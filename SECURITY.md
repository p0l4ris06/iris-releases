# Security policy

IRIS is a beta that keeps a searchable memory of your notes on your own computer. It has no account and no server.

## Reporting a vulnerability
Please **do not** open a public issue for a security problem. Use GitHub's private reporting:
**Security > Report a vulnerability** on this repository. Include the IRIS version (Help > About IRIS > Copy these
details), your operating system, and the steps to reproduce. **Do not attach your memory database or any private
notes**: describe the problem, and we will tell you if we need a (made-up) example.

We will answer within 7 days and tell you what we plan to do. This is a small project run by one person, so we cannot
promise fix times, but we will keep you informed and credit you if you wish.

## What is in scope
The IRIS app and its installers as published on this repository's Releases page; the way IRIS opens, backs up, restores
and upgrades its memory file; the Claude connection (`iris-mcp`); and the build and release process. See
`docs/SECURITY_NOTES.md` in the source repository for what IRIS does and does not protect against.

## Checking a download
Each release has `SHA256SUMS` and a signature `SHA256SUMS.minisig`. See "Check your download" in the README.
If a file does not verify, do not install it and tell us.

## Supported versions
Only the newest published release gets fixes while IRIS is in beta.
