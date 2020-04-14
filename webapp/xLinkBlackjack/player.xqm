xquery version "3.0";

module namespace player = "xLinkbj/player";
import module namespace game = "xLinkbj/game" at "game.xqm";
import module namespace helper = "xLinkbj/helper" at "helper.xqm";

declare namespace uuid = "java:java.util.UUID";

declare variable $player:games := db:open("games")/games;

(:~ Creates a Player with empty Hand
    @bet        Default 0 value given by the controller  function call
    @balance    Default value 10.000 given by the controller function call
    @name       Player name
    @insurance  Default value false given by controller function call
    @position   Seat Position of the player
    returns     Player with default values and a name
:)
declare function player:createPlayer($bet as xs:integer,
        $balance as xs:integer, $name as xs:string, $insurance as xs:boolean, $position as xs:integer) as element(player){
    <player continues="true">
        <id>{xs:string(uuid:randomUUID())}</id>
        <name>{$name}</name>
        <balance>{$balance}</balance>
        <currentHand>
            <cards></cards>
        </currentHand>
        <currentBet>{$bet}</currentBet>
        <insurance>{$insurance}</insurance>
        <position>{$position}</position>
        <won bj="false" draw="false">{fn:false()}</won>
    </player>
};

(:~ This functions takes the bet that is entered by the player in the Browser and assigns the currentBet element of them,
    subtracts that particular amount from their balance and finally sets the next player as active. It also checks, whether
    the bet that was entered is valid or not and sends error message, if false.
    Finally, if the activePlayer is the last one, then the state is shifted towards 'play' and thus the cards are dealt out!
    @gameID     ID of the current Game
    @bet        Bet that was entered by the player
:)
declare
%updating
function player:setBet($gameID as xs:string, $bet as xs:integer) {

    let $activePlayer := $player:games/game[id = $gameID]/activePlayer
    let $player := $player:games/game[id = $gameID]/players/player[id = $activePlayer]
    let $activePlayerNewBalance := $player/balance - $bet
    let $maxBet := $player:games/game[id = $gameID]/maxBet
    let $minBet := $player:games/game[id = $gameID]/minBet
    let $err := <notification>
        <time>{helper:currentTime()}</time>
        <type>error</type>
        <text>Fehler beim Einsatz!!! Der Einsatz muss mindestens {$minBet}, darf maximal {$maxBet} oder
            deinen aktuellen Kontostand nicht übersteigen!</text>
    </notification>

    return (
        if ($bet > $player/balance or $bet > $maxBet or $bet < $minBet) then (
            insert node $err as first into $player:games/game[id = $gameID]/notifications
        ) else (
            replace value of node $player/currentBet with xs:integer($bet),
            replace value of node $player/balance with $activePlayerNewBalance,
            if (game:isRoundCompleted($gameID)) then (game:changeState($gameID, 'play'), game:dealOut($gameID), game:setActivePlayer($gameID)) else (game:setActivePlayer($gameID))
        )
    )
};


declare
%updating
function player:stand($gameID as xs:string){
    let $game := $player:games/game[id = $gameID]
    let $activePlayerID := $game/activePlayer
    let $prot :=
        <notification>
            <time>{helper:currentTime()}</time>
            <type>protocol</type>
            <text>{$game/players/player[id = $activePlayerID]/name/text()} hat seinen Zug beendet!</text>
        </notification>
    return (
        insert node $prot as first into $game/notifications,
        game:setActivePlayer($gameID)
    )};

