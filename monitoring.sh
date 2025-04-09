#!/bin/bash

# Get information about architecture
arc=$(uname -a)

# 1.CPU
# Count of Physical CPU processes
p_cpu=$(grep "physical id" /proc/cpuinfo | sort | uniq | wc -l)
# Count of Virtual CPU cores
v_cpu=$(grep "^processor" /proc/cpuinfo | wc -l)

# 2.MEMORY usage (RAM)
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

# 5.Last Reboot
# Date and time of the last system reboot 
d_lsr=$(who -b | awk '$1 == "system" {print $3 " " $4}')

# 6. LVM Info
# Checks if LVM (Logical Volume Manager) is used
u_lvm=$(if [ $(lsblk | grep "lvm" | wc -l) -eq 0 ]; then echo no; else echo yes; fi)

# 7. TCP connection
# Counts the number of active TCP connections
c_tcp=$(ss -neopt state established | wc -l)

# 8.USER count
# Counts the number of users logged in to the system
u_log=$(users | wc -w)

# 9.NETWORK data
# Displays the IP address of the machine.
ip=$(hostname -I)
# Displays the MAC address
mac=$(ip link | grep "link/ether" | awk '{print $2}')

# 10.SUDO
# Counts the number of commands executed via sudo using the systemd journal
s_cmd=$(journalctl _COMM=sudo | grep COMMAND | wc -l)

wall "	Architecture: $arc
	CPU physical: $p_cpu
	vCPU: $v_cpu
	Memory Usage: $u_ram/${f_ram}MB ($p_ram%)
	Disk Usage: $u_dsk/${f_dsk}Gb ($p_dsk%)
	CPU load: $l_cpu
	Last boot: $d_lsr
	LVM use: $u_lvm
	Connections TCP: $c_tcp ESTABLISHED
	User log: $u_log
	Network: IP $ip ($mac)
	Sudo: $s_cmd cmd"
