xquery version "3.0";

(:~
: User: lorenzobrazzi
: Date: 14.12.19
: Time: 13:21
: To change this template use File | Settings | File Templates.
:)

(: Nötige Module importieren:)
module namespace game = "bj/game";
import module namespace player = "bj/player" at "player.xqm";
import module namespace dealer = "bj/dealer" at "dealer.xqm";
import module namespace chip = "bj/chip" at "chip.xqm";
import module namespace card = "bj/card" at "card.xqm";

declare namespace uuid = "java:java.util.UUID";

declare variable $game:games := db:open("games")/games;

declare function game:getGame() {
    $game:games
};

(:Zum testen der Datenbank:)
declare function game:createEmptyGame(){
    let $id := xs:string(uuid:randomUUID())
    return (
        <game id="{$id}">
        </game>
    )
};

(: Spiel aus den Daten der Formulare instanzieren:)
declare function game:createGame($names as xs:string+, $balances as xs:integer+, $minBet as xs:integer,
        $maxBet as xs:integer) as element(game){
    let $gameId := xs:string(uuid:randomUUID())
    let $players := (for $i in (1 to fn:count($balances))
    return (
        player:createPlayer(xs:string(uuid:randomUUID()), card:emptyHand(), chip:emptyChipSet(), $balances[$i],
                $names[$i], false(), $i)
    ))
    return (
        <game>
            <id>{$gameId}</id>
            <maxBet>{$maxBet}</maxBet>
            <minBet>{$minBet}</minBet>
            <players>{$players}</players>
            <activePlayer>{$players[1]/id/text()}</activePlayer>
            <cashPool>
                <chips>
                    <chip>
                        <value>100</value>
                        <color>green</color>
                    </chip>
                </chips>
            </cashPool>
            <dealer></dealer>
            <deck></deck>
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

(:Nächsten Spieler lokalisieren und festlegen als Aktiver Spieler:)
declare
%updating
function game:setActivePlayer($gameID as xs:string){
    let $oldPlayerID := $game:games/game[id = $gameID]/activePlayer
    let $oldPlayer := $game:games/game[id = $gameID]/players/player[id = $oldPlayerID]
    let $players := $game:games/game[id = $gameID]/players
    let $newPlayerID := $players/$oldPlayer/following::*[1]/id/text()
    return(replace value of node $oldPlayerID with $newPlayerID)
};