declare
%updating
function player:double($gameID as xs:string) {

    let $activePlayer := $player:games/game[id = $gameID]/activePlayer
    let $p := $player:games/game[id = $gameID]/players/player[id = $activePlayer]
    let $currentBet := $p/currentBet
    let $newBet := $currentBet * 2
    let $maxBet := $player:games/game[id = $gameID]/maxBet
    let $err := <notification>
        <time>{helper:currentTime()}</time>
        <type>error</type>
        <text>Fehler beim Verdoppeln!!! Der Einsatz darf
            deinen aktuellen Kontostand/Maximaleinsatz nicht übersteigen! Maximaleinsatz/Kontomaximum wird ausgewählt</text>
    </notification>
    let $prot :=
        <notification>
            <time>{helper:currentTime()}</time>
            <type>protocol</type>
            <text>{$p/name/text()} hat seinen Einsatz !!! VERDOPPELT !!!</text>
        </notification>
    return (
    (: If the doubled value is higher than maxBet or the balance :)
    if ($newBet > $p/balance) then (
        insert node $err as first into $player:games/game[id = $gameID]/notifications,
        replace value of node $currentBet with $p/balance + $currentBet,
        replace value of node $p/balance with 0,
        player:hit($gameID)
    )
    else if ($newBet > $maxBet) then (
        insert node $err as first into $player:games/game[id = $gameID]/notifications,
        replace value of node $currentBet with $maxBet,
        replace value of node $p/balance with $p/balance - $maxBet,
        player:hit($gameID)
    )
    else (
            insert node $prot as first into $player:games/game[id = $gameID]/notifications,
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
    let $score := player:cardValueOfPlayer($gameID, $playerID)
    let $err := <notification>
        <time>{helper:currentTime()}</time>
        <type>error</type>
        <text>An 21 leider vorbeigeschossen :((</text>
    </notification>
    let $prot := <notification>
        <time>{helper:currentTime()}</time>
        <type>protocol</type>
        <text>{$name} hat gehittet!</text>
    </notification>
    let $win := <notification>
        <time>{helper:currentTime()}</time>
        <type>protocol</type>
        <text>Glückwunsch, {$name}! Du hast 21 erreicht!</text>
    </notification>
    (:If the active player is already beyond 21, then there is no need to hit anymore, thus an error message if they
    still click on the button!:)
    return (
        if ($score > 21) then (
            insert node $err as first into $player:games/game[id = $gameID]/notifications
        )
        (:Automatically redirect players, that have reached 21:)
        else if ($score = 21) then (
            insert node $win as first into $player:games/game[id = $gameID]/notifications,
            game:setActivePlayer($gameID)
        )
        (:If the Hit was succesful and they do not reach 21 with their new card, they are free to chose their next action
        of course, i.e. no setActivePlayer() call:)
        else (
                insert node $prot as first into $player:games/game[id = $gameID]/notifications,
                player:drawCard($gameID)
            ))
};



declare
%updating
function player:setInsurance($gameID as xs:string){
    let $playerID := $player:games/game[id = $gameID]/activePlayer
    let $player := $player:games/game[id = $gameID]/players/player[id = $playerID]
    let $prot :=
        <notification>
            <type>protocol</type>
            <time>{helper:currentTime()}</time>
            <text>{$player/name/text()} hat sich für 50% seines Einsatzes versichern lassen!</text>
        </notification>
    let $err :=
        <notification>
            <type>protocol</type>
            <time>{helper:currentTime()}</time>
            <text>Das Guthaben {$player/name/text()} reicht für eine Versicherung nicht aus! (50% des Einsatzes nötig)</text>
        </notification>

    return (
        (:If player has not enough money to pay, simply do nothing:)
        if($player/balance < xs:integer(0.5*$player/currentBet))
        then (
            insert node $err as first into $player:games/game[id = $gameID]/notifications
        )
        else (
        (:Balance - 0.5 currentBet, because the cost of buying Insurance is 50% of your current Bet,
    later if the dealer happens to have a BJ this will be readded to their balance:)
        replace value of node $player/balance with $player/balance - xs:integer(0.5 * $player/currentBet),
        replace value of node $player/insurance with fn:true(),
        insert node $prot as first into $player:games/game[id = $gameID]/notifications
        )

    )
};


(:~ This function calculates the Score of the cards in the players´ hand. All cases besides the Ace are trivial, but since
    A can be either 1 or 11, a more sophisticated approach was chosen. First, the function counts the number of Aces
    in ones hand, followed by calculation the score of cards without aces.
    Finally, by using a left fold, the function counts aces as 11, as long as the final score does not go beyond 21.
    Since this function is called after each card drawn, the calculations always return a valid assignment for the Aces!
    @gameID     ID of the current Game
    @playerID   ID of the player
:)
declare function player:cardValueOfPlayer($gameID as xs:string, $playerID as xs:string) as xs:integer {
    let $player := $player:games/game[id = $gameID]/players/player[id = $playerID]

    let $aceCount := (
        sum(
                for $c in $player/currentHand/cards/card
                return (
                    if ($c/value = 'A') then 1 else 0
                ))
    )

    let $noAcesValue := (
        sum(
                for $c in $player/currentHand/cards/card
                return (
                    if (($c/value = 'B') or ($c/value = 'D') or ($c/value = 'K')) then 10
                    else if ($c/value = 'A') then 0
                    else ($c/value)
                )
        ))

    let $value := fn:fold-left((1 to $aceCount), $noAcesValue, function($acc, $c) {
        if ($acc + 11 > 21) then ($acc + 1) else ($acc + 11)
    })
    return (
        xs:integer($value)
    )
};

(:~ Draws a card for the activePlayer and removes it from the deck stack!
    @gameID     ID of the current Game
:)
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

(:~ Player continuation Confirmation function. Sets the continues attribute to false if the player has choosen to stop
    playing further, or if the player is not able to continue due to having not enough money.
    @game ID    ID of the current Game
    @continue   Boolean  continuation flag
:)
declare
%updating
function player:setContinue($gameID as xs:string, $continue as xs:boolean){
    let $activePlayerID := $player:games/game[id = $gameID]/activePlayer
    let $player := $player:games/game[id = $gameID]/players/player[id = $activePlayerID]
    let $count := fn:count($player:games/game[id = $gameID]/players/player)
    return (
        if ($player/position = $count) then (game:finishRound($gameID, $continue))
        else (
            if ($continue and ($player/balance >= $player:games/game[id = $gameID]/minBet)) then () else (replace value of node $player/@continues with 'false'),
            game:setActivePlayer($gameID)
        )
    )

};