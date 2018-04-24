#!/usr/bin/perl

use strict;
use warnings;
use Tie::IxHash;
use Data::Dumper;

sub xmlDumpAppMode{
	my ($cmpname,$data) = @_;
	my $text="";
	$text .= "\t<applicationmode name=\"$cmpname\">\n";
	if ( ref($data) and exists $data->{'autostart'}){
		$text.= "\t\t<autostarttasks>\n";
	
		my $autostart=$data->{'autostart'};
		foreach my $name (keys %$autostart){
			$text.= "\t\t\t<taskref name=\"$name\"/>\n";	
		}
		$text.="\t\t</autostarttasks>\n";
	}
	$text.="\t</applicationmode>\n";
	return $text;
}
sub xmlDumpComponent{
	my ($cmpname,$data,$map) = @_;
	my $text="";
	$text .= "\t<component name=\"$cmpname\">\n";
	
	my $tasks=getInstByAttributeVal($map,'usesComponent',$cmpname);
	foreach my $name (@$tasks){
		$text.="\t\t<taskref name=\"$name\"/>\n";
	}
	my $isrs=getInstByAttributeVal($map,'isrUsedByComponent',$cmpname);
	foreach my $name (@$isrs){
		$text.="\t\t<isrref name=\"$name\"/>\n" if($name ne  'none');
	}
	
	my $senderport=getInstByAttributeVal($map,'senderportref',$cmpname);
	foreach my $name (@$senderport){
		$text.="\t\t<senderport name=\"$name\"/>\n" if ($name ne "none");
	}
	
	my $receiverport=getInstByAttributeVal($map,'receiverportref',$cmpname);
	foreach my $name (@$receiverport){
		$text.="\t\t<receiverport name=\"$name\"/>\n" if ($name ne "none");
	}
	#print "_>>".Dumper($data)."\n";
	if (ref($data) and exists $data->{'componentRefShm'}){
		my $shm=$data->{'componentRefShm'};
		foreach my $name (keys %$shm){
			my $idata= $shm->{$name};
			
			my $mode= from_selection($idata,'mode');
			$text.= "\t\t\t<shmref name=\"$name\" mode=\"$mode\" />\n";	
			
		}
	}
	$text.="\t</component>\n";
	#print "endcmo\n";
	return $text;
}
sub from_selection{
	my ($data, $key)=@_;
	my $val=  $data->{$key};
	my @vals= keys %$val;
	
	return $vals[0];
}
sub xmlDumpTask{
	my ($cmpname,$data) = @_;
	my $text="";
	$text .= "\t<task name=\"$cmpname\"\n";
	$text.= "\t\tpriority=\"$data->{'priority'}\"\n";
	$text.= "\t\tactivation=\"$data->{'activation'}\"\n" if (exists $data->{'activation'});
	my $schedule=from_selection($data,"schedule");
	$text.= "\t\tschedule=\"$schedule\"\n" if (exists $data->{'schedule'});
	$text.= "\t\tstacksize=\"$data->{'stacksize'}\"";
	$text.=">\n";
	foreach my $eve (keys %{$data->{usesEvent}}) {
		$text .= "\t\t<eventref name=\"$eve\" />\n";
	}
	$text.="\t</task>\n";
	return $text;
}
sub xmlDumpIsr{
	my ($cmpname,$data) = @_;
	my $text="";
	$text .= "\t<isr name=\"$cmpname\"\n";
	$text.= "\t\tcategory=\"$data->{'category'}\"\n";
	$text.= "\t\tfunction=$data->{'function'}\n";
	$text.= "\t\tdevice=$data->{'device'}";
	$text.="/>\n";
	return $text;
}
sub xmlDumpNetPort{
	my ($cmpname,$data) = @_;
	my $text="";
	$text .= "\t<networkport name=\"$cmpname\"\n";
	$text.= "\t\tport=\"$data->{'port'}\"\n";
	my $taskref = from_selection($data, 'taskref');
	my $rp = from_selection($data, 'reciverPort');
	my $sp = from_selection($data, 'senderPort'); 
	$text.= "\t\ttaskref=\"$taskref\"\n";
	$text.= "\t\tsenderport=\"$sp\"\n";
	$text.= "\t\treceiverport=\"$rp\"";
	$text.="/>\n";
	return $text;
}
sub xmlDumpApp{
	my ($cmpname,$data,$map) = @_;
	my $text="";
	$text .= "\t<osapplication name=\"$cmpname\" ";
	if(exists $data->{'trusted'}) {
		$text .= "trusted=\"true\"";
	} else {
		$text .= "trusted=\"false\"";
	}
	$text .= ">\n";
	
	#my $comp=$data->{'uses'};
	#foreach my $name (keys %$comp){
	#	$text.= "\t\t<componentref name=\"$name\"/>\n";	
	#}
	my $comp=getInstByAttributeVal($map,'componentRefApp',$cmpname);
	foreach my $name (@$comp){
		$text.= "\t\t<componentref name=\"$name\"/>\n";	
	}
	
	$text.="\t</osapplication>\n";
	return $text;
}
sub xmlDumpMsgPort{
	my ($cmpname,$data) = @_;
	my $text="";
	$text .= "\t<messageport name=\"$cmpname\"\n";
	$text.= "\t\tmsgctype=$data->{'msgctype'}\n";
	$text.= "\t\tmsgcount=\"$data->{'msgcount'}\"\n";
	$text.= "\t\tmsgcheaderfile=$data->{'msgcheaderfile'}";
	$text.="/>\n";
	return $text;
}
sub xmlDumpCounter {
	my ($cmpname,$data) = @_;
	my $text="";
	$text .= "\t<counter name=\"$cmpname\"\n";
	$text.= "\t\tmaxallowedvalue=\"$data->{'maxallowedvalue'}\"\n";
	$text.= "\t\tticksperbase=\"$data->{'ticksperbase'}\"\n";
	$text.= "\t\tmincycle=\"$data->{'mincycle'}\"\n";
	$text.="/>\n";
	return $text;
}

