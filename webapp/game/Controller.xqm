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


declare variable $controller:landing := doc("../static/index.html");
declare variable $controller:start := doc("../static/startGame.html");

declare
%rest:path("bj/setup")
%updating
%rest:GET
function controller:setup(){
    let $bjModel := doc("db-init/spiele.xml")
    let $redirectLink := "/bj/leerTest"
    return(db:create("spiele",$bjModel),update:output(web:redirect($redirectLink)))
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
function controller:leerTest() {
    let $emptyGame := game:createEmptyGame()
    return(game:insertGame)
};

(: Diese Funktion leitet zur Seite weiter wo man die Balances angeben kann :)
(:declare
%rest:path("/bj/startingPage")
%rest:GET
function controller:startingPage() {
    $controller:start
};:)

declare
%updating
%rest:path("/bj/startGame")
%rest:GET
function controller:startGame() {

    (: Hier müssen wir die Namen aus de Datei die bei startingPage abgeschickt wurde holen -> let $user_names :)
};
