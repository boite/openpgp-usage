# Introduction

You will need:-
- a non-networked workstation
- GnuPG >= 1.4.10 (use the latest version if you possibly can)
- 4 USB sticks, preferably labelled: revcert; master; keys and unsafe, which
  you will mount in directories named with the corresponding labels under
  `/media`, i.e. `/media/revcert`, etc.
- to think about a good strong "passphrase" to protect your private keyrings
- a networked workstation (only for obtaining a copy of the GnuPG configuration
  file)

There is [some background][background] should you want more information about
what results from following these instructions.

It's a good idea to perform the following steps in a LiveCD environment so that
there is no question of any secret key material being stored anywhere other
than on the USB memory sticks.  A LiveCD with a graphical window system (such
as any of the Desktop flavours of popular linux distributions) will make it
easier to use a mouse and keyboard during key generation, so that the system
can generate sufficient random numbers.  Shut down the LiveCD when you've
completed these steps and *before* you reconnect to a network.


# Steps

- Prepare USB memory sticks
  - Partition and Format USB memory sticks
  - Get a copy of a GnuPG configuration file
  - Mount the USB memory sticks
  - Prepare the `master` USB stick for key generation
- Create Master signing and certification key and an encryption subkey
- Add a signing subkey
- Generate Revocation Certificate
- Copy keyrings to the daily-use USB stick
- Unmount and remove the `master` and `revcert` USB sticks
- Remove the private master key from the daily-use keyring
- Make the exported public key (certificate) available for publishing
- Remove the backup secret keyring from the daily-use USB stick


## Prepare USB memory sticks

### Partition and Format USB memory sticks

[Partition and format][format_usb] 4 USB memory sticks with the FAT32 file
system for good portability, with labels: `master`, `revcert`, `keys` and
`unsafe`:

- `master` stores the Master Identity key along with your other secret keys and
  public keys.  You will keep this very very safe and use it infrequently.
- `revcert` stores a Revocation Certificate to be used if you lose control of
  `master`. You will keep this very very safe and physically apart from
  `master`.
- `keys` stores your daily-use keyrings, that is, all of the keys from `master`
  except the Master Identity key. You will keep this very safe, but use it
  frequently.
- `unsafe` is for moving data between a secure workstation and an insecure
  workstation.



### Get a copy of a GnuPG configuration file

Copy [gpg.conf][gpg_conf] to the `unsafe` USB stick.


### Mount the USB memory sticks

Create four directories under `/media`, corresponding to the labels of the four
USB memory sticks.
[Set the proper permissions and mount the USB sticks][mount_usb].


### Prepare the `master` USB stick for key generation

    me@box:~$ cp /media/unsafe/gpg.conf /media/master/
    me@box:~$ echo lock-never >> /media/master/gpg.conf
    me@box:~$ export GNUPGHOME=/media/master


## Create Master signing and certification key and an encryption subkey

    me@box:~$ gpg --gen-key
    gpg (GnuPG) 1.4.11; Copyright (C) 2010 Free Software Foundation, Inc.
    This is free software: you are free to change and redistribute it.
    There is NO WARRANTY, to the extent permitted by law.

    gpg: keyring `/media/master/secring.gpg' created
    gpg: keyring `/media/master/pubring.gpg' created
    Please select what kind of key you want:
       (1) RSA and RSA (default)
       (2) DSA and Elgamal
       (3) DSA (sign only)
       (4) RSA (sign only)
    Your selection? 1
    RSA keys may be between 1024 and 4096 bits long.
    What keysize do you want? (2048) 4096
    Requested keysize is 4096 bits
    Please specify how long the key should be valid.
             0 = key does not expire
          <n>  = key expires in n days
          <n>w = key expires in n weeks
          <n>m = key expires in n months
          <n>y = key expires in n years
    Key is valid for? (0) 5y
    Key expires at Thu 13 Dec 2018 09:20:58 PM GMT
    Is this correct? (y/N) y

    You need a user ID to identify your key; the software constructs the user ID
    from the Real Name, Comment and Email Address in this form:
        "Heinrich Heine (Der Dichter) <heinrichh@duesseldorf.de>"

    Real name: My Full Name
    Email address: me@domain.example.com
    Comment:
    You selected this USER-ID:
        "My Full Name <me@domain.example.com>"

    Change (N)ame, (C)omment, (E)mail or (O)kay/(Q)uit? o
    You need a Passphrase to protect your secret key.

    We need to generate a lot of random bytes. It is a good idea to perform
    some other action (type on the keyboard, move the mouse, utilize the
    disks) during the prime generation; this gives the random number
    generator a better chance to gain enough entropy.
    +++++
    ........+++++
    We need to generate a lot of random bytes. It is a good idea to perform
    some other action (type on the keyboard, move the mouse, utilize the
    disks) during the prime generation; this gives the random number
    generator a better chance to gain enough entropy.
    ...+++++
    .....................+++++
    gpg: /media/master/trustdb.gpg: trustdb created
    gpg: key 0xF1829BDBB6B64480 marked as ultimately trusted
    public and secret key created and signed.

    gpg: checking the trustdb
    gpg: 3 marginal(s) needed, 1 complete(s) needed, PGP trust model
    gpg: depth: 0  valid:   1  signed:   0  trust: 0-, 0q, 0n, 0m, 0f, 1u
    gpg: next trustdb check due at 2013-12-13
    pub   4096R/0xF1829BDBB6B64480 2013-12-14 [expires: 2013-12-13]
          Key fingerprint = 318F B9C5 52E7 E930 0FC4  1068 F182 9BDB B6B6 4480
    uid                 [ultimate] My Full Name <me@domain.example.com>
    sub   4096R/0xFDB32668D55D0A12 2013-12-14 [expires: 2013-12-13]

    me@box:~$