sub xmlDumpAlarm{
	my ($cmpname,$data) = @_;
	my $text="";
	$text .= "\t<alarm name=\"$cmpname\"\n";
	$text.= "\t\tcounterref=\"" . (keys %{$data->{'basedOnCounter'}})[0] . "\"\n";
	$text.= "\t\tarmed=\"false\"\n" if(not exists $data->{'armed'}); 
	$text.= "\t\tarmed=\"true\"\n" if(exists $data->{'armed'}); 
	$text.= "\t\tabsolutetime=\"$data->{'absolutelifetime'}\"\n";
	my $at = from_selection($data->{'activatetask'}, 'task');
	$text.= "\t\tcycletime=\"$data->{'cycletime'}\"\n";
	$text.= "\t\tactivatetask=\"true\"\n" if(exists $data->{'activatetask'});
	my $ev = from_selection($data->{'setevent'}, 'event');
	$text.= "\t\tsetevent=\"true\"\n" if(exists $data->{'setevent'});
	$text.= "\t\tevent=\"$ev\"\n" if(exists $data->{'setevent'});
	$text.= "\t\ttask=\"$at\"";
	$text.="/>\n";
	return $text;
}

sub xmlDumpStartupHook{
	my ($cmpname,$data) = @_;
	return "\t<startuphook name=\"$cmpname\"/>\n";
}
sub xmlDumpSharedMemory{
	my ($cmpname,$data) = @_;
	my $text="";
	$text .= "\t<sharedmemory name=\"$cmpname\"\n";
	$text.= "\t\tcheaderfile=$data->{'cheaderfile'}\n";
	$text.= "\t\tctype=$data->{'ctype'}\n";
	$text.="/>\n";
	return $text;
}

