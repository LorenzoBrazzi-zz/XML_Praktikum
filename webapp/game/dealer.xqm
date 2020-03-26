xquery version "3.0";


module namespace dealer = "bj/dealer";
import module namespace player = "bj/player" at "player.xqm";
import module namespace game = "bj/game" at "game.xqm";
import module namespace helper = "bj/helper" at "helper.xqm";

declare variable $dealer:games := db:open("games")/games;

declare function dealer:numberofDrawingCard($gameID as xs:string, $currentVal as xs:integer, $result as xs:integer) as xs:integer{
    let $card := game:drawCard($gameID, ($result + 1))
    let $cardVal := dealer:newCardValue($card, $currentVal)
    return (
        if ($currentVal >= 17) then ($result)
        else (
            dealer:numberofDrawingCard($gameID, ($currentVal + $cardVal), ($result + 1))
        )
    )
};

declare function dealer:calculateCardValue($gameID as xs:string) as xs:integer {
    let $dealer := $player:games/game[id = $gameID]/dealer

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


declare
%updating
function dealer:turnCard($gameID as xs:string){
    let $hand := $dealer:games/game[id = $gameID]/dealer/currentHand
    let $cards := $hand/card
    for $i in $cards
    return replace value of node $i/hidden with false()
};


declare
%updating
function dealer:drawCard($gameID as xs:string) {
    let $hand := $dealer:games/game[id = $gameID]/dealer/currentHand
    let $val := dealer:calculateCardValue($gameID)
    let $amount := dealer:numberofDrawingCard($gameID, $val, 0)
    let $deck := game:getDeck($gameID)

    return (
        for $i in (1 to $amount)
        return (
            insert node $deck/card[$i] into $hand
        ),
        for $i in (1 to $amount)
        return (
            game:popDeck($gameID)
        ))

};

declare
%updating
function dealer:play($gameID as xs:string){
    dealer:turnCard($gameID),
    dealer:drawCard($gameID)
};

declare
%updating
function dealer:setInsurance($gameID as xs:string){
    let $hand := $dealer:games/game[id = $gameID]/dealer/currentHand
    let $state := $dealer:games/game[id = $gameID]/state
    let $cards := $hand/card
    return (
    (:Aktiviere die Insurance Funktion, sobald die erste Karte ein Ass ist:)
    if ($cards[1]/value = "A")
    then (
        replace value of node $dealer:games/game[id = $gameID]/dealer/isInsurance with true(),
        (:Sollte die folgende Karte ein Zehner Value sein, hat der Dealer natürlich einen Blackjack:)
        replace value of node $state with "insurance",
        ( if (($cards[2]/value = "K") or ($cards[2]/value = "Q") or ($cards[2]/value = "B") or ($cards[2]/value = "10"))
        then (
                replace value of node $dealer:games/game[id = $gameID]/dealer/bj with true()
            ) else ())
    )
    else (
        replace value of node $dealer:games/game[id = $gameID]/dealer/isInsurance with false()
    )
    )
};
