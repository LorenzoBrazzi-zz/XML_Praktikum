xquery version "3.0";


module namespace dealer = "bj/dealer";
import module namespace player = "bj/player" at "player.xqm";
import module namespace game = "bj/game" at "game.xqm";

declare variable $dealer:games := db:open("games")/games;

declare
%updating
function dealer:drawCard($gameID as xs:string) {
    let $hand := $dealer:games/game[id=$gameID]/dealer/currentHand
    let $card := game:drawCard($gameID)

    return (
        insert node $card as first into $hand,
        game:popDeck($gameID)
    )
};

declare
%updating
function dealer:turnCard($gameID as xs:string){
    let $hand := $dealer:games/game[id=$gameID]/dealer/currentHand
    let $cards := $hand/card
    for  $i in $cards
    return replace value of node $i/hidden with false()

};

declare
%updating
function dealer:setInsurance($gameID as xs:string){
    replace value of node $dealer:games/game[id=$gameID]/dealer/isInsurance with true()
};
