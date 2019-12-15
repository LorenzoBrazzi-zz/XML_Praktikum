xquery version "3.0";

(:~
: User: lorenzobrazzi
: Date: 14.12.19
: Time: 13:21
: To change this template use File | Settings | File Templates.
:)

module namespace spieler = "spieler.xqm";

declare variable $spiel:instance := db:open("blackjack")/instance
