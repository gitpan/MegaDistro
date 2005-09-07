package MegaDistro::Package;

use strict;
use warnings;

use Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(make_tarball make_package);

use lib './MegaDistro';

use MegaDistro::Config qw(:default $DEVNULL);
use MegaDistro::RpmMaker::Build qw(have_rpm build_rpm);
use MegaDistro::DebMaker::Build qw(have_deb build_deb);

use Archive::Tar;

#create snapshot of buildtree
sub make_tarball {
# return tarball name here?
	my ( $year, $month, $day ) = (localtime)[5,4,3];
	my $date = sprintf "%02d%02d%02d", $year + 1900, $month + 1, $day;
	my $TARBALL = 'megadistro' . '-' . $date . '.tar.gz';
	system( "cd $Conf{'builddir'}; tar zcvf $Conf{'rootdir'}/$TARBALL * > $DEVNULL; cd $Conf{'rootdir'}" ); #safety
	return -e "$Conf{'rootdir'}/$TARBALL";
}

sub make_package {
# return built package names here, from calls?
	if ( "$Conf{'disttype'}" eq "rpm" ) {
		if ( &have_rpm ) {
			&build_rpm;
		}
		else {  #allow the possibility of another choice, "on-the-fly"/interactively here, since it's possible?
		        #override-able by --force, e.g. testing/development purposes
			die "\nPackage system rpm, is not available on this system!\n";
		}
	}
	elsif ( "$Conf{'disttype'}" eq "deb" ) {
		if ( &have_deb ) {
			&build_deb;
		}
		else {  #allow the possibility of another choice, "on-the-fly"/interactively here, since it's possible?
		        #override-able by --force, e.g. testing/development purposes
			die "\nPackage system deb, is not available on this system!\n";
		}
	}
}

1;
