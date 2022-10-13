FROM alpine:3.16.2

# coreutils for date, findutils for xargs and py3-pip to install awscli
RUN apk update && apk add \
  coreutils=9.1-r0 \
  findutils=4.9.0-r0 \
  py3-pip=22.1.1-r0 \
  jq=1.6-r1
RUN pip3 install awscli==1.25.90
COPY list-outdated-access-keys.sh /list-outdated-access-keys.sh

ENTRYPOINT ["/list-outdated-access-keys.sh"]
