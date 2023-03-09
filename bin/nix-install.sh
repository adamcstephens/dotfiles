#!/bin/sh

# This script installs the Nix package manager on your system by
# downloading a binary distribution and running its installer script
# (which in turn creates and populates /nix).

{ # Prevent execution if this script was only partially downloaded
oops() {
    echo "$0:" "$@" >&2
    exit 1
}

umask 0022

tmpDir="$(mktemp -d -t nix-binary-tarball-unpack.XXXXXXXXXX || \
          oops "Can't create temporary directory for downloading the Nix binary tarball")"
cleanup() {
    rm -rf "$tmpDir"
}
trap cleanup EXIT INT QUIT TERM

require_util() {
    command -v "$1" > /dev/null 2>&1 ||
        oops "you do not have '$1' installed, which I need to $2"
}

case "$(uname -s).$(uname -m)" in
    Linux.x86_64)
        hash=2fbe249d8e42a48eec78db2d2eb626655021c5f091f985e82e2d32d14160e890
        path=428mw94jb35fl48vp2cp3bhq98v6c3v6/nix-2.14.1-x86_64-linux.tar.xz
        system=x86_64-linux
        ;;
    Linux.i?86)
        hash=801397fcff1c4ff9125037d78f154924379fc4f91d99e3292e9c0f16442eae39
        path=qji6ilnhwx1aa693n94yn2zm9vwinyjb/nix-2.14.1-i686-linux.tar.xz
        system=i686-linux
        ;;
    Linux.aarch64)
        hash=96c944c00a0f6757a05c5f6d3bdba9115afd5289eb7357324034d8b11ff6e4ac
        path=9c19cg51gr24f3dxx23cjk8hgh7blc33/nix-2.14.1-aarch64-linux.tar.xz
        system=aarch64-linux
        ;;
    Linux.armv6l)
        hash=ad830d3a4bd38432e71c13bcb3482fefdd12b67fdbb99e450dadafea25a4ccb2
        path=la5v54k3xkh5a3421mbdm5kg4c2m013x/nix-2.14.1-armv6l-linux.tar.xz
        system=armv6l-linux
        ;;
    Linux.armv7l)
        hash=1c95d7abba8d3ee8997733621d075aea48d146e63b0b6c9df1cb6f0338b2ad3c
        path=va7cqr7k5glhry0p8jzyg6ilz81xg61w/nix-2.14.1-armv7l-linux.tar.xz
        system=armv7l-linux
        ;;
    Darwin.x86_64)
        hash=39d7db509b360e129e932b758402ffad0d1669c612c0dae2b8db3a3511e8831c
        path=56nfhn580wxlfri0p1qvab9pq1mk5gsy/nix-2.14.1-x86_64-darwin.tar.xz
        system=x86_64-darwin
        ;;
    Darwin.arm64|Darwin.aarch64)
        hash=4ed09ff768c795f3b859d7821e6023ce1f402be4c550b8c3d48493c3c4ad0746
        path=rinizlyqqf5fsa2ssla8mnjr3bys2bpl/nix-2.14.1-aarch64-darwin.tar.xz
        system=aarch64-darwin
        ;;
    *) oops "sorry, there is no binary distribution of Nix for your platform";;
esac

# Use this command-line option to fetch the tarballs using nar-serve or Cachix
if [ "${1:-}" = "--tarball-url-prefix" ]; then
    if [ -z "${2:-}" ]; then
        oops "missing argument for --tarball-url-prefix"
    fi
    url=${2}/${path}
    shift 2
else
    url=https://releases.nixos.org/nix/nix-2.14.1/nix-2.14.1-$system.tar.xz
fi

tarball=$tmpDir/nix-2.14.1-$system.tar.xz

require_util tar "unpack the binary tarball"
if [ "$(uname -s)" != "Darwin" ]; then
    require_util xz "unpack the binary tarball"
fi

if command -v curl > /dev/null 2>&1; then
    fetch() { curl --fail -L "$1" -o "$2"; }
elif command -v wget > /dev/null 2>&1; then
    fetch() { wget "$1" -O "$2"; }
else
    oops "you don't have wget or curl installed, which I need to download the binary tarball"
fi

echo "downloading Nix 2.14.1 binary tarball for $system from '$url' to '$tmpDir'..."
fetch "$url" "$tarball" || oops "failed to download '$url'"

if command -v sha256sum > /dev/null 2>&1; then
    hash2="$(sha256sum -b "$tarball" | cut -c1-64)"
elif command -v shasum > /dev/null 2>&1; then
    hash2="$(shasum -a 256 -b "$tarball" | cut -c1-64)"
elif command -v openssl > /dev/null 2>&1; then
    hash2="$(openssl dgst -r -sha256 "$tarball" | cut -c1-64)"
else
    oops "cannot verify the SHA-256 hash of '$url'; you need one of 'shasum', 'sha256sum', or 'openssl'"
fi

if [ "$hash" != "$hash2" ]; then
    oops "SHA-256 hash mismatch in '$url'; expected $hash, got $hash2"
fi

unpack=$tmpDir/unpack
mkdir -p "$unpack"
tar -xJf "$tarball" -C "$unpack" || oops "failed to unpack '$url'"

script=$(echo "$unpack"/*/install)

[ -e "$script" ] || oops "installation script is missing from the binary tarball!"
export INVOKED_FROM_INSTALL_IN=1
"$script" "$@"

} # End of wrapping
