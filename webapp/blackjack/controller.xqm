xquery version "3.0";

module namespace controller = "bj/controller";
import module namespace game = "bj/game" at "game.xqm";
import module namespace player = "bj/player" at "player.xqm";
import module namespace dealer = "bj/dealer" at "dealer.xqm";
import module namespace rq = "http://exquery.org/ns/request";
import module namespace helper = "bj/helper" at "helper.xqm";
import module namespace ws = "bj/websocket" at "websocket.xqm";
import module namespace websocket = "http://basex.org/modules/Ws";
declare variable $controller:games := db:open("games")/games;
declare variable $controller:lobby := doc("../static/lobby.xsl");
declare variable $controller:staticPath := "../static/XSL/";

declare
%rest:path("bj/setup")
%updating
%output:method("html")
%rest:GET
function controller:setup(){
    let $bjModel := doc("db-init/games.xml")
    let $redirectLink := "/bj/startingPage"
    return (db:create("games", $bjModel), update:output(web:redirect($redirectLink)))
};

(: Diese Funktion leitet zur Seite weiter wo man die Balances angeben kann :)
declare
%rest:path("/bj/startingPage")
%rest:GET
%output:method("html")
function controller:startingPage() {
    let $name := rq:parameter("name", "")
    let $transformed := xslt:transform($controller:games, $controller:lobby)

    let $html := (
        <html>
            <head>
                <title>Name</title>
                <link rel="stylesheet" type="text/css" href="../static/stylesheet.css"/>
            </head>
            <body>
                {$transformed}
            </body>
        </html>)
    return $html
};

(:Extrahiert Formulardaten aus der Starting Page und leitet diese dem Game Modul weiter, welcher damit ein neues
Spiel generiert, das der Controller letzendlich in die Datenbank hinzufügt
declare
%updating
%rest:path("/bj/form")
%rest:GET
function controller:startGame() {
    let $minBet := rq:parameter("minBet", 0)
    let $maxBet := rq:parameter("maxBet", 100)

    let $names := (for $i in (1, 2, 3, 4, 5)
    return (
        rq:parameter(fn:concat("inputname", $i), "")
    ))


    let $balances := (for $i in (1, 2, 3, 4, 5)
    return (
        rq:parameter(fn:concat("inputbalance", $i), "")
    ))

    (:Filter Balances raus, die mit einem leeren Namen assoziiert sind:)

    let $actualBalances := (for $i in (1, 2, 3, 4, 5)
    where $balances[$i] != "" and $names[$i] != ""
    return $balances[$i])

    let $actualNames := (for $i in (1, 2, 3, 4, 5)
    where $balances[$i] != "" and $names[$i] != ""
    return $names[$i])


    let $game := game:createGame($actualNames, $actualBalances, $minBet, $maxBet)
    return (
        game:insertGame($game),
        update:output(web:redirect($controller:drawLink))
    )
};:)

declare
%updating
%rest:path("/bj/form")
%rest:GET
function controller:startGame() {
    let $minBet := (
        let $valueMinBet := rq:parameter("minBet", 0)
        return(
            if ($valueMinBet = "") then 10 else $valueMinBet
        )
    )
    let $maxBet := (
        let $valueMaxBet := rq:parameter("maxBet", 100)
        return (
            if ($valueMaxBet = "") then 100 else $valueMaxBet
        )
    )

    let $game := game:createGame($minBet, $maxBet)
    let $name := rq:parameter("name", "")
    let $player := player:createPlayer(0, 10000, $name, fn:false(), 1)
    let $endGame := (
        copy $g := $game
        modify (
            insert node $player into $g/players,
            replace value of node $g/activePlayer with $player/id/text()
        )
        return $g
    )
    return (
        if ($minBet > $maxBet) then (update:output(web:redirect("/bj/startingPage")))
        else if ($minBet < 1 or $maxBet < 1) then (update:output(web:redirect("/bj/startingPage")))
        else (
            game:insertGame($endGame),
            update:output(web:redirect(fn:concat("/bj/join/", $game/id/text(), "/", $player/id/text())))
        )
    )
};

