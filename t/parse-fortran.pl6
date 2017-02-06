#!/usr/bin/env perl6
use v6;
use JSON::Fast;
use Fortran::Grammar;
use Fortran::Grammar::Test;

sub MAIN (Str :$rule = "codelines", Bool :$json = False) {
    my Str $input = lines($*IN).join("\n");
    # say "";
    # say "### INPUT ###";
    # say $input;
    # say "#############";
    # say "";
    # say "### INPUT AS $rule ###";
    my $m = Fortran::Grammar::FortranFreeForm.parse: $input, 
        rule => $rule, actions => Fortran::Grammar::Test::TestActions.new;
    if $json { 
        try {
            CATCH { 
                default { say to-json {} }
                }
            say to-json $m.made;
            }
        }
    else { 
        say $m;
        }
    # say "######################";
    # say "";
    }
