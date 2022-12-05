#
# https://lipanski.com/posts/smallest-docker-image-static-website
#

FROM busybox:1.35

RUN adduser -D static
USER static
WORKDIR /home/static

CMD ["busybox", "httpd", "-f", "-v", "-p", "3000"]
