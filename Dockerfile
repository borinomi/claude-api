FROM node:20-bullseye-slim

WORKDIR /app

RUN apt-get update && apt-get install -y \
    python3 \
    git \
    curl \
    bash \
    openssh-server \
    nano \
    && rm -rf /var/lib/apt/lists/*

RUN npm install -g @anthropic-ai/claude-code && npm install -g @google/gemini-cli && npm install -g @openai/codex

RUN userdel -r node && \
    groupadd -g 1000 claudeuser && \
    useradd -u 1000 -g 1000 -m -s /bin/bash claudeuser && \
    echo 'claudeuser:1234' | chpasswd

RUN mkdir -p /home/claudeuser/.claude && \
    mkdir -p /workspace && \
    chown -R claudeuser:claudeuser /home/claudeuser/.claude && \
    chown -R claudeuser:claudeuser /workspace

RUN mkdir /var/run/sshd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config

EXPOSE 22

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN sed -i 's/\r$//' /docker-entrypoint.sh && chmod +x /docker-entrypoint.sh

ENTRYPOINT []
CMD ["/docker-entrypoint.sh"]