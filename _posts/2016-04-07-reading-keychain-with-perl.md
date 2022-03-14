---
layout:     default
title:      Reading the keychain with a perl script
date:       2016-04-07
editdate:   2020-05-11
categories: MacAdmin
disqus_id:  reading-keychain-with-perl.html
render_with_liquid: false
---

This is short.  I figured out how to read the logged in users' keychain from a perl script and send the results to hdiutil for creating encrypted disk images, but then I discovered that I didn't actually need to do it.

I might need to do this again in the future so I better document it.

    # These 3 items are used to find the correct keychain item.
    my $keychain_name = "Each keychain item has a name, use it here";
    my $keychain_kind = "Each keychain item has a kind, use it here";
    my $keychain_account = "Each keychain item has a account, use it here";

    # These variables specify details for the new disk image.
    my $disk_size = "10G";
    my $volname = "Something";
    my $filepath = "/tmp/bla.sparceimage";

    system "PWD=\$(security find-generic-password -w -l \"$keychain_name\" -D \"$keychain_kind\" -a \"$keychain_account\") ; printf \$PWD | hdiutil create -size $disk_size -encryption -stdinpass -volname \"$volname\" -type SPARSE -fs HFS+ \"$filepath\"";
