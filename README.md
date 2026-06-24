# dot

个人 dotfiles，覆盖 zsh / tmux / kitty / nvim(LazyVim)。

## 目录结构

```
.
├── zsh/         # .zshrc + p10k 配置（oh-my-zsh + powerlevel10k）
├── tmux/        # .tmux.conf（vi 复制模式 + pbcopy）
├── kitty/       # kitty 终端配置（含 Tokyo Night 主题）
│   ├── kitty.conf
│   └── theme.conf
├── lazyvim/     # LazyVim 配置，整体软链到 ~/.config/nvim
└── install.sh   # 一键软链安装
```

## 安装

```bash
./install.sh
```

脚本会把各配置软链到对应位置，重复运行安全：
- 已存在的软链会被覆盖；
- 已存在的**真实文件**（非软链）会被跳过并提示，避免覆盖你的本地改动。

## 前置依赖

| 工具 | 安装 |
| --- | --- |
| zsh + oh-my-zsh | `sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"` |
| powerlevel10k | 见 [romkatv/powerlevel10k](https://github.com/romkatv/powerlevel10k) |
| Nerd Font (MesloLGS NF) | `brew install --cask font-meslo-lg-nerd-font` |
| tmux | `brew install tmux` |
| kitty | `brew install --cask kitty` |
| nvim + LazyVim | 见 [LazyVim](https://www.lazyvim.org/) |

## 重新加载配置

- **zsh**：`exec zsh`
- **tmux**：`tmux source-file ~/.tmux.conf`
- **kitty**：在 kitty 中按 `ctrl+shift+f5`
- **nvim**：`:Lazy sync`

## kitty 主题

配置默认使用 Tokyo Night（`kitty/theme.conf`）。想换主题运行：

```bash
kitty +kitten themes
```

选择后会覆盖 `theme.conf`。
