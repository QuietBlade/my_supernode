
### 快速使用

服务端:
```shell
docker run -d --name=n2n-supernode -p 9527:9527/tcp -p 9527:9527/udp yuanzhangzcc/n2n-supernode-v3:latest
```
客户端:
```shell
git clone http://github.com/QuietBlade/su_supernode.git
```


### 如果是windows请使用x64或x86, 如果是linux请先用` rpm `或者 `dpkg -i` 安装后 修改 `edge.conf文件`
***使用 sudo 或者 管理员身份运行:***

```conf
-c=roomname  #这个需要和别人一致, 若无特殊需求保持默认即可
-l=targer_server:9527  # 需要更改为自己的服务器

# The parameters of other clients need to be completely consisten 其他客户端的参数需要完全一致
# exmple: demo.exmple.com:9527 or 1.2.3.4:9527
```

windows下有 `start.bat`, 右键使用管理员运行即可

```shell
edge edge.conf
# edge_v3_bugxia_n2n.exe edge.conf
```


## 编译源码

```dockerfile
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
```

### 编译 `docker build -t n2n-supernode-v3 .`
### 测试 `docker run --rm -p 9527:9527/tcp -p 9527:9527/udp n2n-supernode-v3`
### 运行 `docker run -d --name=n2n-supernode -p 9527:9527/tcp -p 9527:9527/udp n2n-supernode-v3`
