# Systemd inside a Docker container, for CI only
FROM ubuntu:18.04

ENV TZ="Asia/Shanghai"
ENV DEBIAN_FRONTEND="noninteractive"

RUN apt-get update -y

RUN apt-get install -y systemd curl git sudo

# Kill all the things we don't need
RUN find /etc/systemd/system \
    /lib/systemd/system \
    -path '*.wants/*' \
    -not -name '*journald*' \
    -not -name '*systemd-tmpfiles*' \
    -not -name '*systemd-user-sessions*' \
    -exec rm \{} \;

RUN mkdir -p /etc/sudoers.d

RUN systemctl set-default multi-user.target

STOPSIGNAL SIGRTMIN+3

CMD ["/bin/bash", "-c", "exec /sbin/init --log-target=journal 3>&1"]
