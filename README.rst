Jiayu G2F WCDMA Android phone freezing bug fix
==============================================

There is a bug making the Jiayu G2F phone freeze (hang). This project has
a remedy and includes a modified version of boot.img fixing that bug.

**WARNING: This applies only to Jiayu G2F WCDMA model with 4Gb RAM,
Android 4.2.2, kernel 3.4.5, build G2FW-20141027-W-R-V0.3.6
No other models were tested!**


Bug symptoms
------------
Phone frequently freezes (hangs) without any visible reason.


Bug background
--------------
Every couple of seconds a new instance of *memsicd3416x* service
is spawned while the old ones are still continue running. This
obviously leads to resource exhaustion and system freeze.


Bug reason
----------
The *oneshot* option is missing in the *init.rc* file where
*memsicd3416x* service is started.

    
Quick remedy
------------
**DISCLAIMER: ABSOLUTELY NO WARRANTY, DO IT AT YOUR OWN RISK.**

Just flash your phone's boot partition with already modified and
provided here boot.img using the fastboot tool from the Android SDK::

    fastboot flash boot boot.img


Slow remedy
-----------
Get a copy of your phone's boot image, extract it, unpack initrd.cpio.gz,
modify init.rc file according to the diff below. Then repack it back to
the new initrd.cpio.gz, and then write your own new modified boot image.
Flash the resulting boot image to your phone's boot partition.


Diff between original and modified boot.img
-------------------------------------------
The diff::

    diff -Naur original/rootfs/init.rc modified/rootfs/init.rc
    --- original/rootfs/init.rc	2015-10-22 22:41:58.406635561 +0300
    +++ modified/rootfs/init.rc	2015-10-22 22:41:48.970914550 +0300
    @@ -1317,7 +1317,8 @@
     #
     
     service msensord /system/bin/msensord
    -    class main
    +    oneshot
    + #   class main
     
     service s62xd /system/bin/s62xd
         disabled
    @@ -1339,9 +1340,10 @@
     
     service memsicd3416x /system/bin/memsicd3416x
          disabled
    +     oneshot
          user system
         group system
    -    class main
    + #   class main
     
     service akmd8975 /system/bin/akmd8975
         disabled


Notes
-----
The modified boot image was found at
http://www.mediafire.com/download/avcudzc753254tb/JY-G2F-W-kernel-changer-to-0.3.6b.zip.

This boot image also fixes a bug with magnetic sensor service (*msensord*). See
http://4pda.ru/forum/index.php?showtopic=584280&view=findpost&p=40437370.


Misc
----
https://github.com/android/platform_system_core/blob/jb-release/init/readme.txt
