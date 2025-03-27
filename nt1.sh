#!/bin/bash

read -p "您想测试哪些ISP的路由？
1. 移动
2. 联通
3. 电信
4. 三网
请选择选项: " x
read -p "请您选择要测试的IP类型
1. IPv4
2. IPv6
3. IPv4+IPv6
请选择选项: " y

if [ -z "$x" ] || [ -z "$y" ]; then
   echo "输入无效，请重新运行脚本并选择正确的选项。"
   exit 1
fi

case $x in
    1)
        case $y in
            1) nexttrace cqv4.cm.123615.xyz ;;
            2) nexttrace cqv6.cm.123615.xyz ;;
            3) nexttrace cqv4.cm.123615.xyz && nexttrace cqv6.cm.123615.xyz ;;
            *) echo "无效的IP类型选择"; exit 1 ;;
        esac
        ;;
    2)
        case $y in
            1) nexttrace cqv4.cu.123615.xyz ;;
            2) nexttrace cqv6.cu.123615.xyz ;;
            3) nexttrace cqv4.cu.123615.xyz && nexttrace cqv6.cu.123615.xyz ;;
            *) echo "无效的IP类型选择"; exit 1 ;;
        esac
        ;;
    3)
        case $y in
            1) nexttrace cqv4.ct.123615.xyz ;;
            2) nexttrace cqv6.ct.123615.xyz ;;
            3) nexttrace cqv4.ct.123615.xyz && nexttrace cqv6.ct.123615.xyz ;;
            *) echo "无效的IP类型选择"; exit 1 ;;
        esac
        ;;
    4)
        case $y in
            1) nexttrace cqv4.cm.123615.xyz && nexttrace cqv4.cu.123615.xyz && nexttrace cqv4.ct.123615.xyz ;;
            2) nexttrace cqv6.cm.123615.xyz && nexttrace cqv6.cu.123615.xyz && nexttrace cqv6.ct.123615.xyz ;;
            3) nexttrace cqv4.cm.123615.xyz && nexttrace cqv4.cu.123615.xyz && nexttrace cqv4.ct.123615.xyz && nexttrace cqv6.cm.123615.xyz && nexttrace cqv6.cu.123615.xyz && nexttrace cqv6.ct.123615.xyz ;;
            *) echo "无效的IP类型选择"; exit 1 ;;
        esac
        ;;
    *)
        echo "无效的ISP选择"
        exit 1
        ;;
esac

