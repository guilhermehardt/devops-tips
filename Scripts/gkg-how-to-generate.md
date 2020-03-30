## How to generate PGP keys

### Requirements

- Linux
- GPG 2.2.20

### Steps

Checking the GPG version
```bash
$ gpg --help
```
Generating your key
```bash
$ gpg --gen-key
```
The output is something like this:
___
$ gpg --gen-key

gpg (GnuPG) 2.2.20; Copyright (C) 2020 Free Software Foundation, Inc.  
This is free software: you are free to change and redistribute it.  
There is NO WARRANTY, to the extent permitted by law.  

Note: Use "gpg --full-generate-key" for a full featured key generation dialog.

GnuPG needs to construct a user ID to identify your key.

***Enter the username:***  

Real name: **YOUR NAME**  
Email address: administrator@mail.com  
You selected this USER-ID:  
     "Administrator"  

***Select the letter 'O' to confirm***
Change (N)ame, (E)mail, or (O)kay/(Q)uit? **O**  

We need to generate a lot of random bytes. It is a good idea to perform  
some other action (type on the keyboard, move the mouse, utilize the  
disks) during the prime generation; this gives the random number  
generator a better chance to gain enough entropy.  
We need to generate a lot of random bytes. It is a good idea to perform  
some other action (type on the keyboard, move the mouse, utilize the  
disks) during the prime generation; this gives the random number  
generator a better chance to gain enough entropy.  


gpg: key 981D96508FE4E3F2 marked as ultimately trusted  
gpg: revocation certificate stored as '/home/user/.gnupg/openpgp-revocs.d/910C522821A0FDDE67D9D8F5981D96508FE4E3F2.rev'  
public and secret key created and signed.  

pub   rsa3072 2020-03-30 [SC] [expires: 2022-03-30]  
      910C522821A0FDDE67D9D8F5981D96508FE4E3F2  
uid                      Administrator  
sub   rsa3072 2020-03-30 [E] [expires: 2022-03-30]  
___
Listing your local keys
```bash
$ gpg -k
```
Export the gpg public key
```bash
$ gpg --output public-key.asc --export 'YOUR NAME'
```
