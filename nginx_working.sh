if systemctl is-active --quiet nginx; then
	status="ONLINE"
	colored_status="\e[32m$status\e[0m"
	message="NGINX OPERACIONAL!"
	log_file="online_log.txt"
else
	status="OFFLINE"
	colored_status="\e[31m$status\e[0m"
	message="NGINX INOPERANTE OU FORA DE SERVIÇO!!!"
	log_file="offline_log.txt"
fi

log_dir="/var/log/nginx/"

if [[ ! -d "$log_dir" ]]; then
	echo "check_nginx: DIRETÓRIO $log_dir NÃO ENCONTRADO, CRIANDO DIRETÓRIO"
	sudo mkdir -p "$log_dir"
	sudo chmod 755 "$log_dir"
fi

if [[ ! -w "$log_dir" ]]; then
	echo "check_nginx: ESCRITA NÃO PERMITIDA EM $log_dir, PERMISSÃO NECESSÁRIA PARA PROSSEGUIR"
	sudo chmod 755 "$log_dir"
fi

timestamp=$(date "+%Y-%m-%d %H:%M:%S")
log="$timestamp Nginx $colored_status - $message"
echo -e "$log" >> "$log_dir$log_file"
