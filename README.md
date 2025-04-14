# auto-setup-tool-mac
This repo provides an automated setup for both development tools and a local geospatial database environment on macOS using Ansible and Zsh. It installs GUI apps, dev tools (Java, PHP, Docker), SSH/GitHub config, and a full PostgreSQL + PostGIS stack via Homebrew — no Docker required. Smart CLI with virtualenv isolation, secret management, and modular playbooks.

© 2025 Peter Nezval

# 🧰 Smart macOS Dev + PostGIS Environment Setup

This repository provides a modular, automated setup for:

1. **🖥️ Development Environment** – GUI apps (e.g. QGIS, VSCode), dev tools (Java, PHP, Docker), SSH key + GitHub setup
2. **🗄️ PostgreSQL/PostGIS Setup** – Installs a fully functional spatial database stack directly via Homebrew (no Docker)

The setup is managed with **Ansible playbooks** and a **Zsh runner script** that handles environment isolation, secret encryption, dependency scanning, and more.

---

## ⚙️ System Requirements

- macOS (tested on Monterey and newer)
- [Homebrew](https://brew.sh)
- [`zsh`](https://www.zsh.org/) as the terminal shell
- Python 3.8+ (`python3` available in `$PATH`)
- GitHub account (for SSH key auth + Git config)
- (Optional) GPG installed for commit signing

> 💡 All dependencies are auto-installed inside a dedicated Python virtual environment (`~/.ansible-env`).

---

## 🚀  QuickStart

## 💻 1. Install and Set Up Homebrew

Homebrew is the macOS package manager used to install most dependencies.

```bash
# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Add Homebrew to PATH (Apple Silicon)
/opt/homebrew/bin/brew shellenv >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
```

---

## ⚙️ 2. Install Ansible via Homebrew

```bash
brew install ansible
```

---

## 🔐 3. Manage Ansible Vault

Use Vault to securely store and access secrets (like DB passwords) in your playbooks.

```bash

# Optionally encrypt an existing file
ansible-vault encrypt vars/secrets.yml

# View contents (requires password)
ansible-vault view vars/secrets.yml
```

Example contents of `vars/secrets.yml`:

```yaml
admin_password: "My$ecureAdminPass"
user_password: "My$ecureUserPass"
```

Store your Vault password securely:

```bash
echo "yourpassword" > ~/.vault_pass.txt
chmod 600 ~/.vault_pass.txt
```

---

## 📁 4. Run Ansible Playbooks

Basic playbook commands:

```bash
# With sudo prompt
ansible-playbook -i hosts.ini install_apps.yml --ask-become-pass

# With vault password file
ansible-playbook install_apps.yml -i hosts.ini --ask-become-pass --vault-password-file ~/.vault_pass.txt
```

---

## ☕ 5. Add Java to PATH (If Needed)

Only needed if you're using Homebrew-installed OpenJDK directly.

```bash
echo 'export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"' >> ~/.zprofile
```

---

## 🤖 6. Use Your Smart Automation Script

The script `run_all_playbooks.sh` supports interactive and CLI-based execution.

```bash
# Interactive selection
./run_all_playbooks.sh

# Run all playbooks
./run_all_playbooks.sh --all

# Run a single playbook by index
./run_all_playbooks.sh --single 2

# Run a range of playbooks
./run_all_playbooks.sh --range 1-2

# Show available playbooks
./run_all_playbooks.sh --available-playbooks
```

---

## 📄 License

MIT License

Permission is hereby granted, free of charge, to any person obtaining a copy  
of this software and associated documentation files (the “Software”), to deal  
in the Software without restriction, including without limitation the rights  
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell  
copies of the Software, and to permit persons to whom the Software is  
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in  
all copies or substantial portions of the Software.

**THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND**, EXPRESS OR  
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,  
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE  
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER  
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,  
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE  
SOFTWARE.


