# Use a PowerPC64LE Ubuntu base image
FROM ppc64le/ubuntu:22.04

# Install dependencies
RUN apt-get update && \
    apt-get install -y \
    curl \
    git \
    build-essential \
    libssl-dev \
    libncurses5-dev \
    autoconf \
    automake \
    libtool \
    unzip \
    wget

# Install Erlang 26.2.5.3
RUN wget https://github.com/erlang/otp/releases/download/OTP-26.2.5.3/otp_src_26.2.5.3.tar.gz && \
    tar -xvzf otp_src_26.2.5.3.tar.gz && \
    cd otp_src_26.2.5.3 && \
    ./configure && \
    make && \
    make install

# Install Elixir 1.16.3-otp-26
RUN wget https://github.com/elixir-lang/elixir/releases/download/v1.16.3/elixir-otp-26.zip && \
    unzip elixir-otp-26.zip -d /usr/local/elixir && \
    ln -s /usr/local/elixir/bin/elixir /usr/local/bin/elixir && \
    ln -s /usr/local/elixir/bin/iex /usr/local/bin/iex && \
    ln -s /usr/local/elixir/bin/mix /usr/local/bin/mix && \
    ln -s /usr/local/elixir/bin/elixirc /usr/local/bin/elixirc

# Set up the working directory
WORKDIR /app

# Expose port (if needed for running apps later)
EXPOSE 4000

# Default command
CMD ["/bin/bash"]
