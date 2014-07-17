#!/usr/bin/perl -w

=pod

=head1 EncryptionTest

This script will test the Blowfish module imported below. It
attempts to encrypt and decrypt a 1000 strings of data and 
records several statistics.

=cut

use strict;
use Blowfish;
use MIME::Base64;
use Time::HiRes qw(gettimeofday);
use Digest::MD5 qw(md5_base64);

# we will be updating the current number
# so better autoflush stdout
$|++;

# create a new blowfish object
my $blowfish = Blowfish->New();

# save the key
my $key = $blowfish->{key};

# turn on encoding
#$blowfish->EncodeHex(1);

# create another blowfish object for decryption
my $blowfish2 = Blowfish->New($key);

# turn on encoding
#$blowfish2->EncodeHex(1);

# initilize some variables for statistics recording
my $data = 0;
my $starttime = gettimeofday();
my $bigstring = '';

# 
for my $count (0..1000){

	# make some data to encrypt
	my $plaintext = MakeText();

	# save it for a big string test later
	$bigstring .= $plaintext;

    # keep track of the data we are handling
	$data += length($plaintext);

    # encrypt the plaintext
    my $ciphertext = $blowfish->Encrypt($plaintext);
	
	# and then decrypt it
    my $result = $blowfish2->Decrypt($ciphertext);

    # report the results
    if($plaintext eq $result){
    	print "\b\b\b\b\b\b\b\b$count";
    }
    else{
    	print "\nplaintxt = $plaintext\n". $result;
    	die "\ndid not match!";
    }

}

print "\nLoop test passed, starting bigstring test...\n";

# now fort eh bigstring test
my $ciphertext = $blowfish->Encrypt($bigstring);
my $result = $blowfish2->Decrypt($ciphertext);

# report the results
if($bigstring eq $result){
	print("Success!\n")
}
else{
	die "\nbigtext failed!";
}

# do some calculations for stats
my $time = sprintf ("%.2f", gettimeofday() - $starttime);
my $rate = Format($data*2/$time);
$data = Format($data*2);

print "\nTunneled ${data}s in $time seconds at a rate of $rate/s\n";

sub Format{
	my $rate = shift;

	if($rate < 1024){ # bytes

		$rate = sprintf ("%.2f", $rate);
		$rate .= " B";
		return $rate;
	}
	elsif($rate < 1048576){ #kilobytes

		$rate = sprintf ("%.2f", $rate/1024);
		$rate .= " KB";
		return $rate;
	}
	elsif($rate < 1073741824){ # megabytes

		$rate = sprintf ("%.2f", $rate/1048576);
		$rate .= " MB";
		return $rate;
	}
	else{ # gigabytes

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

=pod

=head1 Copyright and License

 This is free and unencumbered software released into the public domain.
 
 Anyone is free to copy, modify, publish, use, compile, sell, or
 distribute this software, either in source code form or as a compiled
 binary, for any purpose, commercial or non-commercial, and by any
 means.
 
 In jurisdictions that recognize copyright laws, the author or authors
 of this software dedicate any and all copyright interest in the
 software to the public domain. We make this dedication for the benefit
 of the public at large and to the detriment of our heirs and
 successors. We intend this dedication to be an overt act of
 relinquishment in perpetuity of all present and future rights to this
 software under copyright law. 
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
 OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
 ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.

 For more information, please refer to <http://unlicense.org>

=cut