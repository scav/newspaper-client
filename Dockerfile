FROM node:9.1 AS builder

WORKDIR /build
COPY . ./

RUN npm -g config set user root && \
    npm install -g elm@0.18.0 && \
    elm-make src/Main.elm --yes


FROM nginx:alpine
LABEL maintainer="dag.heradstveit@sonat.no"

COPY --from=builder /build/ /usr/share/nginx/html