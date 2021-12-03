# Mac Bootstrap

Adapt from [joshukraine bootstrap](https://github.com/joshukraine/mac-bootstrap)


## Prerequisites

1. Make sure your software is up to date:

        sudo softwareupdate -i -a --restart

1. Install Apple's command line tools:

        xcode-select --install

1. Reboot, check for additional updates, then reinstall and reboot as needed.

## Installation

- clone this repo
- run `./bootstrap.sh`

WARNING: This script will ask for your sudo password multiple times. You'll need to babysit it for a while. 😉

## Post-install Tasks

After running `bootstrap` there are still a few things that need to be done.

* Restart your machine in order for some changes to take effect.
* Complete [post-install tasks][post-install-tasks] from dotfiles README.
* Set up desired macOS keyboard shortcuts (see list below)


## macOS Keyboard Shortcuts

These are my (current) primary macOS keyboard shortcuts:

* Alfred: &#8984;Space
* Clipboard (Alfred) &#8997;&#8984;C
* Spotlight search: &#8984;&#8679;Space
* Switch input source: &#8963;&#8679;Space
* Fantastical: &#8997;&#8984;Space
* iTerm2 hotkey window: &#8997;Space
* Remap Caps Lock to CTRL (anyone know a way to automate this?)