FROM ubuntu:18.04

ENV TEST_USER=testuser
ENV TEST_PASSWD=testpasswd

RUN apt-get update && apt-get install -y build-essential curl file git zsh vim sudo locales vim && \
    sed 's/# \(en_US\.UTF\-8\)/\1/i' /etc/locale.gen | sudo tee /etc/locale.gen && \
    locale-gen && \
    useradd -m -s /usr/bin/zsh -G sudo $TEST_USER && \
    echo "$TEST_USER:$TEST_PASSWD" | chpasswd

USER $TEST_USER

