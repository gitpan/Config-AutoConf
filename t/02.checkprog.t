# -*- cperl -*-

use Test::More tests => 6;
use Config;
use Config::AutoConf;

ok(Config::AutoConf->check_prog("perl"));
ok(!Config::AutoConf->check_prog("hopingnobodyhasthiscommand"));

like(Config::AutoConf->check_progs("___perl___", "__perl__", "_perl_", "perl"), qr/perl$/);
is(Config::AutoConf->check_progs("___perl___", "__perl__", "_perl_"), undef);

AWK: {
  my $awk;
  skip "Not sure about your awk", 1 unless $Config{awk};
  ok($awk = Config::AutoConf->check_prog_awk);
  diag("Found AWK as $awk");
}

EGREP: {
  my $grep;
  skip "Not sure about your grep", 1 unless $Config{egrep};
  ok($grep = Config::AutoConf->check_prog_egrep);
  diag("Found EGREP as $grep");
}

