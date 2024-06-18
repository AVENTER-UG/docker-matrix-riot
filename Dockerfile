FROM alpine:3.19

# Maintainer
LABEL maintainer="Andreas Peters <support@aventer.biz>"
LABEL org.opencontainers.image.title="docker-matrix-riot" 
LABEL org.opencontainers.image.description="Element Web Client for Matrix Chat"
LABEL org.opencontainers.image.vendor="AVENTER UG (haftungsbeschränkt)"
LABEL org.opencontainers.image.source="https://github.com/AVENTER-UG/"

# install homeserver template
COPY adds/start.sh /start.sh

# startup configuration
ENTRYPOINT ["/start.sh"]

# Git branch to download
ARG BV_VEC=v1.11.69
ENV BV_VEC=${BV_VEC:-master}
ENV VERSION=1.11.69

# To rebuild the image, add `--build-arg REBUILD=$(date)` to your docker build
# command.
ARG REBUILD=0

# update and upgrade
# installing riot.im with nodejs/npm
RUN chmod a+x /start.sh \
    && apk update \
    && apk add \
        curl \
        libevent \
        libffi \
        libjpeg-turbo \
        libressl \
        sqlite-libs \
      	git \
        unzip \
        nodejs \
        npm \
        yarn \
      	python3 

RUN apk add build-base libpng libpng-dev jpeg-dev pango-dev cairo-dev giflib-dev g++ bash
RUN git clone --branch $BV_VEC --depth 1 https://github.com/vector-im/riot-web.git /riot-web \    
    && cd /riot-web \
    && git checkout $BV_VEC \    
    && yarn install \
    && rm -rf /riot-web/node_modules/phantomjs-prebuilt/phantomjs \
    && echo "riot:  $BV_VEC " > /synapse.version \
    && yarn build \
    || exit 1 \
    ; \
    mv /riot-web/webapp / ; \
    echo "$BV_VEC" | tr -d v > /webapp/version ; \
    cd /webapp ; \
    npm install http-server ; \
    rm -rf /riot-web ; \
    rm -rf /root/.npm ; \
    rm -rf /node_modules; \
    rm -rf /tmp/* ; \
    rm -rf /usr/local/share/.cache ;\
    rm -rf /usr/lib/node_modules/webpack ;\
    apk del \
        unzip \
        libevent \
        libffi \
        libjpeg-turbo \
        libressl \
        npm \
        sqlite-libs \
      	git \
      	curl \
        python3 \
        build-base \
        libpng \
        libpng-dev \
        jpeg-dev \
        pango-dev \
        cairo-dev \
        giflib-dev \
        g++ \
        ; \
    rm -rf /var/lib/apk/* /var/cache/apk/* 

