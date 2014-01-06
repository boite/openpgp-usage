# Mount a USB memory stick

GnuPG will not perform certain actions if the keyrings are not stored in a
directory with secure file permissions.

Make a directory under media with a name corresponding to the label of the USB
memory stick; in this example: `master`

    me@box:~$ sudo mkdir /media/master
    me@box:~$ sudo chown `id -u -n`:`id -g -n` /media/master
    me@box:~$ chmod 700 /media/master
    
Insert the USB memory stick and find the device name; in this example:
`/dev/sdf`

    me@box:~$ ls -l /dev/disk/by-label

Mount the first partition; in this example: `/dev/sdf1`

    me@box:~$ sudo mount -t vfat /dev/sdf1 /media/master -o uid=`id -u`,gid=`id -g`,utf8,dmask=077,fmask=177
