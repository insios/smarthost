FROM alpine:3.20.2

RUN apk add --update --no-cache \
        coreutils \
        bash \
        ca-certificates \
        openssl \
        libsasl \
        postfix postfix-pcre \
        cyrus-sasl cyrus-sasl-login cyrus-sasl-crammd5 cyrus-sasl-digestmd5 \
        opendkim opendkim-utils \
        perl perl-yaml \
        msmtp

ARG APP_LIB=/usr/lib/smarthost
ENV APP_LIB=$APP_LIB

ARG APP_VAR=/var/lib/smarthost
ENV APP_VAR=$APP_VAR

ARG APP_CONF=/etc/smarthost
ENV APP_CONF=$APP_CONF

RUN ln -sf $APP_LIB/bin/docker-entrypoint.sh /usr/bin/docker-entrypoint.sh && \
        newaliases && \
        mkdir -p $APP_CONF && \
        mkdir -p $APP_VAR/postfix $APP_VAR/sasl2 $APP_VAR/opendkim && \
        ln -sf $APP_VAR/sasl2 /etc/sasl2 && \
        touch $APP_VAR/sasl2/sasldb2 && \
        ln -sf $APP_LIB/etc/opendkim/opendkim.conf /etc/opendkim/opendkim.conf && \
        mkdir -p /run/opendkim && \
        ln -sf /usr/bin/msmtp /usr/bin/sendmail && \
        ln -sf /usr/bin/msmtp /usr/sbin/sendmail && \
        ln -sf $APP_LIB/etc/msmtprc /etc/msmtprc

COPY ./ $APP_LIB

EXPOSE 587 586
ENTRYPOINT ["docker-entrypoint.sh"]
CMD [""]
