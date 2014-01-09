# Sign and Encrypt a message for your correspondent

This guide assumes that you're familiar with the [background][background] and
have [generated some keys][genkey-with-detached-identity].


## Ingredients

- Insecure workstation
- Secure workstation
- Daily-use keyrings on the `keys` USB memory stick
- The `unsafe` USB memory stick
- The [signed public key of your correspondent][sign_key]


## Method

- Mount the USB memory sticks
- Sign and encrypt your message


### Mount the USB memory sticks

On the secure workstation, [mount][mount_usb] the `keys` and `unsafe` USB
memory sticks.


### Sign and encrypt your message

    me@box:~$ export GNUPGHOME=/media/keys
    me@box:~$ gpg --armor --output /media/unsafe/msg_for_C097AC75C097AC75.asc --recipient 0xC097AC75C097AC75 --sign --encrypt

    You need a passphrase to unlock the secret key for
    user: "My Full Name <me@domain.example.com>"
    4096-bit RSA key, ID 0xFDB32668D55D0A12, created 2013-12-14
             (subkey on main key ID 0xF1829BDBB6B64480)

    Dear John,
    By the time you read these lines I'll be gone.
    Life goes on, right or wrong
    Now the sun is dead and gone. Dear John.

Hit `Ctrl+D` when you've finished typing your message, et voilà!

Alternatively you can encrypt a file:-

    me@box:~$ gpg --armor --output /media/unsafe/msg_for_C097AC75C097AC75.asc --recipient 0xC097AC75C097AC75 --sign --encrypt some_file.txt


[background]: background.md
[genkey-with-detached-identity]: genkey-with-detached-identity.md
[sign_key]: sign_key.md
[mount_usb]: mount_usb.md
