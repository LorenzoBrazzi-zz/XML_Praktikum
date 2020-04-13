xquery version "3.0";

module namespace xLinkbj-ws = "xLinkbj/websocket";
import module namespace websocket = "http://basex.org/modules/Ws";

declare
%ws-stomp:subscribe("/xLinkbj")
%ws:header-param("param0", "{$xLinkbj}")
%ws:header-param("param1", "{$gameID}")
%ws:header-param("param2", "{$playerID}")
%updating
function xLinkbj-ws:subscribe($xLinkbj, $gameID, $playerID){
    websocket:set(websocket:id(), "applicationID", "xLinkbj"),
    websocket:set(websocket:id(), "xLinkbjUrl", $xLinkbj),
    websocket:set(websocket:id(), "gameID", $gameID),
    websocket:set(websocket:id(), "playerID", $playerID),
    update:output(trace(concat("WS client with id ", $playerID, " subscribed to ", $xLinkbj, "/", $gameID, "/", $playerID)))
};

declare function xLinkbj-ws:getIDs(){
    websocket:ids()
};

declare function xLinkbj-ws:send($data, $path){
    websocket:sendchannel(fn:serialize($data), $path)
};

declare function xLinkbj-ws:get($key, $value){
    websocket:get($key, $value)
};

declare
%ws-stomp:connect("/xLinkbj")
%updating
function xLinkbj-ws:stompconnect(){
    update:output(trace(concat("WS client connected with id ", websocket:id())))
};

declare
%ws:close("/xLinkbj")
%updating
function xLinkbj-ws:stompdisconnect(){
    update:output(trace(concat("WS client disconnected with id ", websocket:id())))
};
