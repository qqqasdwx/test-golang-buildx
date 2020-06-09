FROM --platform=$BUILDPLATFORM golang:1.14.3 AS builder

ARG TARGETPLATFORM
ARG BUILDPLATFORM
WORKDIR /srv
RUN echo "running on $BUILDPLATFORM, building for $TARGETPLATFORM"
COPY . .
ENV GO111MODULE=on
RUN go build -v -o ./myapp -gcflags "-N -l" main.go

FROM --platform=$BUILDPLATFORM alpine
WORKDIR /bin/
COPY --from=builder /srv/myapp .
ENTRYPOINT ["/bin/myapp"]