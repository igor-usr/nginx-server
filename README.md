# Criando um ambiente Linux no Windows:
#### Utilizando o WSL do Windows, crie um subsistema do Ubuntu 20.04 ou superior

Para instalar uma distuibuição Linux no Windows através do WSL, basta abrir o PowerShell, e digitar o seguinte commando:

```bash
wsl --install -d Ubuntu
```

O commando `wsl --install -d Ubuntu` realiza a instalação da versão mais recente do Ubuntu LTS.

Para acessar o seu Linux, basta apertar o botão `Win` do Windows e digitar o nome da sua distribuição Linux, que neste caso, é `Ubuntu`.

Acessando pela primeira vez, será necessário criar um usuário e senha de acesso. Após criadas as credenciais, digite os comandos `uname -a` e `lsb_release -a` para ver os detalhes do seu sistema:

![img](ttps://github.com/igor-usr/nginx-server/img/sistemas_detalhes.png)

Após seguir estes passos, o Linux via WSL está instalado.

# Criando e utilizando um servidor Nginx online e operacional
#### Instalação do Nginx:
```bash
sudo apt install nginx
```

Checando status do serviço do Nginx:
```bash
systemctl status nginx.service
```

![img](ttps://github.com/igor-usr/nginx-server/img/nginx_status.png)

Checando se o Nginx está rodando, filtrando pela porta 80:
```bash
ss -tulne
```

![img](ttps://github.com/igor-usr/nginx-server/img/ss_tulne.png)

Vamos enviar uma requisição para o servidor
```bash
curl -I http://localhost:80
```

![img](ttps://github.com/igor-usr/nginx-server/img/curl.png)

### Criando script que valide se o serviço está online e que envie o resultado da validação para diretório especificado
Criando arquivo de extensão .sh (automação em shell script):
```bash
nano nginx_working.sh
```

Validando disponibilidade do serviço:
```bash
if systemctl is-active --quiet nginx; then
  log="Nginx está rodando!"
fi
```

Armazenando resultado e tratando permissões:
```bash
log_dir="/var/log/nginx/"
log_file="result.txt"

if [[ ! -d "$log_dir" ]]; then
	echo "check_nginx: Diretório $log_dir não encontrado, nessário permissão para criar diretório"
	sudo mkdir -p "$log_dir"
	sudo chmod 775 "$log_dir"
fi

if [[ ! -w "$log_dir" ]]; then
	echo "check_nginx: Não é permitido escrita em $log_dir, necessário permissão para prosseguir"
	sudo chmod 775 "$log_dir"
fi
echo "$log" >> "$log_dir$log_file"
```

#### OBS.: o script deve conter as seguintes informações:
- data e hora
- nome do serviço,
- status
- mensagem personalizada de online ou offline


### Alterando as condições para atender os novos requisitos:
```bash
if systemctl is-active --quiet nginx; then
  status="ONLINE"
	colored_status="\e[32m$status\e[0m"
  message="Nginx está rodando!"
else
  status="OFFLINE"
	colored_status="\e[31m$status\e[0m"
  message="Nginx não está ativo ou está com problemas!"
fi
```

#### Atualizando o resultado final do script:
```bash
timestamp=$(date "+%Y-%m-%d %H:%M:%S")
log="$timestamp Nginx $colored_status - $message"
echo -e "$log" >> "$log_dir$log_file"
```

#### > arquivos gerados pelo script (resultado esperado):
- 01 arquivo para o serviço online
- 01 arquivo para o serviço offline

### Criando a diferenciação dos arquivos de saída:
```bash
if systemctl is-active --quiet nginx; then
	status="ONLINE"
	colored_status="\e[32m$status\e[0m"
	message="Nginx está rodando!"
	log_file="online_log.txt"
else
	status="OFFLINE"
	colored_status="\e[31m$status\e[0m"
	message="Nginx não está ativo ou está com problemas!"
	log_file="offline_log.txt"
fi

log_dir="/var/log/nginx/"

if [[ ! -d "$log_dir" ]]; then
	echo "check_nginx: Diretório $log_dir não encontrado, criando diretório"
	sudo mkdir -p "$log_dir"
	sudo chmod 775 "$log_dir"
fi

if [[ ! -w "$log_dir" ]]; then
	echo "check_nginx: Não é permitido escrita em $log_dir, necessário permissão para prosseguir"
	sudo chmod 775 "$log_dir"
fi

timestamp=$(date "+%Y-%m-%d %H:%M:%S")
log="$timestamp Nginx $colored_status - $message"
echo -e "$log" >> "$log_dir$log_file"
```

### Habilitando a execução automatizada do script para cada 5 minutos:
#### Adicionando script para diretório localizado no PATH para que seja executado sem restrições de diretório:
```bash
sudo cp ./check_nginx.sh /usr/bin
```
#### Dando permissão de execução para o script:
```bash
sudo chmod +x check_nginx.sh
```

#### Abrindo o agendador de tarefas do Linux:
```bash
crontab -e
```

#### Adicinando o seguinte código para executar a tarefa desejada
```bash
*/5 * * * * check_nginx.sh
```
#### Resultado final:

![img](ttps://github.com/igor-usr/nginx-server/img/nginx_online.png)

![img](ttps://github.com/igor-usr/nginx-server/img/nginx_offline.png)

### Realizando versionamento da automatização realizada

#### Iniciando um novo repositório:
```
git init
```
#### Adicionando os arquivos para serem commitados:
```
git add .
```

#### Fazendo o commit:
```
git commit -m "initial commit"
```

#### Renomeando a branch master para main:
```
git branch -M main
```

#### Adicionando o .git do repositório remoto:
```
git remote add origin https://github.com/Paulooo0/linux-activ-compass.git
```

Dando push das alterações na branch main recém criada:
```
git push -U origin main
```
