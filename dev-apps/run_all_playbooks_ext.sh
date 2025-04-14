#!/bin/zsh

set -e

# === Configuration ===
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
ENV_DIR="$HOME/.ansible-env"
PYTHON="$ENV_DIR/bin/python"
PIP="$ENV_DIR/bin/pip"
INVENTORY="$SCRIPT_DIR/hosts.ini"
DEBUG=false

typeset -a PLAYBOOKS
typeset -A PLAYBOOK_DESCRIPTIONS
typeset -a SELECTED_PLAYBOOKS

# === Playbooks ===
PLAYBOOKS=(
  "$SCRIPT_DIR/install_apps.yml"
  "$SCRIPT_DIR/install_setup_services.yml"
  "$SCRIPT_DIR/create_ssh_key.yml"
)

PLAYBOOK_DESCRIPTIONS=(
  "$SCRIPT_DIR/install_apps.yml" "📦 Install GUI apps like QGIS, VS Code, etc."
  "$SCRIPT_DIR/install_setup_services.yml" "⚙️ Install dev tools: Java, PHP, Docker"
  "$SCRIPT_DIR/create_ssh_key.yml" "🔐 Generate SSH key pair"
)

typeset -A MODULE_DEPENDENCIES
MODULE_DEPENDENCIES=(
  docker "docker"
  aws "boto3"
  crypto "cryptography"
)

print_debug() {
  $DEBUG && echo "$1"
}

show_playbook_list() {
  echo "\n📘 Available playbooks:"
  for ((i = 1; i <= ${#PLAYBOOKS}; i++)); do
    pb="${PLAYBOOKS[$i]}"
    desc="${PLAYBOOK_DESCRIPTIONS[$pb]}"
    name=$(basename "$pb")
    echo "  [$i] $name - ${desc:-❓ No description available}"
  done
}

parse_arguments() {
  while [[ $# -gt 0 ]]; do
    case $1 in
      --all)
        SELECTED_PLAYBOOKS=("${PLAYBOOKS[@]}")
        return
        ;;
      --single)
        shift
        SELECTED_PLAYBOOKS+=("${PLAYBOOKS[$1]}")
        return
        ;;
      --range)
        shift
        IFS="-" read start end <<< "$1"
        for ((i = start; i <= end; i++)); do
          SELECTED_PLAYBOOKS+=("${PLAYBOOKS[$i]}")
        done
        return
        ;;
      --available-playbooks)
        show_playbook_list
        exit 0
        ;;
      --debug)
        DEBUG=true
        ;;
      *)
        echo "❌ Unknown argument: $1"
        exit 1
        ;;
    esac
    shift
  done
}

interactive_selection() {
  show_playbook_list
  echo "\n💡 Enter a selection:"
  echo "  all          → run all playbooks"
  echo "  single [N]   → run one playbook"
  echo "  range X-Y    → run multiple in order"
  read "choice?▶️  Your choice: "

  if [[ "$choice" == all ]]; then
    SELECTED_PLAYBOOKS=("${PLAYBOOKS[@]}")
  elif [[ "$choice" =~ single\ ([0-9]+) ]]; then
    index=$match[1]
    SELECTED_PLAYBOOKS+=("${PLAYBOOKS[$index]}")
  elif [[ "$choice" =~ range\ ([0-9]+)-([0-9]+) ]]; then
    start=$match[1]
    end=$match[2]
    for ((i = start; i <= end; i++)); do
      SELECTED_PLAYBOOKS+=("${PLAYBOOKS[$i]}")
    done
  else
    echo "❌ Invalid input."
    exit 1
  fi
}

cleanup() {
  [[ -n "$SUDO_KEEPALIVE_PID" ]] && kill "$SUDO_KEEPALIVE_PID" 2>/dev/null || true
}
trap cleanup EXIT

echo "▶️  Starting smart Ansible setup..."
parse_arguments "$@"
[[ ${#SELECTED_PLAYBOOKS} -eq 0 ]] && interactive_selection

# === Virtual environment ===
if [ ! -d "$ENV_DIR" ]; then
  echo "📦 Creating Python virtual environment at $ENV_DIR..."
  python3 -m venv "$ENV_DIR"
fi

echo "🐍 Activating virtual environment..."
source "$ENV_DIR/bin/activate"

# === Install Ansible ===
if ! $PYTHON -m pip show ansible >/dev/null 2>&1; then
  echo "⬇️  Installing Ansible..."
  $PIP install --upgrade pip
  $PIP install ansible
fi

# === Detect Python dependencies ===
echo "🔍 Scanning playbooks for additional Python dependencies..."
REQUIREMENTS=(ansible)

for pb in "${PLAYBOOKS[@]}"; do
  for module in "${(@k)MODULE_DEPENDENCIES}"; do
    if grep -q "$module" "$pb"; then
      dep=${MODULE_DEPENDENCIES[$module]}
      if [[ ${REQUIREMENTS[(ie)$dep]} -gt ${#REQUIREMENTS} ]]; then
        REQUIREMENTS+=("$dep")
      fi
    fi
  done
done

echo "📦 Installing required packages: ${REQUIREMENTS[*]}"
$PIP install "${REQUIREMENTS[@]}"

# === Sudo password ===
echo "🧑‍💻 Enter sudo password (will be cached)..."
sudo -v
while true; do sudo -n true; sleep 60; done 2>/dev/null &
SUDO_KEEPALIVE_PID=$!

# === Run selected playbooks ===
counter=1
for pb in "${SELECTED_PLAYBOOKS[@]}"; do
  echo -e "\n▶️ [$counter/${#SELECTED_PLAYBOOKS}] Running $(basename "$pb")"
  echo "📘 File: $pb"
  echo "📄 Exists? $( [ -f "$pb" ] && echo yes || echo NO )"

  echo "🚀 Running: ansible-playbook -i $INVENTORY $pb --ask-become-pass"
  ansible-playbook -i "$INVENTORY" "$pb" --ask-become-pass

  counter=$((counter + 1))
done

echo -e "\n✅ All selected playbooks completed successfully!"
