xquery version "3.0";

(:~
: User: lorenzobrazzi
: Date: 06.12.19
: Time: 08:43
: To change this template use File | Settings | File Templates.
:)

module namespace controller = "game/controller.xqm";
import module namespace spiel = "blackjack/spiel" at "spiel.xqm";
import module namespace spieler = "blackjack/spieler" at "spieler.xqm";
import module namespace dealer = "blackjack/dealer" at "dealer.xqm";
import module namespace db = "http://basex.org/modules/db";

import module namespace db = ""; (:Hier muss noch der Link zur Datenbank hin:)

declare variable $controller:landing := doc("../static/index.html");
declare variable $controller:start := doc("../static/startGame.html");

(: Diese Funktion ruft die Startseite auf :)
declare
%rest:path("/blackjack")
%rest:GET
function controller:landingPage() {
    $controller:landing
};

(: Diese Funktion leitet zur Seite weiter wo man die Balances angeben kann :)
declare
%rest:path("/blackjack/startingPage")
%rest:GET
function controller:startingPage() {
    $controller:start
};

declare
%updating
%rest:path("/blackjack/startGame")
%rest:GET
function c:startGame() {
    (: Hier müssen wir die Namen aus de Datei die bei startingPage abgeschickt wurde holen -> let $user_names :)
};

declare

function () {

};