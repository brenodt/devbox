# Use the official Ubuntu base image
FROM alpine:edge

# Update package lists and install necessary packages
RUN apk add \
  git \
  tmux \
  curl \
  gnupg \
  neovim \
  ripgrep \
  alpine-sdk \
  lazygit \
  --update \
  --no-cache

# Import MongoDB public GPG key
RUN curl -fsSL \
  https://downloads.mongodb.com/compass/mongosh-2.2.5-linux-arm64.tgz \
  --output mongosh.tgz \
  && tar -xzf mongosh.tgz \
  && rm mongosh.tgz \
  && mv mongosh*/bin/mongosh /usr/local/bin/ \
  && rm -rf mongosh*

RUN chmod +x /usr/local/bin/mongosh

WORKDIR $HOME

# Clone starter
RUN git clone https://github.com/brenodt/.dotfiles.git \
  --branch minimal \
  --depth 1 \
  --single-branch $HOME/.config

# Set default command to launch tmux
CMD ["tmux"]

