FROM python:3.11

RUN pip3 install ansible-runner ansible ansible-core
RUN pip3 install hvac

ENV LANG=C.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=C.UTF-8