declare
%rest:path("/bj/ready/{$gameID}")
%updating
%rest:POST
function controller:ready($gameID as xs:string) {
(:replace value of node $game:games/game[id = $gameID]/available with fn:count($controller:games/game[id = $gameID]/players/player) < 5,:)
    game:setActivePlayer($gameID),
    update:output(web:redirect(fn:concat("/bj/draw/", $gameID)))
};

declare
%rest:path("/bj/insertPlayer/{$gameID}")
%updating
%rest:GET
function controller:insertPlayer($gameID as xs:string) {
    let $game := $controller:games/game[id = $gameID]
    let $numPlayers := fn:count($game/players/player)
    let $name := rq:parameter("name", "")
    let $player := player:createPlayer(0, 10000, $name, fn:false(), $numPlayers + 1)

    return (
        if (fn:count($game/players/player) = 0) then (replace value of node $game/activePlayer with $player/id/text()) else (),
        insert node $player into $game/players,
        update:output(web:redirect(fn:concat("/bj/join/", $gameID, "/", $player/id)))
    )
};

declare
%rest:GET
%output:method("html")
%rest:path("/bj/join/{$gameID}/{$playerID}")
function controller:join($gameID as xs:string, $playerID as xs:string){
    let $hostname := rq:hostname()
    let $port := rq:port()
    let $address := concat($hostname, ":", $port)
    let $websocketURL := concat("ws://", $address, "/ws/bj")
    let $getURL := concat("http://", $address, "/bj/draw/", $gameID)
    let $subscription := concat("/bj/", $gameID, "/", $playerID)
    let $html :=
        <html>
            <head>
                <title>BlackJack</title>
                <script src="/static/JS/jquery-3.2.1.min.js"></script>
                <script src="/static/JS/stomp.js"></script>
                <script src="/static/JS/ws-element.js"></script>
                <link rel="stylesheet" type="text/css" href="/static/stylesheet.css"/>
            </head>
            <body>
                <ws-stream id="bj" url="{$websocketURL}" subscription="{$subscription}" geturl="{$getURL}"/>
            </body>
        </html>
    return $html
};

declare
%rest:GET
%rest:path("/bj/draw/{$gameID}")
function controller:draw($gameID as xs:string){
    let $game := game:getGame($gameID)
    let $activePlayerID := $game/activePlayer/text()
    let $xslStylesheet := "trafo.xsl"
    let $activeXslStylesheet := "trafo_active.xsl"
    let $title := "BlackJack XML"
    let $wsIDs := ws:getIDs()
    return (
        for $id in $wsIDs
        where ws:get($id, "applicationID") = "bj"
        let $playerID := ws:get($id, "playerID")
        let $destinationPath := concat("/bj/", $gameID, "/", $playerID)
        let $transformedGame :=
            (
                if ($playerID = $activePlayerID)
                then (controller:generatePage($game, $activeXslStylesheet, $title))
                else (controller:generatePage($game, $xslStylesheet, $title))
            )
        return (ws:send($transformedGame, $destinationPath))
    )
(:)return (controller:generatePage($game, $xslStylesheet, $title)):)
};

declare function controller:generatePage($game as element(game), $xslStylesheet as xs:string, $title as xs:string){
    let $stylesheet := doc(concat($controller:staticPath, $xslStylesheet))
    let $transformed := xslt:transform($game, $stylesheet)
    let $state := $game/state/text()
    let $gameID := $game/id/text()
    return $transformed
};

(:Löscht das Spiel mit ID gameID:)
declare
%updating
%rest:path("bj/delete/{$gameID}")
%rest:GET
function controller:deleteGame($gameID as xs:string){
    game:deleteGame($gameID)
};

declare
%updating
%rest:path("bj/setActivePlayer/{$gameID}")
%rest:GET
function controller:setActivePlayer($gameID as xs:string) {
    game:setActivePlayer($gameID),
    update:output(web:redirect(fn:concat("/bj/draw/", $gameID)))
};

declare
%updating
%rest:path("bj/shuffle/{$gameID}")
%rest:GET
function controller:shuffle($gameID as xs:string){
    game:setShuffledDeck($gameID)
};

declare
%updating
%rest:path("bj/hit/{$gameID}")
%rest:POST
function controller:hit($gameID as xs:string){
    player:hit($gameID),
    update:output(web:redirect(fn:concat("/bj/draw/", $gameID)))
};

