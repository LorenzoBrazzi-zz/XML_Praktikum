xquery version "3.0";

(:~
: User: Ikbal Yesiltas
: Date: 18/12/2019
: Time: 12:43
: To change this template use File | Settings | File Templates.
:)

module namespace card = "bj/card";

declare function card:emptyHand(){
    <cards>
    </cards>
};