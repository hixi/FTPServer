# FTPServer

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
```

Use user `ftp` with password `test` and the server `localhost` to access/upload new files.

## Usage example

We want the ftp server to manage `/var/www/html` using the user `ftp` and the password `ftpuserpwassword`.

create the following compose,yml file

For the "user" part, to get the correct id, use for example using the www-data user, enter `id -u www-data`, below we are using the ubuntu default of `33`.

```yaml
cat << EOF > compose.yml
services:
  ftpserver:
    ports:
      - '2121-2130:2121-2130'
    user: 33:33
    volumes:
      # change this to ie. /var/www/html
      - /var/www/html:/files
      - ./config:/config
      - ./certs/:/certs
    image: njordan/ftpserver
EOF
```

Create the required directories:

```bash
# Copy compose.yml to your server
# Create the directories and permissions
mkdir -p config certs
# if needed, change permissions
chown -R www-data:www-data config certs 
```

Add the config file and create the keys:

```bash
cat << EOF > config/ftp.conf
{
  "version": 1,
   "tls": {
      "server_cert": {
         "cert": "/certs/cert.pem",
         "key": "/certs/key.pem"
      }
   },
  "accesses": [
    {
      "user": "ftp",
      "pass": "ftpuserpwassword",
      "fs": "os",
      "params": {
        "basePath": "/files"
      }
    }
  ],
  "passive_transfer_port_range": {
    "start": 2122,
    "end": 2130
  }
}
EOF

# you need to renew this key every year!
openssl req -new -newkey rsa:4096 -x509 -sha256 -days 365 -nodes -out certs/cert.pem -keyout certs/key.pem
chown 33:33 -R certs config

```