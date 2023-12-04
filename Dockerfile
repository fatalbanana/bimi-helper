FROM rust:1.73-bookworm as builder

WORKDIR /usr/src/bimi-agent
COPY . .
RUN cargo install --path .

FROM gcr.io/distroless/base-debian12

ENV TZ=Etc/UTC

COPY --from=builder /usr/local/cargo/bin/bimi-agent /usr/local/bin/bimi-agent
COPY --from=builder /usr/src/bimi-agent/data/bimi_ca.pem /usr/local/share/bimi_ca.pem

USER 1000:1000
CMD ["bimi-agent", "--ssl-ca-file", "/usr/local/share/bimi_ca.pem"]

EXPOSE 3030
