#!/bin/bash

USER_HOME_DIR=$(eval echo ~"$USER")

# Zsh setup
ln -s "$(pwd)"/.zshrc "$USER_HOME_DIR"/.zshrc

# Powerlevel10k setup
ln -s "$(pwd)"/.p10k.zsh "$USER_HOME_DIR"/.p10k.zsh

# Reload zsh to apply changes
source "$USER_HOME_DIR"/.zshrc
