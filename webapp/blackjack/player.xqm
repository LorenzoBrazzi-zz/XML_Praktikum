xquery version "3.0";

module namespace player = "bj/player";
import module namespace chip = "bj/chip" at "chip.xqm";
import module namespace card = "bj/card" at "card.xqm";
import module namespace game = "bj/game" at "game.xqm";
import module namespace helper = "bj/helper" at "helper.xqm";
import module namespace dealer = "bj/dealer" at "dealer.xqm";
declare namespace uuid = "java:java.util.UUID";

declare variable $player:games := db:open("games")/games;

(: WERTE NUR ZUM TESTEN GEÄNDERT :)
declare function player:createPlayer($bet as xs:integer,
        $balance as xs:integer, $name as xs:string, $insurance as xs:boolean, $position as xs:integer) as element(player){
    <player>
        <id>{xs:string(uuid:randomUUID())}</id>
        <name>{$name}</name>
        <balance>{$balance}</balance>
        <currentHand>
            <score></score>
            <cards></cards>
        </currentHand>
        <currentBet>{$bet}</currentBet>
        <insurance>{$insurance}</insurance>
        <position>{$position}</position>
        <won bj="false" draw="false">{fn:false()}</won>
    </player>
};


(:Der Spieler wählt die Chips im View aus, welche dann hier automatisch konvertiert werden,
 um die Rechnung zu erleichtern. Diese Funktion initialisiert den Bet. Darauffolgende bet funktionen arbeiten nur auf Integer!

 --> Für diese Funktion müssen wir die aus der View angeklickten CHips akkumulieren und hier als parameter eingeben <--
        --> Gegebenfalls den Philip ne email schreiben und kurz fragen wie das zu implementieren wäre <--
:)
declare
%updating
function player:setBet($gameID as xs:string, $bet as xs:integer) {

    let $activePlayer := $player:games/game[id = $gameID]/activePlayer
    let $path := $player:games/game[id = $gameID]/players/player[id = $activePlayer]
    let $activePlayerNewBalance := $path/balance - $bet
    let $maxBet := $player:games/game[id = $gameID]/maxBet
    let $minBet := $player:games/game[id = $gameID]/minBet
    let $err := <event>
        <time>{helper:currentTime()}</time>
        <type>error</type>
        <text>Fehler beim Einsatz!!! Der Einsatz muss mindestens {$minBet}, darf maximal {$maxBet} oder
            deinen aktuellen Kontostand nicht übersteigen!</text>
    </event>

    return (
    (: Falls die Balance unter 5 geht dann wird der Spieler entfernt da er dann verloren hat :)
    if ($bet > $path/balance or $bet > $maxBet or $bet < $minBet) then (
    (: Error message und ggf neue eingabe :)
    insert node $err as first into $player:games/game[id = $gameID]/events
    )
    else (
        if ($activePlayerNewBalance <= 0) then ( delete node $path)
        else (
            replace value of node $path/currentBet with xs:integer($bet),
            replace value of node $path/balance with $activePlayerNewBalance
        ),
        if (game:isRoundCompleted($gameID)) then (game:changeState($gameID, 'play'), game:dealOutCards($gameID), game:setActivePlayer($gameID)) else (game:setActivePlayer($gameID))
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
    let $p := $player:games/game[id = $gameID]/players/player[id = $activePlayer]
    let $currentBet := $p/currentBet
    let $newBet := $currentBet * 2
    let $maxBet := $player:games/game[id = $gameID]/maxBet
    let $err := <event>
        <time>{helper:currentTime()}</time>
        <type>error</type>
        <text>Fehler beim Einsatz!!! Der Einsatz darf
            deinen aktuellen Kontostand/Maximaleinsatz nicht übersteigen! Maximaleinsatz/Kontomaximum wird ausgewählt</text>
    </event>
    return (
    (: Falls der vedoppelte Einsatz höher ist als maxBet dann setze einfach den Einsatz auf maxBet :)
    if ($newBet > $p/balance) then (
        insert node $err as first into $player:games/game[id = $gameID]/events,
        replace value of node $currentBet with $p/balance + $currentBet,
        replace value of node $p/balance with 0,
        player:hit($gameID)
    )
    else if ($newBet > $maxBet) then (
        insert node $err as first into $player:games/game[id = $gameID]/events,
        replace value of node $currentBet with $maxBet,
        replace value of node $p/balance with $p/balance - $maxBet,
        player:hit($gameID)
    )
    else (
            replace value of node $currentBet with $newBet,
            replace value of node $p/balance with $p/balance - $currentBet,
            player:hit($gameID)
        )
    )
};

declare
%updating
function player:hit($gameID as xs:string){
    let $playerID := $player:games/game[id = $gameID]/activePlayer
    let $name := $player:games/game[id = $gameID]/players/player[id = $playerID]/name/text()
    let $score := player:calculateCardValuePlayers($gameID, $playerID)
    let $err := <event>
        <time>{helper:currentTime()}</time>
        <type>error</type>
        <text>An 21 leider vorbeigeschosse :((</text>
    </event>
    let $prot := <event>
        <time>{helper:currentTime()}</time>
        <type>protocol</type>
        <text>{$name} hat gehittet!</text>
    </event>
    let $win := <event>
        <time>{helper:currentTime()}</time>
        <type>protocol</type>
        <text>{$name} hat 21 erreicht!</text>
    </event>
    (:Wenn Aktiver Spieler mehr als 21 Scorerpunkte hat, dann kann er folglich keine weiteren Karten mehr ziehen, da
er schließlich schon verloren hat. Demnach muss der nöchste activePlayer gesetted werden!:)
    return (
        if ($score > 21) then (
            insert node $err as first into $player:games/game[id = $gameID]/events,
            game:setActivePlayer($gameID)
        )
        else if ($score = 21) then (
            insert node $win as first into $player:games/game[id = $gameID]/events
        )
        (:Wenn er Hitted, dann erhält der aktiveSpieler ganz einfach ne neue Karte. Jetzt kann er wieder einen Knopf seiner
    Wahl drücken.:)
        else (
                insert node $prot as first into $player:games/game[id = $gameID]/events,
                player:drawCard($gameID)
            ))
};

declare
%updating
function player:setInsurance($gameID as xs:string){
    let $playerID := $player:games/game[id = $gameID]/activePlayer
    let $player := $player:games/game[id = $gameID]/players/player[id = $playerID]
    let $prot :=
        <event>
            <type>protocol</type>
            <time>{helper:currentTime()}</time>
            <text>{$player/name/text()} hat Insurance gekauft</text>
        </event>

    return (
        replace value of node $player/insurance with fn:true(),
        insert node $prot as first into $player:games/game[id = $gameID]/events
    )
};

declare function player:calculateCardValuePlayers($gameID as xs:string, $playerID as xs:string) as xs:integer {
    let $player := $player:games/game[id = $gameID]/players/player[id = $playerID]

    let $amoutOfAces := (
        sum(
                for $c in $player/currentHand/cards/card
                return (
                    if ($c/value = 'A') then 1 else 0
                ))
    )

    let $valueOfCardsWitoutAces := (
        sum(
                for $c in $player/currentHand/cards/card
                return (
                    if (($c/value = 'B') or ($c/value = 'D') or ($c/value = 'K')) then 10
                    else if ($c/value = 'A') then 0
                    else ($c/value)
                )
        ))

    let $value := fn:fold-left((1 to $amoutOfAces), $valueOfCardsWitoutAces, function($acc, $c) {
        if ($acc + 11 > 21) then ($acc + 1) else ($acc + 11)
    })
    return (
        xs:integer($value)
    )
};

(:Ziehen einer Karte und darauffolgendes entfernen eben dieser aus dem Stack:)
declare
%updating
function player:drawCard($gameID as xs:string) {
    let $playerID := $player:games/game[id = $gameID]/activePlayer
    let $player := $player:games/game[id = $gameID]/players/player[id = $playerID]
    let $hand := $player/currentHand/cards
    let $card := game:drawCard($gameID, 1)

    return (
        insert node $card into $hand,
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
function player:setContinue($gameID as xs:string, $continue as xs:boolean){
    let $activePlayerID := $player:games/game[id = $gameID]/activePlayer
    let $player := $player:games/game[id = $gameID]/players/player[id = $activePlayerID]
    return (
        game:evaluateRound($gameID, $activePlayerID),
        if ($continue) then () else (delete node $player),
        game:setActivePlayer($gameID)
    )

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

declare
%updating
function player:payoutDraw($gameID as xs:string, $playerID as xs:string){
    let $player := $player:games/game[id = $gameID]/players/player[id = $playerID]
    let $newBalance := $player/balance + xs:integer($player/currentBet)
    return (
        replace value of node $player/balance with $newBalance
    )
};

declare
%updating
function player:setResult($gameID as xs:string) {
    let $players := $game:games/game[id = $gameID]/players
    let $activePlayer := $player:games/game[id = $gameID]/activePlayer
    let $p := $player:games/game[id = $gameID]/players/player[id = $activePlayer]
    let $dealerCardsValue := dealer:calculateCardValue($gameID)

    return (
        (: Falls der Dealer einen Blackjack hat, verlieren automatisch alle Spieler die keinen Blackjack haben:)
        if (game:dealerHasBJ($gameID)) then (
            let $numberOfCards := fn:count($p/currentHand/cards/card)
            let $playerCardValue := player:calculateCardValuePlayers($gameID, $p/id/text())
            return (
                if (fn:not(($playerCardValue = 21) and ($numberOfCards = 2))) then (
                    replace value of node $p/won with fn:false()
                )
                else (
                    replace node $p/won with (
                        <won bj="true" draw="true">{fn:true()}</won>
                    )
                ))
        (:Falls der Dealer keinen Blackjack hat:)
        ) else (
            let $numberOfCards := fn:count($p/currentHand/cards/card)
            let $playerCardValue := player:calculateCardValuePlayers($gameID, $p/id/text())
            return (
            (:Spieler hat einen Blackjack, Sieg weil die Funktionsstelle nur erreicht, wenn der Dealer kein Blackjack:)
            if (($playerCardValue = 21) and ($numberOfCards = 2)) then (
                replace node $p/won with (
                    <won bj="true" draw="false">{fn:true()}</won>
                )
            )
            (:Dealer hat über 21:)
            else if ($dealerCardsValue > 21 and $playerCardValue <= 21) then (
                replace value of node $p/won with fn:true()
            )
            (:Spieler verliert, über 21 oder weniger als Dealer:)
            else if (($playerCardValue) > 21 or (($dealerCardsValue >= $playerCardValue) and ($dealerCardsValue <= 21)))
                then ( replace value of node $p/won with fn:false())
                else (
                    (:Letzte möglicher Ausgang ist, dass der Spieler gewinnt ohne einen Blackjack zu haben:)
                    replace value of node $p/won with fn:true()
                    )
            )
        ),
        game:setActivePlayer($gameID)
    )
};