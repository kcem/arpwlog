#!/usr/bin/perl

# Konrad Cempura 2009
# GNU GPL 2.0
# http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt

use warnings;
use strict;

my @wiersze;
chomp (@wiersze = <STDIN>);

open (OUT , ">>/var/log/arpwatch/arpwatch_mail.log")
	or die "Nie moglem zapisac danych!";

my %wpis;
foreach ( @wiersze ) {
	chomp;

	if (/^\s*(hostname|ip address|interface|ethernet address|ethernet vendor|old ethernet address|old ethernet vendor|timestamp|previous timestamp|delta):\s(.*)/) {
		$wpis{$1} = $2 if ($2 ne '<unknown>');
	} elsif (/^Subject:\s+(.*)/) {
		# $wpis{'subject'} = '<b>' . $1 . '</b>';
		$wpis{'subject'} = $1;
	} elsif (/^\s*$/ || /^From: / || /^To: /) {
		# skip
	} else {
		if (not defined $wpis{other}) {
			$wpis{'other'} = $_
		} else {
			$wpis{'other'} = ", " . $wpis{'other'} . $_
		}
	}
}

my @tmp; 
@tmp = split (/,?\s/, $wpis{'timestamp'});
$wpis{'timestamp'} = $tmp[2] . " " . substr($tmp[1], 0, 3) . " " . $tmp[3] . " " . $tmp[4]; 

if (defined $wpis{'previous timestamp'}) {
	@tmp = split (/,?\s/, $wpis{'previous timestamp'});
	$wpis{'previous timestamp'} = $tmp[2] . " " . substr($tmp[1], 0, 3) . " " . $tmp[3] . " " . $tmp[4];
}

undef @tmp;

my $result = $wpis{'timestamp'};
$result = $result . "; " . $wpis{'interface'} if defined $wpis{'interface'};
$result = $result . "; " . $wpis{'subject'} if defined $wpis{'subject'};
$result = $result . "; " . $wpis{'ip address'} if defined $wpis{'ip address'};
$result = $result . " (" . $wpis{'hostname'} . ")" if defined $wpis{'hostname'};
$result = $result . "; " . $wpis{'ethernet address'} if defined $wpis{'ethernet address'};
$result = $result . " (" . $wpis{'ethernet vendor'} . ")" if defined $wpis{'ethernet vendor'};
$result = $result . "; " . $wpis{'old ethernet address'} if defined $wpis{'old ethernet address'};
$result = $result . " (" . $wpis{'old ethernet vendor'} . ")" if defined $wpis{'old ethernet vendor'};
$result = $result . "; " . $wpis{'previous timestamp'} if defined $wpis{'previous timestamp'};
$result = $result . " (" . $wpis{'delta'} . ")" if defined $wpis{'delta'};
$result = $result . " nie rozpoznane opcje: " . $wpis{'other'} if defined $wpis{'other'};

print OUT $result . "\n";
close OUT;
