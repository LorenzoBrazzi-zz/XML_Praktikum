xquery version "3.0";


module namespace dealer = "xLinkbj/dealer";
import module namespace game = "xLinkbj/game" at "game.xqm";

declare variable $dealer:games := db:open("games")/games;


(:~ Tail Recursive Function that determines how many cards the dealer has to draw until the score is above 16!
    @game       current Game
    @currentVal current score of the dealers hand
    @result     accumulated number of cards to draw
    returns     number of cards to draw
:)
declare function dealer:numberofDrawingCard($game as element(game), $currentVal as xs:integer, $result as xs:integer) as xs:integer{
    let $card := (
        let $deck := $game/cards
        let $c := $deck/card[$result + 1]

        return $c
    )
    let $cardVal := dealer:newCardValue($card, $currentVal)
    return (
        if ($currentVal >= 17) then ($result)
        else (
            dealer:numberofDrawingCard($game, ($currentVal + $cardVal), ($result + 1))
        )
    )
};

(:~ Calculates the Dealers Score, just as the function in the players module. But because of update constraints reasons,
    this function takes a game element, a modified copy, and adjust the result for that particular. Besides that, everything
    stays the same.
    @game       current Game
    returns     hand Score of the dealer
:)
declare function dealer:cardValueOfDealer($game as element(game)) as xs:integer {
    let $dealer := $game/dealer

    let $amoutOfAces := (
        sum(
                for $c in $dealer/currentHand/card
                return (
                    if ($c/value = 'A') then 1 else 0
                ))
    )

    let $valueOfCardsWitoutAces := (
        sum(
                for $c in $dealer/currentHand/card
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

(:~ This function is needed because the card Ace can be either 1 or 11. When this is called, the dealer has drawn a new
    card, thus the score of the hand must be recalculated in order to correctly assign the value for the Ace, which is
    11, if not beyond 21
    1, otherwise
    @game       current Game
    returns     new Hand score
:)
declare function dealer:newCardValue($card as element(card), $val as xs:integer) as xs:integer{
    let $dummy := 0
    return (
        if ($card/value = 'A') then (
            if ($val + 11 > 21) then (1) else (11)
        ) else (
            if ($card/value = 'K' or $card/value = 'D' or $card/value = 'B') then (10) else ($card/value)
        )
    )
};


(:~ Turns the second card of the Dealer
    @gameID     ID of the current Game
:)
declare function dealer:turnCard($gameID as xs:string) as element(game){
    let $g := (
        copy $c := game:getGame($gameID)
        modify (
            let $cards := $c/dealer/currentHand
            for $i in $cards/card
            return replace value of node $i/turned with false()
        )
        return $c
    )
    return $g

};


(:~ Draws 0 or more cards for the dealer.
    @game       current Game
    returns     adjusted Game
:)
declare function dealer:drawCard($game as element(game)) as element(game) {
    let $result :=(
        copy $c := $game
        modify (
            let $hand := $c/dealer/currentHand
            let $val := dealer:cardValueOfDealer($c)
            let $amount := dealer:numberofDrawingCard($c, $val, 0)
            let $deck := $c/cards

            return (
                for $i in (1 to $amount)
                return (
                    insert node $deck/card[$i] into $hand
                ),
                for $i in (1 to $amount)
                return (
                   delete node $deck/card[1]
                ))
        )
        return $c
    )
    return $result
};

(:~ Combines the actions of first turning the second card, and if necessary, draw some cards.
:)
declare function dealer:play($gameID as xs:string) as element(game){
    dealer:drawCard(dealer:turnCard($gameID))
};
