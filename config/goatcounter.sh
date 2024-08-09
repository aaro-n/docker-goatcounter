#!/bin/sh

# 启动 GoatCounter 并记录日志
exec 2>&1
exec /home/goatcounter/bin/goatcounter serve -listen "$GOATCOUNTER_LISTEN" -automigrate -tls none -db "$GOATCOUNTER_DB" "$GOATCOUNTER_COMMAND"

