xquery version "3.0";

module namespace controller = "xLinkbj/controller";
import module namespace game = "xLinkbj/game" at "game.xqm";
import module namespace player = "xLinkbj/player" at "player.xqm";
import module namespace rq = "http://exquery.org/ns/request";
import module namespace helper = "xLinkbj/helper" at "helper.xqm";
import module namespace ws = "xLinkbj/websocket" at "websocket.xqm";

declare variable $controller:games := db:open("games")/games;
declare variable $controller:lobby := doc("../static/xLinkBlackjack/lobby.xsl");
declare variable $controller:staticPath := "../static/xLinkBlackjack/";

declare
%rest:path("xLinkbj/setup")
%updating
%output:method("html")
%rest:GET
function controller:setup(){
    let $xLinkbjModel := doc("db-init/games.xml")
    let $redirectLink := "/xLinkbj/startingPage"
    return (db:create("games", $xLinkbjModel), update:output(web:redirect($redirectLink)))
};

(:~ Opens up the starting Page with its Lounge
:)
declare
%rest:path("/xLinkbj/startingPage")
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
%rest:path("/xLinkbj/form")
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
        if ($minBet > $maxBet) then (update:output(web:redirect("/xLinkbj/startingPage")))
        else if ($minBet < 1 or $maxBet < 1) then (update:output(web:redirect("/xLinkbj/startingPage")))
        else (
                game:insertGame($endGame),
                update:output(web:redirect(fn:concat("/xLinkbj/join/", $game/id/text(), "/", $player/id/text())))
            )
    )
};

(:~ Confirmation to be ready to play. Used in order to make other players join only in this state, not within playing
    a round.
    @gameID     ID of the current Game
:)
declare
%rest:path("/xLinkbj/ready/{$gameID}")
%updating
%rest:POST
function controller:ready($gameID as xs:string) {
    game:setActivePlayer($gameID),
    update:output(web:redirect(fn:concat("/xLinkbj/draw/", $gameID)))
};


(:~ Creates a Player with the name that is entered by the client and insert it to the Game.
    @gameID     ID of the current Game
:)
declare
%rest:path("/xLinkbj/insertPlayer/{$gameID}")
%updating
%rest:GET
function controller:insertPlayer($gameID as xs:string) {
    let $game := $controller:games/game[id = $gameID]
    let $numPlayers := fn:count($game/players/player)
    let $name := rq:parameter("name", "")
    let $player := player:createPlayer(0, 10000, $name, fn:false(), $numPlayers + 1)
    let $prot :=
        <notification>
            <time>{helper:currentTime()}</time>
            <type>protocol</type>
            <text>{$player/name/text()} ist dem Spiel beigetreten!</text>
        </notification>

    return (
        if (fn:count($game/players/player) = 0) then (replace value of node $game/activePlayer with $player/id/text()) else (),
        insert node $player into $game/players,
        insert node $prot as first into $game/notifications,
        update:output(web:redirect(fn:concat("/xLinkbj/join/", $gameID, "/", $player/id)))
    )
};

(:~ Creates the HTML and WebSocket for the client to stay subscribed to the game Channel.
    @gameID     ID of the current Game
    @playerID   ID of the player
:)
declare
%rest:GET
%output:method("html")
%rest:path("/xLinkbj/join/{$gameID}/{$playerID}")
function controller:join($gameID as xs:string, $playerID as xs:string){
    let $hostname := rq:hostname()
    let $port := rq:port()
    let $address := concat($hostname, ":", $port)
    let $websocketURL := concat("ws://", $address, "/ws/xLinkbj")
    let $getURL := concat("http://", $address, "/xLinkbj/draw/", $gameID)
    let $subscription := concat("/xLinkbj/", $gameID, "/", $playerID)
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
                <ws-stream id="xLinkbj" url="{$websocketURL}" subscription="{$subscription}" geturl="{$getURL}"/>
            </body>
        </html>
    return $html
};


(:~ Visually draws the state of the Game Table.
    @gameID     ID of the current Game
:)
declare
%rest:GET
%rest:path("/xLinkbj/draw/{$gameID}")
function controller:draw($gameID as xs:string){
    let $game := game:getGame($gameID)
    let $activePlayerID := $game/activePlayer/text()
    let $xslStylesheet := "trafo.xsl"
    let $activeXslStylesheet := "trafo_active.xsl"
    let $title := "BlackJack XML"
    let $wsIDs := ws:getIDs()
    return (
        for $id in $wsIDs
        where ws:get($id, "applicationID") = "xLinkbj"
        let $playerID := ws:get($id, "playerID")
        let $destinationPath := concat("/xLinkbj/", $gameID, "/", $playerID)
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
%rest:path("xLinkbj/setActivePlayer/{$gameID}")
%rest:GET
function controller:setActivePlayer($gameID as xs:string) {
    game:setActivePlayer($gameID),
    update:output(web:redirect(fn:concat("/xLinkbj/draw/", $gameID)))
};


declare
%updating
%rest:path("xLinkbj/hit/{$gameID}")
%rest:POST
function controller:hit($gameID as xs:string){
    player:hit($gameID),
    update:output(web:redirect(fn:concat("/xLinkbj/draw/", $gameID)))
};

declare
%updating
%rest:path("xLinkbj/double/{$gameID}")
%rest:POST
function controller:double($gameID as xs:string){
    player:double($gameID),
    update:output(web:redirect(fn:concat("/xLinkbj/draw/", $gameID)))
};

declare
%updating
%rest:path("xLinkbj/stand/{$gameID}")
%rest:POST
function controller:stand($gameID as xs:string){
    player:stand($gameID),
    update:output(web:redirect(fn:concat("/xLinkbj/draw/", $gameID)))
};


(:~ Reads the entered Bet of the player and checks if the value is valid.
    If not then an error message is printed and they have to enter again,
    else the function in the player module is called and finally the resulting game is drawn.
:)
declare
%updating
%rest:path("xLinkbj/setBet/{$gameID}")
%rest:POST
function controller:setBet($gameID as xs:string){
    let $bet := rq:parameter("bet", "")
    let $minBet := $controller:games/game[id = $gameID]/minBet
    let $maxBet := $controller:games/game[id = $gameID]/maxBet
    let $err := <notification>
        <time>{helper:currentTime()}</time>
        <type>error</type>
        <text>Fehler beim Einsatz!!! Der Einsatz muss mindestens {$minBet}, darf maximal {$maxBet} oder
            deinen aktuellen Kontostand nicht übersteigen!</text>
    </notification>

    return (
        if ($bet = "") then (
            insert node $err as first into $controller:games/game[id = $gameID]/notifications,
            update:output(web:redirect(fn:concat("/xLinkbj/draw/", $gameID)))
        ) else (
            player:setBet($gameID, $bet),
            update:output(web:redirect(fn:concat("/xLinkbj/draw/", $gameID))))
    )
};

declare
%updating
%rest:path("xLinkbj/setInsurance/{$gameID}")
%rest:POST
function controller:setInsurance($gameID as xs:string){
    player:setInsurance($gameID),
    update:output(web:redirect(fn:concat("/xLinkbj/draw/", $gameID)))
};


declare
%updating
%rest:path("xLinkbj/continue/{$gameID}/{$continue}")
%rest:POST
function controller:continue($gameID as xs:string, $continue as xs:boolean) {
    player:setContinue($gameID, $continue),
    update:output(web:redirect(fn:concat("/xLinkbj/draw/", $gameID)))
};