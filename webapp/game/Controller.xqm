xquery version "3.0";

(:~
: User: lorenzobrazzi
: Date: 06.12.19
: Time: 08:43
: To change this template use File | Settings | File Templates.
:)

module namespace controller = "game/controller.xqm";

declare variable $controller:landing := doc("../static/index.html");
declare variable $controller:start := doc("../static/startGame.html");

(: This function calls game initiation by displaying start screen :)
declare
%rest:path("/blackjack")
%rest:GET
function controller:landingPage() {
    $controller:landing
};

declare
%rest:path("/blackjack/startGame")
%rest:GET
function controller:startGame() {
    $controller:start
};
