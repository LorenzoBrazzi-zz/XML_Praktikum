xquery version "3.0";

module namespace controller = "bj/controller";
import module namespace game = "bj/game" at "game.xqm";
import module namespace player = "bj/player" at "player.xqm";
import module namespace dealer = "bj/dealer" at "dealer.xqm";
import module namespace rq = "http://exquery.org/ns/request";


declare variable $controller:landing := doc("../static/index.html");
declare variable $controller:start := doc("../static/startGame.html");
declare variable $controller:staticPath := "../static/XSL/";
declare variable $controller:drawLink := "/bj/draw";

declare
%rest:path("bj/setup")
%updating
%rest:GET
function controller:setup(){
    let $bjModel := doc("db-init/games.xml")
    let $redirectLink := "/bj/startingPage"
    return (db:create("games", $bjModel), update:output(web:redirect($redirectLink)))
};

(: Diese Funktion ruft die Startseite auf :)
declare
%rest:path("/bj")
%rest:GET
function controller:landingPage() {
    $controller:landing
};

declare
%rest:path("/bj/leerTest")
%rest:GET
%updating
function controller:leerTest() {
    let $emptyGame := game:createEmptyGame()
    return (game:insertGame($emptyGame))
};

(: Diese Funktion leitet zur Seite weiter wo man die Balances angeben kann :)
declare
%rest:path("/bj/startingPage")
%rest:GET
%output:method("html")
function controller:startingPage() {
    $controller:start
};

(:Extrahiert Formulardaten aus der Starting Page und leitet diese dem Game Modul weiter, welcher damit ein neues
Spiel generiert, das der Controller letzendlich in die Datenbank hinzufügt:)
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
};

declare
%rest:GET
%output:method("html")
%rest:path("/bj/draw")
function controller:draw(){
    let $game := game:getGame()
    let $xslStylesheet := "trafo.xsl"
    let $title := "BlackJack XML"
    return (controller:generatePage($game, $xslStylesheet, $title))
};

declare function controller:generatePage($game as element(game), $xslStylesheet as xs:string, $title as xs:string){
    let $stylesheet := doc(concat($controller:staticPath, $xslStylesheet))
    let $transformed := xslt:transform($game, $stylesheet)
    return (
        <html>
            <head>
                <title>{$title}</title>
                <link rel="stylesheet" type="text/css" href="../static/stylesheet.css"/>
            </head>
            <body>
                {$transformed}
            </body>
        </html>
    )
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
    update:output(web:redirect($controller:drawLink))
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
%rest:GET
function controller:hit($gameID as xs:string){
    player:hit($gameID),
    update:output(web:redirect($controller:drawLink))
};

(:Wenn der Spieler auf den "double" Button klickt:)
declare
%updating
%rest:path("bj/double/{$gameID}")
%rest:GET
function controller:double($gameID as xs:string){
    player:double($gameID)
};


(:Wenn der Spieler die zu einsetzenden Chips gewählt und anschließend auf den "einsetzen" Button geklickt hat:)
declare
%updating
%rest:path("bj/setBet/{$gameID}/{$chips}")
%rest:GET
function controller:testSetBet($gameID as xs:string, $chips){
    player:setBet($gameID, $chips),
    update:output(web:redirect($controller:drawLink))
};

(:Wenn der Aktive Spieler auf den Insurance Button klickt :)
declare
%updating
%rest:path("bj/setInsurance/{$gameID}")
%rest:GET
function controller:setInsurance($gameID as xs:string){
    player:setInsurance($gameID)
};

declare
%updating
%rest:path("bj/win/{$gameID}/{$playerID}")
%rest:GET
function controller:testWin($gameID as xs:string, $playerID as xs:string){
    player:payoutBalanceNormal($gameID, $playerID)
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
    update:output(web:redirect($controller:drawLink))
};

declare
%rest:path("bj/dealerValueTest/{$gameID}")
%rest:GET
function controller:dealerValueTest($gameID as xs:string){
    dealer:calculateDealerValue($gameID)
};