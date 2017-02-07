
# Perl6 Fortran::Grammar module [![Build Status](https://travis-ci.org/nobodyinperson/perl6-fortran-grammar.svg?branch=master)](https://travis-ci.org/nobodyinperson/perl6-fortran-grammar)

Perl6 grammar to parse FORTRAN source code

**Note**: This module is still in very early development.

## Usage

Use it like any grammar in Perl6:

```perl6
#!/usr/bin/env perl6
use Fortran::Grammar; # use the module

# some simple Fortran code
my Str $fortran = q:to/EOT/;
    call sub( array(1:2), sin(1.234_prec), & ! Fortran-style linebreak / comment
        & (/ 1.23, 3.45, 6.78 /), "Hello World!" )
    EOT

# parse the Fortran code
my $parsed = Fortran::Grammar::FortranBasic.parse: $fortran.chomp, 
                rule => "subroutine-call";

say "### input ###";
say $fortran;
say "### parsed ###";
say $parsed;
```

Output:

```perl6
### input ###
call sub( array(1:2), sin(1.234_prec), & ! Fortran-style linebreak / comment
    & (/ 1.23, 3.45, 6.78 /), "Hello World!" )

### parsed ###
｢call sub( array(1:2), sin(1.234_prec), & ! Fortran-style linebreak / comment
    & (/ 1.23, 3.45, 6.78 /), "Hello World!" )｣
 name => ｢sub｣
 arguments => ｢array(1:2), sin(1.234_prec), & ! Fortran-style linebreak / comment
    & (/ 1.23, 3.45, 6.78 /), "Hello World!" ｣
  argument => ｢array(1:2)｣
   value-returning-code => ｢array(1:2)｣
    accessed-variable => ｢array(1:2)｣
     indexed-array => ｢array(1:2)｣
      name => ｢array｣
      array-indices => ｢1:2｣
       array-index => ｢1:2｣
        array-index-region => ｢1:2｣
         value-returning-code => ｢1｣
          in-place => ｢1｣
           atomic => ｢1｣
            number => ｢1｣
             integer => ｢1｣
              digits => ｢1｣
         value-returning-code => ｢2｣
          in-place => ｢2｣
           atomic => ｢2｣
            number => ｢2｣
             integer => ｢2｣
              digits => ｢2｣
  argument => ｢sin(1.234_prec)｣
   value-returning-code => ｢sin(1.234_prec)｣
    function-call => ｢sin(1.234_prec)｣
     name => ｢sin｣
     arguments => ｢1.234_prec｣
      argument => ｢1.234_prec｣
       value-returning-code => ｢1.234_prec｣
        in-place => ｢1.234_prec｣
         atomic => ｢1.234_prec｣
          number => ｢1.234_prec｣
           float => ｢1.234_prec｣
            digits => ｢1｣
            digits => ｢234｣
            precision-spec => ｢_prec｣
             name => ｢prec｣
  argument => ｢(/ 1.23, 3.45, 6.78 /)｣
   value-returning-code => ｢(/ 1.23, 3.45, 6.78 /)｣
    in-place => ｢(/ 1.23, 3.45, 6.78 /)｣
     in-place-array => ｢(/ 1.23, 3.45, 6.78 /)｣
      numbers => ｢1.23, 3.45, 6.78 ｣
       number => ｢1.23｣
        float => ｢1.23｣
         digits => ｢1｣
         digits => ｢23｣
       number => ｢3.45｣
        float => ｢3.45｣
         digits => ｢3｣
         digits => ｢45｣
       number => ｢6.78｣
        float => ｢6.78｣
         digits => ｢6｣
         digits => ｢78｣
  argument => ｢"Hello World!" ｣
   value-returning-code => ｢"Hello World!" ｣
    in-place => ｢"Hello World!" ｣
     atomic => ｢"Hello World!" ｣
      string => ｢"Hello World!" ｣
```

## Install

If you use [panda](https://github.com/tadzik/panda), install `Fortran::Grammar` via 

```bash
panda install Fortran::Grammar
```

or from the repository root

```bash
panda install .
```

## Special thanks

- smls on [StackOverflow.com](http://stackoverflow.com/a/42039566/5433146) for
  an Action object `FALLBACK` method that converts a `Match` object to a
  JSON-serializable `Hash`
