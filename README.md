# home-cups

## 背景

家里有两台打印机，一台品牌是 Pantum（2206），另一台是 HP（1106）。

目前使用 USB 连接 Openwrt 路由器，路由器充当打印服务器角色，客户端连接路由器，在安装相应驱动，可以支持本地打印和远程打印（使用 9100 端口转发），唯一不足是不支持 Airprint 和 无驱动打印。

经过研究，CUPS 支持 IPP 协议，可以把打印文件直接发送到 URL 上就可以免驱动打印，同时也能支持 Airprint 。

后续考虑写一个服务，可以把文件发送到微信，这样就不用经过电脑就可以打印。

## 具体实现

openwrt 可以直接安装 cups ，但 Docker 更为容易，也方便调试，因此此项目是以 [olbat](https://github.com/olbat/dockerfiles/blob/master/cupsd/README.md) 为基础，在安装自己打印机的 Linux 驱动。

## 本地调试

### Build

```shell
docker build -t home-cupsd .
```

### 进入 Docker

```shell
docker run -d -p 631:631 -v /var/run/dbus:/var/run/dbus --name cupsd home-cupsd
```

### 列出打印机型号

```shell
lpinfo -m | grep Pantum
```

## 安装打印机

```shell
lpadmin -p pantum2200nw -v socket://192.168.100.1 -E -m "Pantum/Pantum P2200NW Series.ppd"
```
