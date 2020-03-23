xquery version "3.0";

module namespace helper = "bj/helper";

(:Ass wird zunächst als 10 gewertet, solange bis der wert 21 überschreiter, dann zählt es als 1 weiter:)
declare function helper:helperSum($acc as xs:integer, $numOfAces as xs:string) as xs:integer {

};

(:Diese Funktion gibt einen Zeitstempel zurück:)
declare function helper:currentTime() as xs:string{
    let $time := fn:substring-before(fn:string(fn:current-time()), '.')
    return $time
};