FROM scratch
COPY oomkill /
ENTRYPOINT ["/oomkill"]
