#!/usr/bin/perl

use strict;
use warnings;

my $file = shift or die "usage: update_config.pl *.config";
my $keys={
	isr=>["PSISR"],	
	task=>["FSMTask"],
	component=>["FSM"],
	msgPort=>[],
	netPort=>[],
	'alarm'=>['SystemAlarm'],
	startupHook=>["UserStartupHook"],
	osapplication=>["LukasApp"],
	appmode=>["OSDEFAULTAPPMODE"],
	event=>[],

};
my $text="";
my $inp;
open($inp,'<',$file) or die "cannot open $file";
my $row;
while  ($row = <$inp>){
	#my $old=$row;
	my @keyval=split(/=/,$row);
	if($#keyval==1){
		my $k=$keyval[0];
		my $v=$keyval[1];
		my @splited=split(/\_/, $k);
		if( $#splited>=1 and $splited[0] eq "CONFIG" and exists $keys->{$splited[1]}){
			$k =~ s/_/___/g;
			$k =~ s/___/_/;
		
		}
		$row= $k."=".$v;
	}
	
	$text.= $row;
}

close $inp;
my $outp;
open($outp,'>',$file) or die "cannot open $file";
print $outp $text;
close($outp);


