#!/bin/bash

# 检查系统版本
if [ -f /etc/redhat-release ]; then
    OS_VERSION=$(grep -oE '[0-9]+\.[0-9]+' /etc/redhat-release)
else
    echo "未找到 /etc/redhat-release 文件。请确保您运行的是 CentOS 系统。"
    exit 1
fi

# 仅支持 CentOS 7
if [[ $OS_VERSION != "7."* ]]; then
    echo "此脚本仅支持 CentOS 7 系统。当前系统版本为：$OS_VERSION"
    exit 1
fi

# 备份现有的YUM源配置文件
if [ -f /etc/yum.repos.d/CentOS-Base.repo ]; then
    cp /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak
    echo "现有的YUM源配置文件已备份为CentOS-Base.repo.bak"
fi

# 删除所有现有的YUM源配置文件
rm -f /etc/yum.repos.d/*.repo

# 添加阿里云的CentOS源
cat > /etc/yum.repos.d/CentOS-Base-ali.repo <<EOF
[ali-base]
name=CentOS-\$releasever - Base - aliyun
baseurl=http://mirrors.aliyun.com/centos/7/os/\$basearch/
gpgcheck=1
enabled=1
priority=1
gpgkey=http://mirrors.aliyun.com/centos/RPM-GPG-KEY-CentOS-7

[ali-updates]
name=CentOS-\$releasever - Updates - aliyun
baseurl=http://mirrors.aliyun.com/centos/7/updates/\$basearch/
gpgcheck=1
enabled=1
priority=1
gpgkey=http://mirrors.aliyun.com/centos/RPM-GPG-KEY-CentOS-7

[ali-extras]
name=CentOS-\$releasever - Extras - aliyun
baseurl=http://mirrors.aliyun.com/centos/7/extras/\$basearch/
gpgcheck=1
enabled=1
priority=1
gpgkey=http://mirrors.aliyun.com/centos/RPM-GPG-KEY-CentOS-7

[ali-plus]
name=CentOS-\$releasever - Plus - aliyun
baseurl=http://mirrors.aliyun.com/centos/7/centosplus/\$basearch/
gpgcheck=1
enabled=1
priority=1
gpgkey=http://mirrors.aliyun.com/centos/RPM-GPG-KEY-CentOS-7
EOF

# 添加CentOS官方Vault源
cat > /etc/yum.repos.d/CentOS-Vault.repo <<EOF
[vault-base]
name=CentOS-\$releasever - Base - Vault
baseurl=http://vault.centos.org/7.9.2009/os/\$basearch/
gpgcheck=1
enabled=1
priority=10
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

[vault-updates]
name=CentOS-\$releasever - Updates - Vault
baseurl=http://vault.centos.org/7.9.2009/updates/\$basearch/
gpgcheck=1
enabled=1
priority=10
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

[vault-extras]
name=CentOS-\$releasever - Extras - Vault
baseurl=http://vault.centos.org/7.9.2009/extras/\$basearch/
gpgcheck=1
enabled=1
priority=10
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

[vault-plus]
name=CentOS-\$releasever - Plus - Vault
baseurl=http://vault.centos.org/7.9.2009/centosplus/\$basearch/
gpgcheck=1
enabled=1
priority=10
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
EOF

# 清理并生成缓存
yum clean all
yum makecache

echo "YUM源已成功更换（包括CentOS Vault和阿里云源）
