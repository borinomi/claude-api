#!/bin/bash
set -e

mkdir -p /home/claudeuser/.claude
chown -R claudeuser:claudeuser /home/claudeuser
chown -R claudeuser:claudeuser /workspace

exec /usr/sbin/sshd -D
