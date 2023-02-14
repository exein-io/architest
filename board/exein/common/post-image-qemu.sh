#!/bin/bash
# Install a start-qemu.sh into the images directory.
# This is a customization of buildroot's board/qemu/post-image.sh:
# - Networking has SSH port forwarded to host:3366

echo $2

START_QEMU_SCRIPT="${BINARIES_DIR}/start-qemu.sh"

QEMU_COMMON="\\
 -m 1024M \\
 -nographic"
QEMU_NETWORK="\\
  -nic user,model=virtio-net-pci,hostfwd=tcp:127.0.0.1:3366-10.0.2.14:22"
case ${2} in
  x86_64)
    QEMU_CMD=qemu-system-x86_64
    QEMU_ARGS="\\
      -M pc \\
      -kernel bzImage \\
      -drive file=rootfs.ext2,if=virtio,format=raw \\
      -append \"rootwait root=/dev/vda console=tty1 console=ttyS0\""
    ;;

  aarch64)
    QEMU_CMD=qemu-system-aarch64
    QEMU_ARGS="\\
      -M virt \\
      -cpu cortex-a53 \\
      -smp 1 \\
      -kernel Image \\
      -append \"rootwait root=/dev/vda console=ttyAMA0\" \\
      -drive file=rootfs.ext2,if=none,format=raw,id=hd0 \\
      -device virtio-blk-device,drive=hd0"
    ;;

  mips)
    QEMU_CMD=qemu-system-mips64
    QEMU_ARGS="\\
      -M malta \\
      -kernel vmlinux \\
      -serial stdio \\
      -drive file=rootfs.ext2,format=raw \\
      -append \"rootwait root=/dev/sda\""
    ;;

  riscv64)
    QEMU_CMD=qemu-system-riscv64
    QEMU_ARGS="\\
      -M virt \\
      -kernel Image \\
      -append \"rootwait root=/dev/vda ro\" \\
      -drive file=rootfs.ext2,format=raw,id=hd0  \\
      -device virtio-blk-device,drive=hd0 -nographic"
      QEMU_NETWORK="\\
        -netdev user,id=net0,hostfwd=tcp:127.0.0.1:3366-10.0.2.14:22 \\
        -device virtio-net-device,netdev=net0"
    ;;

  *)
    echo "Missing architecture argument"
    echo "It should be set with the BR2_ROOTFS_POST_SCRIPT_ARGS config"
    exit 1
    ;;
esac

cat <<-_EOF_ > "${START_QEMU_SCRIPT}"
	#!/bin/sh
	(
	BINARIES_DIR="\${0%/*}/"
	cd \${BINARIES_DIR}

	export PATH="${HOST_DIR}/bin:\${PATH}"
	exec ${QEMU_CMD} ${QEMU_ARGS} ${QEMU_COMMON} ${QEMU_NETWORK}
	)
_EOF_

chmod +x "${START_QEMU_SCRIPT}"
