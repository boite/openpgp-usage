# Introduction

It's a good idea to perform the following steps in a LiveCD environment,
without being connected to a network.  Shutdown the LiveCD when you've
completed these steps (and before you reconnect to a network).

You will need:-
- a LiveCD which makes GnuPG >= 1.4.10 available
- 3 USB sticks (preferably labelled: revcert, master and keys; and which you
  will mount under `/media` with these labels, i.e. /media/revcert, etc.).
- to think about a good strong "passphrase" (it should not be a phrase; it
  should not contain real words or anything like the passwords contained in
  numerous password dumps) to protect your private keys. It should be something
  which you will remember (you remember well things from when you were young).
  As an example, consider:
  "When I was five, I filled the pencil case belonging to a bully with glue
  because he made me give him my lunch money. Nobody ever found out that it was
  me who did it. He cried all afternoon!".
  Take up to two characters from each word, substitute numbers where it makes
  sense to do so, use punctuation:

      WhIwa5,Ifithpecabe2abuwiglbehemamegihimylumo. Noevfoouthitwamewhdiit. Hecralaf!

# Steps

## Summary of steps
- Partition and Format USB memory sticks
- Get a copy of a GnuPG configuration file
- Mount the USB memory sticks
- Create Master signing and certification key and an encryption subkey
- Add a signing subkey
- Generate Revocation Certificate
- Copy Revocation Certificate to "Revcert" USB stick
- Make a backup of the private and public keyrings
- Copy keyrings to "Master" USB stick
- Remove the private master key from the day-to-day keyring
- Copy keyrings to "Day-to-day" USB stick


## Partition and Format USB memory sticks

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

[format_usb]: docs/format_usb.md


## Get a copy of a GnuPG configuration file

Copy [gpg.conf][gpg_conf] to the `unsafe` USB stick.

[gpg_conf]: conf/gpg.conf


## Mount the USB memory sticks

Create four directories under `/media`, corresponding to the labels of the four
USB memory sticks.
[Set the proper permissions and mount the USB sticks][mount_usb].

[mount_usb]: docs/mount_usb.md


## Create Master signing and certification key and an encryption subkey

    me@box:~$ gpg --gen-key
    gpg (GnuPG) 1.4.11; Copyright (C) 2010 Free Software Foundation, Inc.
    This is free software: you are free to change and redistribute it.
    There is NO WARRANTY, to the extent permitted by law.

    gpg: keyring `/home/me/.gnupg/secring.gpg' created
    gpg: keyring `/home/me/.gnupg/pubring.gpg' created
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
    gpg: /home/me/.gnupg/trustdb.gpg: trustdb created
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

    me@box:~$ gpg -o revcert.asc --gen-revoke 0xF1829BDBB6B64480

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


## Copy Revocation Certificate to "Revcert" USB stick

Assuming a USB stick mounted at `/media/revcert`.

    me@box:~$ cp .gnupg/pubring.gpg /media/revcert/
    me@box:~$ cp .gnupg/secring.gpg /media/revcert/


## Make a backup of the private and public keyrings

    me@box:~$ cp .gnupg/pubring.gpg .gnupg/pubring.gpg.backup
    me@box:~$ cp .gnupg/secring.gpg .gnupg/secring.gpg.backup


## Copy keyrings to "Master" USB stick

Assuming a USB stick mounted at `/media/master`.

    me@box:~$ cp .gnupg/pubring.gpg /media/master/
    me@box:~$ cp .gnupg/secring.gpg /media/master/

Copy `gpg.conf` also.  Append `lock-never` to the configuration.

    me@box:~$ cp .gnupg/gpg.conf /media/master/
    me@box:~$ echo lock-never >> /media/master/gpg.conf


## Remove the private master key from the day-to-day keyring

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

.

    me@box:~$ gpg --list-secret-keys
    /home/me/.gnupg/secring.gpg
    --------------------------------
    sec   4096R/0xF1829BDBB6B64480 2013-12-14 [expires: 2013-12-13]
    uid                            My Full Name <me@domain.example.com>
    ssb   4096R/0xFDB32668D55D0A12 2013-12-14
    ssb   4096R/0xC3897294DD857167 2013-12-14

    me@box:~$ gpg --export-secret-subkeys 0xFDB32668D55D0A12! 0xC3897294DD857167! > exported_subkeys
    me@box:~$ gpg --export 0xF1829BDBB6B64480 > exported_pubkeys
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
    me@box:~$ gpg --import exported_pubkeys
    gpg: key 0xF1829BDBB6B64480: "My Full Name <me@domain.example.com>" not changed
    gpg: Total number processed: 1
    gpg:              unchanged: 1
    me@box:~$

Now, when you `--list-secret-keys`, you should see `sec#` to denote that the
master secret key is not actually present in the secret keyring.

    me@box:~$ gpg --list-secret-keys
    /home/me/.gnupg/secring.gpg
    --------------------------------
    sec#  4096R/0xF1829BDBB6B64480 2013-12-14 [expires: 2013-12-13]
    uid                            My Full Name <me@domain.example.com>
    ssb   4096R/0xFDB32668D55D0A12 2013-12-14
    ssb   4096R/0xC3897294DD857167 2013-12-14

    me@box:~$


## Copy keyrings "Day-to-day" to USB stick

Assuming a USB stick mounted at `/media/keys`.

    me@box:~$ cp .gnupg/pubring.gpg /media/keys/
    me@box:~$ cp .gnupg/secring.gpg /media/keys/

Copy `gpg.conf` also.  Append `lock-never` to the configuration.

    me@box:~$ cp .gnupg/gpg.conf /media/keys/
    me@box:~$ echo lock-never >> /media/keys/gpg.conf
