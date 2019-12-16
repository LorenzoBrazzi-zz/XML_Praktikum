xquery version "3.0";

(:~
: User: lorenzobrazzi
: Date: 14.12.19
: Time: 13:21
: To change this template use File | Settings | File Templates.
:)

module namespace spiel = "bj/spiel";
import module namespace spieler = "bj/spieler" at "spieler.xqm";
import module namespace dealer = "bj/dealer" at "dealer.xqm";

declare variable $spiel:spiele := db:open("bj")/spiele;

declare function spiel:getSpiel() {
    $spiel:spiele
};

