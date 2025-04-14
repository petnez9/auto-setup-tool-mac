# auto-setup-tool-mac
This repo provides a fully automated setup for both development tools and a local geospatial database environment on macOS using Ansible and Zsh. It installs GUI apps, dev tools (Java, PHP, Docker), SSH/GitHub config, and a full PostgreSQL + PostGIS stack via Homebrew — no Docker required. Smart CLI with virtualenv isolation, secret management, and modular playbooks.

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


