FROM golang:1.18.1
WORKDIR /app
COPY . .
COPY index.html ./task23
RUN go mod download
RUN go build -o task23 .

EXPOSE 80

CMD ["./task23"]
