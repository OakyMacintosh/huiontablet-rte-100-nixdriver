# Huion Inspiroy RTE-100 Nix Flake

This flake packages the **Huion Inspiroy RTE-100** tablet driver directly from Huion’s official `.deb` file.

It fetches, unpacks, and installs the driver declaratively — no `dpkg -i`, no mutable system state, no sorcery.

---

## ⚙️ Features

* Builds the **official Huion driver** from `.deb`
* Automatically patches binaries for Nix dynamic libraries
* Supports `nix build`, `nix run`, or `nix profile install`
* Easy to extend with udev rules for plug-and-play tablet use on NixOS

---

## 🧱 Building

Clone the flake and build:

```bash
git clone https://github.com/oakymacintosh/huiontablet-rte-100-nixdriver.git
cd huion-rte100-flake
nix build .#huion-driver
```

After building, you’ll get an output path like:

```
result -> /nix/store/…-huion-driver
```

---

## 🧬 Installing

Install the driver into your user profile:

```bash
nix profile install .#huion-driver
```

or system-wide (for NixOS modules):

```nix
environment.systemPackages = [ inputs.huion.packages.x86_64-linux.huion-driver ];
```

---

## 🔑 Fetching the `.deb`

The `.deb` is fetched automatically from Huion’s servers:

```
https://driverdl.huion.com/driver/Linux/HuionTablet_LinuxDriver_v15.0.0.162.x86_64.deb
```

If you want to verify or rehost it, you can compute the hash manually:

```bash
nix-prefetch-url "https://driverdl.huion.com/driver/Linux/HuionTablet_LinuxDriver_v15.0.0.162.x86_64.deb"
```

Paste the output into the `sha256` field in your `flake.nix`.

---

## 🦙 Optional — NixOS Integration

If you want full tablet functionality (udev, hotplug, GUI launcher), you can extend this flake into a NixOS module:

```nix
services.udev.packages = [ inputs.huion.packages.x86_64-linux.huion-driver ];
```

You might also wrap `HuionTablet` with `pkgs.makeWrapper` to place it on your `$PATH`.

---

## 📜 License

This flake itself is MIT-licensed.
The **Huion driver** inside the `.deb` is proprietary and redistributable **only by Huion**.

---
