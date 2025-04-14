# 🗄️ PostgreSQL Database Setup Manual

This guide helps you automate the setup of a PostgreSQL + PostGIS database with Ansible on macOS using Homebrew, Ansible Vault, and a smart shell wrapper.

---

## 📦 1. What This Does

This setup will:

- Install PostgreSQL 14, PostGIS, and pgAdmin4 using Homebrew
- Start the PostgreSQL service
- Create a superuser (`pn-admin`) and a standard user (`db-user`)
- Create a database (`test_db`) and grant privileges
- Enable the PostGIS extension
- Manage secrets securely using Ansible Vault
- Run everything using a smart wrapper script and isolated Python virtual environment

---

## 🧰 2. Requirements

- macOS with Homebrew
- `python3` and `pip`
- Internet access to install dependencies
- Optional: Ansible Vault password stored in `~/.vault_pass.txt`

---

## 🛠️ 3. Installation & Usage

### Step 1: Clone your repo

```bash
git clone <your-repo-url>
cd <your-repo>
```

### Step 2: Make your script executable

```bash
chmod +x run_postgres_setup.sh
```

### Step 3: Run the script

```bash
./run_postgres_setup.sh
```

This will:

- Create a Python virtual environment under `~/.ansible-env`
- Install Ansible and required Python dependencies (e.g. `psycopg2-binary`)
- Prompt you to enter DB passwords if not yet created
- Encrypt secrets using Ansible Vault
- Start PostgreSQL if not running
- Run the playbook

---

## 🔐 4. Secrets Management

Secrets (like database user passwords) are stored in `vars/secrets.yml`, encrypted with Ansible Vault.

Example encrypted content:

```yaml
admin_password: "My$ecureAdminPass"
user_password: "My$ecureUserPass"
```

To decrypt:

```bash
ansible-vault view vars/secrets.yml
```

To edit:

```bash
ansible-vault edit vars/secrets.yml
```

---

## 📁 5. Playbook File: `psgsql_db_setup.yml`

Includes tasks to:

- Install PostgreSQL/PostGIS/pgAdmin4
- Start PostgreSQL
- Create users and database
- Grant privileges
- Enable PostGIS extension

---

## 📂 6. Inventory File: `hosts.ini`

Minimal content:

```ini
[local]
localhost ansible_connection=local
```

---

## ✅ 7. After Setup

- You can connect to the DB via `psql` or pgAdmin.
- Use the user `pn-admin` or `db-user` as needed.

---

## 🧼 8. Cleaning Up

To stop PostgreSQL:

```bash
brew services stop postgresql@14
```

To remove the virtual environment:

```bash
rm -rf ~/.ansible-env
```

---

## 📌 Tips

- Always commit your `vars/secrets.yml` encrypted to Git (never plain-text!)
- You can re-run the script anytime; it will skip what's already set up
- Adjust the database name and usernames directly in the playbook

---
