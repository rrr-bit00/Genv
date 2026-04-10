FROM golang:1.26.2-bookworm

WORKDIR /app

ENV GOCACHE=/root/.cache/go-build
ENV GOPATH=/go

CMD ["bash"]
