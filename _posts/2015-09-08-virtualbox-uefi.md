---
layout:     default
title:      "The VirtualBox Interactive Shell"
date:       2015-09-08
editdate:   2020-05-11
categories: MacAdmin
disqus_id:  virtual-box-uefi.html
---

This post is unfinished and unresolved but I've got a lot of information so I thought I'd post it anyway.  I wrote it back in Sept 2015 but am just posting it in Apr 2016.

The reason why it was unresolved is because I kept having errors on disks I created this way, so I decided it wasn't worth it.  I also never really figured out how to use the interactive shell to do anything useful.  Here's the original post.

---

My goal was to be able to create VirtualBox images quickly and easily without having to run an OS X installer every time.  I tried cloning images and resizing but it wouldn't work.  So I figured if I could mount the filesystem on the host and install the files it would work.  I was wrong.

Booting to UEFI Interactive Shell
---------

So if you don't have a bootable disk for some reason, VirtualBox will boot up to the UEFI Interactive Shell.  An easy way to get this is to go to a VM settings and remove all disks and start the VM up.

Normally, OS X boots to it's own EFI boot loader located at /System/Library/CoreServices/boot.efi.  This isn't a standard location for EFI boot loaders.  The following statement makes me think that the location of the OS loader is part of the volume header.

