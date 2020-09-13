FROM alpine:3.12
RUN apk update && \
  apk add --no-cache bash gettext tzdata && \
  apk add --no-cache dovecot dovecot-lmtpd && \
  rm -rf /var/lib/cache/apk/*
COPY conf /tmp/dovecot_staging
COPY entrypoint.sh /usr/libexec
EXPOSE 149/tcp
VOLUME ["/etc/dovecot", "/var/mail", "/var/spool/postfix/private"]
ENTRYPOINT ["/usr/libexec/entrypoint.sh"]
