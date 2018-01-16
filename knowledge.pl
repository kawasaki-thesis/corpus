#!/usr/bin/perl
use Encode;
use utf8;

#binmode(STDOUT,":encoding(utf-8)");

#�f�[�^�̃t�@�C�������N���X���i�{�Ԃ�10
$fnum=10;

#�e�t�@�C�����疼���A�ŗL�����A�����A�`�e���𒊏o���Ċi�[
for($i=0; $i<$fnum; $i++){
	$j=0;
	$inputfile = "data/words" . ($i+1) . ".txt";
	open(IN,$inputfile) || die "$!";
	#binmode(IN,":encoding(euc-jp)");
	print "$inputfile\n";
	while(<IN>){
		chomp;
		@list = split(/\t/);
		
		if($list[1] =~ /NN|VV|JJ|NP/){
			$words[$i][$j] = $list[2];
			$j++;
		}
	}
	close(IN);
}
print "took corpus...\n";
#�N���X���Ƃ̃��[�h���X�g���A���[�h���ƂɃN���X�]�������悤�ɕό`
for($i=0; $i<$fnum; $i++){
	for($j=0; $j<=$#{$words[$i]}; $j++){
		$flag=0;
		foreach(@corpus){
			if(@{$_}[0] eq $words[$i][$j]){
				$flag=1;
				@{$_}[($i+1)]++;
				break;
			}
		}
		if($flag==0){
			$str=$words[$i][$j];
			push(@corpus, [$str,0,0,0,0,0,0,0,0,0,0]);
			$corpus[$#corpus][($i+1)]++;
		}
	}
}

print "making list...\n";
#�p�o������X�g��
foreach (@corpus){
	$str = @{$_}[0];
	$sum=0;
	for($i=0; $i<10; $i++) {$sum+=@{$_}[$i+1];}
	$hash{$str} = $sum;
}
print "writing list...\n";
for my $key (sort {$hash{$b} <=> $hash{$a} || $a cmp $b} keys %hash) {
	$filename = "htmllist.txt";
	open(DATAFILE, "+>>", $filename) or die("Error:$!");
	print DATAFILE "<li>" . $key . " : " . $hash{$key} . "</li>\n";
	close(DATAFILE);
}

print "shape data...\n";
#�]���l�𐳋K��
foreach (@corpus){
	@{$_}[0]='\'' . @{$_}[0] . '\'';
	$sum=0;
	for($i=0; $i<10; $i++) {$sum+=@{$_}[$i+1];}
	for($i=0; $i<10; $i++) {@{$_}[$i+1]=@{$_}[$i+1]/$sum;}
}
print "writing sql...\n";
#�R�[�p�X��W���o��
foreach (@corpus){
	$filename = "knowledge.sql";
	open(DATAFILE, "+>>", $filename) or die("Error:$!");
	print DATAFILE "INSERT INTO heritage_corpus VALUES(";
	print DATAFILE join(", ", @{$_});
	print DATAFILE ");";
	print DATAFILE "\n";
	#j���J���}�ŉ��ɕ��ׂ�i�s�\��
	close(DATAFILE);
}

#end
