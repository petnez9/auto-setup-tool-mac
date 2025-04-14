# 🧰 Smart macOS Setup with Ansible + Zsh

This repository provides a fully automated way to set up a development environment on macOS using **Ansible** and a smart **Zsh runner script**. It includes:

- GUI apps (e.g. QGIS, VSCode, IntelliJ)
- Development services (Java, PHP, Docker)
- SSH key generation
- Python virtual environment isolation
- Dynamic playbook runner with smart selection

---

## 🚀 Quick Start

```bash
./run_all_playbooks_ext.sh
```

You will be prompted to:

- Select which playbooks to run (interactive or CLI options)
- Enter your sudo password once
- Optionally debug with `--debug`

---

## 📁 Playbook Overview

| Playbook | Description |
|----------|-------------|
| `install_apps.yml` | 📦 Install GUI apps (QGIS, VS Code, IntelliJ, etc.) |
| `install_setup_services.yml` | ⚙️ Install dev tools (Java, PHP, Docker) |
| `create_ssh_key.yml` | 🔐 Generate an SSH key pair with Ansible |

---

## 📜 Script Details

### `run_all_playbooks_ext.sh`

This Zsh script automates:

- 🐍 Creating a Python virtual environment in `~/.ansible-env`
- 📦 Installing Ansible and required Python dependencies
- 🔍 Scanning playbooks for keywords (`docker`, `crypto`, etc.)
- 🔐 Caching sudo credentials
- 🧠 Letting you choose playbooks to run interactively or via flags

### CLI Options

```bash
./run_all_playbooks_ext.sh --all
./run_all_playbooks_ext.sh --single 2
./run_all_playbooks_ext.sh --range 1-2
./run_all_playbooks_ext.sh --available-playbooks
./run_all_playbooks_ext.sh --debug
```

---

## 🛠️ Requirements

- macOS with Homebrew installed
- `zsh` as your shell
- Python 3.8+ (`python3` should be available)
- Internet connection (for `pip` and Homebrew)

---

## 📦 Python Dependencies (Auto-Detected)

Your script intelligently installs only what's needed:

- `ansible`
- `docker` (for Docker modules)
- `cryptography` (for SSH key modules)
- `boto3` (for AWS modules, if needed)

---

## 🔐 SSH Key Playbook

The `create_ssh_key.yml` playbook automates Git/GitHub setup by:

- 🔑 Generating a 4096-bit RSA key at `~/.ssh/id_rsa_custom`
- 🧠 Adding the key to your local `ssh-agent`
- 🧰 Installing GitHub CLI (`gh`) via Homebrew
- 🌐 Logging in to GitHub securely via browser (SSH-based login)
- 🧾 Setting your Git username and email globally

### How It Works

When you run the playbook, you'll be prompted for:

- Your Git username and email (to set globally via `git config`)

If you're already authenticated with GitHub (`~/.config/gh/hosts.yml` exists), the login step is skipped automatically.

The public SSH key is printed at the end of the playbook for manual reuse if needed.

### Example key path

```bash
~/.ssh/id_rsa_custom

---

## 📌 Tips

- All operations are local (`hosts.ini` points to `localhost`)
- The SSH playbook uses your current system username for file permissions
- You can extend this setup easily by dropping new playbooks into the folder and updating the script

---



