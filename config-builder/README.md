Cisco Config Builder

This project provides a Bash-driven modular configuration builder for Cisco devices.
It organizes switch configurations into reusable global, modules, and saved sets, making it easy to assemble custom configurations interactively.

Features

    *Interactive CLI menu – select device type (3850, C9800).
    
    *Global – device-type–specific base configurations.
    
    *Modular – VLANs, ACLs, interfaces, AP ports, etc.
    
    *Saved sets – save commonly used module bundles for quick reuse.
    
    *Variable substitution – fill in placeholders (e.g., hostname, domain).
    
    *Output builder – exports final .conf files ready for deployment.

Project Structure

    cisco-config-builder/
    │
    │── global/                 # Device-specific global files
    │   ├── c9800_global.conf
    │   ├── 3850_global.conf
    │
    │── modules/                # Modular files
    │   ├── vlans.conf
    │   ├── acls.conf
    │   ├── interfaces.conf
    │   ├── ap_ports.conf
    │
    │── sets/                   # Saved module lists
    │   └── (your sets here)
    │
    │── output/                 # Final generated configs
    │   └── (your configs here)
    │
    │── build_config.sh          # Main Bash script
    └── README.md                # Documentation

Usage

Clone the repo:

    git clone https://github.com/<your-username>/cisco-config-builder.git
    cd cisco-config-builder

Make the script executable:

    chmod +x build_config.sh

Run the script:

    ./build_config.sh

Follow the prompts:

    Select your device type (e.g., 3850 or C9800).
    Pick modules you want to include.
    Enter variables (e.g., hostname, domain name).
    Save/load module sets if you want quick reuse.

Example Run

    Select device type:
    1) Cisco 3850 Switch
    2) Cisco C9800 WLC
    Choice: 1

    Available modules:

    1) vlans.conf
    2) acls.conf
    3) interfaces.conf
    4) ap_ports.conf
    Select modules (space separated): 1 3

    Enter hostname: SW1
    Enter domain name: uccs.edu
    ...
    Final config saved to: output/SW1_config.conf

Extending

    Add new device types by dropping global configs into global/.
    Add new modules by creating .conf files in modules/.
    Create saved bundles by writing .set files inside sets/.
    Output is always generated in the output/ directory.

Requirements

    Bash shell (Linux, macOS, or WSL on Windows).
    nano (optional – used if you want to edit sets from inside the script).

License

    MIT – use, share, and improve freely.
