# Delight SDK Helper

AI-powered SDK assistant for macOS — built on Claude Code Agent SDK for Sendbird Delight.

## Prerequisites

- macOS 26+ (Tahoe)
- [Claude Code CLI](https://github.com/anthropics/claude-code) — `npm install -g @anthropic-ai/claude-code`
- `git`
- SSH key setup for private repo access

> Node.js, npm, gh CLI, etc. are **not required**. The bridge is bundled as a standalone binary.

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/sendbird-playground/delight-sdk-helper/main/install.sh | bash
```

Downloads the latest release, copies to `/Applications`, and removes quarantine automatically.

After installation, complete the onboarding wizard on first launch.

## Features

- **AI Chat** — Claude navigates SDK repos directly and provides accurate answers
- **Knowledge Base** — Auto-clone & sync SDK repositories
- **Quick Question** — Instant questions via global shortcut (Cmd+Shift+D)
- **Streaming** — Real-time responses with Markdown/code syntax highlighting
