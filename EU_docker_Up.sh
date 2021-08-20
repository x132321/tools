# 判断当前 docker 状态，遇到 Created 或 Exited 时重启，直至刷成功
echo "docker ps -a | egrep 'Created|Exited'" >  /root/EU_docker_AutoUp.sh
echo 'until [ $? -ne 0 ]'  >> /root/EU_docker_AutoUp.sh
echo '  do' >> /root/EU_docker_AutoUp.sh
echo '     docker start $(docker ps -aq)' >> /root/EU_docker_AutoUp.sh
echo "     docker ps -a | egrep 'Created|Exited'" >> /root/EU_docker_AutoUp.sh
echo 'done' >> /root/EU_docker_AutoUp.sh

# 判断刷重启进程是否存在，不存在则启动刷重启脚本
echo "pgrep -laf 'EU_docker_AutoUp'" >  /root/EU_docker_check.sh
echo 'if [ $? -ne 0 ]' >> /root/EU_docker_check.sh
echo '     then bash /root/EU_docker_AutoUp.sh' >> /root/EU_docker_check.sh
echo 'fi' >> /root/EU_docker_check.sh

# 定时任务，1分钟运行守护进程一次
echo '*/1 * * * *  root bash /root/EU_docker_check.sh' >> /etc/crontab
echo -e "\033[32m EUserv Docker 守护进程已运行，系统1分钟判断一次 Docker 状态，重启已停止的 docker ！ \033[0m"