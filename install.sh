#!/usr/bin/env bash
# =============================================================================
# dotfiles 安装脚本：把各工具配置软链到对应位置
# 用法: ./install.sh
# 重复运行安全（会覆盖已有软链，遇到非软链的真实文件会跳过并提示）
# =============================================================================
set -euo pipefail

DOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 颜色输出
green() { printf '\033[32m%s\033[0m\n' "$*"; }
yellow(){ printf '\033[33m%s\033[0m\n' "$*"; }
red()   { printf '\033[31m%s\033[0m\n' "$*"; }

# link <源文件(相对DOT_DIR)> <目标绝对路径>
link() {
  local src="$DOT_DIR/$1"
  local dest="$2"

  if [[ ! -e "$src" ]]; then
    yellow "  跳过：源文件不存在 $1"
    return
  fi

  mkdir -p "$(dirname "$dest")"

  if [[ -L "$dest" ]]; then
    rm "$dest"
  elif [[ -e "$dest" ]]; then
    red "  跳过：目标已存在且非软链（避免覆盖你的真实文件）-> $dest"
    return
  fi

  ln -sf "$src" "$dest"
  green "  链接: $dest -> $src"
}

echo "==> 安装 dotfiles 软链"
echo

echo "[zsh]"
link zsh/.zshrc        "$HOME/.zshrc"
link zsh/.p10k.zsh     "$HOME/.p10k.zsh"
echo

echo "[tmux]"
link tmux/.tmux.conf   "$HOME/.tmux.conf"
echo

echo "[kitty]"
link kitty/kitty.conf  "$HOME/.config/kitty/kitty.conf"
link kitty/theme.conf  "$HOME/.config/kitty/theme.conf"
echo

echo "[lazyvim]"
# LazyVim 配置目录整体软链
if [[ -e "$DOT_DIR/lazyvim" ]]; then
  if [[ -L "$HOME/.config/nvim" ]]; then
    rm "$HOME/.config/nvim"
  elif [[ -e "$HOME/.config/nvim" ]]; then
    red "  跳过：~/.config/nvim 已存在且非软链"
  else
    mkdir -p "$HOME/.config"
    ln -sf "$DOT_DIR/lazyvim" "$HOME/.config/nvim"
    green "  链接: $HOME/.config/nvim -> $DOT_DIR/lazyvim"
  fi
fi
echo

echo "==> 完成"
echo "提示："
echo "  - kitty: brew install --cask kitty font-meslo-lg-nerd-font"
echo "  - tmux 重新加载: tmux source-file ~/.tmux.conf"
echo "  - kitty 重新加载: ctrl+shift+f5"
