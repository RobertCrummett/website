#import "../theme.typ": hr

In this post I will describe what I learned about USB drives while
uploading a new version of the BIOS to my motherboard. This will mostly be
about file systems relevant to the Windows environment: FAT32, exFAT, and NTFS.
MacOS and Linux are usually capable of interacting with these file systems
as well, although they tend to use different file systems internally.

#hr

A USB drive will have a file system on it. The purpose of the file system is
to organize files. There are several different types of file systems: FAT32,
exFAT, or NTFS.

== FAT32

The FAT in FAT32 and exFAT stands for _File Allocation Table_. FAT32
is the oldest of the three file types. For this reason it is generally slower
than the other two, but it is well supported. For instance, to install a new
version of my BIOS, I had to reformat my drive to FAT32 to ensure the motherboard
would read files correctly.

On a FAT32 file system, you cannot save files over 4GB or make partitions over 8TB.
FAT32 uses an unsigned 32-bit integers to store the file size. So files cannot
exceed the maximum size of an unsigned 32-bit --- $2^32 - 1$. Therefore this
limit is exact. Files cannot be 4GB or larger. The 8TB limit is less obvious.

The FAT32 allocation table keeps track of _clusters_ of sectors with 28 bits.
The maximum cluster size is 32 KB. The partition size is the number of clusters multiplied
by the size of the cluster. Multiplying 32KB by $2^28$ yields 8TB, the maximum
partition size.

Although 8TB partitions are supported on FAT32, Microsoft only supports formatting
up to 32GB. This is to encourage migration to exFAT and NTFS file systems --- the
number 32GB it completely arbitrary.

== exFAT

Next in the lineup of file system formats is exFAT. The name stands
for extended file allocation table. It is newer than FAT32, but not so
new as NTFS. It is not so well supported by MacOS and Linux as FAT32,
but it is supported by Windows XP and newer.

The maximum file size and partition allowable on exFAT are both 128PB. Huge! So you can
store larger files on these type of drives. Once I was messing around with geophysical data,
gridded at 100 meters by 100 meters across the continent of Australia as 32-bit floating point numbers.
The grid was too large to store on my FAT32 drive (roughly 16GB each) so I had to
reformat the drive before exporting my data.

== NTFS

NTFS is the most modern file system on the list. It is what is being used by default
under the hood of all modern Windows devices. NTFS stands for New Technology File System.

NTFS is a journaling file system, unlike FAT32 and exFAT. File allocation tables are basically
a gigantic table listing which file comes next in the file system. Logically, the flow is very linear:
first comes cluster one, then cluster two, then the end. But NTFS is a journaling file system. It
records the metadata for each file in a master file table. To make a change, first the change is
documented in the master file table, and then the change is made to disk. So journaling file systems
are much more resilient to power outages during operations!

#hr

== File Transfer Speed

USB sticks usually communicate file transfer speed in the language of bits per second (mps). USB 2.0
is capable of transferring about 500Mbps, while USB 3.0 is capable of about 5Gbps (ten times more).

Time to clear up some misconceptions I had.
Baud rate, or baud per second, is a little different than bits per second. Baud is a measure of
_symbols_ transferred, not necessarily bits. When individual bits correspond to symbols, then the
baud rate will be the same as the bit rate. But only in this case.

#hr

== Memory Layout

Memory layout on disk is a level lower than the file system --- effectively, it is what the file
system is sitting on. Each partition of the disk or drive or whatever can hold a file system. So a drive with multiple
partitions can have multiple, independent file systems. There are two types relevant to this high level blog: MBR and GPT.

== MBR

MBR, or Master Boot Record, is the older of the two memory layouts. It is more fragile than GPT, and has stricter
memory limits. For instance, MBR is usually limited to four partitions. Tricks are required to get extended partitions.
MBR has 32-bit logical block addressing (abbreviated LBA; block sizes are 512 bytes),
limiting it at drive sizes of $2^32$ times 512 = 2TB drive sizes.

It is legacy, and so it works in a lot of places. But it has been largely replaced by GPT.

== GPT

GPT, or GUID Partition Table, is the second memory layout scheme. It is newer than MBR and generally more
resistant to corruption. It uses 64-bit LBA scheme, giving it virtually uncapped maximum drive size. This type
of memory layout does not have a strict limit on partitions, although I hear that Windows limits the number
of partitions at 128.

Except for legacy systems, GPT layout is recommended to my knowledge.

#hr

== Sources

#link("https://www.pcmag.com/how-to/fat32-vs-exfat-vs-ntfs-which-format-is-best-for-your-storage-drive?test_uuid=04IpBmWGZleS0I0J3epvMrC&test_variant=A")[https://www.pcmag.com/how-to/fat32-vs-exfat-vs-ntfs-which-format-is-best-for-your-storage-drive]
