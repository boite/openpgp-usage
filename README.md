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
- [Certify the identity][sign_key] of a correspondent.
- [Sign and encrypt a message][sign_encrypt] to a correspondent
- Refresh the public keys of correspondents over Tor using
  [Parcimonie on Windows][parcimonie-vbguest]
- ...

There is also a [sample configuration file for GnuPG][gpg-conf] which you may
wish to use in place of the default configuration.


## Bibliography

This guide builds on the work of many other people:-

- https://www.gnupg.org/gph/en/manual.html The GNU Privacy Handbook
- http://ekaia.org/blog/2009/05/10/creating-new-gpgkey/ Creating a new GPG key
- http://keyring.debian.org/creating-key.html Creating a new GPG key
- https://wiki.debian.org/subkeys Using OpenPGP subkeys in Debian development
- https://tools.ietf.org/html/rfc4880 OpenPGP Message Format
- https://dev.guardianproject.info/projects/psst/wiki/CleanRoom?title=CleanRoom
  Clean Room
- https://wiki.fsfe.org/Card_howtos/Card_with_subkeys_using_backups Card with
  subkeys using backups
- http://spin.atomicobject.com/2013/11/24/secure-gpg-keys-guide/ Generating
  More Secure GPG Keys: A Step-by-Step Guide
- https://we.riseup.net/riseuplabs+paow/openpgp-best-practices OpenPGP Best
  Practices 
- https://www.gnupg.org/howtos/card-howto/en/smartcard-howto-single.html How to
  use the Fellowship Smartcard
- http://www.davidsoergel.com/gpg.html Thoughts on GPG Key Management
- http://www.interhack.net/people/cmcurtin/snake-oil-faq.html Snake Oil Warning
  Signs: Encryption Software to Avoid
- http://cryptnet.net/fdp/crypto/keysigning_party/en/keysigning_party.html The
  Keysigning Party HOWTO
- https://help.ubuntu.com/community/GnuPrivacyGuardHowto Gnu Privacy Guard
  Howto
- https://security.stackexchange.com/q/31594 What is a good general purpose
  GnuPG key setup?
- http://security.stackexchange.com/q/47798 Which signing key should I use for
  certifying other peoples public keys: master or subkey?
- https://wiki.openstack.org/wiki/OpenPGP_Web_of_Trust OpenPGP Web of Trust
- http://www.phillylinux.org/keys/terminal.html Keysigning with the GNU/Linux
  Terminal


[background]:         docs/background.md
[genkey-with-detached-identity]: docs/genkey-with-detached-identity.md
[sign_key]:           docs/sign_key.md
[sign_encrypt]:       docs/sign_encrypt.md
[parcimonie-vbguest]: vm/parcimonie/
[gpg-conf]:           conf/gpg.conf
