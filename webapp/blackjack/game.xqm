xquery version "3.0";

(: Nötige Module importieren:)
module namespace game = "bj/game";
import module namespace player = "bj/player" at "player.xqm";
import module namespace dealer = "bj/dealer" at "dealer.xqm";
import module namespace card = "bj/card" at "card.xqm";
import module namespace helper = "bj/helper" at "helper.xqm";

(: Hiermit generieren wir die IDs sowohl der Spiele als auch der Spieler :)
declare namespace uuid = "java:java.util.UUID";
declare namespace random = "http://basex.org/modules/random";

declare variable $game:games := db:open("games")/games;
declare variable $game:d := game:shuffleDeck();

declare function game:getGame($gameID as xs:string) {
    $game:games/game[id = $gameID]
};

(:Zum testen der Datenbank:)
declare function game:createEmptyGame(){
    let $id := xs:string(uuid:randomUUID())
    return (
        <game id="{$id}">
        </game>
    )
};

(: Spiel aus den Daten der Formulare instanzieren,
   Evenets sind wichtig für diverse Dinge, wie Protokolle oder Error messages,
   States sind wichtig um später bei der Transformation Knöpfe richtig ein und ausblenden zu können!:)
declare function game:createGame($minBet as xs:integer, $maxBet as xs:integer) as element(game){
    let $gameId := xs:string(uuid:randomUUID())

    return (
        <game>
            <id>{$gameId}</id>
            <events>
                <event>
                    <time>{helper:currentTime()}</time>
                    <type>protocol</type>
                    <text>Neues Spiel eröffnet, Viel Spass beim Spielen!</text>
                </event>
            </events>
            <state>ready</state>
            <maxBet>{$maxBet}</maxBet>
            <minBet>{$minBet}</minBet>
            <players></players>
            <activePlayer></activePlayer>
            <available>{fn:true()}</available>
            <dealer>
                <currentHand></currentHand>
                <bj>{fn:false()}</bj>
                <isInsurance>{fn:false()}</isInsurance>
            </dealer>
            {$game:d}
        </game>
    )
};

declare
%updating
function game:insertGame($g as element(game)){
    insert node $g as first into $game:games
};


declare
%updating
function game:deleteGame($gameID as xs:string){
    delete node $game:games/game[id = $gameID]
};

(:Nächsten Spieler lokalisieren und festlegen als Aktiver Spieler
  Falls letzter Spieler fertig ist, rufe evaluateRound() auf
:)
declare
%updating
function game:setActivePlayer($gameID as xs:string){
    let $oldPlayerID := $game:games/game[id = $gameID]/activePlayer
    let $state := $game:games/game[id = $gameID]/state
    let $oldPlayer := $game:games/game[id = $gameID]/players/player[id = $oldPlayerID]
    let $players := $game:games/game[id = $gameID]/players
    let $count := fn:count($players/player)
    let $newPlayerID := $players/$oldPlayer/following::*[1]/id/text()
    let $prot := <event>
        <time>{helper:currentTime()}</time>
        <type>protocol</type>
        <text>Berechne Spielausgang...</text>
    </event>
    return (
        if (fn:not($oldPlayer/position = $count)) then (replace value of node $oldPlayerID with $newPlayerID)
        else (
            if ($state = 'ready') then (
                game:changeState($gameID, 'bet'),
                replace value of node $game:games/game[id = $gameID]/available with fn:false(),
                replace value of node $oldPlayerID with $players/player[1]/id/text()
            )
            else if ($state = 'play') then (
                let $g := dealer:play($gameID)
                let $gg := game:setResult($g)
                let $result := game:evaluateRound($gg)
                return replace node $game:games/game[id = $gameID] with $result
            )
            else (replace value of node $oldPlayerID with $players/player[1]/id/text())
        )
    )
};

declare
%updating
function game:finishRound($gameID as xs:string, $continue as xs:boolean) {
    let $g := game:resetTable($gameID, $continue)
    let $gg := game:assignPositions($g)
    let $result := game:prepareGame($gg)
    return (replace node $game:games/game[id = $gameID] with $result)
};

declare function game:getPlayerNames($gameID as xs:string){
    let $players := $game:games/game[id = $gameID]/players
    let $playerNames := (for $player in $players
    return (
        $player/name/text()
    )
    )
    return $playerNames
};


