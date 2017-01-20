#!/usr/bin/perl
# Author: Li Shimin
#  Email: shiminli@aggiemail.usu.edu
# This script is used for reordering the number of lemmas, theorems, equations,
# corollaries, and observations in the tex source code file.
# Usage: reorder.pl tex_file
# The reordered file will be saved in a file named "ordered_tex_file",
# and the input file would be kept intact.

use strict;
use warnings;

if ($#ARGV<0) {
    print "Usage: reorder.pl file_name\n";
    exit 1;
}

my $srcfile = $ARGV[0];
my $dstfile = "ordered_" . $srcfile;

if (-e $dstfile) {
    print "The destination file exists! Will you overwrite it anyway?\n";
    $_ = <STDIN>;
    die "Cannot overwrite the output file!\n" if (! m/^y/);
}

open(my $sf, "<", $srcfile)
    or die "Cannot open file: $srcfile.\n";

open(my $df, ">", $dstfile)
    or die "Cannot open file: $dstfile.\n";

my %reorder = (
         "lem" => 10,
        "theo" => 10,
          "eq" => 10,
        "obsr" => 10,
        "coro" => 10
);

while (my $row = <$sf>) {
    my @matches = $row =~ m/({(lem|theo|eq|obsr|coro):[0-9]+})/g;
    if (@matches) {
        foreach (@matches) {
            next if ($_ =~ m/^(lem|theo|eq|obsr|coro)$/g);
            my $label = $_;
            $label =~ /(lem|theo|eq|obsr|coro)/;
            my $class = $1;
            if (! defined $reorder{$label}) {
                $reorder{$label} = "{".$class.":".$reorder{$class}."}";
                $reorder{$class} += 10;
            }
        }

        $row =~ s/({(lem|theo|eq|obsr|coro):[0-9]+})/$1@@@/g;
        my @substr = split(/@@@/, $row);
        $row = "";
        foreach (@substr) {
            $_ =~ s/({(lem|theo|eq|obsr|coro):[0-9]+})/$reorder{$1}/g;
            $row = $row.$_;
        }
    }

    print $df $row;
}

close($sf) or warn "Close $srcfile Failed!\n";
close($df) or warn "Close $dstfile Failed!\n";
