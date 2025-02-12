FROM envoyproxy/envoy:v1.28-latest
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y curl && \
    rm -rf /var/lib/apt/lists/* 