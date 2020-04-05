xquery version "3.0";


module namespace dealer = "bj/dealer";
import module namespace player = "bj/player" at "player.xqm";
import module namespace game = "bj/game" at "game.xqm";
import module namespace helper = "bj/helper" at "helper.xqm";

declare variable $dealer:games := db:open("games")/games;

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

declare function dealer:calculateCardValue($game as element(game)) as xs:integer {
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


declare function dealer:turnCard($gameID as xs:string) as element(game){
    let $g := (
        copy $c := game:getGame($gameID)
        modify (
            let $cards := $c/dealer/currentHand
            for $i in $cards/card
            return replace value of node $i/hidden with false()
        )
        return $c
    )
    return $g

};


declare function dealer:drawCard($game as element(game)) as element(game) {
    let $result :=(
        copy $c := $game
        modify (
            let $hand := $c/dealer/currentHand
            let $val := dealer:calculateCardValue($c)
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

declare function dealer:play($gameID as xs:string) as element(game){
    dealer:drawCard(dealer:turnCard($gameID))
};
