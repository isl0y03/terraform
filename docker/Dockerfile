# ベースイメージを選択
FROM public.ecr.aws/ubuntu/ubuntu:24.04

# GIDとUIDはDockerfileのARGで指定
# USERNAMEはデフォルトのままでOK
ARG USERNAME=terraform
ARG GID=1000
ARG UID=1000

# Terraform をインストール
RUN apt-get update && apt-get install -y gnupg software-properties-common jq curl sudo unzip vim \
    && curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list \
    && apt-get update && apt-get install -y terraform \
    # 指定されたユーザー/グループがすでに存在する場合は削除
    && (getent passwd $UID && userdel -r $(getent passwd $UID | cut -d: -f1) && sync) || true \
    && (getent group $GID && groupdel $(getent group $GID | cut -d: -f1) && sync) || true \
    # teraformユーザーの作成
    && groupadd -g $GID $USERNAME \
    && useradd -u $UID -g $USERNAME -m -s /bin/bash $USERNAME \
    && echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers \
    && git config --global core.editor vim \
    # awscliのインストール
    && curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install \
    && rm -rf aws awscliv2.zip \
    && mkdir -p /workspace

COPY resources/aws.sh /etc/profile.d/aws.sh

USER $USERNAME
