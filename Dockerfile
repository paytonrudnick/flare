FROM python:2.7.18-slim

MAINTAINER Justin Henderson justin@hasecuritysolutions.com

RUN apt update \
    && apt install -y git gcc python-lxml \
    && cd /opt && git clone https://github.com/austin-taylor/flare.git \
    && cd /opt/flare && pip install -r requirements.txt \
    && useradd -ms /bin/bash flare \
    && mkdir /var/log/flare \
    && chown flare: /var/log/flare \
    && mkdir /opt/flare/output/ \
    && ln -sf /dev/stderr /var/log/flare/flare.log \
    && chown -R flare: /opt/flare
RUN cd /opt/flare && python /opt/flare/setup.py install || true
USER flare

STOPSIGNAL SIGTERM

CMD  flare_beacon -c /opt/flare/configs/elasticsearch.ini -who -json=/opt/flare/output/output.json
