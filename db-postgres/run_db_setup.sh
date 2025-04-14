#!/bin/zsh

set -e

# === Configuration ===
SCRIPT_DIR="$(cd "$(dirname "${(%):-%N}")" && pwd)"
ENV_DIR="$HOME/.ansible-env"
PYTHON="$ENV_DIR/bin/python"
PIP="$ENV_DIR/bin/pip"
PLAYBOOK="$SCRIPT_DIR/psgsql_db_setup.yml"
SECRETS_FILE="$SCRIPT_DIR/vars/secrets.yml"
INVENTORY="$SCRIPT_DIR/hosts.ini"

# Ansible module to Python dependency mapping
typeset -A MODULE_DEPENDENCIES
MODULE_DEPENDENCIES=(
  postgresql "psycopg2-binary"
  docker "docker"
  aws "boto3"
)

echo "▶️  Starting smart Ansible setup..."

# === Step 1: Set up virtual environment ===
if [ ! -d "$ENV_DIR" ]; then
  echo "📦 Creating Python virtual environment at $ENV_DIR..."
  python3 -m venv "$ENV_DIR"
fi

echo "🐍 Activating virtual environment..."
source "$ENV_DIR/bin/activate"

# === Step 2: Install Ansible if not already installed ===
if ! $PYTHON -m pip show ansible >/dev/null 2>&1; then
  echo "⬇️  Installing Ansible..."
  $PIP install --upgrade pip
  $PIP install ansible
fi

# === Step 3: Scan for additional Python dependencies ===
echo "🔍 Scanning playbook for additional Python dependencies..."
REQUIREMENTS=(ansible)

for module in "${(@k)MODULE_DEPENDENCIES}"; do
  if grep -q "$module" "$PLAYBOOK"; then
    dep=${MODULE_DEPENDENCIES[$module]}
    if [[ ${REQUIREMENTS[(ie)$dep]} -gt ${#REQUIREMENTS} ]]; then
      REQUIREMENTS+=("$dep")
    fi
  fi
done

echo "📦 Installing Python packages: ${REQUIREMENTS[*]}"
$PIP install "${REQUIREMENTS[@]}"

# === Step 4: Ensure vars/ directory exists and is writable ===
VARS_DIR="$SCRIPT_DIR/vars"
if [ ! -d "$VARS_DIR" ]; then
  echo "📁 Creating vars/ directory..."
  mkdir -p "$VARS_DIR"
fi

if [ ! -w "$VARS_DIR" ]; then
  echo "❌ ERROR: Cannot write to $VARS_DIR. Check permissions."
  exit 1
fi

# === Step 5: Create secrets.yml if it doesn't exist ===
if [ ! -f "$SECRETS_FILE" ]; then
  echo "🔐 No secrets.yml found. Let's create one."

  read "admin_password?👑 Superuser password for 'pn-admin': "
  echo
  read "user_password?👤 Standard DB user password for 'db-user': "
  echo

  cat > /tmp/secrets.yml <<EOF
admin_password: "$admin_password"
user_password: "$user_password"
EOF

  echo "🔒 Encrypting secrets.yml..."
  ansible-vault encrypt /tmp/secrets.yml --output "$SECRETS_FILE"
  rm /tmp/secrets.yml
else
  echo "🔐 Using existing encrypted secrets.yml"
fi

# === Step 6: Check if PostgreSQL service is running ===
echo "🔍 Checking if PostgreSQL service is running..."

if brew services list | grep -E '^postgresql(@\d+)?\s' | grep -q "started"; then
  echo "✅ PostgreSQL service is running."
else
  echo "⚠️ PostgreSQL service is not running. Starting it now..."
  brew services start postgresql@14
  sleep 3
fi


# === Step 7: Run Ansible playbook ===
echo "🚀 Running Ansible playbook..."
ansible-playbook -i "$INVENTORY" "$PLAYBOOK" --ask-vault-pass

# debug version
# ANSIBLE_DEBUG=1 ansible-playbook -i "$INVENTORY" "$PLAYBOOK" --ask-vault-pass
