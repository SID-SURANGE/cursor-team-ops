<div align="center">

# 🔒 Security Policy

[![security](https://img.shields.io/badge/security-responsible%20disclosure-6366f1?style=flat-square)](#reporting-a-vulnerability)

</div>

---

## Supported Versions

| Version | Supported |
|---------|-----------|
| Latest (`main`) | ✅ Active |
| Older tagged releases | ❌ No backports |

Always use the latest version. Run `git pull && bash install.sh` to update.

---

## Scope

This policy covers security vulnerabilities in:

- **Install scripts** — `install.sh`, `install.ps1`, `bootstrap-project.sh`, `sync-project.sh` / `sync-project.ps1`
- **Hook scripts** — `hooks/git-guard.sh`, `hooks/session-context.sh`
- **Rules and skills** — any content that could cause an agent to execute unsafe commands or exfiltrate data

**Out of scope:**

- Vulnerabilities in Cursor itself — report those to [Anysphere](https://cursor.com)
- Vulnerabilities in third-party tools referenced by skills (GitHub CLI, ShellCheck, etc.)
- Issues in repos that have adopted the kit but added their own modifications

---

## Reporting a Vulnerability

**Do not open a public GitHub issue for security vulnerabilities.**

Report privately via email: **ssurange.dev@gmail.com**

Include in your report:

- A description of the vulnerability and its potential impact
- Steps to reproduce or a proof-of-concept
- The version or commit SHA where you found it
- Any suggested fix (optional but appreciated)

---

## Response Timeline

| Step | Target time |
|------|------------|
| Acknowledgement of report | Within 48 hours |
| Initial assessment and severity triage | Within 5 days |
| Fix or mitigation released | Within 14 days for HIGH/CRITICAL |
| Public disclosure | After fix is released and users have had time to update |

---

## Our Commitment

- We will acknowledge your report promptly
- We will keep you informed of progress
- We will credit you in the fix commit and changelog (unless you prefer anonymity)
- We will not take legal action against good-faith security researchers

---

## Security Design Notes

For contributors and users who want to understand the security posture of the kit:

- **Install scripts run with your user permissions** — they symlink or copy files into `~/.cursor/`. They do not require `sudo` and do not modify system directories.
- **Hook scripts execute before shell commands** — `git-guard.sh` only reads the command string and outputs a JSON allow/deny response. It does not execute the command itself.
- **No network calls** — no install or hook script makes outbound network requests. `session-context.sh` only reads a local file.
- **No package dependencies** — the kit requires only `bash`, `git`, and standard POSIX tools. No `npm install` or `pip install`.
