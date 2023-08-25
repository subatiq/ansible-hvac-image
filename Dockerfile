FROM registry.redhat.io/ubi7/ubi

ENV DESCRIPTION="A tool and python library that helps when interfacing with Ansible \
directly or as part of another system whether that be through a \
container image interface, as a standalone tool, or as a Python module \
that can be imported. The goal is to provide a stable and consistent \
interface abstraction to Ansible."


LABEL com.redhat.component="ansible-runner-container"
LABEL name="ansible-runner"
LABEL version="1.4.9"
LABEL vendor="Red Hat, Inc."
LABEL architecture="x86_64"
LABEL summary="Red Hat Ansible Tower is a fully-featured automation console and REST API for Ansible automation."
LABEL description="$DESCRIPTION"
LABEL io.k8s.description="$DESCRIPTION"
LABEL io.k8s.display-name="Red Hat Ansible Runner"
LABEL io.openshift.tags="ansible-runner,ansible-tower,automation"
LABEL maintainer="Shane McDonald <smcdonal@redhat.com>"

ENV container=oci

ADD entrypoint.sh /bin/entrypoint
RUN yum install -y ansible ansible-runner tini bubblewrap sudo rsync openssh-clients ansible-tower-venv-ansible
RUN localedef -c -i en_US -f UTF-8 en_US.UTF-8

# In OpenShift, container will run as a random uid number and gid 0. Make sure things
# are writeable by the root group.
RUN for dir in \
      /runner \
      /runner/env \
      /runner/inventory \
      /runner/project \
      /runner/artifacts ; \
    do mkdir -m 0775 -p $dir ; chmod -R g+rwx $dir ; chgrp -R root $dir ; done && \
    for file in \
      /etc/passwd \
      /etc/group ; \
    do touch $file ; chmod g+rw $file ; chgrp root $file ; done && \
    chmod g+w /etc/passwd && chmod +x /bin/entrypoint

RUN pip3 install hvac

ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8
ENV HOME=/runner

ENTRYPOINT ["entrypoint"]
CMD ["ansible-runner", "run", "/runner"]
