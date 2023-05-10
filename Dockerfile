FROM golang:1.18.1
WORKDIR /app
COPY . .
COPY go.mod go.sum .
RUN go mod download
COPY task14.go .
RUN CGO_ENABLED=0 GOOS=linux go build -o task16 .

EXPOSE 8080

CMD ["./task16"]
