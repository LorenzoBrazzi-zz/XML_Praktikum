xquery version "3.0";

module namespace helper = "bj/helper";


(:Diese Funktion gibt einen Zeitstempel zurück:)
declare function helper:currentTime() as xs:string{
    let $time := fn:substring-before(fn:string(fn:current-time()), '.')
    return $time
};