## Add a signing subkey

Note the master key ID from the previous step, in this example it is:-
`0xF1829BDBB6B64480`

    me@box:~$ gpg --edit-key  0xF1829BDBB6B64480
    gpg (GnuPG) 1.4.11; Copyright (C) 2010 Free Software Foundation, Inc.
    This is free software: you are free to change and redistribute it.
    There is NO WARRANTY, to the extent permitted by law.

    Secret key is available.

    pub  4096R/0xF1829BDBB6B64480  created: 2013-12-14  expires: 2013-12-13  usage: SC
                                   trust: ultimate      validity: ultimate
    sub  4096R/0xFDB32668D55D0A12  created: 2013-12-14  expires: 2013-12-13  usage: E
    [ultimate] (1). My Full Name <me@domain.example.com>

    gpg> addkey
    Key is protected.

    You need a passphrase to unlock the secret key for
    user: "My Full Name <me@domain.example.com>"
    4096-bit RSA key, ID 0xF1829BDBB6B64480, created 2013-12-14

    Please select what kind of key you want:
       (3) DSA (sign only)
       (4) RSA (sign only)
       (5) Elgamal (encrypt only)
       (6) RSA (encrypt only)
    Your selection? 4
    RSA keys may be between 1024 and 4096 bits long.
    What keysize do you want? (2048) 4096
    Requested keysize is 4096 bits
    Please specify how long the key should be valid.
             0 = key does not expire
          <n>  = key expires in n days
          <n>w = key expires in n weeks
          <n>m = key expires in n months
          <n>y = key expires in n years
    Key is valid for? (0) 5y
    Key expires at Thu 13 Dec 2018 09:22:19 PM GMT
    Is this correct? (y/N) y
    Really create? (y/N) y
    We need to generate a lot of random bytes. It is a good idea to perform
    some other action (type on the keyboard, move the mouse, utilize the
    disks) during the prime generation; this gives the random number
    generator a better chance to gain enough entropy.
    ......+++++
    ..............+++++

    pub  4096R/0xF1829BDBB6B64480  created: 2013-12-14  expires: 2013-12-13  usage: SC
                                   trust: ultimate      validity: ultimate
    sub  4096R/0xFDB32668D55D0A12  created: 2013-12-14  expires: 2013-12-13  usage: E
    sub  4096R/0xC3897294DD857167  created: 2013-12-14  expires: 2013-12-13  usage: S
    [ultimate] (1). My Full Name <me@domain.example.com>

    gpg> save

    me@box:~$


## Generate Revocation Certificate

The public keys generated thus far are all bound to (self-signed by) the
master private signing key (our master identity key). Losing control of the
master private signing key necessarily requires revocation of all its bound
public keys. This is the purpose of this revocation certificate.

    me@box:~$ gpg -o /media/revcert/revcert_F1829BDBB6B64480.asc --gen-revoke 0xF1829BDBB6B64480

    sec  4096R/0xF1829BDBB6B64480 2013-12-14 My Full Name <me@domain.example.com>

    Create a revocation certificate for this key? (y/N) y
    Please select the reason for the revocation:
      0 = No reason specified
      1 = Key has been compromised
      2 = Key is superseded
      3 = Key is no longer used
      Q = Cancel
    (Probably you want to select 1 here)
    Your decision? 1
    Enter an optional description; end it with an empty line:
    >
    Reason for revocation: Key has been compromised
    (No description given)
    Is this okay? (y/N) y

    You need a passphrase to unlock the secret key for
    user: "My Full Name <me@domain.example.com>"
    4096-bit RSA key, ID 0xF1829BDBB6B64480, created 2013-12-14

    ASCII armored output forced.
    Revocation certificate created.

    Please move it to a medium which you can hide away; if Mallory gets
    access to this certificate he can use it to make your key unusable.
    It is smart to print this certificate and store it away, just in case
    your media become unreadable.  But have some caution:  The print system of
    your machine might store the data and make it available to others!
    me@box:~$


