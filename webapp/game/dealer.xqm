xquery version "3.0";


module namespace dealer = "bj/dealer";
import module namespace player = "bj/player" at "player.xqm";
import module namespace game = "bj/game" at "game.xqm";
import module namespace helper = "bj/helper" at "helper.xqm";

declare variable $dealer:games := db:open("games")/games;

declare
%updating
function dealer:drawCard($gameID as xs:string) {
    let $hand := $dealer:games/game[id = $gameID]/dealer/currentHand
    let $card := game:drawCard($gameID)
    let $val := dealer:calculateCardValue($gameID)

    return (
        if ($val < 17) then (
            insert node $card into $hand,
            game:popDeck($gameID)
        )
        else ()
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

declare
%updating
function dealer:drawCards($gameID as xs:string) {
    let $hand := $dealer:games/game[id = $gameID]/dealer/currentHand
    let $deck := game:getDeck($gameID)

    return
        for $i in (1, 2)
        return (insert node $deck/card[1] as first into $hand,
        delete node $deck/card[1])

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
function dealer:setInsurance($gameID as xs:string){
    let $hand := $dealer:games/game[id = $gameID]/dealer/currentHand
    let $cards := $hand/card
    return (
    (:Aktiviere die Insurance Funktion, sobald die erste Karte ein Ass ist:)
    if ($cards[1]/value = "A")
    then (
        replace value of node $dealer:games/game[id = $gameID]/dealer/isInsurance with true(),
        (:Sollte die folgende Karte ein Zehner Value sein, hat der Dealer natürlich einen Blackjack:)
        (if (($cards[2]/value = "K") or ($cards[2]/value = "Q") or ($cards[2]/value = "B") or ($cards[2]/value = "10"))
        then (
                replace value of node $dealer:games/game[id = $gameID]/dealer/bj with true()
            ) else ())
    )
    else (
        replace value of node $dealer:games/game[id = $gameID]/dealer/isInsurance with false()
    )
    )
};
