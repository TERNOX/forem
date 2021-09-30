FROM gitpod/workspace-postgres

# Install Ruby
ENV RUBY_VERSION=3.0.2

# Taken from https://www.gitpod.io/docs/languages/ruby
RUN echo "rvm_gems_path=/home/gitpod/.rvm" > ~/.rvmrc
RUN bash -lc "rvm install ruby-$RUBY_VERSION && rvm use ruby-$RUBY_VERSION --default"
RUN echo "rvm_gems_path=/workspace/.rvm" > ~/.rvmrc

# Install the GitHub CLI
RUN brew install gh

# Install Redis.
RUN sudo apt-get update \
        && sudo apt-get install -y \
        redis-server

# Install Cypress dependencies
RUN sudo DEBIAN_FRONTEND=noninteractive apt-get install -y \
        libgtk2.0-0 \
        libgtk-3-0 \
        libnotify-dev \
        libgconf-2-4 \
        libnss3 \
        libxss1 \
        libasound2 \
        libxtst6 \
        xauth \
        xvfb \
        && sudo rm -rf /var/lib/apt/lists/*

# Install Node and Yarn
ENV NODE_VERSION=14.17.6
RUN bash -c ". .nvm/nvm.sh && \
        nvm install ${NODE_VERSION} && \
        nvm alias default ${NODE_VERSION} && \
        npm install -g yarn"
ENV PATH=/home/gitpod/.nvm/versions/node/v${NODE_VERSION}/bin:$PATH