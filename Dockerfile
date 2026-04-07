FROM node:22-alpine

# Maintainer
LABEL maintainer="Andreas Peters <support@aventer.biz>"
LABEL org.opencontainers.image.title="docker-matrix-riot"
LABEL org.opencontainers.image.description="Element Web Client for Matrix Chat"
LABEL org.opencontainers.image.vendor="AVENTER UG (haftungsbeschränkt)"
LABEL org.opencontainers.image.source="https://github.com/AVENTER-UG/"

# Startup
COPY adds/start.sh /start.sh
ENTRYPOINT ["/start.sh"]

# Git branch / version
ARG BV_VEC=v1.12.14
ENV BV_VEC=${BV_VEC}
ENV VERSION=1.12.14

ARG REBUILD=0

# Base dependencies
RUN chmod +x /start.sh \
    && apk update \
    && apk add --no-cache \
        bash \
        curl \
        git \
        python3 \
        build-base \
        cairo-dev \
        pango-dev \
        jpeg-dev \
        giflib-dev \
        libpng-dev \
        sqlite-libs \
        unzip

# Enable corepack + pnpm
RUN corepack enable \
    && corepack prepare pnpm@10.28.2 --activate

# Build riot-web
RUN git clone --branch ${BV_VEC} --depth 1 https://github.com/vector-im/riot-web.git /riot-web
RUN cd /riot-web/apps/web \
    && pnpm install \
    && pnpm run build
RUN cd /riot-web/apps/web && rm -rf node_modules/phantomjs-prebuilt/phantomjs \
    && echo "riot: ${BV_VEC}" > /synapse.version \
    && mv webapp /webapp \
    && echo "${BV_VEC}" | tr -d v > /webapp/version

# Runtime HTTP server
RUN cd /webapp \
    && pnpm add http-server

# Cleanup
RUN rm -rf /riot-web \
    /root/.npm \
    /root/.cache \
    /tmp/* \
    /usr/local/share/.cache \
    && apk del \
        git \
        curl \
        python3 \
        build-base \
        cairo-dev \
        pango-dev \
        jpeg-dev \
        giflib-dev \
        libpng-dev \
        unzip \
    && rm -rf /var/cache/apk/*
