#!/usr/bin/perl
use Test::More tests => 4;
use Config::AutoConf;
use Config::AutoConf::Linker;
use File::Temp qw/tempdir/;
use File::Spec;

my $dir = tempdir(CLEANUP => 0);
_write_files($dir);
my $CC = ExtUtils::CBuilder->new(quiet => 0);
my ($LD, $CCL) = Config::AutoConf::Linker::detect_library_link_commands($CC);

SKIP: {
    skip "Could not detect how to link a library.", 4 unless defined($LD) && defined($CCL);

    my $lfile = File::Spec->catfile($dir, 'library.c');
    my $cfile = File::Spec->catfile($dir, 'test.c');

    my $lfile_o = $CC -> compile(source => $lfile);
    my $cfile_o = $CC -> compile(source => $cfile);

    my $libfile = File::Spec->catfile($dir, "libbar$LIBEXT");
    my $exefile = File::Spec->catfile($dir, "bar$EXEEXT");

    $LD -> ( $CC,
             objects => [ $lfile_o ],
             module_name => 'foo',
             lib_file => $libfile);

    ok(-f $libfile);

    $CCL -> ( $CC,
              objects => [ $cfile_o ],
              exe_file => $exefile,
              extra_linker_flags => "-L$dir -lbar" );

    ok(-f $exefile);
    ok(-x $exefile);

    my $out;
    if ($LIBEXT eq "so") {
        $ENV{LD_LIBRARY_PATH} = ".";
    }
    chomp($out = `$exefile`);
    is($out, "42");
}

sub _write_files {
    my $outpath = shift;
    my $fh;
    while(<DATA>) {
        if (m!==\[(.*?)\]==!) {
	    my $fname = $1;
            $fname = File::Spec->catfile($outpath, $fname);
            open $fh, ">$fname" or die "Can't create temporary file $fname\n";
        } elsif ($fh) {
            print $fh $_;
        }
    }
}

__END__
__DATA__
==[library.c]==
  int answer(int a) {
      return 20+a;
  }
==[test.c]==
#include <stdio.h>

int main() {
    int a = answer(22);
    printf("%d\n", a);
    return 0;
}
