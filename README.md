# NKN-N1
Generate an image with nkn miner from armbian image(ubuntu) for Phicomn N1 device

### overview

Tested image is Armbian_5.77_Aml-s905_Ubuntu_bionic_default_5.1.0-rc1_20190408.img , others with a kernel version above 5.0 should be ok. If you use debian, you should comment or uncomment some lines in patch-img.sh between 39-43 according the apt source configuration in your image.

### How to

I do the following using the loop device on my pc, by mounting the image to /dev/loopx. You can also burn the image into a flash disk then do the following.

### Append your image

We need more space to install docker, so we have to append some space first.

> dd bs=512 seek=3653631 count=520000 if=/dev/zero of=Armbian_5.77_Aml-s905_Ubuntu_bionic_default_5.1.0-rc1_20190408.img

the seek need to be set by look at

> fdisk -l Armbian_5.77_Aml-s905_Ubuntu_bionic_default_5.1.0-rc1_20190408.img

the *seek* should be the end sector of the second partition, the *count* is the number of 512byte block, type 520000 and  append 260Mib.

After appending,use fdsik to delete partition2, and the rebuild it, notice that the start sector of the new partition 2 should be the start sector of origin partition 2, the end sector left default.

### mount the partition

then

> sudo losetup -P /dev/loop7 Armbian_5.77_Aml-s905_Ubuntu_bionic_default_5.1.0-rc1_20190408.img

If you use a destop, the paritions should be auto mounted, however, we should umount the second partition.

> sudo e2fsck -f /dev/loop7p2

then

> sudo resize2s /dev/loop7p2

after finish the *resize2fs*,mount the partition again.

### patch the image 

this step add some necessary files into the image.

modified your mount directory in the script first, line 6 and 7.

>BOOTDIR="/media/xubuntu/BOOT/"
>ROOTFSDIR="/media/xubuntu/ROOTFS/"

then execute the script with root privilege.

> chmod +x patch-img.sh
>
> sudo ./patch-img.sh

### chroot

If you don't  this on AARCH64 environment such as X86-64, you need a qemu, please use the package manage tools, like apt on ubuntu, install qemu-user-static, and then mount the loop device.

> sudo losetup -P /dev/loop7 Armbian_5.77_Aml-s905_Ubuntu_bionic_default_5.1.0-rc1_20190408.img

next, copy the qemu binary to the rootfs partition of the image (you can delete after you finish the chroot operation)

> sudo cp /usr/bin/qemu-aarch64-static /media/xubuntu/ROOTFS/usr/bin/qemu-aarch64-static

then copy the post-chroot.sh into the /root directory of the image and execute with root privilege.

### package the image

Exit the chroot environment, then you can delete the post-chroot.sh script and delete the qemu-aarch64-static. Umount the loop device.

> sudo umount /dev/loop7p1 
>
> sudo umount /dev/loop7p2
>
> sudo losetup -d /dev/loop7

then compress the image 

> xz -z -k -T0  Armbian_5.77_Aml-s905_Ubuntu_bionic_default_5.1.0-rc1_20190408.img