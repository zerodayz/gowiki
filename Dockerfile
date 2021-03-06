FROM golang:latest as builder
RUN mkdir /app 
ADD . /app/
WORKDIR /app 
ENV KEEPSAKE_VERSION latest
RUN curl -sSL https://github.com/zerodayz/keepsake/archive/$KEEPSAKE_VERSION.tar.gz \
              | tar -v -C /app -xz
RUN cd keepsake-$KEEPSAKE_VERSION && CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -ldflags '-extldflags "-static"' -o wiki wiki.go
FROM scratch
LABEL maintainer="Robin Cernin <cerninr@gmail.com>"
ENV KEEPSAKE_VERSION latest
COPY --from=builder /app/keepsake-$KEEPSAKE_VERSION /app
WORKDIR /app
CMD ["./wiki"]
