# Goal

The goal is to secure email communication between a person at a single physical
location and their correspondents, from prying eyes, using the Gnu Privacy
Guard (GnuPG) implementation of OpenPGP.

## Threats

These are the threats against which this scheme provides satisfactory defence:-

- All communications are collected and stored by at least one adversary.
- Computers connected to a network are actively exfiltrating all information
  stored on them to at least one adversary.


# Scheme

This is a description of just one possible scheme in which communications can
be secured.

In this scheme there will be four GnuPG keyrings, two physical
workstations and a virtual machine:-

## Secure Workstation

This will run Ubuntu 12.4 (Long Term Support) without a window system and
without networking.  The workstation is physically secured and shall be a safe
machine on which to generate and manage OpenPGP keys and perform cryptographic
operations in support of the stated goal.

## Insecure Workstation

This will run Windows 7, be connected to the internet through a Local Area
Network and, as such, will carry sensitive information like private OpenPGP
keys or the plain text of messages.

## Virtual Machine

This will run Ubuntu 13.10 without a window system.  It will be hosted on the
network connected Insecure Workstation and its purpose is to run Tor and
Parcimonie for anonymous retrieval of updates to a set of public keys.

## GnuPG Keyrings

- A Master Keyring, which will contain :-
    - one's own private keys, including a master identity key
    - one's own public keys
    - the public keys of one's correspondents
- Daily-use Keyring, which will contain :-
    - one's own private subkeys, excluding the master identity key
    - one's own public keys
    - the public keys of one's correspondents
- Insecure Keyring, which will contain :-
    - one's own public keys
    - the public keys of one's correspondents
    - other public keys, such as code-signing keys
- Parcimonie Keyring, which will contain those requiring periodic updates :-
    - the public keys of one's correspondents
    - other public keys, such as code-signing keys

The master and daily-use keyrings are to be used only on the secure
workstation, stored on separate USB memory sticks and kept very safe. Losing
control of the private keys on the master keyring is a major security breach.
Losing control of the private keys on the daily-use keyring is still a breach
of security, but is at least one which can be quickly recovered from.
