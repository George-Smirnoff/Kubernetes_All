FROM centos:centos7

# install SSH and create user to login with private key
RUN yum update -y && \
    yum install -y openssh-server \
                   openssh-clients \
                   iproute && \
	yum clean all
RUN /usr/bin/ssh-keygen -A

RUN useradd deploy-user

COPY certs/deploy.pub /home/deploy-user/.ssh/authorized_keys

RUN yum update -y && \
    yum install -y  docker \
                    java-1.8.0-openjdk \
                    git \
                    maven && \
	yum clean all

RUN mkdir /var/lib/jenkins

CMD ["/usr/sbin/sshd", "-D"]
