FROM golang:1.19-alpine AS builder
RUN apk update && apk add --no-cache make git curl
WORKDIR /
RUN git clone https://github.com/smk762/callisto -b cosmos/v0.46.x
WORKDIR /callisto
RUN go mod download
RUN make build


FROM alpine:latest
WORKDIR /bdjuno
RUN apk update && apk add --no-cache curl
COPY --from=builder /callisto/hasura /bdjuno/hasura
COPY --from=builder /callisto/build/bdjuno /usr/bin/bdjuno
RUN curl -L https://github.com/hasura/graphql-engine/raw/stable/cli/get.sh | sh
RUN bdjuno init || true
COPY ./config.yaml /root/.bdjuno/config.yaml
COPY ./genesis.json /root/.bdjuno/genesis.json
RUN bdjuno parse genesis-file --genesis-file-path /root/.bdjuno/genesis.json || true
CMD [ "bdjuno" ]
