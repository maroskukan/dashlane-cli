FROM node:16 as build

WORKDIR /src

COPY package.json package-lock.json ./

RUN npm ci

COPY . .

RUN npm run build

RUN npm link

RUN npm run pkg

FROM node:16

RUN apt-get update && \
    apt-get install -y libsecret-1-dev && \
    rm -rf /var/lib/apt/lists/*

## From ‘builder’ stage copy over the artifacts in bundle
COPY --from=build /src/bundle/dcli-linux /usr/local/bin/dcli

ENTRYPOINT ["bash"]