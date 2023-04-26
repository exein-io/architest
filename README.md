# Architest

Architest is a collection of scripts and configurations for making it easier to
test software across a wide range of Linux kernels and architectures.

Our use-case is running a test-suite of eBPF programs over multiple machines
for quickly spotting regressions.

## Getting started with pre-compiled machines

Download a ready to use virtual machine [from our release page](https://github.com/Exein-io/architest/releases).

```
wget https://github.com/Exein-io/architest/releases/download/0.2/aarch64_6.0.tar.gz
tar -xzf aarch64_6.0.tar.gz
cd build/aarch64_6.0/images/
./start-qemu.sh
```

The machine can then be reached over SSH.

```
ssh root@localhost -p 3366
```

## Building new machines

If you need some sort of customization or the machine you need lacks a prebuilt binary,
you'll have to clone the project and build from source.
This repository is just a collection of configuration files for buildroot, you'll probably
need to consult [its documentation](https://buildroot.org/downloads/manual/manual.html).

```
git clone --recurse-submodules git@github.com:Exein-io/architest.git
```

After cloning it you can setup a build folder. `make` will compile the kernel and the
root file system. Finally, the generated `start-qemu.sh` script will make it easy to
start `qemy-system` with the right settings.

```sh
$ ./scripts/bootstrap.sh x86_64 5.15
...
$ cd build/x86_64_5.15/
$ make
...
$ ./images/start-qemu.sh
...
```

## How to use

### Fragments folder and the bootstrap script

The `fragments/` folder contains the partial configurations:

- [fragments/common.frag](./fragments/common.frag) contains shared configurations
- [fragments/linux/](./fragments/linux/) contains kernel specific configurations
- [fragments/arch/](./fragments/arch/) contains architecture specific configurations

The [bootstrap script](./scripts/bootstrap.sh) will merge them together
to produce a working configuration. That script is extremely simple, it's just
a convenience for cancatenating the three files.

```
$ ./scripts/bootstrap.sh 
Usage: ./scripts/bootstrap.sh <architecture> <linux_version>

Available architectures:
- x86_64
- aarch64
- riscv64
- mips

Available linux versions:
- 5.5
- 5.10
- 5.13
- 5.15
- 6.0
```

### Build directories

All the build artifacts will go in the `build` directory. Each target will have
its own `build/<arch>_<kernel>/` folder.

To save space and time, all the targets will share the downloaded files in `build/download`.

In order to have multiple output directories, we use the buildroot "build out of tree" feature.
For more details, see <https://buildroot.org/downloads/manual/manual.html#_building_out_of_tree>

## Advanced topics

### Trying a custom kernel

Whether to test a particular commit or a local change, we may want to compile
a custom kernel.

Bootstrap a architest build directory as usual. Then edit `local.mk` and make
it point to your local clone:
```
LINUX_OVERRIDE_SRCDIR=/home/dev/projects/linux/
```

Note: `local.mk` is the default makefile override file, as specified by
`BR2_PACKAGE_OVERRIDE_FILE`. Configurations for kernels up to 5.15 do
override that settings to work-around a compilation issue with pahole.

## Customizations

### Buildroot linking

We include buildroot as a submodule. Than we include architest configurations
by using the `BR2_EXTERNAL` variable.
See <https://buildroot.org/downloads/manual/manual.html#outside-br-custom>

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

We've [enabled](./board/exein/common/linux.config) most kernel flags for eBPF support.

We've setup the [fstab file](./board/exein/common/overlay/etc/fstab) to auto-mount BPF
related folders:

- `/sys/fs/bpf`
- `/sys/kernel/debug`
- `/sys/kernel/tracing`
- `/sys/kernel/security`

