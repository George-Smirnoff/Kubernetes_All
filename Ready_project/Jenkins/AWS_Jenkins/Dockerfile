FROM centos:centos7

RUN yum update -y && \
    yum install -y openssh-server \
                   openssh-clients \
                   iproute && \
		   yum clean all
RUN /usr/bin/ssh-keygen -A

RUN useradd remote-user

COPY certs/remote.pub /home/remote-user/.ssh/authorized_keys
COPY certs/remote /home/remote-user/

RUN yum install mysql -y && \
                yum clean all
RUN curl -O https://bootstrap.pypa.io/get-pip.py && \
    python get-pip.py && \
    pip install awscli

CMD ["/usr/sbin/sshd", "-D"]
