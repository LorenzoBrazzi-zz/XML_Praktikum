xquery version "3.0";

(: Nötige Module importieren:)
module namespace game = "xLinkbj/game";
import module namespace player = "xLinkbj/player" at "player.xqm";
import module namespace dealer = "xLinkbj/dealer" at "dealer.xqm";
import module namespace helper = "xLinkbj/helper" at "helper.xqm";

(: For generating the IDs for players and games :)
declare namespace uuid = "java:java.util.UUID";
declare namespace random = "http://basex.org/modules/random";

declare variable $game:games := db:open("games")/games;
declare variable $game:d := game:shuffleDeck();

declare function game:getGame($gameID as xs:string) {
    $game:games/game[id = $gameID]
};


(:~ This function returns an empty Game with default values and notifications!
    @minBet     Minimum Bet for this Game
    @maxBet     Maximum Bet for this Game
:)
declare function game:createGame($minBet as xs:integer, $maxBet as xs:integer) as element(game){
    let $gameId := xs:string(uuid:randomUUID())

    return (
        <game>
            <id>{$gameId}</id>
            <notifications>
                <notification>
                    <time>{helper:currentTime()}</time>
                    <type>protocol</type>
                    <text>Neues Spiel eröffnet, Viel Spass beim Spielen!</text>
                </notification>
                <notification>
                    <time>{helper:currentTime()}</time>
                    <type>protocol</type>
                    <text>Jeder Spieler startet mit einem Kontostand von 10.000!</text>
                </notification>
            </notifications>
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

(:~ Sets the next Player as active while the round (player 1 up to the last player) is not completed, otherwise
    looks at the current state and initiates the new one!

    @gameID     ID of the current Game
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

(:~ This function first resets the table, then assigns the players to their new positions,
    in case of someone left the game, and prepares the Game for the new Round! And is called within the player module
    (Last player of Round calls this function to ultimately finish the round and start anew!)
    @gameID     ID of the current Game
    @continue   Bool Flag from the last player, to bypass the update constraints
:)
declare
%updating
function game:finishRound($gameID as xs:string, $continue as xs:boolean) {
    let $g := game:resetTable($gameID, $continue)
    let $gg := game:assignPositions($g)
    let $result := game:prepareGame($gg)
    return (replace node $game:games/game[id = $gameID] with $result)
};


(:~ Imports the 6 deck of cards from the deck.xml Files, shuffles them and returns the sequence
:)
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

    let $result :=
        for $c in $deck/card
        order by random:integer(52)
        return $c

    return <cards>
        {$result}
    </cards>
};

(:~ Set Function of shuffleDeck(), that also insert the resulting deck into the correct Game
    @gameID     ID of the current Game
:)
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

(:~ Returns the deck of the Game
    @gameID     ID of the current Game
:)
declare function game:getDeck($gameID as xs:string) as element(cards){
    let $deck := $game:games/game[id = $gameID]/cards
    return $deck
};

(:~ Returns the card with the given index
    @gameID     ID of the current Game
    @index      Index of the card
:)
declare function game:drawCard($gameID as xs:string, $index as xs:integer) as element(card){
    let $deck := game:getDeck($gameID)
    let $card := $deck/card[$index]

    return $card
};

(:~ Pops a card from the deck stack
:)
declare
%updating
function game:popDeck($gameID as xs:string){
    let $deck := game:getDeck($gameID)
    return delete node $deck/card[1]
};


(:~ Initial Deal out function. Gives each Player and the Dealer 2 Cards, based on the position in the deck. E.g.
    since there are at max 5 players, the dealer simply gets the cards at index = 11 and index = 12!
    It also checks, whether Insurance option is viable and if the dealer BJ element can be set to true!
    @gameID     ID of the current Game
:)
declare
%updating
function game:dealOut($gameID as xs:string){
    let $g := $game:games/game[id = $gameID]
    let $prot := <notification>
        <time>{helper:currentTime()}</time>
        <type>protocol</type>
        <text>Karten wurden verteilt! Lasst die RUNDE BEGINNEN!</text>
    </notification>

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
                (: The second card of the dealer is the only card in the whole game that is turned:)
                let $second_modified := (
                    <card>
                        <value>{$second_card/value/text()}</value>
                        <color>{$second_card/color/text()}</color>
                        <turned>{fn:true()}</turned>
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
        insert node $prot as first into $game:games/game[id = $gameID]/notifications
    )
};


(:~ Checks if the current Round of player actions is completed.
    True, if the next activePlayer is the first player
    False, otherwise
    @gameID     ID of the current Game
:)
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
function game:playerWon($game as element(game), $playerID as xs:string) as xs:boolean {
    let $player := $game/players/player[id = $playerID]
    return $player/won
};


(:~ This function gets a Game element as its parameter, evaluates the round by paying out each Player, setting the
    state to continue and finally the first player as active
    @game   current Game
    returns evaluated Game
:)
declare function game:evaluateRound($game as element(game)) as element(game) {
    let $prot :=
        <notification>
            <time>{helper:currentTime()}</time>
            <type>protocol</type>
            <text>Payouts wurden jedem Spieler zugewiesen. Neues Spiel neues Glück! Aufgehts!</text>
        </notification>
    let $result := (
        copy $c := $game
        modify (
            for $p in $c/players/player
            let $playerWon := $p/won
            (:If a player has not bought Insurance, this will become 0 and not relevant anymore for following computations:)
            let $ins := (
                if ($c/dealer/xLinkbj/text() = 'true' and $p/insurance/text() = 'true') then 1 else 0
            )
            return (
            (:Each Payout scenario, win, draw, BJ, (optional) Insurance:)

            if ($playerWon/@draw/string() = "true") then (
                let $newBalance := $p/balance + xs:integer($p/currentBet) + ($ins * $p/currentBet)
                return replace value of node $p/balance with $newBalance
            ) else if ($playerWon/@xLinkbj/string() = "true") then (
                let $newBalance := $p/balance + $p/currentBet + xs:integer($p/currentBet * 1.5) + ($ins * $p/currentBet)
                return replace value of node $p/balance with $newBalance
            )
            else if (game:playerWon($c, $p/id/text())) then (
                    let $newBalance := $p/balance + $p/currentBet * 2 + ($ins * $p/currentBet)
                    return replace value of node $p/balance with $newBalance
                )
                else ()
            ),
            insert node $prot as first into $c/notifications,
            replace value of node $c/activePlayer with $c/players/player[1]/id/text(),
            replace value of node $c/state with "continue"
        )
        return $c
    )
    return $result
};


(:~ This function transforms its given Game element, by closing the Round, i.e. it
        - deletes Players that choosed not to continue
        - deletes Players that cannot afford to play a next Round (minBet too high)
        - resets all Insurance Options to false
        - resets all win elements to false
        - resets the deck with a new shuffled one
        - deletes player and dealer Hands
    @gameID                 ID of the current Game
    @lastPlayer_continue    Bool Flag for the continutation of the last Player (important because of update constraints)
    returns                 the resetted Game status
:)
declare function game:resetTable($gameID as xs:string, $lastPlayer_continue as xs:boolean) as element(game){
    let $game := $game:games/game[id = $gameID]
    let $result := (
        copy $c := $game
        modify (
            let $deck := game:shuffleDeck()
            let $dealer := $c/dealer
            return (
                for $p in $c/players/player
                let $err2 := <notification>
                    <time>{helper:currentTime()}</time>
                    <type>error</type>
                    <text>{$p/name/text()} hat nicht mehr genügend Geld! Pfiat di ;D</text>
                </notification>
                let $prot := <notification>
                    <time>{helper:currentTime()}</time>
                    <type>protocol</type>
                    <text>{$p/name/text()} hat das Spiel verlassen!</text>
                </notification>

                return (
                    if (xs:integer($p/balance) < $c/minBet) then (
                        insert node $err2 as first into $c/notifications,
                        delete node $p
                    )
                    else if ($p/@continues/string() = 'true') then (
                    (:Last Player and their continutation are adjusted in this step:)
                    if (($c/players/player[last()] = $p) and fn:not($lastPlayer_continue)) then (delete node $p,
                    insert node $prot as first into $c/notifications) else (),
                    replace node $p/insurance with <insurance>{fn:false()}</insurance>,
                    replace value of node $p/currentBet with 0,
                    replace node $p/currentHand/cards with <cards></cards>,
                    replace node $p/won with <won bj="false" draw="false">{fn:false()}</won>
                    ) else (delete node $p, insert node $prot as first into $c/notifications)
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

(:~ This function correctly assigns the new Position after some Players left the Game, e.g.
    There are 5 Players, number 3 has left, then this function fills the empty spot with player 4 and pulls player 5
    into position 4, so other players can simply join as last player!
    @game       current Game
    returns     correctly adjusted Game
:)
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


(:~ Prepares the Game for the new Round by setting its state to ready or checking if this game is still a valid game to
    join into, by looking at the amount of players it has, deleted if there are no more players avaiable or sets
    the join condition to unavailable if there are no free spots
    @game       current Game
:)
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

(:~ This function determines the winners and losers of the current Round.
    @game       current Game
    returns     Game, where all plays against the dealer have been evaluated
:)
declare function game:setResult($game as element(game)) as element(game) {
    let $dealerCardsValue := dealer:cardValueOfDealer($game)
    let $result := (
        copy $c := $game
        modify (
            for $p in $c/players/player
            return (
            (: If dealer has BJ, then all players who don´t have a BJ themselves lose, if they have, then it is a draw:)
            if (game:dealerHasBJ($c)) then (
                let $numberOfCards := fn:count($p/currentHand/cards/card)
                let $playerCardValue := player:cardValueOfPlayer($c/id/text(), $p/id/text())
                return (
                    if (fn:not(($playerCardValue = 21) and ($numberOfCards = 2))) then (
                        replace value of node $p/won with fn:false()
                    )
                    else (
                        replace node $p/won with (
                            <won bj="true" draw="true">{fn:true()}</won>
                        )
                    ))
            (:Otherwise (dealer has no BJ):)
            ) else (
                let $numberOfCards := fn:count($p/currentHand/cards/card)
                let $playerCardValue := player:cardValueOfPlayer($c/id/text(), $p/id/text())
                return (
                (:Player has BJ --> Win, because this part of the code cannot be reached if the dealer has a BJ:)
                if (($playerCardValue = 21) and ($numberOfCards = 2)) then (
                    replace node $p/won with (
                        <won bj="true" draw="false">{fn:true()}</won>
                    )
                )
                (:Draw:)
                else if ($dealerCardsValue = $playerCardValue) then (
                    replace node $p/won with <won bj="false" draw="true">{fn:false()}</won>
                )
                (:Dealer has more than 21:)
                else if ($dealerCardsValue > 21 and $playerCardValue <= 21) then (
                        replace value of node $p/won with fn:true()
                    )
                    (:Player loses, either past 21 or less than dealer:)
                    else if (($playerCardValue) > 21 or (($dealerCardsValue >= $playerCardValue) and ($dealerCardsValue <= 21)))
                        then ( replace value of node $p/won with fn:false())
                        else (
                            (:Final possible outcome is that the player wins, but without a BJ:)
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