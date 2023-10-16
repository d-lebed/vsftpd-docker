FROM alpine:3

RUN apk add --no-cache \
    bash \
    vsftpd \
    openssl \
    && rm -rf /var/cache/apk/*

COPY vsftpd.conf /etc/vsftpd/vsftpd.conf

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

CMD ["/usr/local/bin/entrypoint.sh"]
