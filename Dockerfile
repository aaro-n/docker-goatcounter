# 使用 Alpine 基础镜像
FROM alpine:latest

# 设置环境变量
ENV GOATCOUNTER_LISTEN=:8080
ENV GOATCOUNTER_DB="sqlite+file:/home/goatcounter/db/goatcounter.sqlite3"
ENV GOATCOUNTER_OPTS="--automigrate"

# 安装所需的包
RUN apk add --no-cache \
    curl \
    gzip \
    tzdata \
    runit \
    libcap \
    tzdata \ 
    logrotate 

# 下载并解压 GoatCounter
RUN mkdir -p /home/goatcounter/bin && \
    dst="/home/goatcounter/bin/goatcounter-$LATEST_VERSION" && \
    arch=$(uname -m) && \
    if [ "$arch" = "x86_64" ]; then \
        url="https://github.com/arp242/goatcounter/releases/download/$LATEST_VERSION/goatcounter-$LATEST_VERSION-linux-amd64.gz"; \
    elif [ "$arch" = "aarch64" ]; then \
        url="https://github.com/arp242/goatcounter/releases/download/$LATEST_VERSION/goatcounter-$LATEST_VERSION-linux-arm64.gz"; \
    else \
        echo "不支持的架构: $arch"; \
        exit 1; \
    fi && \
    if [ ! -f "$dst" ]; then \
        curl -L "$url" | \
        gzip -d > "$dst"; \
    fi && \
    chmod a+x "$dst" && \
    setcap 'cap_net_bind_service=+ep cap_sys_chroot=+ep' "$dst" && \
    ln -sf "$dst" "/home/goatcounter/bin/goatcounter"

# 创建数据库和日志目录
RUN mkdir -p /home/goatcounter/db /var/log/goatcounter


# 设置 Runit 服务
COPY config/runit /etc/runit

COPY config/goatcounter.sh /etc/service/sgoatcounter/run

RUN chmod +x /etc/service/*/run && \
    chmod +x /etc/runit/* && \
    cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo 'Asia/Shanghai' > /etc/timezone

# 启动服务
CMD ["runsvdir", "/etc/service"]
