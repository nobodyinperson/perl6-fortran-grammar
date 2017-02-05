
# Perl6 Fortran::Grammar module [![Build Status](https://travis-ci.org/nobodyinperson/perl6-fortran-grammar.svg?branch=master)](https://travis-ci.org/nobodyinperson/perl6-fortran-grammar)

Perl6 grammar to parse FORTRAN source code

**Note**: This module is still in very early development.

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
