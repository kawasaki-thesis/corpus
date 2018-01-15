#!/usr/local/bin/perl
use LWP::Simple;
use XML::Simple;
use Data::Dumper;
$xml = XML::Simple->new;

#$str = "<p>Criterion (ii): The site of Timgad, with its Roman military camp, its model town-planning and its particular type of civil and military architecture reflects an important interchange of ideas, technologies and traditions exercised by the central power of Rome on the colonisation of the high plains of Antique Algeria.</p>\n
#<p>Criterion (iii): Timgad adopts the guidelines of Roman town-planning governed by a remarkable grid system. Timgad thus constitutes a typical example of an urban model, the permanence of the original plan of the military encampment having governed the development of the site throughout all the ulterior periods and still continues to bear witness to the building inventiveness of the military engineers of the Roman civilization, today disappeared. </p>\n
#<p>Criterion (iv): Timgad possesses a rich architectural inventory comprising numerous and diversified typologies, relating to the different historical stages of its construction: the defensive system, buildings for the public conveniences and spectacles, and a religious complex. Timgad illustrates a living image of Roman colonisation in North Africa over three centuries.</p>\n";
#@list=split(/\n/, $str);

$data = $xml->XMLin('data.xml');
#print Dumper($data);

$heritage_list_ref = $$data{row};
foreach $htg (@$heritage_list_ref){
	#$num = %{$_}{'id_number'}‚à‚ ‚é
	#$url = 'http://whc.unesco.org/en/list/' . $num;
	$url = %{$htg}{'http_url'};
	$html = get($url);
	@list = split(/\n/, $html);
	print $url;
	print "\n";
	foreach(@list){
		if(/<p>(<strong>)*Criterion\s*\(([ivx]+)\):/){
			if($2 eq "i"){$i=0;}
			elsif($2 eq "ii"){$i=1;}
			elsif($2 eq "iii"){$i=2;}
			elsif($2 eq "iv"){$i=3;}
			elsif($2 eq "v"){$i=4;}
			elsif($2 eq "vi"){$i=5;}
			elsif($2 eq "vii"){$i=6;}
			elsif($2 eq "viii"){$i=7;}
			elsif($2 eq "ix"){$i=8;}
			elsif($2 eq "x"){$i=9;}
			s/<p>(<strong>)*Criterion\s*\(([ivx]+)\):\s*//;
			s/<\/p>//;
			s/<\/strong>//;
			push(@{$txt[$i]}, $_);
		}
	}
}
$i=1;
foreach (@txt){
	$filename = "data/class" . $i . ".txt";
	open(DATAFILE, "+>>", $filename) or die("Error:$!");
	if(@{$_}){
		print DATAFILE join("\n", @{$_}) . "\n";
	}
	close(DATAFILE);
	$i++;
}


#end