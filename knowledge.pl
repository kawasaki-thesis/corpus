#!/usr/bin/perl
use Encode;
use utf8;

#binmode(STDOUT,":encoding(utf-8)");

#データのファイル数＝クラス数（本番は10
$fnum=10;

#各ファイルから名詞、固有名詞、動詞、形容詞を抽出して格納
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
#クラスごとのワードリストを、ワードごとにクラス評価がつくように変形
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
#頻出語をリスト化
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
#評価値を正規化
foreach (@corpus){
	@{$_}[0]='\'' . @{$_}[0] . '\'';
	$sum=0;
	for($i=0; $i<10; $i++) {$sum+=@{$_}[$i+1];}
	for($i=0; $i<10; $i++) {@{$_}[$i+1]=@{$_}[$i+1]/$sum;}
}
print "writing sql...\n";
#コーパスを標準出力
foreach (@corpus){
	$filename = "knowledge.sql";
	open(DATAFILE, "+>>", $filename) or die("Error:$!");
	print DATAFILE "INSERT INTO heritage_corpus VALUES(";
	print DATAFILE join(", ", @{$_});
	print DATAFILE ");";
	print DATAFILE "\n";
	#jをカンマで横に並べてi行表示
	close(DATAFILE);
}

#end
