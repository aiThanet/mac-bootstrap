
#!/usr/bin/env bash

################################################################################
# bootstrap
#
# This script is intended to set up a new Mac computer with my dotfiles and
# other development preferences.
################################################################################


# Thank you, thoughtbot!
bootstrap_echo() {
  local fmt="$1"; shift

  # shellcheck disable=SC2059
  printf "\\n[BOOTSTRAP] $fmt\\n" "$@"
}


################################################################################
# VARIABLE DECLARATIONS
################################################################################

osname=$(uname)

export COMMANDLINE_TOOLS="/Library/Developer/CommandLineTools"
export OLD_DOTFILES_BAK="${HOME}/old_dotfiles_bak"
export DOTFILES_REPO_URL="https://github.com/aiThanet/dotfiles.git"
export DOTFILES_DIR="${HOME}/dotfiles"
export BOOTSTRAP_REPO_URL="https://github.com/aiThanet/mac-bootstrap.git"
export BOOTSTRAP_DIR="${HOME}/mac-bootstrap"

PS3="> "

comp=$(scutil --get ComputerName)
host=$(scutil --get LocalHostName)

if [ -z "$comp" ] || [ -z "$host" ]; then
  DEFAULT_COMPUTER_NAME="My Mac Computer"
  DEFAULT_HOST_NAME="my-mac-computer"
else
  DEFAULT_COMPUTER_NAME="$comp"
  DEFAULT_HOST_NAME="$host"
fi

DEFAULT_DOTFILES_BRANCH="master"
DEFAULT_NODEJS_VERSION="12.18.3"
DEFAULT_RUBY_VERSION="2.7.1"
export ASDF_NODEJS_VERSION=$DEFAULT_NODEJS_VERSION


################################################################################
# Make sure we're on a Mac before continuing
################################################################################

if [ "$osname" == "Linux" ]; then
  bootstrap_echo "Oops, looks like you're on a Linux machine."
  exit 1
elif [ "$osname" != "Darwin" ]; then
  bootstrap_echo "Oops, it looks like you're using a non-UNIX system. This script
only supports Mac. Exiting..."
  exit 1
fi


################################################################################
# Check for presence of command line tools if macOS
################################################################################

if [ ! -d "$COMMANDLINE_TOOLS" ]; then
  bootstrap_echo "Apple's command line developer tools must be installed before
running this script. To install them, just run 'xcode-select --install' from
the terminal and then follow the prompts. Once the command line tools have been
installed, you can try running this script again."
  exit 1
fi


################################################################################
# Authenticate
################################################################################

sudo -v

# Keep-alive: update existing `sudo` time stamp until bootstrap has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

set -e


################################################################################
# Welcome and setup
################################################################################

echo
echo "*************************************************************************"
echo "*******                                                           *******"
echo "*******                 Welcome to Mac Bootstrap!                 *******"
echo "*******                                                           *******"
echo "*************************************************************************"
echo

printf "Before we get started, let's get some info about your setup.\\n"

printf "\\nPlease select a default shell.\\n"
select my_shell in fish zsh
do
  case $my_shell in
    fish)
      export DEFAULT_SHELL="fish"
      break
      ;;
    zsh)
      export DEFAULT_SHELL="zsh"
      break
      ;;
    *)
      echo "Please enter 1 for fish or 2 for zsh."
      ;;
  esac
done

printf "\\nLooks good. Here's what we've got so far.\\n"
printf "Computer name:     ==> [%s]\\n" "$COMPUTER_NAME"
printf "Host name:         ==> [%s]\\n" "$HOST_NAME"
printf "Default shell:     ==> [%s]\\n" "$DEFAULT_SHELL"

echo
read -p "Continue? (y/n) " -n 1 -r
echo
if [[ ! "$REPLY" =~ ^[Yy]$ ]]; then
  echo "Exiting..."
  exit 1
fi

################################################################################
# 1. Provision with my adaptation of Laptop (install/laptop)
################################################################################

bootstrap_echo "Step 1: Installing Laptop script..."

sh "${BOOTSTRAP_DIR}/install/laptop" | tee ~/laptop.log

bootstrap_echo "Done!"


################################################################################
# 2. Install Oh My Zsh
################################################################################

if [ "$DEFAULT_SHELL" == "zsh" ]; then
  bootstrap_echo "Step 2: Installing Oh My Zsh..."

  if [ -d "${HOME}/.oh-my-zsh" ]; then
    rm -rf "${HOME}/.oh-my-zsh"
  fi

  git clone https://github.com/robbyrussell/oh-my-zsh.git "${HOME}/.oh-my-zsh"

  if [ -d /usr/local/share/zsh ]; then
    bootstrap_echo "Setting permissions for /usr/local/share/zsh..."
    sudo chmod -R 755 /usr/local/share/zsh
  fi

  if [ -d /usr/local/share/zsh/site-functions ]; then
    bootstrap_echo "Setting permissions for /usr/local/share/zsh/site-functions..."
    sudo chmod -R 755 /usr/local/share/zsh/site-functions
  fi

  bootstrap_echo "Done!"
else
  bootstrap_echo "Step 2: Zsh not selected. Skipping Oh My Zsh installation."
fi


################################################################################
# 3. Set macOS preferences
################################################################################

bootstrap_echo "Step 3: Setting macOS preferences..."

# shellcheck source=/dev/null
# source "${BOOTSTRAP_DIR}/install/macos-defaults"

bootstrap_echo "Done!"

################################################################################
# 4. Install ~/bin utilities
################################################################################

bootstrap_echo "Step 4: Installing ~/bin utilities..."

# cp -R "$BOOTSTRAP_DIR"/bin/* "${HOME}/bin/"

bootstrap_echo "Done!"


################################################################################
# 5. Set up Tmuxinator (https://github.com/tmuxinator/tmuxinator)
################################################################################

bootstrap_echo "Step 5: Setting up Tmuxinator..."

# if [ ! -d "${HOME}/.tmuxinator/" ]; then
#   mkdir "${HOME}/.tmuxinator"
# fi

# if [ "$DEFAULT_SHELL" == "zsh" ]; then
#   bootstrap_echo "Installing zsh completions..."
#   wget https://raw.githubusercontent.com/tmuxinator/tmuxinator/master/completion/tmuxinator.zsh -O /usr/local/share/zsh/site-functions/_tmuxinator
# fi

# cp "${BOOTSTRAP_DIR}/lib/default.yml" "${HOME}/.tmuxinator/"

bootstrap_echo "Done!"



################################################################################
# 7. Setup dotfiles
################################################################################

bootstrap_echo "Step 7: Installing dotfiles..."

# if [[ -d $DOTFILES_DIR ]]; then
#   bootstrap_echo "Backing up old dotfiles to ${HOME}/old_dotfiles_bak..."
#   rm -rf "$OLD_DOTFILES_BAK"
#   cp -R "$DOTFILES_DIR" "$OLD_DOTFILES_BAK"
#   rm -rf "$DOTFILES_DIR"
# fi

# bootstrap_echo "Cloning dotfiles repo to ${DOTFILES_DIR} ..."

# git clone "$DOTFILES_REPO_URL"

# shellcheck source=/dev/null
source "${DOTFILES_DIR}/install.sh"

bootstrap_echo "Done!"

# rm -rf "$BOOTSTRAP_DIR"

echo
echo "**********************************************************************"
echo "**********************************************************************"
echo "****                                                              ****"
echo "**** Mac Bootstrap script complete! Please restart your computer. ****"
echo "****                                                              ****"
echo "****                                                              ****"
echo "**********************************************************************"
echo "**********************************************************************"
echo