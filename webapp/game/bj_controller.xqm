xquery version "3.0";

module namespace controller = "bj_controller.xqm";
import module namespace main = "BlackJack/Main" at "bj_main.xqm";

declare variable $controller:index := doc("../static/blackjack/index.html")

declare
%rest:path('/blackjack')
%rest:GET
function c:spielAufrufen(){
    $controller:index
};