(: Shuffle Function:)
declare
%private
function game:shuffleDeck() as element(cards){
    let $cardSet := fn:doc("./deck.xml")/cards/*
    let $deck := <cards>
        {$cardSet}
        {$cardSet}
        {$cardSet}
        {$cardSet}
        {$cardSet}
        {$cardSet}
    </cards>

    let $shuffled :=
        for $c in $deck/card
        order by random:integer(52)
        return $c

    return <cards>
        {$shuffled}
    </cards>
};

(:Public setter Function of shuffle():)
declare
%updating
function game:setShuffledDeck($gameID as xs:string){
    let $deck := $game:games/game[id = $gameID]/cards
    let $shuffled := game:shuffleDeck()

    return (
        delete node $deck,
        insert node $shuffled into $game:games/game[id = $gameID]
    )
};

(:Erhatle Deck für diverse andere Funktionen:)
declare function game:getDeck($gameID as xs:string) as element(cards){
    let $deck := $game:games/game[id = $gameID]/cards
    return $deck
};

(:Funktion für Spieler und Dealer um eine Karte zu ziehen und zugleich die gezogene Karte aus dem Deck Stack
zu entfernen, Der index ist für den Dealer, default = 1:)
declare function game:drawCard($gameID as xs:string, $index as xs:integer) as element(card){
    let $deck := game:getDeck($gameID)
    let $card := $deck/card[$index]

    return $card
};

(:Nach ziehen einer Karte wird diese aus dem Stack entfernt, Controller muss diese hier bei jeder Draw funktion
extern aufrufen:)
declare
%updating
function game:popDeck($gameID as xs:string){
    let $deck := game:getDeck($gameID)
    return delete node $deck/card[1]
};


declare
%updating
function game:dealOutCards($gameID as xs:string){
    let $g := $game:games/game[id = $gameID]
    let $prot := <event>
        <time>{helper:currentTime()}</time>
        <type>protocol</type>
        <text>Karten wurden verteilt! Lasst die RUNDE BEGINNEN!</text>
    </event>

    return (
        let $dealer := $g/dealer
        for $p in $g/players/player
        return (
            let $pos := xs:integer($p/position)
            return ( insert node $g/cards/card[($pos * 2) - 1] into $p/currentHand/cards,
            insert node $g/cards/card[($pos * 2)] into $p/currentHand/cards,
            delete node $g/cards/card[($pos * 2) - 1],
            delete node $g/cards/card[($pos * 2)],
            if ((xs:integer(fn:count($g/players))) = $pos) then (
            (: Zweite Karte des Dealers ist die einzige Karte die verdeckt ist:)
            let $first_card := $g/cards/card[11]
            let $dealer_first_value := (
                if ($first_card/value = 'A') then 11 else (
                    if ($first_card/value = 'K' or $first_card/value = 'B' or $first_card/value = 'D') then 10 else $first_card/value
                )
            )
            let $second_card := $g/cards/card[12]
            let $dealer_second_value := (
                if ($second_card/value = 'A') then 11 else (
                    if ($second_card/value = 'K' or $second_card/value = 'B' or $second_card/value = 'D') then 10 else $second_card/value
                )
            )
            let $second_modified := (
                <card>
                    <value>{$second_card/value/text()}</value>
                    <color>{$second_card/color/text()}</color>
                    <hidden>{fn:true()}</hidden>
                </card>
            )

            return (
                if ($g/cards/card[11]/value = 'A') then (
                    replace value of node $dealer/isInsurance with fn:true()
                ) else (),
                if ($dealer_first_value + $dealer_second_value = 21)
                then (replace value of node $dealer:games/game[id = $gameID]/dealer/bj with fn:true())
                else (),
                insert node $g/cards/card[11] into $dealer/currentHand,
                insert node $second_modified into $dealer/currentHand,
                delete node $g/cards/card[11],
                delete node $g/cards/card[12])
            ) else ()
            )
        ),
        insert node $prot as first into $game:games/game[id = $gameID]/events
    )
};


declare function game:isRoundCompleted($gameID as xs:string) as xs:boolean{
    let $activeID := $game:games/game[id = $gameID]/activePlayer
    let $activePlayer := $game:games/game[id = $gameID]/players/player[id = $activeID]
    let $count := fn:count($game:games/game[id = $gameID]/players/player)
    return (
        if ($activePlayer/position = $count)
        then (fn:true()) else (fn:false())
    )
};

declare function game:dealerHasBJ($game as element(game)) as xs:boolean {
    let $dealer := $game/dealer
    return $dealer/bj
};

declare
%private
function game:hasBJ($game as element(game)) as xs:boolean {
    let $dealer := $game/dealer
    return $dealer/isInsurance and $dealer/bj
};

declare
%private
function game:playerWon($game as element(game), $playerID as xs:string) as xs:boolean {
    let $player := $game/players/player[id = $playerID]
    return $player/won
};

declare
%private
function game:playerHasInsurance($game as element(game), $playerID as xs:string) as xs:boolean {
    let $player := $game/players/player[id = $playerID]
    return $player/insurance
};

declare function game:evaluateRound($game as element(game)) as element(game) {
    let $result := (
        copy $c := $game
        modify (
            for $p in $c/players/player
            let $playerWon := $p/won
            let $ins := (
                if ($c/dealer/bj/text() = 'true' and $p/insurance/text() = 'true') then 1 else 0
            )
            return (
            (:Wenn Dealer BJ dann kriegt ein Spieler, falls er Insurance gekauft hat, 50% seines Bets zurück:)

            if ($playerWon/@draw/string() = "true") then (
                let $newBalance := $p/balance + xs:integer($p/currentBet) + ($ins * $p/currentBet)
                return replace value of node $p/balance with $newBalance
            ) else if ($playerWon/@bj/string() = "true") then (
                let $newBalance := $p/balance + $p/currentBet + xs:integer($p/currentBet * 1.5) + ($ins * $p/currentBet)
                return replace value of node $p/balance with $newBalance
            )
            else if (game:playerWon($c, $p/id/text())) then (
                    let $newBalance := $p/balance + $p/currentBet * 2 + ($ins * $p/currentBet)
                    return replace value of node $p/balance with $newBalance
                )
                (:Da das erste if ein Unentschieden ausschließt, wird hier nur auf ein Sieg geachtet:)
                else ()
            ),
            replace value of node $c/activePlayer with $c/players/player[1]/id/text(),
            replace value of node $c/state with "continue"
        )
        return $c
    )
    return $result
};


declare function game:resetTable($gameID as xs:string, $lastPlayer_continue as xs:boolean) as element(game){
    let $game := $game:games/game[id = $gameID]
    let $result := (
        copy $c := $game
        modify (
            let $deck := game:shuffleDeck()
            let $dealer := $c/dealer
            return (
                for $p in $c/players/player
                let $err2 := <event>
                    <time>{helper:currentTime()}</time>
                    <type>error</type>
                    <text>{$p/name/text()} hat nicht mehr genügend Geld! Pfiat di ;D</text>
                </event>
                return (
                    if (xs:integer($p/balance) < $c/minBet) then (
                        insert node $err2 as first into $c/events,
                        delete node $p
                    )
                    else if ($p/@continues/string() = 'true') then (
                    (:Der letzte Spieler und sein Continue Click wird nochmal hier angepasst:)
                    if (($c/players/player[last()] = $p) and fn:not($lastPlayer_continue)) then (delete node $p) else (),
                    replace node $p/insurance with <insurance>{fn:false()}</insurance>,
                    replace value of node $p/currentBet with 0,
                    replace node $p/currentHand/cards with <cards></cards>,
                    replace node $p/won with <won bj="false" draw="false">{fn:false()}</won>
                    ) else (delete node $p)
                ),
                replace value of node $dealer/isInsurance with fn:false(),
                replace node $dealer/currentHand with <currentHand></currentHand>,
                replace node $c/cards with $deck
            )
        )
        return $c
    )
    return $result
};

declare function game:assignPositions($game as element(game)) as element(game) {
    let $result := (
        copy $c := $game
        modify (
            let $count := count($c/players/player)
            return (
                for $i in (1 to $count)
                return (
                    replace value of node $c/players/player[$i]/position with $i
                )
            )
        )
        return $c
    )
    return $result
};

declare function game:prepareGame($game as element(game)) as element(game) {
    let $result := (
        copy $c := $game
        modify(
            let $count := fn:count($c/players/player)
            let $oldPlayerID := $c/activePlayer
            return (
                if ($count = 0) then (
                    replace value of node $c/state with 'deleted'
                ) else (
                    replace value of node $c/state with "ready",
                    replace value of node $c/available with $count < 5,
                    replace value of node $oldPlayerID with $c/players/player[1]/id/text()
                )
            )
        )
        return $c
    )
    return $result
};

declare
%updating
function game:changeState($gameID as xs:string, $nextState as xs:string){
    let $g := $game:games/game[id = $gameID]
    return (
        replace value of node $g/state with $nextState
    )};

declare function game:setResult($game as element(game)) as element(game) {
    let $dealerCardsValue := dealer:calculateCardValue($game)
    let $result := (
        copy $c := $game
        modify (
            for $p in $c/players/player
            return (
            (: Falls der Dealer einen Blackjack hat, verlieren automatisch alle Spieler die keinen Blackjack haben:)
            if (game:dealerHasBJ($c)) then (
                let $numberOfCards := fn:count($p/currentHand/cards/card)
                let $playerCardValue := player:calculateCardValuePlayers($c/id/text(), $p/id/text())
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
                let $playerCardValue := player:calculateCardValuePlayers($c/id/text(), $p/id/text())
                return (
                (:Spieler hat einen Blackjack, Sieg weil die Funktionsstelle nur erreicht, wenn der Dealer kein Blackjack:)
                if (($playerCardValue = 21) and ($numberOfCards = 2)) then (
                    replace node $p/won with (
                        <won bj="true" draw="false">{fn:true()}</won>
                    )
                )
                (:Unentschieden:)
                else if ($dealerCardsValue = $playerCardValue) then (
                    replace node $p/won with <won bj="false" draw="true">{fn:false()}</won>
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
            )
            )
        )
        return $c
    )
    return $result

};