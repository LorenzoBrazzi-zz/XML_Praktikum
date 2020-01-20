xquery version "3.0";

module namespace player = "bj/player";
import module namespace chip = "bj/chip" at "chip.xqm";
import module namespace card = "bj/card" at "card.xqm";
import module namespace game = "bj/game" at "game.xqm";

declare variable $player:games := db:open("games")/games;

(: WERTE NUR ZUM TESTEN GEÄNDERT :)
declare function player:createPlayer($id as xs:string, $currentHand as element(cards), $bet as xs:integer,
        $balance as xs:integer, $name as xs:string, $insurance as xs:boolean, $position as xs:integer) as element(player){
    <player>
        <id>{$id}</id>
        <name>{$name}</name>
        <balance>{$balance}</balance>
        <currentHand>
            <cards></cards>
        </currentHand>
        <currentBet>{$bet}</currentBet>
        <insurance>{$insurance}</insurance>
        <position>{$position}</position>
    </player>
};


(:Der Spieler wählt die Chips im View aus, welche dann hier automatisch konvertiert werden,
 um die Rechnung zu erleichtern. Diese Funktion initialisiert den Bet. Darauffolgende bet funktionen arbeiten nur auf Integer!

 --> Für diese Funktion müssen wir die aus der View angeklickten CHips akkumulieren und hier als parameter eingeben <--
        --> Gegebenfalls den Philip ne email schreiben und kurz fragen wie das zu implementieren wäre <--
:)
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
            replace value of node $path/currentBet with xs:integer($amount),
            replace value of node $path/balance with $activePlayerNewBalance
        ),
        game:setActivePlayer($gameID)
    )
    )
};


(:Stand heisst einfach, dass der aktiveSpieler seinen Zug beendet. Demnach wird einfach nur setActivePlayer aufgerufen:)
declare
%updating
function player:stand($gameID as xs:string){
    game:setActivePlayer($gameID)
};

declare
%updating
function player:double($gameID as xs:string) {

    let $activePlayer := $player:games/game[id = $gameID]/activePlayer
    let $currentBet := $player:games/game[id = $gameID]/players/player[id = $activePlayer]/currentBet
    let $newBet := $currentBet * 2
    let $maxBet := $player:games/game[id = $gameID]/maxBet

    (: Vielleicht hier noch schauen das wenn es nicht geht dass ein Error_message irgendwie ausgegeben wird :)
    return (
    (: Falls der vedoppelte Einsatz höher ist als maxBet dann setze einfach den Einsatz auf maxBet :)
    if ($newBet > $maxBet) then (
        replace value of node $currentBet with $maxBet,
        player:hit($gameID)
    ) else (
        replace value of node $currentBet with $newBet,
        player:hit($gameID)
    )
    )
};

declare
%updating
function player:hit($gameID as xs:string){
    let $playerID := $player:games/game[id = $gameID]/activePlayer
    let $score := player:calculateCardValue($gameID)
    (:Wenn Aktiver Spieler mehr als 21 Scorerpunkte hat, dann kann er folglich keine weiteren Karten mehr ziehen, da
er schließlich schon verloren hat. Demnach muss der nöchste activePlayer gesetted werden!:)
    return
        if ($score > 21) then (
        (:Fehlermeldung hinzufügen:)
        game:setActivePlayer($gameID)
        )
        (:Wenn er Hitted, dann erhält der aktiveSpieler ganz einfach ne neue Karte. Jetzt kann er wieder einen Knopf seiner
    Wahlt drücken.:)
        else (
            player:drawCard($gameID)
        )
};

declare
%updating
function player:setInsurance($gameID as xs:string){
    let $playerID := $player:games/game[id = $gameID]/activePlayer
    let $path := $player:games/game[id = $gameID]/players/player[id = $playerID]

    return (
        replace value of node $path/insurance with fn:true()
    )
};

(:
Berechnet den Int Value der Chips Objekte um für die anderen Funktionen die Rechnung zu erleichtern.
Der Spieler wählt sozusagen seine zu setzenden Chips einfach aus, und im Backend wird dies automatisch zu einem Int
konvetiert und so auch dann angezeigt.
:)
declare
%private
function player:calculateChipsValue($chips as element(chips)){
    let $result := fn:sum(
            for $c in $chips/chip/value
            return $c
    )
    return $result
};

(:Berechnet den Blattscore des Spielers:)
declare function player:calculateCardValue($gameID as xs:string){
    let $playerID := $player:games/game[id = $gameID]/activePlayer
    let $hand := $player:games/game[id = $gameID]/players/player[id = $playerID]/currentHand/cards/*

    return fn:sum(
            for $c in $hand/value
            return $c
    )
};

(:Ziehen einer Karte und darauffolgendes entfernen eben dieser aus dem Stack:)
declare
%updating
function player:drawCard($gameID as xs:string) {
    let $playerID := $player:games/game[id = $gameID]/activePlayer
    let $player := $player:games/game[id = $gameID]/players/player[id = $playerID]
    let $hand := $player/currentHand/cards
    let $card := game:drawCard($gameID)

    return (
        insert node $card as first into $hand,
        game:popDeck($gameID)
    )
};

declare
%updating
function player:drawCards($gameID as xs:string, $playerID as xs:string) {
    let $p := $player:games/game[id = $gameID]/players/player[id = $playerID]
    let $hand := $p/currentHand/cards
    let $deck := game:getDeck($gameID)

    for $i in (1, 2)
    return (insert node $deck/card[1] as first into $hand,
    delete node $deck/card[1])
};


declare
%updating
function player:payoutBalanceNormal($gameID as xs:string, $playerID as xs:string){
    let $player := $player:games/game[id = $gameID]/players/player[id = $playerID]
    let $newBalance := $player/balance + $player/currentBet * 2
    return (
        replace value of node $player/balance with $newBalance
    )
};

declare
%updating
function player:payoutBJ($gameID as xs:string, $playerID as xs:string){
    let $player := $player:games/game[id = $gameID]/players/player[id = $playerID]
    let $newBalance := $player/balance + $player/currentBet + xs:integer($player/currentBet * 1.5)
    return (
        replace value of node $player/balance with $newBalance
    )
};

declare
%updating
function player:payoutInsurance($gameID as xs:string, $playerID as xs:string){
    let $player := $player:games/game[id = $gameID]/players/player[id = $playerID]
    let $newBalance := $player/balance + xs:integer($player/currentBet * 0.5)
    return (
        replace value of node $player/balance with $newBalance
    )
};