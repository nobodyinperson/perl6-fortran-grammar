use v6;
# use Grammar::Tracer;

unit module Fortran::Grammar;
    
# basic Fortran structures
grammar FortranBasic is export { 

    # ignorable whitespace
    token comment { "!" \N* $$ }
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

    proto token boolean { * }
    token boolean:sym<true>  { :i '.true.' }
    token boolean:sym<false> { :i '.false.' }

    token atomic { <boolean> || <number> || <strings> }

    rule  in-place-array { \( \/ [ <booleans> || <strings> || <numbers> ] \/ \) }
    token array-index-region { <value-returning-code> ? \: <value-returning-code> ? }
    token in-place { <atomic> || <in-place-array> }
    rule  strings { <string> [ \, <string> ] * }
    rule  numbers { <number> [ \, <number> ] * }
    rule  booleans { <boolean> [ \, <boolean> ] * }

    token array-index { <array-index-region> || <integer> || <name> }
    rule  array-indices { <array-index> [ \, <array-index> ] *  }
    rule  indexed-array { <name> \( <array-indices> \) }
    rule  accessed-variable { <sign>? [ <indexed-array> || <name> ] }

    proto token arithmetic-operator { * }
    token arithmetic-operator:sym<addition>        { '+'  }
    token arithmetic-operator:sym<subtraction>     { '-'  }
    token arithmetic-operator:sym<multiplication>  { '*'  }
    token arithmetic-operator:sym<division>        { '/'  }
    token arithmetic-operator:sym<power>           { '**' }

    proto token relational-operator { * }
    token relational-operator:sym<equality>      { :i '==' | '.eq.' }
    token relational-operator:sym<inequality>    { :i '/=' | '.ne.' }
    token relational-operator:sym<less>          { :i '<'  | '.lt.' }
    token relational-operator:sym<greater>       { :i '<'  | '.lt.' }
    token relational-operator:sym<less-equal>    { :i '<=' | '.le.' }
    token relational-operator:sym<greater-equal> { :i '>=' | '.ge.' }

    proto token logical-operator { * }
    token logical-operator:sym<and>            { :i '.and.'   }
    token logical-operator:sym<or>             { :i '.or.'    }
    # TODO .not. is a prefix operator, not infix
    # token logical-operator:sym<not>            { :i '.not.'   }
    token logical-operator:sym<equivalent>     { :i '.eqv.'   }
    token logical-operator:sym<non-equivalent> { :i '.neqv.'  }

    # TODO all of the statements are only very basic and need improvement
    proto rule statement { * }
    rule statement:sym<arithmetic> { 
        <value-returning-code> [ <arithmetic-operator> <value-returning-code> ] + }
    rule statement:sym<relational> { 
        <value-returning-code> <relational-operator> <value-returning-code> }
    rule statement:sym<logical> { 
        <value-returning-code> [ <logical-operator> <value-returning-code> ] + }

    rule assignment { <accessed-variable> '=' <value-returning-code> }

    token argument { <value-returning-code> } # any value returning code can be an argument
    rule  arguments { <argument> [ \, <argument> ] * } # a list of arguments

    rule  function-call { <name> \( <arguments> ? \) }
    rule  subroutine-call { :i call <name> [ \( <arguments> ? \) ] ? }

    rule  value-returning-code { 
           <function-call> 
        || <in-place> 
        || <accessed-variable> 
        }
    }


