#!/bin/bash

PACKAGES=("docker")

# 패키지 설치
echo "1. yum update"
sudo yum update -y

echo ""
echo "2. yum install"
sudo yum install -y "${PACKAGES[@]}"

# 설치된 패키지 확인
echo ""
echo "3. Check Installed packages"
echo "--------------------"
for package in "${PACKAGES[@]}"; do
    if rpm -q "$package" &>/dev/null; then
        echo "$package is installed."

        # 서비스 존재 여부 확인
        if sudo systemctl is-active "$package.service" | grep -q "unknown"; then
						echo "$package 는 서비스 X "
		    else
			      # 서비스 시작
            echo "$package 는 서비스 O"
            sudo systemctl start "$package.service"
            if [ $? -eq 0 ]; then
                echo "$package service started successfully."
            else
                echo "Failed to start $package service."
            fi
        fi
    fi
done

sudo usermod -aG docker ec2-user
echo "스크립트가 종료되었습니다. 사용자를 로그아웃시킵니다."
pkill -KILL -u "$USER"
