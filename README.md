# Monster Army Development Environment Setup

Quick setup script for onboarding new developers on macOS.

## What Gets Installed

- **CLI Tools**: node, pnpm, gh (GitHub CLI), go, jq, php, composer, certbot, commitizen, prettier
- **Applications**: Figma, Postman, Apidog, DBeaver, iTerm2, Microsoft Edge, VS Code extensions support
- **Development Tools**: Xcode, .NET SDK, OpenJDK, Rider

## Quick Start

1. Clone the Repo

   ```bash
   git clone https://github.com/codeware-au/setup-macbook.git
   ```

2. Run the setup:

   ```bash
   bash install.sh
   ```

## Troubleshooting

- **Command not found after installation:** Restart your terminal
- **Permission denied:** Make sure you ran `chmod +x install.sh`
- **Brew installation fails:** Ensure you have Xcode Command Line Tools: `xcode-select --install`
