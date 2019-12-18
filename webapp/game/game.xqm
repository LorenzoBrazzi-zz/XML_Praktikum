xquery version "3.0";

(:~
: User: lorenzobrazzi
: Date: 14.12.19
: Time: 13:21
: To change this template use File | Settings | File Templates.
:)

(: Nötige Module importieren:)
module namespace game = "bj/game";
import module namespace player = "bj/spieler" at "player.xqm";
import module namespace dealer = "bj/dealer" at "dealer.xqm";
declare namespace uuid = "java:java.util.UUID";

declare variable $game:games := db:open("games")/games;

declare function game:getGame() {
    $game:games
};

(: Spiel aus den Daten der Formulare instanzieren:)
declare function game:createEmptyGame(){
    let $id := xs:string(uuid:randomUUID())
    return(
        <game id="{$id}">
        </game>
    )
};

declare function game:createGame($names as xs:string+, $balances as xs:integer+, $minBet as xs:integer, $maxBet as xs:integer) as element(game){
    let $id := xs:string(uuid:randomUUID())
    return (
        <game id="{$id}">
            <maxBet>{$maxBet}</maxBet>
            <minBet>{$minBet}</minBet>
            <activePlayer>{$names}</activePlayer>
        </game>
    )
};

declare
%updating
function game:insertGame($g as element(game)){
    insert node $g as first into $game:games
};