## Copy keyrings to the daily-use USB stick

Copy the keyrings, trust database and GnuPG configuration to `/media/keys`.

    me@box:~$ cp /media/master/pubring.gpg /media/keys/
    me@box:~$ cp /media/master/secring.gpg /media/keys/
    me@box:~$ cp /media/master/trustdb.gpg /media/keys/
    me@box:~$ cp /media/master/gpg.conf /media/keys/


## Unmount and remove the `master` and `revcert` USB sticks

The `master` USB stick now contains your public and private keys, including the
Master Identity key.  Both the `master` and `revcert` USB sticks can be removed
and squirrelled safely away.

    me@box:~$ sudo umount /media/master
    me@box:~$ sudo umount /media/revcert


## Remove the private master key from the daily-use keyring

Convoluted process to remove the private master key from the secret keyring
(`secring.gpg`):-

- export the private subkeys and public key and subkeys
- delete the private master key
- import the private subkeys and public key and subkeys

There's an alternative which doesn't bother to export the public keys, but it
*seems* safer to use the former method than this one:-

- export private subkeys
- delete the private master key
- import the private subkeys

If you should encounter any problems with this step you can delete everything
on the daily-use keyring, mount `master` again and repeat the previous two
steps before doing this step from the beginning.

    me@box:~$ export GNUPGHOME=/media/keys
    me@box:~$ gpg --list-secret-keys
    /media/keys/secring.gpg
    --------------------------------
    sec   4096R/0xF1829BDBB6B64480 2013-12-14 [expires: 2013-12-13]
    uid                            My Full Name <me@domain.example.com>
    ssb   4096R/0xFDB32668D55D0A12 2013-12-14
    ssb   4096R/0xC3897294DD857167 2013-12-14

    me@box:~$ gpg --export-secret-subkeys 0xFDB32668D55D0A12! 0xC3897294DD857167! > exported_subkeys
    me@box:~$ gpg --armor --export 0xF1829BDBB6B64480 > pubcert_F1829BDBB6B64480.asc
    me@box:~$ gpg --delete-secret-key 0xF1829BDBB6B64480
    gpg (GnuPG) 1.4.11; Copyright (C) 2010 Free Software Foundation, Inc.
    This is free software: you are free to change and redistribute it.
    There is NO WARRANTY, to the extent permitted by law.


    sec  4096R/0xF1829BDBB6B64480 2013-12-14 My Full Name <me@domain.example.com>

    Delete this key from the keyring? (y/N) y
    This is a secret key! - really delete? (y/N) y
    me@box:~$ gpg --import exported_subkeys
    gpg: key 0xF1829BDBB6B64480: secret key imported
    gpg: key 0xF1829BDBB6B64480: "My Full Name <me@domain.example.com>" not changed
    gpg: Total number processed: 1
    gpg:              unchanged: 1
    gpg:       secret keys read: 1
    gpg:   secret keys imported: 1
    me@box:~$ rm exported_subkeys
    me@box:~$ gpg --import pubcert_F1829BDBB6B64480.asc
    gpg: key 0xF1829BDBB6B64480: "My Full Name <me@domain.example.com>" not changed
    gpg: Total number processed: 1
    gpg:              unchanged: 1
    me@box:~$

Now, when you `--list-secret-keys`, you should see `sec#` to denote that the
master secret key is not actually present in the secret keyring.

    me@box:~$ gpg --list-secret-keys
    /media/keys/secring.gpg
    --------------------------------
    sec#  4096R/0xF1829BDBB6B64480 2013-12-14 [expires: 2013-12-13]
    uid                            My Full Name <me@domain.example.com>
    ssb   4096R/0xFDB32668D55D0A12 2013-12-14
    ssb   4096R/0xC3897294DD857167 2013-12-14

    me@box:~$


## Make the exported public key (certificate) available for publishing

Having exported an ASCII armoured public key certificate in the previous step,
you may want to make it available to your correspondents or to the public.

    me@box:~$ mv pubcert_F1829BDBB6B64480.asc /media/unsafe/


## Remove the backup secret keyring from the daily-use USB stick

GnuPG creates backups of the keyrings and the backup of the secret keyring must
be removed since it currently contains the master identity key which was
removed from the secret keyring in the previous step. Note the tilde: `~` !

    me@box:~$ rm /media/keys/secring.gpg~


[background]: background.md
[format_usb]: format_usb.md
[mount_usb]: mount_usb.md
[gpg_conf]: ../conf/gpg.conf
