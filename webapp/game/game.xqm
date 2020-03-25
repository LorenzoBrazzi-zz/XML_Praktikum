xquery version "3.0";

(: Nötige Module importieren:)
module namespace game = "bj/game";
import module namespace player = "bj/player" at "player.xqm";
import module namespace dealer = "bj/dealer" at "dealer.xqm";
import module namespace chip = "bj/chip" at "chip.xqm";
import module namespace card = "bj/card" at "card.xqm";
import module namespace helper = "bj/helper" at "helper.xqm";
import module namespace controller = "bj/controller" at "controller.xqm";

(: Hiermit generieren wir die IDs sowohl der Spiele als auch der Spieler :)
declare namespace uuid = "java:java.util.UUID";
declare namespace random = "http://basex.org/modules/random";
declare namespace update = "http://basex.org/modules/update";

declare variable $game:games := db:open("games")/games;
declare variable $game:d := game:shuffleDeck();

declare function game:getGame() {
    $game:games/game
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
declare function game:createGame($names as xs:string+, $balances as xs:integer+, $minBet as xs:integer,
        $maxBet as xs:integer) as element(game){
    let $gameId := xs:string(uuid:randomUUID())
    let $players := (for $i in (1 to fn:count($balances))
    return (
        player:createPlayer(xs:string(uuid:randomUUID()), card:emptyHand(), $minBet, $balances[$i],
                $names[$i], fn:false(), $i)
    ))
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
            <state>bet</state>
            <maxBet>{$maxBet}</maxBet>
            <minBet>{$minBet}</minBet>
            <players>{$players}</players>
            <activePlayer>{$players[1]/id/text()}</activePlayer>
            <dealer>
                <currentHand>
                </currentHand>
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
    return (
        if (fn:not($oldPlayer/position = $count)) then (replace value of node $oldPlayerID with $newPlayerID)
        else (
            if ($state = 'play') then (
                game:changeState($gameID, 'evaluate'),
                replace value of node $oldPlayerID with $players/player[1]/id/text(),
                game:determineWinners($gameID),
                game:evaluateRound($gameID)
            ) else (replace value of node $oldPlayerID with $players/player[1]/id/text()))
    )

(: WIR MÜSSEN NOCH DEN FALL ABCHECNKEN WENN KEIN SPIELER MEHR DA IST ALSO WENN activePlayer = ""
    --> Wir haben doch die Position IDs mit Zahlen von 1 bis 5 gemacht, somit können wir einfach den Spieler dann
    aufrufen, der an Pos 1 sitzt:)
};

declare
%updating
function game:evaluate($gameID as xs:string) {
    let $x := 0
    return (game:determineWinners($gameID))
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
zu entfernen:)
declare function game:drawCard($gameID as xs:string) as element(card){
    let $deck := game:getDeck($gameID)
    let $card := $deck/card[1]

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
            (: Zweite Karte des Dealers ist die winzige Karte die verdeckt ist:)
            let $second_card := $g/cards/card[12]
            let $second_modified := (
                <card>
                    <value>{$second_card/value/text()}</value>
                    <color>{$second_card/color/text()}</color>
                    <hidden>{fn:true()}</hidden>
                </card>
            )
            return (
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

declare
%updating
function game:determineWinners($gameID as xs:string) {
    let $players := $game:games/game[id = $gameID]/players
    let $dealer := $game:games/game[id = $gameID]/dealer
    let $dealerCardsValue := dealer:calculateCardValue($gameID)

    for $p in $players/player
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
        (:Bedingungen bei dem der Spieler verliert:)
        ) else if (($playerCardValue) > 21 or ($dealerCardsValue >= $playerCardValue))
        then ( replace value of node $p/won with fn:false())
        else (
            (:Letzte möglicher Ausgang ist, dass der Spieler gewinnt ohne einen Blackjack zu haben:)
            replace value of node $p/won with fn:true()
            )
        )
    ))
};

declare
%private
function game:dealerHasBJ($gameID as xs:string) as xs:boolean {
    let $dealer := $game:games/game[id = $gameID]/dealer
    return $dealer/bj
};

declare
%private
function game:isInsurancePossible($gameID as xs:string) as xs:boolean {
    let $dealer := $game:games/game[id = $gameID]/dealer
    return $dealer/isInsurance
};

declare
%private
function game:playerWon($gameID as xs:string, $playerID as xs:string) as xs:boolean {
    let $player := $game:games/game[id = $gameID]/players/player[id = $playerID]
    return $player/won
};

declare
%private
function game:playerHasInsurance($gameID as xs:string, $playerID as xs:string) as xs:boolean {
    let $player := $game:games/game[id = $gameID]/players/player[id = $playerID]
    return $player/insurance
};

declare
%updating
function game:evaluateRound($gameID as xs:string) {
    let $players := $game:games/game[id = $gameID]/players
    let $insurancePossible := $game:games/game[id = $gameID]/dealer/isInsurance

    for $p in $players/player
        return (
        if(game:playerWon($gameID, $p/id/text())) then (
         player:payoutBalanceNormal($gameID, $p/id/text())) else ())
        (:)let $playerWon := $p/won
            return (
            (:Bei Unentschieden wird gleich ausgezahlt:)
            if ($playerWon/@draw = "true") then (
                player:payoutDraw($gameID, $p/id/text())
            ) else if (game:playerWon($gameID, $p/id/text())) then (
                player:payoutBalanceNormal($gameID, $p/id/text)) else ()):)
                (:)) else if ((game:isInsurancePossible($gameID)) and (game:playerHasInsurance($gameID, $p/id/text()))) then (
                player:payoutInsurance($gameID, $p/id/text())
            (:Da das erste if ein Unentschieden ausschließt, wird hier nur auf ein Sieg geachtet:)
            ) else if ($playerWon/@bj = "true") then (
                player:payoutBJ($gameID, $p/id/text())
            ) else ()
            )):)
};


declare
%updating
function game:resetTable($gameID){
    let $game := $game:games/game[id = $gameID]
    let $deck := game:shuffleDeck()
    return (
        for $p in $game/players/player
        return (
            replace node $p/currentHand/cards with <cards></cards>
        ),
        replace node $game/cards with $deck
    )

};

declare
%updating
function game:closeRound($gameID){
    game:determineWinners($gameID),
    game:evaluateRound($gameID),
    game:resetTable($gameID)
};

declare
%updating
function game:changeState($gameID as xs:string, $nextState as xs:string){
    let $g := $game:games/game[id = $gameID]
    return (
        replace value of node $g/state with $nextState
    )};