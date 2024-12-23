# Starknet Cairo Development Environment Setup

This repository documents the steps taken to set up a development environment for Starknet using Cairo programming language.

## Prerequisites

- Linux/Unix-based system (Ubuntu recommended)
- Python 3.9 or higher
- Git
- Rust and Cargo

## Installation Steps

### 1. Install Rust and Cargo
```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source $HOME/.cargo/env
```

### 2. Install Cairo Language
```bash
curl -L https://github.com/cairo-lang/cairo/releases/download/v2.5.3/cairo-2.5.3-ubuntu-22.04.deb -o cairo.deb
sudo dpkg -i cairo.deb
```

### 3. Install Python Dependencies
```bash
python3 -m pip install --upgrade pip
python3 -m pip install cairo-lang
```

### 4. Install Scarb (Cairo Package Manager)
```bash
curl --proto '=https' --tlsv1.2 -sSf https://docs.swmansion.com/scarb/install.sh | sh
```

### 5. Install VSCode Extensions
- Install "Cairo" extension for syntax highlighting and language support
- Install "Cairo Test Runner" for running tests directly from VSCode

### 6. Configure Environment Variables
Add the following to your `~/.bashrc` or `~/.zshrc`:
```bash
export PATH="$PATH:/path/to/cairo/bin"
```

### 7. Verify Installation
```bash
# Verify Cairo installation
cairo-compile --version

# Verify Scarb installation
scarb --version
```

## Additional Tools and Resources

### Starknet CLI
```bash
pip install starknet-devnet
pip install starknet-py
```

### Useful Development Tools
- [Starknet Devnet](https://github.com/0xSpaceShard/starknet-devnet) - Local Starknet development network
- [Protostar](https://github.com/software-mansion/protostar) - Cairo project management and testing framework
- [Nile](https://github.com/OpenZeppelin/nile) - Command line tool for Starknet development

## Troubleshooting

If you encounter any issues during installation:

1. Ensure all prerequisites are properly installed
2. Check system compatibility
3. Verify all environment variables are correctly set
4. Consult the [official Cairo documentation](https://www.cairo-lang.org/docs/) for detailed information

## Resources

- [Official Cairo Documentation](https://www.cairo-lang.org/docs/)
- [Starknet Documentation](https://docs.starknet.io/documentation/)
- [Cairo Book](https://book.cairo-lang.org/)
- [Starknet Ecosystem](https://www.starknet.io/ecosystem)

## Contributing

Feel free to contribute to this documentation by submitting pull requests or creating issues for any improvements or corrections.
