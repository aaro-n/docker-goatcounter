FROM alpine:latest

# 设置环境变量
ARG GOATCOUNTER_VERSION=v2.5.0
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
    dst="/home/goatcounter/bin/goatcounter-$GOATCOUNTER_VERSION" && \
    if [ ! -f "$dst" ]; then \
        curl -L "https://github.com/arp242/goatcounter/releases/download/$GOATCOUNTER_VERSION/goatcounter-$GOATCOUNTER_VERSION-linux-amd64.gz" | \
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
