# Use the official Ubuntu base image
FROM alpine:edge

# Define the home directory for the "dev" user as an environment variable
ENV DEV_HOME /home/dev

# Update package lists and install necessary packages
RUN apk add \
  git \
  tmux \
  curl \
  gnupg \
  neovim \
  ripgrep \
  alpine-sdk \
  linux-tools \
  lazygit \
  --update \
  --no-cache

# Configure perf
RUN echo "kernel.perf_event_paranoid = 1" >> /etc/sysctl.conf

# Import MongoDB public GPG key
RUN curl -fsSL \
  https://downloads.mongodb.com/compass/mongosh-2.2.5-linux-arm64.tgz \
  --output mongosh.tgz \
  && tar -xzf mongosh.tgz \
  && rm mongosh.tgz \
  && mv mongosh*/bin/mongosh /usr/local/bin/ \
  && rm -rf mongosh*

RUN chmod +x /usr/local/bin/mongosh

# Create a non-root user named "dev" with the home directory defined by the environment variable
RUN adduser -D -h $DEV_HOME dev

# Set the default user to "dev"
USER dev

# Set the default working directory for the "dev" user
WORKDIR $DEV_HOME

# Clone starter
RUN git clone https://github.com/brenodt/.dotfiles.git \
  --branch minimal \
  --depth 1 \
  --single-branch $DEV_HOME/.config

# Set default command to launch tmux
CMD ["tmux"]

