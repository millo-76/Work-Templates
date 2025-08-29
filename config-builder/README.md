
# Cisco Config Builder

This project provides a Bash-driven modular configuration builder for Cisco devices.
It organizes switch configurations into reusable global, modules, and saved sets, making it easy to assemble custom configurations interactively.

## Features

- Interactive CLI menu – select device type (3850, C9800)
- Global – device-type–specific base configurations
- Modular – VLANs, etc. (currently only `vlans.conf`)
- Saved sets – save commonly used module bundles for quick reuse
- Variable substitution – fill in placeholders (e.g., hostname, domain)
- Output builder – exports final .conf files ready for deployment

## Project Structure (Current)

    config-builder/
    ├── global/                 # Device-specific global files
    │   ├── 3850_global.conf
    │   └── c9800_global.conf
    ├── modules/                # Modular files
    │   └── vlans.conf
    ├── sets/                   # Saved module lists (currently empty)
    ├── output/                 # Final generated configs (currently empty)
    ├── build_config.sh         # Main Bash script
    ├── set_manager.sh          # Script to manage sets
    └── README.md               # Documentation


## Usage

Clone the repo:

    git clone https://github.com/millo-76/config-builder.git
    cd config-builder

Make the script executable:

    chmod +x build_config.sh set_manager.sh

Run the main script:

    ./build_config.sh

Follow the prompts to select device type, pick modules (currently only `vlans.conf`), enter variables, and generate your config.

## Example Run

    Select device type:
    1) Cisco 3850 Switch
    2) Cisco C9800 WLC
    Choice: 1

    Available modules:
    1) vlans.conf
    Select modules (space separated): 1

    Enter hostname: SW1
    Enter domain name: uccs.edu
    ...
    Final config saved to: output/SW1_config.conf

## Extending

- Add new device types by dropping global configs into `global/`.
- Add new modules by creating `.conf` files in `modules/`.
- Create saved bundles by writing files inside `sets/`.
- Output is always generated in the `output/` directory.

## Requirements

- Bash shell (Linux, macOS, or WSL on Windows)
- `nano` (optional – used if you want to edit sets from inside the script)

## License

MIT – use, share, and improve freely.