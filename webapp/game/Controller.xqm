xquery version "3.0";

(:~
: User: lorenzobrazzi
: Date: 06.12.19
: Time: 08:43
: To change this template use File | Settings | File Templates.
:)

module namespace controller = "bj/controller";
import module namespace game = "bj/game" at "spiel.xqm";
import module namespace player = "bj/spieler" at "spieler.xqm";
import module namespace dealer = "bj/dealer" at "dealer.xqm";
<<<<<<< HEAD
=======
import module namespace rq = "http://exquery.org/ns/request";

>>>>>>> 1c6c1766d0d9b57fe103d588f79fed3521c9ac2c

declare variable $controller:landing := doc("../static/index.html");
declare variable $controller:start := doc("../static/startGame.html");

declare
%rest:path("bj/setup")
%updating
%rest:GET
function controller:setup(){
    let $bjModel := doc("db-init/games.xml")
    let $redirectLink := "/bj/startingPage"
    return(db:create("games",$bjModel),update:output(web:redirect($redirectLink)))
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
    return(game:insertGame($emptyGame))
};

(: Diese Funktion leitet zur Seite weiter wo man die Balances angeben kann :)
declare
%rest:path("/bj/startingPage")
%rest:GET
%output:method("html")
function controller:startingPage() {
    $controller:start
};

declare
%updating
%rest:path("/bj/form")
%rest:GET
function controller:startGame() {
    let $minBet := rq:parameter("minBet", "")
    let $maxBet := rq:parameter("maxBet", "")
    let $names := (for $i in (1,2,3,4,5)
                    return(
                        rq:parameter("inputname{i}", "")
                    ))
    let $balances := (for $i in (1,2,3,4,5)
                        return(
                            rq:parameter("inputbalance{i}", "")
                        ))
    let $game := game:createGame($names, $balances, $minBet, $maxBet)
    return(
        game:insertGame($game)
    )
};
