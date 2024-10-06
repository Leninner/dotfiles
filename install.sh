#!/bin/bash

# Zsh setup
ln -s "$HOME"/dotfiles/.zshrc "$HOME"/.zshrc

# Powerlevel10k setup
ln -s "$HOME"/dotfiles/.p10k.zsh "$HOME"/.p10k.zsh

# Reload zsh to apply changes
source "$HOME"/.zshrc
