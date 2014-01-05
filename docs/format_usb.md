# Format USB memory stick

These instructions have been tested on Ubuntu 12.04 and result in a memory
stick which can be used in Windows and Linux (and probably Macintoshes too).

Insert the USB memory stick and find the device name; in this example:
`/dev/sdf`

    me@box:~$ ls -l /dev/disk/by-id/usb*

Partition the memory stick

    me@box:~$ sudo fdisk /dev/sdf
    o [ENTER] # create a new empty DOS partition table
    n [ENTER] # add a new partition
    [ENTER]   # use the default primary partition
    [ENTER]   # use the default partition number 1
    [ENTER]   # use the default starting block
    [ENTER]   # use the default ending block
    t [ENTER] # change a partition's system id
    b [ENTER] # W95 FAT32 - note that for large, e.g. 16GB, drives use an id of
              # c W95 FAT32 (LBA)
    w [ENTER] # write table to disk and exit

Format the first partition; in this example: `/dev/sdf1`

    me@box:~$ sudo mkfs.vfat -n <your_label_here> /dev/sdf1
