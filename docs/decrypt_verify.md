# Decrypt and verify a message from a correspondent

This guide assumes that you're familiar with the [background][background] and
have [generated some keys][genkey-with-detached-identity].


## Ingredients

- Insecure workstation
- Secure workstation
- Daily-use keyrings on the `keys` USB memory stick
- The `unsafe` USB memory stick
- The [signed and encrypted message from your correspondent][sign_encrypt]


## Method

- Mount the USB memory sticks
- Decrypt and verify the message


### Mount the USB memory sticks

On the secure workstation, [mount][mount_usb] the `keys` and `unsafe` USB
memory sticks.


### Decrypt and verify the message

    me@box:~$ export GNUPGHOME=/media/keys
    me@box:~$ gpg --decrypt /media/unsafe/msg.asc

    You need a passphrase to unlock the secret key for
    user: "My Full Name <me@domain.example.com>"
    4096-bit RSA key, ID 0xFDB32668D55D0A12, created 2013-12-14
             (subkey on main key ID 0xF1829BDBB6B64480)

    gpg: encrypted with 4096-bit RSA key, ID 0xFDB32668D55D0A12, created 2013-12-14
    gpg:  "My Full Name <me@domain.example.com>"
    Greetings,
    There are three of them and Alleline.
    Sincerely,
    Control.

    gpg: Signature made Thu 9 Jan 2014 21:30:00 GMT
    gpg:                using DSA key 0xC097AC75C097AC75
    gpg: Good signature from "Your Contact <your-contact@example.com>" [full]
    gpg:                 aka "Your Contact <your-contact@other.example.com>" [full]
    me@box:~$


[background]: background.md
[genkey-with-detached-identity]: genkey-with-detached-identity.md
[sign_encrypt]: sign_encrypt.md
[mount_usb]: mount_usb.md
