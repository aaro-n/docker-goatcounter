#!/bin/sh

# 启动 GoatCounter 并记录日志
exec 2>&1

# 基本命令
command="/home/goatcounter/bin/goatcounter serve -listen \"$GOATCOUNTER_LISTEN\" -automigrate -tls none -db \"$GOATCOUNTER_DB\""

# 检查 GOATCOUNTER_COMMAND 是否有内容
if [ -n "$GOATCOUNTER_COMMAND" ]; then
    command="$command $GOATCOUNTER_COMMAND"
fi

# 执行命令
exec $command

