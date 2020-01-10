xquery version "3.0";


module namespace dealer = "bj/dealer";
import module namespace player = "bj/player" at "player.xqm";
import module namespace game = "bj/game" at "game.xqm";

declare variable $dealer:games := db:open("games")/games;


(:Zieht eine Karte und enfernt diese aus dem Deck Stack:)
declare
%updating
function drawCard($gameID as xs:string){
    let $dealer := $dealer:games/game[id = $gameID]/dealer
    let $card := drawCard($gameID)

    return(
        insert node $card into $dealer/currentHand
    )

};