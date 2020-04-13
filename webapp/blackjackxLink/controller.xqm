xquery version "3.0";

module namespace controller = "bj/controller";
import module namespace game = "bj/game" at "game.xqm";
import module namespace player = "bj/player" at "player.xqm";
import module namespace rq = "http://exquery.org/ns/request";
import module namespace helper = "bj/helper" at "helper.xqm";
import module namespace ws = "bj/websocket" at "websocket.xqm";

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

(:~ Opens up the starting Page with its Lounge
:)
declare
%rest:path("/bj/startingPage")
%rest:GET
%output:method("html")
function controller:startingPage() {
    let $transformed := xslt:transform($controller:games, $controller:lobby)

    let $html := (
        <html>
            <head>
                <title>Lobby</title>
                <link rel="stylesheet" type="text/css" href="../static/stylesheet.css"/>
            </head>
            <body>
                {$transformed}
            </body>
        </html>)
    return $html
};


(:~ Processes the form values entered by player, creates the corresponding Game and finally inserts it into the DB.
    This function also checks for valid values, such as minBet, maxBet not being an empty String.
:)
declare
%updating
%rest:path("/bj/form")
%rest:GET
function controller:startGame() {
    let $minBet := (
        let $valueMinBet := rq:parameter("minBet", 0)
        return (
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

(:~ Confirmation to be ready to play. Used in order to make other players join only in this state, not within playing
    a round.
    @gameID     ID of the current Game
:)
declare
%rest:path("/bj/ready/{$gameID}")
%updating
%rest:POST
function controller:ready($gameID as xs:string) {
    game:setActivePlayer($gameID),
    update:output(web:redirect(fn:concat("/bj/draw/", $gameID)))
};


(:~ Creates a Player with the name that is entered by the client and insert it to the Game.
    @gameID     ID of the current Game
:)
declare
%rest:path("/bj/insertPlayer/{$gameID}")
%updating
%rest:GET
function controller:insertPlayer($gameID as xs:string) {
    let $game := $controller:games/game[id = $gameID]
    let $numPlayers := fn:count($game/players/player)
    let $name := rq:parameter("name", "")
    let $player := player:createPlayer(0, 10000, $name, fn:false(), $numPlayers + 1)
    let $prot :=
        <event>
            <time>{helper:currentTime()}</time>
            <type>protocol</type>
            <text>{$player/name/text()} ist dem Spiel beigetreten!</text>
        </event>

    return (
        if (fn:count($game/players/player) = 0) then (replace value of node $game/activePlayer with $player/id/text()) else (),
        insert node $player into $game/players,
        insert node $prot into $game/events,
        update:output(web:redirect(fn:concat("/bj/join/", $gameID, "/", $player/id)))
    )
};

(:~ Creates the HTML and WebSocket for the client to stay subscribed to the game Channel.
    @gameID     ID of the current Game
    @playerID   ID of the player
:)
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


(:~ Visually draws the state of the Game Table.
    @gameID     ID of the current Game
:)
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
            (:Multiple stylesheets needed, because the inactive Players should not see the buttons on the screen:)
            if ($playerID = $activePlayerID)
            then (controller:generatePage($game, $activeXslStylesheet))
            else (controller:generatePage($game, $xslStylesheet))
            )
        return (ws:send($transformedGame, $destinationPath))
    )
};

declare function controller:generatePage($game as element(game), $xslStylesheet as xs:string){
    let $stylesheet := doc(concat($controller:staticPath, $xslStylesheet))
    let $transformed := xslt:transform($game, $stylesheet)
    return $transformed
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
%rest:path("bj/hit/{$gameID}")
%rest:POST
function controller:hit($gameID as xs:string){
    player:hit($gameID),
    update:output(web:redirect(fn:concat("/bj/draw/", $gameID)))
};

declare
%updating
%rest:path("bj/double/{$gameID}")
%rest:POST
function controller:double($gameID as xs:string){
    player:double($gameID),
    update:output(web:redirect(fn:concat("/bj/draw/", $gameID)))
};

declare
%updating
%rest:path("bj/stand/{$gameID}")
%rest:POST
function controller:stand($gameID as xs:string){
    player:stand($gameID),
    update:output(web:redirect(fn:concat("/bj/draw/", $gameID)))
};


(:~ Reads the entered Bet of the player and checks if the value is valid.
    If not then an error message is printed and they have to enter again,
    else the function in the player module is called and finally the resulting game is drawn.
:)
declare
%updating
%rest:path("bj/setBet/{$gameID}")
%rest:POST
function controller:setBet($gameID as xs:string){
    let $bet := rq:parameter("bet", "")
    let $minBet := $controller:games/game[id = $gameID]/minBet
    let $maxBet := $controller:games/game[id = $gameID]/maxBet
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

declare
%updating
%rest:path("bj/setInsurance/{$gameID}")
%rest:POST
function controller:setInsurance($gameID as xs:string){
    player:setInsurance($gameID),
    update:output(web:redirect(fn:concat("/bj/draw/", $gameID)))
};


declare
%updating
%rest:path("bj/continue/{$gameID}/{$continue}")
%rest:POST
function controller:continue($gameID as xs:string, $continue as xs:boolean) {
    player:setContinue($gameID, $continue),
    update:output(web:redirect(fn:concat("/bj/draw/", $gameID)))
};