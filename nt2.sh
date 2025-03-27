#!/bin/bash

# 定义目标地址和对应的运营商
declare -A targets=(
    ["电信"]="cq.ct.123615.xyz"  # 示例域名，请替换为实际地址
    ["联通"]="cq.cu.123615.xyz"
    ["移动"]="cq.cm.123615.xyz"
)

# 函数：执行NextTrace (假设存在一个名为nexttrace的工具)
execute_nexttrace() {
    local target=$1
    local version=$2
    echo "正在对 $target 进行 IPv$version 路由追踪..."

    if ! command -v nexttrace &> /dev/null; then
        echo "nexttrace 工具未安装或不在PATH中。请确认已正确安装并配置。"
        return 1
    fi

    if [[ "$version" == "4" ]]; then
        nexttrace -4 "$target"
    elif [[ "$version" == "6" ]]; then
        nexttrace -6 "$target"
    else
        echo "未知的IP版本: $version"
        return 1
    fi
}

# 批量执行选定运营商的V4V6测试
batch_execute_selected() {
    PS3="请选择要进行V4V6测试的运营商（选择完成后按Enter）："

    while true; do
        select operator in "${!targets[@]}"; do
            if [ -n "$operator" ]; then
                echo "开始对 ${operator} (${targets[$operator]}) 进行 V4V6 测试..."
                execute_nexttrace "${targets[$operator]}" "4"
                execute_nexttrace "${targets[$operator]}" "6"
                echo "完成对 ${operator} 的测试。\n"
            else
                echo "无效的选择，请重新选择或按Enter结束选择。"
                break  # 如果选择了无效项，则退出循环
            fi
        done
        break  # 退出主循环
    done
}

# 主程序
echo "请选择要进行的操作（输入数字）："
options=("单个运营商测试" "选定运营商V4V6测试")
select opt in "${options[@]}"; do
    case $opt in
        "单个运营商测试")
            echo "请选择要测试的网络运营商（输入数字或名称）："
            select operator in "${!targets[@]}"; do
                if [ -n "$operator" ]; then
                    break
                else
                    echo "无效的选择，请重新选择。"
                fi
            done

            echo "你选择了 $operator, 目标地址为 ${targets[$operator]}"

            # 选择IP版本
            echo "请选择IP版本（输入数字）："
            select ip_version in "IPv4" "IPv6"; do
                if [ -n "$ip_version" ]; then
                    version=$(echo $ip_version | grep -o '[0-9]')
                    if execute_nexttrace "${targets[$operator]}" "$version"; then
                        echo "IPv$version 路由追踪完成。"
                    else
                        echo "IPv$version 路由追踪失败。"
                    fi
                    break
                else
                    echo "无效的选择，请重新选择。"
                fi
            done
            ;;
        "选定运营商V4V6测试")
            batch_execute_selected
            ;;
        *) echo "无效的选择，请重新运行脚本并选择正确的选项"; exit ;;
    esac
    break
done

echo "测试完成。"
