# OpenPGP Usage

This is a short guide to using OpenPGP (as implemented by GnuPG) to secure
email communication from an adversary who collects and stores *everything*
being sent and received on the internet.

It is hoped that the guide, whilst short, will bring together numerous sources
of information which can be daunting new users or frustrate their attempts to
secure their email communication.

To start with, there is a little [background][background] which describes the
goals of the guide and a little about the set-up.

Then there are guides for the individual operations, notably:-

- [Generate a set of OpenPGP keys][genkey-with-detached-identity], including a
  detached Master Identity key.
- ...

There is also a [sample configuration file for GnuPG][gpg-conf] which you may
wish to use in place of the default configuration.


[genkey-with-detached-identity]: docs/genkey-with-detached-identity.md
[gpg-conf]: conf/gpg.conf


## Bibliography

This guide builds on the work of many other people:-

- http://www.gnupg.org/gph/en/manual.html The GNU Privacy Handbook
- http://ekaia.org/blog/2009/05/10/creating-new-gpgkey/
- http://der-dakon.net/blog/KDE/create-gpg-key-with-kde.html
- http://keyring.debian.org/creating-key.html
- http://wiki.debian.org/subkeys
- https://tools.ietf.org/html/rfc4880
- https://guardianproject.info/wiki/CleanRoom
- https://wiki.fsfe.org/Card_howtos/Card_with_subkeys_using_backups
- http://spin.atomicobject.com/2013/11/24/secure-gpg-keys-guide/
- https://we.riseup.net/riseuplabs+paow/openpgp-best-practices
- http://www.gnupg.org/howtos/card-howto/en/smartcard-howto-single.html
- http://www.davidsoergel.com/gpg.html
- http://www.interhack.net/people/cmcurtin/snake-oil-faq.html
- http://cryptnet.net/fdp/crypto/keysigning_party/en/keysigning_party.html
- https://help.ubuntu.com/community/GnuPrivacyGuardHowto
- https://security.stackexchange.com/q/31594 What is a good general purpose
  GnuPG key setup?
- http://security.stackexchange.com/q/47798 Which signing key should I use for
  certifying other peoples public keys: master or subkey?
- https://wiki.openstack.org/wiki/OpenPGP_Web_of_Trust
- http://www.phillylinux.org/keys/terminal.html
