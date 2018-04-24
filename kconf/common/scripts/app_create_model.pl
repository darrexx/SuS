#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
our $configuration;
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

sub create_type_feature{
	my ($types) =@_;
	my $text="";
	foreach my $t (keys %$types){
		if (ref $types->{$t} eq "ARRAY" ){
			my $a= $types->{$t};
			my @b=@$a;
			my $len=$#b + 1;
		}
	}
	return $text;
}

sub createInstance{
	my ($node,$path,$instanceName,$depends,$ilev)= @_;
	#make copy of node, because it will be changed in the next step
	my %copyOfNode = %$node;
	$node = \%copyOfNode;
	$node->{'name'}=~ s/\[self\]/$instanceName/ if(exists $node->{'name'});
	$node->{'prompt'}=~ s/\[self\]/$instanceName/ if(exists $node->{'prompt'}) ;
	$node->{'default'}=~ s/\[self\]/$instanceName/ if(exists $node->{'default'}) ;
	
	return createConfig ($node,$path,$instanceName,$depends,$ilev)
		 if( $node->{'template'} eq "config");
	return createConfig ($node,$path,$instanceName,$depends,$ilev)
		 if( $node->{'template'} eq "menuconfig");
	return createMenu ($node,$path,$instanceName,$depends,$ilev)
		 if( $node->{'template'} eq "menu");
	return createChoice ($node,$path,$instanceName,$depends,$ilev)
		 if( $node->{'template'} eq "choice");
	return createReferences ($node,$path,$instanceName,$depends,$ilev)
		 if( $node->{'template'} eq "references");
	
}
sub indentLine {
	my ($ilev, $str) = @_;
	my $ind= "\t" x $ilev;
	return "${ind}${str}\n";
}
sub joinDepends{
	my($a, $b)=@_;
	return $a.$b if($a eq "" or $b eq "");
	return "($a) && ($b)";
}
sub createMenu{
	my ($config,$path,$instanceName,$depends,$indent)= @_;
	
	my $ret="";
	
	my $dependencies= "";
	$dependencies = $config->{'depends'} if (exists $config->{'depends'});
	$dependencies =joinDepends($depends, $dependencies);
	
	$ret.=indentLine($indent,"menu \"$config->{'prompt'}\"");
	$ret .= indentLine($indent+1,"depends on $dependencies") 
		unless ($dependencies eq "");
	my $list=$config->{options};
	foreach my $child (@$list){
		my $newpath="${path}___$config->{name}";
		$ret.=createInstance($child,
			$newpath,$instanceName,"",$indent+1);
	}	
		
	$ret.=indentLine($indent,"endmenu");

}

sub createChoice{
	my ($config,$path,$instanceName,$depends,$indent)= @_;
	
	my $ret="";
	
	my $dependencies= "";
	$dependencies = $config->{'depends'} if (exists $config->{'depends'});
	my $fulldependencies =joinDepends($depends, $dependencies);

	$ret.=indentLine($indent,"choice");
	$ret.=indentLine($indent+1,"prompt \"$config->{'prompt'}\"");
	$ret .= indentLine($indent+1,"depends on $fulldependencies") 
		unless ($fulldependencies eq "");
	
	my $list=$config->{options};
	foreach my $child (@$list){
		my $newpath="${path}___$config->{name}";
		$ret.=createInstance($child,
			$newpath,$instanceName,"",$indent+1);
	}	
		
	$ret.=indentLine($indent,"endchoice");

}

