xquery version "3.0";

(:~
: User: lorenzobrazzi
: Date: 14.12.19
: Time: 13:21
: To change this template use File | Settings | File Templates.
:)

module namespace player = "bj/player";
import module namespace chip = "bj/chip" at "chip.xqm";
import module namespace card = "bj/card" at "card.xqm";

declare variable $player:games := db:open("games")/games;

declare function player:createPlayer($id as xs:string, $currentHand as element(cards), $currentBet as element(chips),
        $balance as xs:integer, $name as xs:string, $insurance as xs:boolean, $position as xs:integer) as element(player){
    <player>
        <id>{$id}</id>
        <name>{$name}</name>
        <balance>{$balance}</balance>
        <currentHand>{$currentHand}</currentHand>
        <currentBet>{$currentBet}</currentBet>
        <insurance>{$insurance}</insurance>
        <position>{$position}</position>
    </player>
};
