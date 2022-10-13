FROM alpine:3.16.2

RUN apk update && apk add \
  coreutils \
  findutils \
  py3-pip \
  jq
RUN pip3 install awscli
COPY list-outdated-access-keys.sh /list-outdated-access-keys.sh

ENTRYPOINT ["/list-outdated-access-keys.sh"]
