# Run Parcimonie in a VirtualBox Ubuntu guest on a Windows host

Ingredients:-

- [VirtualBox][vbox]
- [Vagrant][vagrant]
- [Vagrant VirtualBox Guest Additions plugin][vagrant-vbguest] version >=
  0.10.0
- The files in this directory and subdirectories
- An export of the public keys on your keyring

Method:-

- Install VirtualBox, Vagrant and VirtualBox Guest Additions plugin
- Change to this directory on your host system
- Issue `vagrant up`; this will start by downloading a (>320MB) virtual machine
  image from the web
- SSH into the guest (username `vagrant` and password `vagrant`, or use the
  [ssh key][vagrant_ssh_key]) and finalise the set-up by performing the small
  number of tasks, below

Verify the integrity of the Certificate Authority file used by the
Synchronising Key Servers (SKS) in the `hkps.pool.sks-keyservers.net` pool:-

    me@box:~$ gpg --keyserver pool.sks-keyservers.net --recv-keys 0x94CBAFDD30345109561835AA0B7F8B60E3EDFAE3
    me@box:~$ gpg --verify .gnupg/sks-keyservers.netCA.pem{.asc,}

Go no further and find out what went wrong if the signature on the .pem file
isn't a good one or wasn't made by `Kristian Fiskerstrand
<kristian.fiskerstrand@sumptuouscapital.com>` using the key you've just
imported.

If the certificate is OK then it's time to see if Parcimonie works:-

    me@box:~$ DISPLAY=":0" DBUS_SESSION_BUS_ADDRESS="unix:path=/run/dbus/system_bus_socket" parcimonie --verbose

You should see something like:-

    14:19:44 libtorsocks(7619): WARNING: The symbol res_query() was not found in any shared library with the reported error: Not Found!
      Also, we failed to find the symbol __res_query() with the reported error: Not Found
    14:19:44 libtorsocks(7619): WARNING: The symbol res_search() was not found in any shared library with the reported error: Not Found!
      Also, we failed to find the symbol __res_search() with the reported error: Not Found
    14:19:44 libtorsocks(7619): WARNING: The symbol res_send() was not found in any shared library with the reported error: Not Found!
      Also, we failed to find the symbol __res_send() with the reported error: Not Found
    14:19:44 libtorsocks(7619): WARNING: The symbol res_querydomain() was not found in any shared library with the reported error: Not Found!
      Also, we failed to find the symbol __res_querydomain() with the reported error: Not Found
    14:19:44 libtorsocks(7620): WARNING: The symbol res_query() was not found in any shared library with the reported error: Not Found!
      Also, we failed to find the symbol __res_query() with the reported error: Not Found
    14:19:44 libtorsocks(7620): WARNING: The symbol res_search() was not found in any shared library with the reported error: Not Found!
      Also, we failed to find the symbol __res_search() with the reported error: Not Found
    14:19:44 libtorsocks(7620): WARNING: The symbol res_send() was not found in any shared library with the reported error: Not Found!
      Also, we failed to find the symbol __res_send() with the reported error: Not Found
    14:19:44 libtorsocks(7620): WARNING: The symbol res_querydomain() was not found in any shared library with the reported error: Not Found!
      Also, we failed to find the symbol __res_querydomain() with the reported error: Not Found
    Using 604800 seconds as average sleep time.
    tryRecvKey: trying to fetch 94CBAFDD30345109561835AA0B7F8B60E3EDFAE3
    14:19:44 libtorsocks(7625): connect: Connection is to a local address (10.0.2.3), may be a TCP DNS request to a local DNS server so have to reject to be safe. Please report a bug to http://code.google.com/p/torsocks/issues/entry if this is preventing a program from working properly with torsocks.
      Also, we failed to find the symbol __res_query() with the reported error: Not Found
      Also, we failed to find the symbol __res_search() with the reported error: Not Found
      Also, we failed to find the symbol __res_send() with the reported error: Not Found
      Also, we failed to find the symbol __res_querydomain() with the reported error: Not Found
      Also, we failed to find the symbol __res_query() with the reported error: Not Found
      Also, we failed to find the symbol __res_search() with the reported error: Not Found
      Also, we failed to find the symbol __res_send() with the reported error: Not Found
      Also, we failed to find the symbol __res_querydomain() with the reported error: Not Found
    gpg: requesting key 0x0B7F8B60E3EDFAE3 from hkps server hkps.pool.sks-keyservers.net
    gpg: key 0x0B7F8B60E3EDFAE3: "Kristian Fiskerstrand <kristian.fiskerstrand@sumptuouscapital.com>" not changed
    gpg: Total number processed: 1
    gpg:              unchanged: 1
    Will now sleep 1124284 seconds.

If that went well then stop parcimonie with `Ctrl+C` and export the public keys
from your keyring on the host machine:-

    C:\path\to\shared> gpg --armor --output pub.export.asc --export

Import them into the keyring on the guest machine and, should you need to,
remove any keys which you don't want to be refreshed:-

    me@box:~$ gpg --import $HOME/host_share/pub.export.asc
    me@box:~$ rm $HOME/host_share/pub.export.asc
    me@box:~$ gpg --batch --yes --delete-key 0x<long_key_id_to_remove> 0x<...>

Finally, install a crontab containing some useful cron jobs and start
parcimonie:-

    me@box:~$ crontab $HOME/host_share/new_crontab
    me@box:~$ ./parcimonie/start_parcimonie.sh

At this point, parcimonie is slowly refreshing keys on the guest's public
keyring over Tor.

A cron job will rotate the logs in `~/parcimonie/log/` and other cron jobs will
periodically import new keys from `~/host_share/pub.refresh.asc` and export all
public keys to `~/host_share/pub.updates.asc`. Thus you can import refreshed
keys into a keyring on your host machine by doing:-

    C:\path\to\shared> gpg --import pub.updates.asc 2>& 1 > NUL | find /V "not changed"
    gpg: key 0x0B7F8B60E3EDFAE3: "Kristian Fiskerstrand <kristian.fiskerstrand@sumptuouscapital.com>" 2 new signatures
    gpg: Total number processed: 37
    gpg:              unchanged: 36
    gpg:         new signatures: 2
    gpg: 3 marginal(s) needed, 1 complete(s) needed, PGP trust model
    gpg: depth: 0  valid:   4  signed:   1  trust: 0-, 0q, 0n, 0m, 0f, 4u
    gpg: depth: 1  valid:   1  signed:   0  trust: 1-, 0q, 0n, 0m, 0f, 0u
    gpg: next trustdb check due at 2015-09-27

and when you have a newly acquired public key needing to be refreshed by
parcimonie:-

    C:\path\to\shared> gpg --armor --output pub.refresh.asc --export 0x<long_key_id> ...

Be careful though that enough time has elapsed for the guest to import
`pub.refresh.asc` before you clobber it with another exported key.

Finally, if you have to stop and start the guest at any point (which you should
always do from the host with `vagrant halt` and `vagrant up`) you need only
issue the following on the guest:-

    me@box:~$ ./parcimonie/start_parcimonie.sh


[vbox]: https://www.virtualbox.org/wiki/Downloads
[vagrant]: https://www.vagrantup.com/downloads.html
[vagrant-vbguest]: https://github.com/dotless-de/vagrant-vbguest
[vagrant_ssh_key]: https://github.com/mitchellh/vagrant/tree/master/keys
