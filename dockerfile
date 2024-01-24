# 使用 Ubuntu 作为基础镜像
FROM ubuntu:latest

# 安装必要的工具
RUN apt-get update && \
    apt-get install -y autoconf make gcc wget

# 下载 n2n v3.0 的源码
#RUN wget https://github.com/ntop/n2n/archive/refs/tags/3.0.tar.gz
RUN wget https://ghproxy.homeboyc.cn/https://github.com/ntop/n2n/archive/refs/tags/3.0.tar.gz

# 解压并编译 n2n
RUN tar xzvf 3.0.tar.gz && \
    cd n2n-3.0 && \
    ./autogen.sh && \
    ./configure && \
    make && make install

# 清理工作
RUN apt-get remove --purge -y autoconf make gcc wget && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* 3.0.tar.gz n2n-3.0

# 设置环境变量的默认值
ENV N2N_IP_RANGE="192.168.198.0-192.168.200.0/24"
ENV N2N_SUPERNODE_NAME="Supernode"

# 暴露 Supernode 监听的端口
EXPOSE 9527/tcp
EXPOSE 9527/udp

# 设置容器启动时的默认命令
ENTRYPOINT ["/bin/bash", "-c", "supernode -p 9527 -f -a $N2N_IP_RANGE -F $N2N_SUPERNODE_NAME"]

# 使用编译: docker build -t n2n-supernode-v3 .
# 测试 docker run --rm -p 9527:9527/tcp -p 9527:9527/udp n2n-supernode-v3
# 运行 docker run -d --name=n2n-supernode -p 9527:9527/tcp -p 9527:9527/udp n2n-supernode-v3