(:Wenn der Spieler auf den "double" Button klickt:)
declare
%updating
%rest:path("bj/double/{$gameID}")
%rest:POST
function controller:double($gameID as xs:string){
    player:double($gameID),
    update:output(web:redirect(fn:concat("/bj/draw/", $gameID)))
};

(:Wenn der Spieler auf den "stand" Button klickt:)
declare
%updating
%rest:path("bj/stand/{$gameID}")
%rest:POST
function controller:stand($gameID as xs:string){
    player:stand($gameID),
    update:output(web:redirect(fn:concat("/bj/draw/", $gameID)))
};


(:Wenn der Spieler die zu einsetzenden Chips gewählt und anschließend auf den "einsetzen" Button geklickt hat:)
declare
%updating
%rest:path("bj/setBet/{$gameID}")
%rest:POST
function controller:setBet($gameID as xs:string){
    let $bet := rq:parameter("bet", "")
    let $minBet := $controller:games/game[id = $gameID]/minBet
    let $maxBet := $controller:games/game[id = $gameID]/maxBet
    let $activePlayerID := $controller:games/game[id = $gameID]/activePlayer/text()
    let $player := $controller:games/game[id = $gameID]/players/player[id = $activePlayerID]
    let $err := <event>
        <time>{helper:currentTime()}</time>
        <type>error</type>
        <text>Fehler beim Einsatz!!! Der Einsatz muss mindestens {$minBet}, darf maximal {$maxBet} oder
            deinen aktuellen Kontostand nicht übersteigen!</text>
    </event>

    return (
        if ($bet = "") then (
            insert node $err as first into $controller:games/game[id = $gameID]/events,
            update:output(web:redirect(fn:concat("/bj/draw/", $gameID)))
        ) else (
            player:setBet($gameID, $bet),
            update:output(web:redirect(fn:concat("/bj/draw/", $gameID))))
    )
};

(:Wenn der Aktive Spieler auf den Insurance Button klickt :)
declare
%updating
%rest:path("bj/setInsurance/{$gameID}")
%rest:POST
function controller:setInsurance($gameID as xs:string){
    let $dummy := 0
    return (
        player:setInsurance($gameID),
        update:output(web:redirect(fn:concat("/bj/draw/", $gameID))))
};

declare
%rest:path("bj/test/{$gameID}")
%rest:GET
function controller:test($gameID as xs:string){
    let $g := dealer:play($gameID)
    let $gg := game:setResult($g)
    let $result := game:evaluateRound($gg)
    return $result
};

declare
%updating
%rest:path("bj/continue/{$gameID}/{$continue}")
%rest:POST
function controller:continue($gameID as xs:string, $continue as xs:boolean) {
    player:setContinue($gameID, $continue),
    update:output(web:redirect(fn:concat("/bj/draw/", $gameID)))
};

(:https://www.youtube.com/watch?v=dbxBJWQPqZY hat gute buttons zum kopieren, kartensummen auch ganz cooles feature,
win lose draw Symbole auch implementieren wie im Video,
Status Text der das Spielgeschehen beschreibt:)

(:Wenn Spiel startet, werden Karten automatisch ausgeteilt:)
declare
%updating
%rest:path("bj/dealOut/{$gameID}")
%rest:GET
function controller:testDealOut($gameID as xs:string){
    controller:shuffle($gameID),
    game:dealOutCards($gameID),
    update:output(web:redirect(fn:concat("/bj/draw/", $gameID)))
};

declare
%rest:path("bj/dealerValueTest/{$gameID}")
%rest:GET
function controller:dealerValueTest($gameID as xs:string){
    dealer:calculateCardValue($gameID)
};


declare
%rest:path("bj/dealerDrawTest/{$gameID}")
%rest:GET
function controller:dealerDrawTest($gameID){
    <div>
        <div>{dealer:newCardValue(game:getDeck($gameID)/card[1], dealer:calculateCardValue($gameID))}</div>
        <div>{dealer:calculateCardValue($gameID)}</div>
        <div>{dealer:numberofDrawingCard($gameID, dealer:calculateCardValue($gameID), 0)}</div>
    </div>
};