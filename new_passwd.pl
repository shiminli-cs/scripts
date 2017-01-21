#!/usr/bin/perl
#
# It is a perl script used for creating a good password containing both cases
# of letters, numbers, and symbols.
#
# Show Help Information: new_passwd.pl -h
#

use strict;
use warnings;
use Getopt::Std;

sub show_help {
    print "Useage:\n";
    print "new_passwd.pl -aAnsl\n";
    print "-a\t\t the password contains lower case letters(a-z)\n";
    print "-A\t\t the password contains upper case letters(A-Z)\n";
    print "-n\t\t the password contains numerical character(0-9)\n";
    print "-s\t\t the password contains special symbols\n";
    print "-u\t\t the password contains only unique characters\n";
    print "-l length\t set the password length(default: 6)\n";

    exit 0;
}

sub show_version {
    print "Version: 0.2.1 Changed the default option: -l 9 -Ana. 2016-4-15\n";

    exit 0;
}

### main program

use vars qw($opt_a $opt_A $opt_h $opt_l $opt_n $opt_s $opt_u $opt_v);
getopts('aAhl:nsuv');

&show_version if $opt_v;
&show_help if $opt_h;

my $len = $opt_l || 9;    # default length 9
my $opt_cnt = 0;
my @rand_str = ();

# store all the characters
my @num = qw(0 1 2 3 4 5 6 7 8 9);
my @ABC = qw(A B C D E F G H I J K L M N O P Q R S T U V W X Y Z);
my @abc = qw(a b c d e f g h i j k l m n o p q r s t u v w x y z);
my @sym = qw(! $ % & * + - . / : ; < = > ? @ [ ] ^ _ ` { | } ~); # no " ' \
unshift (@sym, '(', ')', '#', ','); # to prevent perl's complains or warnings.
my @all_sym = (@num, @ABC, @abc, @sym);
my @ch_src = ();

if ((!$opt_a) && (!$opt_A) && (!$opt_n) && (!$opt_s)) {
    $opt_a++;
    $opt_A++;
    $opt_n++;
}

if ($opt_a) {
    $opt_cnt++;
    my $i = rand @abc;
    unshift @rand_str, $abc[$i];

    if ($opt_u) {
        if ($i>=1) {
            $abc[$i-1] = shift @abc;
        } else {
            shift @abc;
        }
    }

    unshift (@ch_src, @abc);
}

if ($opt_A) {
    $opt_cnt++;
    my $i = rand @ABC;
    unshift @rand_str, $ABC[$i];

    if ($opt_u) {
        if ($i>=1) {
            $ABC[$i-1] = shift @ABC;
        } else {
            shift @ABC;
        }
    }

    unshift (@ch_src, @ABC);
}

if ($opt_n) {
    $opt_cnt++;
    my $i = rand @num;
    unshift @rand_str, $num[$i];

    if ($opt_u) {
        if ($i>=1) {
            $num[$i-1] = shift @num;
        } else {
            shift @num;
        }
    }

    unshift (@ch_src, @num);
}

if ($opt_s) {
    $opt_cnt++;
    my $i = rand @sym;
    unshift @rand_str, $sym[$i];

    if ($opt_u) {
        if ($i>=1) {
            $sym[$i-1] = shift @sym;
        } else {
            shift @sym;
        }
    }

    unshift (@ch_src, @sym);
}

if ($len < $opt_cnt) {
    print "The count of characters[$len] should not be smaller " .
          "than count of character types[$opt_cnt].\n";
    exit -1;
}

if ($opt_u && $len > (@ch_src + @rand_str)) {
    print "The total number of characters[".(@ch_src + @rand_str).
          "] which could be contained " .
          "in password is smaller than the length[$len] of it.\n";
    exit -1;
}

foreach (1..$len-$opt_cnt) {
    my $i = rand @ch_src;
    unshift @rand_str, $ch_src[$i];

    if ($opt_u) {
        if ($i>=1) {
            $ch_src[$i-1] = shift @ch_src;
        } else {
            shift @ch_src;
        }
    }
}

foreach (1..$len) {
    my $i = rand @rand_str;
    print $rand_str[$i];

    if ($i>=1) {
        $rand_str[$i-1] = shift @rand_str;
    } else {
        shift @rand_str;
    }
}

print "\n";
exit 0;
