#!/bin/bash
# Purpose:
#	* bootstrap machine in order to prepare for ansible playbook run

set -e

# Set install location -- this is where the playbook repo gets cloned
#  into. Suggest something like ~/.setup or ~/Code/setup
INSTALL_PATH="$HOME/.setup"

# Download and install Command Line Tools if no developer tools exist
# Checking for GCC isn't reliable. An xcode-select command returns 2
#  when Xcode isn't installed, so let's use that
if [[ -x "xcode-select -p" ]]; then
    echo "Info   | Install   | xcode"
    xcode-select --install
fi

# Download and install Homebrew
if [[ ! -x /usr/local/bin/brew ]]; then
    echo "Info   | Install   | homebrew"
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Download and install git
if [[ ! -x /usr/local/bin/git ]]; then
    echo "Info   | Install   | git"
    brew install git
fi

# Download and install Ansible
if [[ ! -x /usr/local/bin/ansible ]]; then
    echo "Info   | Install   | Ansible"
    brew update
    brew install ansible
fi

# Modify the PATH
# This should be subsequently updated in shell settings
export PATH=/usr/local/bin:$PATH

# Clone the repo locally so it can be run
if [[ ! -d $INSTALL_PATH ]]; then
    mkdir -p $INSTALL_PATH
    git clone https://github.com/agworld/setup.git $INSTALL_PATH
    echo "Info   | Clone     | setup repo"
fi

# Run the playbook
ansible-playbook $INSTALL_PATH/local.yml -i $INSTALL_PATH/hosts --ask-sudo-pass --connection=local
