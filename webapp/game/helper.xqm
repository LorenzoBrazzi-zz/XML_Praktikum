xquery version "3.0";

module namespace helper = "bj/helper";

(:Ass wird zunächst als 10 gewertet, solange bis der wert 21 überschreiter, dann zählt es als 1 weiter:)
declare function helper:helperSum($acc as xs:integer, $x as xs:string) as xs:integer {
    if ($x= 'A') then (
        if (($acc + 11) > 21) then (
            let $res := $acc + 1
            return $res
        ) else (
            let $res := $acc + 11
            return $res
        )
    ) else if (($x = 'K') or ($x = 'D') or ($x = 'B')) then (
        let $res := $acc + 10
        return $res
    ) else (
        let $res := $acc + xs:integer($x)
        return $res
    )
};