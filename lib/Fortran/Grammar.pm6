use v6;
# use Grammar::Tracer;

unit module Fortran::Grammar;
    
grammar FortranFreeForm is export { 
    # regex TOP { :s <value-returning-code> }
    
    # multiple codelines
    rule codelines {
        [ <full-codeline> <.nl>? ]*
        }

    rule full-codeline { 
        ^^ <codeline> $$
        }

    rule codeline {
        [
        <comment>
        || <preprocessor-line>
        || <subroutine-call>
        || <not-implemented-code>
        ]
        }
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

    # fortran primitives
    token name { :i <[a..z0..9_]>+ }
    token precision-spec { _ <name> }
    token digits { \d+ }
    token integer { <digits> <precision-spec> ? }
    token float { <digits> \. <digits>  <precision-spec> ? }
    token number { <sign>? [ <float> || <integer> ] }
    rule  string { [ '"' <-["]>* '"' ] || [ "'" <-[']>* "'" ] }
    rule  sign { <[-+]> }
    token atomic { <number> || <string> }
    rule  in-place-array { \( \/ [ <strings> || <numbers> ] \/ \) }
    token array-index-region { <value-returning-code> ? \: <value-returning-code> ? }
    token in-place { <atomic> || <in-place-array> }
    rule  strings { <string> [ \, <string> ] * }
    rule  numbers { <number> [ \, <number> ] * }

    token array-index { <array-index-region> || <integer> || <name> }
    rule  array-indices { <array-index> [ \, <array-index> ] *  }
    rule  indexed-array { <name> \( <array-indices> \) }
    rule  accessed-variable { <sign>? [ <indexed-array> || <name> ] }

    # fortran operators
    # only simple statements are possible
    token operator { <[-+*/]> || '**' }
    rule statement { 
        <value-returning-code-no-statement> 
        [ <operator> <value-returning-code-no-statement> ] * }

    token argument { <value-returning-code> } # any value returning code can be an argument
    rule  arguments { <argument> [ \, <argument> ] * } # a list of arguments

    # token known-index { <integer> || <return-size-one-function-call> }
    # rule  known-indices { <known-index> [ \, <known-index> ] * }
    # rule  known-indexed-array { <name> \( <known-indices> \) }
    # token return-size-one-code { <integer> || <float> || 
    #     <known-indexed-array> || <return-size-one-function-call> }
    # token return-size-one-function { size || rank } # function with return size one
    # rule  return-size-one-function-call
    #     { <return-size-one-function> \( <arguments> ? \) }

    rule  function-call { <name> \( <arguments> ? \) }
    rule  subroutine-call { :i call <name> [ \( <arguments> ? \) ] ? }

    rule  value-returning-code { <function-call> || <in-place> || <accessed-variable> || <statement> }
    rule  value-returning-code-no-statement { <function-call> || <in-place> || <accessed-variable> }
    }


