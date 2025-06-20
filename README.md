# Architest

Architest is a collection of scripts and configurations for making it easier to
test software across a wide range of Linux kernels and architectures.

Our use-case is running a test-suite of eBPF programs over multiple machines
for quickly spotting regressions.

## Getting started with pre-compiled machines

Download a ready to use virtual machine [from our release page](https://github.com/exein-io/architest/releases).

```
wget https://github.com/exein-io/architest/releases/download/0.2/aarch64_6.12.tar.gz
tar -xzf aarch64_6.12.tar.gz
cd build/aarch64_6.12/images/
./start-qemu.sh
```

The machine can then be reached over SSH.

```
ssh root@localhost -p 3366
```

To download all available pre-compiled machines, you can use [Github CLI](https://cli.github.com/):

```
gh release download -R exein-io/architest -D release -p "*.tar.gz"
cd release
for file in *.tar.gz; do tar -xzf $file --one-top-level && rm $file; done
ls
```

## Building new machines

If your project requires specific customizations or if a pre-built binary 
for your desired configuration isn't available, you'll need to build a machine
from source.
This repository is a collection of configuration files for Buildroot.For detailed info
please consult [its official documentation](https://buildroot.org/downloads/manual/manual.html).

First, clone the project and submodules:
```
git clone --recurse-submodules git@github.com:Exein-io/architest.git
```

After cloning it you can setup a build folder using the `bootstrap.sh` script. 
The `make` will compile the kernel and the root file system. 
Finally, the generated `start-qemu.sh` script provide an easy way to
start `qemu-system` with the correct settings.

```sh
# Bootstrap for aarch64 with kernel 5.15.185
$ ./scripts/bootstrap.sh x86_64 5.15.185
...
$ cd build/x86_64_5.15/
$ make
...
$ ./images/start-qemu.sh
...
```

## How to use

### Fragments folder and the bootstrap script

The `fragments/` directory contains partial configurations:

- [fragments/common.frag](./fragments/common.frag) contains configurations shared across all architectures and kernel versions.
- [fragments/arch/](./fragments/arch/) contains architecture specific configurations (e.g., `x86_64.frag`, `aarch64.frag`).
- [fragments/linux/](./fragments/linux/) *optional* contains kernel specific configurations - merged only if a `<kernel-version>.frag` exists (e.g. we have 5.15.185frag for paole version downgrade)

The [bootstrap script](./scripts/bootstrap.sh) merges these fragments to 
produce a working Buildroot `.config` file. That script is extremely simple, it's just
a convenience for concatenating the three files.

```
$ ./scripts/bootstrap.sh 
Usage: ./scripts/bootstrap.sh <architecture> <kernel-version>

Available architectures:
- x86_64
- aarch64
- riscv64

Available linux versions:
Provide the exact kernel version you wish to build (e.g., 5.15.185 or 5.15).
If no version-specific fragment exists, only the common and architecture fragmests will be merged.
```

### Build directories

All build artifacts are places in the `build/` directory. Each target will have
its own `build/<arch>_<kernel-version>/` folder.

To optimize space and time, all the targets will share the downloaded source files in `build/download/` directory.

This project leverages Buildroot's "build out of tree" feature, which allows
multiple output directories from a single Buildroot source tree.
For more details, see <https://buildroot.org/downloads/manual/manual.html#_building_out_of_tree>

## Advanced topics

### Trying a custom kernel

Whether to test a particular commit or a local change, you might want to compile
a custom kernel.

First, bootstrap an Architest build directory as usual. Then edit `external.mk` and make
it point to your local clone:
```
LINUX_OVERRIDE_SRCDIR=/home/dev/projects/linux/
```

Note: `external.mk` is the default makefile override mechanism, specified by
`BR2_PACKAGE_OVERRIDE_FILE`. Configurations for kernels up to 5.15 use the kernel-specific fragment
to override that settings to work-around a compilation issue with `pahole`.

### Building a release

The `./scripts/release.sh` script can be used to automate the creation of
of multiple machines. For each architecture/kernel combination defined in that file,
the script will call `./scripts/bootstrap.sh $ARCH $KERNEL`, run `make` and finally
pack the results into an archive located in `./build/release/$ARCH_$KERNEL.tar.gz`.

## Customizations

### Buildroot integration

We include buildroot as a Git submodule. Architest configurations are then 
integrated into Buildroot using the `BR2_EXTERNAL` variable.
See [Buildroot manual on external trees] (https://buildroot.org/downloads/manual/manual.html#outside-br-custom)

### Networking

The guest networking is started in user-mode, with the SSH port forwarding to
the host port 3366. This is [very unsecure](./board/exein/common/overlay/etc/ssh/sshd_config),
be aware that anyone with access to local port 3366 will have root access to the
qemu virtual machine.

We use user networking to avoid the need for root access when starting up qemu.

```
-nic user,model=virtio-net-pci,hostfwd=tcp:127.0.0.1:3366-10.0.2.14:22
```

You can connect with `ssh qemu` after adding this alias to your `~/.ssh/config`:
```
Host qemu
  Hostname localhost
  User root
  port 3366
  StrictHostKeyChecking no
  UserKnownHostsFile /dev/null
  LogLevel QUIET
```

### BPF support

We've [enabled](./board/exein/common/) most kernel flags necessary for eBPF support for each architecture/kernel.

We've setup the [fstab file](./board/exein/common/overlay/etc/fstab) to auto-mount BPF
related folders:

- `/sys/fs/bpf`
- `/sys/kernel/debug`
- `/sys/kernel/tracing`
- `/sys/kernel/security`