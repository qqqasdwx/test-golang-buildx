FROM --platform=${BUILDPLATFORM:-linux/amd64} golang:1.14.3 AS builder

ARG TARGETPLATFORM
ARG BUILDPLATFORM
WORKDIR /srv
RUN echo "running on $BUILDPLATFORM, building for $TARGETPLATFORM"
COPY . .
ENV GO111MODULE on
ENV GOPROXY https://goproxy.io,direct
RUN go mod download
RUN go build -v -o ./myapp -gcflags "-N -l" main.go

FROM --platform=${TARGETPLATFORM:-linux/amd64} alpine:latest
WORKDIR /bin/
COPY --from=builder /srv/myapp .
ENTRYPOINT ["/bin/myapp"]