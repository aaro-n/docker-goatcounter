#!/bin/sh

# 启动 GoatCounter 并记录日志
exec 2>&1

# 初始化命令字符串
GOATCOUNTER_COMMAND=""

# 循环处理每个 GOATCOUNTER_COMMAND_n
i=1
while true; do
    # 获取当前的 GOATCOUNTER_COMMAND_n
    eval "CMD=\$GOATCOUNTER_COMMAND_$i"
    
    # 如果没有找到命令，退出循环
    [ -z "$CMD" ] && break
    
    # 将当前命令添加到字符串中
    GOATCOUNTER_COMMAND="$GOATCOUNTER_COMMAND $CMD"
    
    # 递增计数器
    i=$((i + 1))
done

# 启动 GoatCounter
exec /home/goatcounter/bin/goatcounter serve -listen "$GOATCOUNTER_LISTEN" -automigrate -tls none -db "$GOATCOUNTER_DB" $GOATCOUNTER_COMMAND

