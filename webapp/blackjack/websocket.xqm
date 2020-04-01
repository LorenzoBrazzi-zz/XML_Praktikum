xquery version "3.0";

module namespace bj-ws = "bj/websocket";
import module namespace websocket = "http://basex.org/modules/Ws";

declare
%ws-stomp:subscribe("/bj")
%ws:header-param("param0", "{$gameID}")
%ws:header-param("param1", "{$playerID}")
%updating
function bj-ws:subscribe($gameID, $playerID){
    websocket:set(websocket:id(), "playerID", $playerID),
    websocket:set(websocket:id(), "applicationID", "bj"),
    update:output(trace(concat("WS client with id ", ws:id(), " subscribed to ", $gameID, "/", $playerID)))
};

declare function bj-ws:getIDs(){
    websocket:ids()
};

declare function bj-ws:send($data, $path){
    websocket:sendchannel(fn:serialize($data), $path)
};

declare function bj-ws:get($key, $value){
    websocket:get($key, $value)
};

