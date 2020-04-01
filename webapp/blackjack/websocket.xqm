xquery version "3.0";

module namespace bj-ws = "bj/websocket";
import module namespace websocket = "http://basex.org/modules/Ws";

declare
%ws-stomp:subscribe("/bj")
%ws:header-param("param0", "{$bj}")
%ws:header-param("param1", "{$gameID}")
%ws:header-param("param2", "{$playerID}")
%updating
function bj-ws:subscribe($bj, $gameID, $playerID){
    websocket:set(websocket:id(), "applicationID", "bj"),
    websocket:set(websocket:id(), "bjUrl", $bj),
    websocket:set(websocket:id(), "gameID", $gameID),
    websocket:set(websocket:id(), "playerID", $playerID),
    update:output(trace(concat("WS client with id ", $playerID, " subscribed to ", $bj, "/", $gameID, "/", $playerID)))
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

declare
%ws-stomp:connect("/bj")
%updating
function bj-ws:stompconnect(){
    update:output(trace(concat("WS client connected with id ", websocket:id())))
};

declare
%ws:close("/bj")
%updating
function bj-ws:stompdisconnect(){
    update:output(trace(concat("WS client disconnected with id ", websocket:id())))
};