sub generateXmlFile{
	my ($data,$fx)=@_;
	
	my $text =<<"eos";
<?xml version=\"1.0\"?>

<ciaoApp	name=\"Simple\"
			xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"
			xsi:noNamespaceSchemaLocation=\"../../../../tools/xml/ciaoApp.xsd\">

eos
	my $decl;
	
	$decl = $data->{'appmode'};
	foreach my $name (keys %$decl){
		$text .= xmlDumpAppMode($name,$decl->{$name});
	}
	
	$decl = $data->{'task'};
	foreach my $name (keys %$decl){
		$text .= xmlDumpTask($name,$decl->{$name});
	}
	
	$decl = $data->{'isr'};
	foreach my $name (keys %$decl){
		$text .= xmlDumpIsr($name,$decl->{$name});
	}
	$decl = $data->{'component'};
	foreach my $name (keys %$decl){
		$text .= xmlDumpComponent($name,$decl->{$name},$data);
	}
	$decl = $data->{'alarm'};
	foreach my $name (keys %$decl){
		$text .= xmlDumpAlarm($name,$decl->{$name},$data);
	}
	$decl = $data->{'counter'};
	foreach my $name (keys %$decl){
		$text .= xmlDumpCounter($name,$decl->{$name},$data);
	}
	$decl = $data->{'osapplication'};
	foreach my $name (keys %$decl){
		$text .= xmlDumpApp($name,$decl->{$name},$data);
	}
	$decl = $data->{'event'};
	foreach my $name (keys %$decl){
		$text .= "\t<event name=\"$name\"/>\n";
	}
	$decl = $data->{'startupHook'};
	foreach my $name (keys %$decl){
		$text .= xmlDumpStartupHook($name,$decl->{$name},$data);
	}
	
	$decl = $data->{'msgPort'};
	foreach my $name (keys %$decl){
		$text .= xmlDumpMsgPort($name,$decl->{$name});
	}
	
	$decl = $data->{'netPort'};
	foreach my $name (keys %$decl){
		$text .= xmlDumpNetPort($name,$decl->{$name});
	}
	
	$decl = $data->{'sharedmemory'};
	foreach my $name (keys %$decl){
		$text .= xmlDumpSharedMemory($name,$decl->{$name});
	}
	

	if(exists $fx->{'hooksHeaders'}){
		$text.="\t<hooksheaders>\n";
		$fx->{'hooksHeaders'} =~ s/\"//g ;
		my @header_list=split(/;/,$fx->{'hooksHeaders'});
		foreach my $header(@header_list){
			$header =~ s/^\s+//;
			$header =~ s/\s+$//;

			$text.="\t\t<hooksheader name=\"$header\"/>\n"
		}
		
		$text.="\t</hooksheaders>\n";
	
	}
	if(exists $fx->{'applicationHeaders'}){
		$text.="\t<applicationheaders>\n";
		$fx->{'applicationHeaders'} =~ s/\"//g ;
		my @header_list=split(/;/,$fx->{'applicationHeaders'});
		foreach my $header(@header_list){
			$header =~ s/^\s+//;
			$header =~ s/\s+$//;

			$text.="\t\t<applicationheader name=\"$header\"/>\n"
		}
		
		$text.="\t</applicationheaders>\n";
	
	}
	$text.="</ciaoApp>\n";

	return $text;
}
sub find_all{ 
	my ($map, $name,$parent) = @_;
	my $result=[];
	my $parents=[];
	$parent = "" unless (defined $parent);
	foreach my $key (%$map){
		#print "$key\n";
		if($key eq $name){
			push @$result, $map->{$key};
			push @$parents, $parent;
		}
		elsif (ref($map->{$key}) eq "HASH"){
			my ($inh,$inhp)=find_all($map->{$key},$name, $key);
			push @$result,@$inh;
			push @$parents,@$inhp;		
		}
	
	}
	return ($result,$parents);

}
sub getAttribute{
	my ($map,$instName, $attribName)=@_;
	my @attribVals;
	my ($relAttrib, $relInst)=find_all($map,$attribName);
	my $c=0;
	foreach my $i (@$relInst){
		push @attribVals,$relAttrib->[$c++] if($i eq $instName);	
	}
	return \@attribVals;
}
sub getInstByAttributeVal{
	my ($map, $attribName, $attribVal)=@_;
	my @inst;
	my ($relAttrib, $relInst)=find_all($map,$attribName);
	my $c=0;
	foreach my $i (@$relAttrib){
		if (exists $i->{$attribVal}){
			push @inst, $relInst->[$c];
		}
		$c++;
	}
	return \@inst;
}

sub multimap{
	my ($map, $key, $val) = @_;

	if(exists $map->{$key}){
		unless (ref($map->{$key}) eq ('ARRAY')){
			$map->{$key}=[$map->{$key}];
		}
	}
	else{
	
		$map->{$key} = [];
	}
	my $array = $map->{$key};
	push @$array, $val;
	
}


sub accumulate{
	my ($list, $raw, $depth)=@_;
	my $result = {};
	my $todo ={};
	foreach my $line (@$list){
		
		my @key_list=split(/___/,$line);
		
		if($#key_list == $depth){
			$result->{$key_list[$depth]}=$raw->{$line};
		}
		else{
			
			multimap($todo,$key_list[$depth], $line);
		}
	}
	
	foreach my $subkey ( keys %$todo){
		my $subval=accumulate($todo->{$subkey},$raw, $depth+1);
		$result->{$subkey}=$subval;
		
	}
	return $result;

}
sub filter {
	my ($data, $scheme)=@_;
	my $hash= {};
	foreach my $line (keys %$data){
		my @vals=split (/_/, $line);
		my $primkey=$vals[0];
		$hash->{$line}=$data->{$line} if exists $scheme->{$primkey};
	
	}
	return $hash;
 
}
sub generate_xml_appconf{
	#my $usage="usage: app_transform configfile xmloutfile scheme\n";
	my ($cf,$sf)=@_ ;
	#unless($#ARGV==2){
	#	print STDERR $usage;
	#	exit(1);	
	#}

	my $fx=read_config($cf);
	my $scheme=load_file($sf);

	my $selection=filter($fx,$scheme);

	my @keys=keys %$selection;
	my $res=accumulate(\@keys,$fx,0);
	#print Dumper($res);
	#print "$fx->{'hooksHeaders'}\n";

	return generateXmlFile($res, $fx);
}

1;



