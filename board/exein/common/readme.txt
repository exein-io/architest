Commands to run emulation. Note: these are used by board/qemu/post-image.sh to extract the qemu command line.

  qemu-system-x86_64 -M pc -kernel output/images/bzImage -drive file=output/images/rootfs.ext2,if=virtio,format=raw -append "rootwait root=/dev/vda console=tty1 console=ttyS0" -serial stdio -nic user,model=virtio-net-pci,hostfwd=tcp:127.0.0.1:3366-10.0.2.14:22 -m 1024M # qemu_x86_64_defconfig
  qemu-system-aarch64 -M virt -cpu cortex-a53 -nographic -smp 1 -kernel output/images/Image -append "rootwait root=/dev/vda console=ttyAMA0" -drive file=output/images/rootfs.ext2,if=none,format=raw,id=hd0 -device virtio-blk-device,drive=hd0 -nic user,model=virtio-net-pci,hostfwd=tcp:127.0.0.1:3366-10.0.2.14:22 -m 1024M # qemu_aarch64_defconfig
  qemu-system-mips64 -M malta -kernel output/images/vmlinux -serial stdio -drive file=output/images/rootfs.ext2,format=raw -append "rootwait root=/dev/sda" -nic user,model=virtio-net-pci,hostfwd=tcp:127.0.0.1:3366-10.0.2.14:22 -m 1024M # qemu_mips_defconfig



