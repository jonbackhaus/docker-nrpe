FROM alpine:3.14

RUN addgroup -g 1000 nagios \
   && adduser -u 1000 -G nagios -D -H nagios

RUN apk add --no-cache \
      nrpe \
      nagios-plugins-all \
      # nagios-plugins-procs \
      # nagios-plugins-time \
      # nagios-plugins-load \
      # nagios-plugins-swap \
      # nagios-plugins-disk \
      perl \
      python3 \
      sudo \
   # && rc-update add nrpe default \
   && echo 'nagios ALL=(ALL) NOPASSWD: /usr/lib/nagios/plugins/*' >> /etc/sudoers \
   && echo 'Defaults: nagios        !requiretty' >> /etc/sudoers

# ADD check_memory check_time_skew check_oxidized.rb check_docker check_swarm /usr/lib/nagios/plugins/
# ADD nrpe.cfg /etc/nrpe.cfg
RUN mkdir /nrpe \
   && chown -R nagios:nagios /nrpe

ADD entrypoint.sh /entrypoint.sh

EXPOSE 5666

USER nagios

CMD /entrypoint.sh
