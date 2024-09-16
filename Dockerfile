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

COPY app/ $APP_LIB

EXPOSE 587 586
ENTRYPOINT ["docker-entrypoint.sh"]
CMD [""]

# ARG BUILD_IMAGE_TAG
# ARG CI_PROJECT_ID
# ARG CI_PROJECT_NAME
# ARG CI_PROJECT_NAMESPACE
# ARG CI_PROJECT_PATH
# ARG CI_COMMIT_BRANCH
# ARG CI_COMMIT_REF_NAME
# ARG CI_COMMIT_SHA
# ARG CI_COMMIT_SHORT_SHA
# ARG CI_COMMIT_TAG
# ARG CI_COMMIT_TIMESTAMP
# LABEL io.insios.src="github"
#       io.insios.build-image-tag="$BUILD_IMAGE_TAG" \
#       io.insios.ci-project-id="$CI_PROJECT_ID" \
#       io.insios.ci-project-name="$CI_PROJECT_NAME" \
#       io.insios.ci-project-namespace="$CI_PROJECT_NAMESPACE" \
#       io.insios.ci-project-path="$CI_PROJECT_PATH" \
#       io.insios.ci-commit-branch="$CI_COMMIT_BRANCH" \
#       io.insios.ci-commit-ref-name="$CI_COMMIT_REF_NAME" \
#       io.insios.ci-commit-sha="$CI_COMMIT_SHA" \
#       io.insios.ci-commit-short-sha="$CI_COMMIT_SHORT_SHA" \
#       io.insios.ci-commit-tag="$CI_COMMIT_TAG" \
#       io.insios.ci-commit-timestamp="$CI_COMMIT_TIMESTAMP"
