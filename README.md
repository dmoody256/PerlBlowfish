PerlBlowfish
============

This package creates a encryptor object that uses the Blowfish Encryption
Algorithm. Blowfish is somehwat old and not the strongest encryption, but
is still very secure. One of the design goals of this package of the
Blowfish Encryption Algorithm was to not be dependent on any other 
packages and work with perl 5.8.3.

To use this package you must first use the New subroutine to build the 
encryptor object. You will need to pass the New an encryption key between
8 and 56 bytes long. If you do not supply one, one will be generated and
will be avialable by accessing the object 'key' hash key. 
e.g. my $key = $blowfish_object->{key};

Interface with the object requires only the Encrypt and Decrypt 
subroutines. All other subroutines are for internal use only.

Check the encryptiontest.pl for a use case example.
