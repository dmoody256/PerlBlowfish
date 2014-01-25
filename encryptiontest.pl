#!/usr/bin/perl -w

use strict;
use Blowfish;
use MIME::Base64;
use Time::HiRes qw(gettimeofday);
use Digest::MD5 qw(md5_base64);

$|++;

my $blowfish = Blowfish->New();
my $key = $blowfish->{key};
$blowfish->EncodeHex(1);
my $blowfish2 = Blowfish->New($key);
$blowfish2->EncodeHex(1);

my $data = 0;
my $starttime = gettimeofday();

for my $count (0..1000){

	my $plaintext = MakeText();
	$data += length($plaintext);
    my $ciphertext = $blowfish->Encrypt($plaintext);

    my $result = $blowfish2->Decrypt($ciphertext);

    if($plaintext eq $result){
    	print "\b\b\b\b\b\b\b\b$count";
    }
    else{
    	print "\nplaintxt = $plaintext\n". $result;
    	die "\ndid not match!";
    }

}

my $time = gettimeofday() - $starttime;
my $rate = Format($data/$time);
$data = Format($data);

print "\nTunneled ${data}s in $time seconds at a rate of $rate/s\n";

sub Format{
	my $rate = shift;

	if($rate < 1024){

		$rate = sprintf ("%.2f", $rate);
		$rate .= " B";
		return $rate;
	}
	elsif($rate < 1048576){

		$rate = sprintf ("%.2f", $rate/1024);
		$rate .= " KB";
		return $rate;
	}
	elsif($rate < 1073741824){

		$rate = sprintf ("%.2f", $rate/1048576);
		$rate .= " MB";
		return $rate;
	}
	else{

		$rate = sprintf ("%.2f", $rate/1073741824);
		$rate .= " GB";
		return $rate;
	}
}

sub MakeText{

	my $random = '';

	for my $count (0..20){
		$random .= md5_base64(encode_base64(int rand(100000)));
	}
	
    return $random;
}