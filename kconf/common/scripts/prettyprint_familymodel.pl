#!/usr/bin/perl

use strict;
use warnings;

use Data::Dumper;
use Tie::IxHash;
use File::Copy;
use File::Basename;
use File::Path;

my $keyorder = [
	'vname',
	'name',
	'depends',
	'dir',
	'subdir',
	'srcdir',
	'srcfile',
	'classname',
	'generate',
	'file',
	'files',
	'symlink',
	'comp',
];

sub sort_keys {
	my $ref = shift;
	my @ko = ( );
	my %keys = map { $_ => 1 } keys %$ref;

	foreach my $k (@$keyorder) {
		if(exists $keys{$k}) {
			push @ko, $k;
			delete $keys{$k};
		}
	}

	print STDERR "WARN: Unknown Attribute $_\n" foreach (keys %keys);

	push @ko, (keys %keys);

	return \@ko;
}

sub load_file {
	my $name = shift;
	my $family;
	unless ($family = do $name) {
		die "couldn't parse $name: $@" if $@;
		die "couldn't do $name: $!" unless defined $family;
		die "couldn't run $name" unless $family;
	}
	
	return $family;
}

sub isComplex {
	my $href = shift;

	if( (scalar(keys %$href)==1) && (exists $href->{file} || exists $href->{files}) ) {
		return 0;
	}

	return 1;
}

sub recurse {
	my $href = shift;
	return unless exists $href->{comp} && ref $href->{comp};

	my @filegroup = ( );
	my @complexchildren = ( );

	foreach my $comp (@{$href->{comp}}) {
		#my $name = exists $comp->{name}  ? $comp->{name} : 'unnamed';
		#print STDERR "name: $name\n";
		if(isComplex($comp)) {
			recurse($comp);
			push @complexchildren, $comp;

		} else {
			if(exists $comp->{file}) {
				push @filegroup, $comp->{file};
			} else {
				push @filegroup, $_ foreach @{$comp->{files}};
			}
		}
	}

	if(@filegroup > 1) {
		unshift @complexchildren, { files => \@filegroup };
		$href->{comp} = \@complexchildren;
	} elsif(@filegroup == 1) {
		unshift @complexchildren, { file => $filegroup[0] };
	}
}

my $href =load_file($ARGV[0]); 
recurse($href);

$Data::Dumper::Indent = 1;
$Data::Dumper::Sortkeys = \&sort_keys;
print Dumper($href);

