#!/bin/bash

# Get information about architecture
arc=$(uname -a)

# 1.CPU
# Count of Physical CPU processes
p_cpu=$(grep "physical id" /proc/cpuinfo | sort | uniq | wc -l)
# Count of Virtual CPU cores
v_cpu=$(grep "^processor" /proc/cpuinfo | wc -l)

# 2.RAM
# Total RAM in megabytes
t_ram=$(free -m | awk '$1 == "Mem:" {print $2}')
# Used RAM in megabytes
u_ram=$(free -m | awk '$1 == "Mem:" {print $3}')
# Percentage of RAM used
p_ram=$(free | awk '$1 == "Mem:" {printf("%.2f"), $3/$2*100}')

# 3.DISK
# Calculate total disks size on megabytes without /boot
f_dsk=$(df -m | grep "^/dev/" | grep -v "/boot$" | awk '{disk_t += $2} END {printf("%.1fGb", disk_t/1024)}')
# Calculate how much disk space used
u_dsk=$(df -BM | grep '^/dev/' | grep -v '/boot$' | awk '{ut += $3} END {print ut}')
# Percentage of disk space used
p_dsk=$(df -BM | grep '^/dev/' | grep -v '/boot$' | awk '{ut += $3} {ft+= $2} END {printf("%d"), ut/ft*100}')

# 4.CPU load data
# Calculates CPU load: user + system
cpul=$(top -bn1 | grep '^%Cpu' | cut -c 9- | xargs | awk '{printf("%.1f%%"), $1 + $3}')


# BOOT

# LVM

# TCP

# USER LOG

# NETWORK

# SUDO
