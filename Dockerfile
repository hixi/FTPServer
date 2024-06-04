FROM golang:1.22

RUN go install github.com/fclairamb/ftpserver@v0.14.0

ENTRYPOINT [ "ftpserver" ]
CMD ["-conf", "/config/ftp.conf"]
