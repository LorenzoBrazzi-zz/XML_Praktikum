xquery version "3.0";

(:~ This module contains helper functions!
:)

module namespace helper = "bj/helper";


(:~ Returns the current Time stamp!
:)
declare function helper:currentTime() as xs:string{
    let $time := fn:substring-before(fn:string(fn:current-time()), '.')
    return $time
};