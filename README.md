# docker-postfix

A container running Dovecot with secure default settings. By default, only encrypted IMAP is available on port 143.

## Build instructions

Build the docker image locally:
```
cd docker-dovecot
docker build -t dovecot .
```

## Running the container

Create and run the container with the following command:
```
docker run --name dovecot -d -v /etc/dovecot:/etc/dovecot -v /var/mail:/var/mail -v /var/spool/postfix/private:/var/spool/postfix/private -v /path/to/tls/files:/tls -e MAIL_DOMAIN=foo.com -e TLS_CERT_FILE=/tls/cert.pem -e TLS_KEY_FILE=/tls/key.pem -e SUBMISSION_HOST=postfix -p 143:143/tcp dovecot
```
The configuration and mail directories are persisted as volumes. The `postfix/private` directory is used to set up SASL authentication and final delivery for Postfix. The TLS key and certificate should also be made available to the container.

The container requires several environment variables to be set to initialisation. These are described further in the next section.

## Environment variables

The configuration files cannot be built unless the following environment variables have been set.

Variable        | Description
--------        | -----------
MAIL_DOMAIN     | The domain for which Dovecot will be handling mail
TLS_CERT_FILE   | The path to the TLS certificate (this path must be accessible within the container)
TLS_KEY_FILE    | The path to the TLS key (this path must be accessible within the container)
SUBMISSION_HOST | The host where any mail generated by Dovecot is sent

## Notes

This image is best used in conjunction with Postfix. By default, an authentication listener is configured at `private/auth` and an LMTP listener is configured at `private/dovecot-lmtp`. Make sure the corresponding settings have been configured in your instance of Postfix.

A passwd-file is used for defining users. Further information is available in the [Dovecot documentation](https://doc.dovecot.org/configuration_manual/authentication/passwd_file/).
