FROM python:3.11

RUN pip3 install ansible-runner
RUN pip3 install hvac

ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8
