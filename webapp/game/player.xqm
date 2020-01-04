xquery version "3.0";

module namespace player = "bj/player";
import module namespace chip = "bj/chip" at "chip.xqm";
import module namespace card = "bj/card" at "card.xqm";
import module namespace game = "bj/game" at "game.xqm";

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


(:Der Spieler wählt die Chips im View aus, welche dann hier automatisch konvertiert werden,
 um die Rechnung zu erleichtern:)
declare
%updating
function player:setBet($gameID as xs:string, $bet as element(chips)) {

    let $amount := player:calculateChipsValue($bet)
    let $activePlayer := $player:games/game[id = $gameID]/activePlayer
    let $path := $player:games/game[id = $gameID]/players/player[id = $activePlayer]
    let $activePlayerNewBalance := $path/balance - $amount
    let $maxBet := $player:games/game[id = $gameID]/maxBet
    let $minBet := $player:games/game[id = $gameID]/minBet

    return (
    (: Falls die Balance unter 5 geht dann wird der Spieler entfernt da er dann verloren hat :)
    if ($amount > $path/balance) then (
    (: Error message und ggf neue eingabe :)
    ) else if ($amount > $maxBet) then (
    (: Error message und ggf neue eingabe :)
    ) else if ($amount < $minBet) then (
    (: Error message und ggf neue eingabe :)
    ) else (
        if ($activePlayerNewBalance < 5) then ( delete node $path)
        else (
            replace value of node $path/currentBet with ($path/currentBet + $amount),
            replace value of node $path/balance with$activePlayerNewBalance
        ),
        game:setActivePlayer($gameID)
    )
    )
};


declare
%updating
function player:double($gameID as xs:string) {

    let $activePlayer := $player:games/game[id = $gameID]/activePlayer
    let $currentBet := $player:games/game[id = $gameID]/players/player[id = $activePlayer]/currentBet
    let $path := $player:games/game[id = $gameID]/players/player[id = $activePlayer]/currentBet
    let $newBet := $currentBet * 2
    let $maxBet := $player:games/game[id = $gameID]/maxBet

    (: Vielleicht hier noch schauen das wenn es nicht geht dass ein Error_message irgendwie ausgegeben wird :)
    return (
    (: Falls der vedoppelte Einsatz höher ist als maxBet dann setze einfach den Einsatz auf maxBet :)
    if ($newBet > $maxBet) then (
        replace value of node $path with $maxBet
    ) else (
        replace value of node $path with $newBet
    )
    )
};

declare
%updating
function player:setHit(){

};

(:
Berechnet den Int Value der Chips Objekte um für die anderen Funktionen die Rechnung zu erleichtern.
Der Spieler wählt sozusagen seine zu setzenden Chips einfach aus, und im Backend wird dies automatisch zu einem Int
konvetiert und so auch dann angezeigt.
:)
declare
%private
function player:calculateChipsValue($chips as element(chips)){
    fn:sum(
            for $c in $chips/chip/value
            return $c
    )
};

(:Berechnet den Blattscore des Spielers:)
declare function player:calculateCardValue($gameID as xs:string, $playerID as xs:string){
    let $player := $player:games/game[id = $gameID]/players/player[id = $playerID]
    let $hand := $player/currentHand

    return fn:sum(
            for $c in $hand/value
            return $c
    )
};