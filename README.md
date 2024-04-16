# FTPServer

Example usage of https://github.com/fclairamb/ftpserver

## Development

Create directories and permissions

```bash
mkdir -p demo-var-www config certs

# create certs
openssl req -new -newkey rsa:4096 -x509 -sha256 -days 365 -nodes -out certs/cert.pem -keyout certs/key.pem

# set access rights
sudo chown -R 1000:1000 certs demo-var-www config certs

# fix permissions for certs
sudo chmod 600 certs/cert.pem certs/key.pem

# build ftpserver
go build -o ./builds/

# run ftpserver
./ftpserver -config ./config/ftp.conf

# on windows, you might need to use backward slashes:
# .\ftpserver.exe -config .\config\ftp.conf
```

Use user `ftp` with password `test` and the server `localhost` to access/upload new files.

## Usage example

We need a base directory to start from, as an example we use:

```bash
mkdir -p $HOME/ftpserver
cd $_
```

We want the ftp server to manage `/var/www/html` using the user `ftp` and the password `ftpuserpwassword`.

Create the required directories:

```bash
# Copy compose.yml to your server
# Create the directories and permissions
mkdir -p config certs
```

Add the config file and create the keys:

```bash
cat << EOF > config/ftp.conf
{
  "version": 1,
   "tls": {
      "server_cert": {
         "cert": "./certs/cert.pem",
         "key": "./certs/key.pem"
      }
   },
  "accesses": [
    {
      "user": "ftp",
      "pass": "ftpuserpwassword",
      "fs": "os",
      "params": {
        "basePath": "/var/www/html"
      }
    }
  ],
  "public_host": "<your-server-ip>",
  "listen_address": ":21",
  "passive_transfer_port_range": {
    "start": 3022,
    "end": 3030
  }
}
EOF

# you need to renew this key every year!
openssl req -new -newkey rsa:4096 -x509 -sha256 -days 365 -nodes -out certs/cert.pem -keyout certs/key.pem
sudo chown 33:33 -R certs config
```

Start the service:

```bash
./ftpserver -config ./config/config.json
```
