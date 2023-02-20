# Testeroot

Testeroot is a collection of scripts and configurations for making it easier to
test software across a wide range of Linux kernels and architectures.

Our use-case is running a test-suite of eBPF programs over multiple machines
for quickly spotting regressions.

# Getting started with pre-compiled machines

Download a ready to use virtual machine [from our release page](https://github.com/Exein-io/testeroot/releases).

```
wget https://github.com/Exein-io/testeroot/releases/download/0.1/build_x86_64_5.15.tar.gz
tar -xzf build_x86_64_6.0.tar.gz
cd build_x86_64_6.0/images/
./start-qemu.sh
```

The machine can then be reached with SSH.

```
ssh root@localhost -p 3366
```

# Building new machines

If you need some sort of customization or the machine you need lacks a prebuilt binary,
you'll have to clone the project and build from source.
This repository is just a collection of configuration files for buildroot, so should you
probably consult [its documentation](https://buildroot.org/downloads/manual/manual.html).

```
git clone --recurse-submodules git@github.com:Exein-io/testeroot.git
```

```sh
./scripts/bootstrap.sh x86_64 5.15
```

## How to use

### Customizations

We've configured buildroot to make it fit for use-case. These can be included
with the `BR2_EXTERNAL` variable.
See <https://buildroot.org/downloads/manual/manual.html#outside-br-custom>

### Build directories

All the build artifacts will go in the `build` directory. Each target will have
its own `build/<arch>_<kernel>/` folder.

To save space and time, all the targets will share the downloaded files in `build/download`.

In order to hame multiple output directories, we use the buildroot "build out of tree" feature.
For more details, see <https://buildroot.org/downloads/manual/manual.html#_building_out_of_tree>

### Defconfig handling

```sh
# list available configurations
make list-defconfigs

# pick one of buildroot available defconfigs
make qemu_x86_64_defconfig

# save a custom one
make savedefconfig BR2_DEFCONFIG=$(realpath ../configs/qemu_x86_64_defconfig)
```

## Customizations

### Networking

The guest networking is started in user-mode, with the SSH port forwarding to
the guest 3366.

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

## Fragments folder

TODO: document folder

## Advanced topics

### Trying a custom kernel

Whether to test a particular commit or a local change, we may want to compile
a custom kernel.

Bootstrap a testeroot build directory as usual. Then edit `local.mk` and make
it point to your local clone:
```
LINUX_OVERRIDE_SRCDIR=/home/dev/projects/linux/
```

## Name

Testeroot is a composition of "tester" (because it's useful for testing software)
and "root" (because it's based on buildroot).
It also contains "teste", which is the Italian word for "heads". In some way,
we're running run the tests over multiple heads.


### History of customizations

These are the notes of the customizations:
- Installed sshd and a very unsecure server configuration
- Set static user networking. Customized qemu script
- Error /sys/kernel/btf/vmlinux file not found
  Solution: enable BTF
- Error btf not being generated in 5.19
  Solution: downgrade pahole to 1.22

- Problem: changing frament config not doing anything
  Solution: wans't updating dependencies

- Problem: missing files
  Solution: automount fstab

- Problem:
 failed program load lsm path_mknod
 Unknown BTF type `bpf_lsm_path_mknod`

- Problem:
  0: failed program attach kprobe security_path_mknod
  1: `/sys/bus/event_source/devices/kprobe/type`
  2: No such file or directory (os error 2)
  at /home/matteo/projects/pulsar/bpf-common/src/test_runner.rs:118:64
  Solution:
  CONFIG_KPROBES=y

- Problem:
  failed program attach kprobe security_path_mknod `perf_event_open` failed
  No such file or directory (os error 2)
  /home/matteo/projects/pulsar/bpf-common/src/test_runner.rs:118:64
  Solution:
  CONFIG_SECURITY_PATH=y
