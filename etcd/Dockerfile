FROM resin/rpi-raspbian:wheezy-20151223
MAINTAINER Peter Frandsen <pfrandsen@gmail.com>
LABEL decription="Raspberry Pi etcd (32 bit ARM)"

COPY etcd /etcd/etcd
COPY etcdctl /etcd/etcdctl

RUN chmod +x /etcd/etcd
RUN chmod +x /etcd/etcdctl

ENV PATH "$PATH:/etcd"
# RUN echo $PATH

EXPOSE 4001 7001 2379 2380
