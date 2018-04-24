#!/usr/bin/perl

use strict;
use warnings;

use Data::Dumper;
use Tie::IxHash;
use File::Copy;
use File::Basename;
use File::Path;
use File::Spec;
use File::stat;
use Getopt::Std;

push @INC, dirname($0);
require 'generators.pl';

our $srcp;
our $configp;
our $arch;
our $configfile;
our $doLinks;

our $features;

sub touch_symlink {
	my $name=shift;
	my $fullconfigname="$configp/$name";
	#print "dest= $configp\\$name src=  $srcp\\$name\n";	
	mkpath(dirname($fullconfigname));
	my $abs_path = File::Spec->rel2abs( "$srcp/$name") ;
	symlink ("$abs_path",  "$fullconfigname") or print STDERR "omitting $name\n";
}

# reads in variant description (e.g. .config) and returns a
# hash mapping defined features to their values 
sub read_config {
	my $conffile=shift;
	my $line=0;
	my %features = ( );
	
	open (CONFIG, $conffile) or die "Cannot open .config: $!";
	my $t = tie(%features, 'Tie::IxHash');
	while(<CONFIG>){
		$line++;
		next if ( m/^\s*$/ || m/^\s*#/);
		chomp;
		unless ( m/^CONFIG_([^=]+)=/) {
			print STDERR "illegal syntax $conffile:$line: $_";
		}
		$features{$1}=$';
	}
	close CONFIG;
	
	return \%features;
}

# reads in a component tree (family model) and returns a hash ref to it
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

sub perform_feature_related_actions{
	no strict 'refs';
	my $joblist= shift;
	my $i;
	foreach (@$joblist ){
		#print Dumper ($_);
		my %family=%$_;
		my $action = $family{"action"};
		my $args = $family{"args"};
		#print "invoke $action\n";
		&$action ($args);
	}
	return 0; 


}
sub provide_item {
	my $p_self=shift;
	my $p_env=shift;
	my $filename= shift || $p_self->{'file'};
	
	my $src_root=$p_env->{'src_root'};
	my $target_root=$p_env->{'target_root'};
	
	my $path=$p_self->{'path'};
	
	# determine source and target directories
	my $src_path = exists($p_self->{'srcdir'}) ? $p_self->{'srcdir'} : $path;
	my $target_path = $path;
	
	# determine source and target filenames
	my $src_file = exists $p_self->{'srcfile'} ? $p_self->{'srcfile'} : $filename;
	my $target_file = $filename;
	
	# insert actual architecture if applicable
	$a=$p_env->{'arch'};
	$src_path =~ s/!ARCH/$a/;
	$target_path =~ s/!ARCH//;
	
	# create target dir
	mkpath("$target_root/$target_path/");
	
	# use arch indep file if arch specific file is not available
	if(!-e "$src_root/$src_path/$src_file" && -e "$src_root/$src_path/$a/$src_file") {
		$src_path="$src_path/$a";
	}

	my $sourceFullPath = "$src_root/$src_path/$src_file";
	my $targetFullPath = "$target_root/$target_path/$target_file";

	if( -d$sourceFullPath ) {
		generateDirectoryRecursive($sourceFullPath, $targetFullPath,$p_self);
	} else {
		generateTargetFile($sourceFullPath, $targetFullPath);
	}

}

sub generateDirectoryRecursive {
	my ($sourceFullPath, $targetFullPath, $p_self) = @_;

	unless ( opendir(DIRH, $sourceFullPath) ) {
		print STDERR "Failed to open directory $sourceFullPath\n";
		return;
	}
	my @entries = grep { !/^\./ } readdir(DIRH);
	closedir(DIRH);

	PROCESSENTRIES: foreach my $ent (@entries) {
		if(exists $p_self->{except_regexp}) {
			my $eregexp = $p_self->{except_regexp};
			$eregexp = [ $eregexp ] unless ref $eregexp;
			foreach my $regexp (@$eregexp) {
				next PROCESSENTRIES if $ent =~ /$regexp/;
			}
		}
		if(-d"$sourceFullPath/$ent") {
			generateDirectoryRecursive("$sourceFullPath/$ent", "$targetFullPath/$ent",$p_self);
		} else {
			generateTargetFile("$sourceFullPath/$ent", "$targetFullPath/$ent");
		}
	}

}
sub providePattern{
	my ($p_self, $p_env)=@_;
	
	my $src_root=$p_env->{'src_root'};
	my $path=$p_self->{'path'};
	my $src_path = exists($p_self->{'srcdir'}) ? $p_self->{'srcdir'} : $path;
	
	my $a=$p_env->{'arch'};
	
	
	return unless(exists $p_self->{'files'});
	
	# if files is an array, pass through
	if(ref( $p_self->{'files'})){
		return @{$p_self->{'files'}};
	}
	else{#  treats  'files' attribute as regexp if it is not a list (but a string)
		my @entries_arch;
		unless ( opendir(DIRH, "$src_root/$src_path") ) {
			print STDERR "Failed to open directory $src_root/$src_path\n";
			return;
		}
		my @entries = grep { !/^\./ } readdir(DIRH);
		closedir(DIRH);
		
		if(-e "$src_root/$src_path/$a"){
			unless ( opendir(DIRH, "$src_root/$src_path/$a") ) {
				print STDERR "Failed to open directory $src_root/$src_path/$a\n";
				return;
			} 
		
			@entries_arch = grep { !/^\./ } readdir(DIRH);
			closedir(DIRH);
		}
		my %tmp;
		$tmp{$_} = 1 foreach((@entries,@entries_arch));
		my $regex=$p_self->{'files'};
		my @allEntries =grep  m/$regex/ ,  keys %tmp;
		#print Dumper(\@allEntries);
		return @allEntries;
	}
}
sub generateTargetFile {
	my ($sourceFullPath, $targetFullPath) = @_;

	# generate base directory
	mkpath($&) if($targetFullPath =~ /.*\//);

	if($doLinks) {
		link($sourceFullPath, $targetFullPath) or print STDERR "Failed to create link $targetFullPath ($sourceFullPath): $!\n";
	} else {
#		my $targetExists=1;
#		my $sourceStat=lstat($sourceFullPath) or print STDERR "Failed to stat $sourceFullPath";
#		my $targetStat=lstat($targetFullPath) or $targetExists=0;
		#if(not $targetExists or($sourceStat->mtime > $targetStat->mtime )){
#		if(1) {
			if(-l $sourceFullPath) {
#				unless ($targetExists) {
					my $dest = readlink($sourceFullPath);
					symlink($dest, $targetFullPath);
#				}			
			} else {
				copy($sourceFullPath, $targetFullPath) or print STDERR "Failed to create $targetFullPath ($sourceFullPath): $!\n";
			}
#		}
	}
}

# traverse_cmp_tree(load_file('ciao_oscore.cmp.auto.pl'),'',0,'~','ciao');
sub traverse_cmp_tree {
	my ($tree, $path, $create, $basepath, $comp) = @_;
	
	my $generated=0;
	my $name='<unnamed>';
	
	# skip if dependencies are not met
	if (exists $tree->{'depends'}){
		my $access= eval ($tree->{'depends'}); warn $@ if $@;
		return unless $access;
	}

	# redefine path relative to root	
	if (exists $tree->{'dir'}){
		$path=$tree->{'dir'};
	}

	# redefine path relative to parent directory
	if (exists $tree->{'subdir'}) {
		$path="$path/".$tree->{'subdir'};
	}
	
	my $p_self=$tree;
	my $p_env= { arch=>$arch, target_root=>$configp, src_root=>$srcp };
	$p_self->{'path'}=$path;
	
	if (exists $tree->{'name'}){
		$name=$tree->{'name'};
	}
	
	if (exists $tree->{'generate'} && not $generated){
		mkpath "$configp/$path";
		my $gen;
		my $selfstring= Dumper($p_self);
		my $envstring= Dumper($p_env);
		$gen= eval ("my $selfstring;our \%self=\%\$VAR1;$envstring;our \%env=\%\$VAR1;$tree->{'generate'}"); warn $@ if $@;
		
		$generated=1;
		open (FILE, ">$configp/$path/$tree->{'file'}") or die "Cannot create $tree->{'file'}: $!";
		print FILE $gen;
		close FILE;
	}

	unless ( $generated ) {
		# 
		if (exists $tree->{'symlink'}) {
			$path="$path/".$tree->{'symlink'};
			touch_symlink ($path); 
		}

		if (exists $tree->{'create_symlink'}) {
			my $linkfile = "$configp/$path/".$tree->{'create_symlink'}->[1];
			my $dest = $tree->{'create_symlink'}->[0];
			symlink $dest, $linkfile or die "Cannot create symlink $linkfile: $!";
		}

		if (exists $tree->{'file'}) {
			provide_item ($p_self, $p_env, undef);
		}

		if (exists $tree->{'files'}) {
			if(exists $tree->{srcfile}) {
				warn "node $name: attributes files and srcfile are mutually exclusive\n";
			} else {
				#provide_item($p_self, $p_env, $_) foreach @{$tree->{files}};
				provide_item($p_self, $p_env, $_) foreach (providePattern($p_self, $p_env));
			}
		}
	}
	
	# visit child nodes
	if(exists $tree->{comp}) {
		traverse_cmp_tree($_,$path,$create,$basepath,$comp) foreach @{$tree->{comp}};
	}
}


sub AUTOLOAD{
	our $AUTOLOAD;
	my %feat= %$features;
	#print "$AUTOLOAD \n";
	$AUTOLOAD =~ s/:://;
	my $feature_name= $';
	
	#print " $feature_name = $feat{$feature_name}\n";
	
	return $feat{$feature_name};

}

my %cmd_args;

getopts('lo:i:a:f:m:', \%cmd_args);

foreach my $reqparm (qw(o i a f m)) {
	unless(exists $cmd_args{$reqparm}) {
		print STDERR <<EOUSAGE;
Usage: $0 -[afimo] <param> [-l]
-a: architecture (e.g., _tc, _x86)
-f: configuration file with feature selection
-i: input directory
-l: generate hardlinks instead of copying files
-m: family models, separated by :
-o: output directory

Required parameter -$reqparm was not specified.
EOUSAGE
		exit 1;
	}
}

my $familyModelList = [ split(':', $cmd_args{'m'}) ];

$configfile=$cmd_args{'f'};
$srcp=$cmd_args{'i'};
$configp=$cmd_args{'o'};
$arch=$cmd_args{'a'};
$doLinks=$cmd_args{'l'};

rmtree( $configp,0,1);
if(-e $configp){
	print STDERR "could not delete configdir \"$configp\"\n";
	exit(1);
}

$features=read_config($configfile);
my $familyModel;
foreach $familyModel(@$familyModelList){
	traverse_cmp_tree(load_file( $familyModel),'',0,'~','ciao');
}

