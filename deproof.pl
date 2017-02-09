#!/usr/bin/perl
# Author: Li Shimin
#  Email: shiminli@aggiemail.usu.edu
# This script is used for move the proofs in a tex file into the Appendix.
# Usage: deproof.pl tex_file
# The new file will be saved into "deproof_tex_file",
# and the input file would be kept intact.
# NOTICE YOU NEED TO PUT \BEGIN{LEMMA}\LABEL{xxx} IN A LINE SEPARATELY.

use strict;
use warnings;

if ($#ARGV<0) {
    print "Usage: deproof.pl tex_file\n";
    exit 1;
}


my $srcfile = $ARGV[0];
my $dstfile = "deproof_" . $srcfile;
my $tmpfile = "/tmp/Appendix_" . $$;
my $lemma = 0;
my $proof = 0;
my $enddoc = 0;
my $row;

if (-e $dstfile) {
    print "The destination file exists! Will you overwrite it anyway?\n";
    $_ = <STDIN>;
    die "Cannot overwrite the output file!\n" if (! m/^y/);
}

open(my $sf, "<", $srcfile)
    or die "Cannot open file: $srcfile. Error: ". $!."\n";

open(my $df, ">", $dstfile)
    or die "Cannot open file: $dstfile. Error: ". $!."\n";

open(my $tf, ">", $tmpfile)
    or die "Cannot open file: $tmpfile. Error: ". $!."\n";

print $tf "\\newpage\n\\appendix\n\\section*{APPENDIX}\n\n";

while ($row = <$sf>) {
    $enddoc = 1 if ($row =~ /^\\end\{document\}/);

    if ($enddoc) {
        print $tf $row;
        next;
    }

    if ($row =~ /^\\begin\{(lemma|theorem)\}/) {
        $lemma = 1;
        my @matches = $row =~ m/(\{(lem|theo):\w+\})/g;
        print $tf "\n\\section*{Proof of Lemma~\\ref$matches[0]}\n\n";
        print $tf "\\vspace{0.1in}\n";
        print $tf "\\noindent\n";
        print $tf "{\\bf Lemma \\ref$matches[0]}\n";
        print $tf "{\\em\n";
    }

    if ($row =~ /^\\end\{(lemma|theorem)\}/) {
        $lemma = 0;
        print $tf "}\n";
    }

    print $tf $row if ($lemma && $row !~ /^\\begin\{(lemma|theorem)\}/);

    $proof = 1 if ($row =~ /^\\begin\{proof\}/);
    print $tf $row if ($proof);
    $row = "% ".$row if ($proof); # comment the proofs
    $proof = 0 if ($row =~ /^\% \\end\{proof\}/);

    print $df $row;
}

close($sf) or warn "Close $srcfile Failed! Error: ". $!."\n";
close($tf) or warn "Close $tmpfile Failed! Error: ". $!."\n";

open($tf, "<", $tmpfile)
    or die "Cannot open file: $tmpfile. Error: ". $!."\n";

print $df $row while ($row = <$tf>);

close($df) or warn "Close $dstfile Failed! Error: ". $!."\n";
unlink $tmpfile;
