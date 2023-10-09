FROM debian as builder

RUN apt update && \
    apt install -y build-essential pkg-config gdb libssl-dev libpcre2-dev libargon2-0-dev libsodium-dev libc-ares-dev libcurl4-openssl-dev

RUN useradd -m -s /bin/bash build
USER build

WORKDIR /irc
WORKDIR /soruce
COPY --chown=build:build . .
RUN ./Config -q && make

RUN make install

FROM debian

RUN apt update && \
    apt install -y build-essential pkg-config gdb libssl-dev libpcre2-dev libargon2-0-dev libsodium-dev libc-ares-dev libcurl4-openssl-dev
    
RUN apt install -y vim rsync daemontools

RUN useradd -m -s /bin/bash unrealircuser
USER unrealircuser

COPY --chown=unrealircuser:unrealircuser --from=builder /irc /irc

ENTRYPOINT ["fghack", "/irc/unrealircd", "start"]