sub createReferences {
		my ($config,$path,$instanceName,$depends,$indent)= @_;
	
	my $ret="";
	
	my $dependencies= "";
	$dependencies = $config->{'depends'} if (exists $config->{'depends'});
	$dependencies =joinDepends($depends, $dependencies);
	
	my $ilist=$configuration->{$config->{'list'}};
	#print Dumper($config);
	foreach my $iname(@$ilist){
		#my $idependencies =joinDepends("$config->{'list'}___$iname", $dependencies);
		my $idependencies = $dependencies;
		my $templatetype="config";
		$templatetype="menuconfig" if (exists $config->{options});
		$ret .= indentLine($indent,"$templatetype ${path}___$iname");
		$ret .= indentLine($indent+1,"bool \"$iname\"");
		$ret .= indentLine($indent+1,"depends on $idependencies") 
			unless ($idependencies eq "");
		
		$ret .= indentLine($indent+1,"default $config->{'default'}") 
			if (exists $config->{'default'} and $config->{'type'} ne "string");
		$ret .= indentLine($indent+1,"default \"$config->{'default'}\"") 
			if (exists $config->{'default'} and $config->{'type'} eq "string");
		if(exists $config->{options}){
			my $list=$config->{options};
			my $instanceName="${path}___$iname";
			foreach my $child (@$list){
				my $newpath="${path}___$iname";
				$ret.=createInstance($child,
					$newpath,$instanceName,$instanceName,$indent+1);
			}	
		}
		
	};	
	return $ret;

}


sub createConfig{
	my ($config,$path,$instanceName,$depends,$indent)= @_;
	
	my $ret="";
	
	my $dependencies= "";
	$dependencies = $config->{'depends'} if (exists $config->{'depends'});
	$dependencies =joinDepends($depends, $dependencies);
	
	$ret .= indentLine($indent,"$config->{template} ${path}___$config->{'name'}");
	$ret .= indentLine($indent+1,"$config->{'type'} \"$config->{'prompt'}\"");
	$ret .= indentLine($indent+1,"range $config->{'range'}")
		if (exists $config->{'range'});
	$ret .= indentLine($indent+1,"depends on $dependencies") 
		unless ($dependencies eq "");
	$ret .= indentLine($indent+1,"default $config->{'default'}") 
		if (exists $config->{'default'} and $config->{'type'} ne "string");
	$ret .= indentLine($indent+1,"default \"$config->{'default'}\"") 
		if (exists $config->{'default'} and $config->{'type'} eq "string");
		
	if($config->{template} eq "menuconfig"){
		my $list=$config->{options};
		foreach my $child (@$list){
			my $newpath="${path}___$config->{name}";
			$ret.=createInstance($child,
				$newpath,$instanceName,$newpath,$indent+1);
		}	
	}
	return $ret;

}
my $usage = "usage app_create_model.pl profil scheme feature-model \n";  

die $usage unless($#ARGV == 2);

my $x={ name=>"text" };
$configuration=load_file(shift);
my $sf=shift;
my $fm=shift;
my $output="menu \"System Objects\"\n";
my $scheme= load_file($sf);

foreach my $key ( keys %$configuration){
	my $instances= $configuration->{$key};
	$output.="menu \"$key\"\n";
	foreach my $instanceName (@$instances){
		if (exists $scheme->{$key}){
			#print "found $instanceName\n";
			$output.=createInstance($scheme->{$key},$key,$instanceName,"",1);
		}
		else{
			warn "No template for $key available";
		}
	}
	$output.="endmenu\n";
}
$output.= <<"eos";
config hasApplicationHeader
	bool \"Include application header\"
	default y
	config applicationHeaders
		depends on hasApplicationHeader
		string \"Application Headers\"
		default \"appcode.h\"
		help
			use semicolon separated list, if you wish to use more than one header-file
		depends on hasApplicationHeader
	
config hasHooksHeader
	bool \"Include hooks header\"
	default n
	config hooksHeaders
		depends on hasHooksHeader
		string \"Hooks Headers\"
		default \"hooks.h\"
		help
			use semicolon separated list, if you wish to use more than one header-file
		depends on hasHooksHeader
eos
$output.=create_type_feature($configuration);
$output.="\nendmenu\n";

my $file;
open ($file, ">", $fm) or die "cannot open $file" ;
print $file $output;
#print printConfig(2, $x);

