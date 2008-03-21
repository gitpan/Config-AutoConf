# -*- cperl -*-

use Test::More tests => 6;
use Config;
use Config::AutoConf;

if ($^O =~ m!MSWin32!) {
	ok(Config::AutoConf->check_prog("perl.exe"));
} else {
	ok(Config::AutoConf->check_prog("perl"));
}

ok(!Config::AutoConf->check_prog("hopingnobodyhasthiscommand"));

SKIP: {
	if ($^O =~ m!MSWin32!) {
		like(Config::AutoConf->check_progs("__perl__.exe", "_perl_.exe", "perl.exe"), qr/perl.exe$/);
	} else {
		like(Config::AutoConf->check_progs("___perl___", "__perl__", "_perl_", "perl"), qr/perl$/);
	}
	is(Config::AutoConf->check_progs("___perl___", "__perl__", "_perl_"), undef);	
};

SKIP: {
  my $awk;
  skip "Not sure about your awk", 1 if $^O =~ m!MSWin32! || !$Config{awk};
  ok(($awk = Config::AutoConf->check_prog_awk));
  diag("Found AWK as $awk");
};

SKIP: {
  my $grep;
  skip "Not sure about your grep", 1 if $^O =~ m!MSWin32! || !$Config{egrep};
  ok(($grep = Config::AutoConf->check_prog_egrep));
  diag("Found EGREP as $grep");
};

