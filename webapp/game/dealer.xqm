xquery version "3.0";

(:~
: User: lorenzobrazzi
: Date: 14.12.19
: Time: 13:21
: To change this template use File | Settings | File Templates.
:)

module namespace dealer = "bj/dealer";
import module namespace spieler = "bj/spieler" at "spieler.xqm";
import module namespace s = "bj/s" at "spiel.xqm";

declare variable $spiel:spiele := db:open("spiele")/spiele;
