use v6;

unit module Fortran::Grammar;
    
grammar FortranFreeForm is export { 
    # regex TOP { :s <value-returning-code> }

    # multiple codelines
    rule codelines { 
        [<codeline> <.nl>?]*
        }

    rule codeline { 
        ^^ 
        [
        <empty-line>
        || <preprocessor-line>
        || <subroutine-call>
        || <not-implemented-code>
        ]
        $$ }
    rule not-implemented-code { \N* }

    token comment { "!" \N* $$ }
    token preprocessor-line { ^^ "#" \N* $$ }
    token ws { 
        <!ww> 
        \h* 
        ["&" \h* [ <comment>? <nl> ] + \h* "&" \h*] ? 
        <comment> ?
        }
    token nl { \n+ }
    token empty-line { \h* }

    # fortran primitives
    token variablename { :i <[a..z0..9_]>+ }
    token precision-spec { _ <variablename> }
    token integer { \d+ <precision-spec> ? }
    token float { \d+ [ \. \d+ ]? <precision-spec> ? }
    token number { <float> || <integer> }
    rule  string { [ '"' <-["]>* '"' ] || [ "'" <-[']>* "'" ] }
    token atomic { <number> || <string> }
    rule  in-place-array { \( \/ [ <strings> || <numbers> ] \/ \) }
    token array-index-region { <value-returning-code> ? \: <value-returning-code> ? }
    token in-place { <atomic> || <in-place-array> }
    rule  strings { <string> [ \, <string> ] * }
    rule  numbers { <number> [ \, <number> ] * }

    token array-index { <array-index-region> || <variablename> || <integer> }
    rule  array-indices { <array-index> [ \, <array-index> ] *  }
    rule  indexed-array { <variablename> \( <array-indices> \) }
    rule  accessed-variable { <indexed-array> || <variablename> }

    # fortran operators
    # only simple statements are possible
    token operator { <[-+*/]> || '**' }
    rule statement { <value-returning-code-no-statement> <operator> <value-returning-code-no-statement> }

    token argument { <value-returning-code> } # any value returning code can be an argument
    rule  arguments { <argument> [ \, <argument> ] * } # a list of arguments

    # token known-index { <integer> || <return-size-one-function-call> }
    # rule  known-indices { <known-index> [ \, <known-index> ] * }
    # rule  known-indexed-array { <variablename> \( <known-indices> \) }
    # token return-size-one-code { <integer> || <float> || 
    #     <known-indexed-array> || <return-size-one-function-call> }
    # token return-size-one-function { size || rank } # function with return size one
    # rule  return-size-one-function-call
    #     { <return-size-one-function> \( <arguments> ? \) }

    rule  function-call { <variablename> \( <arguments> ? \) }
    rule  subroutine-call { :i call <variablename> [ \( <arguments> ? \) ] ? }

    rule  value-returning-code { <function-call> || <statement> || <in-place> || <accessed-variable> }
    rule  value-returning-code-no-statement { <function-call> || <in-place> || <accessed-variable> }
    }