>The OS loader is usually located through a file ID pointer in the HFS+ volume header. This info can be set with the bless command-line tool. [OSX86 project](http://wiki.osx86project.org/wiki/index.php/Apple's_EFI_implementation)

So if you install the OS X file system by using a file copy, it will not be bootable (that's what I did).

I attempted many things to try to get the machine to boot including booting to a working drive and running the bless command on the non-booting drive, running the bless command on the host computer while the non-booting drive was mounted, trying to use the Interactive Shell to select the correct drive, installing [rEFInd](http://sourceforge.net/projects/refind/), booting to the install image and repairing the disk, and other things.

I eventually found that running the OS installer or using Carbon Copy Cloner's block copy fixed it.

Either way, I decided to write down everything I learned about the Interactive Shell, since it might be useful someday.

Version
---------

Output of `ver` command.

    UEFI Interactive Shell v2.0
    Copyright 2009-2011 Intel(r) Corportation. All rights reserved. Beta build 1.0
    UEFI v2.31 (EDK II, 0x00010000)

This is probably contained in the file /Applications/VirtualBox.app/Contents/MacOS/VBoxEFI64.fd.  However, when I ran strings on that file the text wasn't in it (or in any other file in the VirtualBox.app folder).

I tried the Tianocore shell and for some reason it didn't have the `bcfg` command.

List of commands
---------

This is the list of commands printed when you type `help`. Add `-b` to any command to show one screen at a time (like less/more).  Typos are part of the real text printed by this shell.

    attrib          -Displays or changes the attributes of files or directories.
    cd              -Displays or chagnes the current directory.
    cp              -Copies one or more source files or directories to a destination.
    load            -Loads a UEFI driver into memory.
    map             -Defines a mapping between a user-defined name and a device handle.
    mkdir           -Creates one or more new directories.
    mv              -Moves one or more files to a destination within a file system.
    parse           -Command used to retrieve a value from a particular record which was output in a standard formatted output.
    reset           -Resets the system.
    set             -Displays, changes or deletes a UEFI Shell environment variables.
    ls              -Lists a directory's contents or file information.
    rm              -Deletes one or more files or directories
    vol             -Displays the volume information for the file system taht is specified by fs.
    date            -Displays and sets the current date for the system.
    time            -Displays or sets the current time for the system.
    timezone        -Displays or sets time zone information.
    stall           -Stalls the operation for a specified number of microseconds.
    for             -Starts a loop based on for syntax.
    goto            -moves around the point of execution in a script.
    if              -Controls which script commands will be executed based on provided conditional expressions.
    shift           -moves all in-script parameters down 1 number (allows access over 10).
    exit            -Exits the UEFI Shell or the current script.
    else            -Else identifies the portion of the code executedd if the if was FALSE.
    endif           -Ends the block of a script controlled by an 'if' statement.
    endfor          -Ends a 'for' loop.
    type            -Sends the contents of a file to the standard output device.
    touch           -Updates the time and date on a file to the current time and date.
    ver             -Displays the version information for the UEFI Shell and the underlying UEFI firmware
    alias           -Displays, creates, or deletes aliases in the UEFI Shell environment.
    cls             -Clears the standard ouptut and optionally changes the background color.
    echo            -Controls whether script commands are displayed as they are read for the script file, and prints the given message to the display.
    pause           -Pauses a script and waits for an operator to press a key.
    getmtc          -Gets the MTC from BootServices and displays it.
    help            -Displays the list of commands that are built into the UEFI Shell.
    connect         -Binds a driver to a specific device and starts the driver.
    devices         -Displays the list of devices managed by UEFI drivers.
    openinfo        -Displays the protocols and agents associated with a handle.
    disconnect      -Disconnects one or more drivers from the specified devices.
    reconnect       -Reconnects drivers to the specific device.
    unload          -Unloads a driver image that was already loaded.
    drvdiag         -Invokes the Driver Diagnostics Protocol.
    dh              -Displays the device handles in the UEFI environment.
    drivers         -Displays a list of information for drivers that follow the UEFI Driver Model in the UEFI environment.
    devtree         -Displays the tree of devices compliant with the UEFI Driver Model.
    drvcfg          -Configures the driver using the platform's underlying configuration infrastructure.
    setsize         -Adjust the size of a file.
    comp            -Compares the contents of two files on a byte for byte basis.
    mode            -Displays or changes the console output device mode.
    memmap          -Displays the memory map maintained by the EFI environment.
    eficompress     -Compress a file using EFI Compression Algorithm.
    efidecompress   -Decompress a file using UEFI Decompression Algorithm.
    dmem            -Displays the contents of system or device memory.
    loadpcirom      -Loads a UEFI driver from a file in the format of a PCI Option ROM.
    mm              -Displays or modifies MEM/MMIO/IO/PCI/PCIE address space.
    setvar          -Changes the value of a UEFI variable.
    setmode         -Sets serial port attributes.
    pci             -Displays PCI device list or PCI function configuration space.
    smbiosview      -Displays SMBIOS informatino.
    dmpstore        -Manages all UEFI NVRAM variables.
    dblk            -Displays the contents of one or more blocks from a block device.
    edit            -Full screen editor for ASCII or UCS-2 files.
    hexedit         -Full screen hex editor for files, block devices, or memory.
    bcfg            -Manages the boot and driver options that are stored in NVRAM.
    ping            -Ping the target host with IPv4 stack.
    ifconfig        -Modify the default IP address of the UEFI IP4 Network Stack.

Moving around the filesystem
---------

    ls fs1:\

    09/11/2015  19:22           0 .com.apple.timemachine.donopresent
    08/25/2015  00:16           0 .file
    09/11/2015  21:37 <DIR>   175 .fseventsd
    ...

Yup, that's Mac OS X.

A weird thing is that when I ran `ls fs1:\System` it didn't list "Library", it listed "System".  And when I tried to list that it said it was empty.

Configuring boot options
---------

To see the current boot options, use this command.

    bcfg boot dump -v

To set the boot disk, you'd do something like this.

    bcfg boot dump -v
    bcfg boot add 3 fs0:EFI[Your path][Your EFI name].efi
    bcfg boot mv 3 0

If you want to remove it use this.

    bcfg boot rm 3

I tried to add Apple's boot.efi like this.

    bcfg boot add 3 fs1:\System\Library\CoreServices\boot.efi "10.6"

It didn't work, I don't remember what it said.  It had something to do with not being able to find a file there (I'm guessing because it saw fs1:\System\System and nothing else).

NVRAM variables
---------

The only NVRAM variable that appears to be settable is boot-args.

[3.12.2. Specifying boot arguments](http://www.virtualbox.org/manual/ch03.html#efi)

>It is currently not possible to manipulate EFI variables from within a running guest (e.g., setting the "boot-args" variable by running the nvram tool in a Mac OS X guest will not work). As an alternative way, "VBoxInternal2/EfiBootArgs" extradata can be passed to a VM in order to set the "boot-args" variable. To change the "boot-args" EFI variable:
>
>    `VBoxManage setextradata "VM name" VBoxInternal2/EfiBootArgs <value>`

When I ran `dmpstore` I clearly can see differences in variables for Boot0001 between a bootable disk and a non-bootable disk.  I didn't figure out the differences.

So to set single user mode boot run the following command.

    VBoxManage setextradata "VM name" VBoxInternal2/EfiBootArgs -s

To see the settings run the following command.

    VBoxManage getextradata "VM name" VBoxInternal2/EfiBootArgs

And to turn that off run the following command.

    VBoxManage setextradata "VM name" VBoxInternal2/EfiBootArgs ""
