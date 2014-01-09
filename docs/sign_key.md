# Sign the key of your correspondent

This guide assumes that you're familiar with the [background][background] and
have [generated some keys][genkey-with-detached-identity].


## Ingredients

- Insecure workstation
- Secure workstation
- Master keyrings on the `master` USB memory stick
- Daily-use keyrings on the `keys` USB memory stick
- The `unsafe` USB memory stick


## Method

- Copy your correspondents public key to the `unsafe` USB memory stick
- Mount the USB memory sticks
- Import your correspondents key into the Master keyring
- Verify the fingerprint with your correspondent
- Sign your correspondents key
- Export the signed public key certificate of your correspondent
- Import the signed public key certificate into your daily-use keyring


### Copy your correspondents public key to the `unsafe` USB memory stick

There are numerous ways to obtain the public key (properly, the public key
certificate).  Once you have it, copy it to the `unsafe` USB memory stick on
your insecure workstation.  In the following example the file is named
`C097AC75C097AC75.asc`.


### Mount the USB memory sticks

On the secure workstation, [mount][mount_usb] the `master`, `keys` and `unsafe`
USB memory sticks.


### Import your correspondents key into the Master keyring

    me@box:~$ export GNUPGHOME=/media/master
    me@box:~$ gpg --import /media/unsafe/C097AC75C097AC75.asc
    gpg: key 0xC097AC75C097AC75: public key "Your Contact <your-contact@example.com>" imported
    gpg: Total number processed: 1
    gpg:               imported: 1


### Verify the fingerprint with your correspondent

    me@box:~$ gpg --fingerprint -k 0xC097AC75C097AC75
    pub   1024D/0xC097AC75C097AC75 2008-09-27 [expires: 2015-09-27]
          Key fingerprint = B452 6436 7BCD E26B F9D3  81CB C097 AC75 C097 AC75
    uid                 [ unknown] Your Contact <your-contact@example.com>
    uid                 [ unknown] Your Contact <your-contact@other.example.com>
    sub   2048g/0x0COO1A5C001CA9BE 2008-09-27 [expires: 2015-12-09]


### Sign your correspondents key

In this operation you are certifying that one or more User IDs bound to the
public key of your correspondent truly represent their identity. You do this by
adding a signature, made by your Master secret key, to their public key
certificate.

    me@box:~$ gpg -K
    /media/keys/secring.gpg
    --------------------------------
    sec   4096R/0xF1829BDBB6B64480 2013-12-14 [expires: 2013-12-13]
    uid                            My Full Name <me@domain.example.com>
    ssb   4096R/0xFDB32668D55D0A12 2013-12-14
    ssb   4096R/0xC3897294DD857167 2013-12-14

    me@box:~$ gpg --local-user 0xF1829BDBB6B64480! --sign-key 0xC097AC75C097AC75

    pub   1024D/0xC097AC75C097AC75  created:2008-09-27  expires: 2015-09-27 usage: SC
                                    trust: unknown      validity: unknown
    sub   2048g/0x0COO1A5C001CA9BE  created:2008-09-27  expires: 2015-12-09 usage: E
    [ unknown] (1). Your Contact <your-contact@example.com>
    [ unknown] (2)  Your Contact <your-contact@other.example.com>

    Really sign all user IDs? (y/N) y

    pub   1024D/0xC097AC75C097AC75  created:2008-09-27  expires: 2015-09-27  usage: SC
                                    trust: unknown      validity: unknown
     Primary key fingerprint: B452 6436 7BCD E26B F9D3  81CB C097 AC75 C097 AC75

         Your Contact <your-contact@example.com>
         Your Contact <your-contact@other.example.com>

    This key is due to expire on 2015-09-27.
    Are your sure that you want to sign this key with your
    key "My Full Name <me@domain.example.com>" (0xF1829BDBB6B64480)

    Really sign? (y/N) y

    You need a passphrase to unlock the secret key for
    user: "My Full Name <me@domain.example.com>"
    4096-bit RSA key, ID 0xF1829BDBB6B64480, created 2013-12-14

    me@box:~$


### Export the signed public key certificate of your correspondent

You will want to make the signed key available to your daily-use keyring so
that it can be used to encrypt messages to your correspondent.  You will also
want to make it available on the insecure workstation so that you are able to
publish the updated certificate.

    me@box:~$ gpg --armor --output /media/unsafe/C097AC75C097AC75_signed_by_F1829BDBB6B64480.asc --export 0xC097AC75C097AC75
    me@box:~$ sudo umount /media/master


### Import the signed public key certificate into your daily-use keyring

    me@box:~$ export GNUPGHOME=/media/keys
    me@box:~$ gpg --import /media/unsafe/C097AC75C097AC75_signed_by_F1829BDBB6B64480.asc
    gpg: key 0xC097AC75C097AC75: public key "Your Contact <your-contact@example.com>" imported
    gpg: Total number processed: 1
    gpg:               imported: 1
    gpg: 3 marginal(s) needed, 1 complete(s) needed, PGP trust model
    gpg: depth: 0  valid:   1  signed:   1  trust: 0-, 0q, 0n, 0m, 0f, 1u
    gpg: depth: 1  valid:   1  signed:   0  trust: 1-, 0q, 0n, 0m, 0f, 0u
    gpg: next trustdb check due at 2015-09-27

You're now ready to [encrypt messages for your correspondent][sign_encrypt].


[background]: background.md
[genkey-with-detached-identity]: genkey-with-detached-identity.md
[mount_usb]: mount_usb.md
[sign_encrypt]: sign_encrypt.md
