# 说明
将`docker-compose-example.yml`重命名为`docker-compose.yml`，执行`docker-compose up`，即可运行*goatcounter*。
# 环境变量

| 变量名                    | 默认值                                               | 说明                                                                   |
|:-------------------------:|:----------------------------------------------------:|:----------------------------------------------------------------------:|
| GOATCOUNTER_LISTEN        | :8080                                                | goatcounter运行在8080端口上。                                           |
| GOATCOUNTER_DB            | sqlite+file:/home/goatcounter/db/goatcounter.sqlite3 | 默认使用sqlite数据库，并且保存在home/goatcounter/db/goatcounter.sqlite3 |
|  GOATCOUNTER_COMMAND_数字 |                                                      | 执行goatcounter命令。                                                   |

# 特殊说明
1. 使用PostgreSQL数据库
`GOATCOUNTER_DB = "postgresql+user=用户名 password=密码 host=主机 port=端口 dbname=数据库名称 sslmode=disable"`
2. 启用电子邮件
 `GOATCOUNTER_COMMAND_1 = "-email-from=发件人`

 `GOATCOUNTER_COMMAND_2 = "-smtp=smtp://用户名:密码@smtp.mailgun.org:587"`
 
 如果用户名为：123@123.com，这写为123%40123.com，完整为`GOATCOUNTER_COMMAND_2 = "-smtp=smtp://123%40123.com:密码@smtp.mailgun.org:587"`
