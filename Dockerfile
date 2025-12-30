FROM node:20-bullseye-slim

WORKDIR /app

RUN apt-get update && apt-get install -y \
    python3 \
    git \
    curl \
    bash \
    openssh-server \
    && rm -rf /var/lib/apt/lists/*

RUN npm install -g @anthropic-ai/claude-code

RUN groupadd -r claudeuser && \
    useradd -r -g claudeuser -m -s /bin/bash claudeuser && \
    echo 'claudeuser:1234' | chpasswd

RUN mkdir -p /home/claudeuser/.claude && \
    chown -R claudeuser:claudeuser /home/claudeuser/.claude

RUN mkdir /var/run/sshd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]