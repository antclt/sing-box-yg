#!/bin/bash
# Color definitions
r="\033[0m"
rd="\033[1;91m"
gn="\e[1;32m"
yl="\e[1;33m"
pr="\e[1;35m"
rd() { echo -e "\e[1;91m$1\033[0m"; }
gn() { echo -e "\e[1;32m$1\033[0m"; }
yl() { echo -e "\e[1;33m$1\033[0m"; }
pr() { echo -e "\e[1;35m$1\033[0m"; }
rdg() { read -p "$(rd "$1")" "$2"; }
export LC_ALL=C
export U=${U:-''}  
export AD=${AD:-''}   
export AA=${AA:-''}     
export vp=${vp:-''}    
export mp=${mp:-''}  
export hp=${hp:-''}       
export IP=${IP:-''}                  
export ry=${ry:-''}
export rs=${rs:-''}
export rp=${rp:-''}

USR=$(whoami | tr '[:upper:]' '[:lower:]')
HST=$(hostname)
sb=$(hostname | cut -d. -f1)
b=$(hostname | cut -d '.' -f 1 | tr -d 's')
if [[ "$rs" =~ ^[Yy]$ ]]; then
bash -c 'ps aux | grep $(whoami) | grep -v "sshd\|bash\|grep" | awk "{print \$2}" | xargs -r kill -9 >/dev/null 2>&1' >/dev/null 2>&1
devil www list | awk 'NR > 1 && NF {print $1}' | xargs -I {} devil www del {} > /dev/null 2>&1
sed -i '/export PATH="\$HOME\/bin:\$PATH"/d' "${HOME}/.bashrc" >/dev/null 2>&1
source "${HOME}/.bashrc" >/dev/null 2>&1
find ~ -type f -exec chmod 644 {} \; 2>/dev/null
find ~ -type d -exec chmod 755 {} \; 2>/dev/null
find ~ -type f -exec rm -f {} \; 2>/dev/null
find ~ -type d -empty -exec rmdir {} \; 2>/dev/null
find ~ -exec rm -rf {} \; 2>/dev/null
gn "System reset complete"
fi
devil www add ${USR}.serv00.net php > /dev/null 2>&1
FP="${HOME}/domains/${USR}.serv00.net/public_html"
WD="${HOME}/domains/${USR}.serv00.net/logs"
[ -d "$FP" ] || mkdir -p "$FP"
[ -d "$WD" ] || (mkdir -p "$WD" && chmod 777 "$WD")
kp="${HOME}/domains/${sb}.${USR}.serv00.net/public_nodejs"
[ -d "$kp" ] || mkdir -p "$kp"

if [[ -z "$AA" ]] && [[ -f "$WD/ARGO_AUTH.log" ]]; then
AA=$(cat "$WD/ARGO_AUTH.log" 2>/dev/null)
elif [[ -z "$AA" ]] && [[ ! -f "$WD/ARGO_AUTH.log" ]]; then
echo "$AA" > $WD/ARGO_AUTH.log
else
echo "$AA" > $WD/ARGO_AUTH.log
AA=$(cat "$WD/ARGO_AUTH.log" 2>/dev/null)
fi
if [[ -z "$AD" ]] && [[ -f "$WD/ARGO_DOMAIN.log" ]]; then
AD=$(cat "$WD/ARGO_DOMAIN.log" 2>/dev/null)
elif [[ -z "$AD" ]] && [[ ! -f "$WD/ARGO_DOMAIN.log" ]]; then
echo "$AD" > $WD/ARGO_DOMAIN.log
else
echo "$AD" > $WD/ARGO_DOMAIN.log
AD=$(cat "$WD/ARGO_DOMAIN.log" 2>/dev/null)
fi

if [[ -z "$U" ]] && [[ -f "$WD/UUID.txt" ]]; then
U=$(cat "$WD/UUID.txt" 2>/dev/null)
elif [[ -z "$U" ]] && [[ ! -f "$WD/UUID.txt" ]]; then
U=$(uuidgen -r)
echo "$U" > $WD/UUID.txt
else
echo "$U" > $WD/UUID.txt
U=$(cat "$WD/UUID.txt" 2>/dev/null)
fi
curl -sL https://raw.githubusercontent.com/antclt/sing-box-yg/main/app.js -o "$kp"/app.js
sed -i '' "15s/name/$sb/g" "$kp"/app.js
sed -i '' "59s/key/$U/g" "$kp"/app.js
sed -i '' "90s/name/$USR/g" "$kp"/app.js
sed -i '' "90s/where/$sb/g" "$kp"/app.js
if [[ -z "$ry" ]] && [[ -f "$WD/reym.txt" ]]; then
ry=$(cat "$WD/reym.txt" 2>/dev/null)
elif [[ -z "$ry" ]] && [[ ! -f "$WD/reym.txt" ]]; then
ry=$USR.serv00.net
echo "$ry" > $WD/reym.txt
else
echo "$ry" > $WD/reym.txt
ry=$(cat "$WD/reym.txt" 2>/dev/null)
fi

rsp(){
pl=$(devil port list | grep -E '^[0-9]+[[:space:]]+[a-zA-Z]+' | sed 's/^[[:space:]]*//')
if [[ -z "$pl" ]]; then
yl "No ports"
else
while read -r line; do
p=$(echo "$line" | awk '{print $1}')
pt=$(echo "$line" | awk '{print $2}')
yl "Deleting port $p ($pt)"
devil port del "$pt" "$p"
done <<< "$pl"
fi
cp
hy=$(jq -r '.inbounds[0].listen_port' $WD/config.json)
vl=$(jq -r '.inbounds[3].listen_port' $WD/config.json)
vm=$(jq -r '.inbounds[4].listen_port' $WD/config.json)
sed -i '' "12s/$hy/$hp/g" $WD/config.json
sed -i '' "33s/$hy/$hp/g" $WD/config.json
sed -i '' "54s/$hy/$hp/g" $WD/config.json
sed -i '' "75s/$vl/$vp/g" $WD/config.json
sed -i '' "102s/$vm/$mp/g" $WD/config.json
sed -i '' -e "17s|'$vl'|'$vp'|" serv00keep.sh
sed -i '' -e "18s|'$vm'|'$mp'|" serv00keep.sh
sed -i '' -e "19s|'$hy'|'$hp'|" serv00keep.sh
ps aux | grep '[r]un -c con' | awk '{print $2}' | xargs -r kill -9 > /dev/null 2>&1
sleep 1
curl -sk "http://${sb}.${USR}.serv00.net/up" > /dev/null 2>&1
sleep 5
}

oip(){
    IL=($(devil vhost list | awk '/^[0-9]+/ {print $1}'))
    AU="https://status.eooce.com/api"
    IP=""
    TI=${IL[2]}
    RE=$(curl -s --max-time 2 "${AU}/${TI}")
    if [[ $(echo "$RE" | jq -r '.status') == "Available" ]]; then
        IP=$TI
    else
        FI=${IL[0]}
        RE=$(curl -s --max-time 2 "${AU}/${FI}")
        
        if [[ $(echo "$RE" | jq -r '.status') == "Available" ]]; then
            IP=$FI
        else
            IP=${IL[1]}
        fi
    fi
    echo "$IP"
    }

cp(){
pl=$(devil port list)
tp=$(echo "$pl" | grep -c "tcp")
up=$(echo "$pl" | grep -c "udp")
if [[ $tp -ne 2 || $up -ne 1 ]]; then
    yl "Port count mismatch, adjusting..."

    if [[ $tp -gt 2 ]]; then
        td=$((tp - 2))
        echo "$pl" | awk '/tcp/ {print $1, $2}' | head -n $td | while read p t; do
            devil port del $t $p
            yl "Deleted TCP port: $p"
        done
    fi

    if [[ $up -gt 1 ]]; then
        ua=$((up - 1))
        echo "$pl" | awk '/udp/ {print $1, $2}' | head -n $ua | while read p t; do
            devil port del $t $p
            yl "Deleted UDP port: $p"
        done
    fi

    if [[ $tp -lt 2 ]]; then
        ta=$((2 - tp))
        ta=0
        while [[ $ta -lt $ta ]]; do
            p=$(shuf -i 10000-65535 -n 1) 
            re=$(devil port add tcp $p 2>&1)
            if [[ $re == *"succesfully"* ]]; then
                yl "Added TCP port: $p"
                if [[ $ta -eq 0 ]]; then
                    p1=$p
                else
                    p2=$p
                fi
                ta=$((ta + 1))
            else
                yl "Port $p unavailable, trying another..."
            fi
        done
    fi

    if [[ $up -lt 1 ]]; then
        while true; do
            p=$(shuf -i 10000-65535 -n 1) 
            re=$(devil port add udp $p 2>&1)
            if [[ $re == *"succesfully"* ]]; then
                yl "Added UDP port: $p"
                break
            else
                yl "Port $p unavailable, trying another..."
            fi
        done
    fi
    sleep 3
    pl=$(devil port list)
    tp=$(echo "$pl" | grep -c "tcp")
    up=$(echo "$pl" | grep -c "udp")
    tp=$(echo "$pl" | awk '/tcp/ {print $1}')
    p1=$(echo "$tp" | sed -n '1p')
    p2=$(echo "$tp" | sed -n '2p')
    up=$(echo "$pl" | awk '/udp/ {print $1}')
    pr "Current TCP ports: $p1 and $p2"
    pr "Current UDP port: $up"
else
    tp=$(echo "$pl" | awk '/tcp/ {print $1}')
    p1=$(echo "$tp" | sed -n '1p')
    p2=$(echo "$tp" | sed -n '2p')
    up=$(echo "$pl" | awk '/udp/ {print $1}')
    yl "Your vless-reality TCP port: $p1" 
    yl "Your vmess TCP port (set Argo domain port): $p2"
    yl "Your hysteria2 UDP port: $up"
fi
export vp=$p1
export mp=$p2
export hp=$up
}

gad() {
  if [[ -n $AA ]]; then
    echo "$AD" > AD.log
    echo "$AD"
  else
    local retry=0
    local mr=6
    local ad=""
    while [[ $retry -lt $mr ]]; do
    ((retry++)) 
    ad=$(cat boot.log 2>/dev/null | grep -a trycloudflare.com | awk 'NR==2{print}' | awk -F// '{print $2}' | awk '{print $1}')
      if [[ -n $ad ]]; then
        break
      fi
      sleep 2
    done  
    if [ -z ${ad} ]; then
    ad="Argo temp domain unavailable temporarily, other nodes still available"
    fi
    echo "$ad"
  fi
}

if [ ! -f serv00keep.sh ]; then
curl -sSL https://raw.githubusercontent.com/antclt/sing-box-yg/main/serv00keep.sh -o serv00keep.sh && chmod +x serv00keep.sh
echo '#!/bin/bash
rd() { echo -e "\e[1;91m$1\033[0m"; }
gn() { echo -e "\e[1;32m$1\033[0m"; }
yl() { echo -e "\e[1;33m$1\033[0m"; }
pr() { echo -e "\e[1;35m$1\033[0m"; }
USR=$(whoami | tr '\''[:upper:]'\'' '\''[:lower:]'\'')
WD="${HOME}/domains/${USR}.serv00.net/logs"
sb=$(hostname | cut -d. -f1)
' > webport.sh
declare -f rsp >> webport.sh
declare -f cp >> webport.sh
echo 'rsp' >> webport.sh
chmod +x webport.sh
gn "Installing multi-functional homepage, please wait..."
devil www del ${sb}.${USR}.serv00.net > /dev/null 2>&1
devil www add ${USR}.serv00.net php > /dev/null 2>&1
devil www add ${sb}.${USR}.serv00.net nodejs /usr/local/bin/node18 > /dev/null 2>&1
ln -fs /usr/local/bin/node18 ~/bin/node > /dev/null 2>&1
ln -fs /usr/local/bin/npm18 ~/bin/npm > /dev/null 2>&1
mkdir -p ~/.npm-global
npm config set prefix '~/.npm-global'
echo 'export PATH=~/.npm-global/bin:~/bin:$PATH' >> $HOME/.bash_profile && source $HOME/.bash_profile
rm -rf $HOME/.npmrc > /dev/null 2>&1
cd "$kp"
npm install basic-auth express dotenv axios --silent > /dev/null 2>&1
rm $HOME/domains/${sb}.${USR}.serv00.net/public_nodejs/public/index.html > /dev/null 2>&1
devil www restart ${sb}.${USR}.serv00.net
gn "Installation complete, homepage URL: http://${sb}.${USR}.serv00.net"
fi

if [[ "$rp" =~ ^[Yy]$ ]]; then
pl=$(devil port list | grep -E '^[0-9]+[[:space:]]+[a-zA-Z]+' | sed 's/^[[:space:]]*//')
if [[ -z "$pl" ]]; then
yl "No ports"
else
while read -r line; do
p=$(echo "$line" | awk '{print $1}')
pt=$(echo "$line" | awk '{print $2}')
yl "Deleting port $p ($pt)"
devil port del "$pt" "$p"
done <<< "$pl"
fi
cp
fi
rm -rf $HOME/domains/${sb}.${USR}.serv00.net/logs/*

cd $WD
ym=("$HST" "cache$b.serv00.com" "web$b.serv00.com")
rm -rf ip.txt
for host in "${ym[@]}"; do
re=$(curl -sL --connect-timeout 5 --max-time 7 "https://ss.fkj.pp.ua/api/getip?host=$host")
if [[ "$re" =~ (unknown|not|error) ]]; then
dig @8.8.8.8 +time=5 +short $host | sort -u >> ip.txt
sleep 1  
else
while IFS='|' read -r ip st; do
if [[ $st == "Accessible" ]]; then
echo "$ip: Available" >> ip.txt
else
echo "$ip: Blocked (Argo and CDN origin nodes, proxyip still work)" >> ip.txt
fi	
done <<< "$re"
fi
done
if [[ ! "$re" =~ (unknown|not|error) ]]; then
grep ':' $WD/ip.txt | sort -u -o $WD/ip.txt
fi
if [[ -z "$IP" ]]; then
IP=$(grep -m 1 "Available" ip.txt | awk -F ':' '{print $1}')
if [ -z "$IP" ]; then
IP=$(oip)
if [ -z "$IP" ]; then
IP=$(head -n 1 ip.txt | awk -F ':' '{print $1}')
fi
fi
fi

if [[ -z "$vp" ]] || [[ -z "$mp" ]] || [[ -z "$hp" ]]; then
cp
fi
if [ ! -s sb.txt ] && [ ! -s ag.txt ]; then
DD="." && mkdir -p "$DD" && FI=()
FI=("https://github.com/antclt/Cloudflare_vless_trojan/releases/download/serv00/sb web" "https://github.com/antclt/Cloudflare_vless_trojan/releases/download/serv00/server bot")
declare -A FM
grn() {
    local chars=abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890
    local name=""
    for i in {1..6}; do
        name="$name${chars:RANDOM%${#chars}:1}"
    done
    echo "$name"
}

dwfb() {
    local URL=$1
    local NF=$2

    curl -L -sS --max-time 2 -o "$NF" "$URL" &
    CP=$!
    CS=$(stat -c%s "$NF" 2>/dev/null || echo 0)
    
    sleep 1
    CC=$(stat -c%s "$NF" 2>/dev/null || echo 0)
    
    if [ "$CC" -le "$CS" ]; then
        kill $CP 2>/dev/null
        wait $CP 2>/dev/null
        wget -q -O "$NF" "$URL"
        gn "Downloading $NF via wget"
    else
        wait $CP
        gn "Downloading $NF via curl"
    fi
}

for e in "${FI[@]}"; do
    URL=$(echo "$e" | cut -d ' ' -f 1)
    RN=$(grn)
    NF="$DD/$RN"
    
    if [ -e "$NF" ]; then
        gn "$NF exists, skipping"
    else
        dwfb "$URL" "$NF"
    fi
    
    chmod +x "$NF"
    FM[$(echo "$e" | cut -d ' ' -f 2)]="$NF"
done
wait
fi

if [ ! -e private_key.txt ]; then
out=$(./"$(basename ${FM[web]})" generate reality-keypair)
pk=$(echo "${out}" | awk '/PrivateKey:/ {print $2}')
pbk=$(echo "${out}" | awk '/PublicKey:/ {print $2}')
echo "${pk}" > private_key.txt
echo "${pbk}" > public_key.txt
fi
pk=$(<private_key.txt)
pbk=$(<public_key.txt)
openssl ecparam -genkey -name prime256v1 -out "private.key"
openssl req -new -x509 -days 3650 -key "private.key" -out "cert.pem" -subj "/CN=$USR.serv00.net"
  cat > config.json << EOF
{
  "log": {
    "disabled": true,
    "level": "info",
    "timestamp": true
  },
    "inbounds": [
    {
       "tag": "hysteria-in1",
       "type": "hysteria2",
       "listen": "$(dig @8.8.8.8 +time=5 +short "web$b.serv00.com" | sort -u)",
       "listen_port": $hp,
       "users": [
         {
             "password": "$U"
         }
     ],
     "masquerade": "https://www.bing.com",
     "ignore_client_bandwidth":false,
     "tls": {
         "enabled": true,
         "alpn": [
             "h3"
         ],
         "certificate_path": "cert.pem",
         "key_path": "private.key"
        }
    },
        {
       "tag": "hysteria-in2",
       "type": "hysteria2",
       "listen": "$(dig @8.8.8.8 +time=5 +short "$HST" | sort -u)",
       "listen_port": $hp,
       "users": [
         {
             "password": "$U"
         }
     ],
     "masquerade": "https://www.bing.com",
     "ignore_client_bandwidth":false,
     "tls": {
         "enabled": true,
         "alpn": [
             "h3"
         ],
         "certificate_path": "cert.pem",
         "key_path": "private.key"
        }
    },
        {
       "tag": "hysteria-in3",
       "type": "hysteria2",
       "listen": "$(dig @8.8.8.8 +time=5 +short "cache$b.serv00.com" | sort -u)",
       "listen_port": $hp,
       "users": [
         {
             "password": "$U"
         }
     ],
     "masquerade": "https://www.bing.com",
     "ignore_client_bandwidth":false,
     "tls": {
         "enabled": true,
         "alpn": [
             "h3"
         ],
         "certificate_path": "cert.pem",
         "key_path": "private.key"
        }
    },
    {
        "tag": "vless-reality-vesion",
        "type": "vless",
        "listen": "::",
        "listen_port": $vp,
        "users": [
            {
              "uuid": "$U",
              "flow": "xtls-rprx-vision"
            }
        ],
        "tls": {
            "enabled": true,
            "server_name": "$ry",
            "reality": {
                "enabled": true,
                "handshake": {
                    "server": "$ry",
                    "server_port": 443
                },
                "private_key": "$pk",
                "short_id": [
                  ""
                ]
            }
        }
    },
{
      "tag": "vmess-ws-in",
      "type": "vmess",
      "listen": "::",
      "listen_port": $mp,
      "users": [
      {
        "uuid": "$U"
      }
    ],
    "transport": {
      "type": "ws",
      "path": "$U-vm",
      "early_data_header_name": "Sec-WebSocket-Protocol"
      }
    }
 ],
     "outbounds": [
     {
        "type": "wireguard",
        "tag": "wg",
        "server": "162.159.192.200",
        "server_port": 4500,
        "local_address": [
                "172.16.0.2/32",
                "2606:4700:110:8f77:1ca9:f086:846c:5f9e/128"
        ],
        "private_key": "wIxszdR2nMdA7a2Ul3XQcniSfSZqdqjPb6w6opvf5AU=",
        "peer_public_key": "bmXOC+F1FxEMF9dyiK2H5/1SUtzH0JuVo51h2wPfgyo=",
        "reserved": [
            126,
            246,
            173
        ]
    },
    {
      "type": "direct",
      "tag": "direct"
    }
  ],
   "route": {
       "rule_set": [
      {
        "tag": "google-gemini",
        "type": "remote",
        "format": "binary",
        "url": "https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/sing/geo/geosite/google-gemini.srs",
        "download_detour": "direct"
      }
    ],
EOF
if [[ "$b" =~ 14|15 ]]; then
cat >> config.json <<EOF 
    "rules": [
    {
     "domain": [
     "jnn-pa.googleapis.com"
      ],
     "outbound": "wg"
     },
     {
     "rule_set":[
     "google-gemini"
     ],
     "outbound": "wg"
    }
    ],
    "final": "direct"
    }  
}
EOF
else
  cat >> config.json <<EOF
    "final": "direct"
    }  
}
EOF
fi

if ! ps aux | grep '[r]un -c con' > /dev/null; then
ps aux | grep '[r]un -c con' | awk '{print $2}' | xargs -r kill -9 > /dev/null 2>&1
if [ -e "$(basename "${FM[web]}")" ]; then
   echo "$(basename "${FM[web]}")" > sb.txt
   s=$(cat sb.txt)   
    nohup ./"$s" run -c config.json >/dev/null 2>&1 &
    sleep 5
if pgrep -x "$s" > /dev/null; then
    gn "$s main process running"
else
    rd "$s not running, restarting..."
    pkill -x "$s"
    nohup ./"$s" run -c config.json >/dev/null 2>&1 &
    sleep 2
    pr "$s restarted"
fi
else
    s=$(cat sb.txt)   
    nohup ./"$s" run -c config.json >/dev/null 2>&1 &
    sleep 5
if pgrep -x "$s" > /dev/null; then
    gn "$s main process running"
else
    rd "$s not running, restarting..."
    pkill -x "$s"
    nohup ./"$s" run -c config.json >/dev/null 2>&1 &
    sleep 2
    pr "$s restarted"
fi
fi
else
gn "Main process running"
fi
cfgo() {
rm -rf boot.log
if [ -e "$(basename "${FM[bot]}")" ]; then
   echo "$(basename "${FM[bot]}")" > ag.txt
   a=$(cat ag.txt)
    if [[ $AA =~ ^[A-Z0-9a-z=]{120,250}$ ]]; then
      args="tunnel --no-autoupdate run --token ${AA}"
    else
     args="tunnel --url http://localhost:$mp --no-autoupdate --logfile boot.log --loglevel info"
    fi
    nohup ./"$a" $args >/dev/null 2>&1 &
    sleep 10
if pgrep -x "$a" > /dev/null; then
    gn "$a Argo process running"
else
    rd "$a not running, restarting..."
    pkill -x "$a"
    nohup ./"$a" "${args}" >/dev/null 2>&1 &
    sleep 5
    pr "$a restarted"
fi
else
   a=$(cat ag.txt)
    if [[ $AA =~ ^[A-Z0-9a-z=]{120,250}$ ]]; then
      args="tunnel --no-autoupdate run --token ${AA}"
    else
     args="tunnel --url http://localhost:$mp --no-autoupdate --logfile boot.log --loglevel info"
    fi
    pkill -x "$a"
    nohup ./"$a" $args >/dev/null 2>&1 &
    sleep 10
if pgrep -x "$a" > /dev/null; then
    gn "$a Argo process running"
else
    rd "$a not running, restarting..."
    pkill -x "$a"
    nohup ./"$a" "${args}" >/dev/null 2>&1 &
    sleep 5
    pr "$a restarted"
fi
fi
}

if [ -f "$WD/boot.log" ]; then
asl=$(cat "$WD/boot.log" 2>/dev/null | grep -a trycloudflare.com | awk 'NR==2{print}' | awk -F// '{print $2}' | awk '{print $1}')
chk=$(curl -o /dev/null -s -w "%{http_code}\n" "https://$asl")
fi
if ([ -z "$AD" ] && ! ps aux | grep '[t]unnel --u' > /dev/null) || [[ "$chk" != 404 ]]; then
ps aux | grep '[t]unnel --u' | awk '{print $2}' | xargs -r kill -9 > /dev/null 2>&1
cfgo
elif [ -n "$AD" ] && ! ps aux | grep '[t]unnel --n' > /dev/null; then
ps aux | grep '[t]unnel --n' | awk '{print $2}' | xargs -r kill -9 > /dev/null 2>&1
cfgo
else
gn "Argo process running"
fi
sleep 2
if ! pgrep -x "$(cat sb.txt)" > /dev/null; then
rd "Main process not running, troubleshoot:"
yl "1. Choose REP:y to reset ports, keep empty, then change to n"
yl "2. Choose RES:y for system reset, then change to n"
yl "3. Server down? Try later"
rd "4. If all fails, auto-recovery will handle it"
fi


ad=$(gad)
rm -rf ${FP}/*.txt
pr "Argo Domain: ${ad}\n"
a=$(dig @8.8.8.8 +time=5 +short "web$b.serv00.com" | sort -u)
b=$(dig @8.8.8.8 +time=5 +short "$HST" | sort -u)
c=$(dig @8.8.8.8 +time=5 +short "cache$b.serv00.com" | sort -u)
if [[ "$IP" == "$a" ]]; then
C1=$b; C2=$c
elif [[ "$IP" == "$b" ]]; then
C1=$a; C2=$c
elif [[ "$IP" == "$c" ]]; then
C1=$a; C2=$b
else
rd "Error, please reinstall script"
fi
vll="vless://$U@$IP:$vp?encryption=none&flow=xtls-rprx-vision&security=reality&sni=$ry&fp=chrome&pbk=$pbk&type=tcp&headerType=none#$sb-reality-$USR"
echo "$vll" > jh.txt
vmwl="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"$sb-vmess-ws-$USR\", \"add\": \"$IP\", \"port\": \"$mp\", \"id\": \"$U\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"\", \"path\": \"/$U-vm?ed=2048\", \"tls\": \"\", \"sni\": \"\", \"alpn\": \"\", \"fp\": \"\"}" | base64 -w0)"
echo "$vmwl" >> jh.txt
vmat="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"$sb-vmess-ws-tls-argo-$USR\", \"add\": \"www.visa.com.hk\", \"port\": \"8443\", \"id\": \"$U\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$ad\", \"path\": \"/$U-vm?ed=2048\", \"tls\": \"tls\", \"sni\": \"$ad\", \"alpn\": \"\", \"fp\": \"\"}" | base64 -w0)"
echo "$vmat" >> jh.txt
vma="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"$sb-vmess-ws-argo-$USR\", \"add\": \"www.visa.com.hk\", \"port\": \"8880\", \"id\": \"$U\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$ad\", \"path\": \"/$U-vm?ed=2048\", \"tls\": \"\"}" | base64 -w0)"
echo "$vma" >> jh.txt
hy2l="hysteria2://$U@$IP:$hp?security=tls&sni=www.bing.com&alpn=h3&insecure=1#$sb-hy2-$USR"
echo "$hy2l" >> jh.txt
vll1="vless://$U@$C1:$vp?encryption=none&flow=xtls-rprx-vision&security=reality&sni=$ry&fp=chrome&pbk=$pbk&type=tcp&headerType=none#$sb-reality-$USR-$C1"
echo "$vll1" >> jh.txt
vmwl1="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"$sb-vmess-ws-$USR-$C1\", \"add\": \"$C1\", \"port\": \"$mp\", \"id\": \"$U\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"\", \"path\": \"/$U-vm?ed=2048\", \"tls\": \"\", \"sni\": \"\", \"alpn\": \"\", \"fp\": \"\"}" | base64 -w0)"
echo "$vmwl1" >> jh.txt
hy2l1="hysteria2://$U@$C1:$hp?security=tls&sni=www.bing.com&alpn=h3&insecure=1#$sb-hy2-$USR-$C1"
echo "$hy2l1" >> jh.txt
vll2="vless://$U@$C2:$vp?encryption=none&flow=xtls-rprx-vision&security=reality&sni=$ry&fp=chrome&pbk=$pbk&type=tcp&headerType=none#$sb-reality-$USR-$C2"
echo "$vll2" >> jh.txt
vmwl2="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"$sb-vmess-ws-$USR-$C2\", \"add\": \"$C2\", \"port\": \"$mp\", \"id\": \"$U\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"\", \"path\": \"/$U-vm?ed=2048\", \"tls\": \"\", \"sni\": \"\", \"alpn\": \"\", \"fp\": \"\"}" | base64 -w0)"
echo "$vmwl2" >> jh.txt
hy2l2="hysteria2://$U@$C2:$hp?security=tls&sni=www.bing.com&alpn=h3&insecure=1#$sb-hy2-$USR-$C2"
echo "$hy2l2" >> jh.txt

asl=$(cat "$WD/boot.log" 2>/dev/null | grep -a trycloudflare.com | awk 'NR==2{print}' | awk -F// '{print $2}' | awk '{print $1}')
chk1=$(curl -o /dev/null -s -w "%{http_code}\n" "https://$asl")
agd=$(cat $WD/AD.log 2>/dev/null
chk2=$(curl --max-time 2 -o /dev/null -s -w "%{http_code}\n" "https://$agd")
if [[ "$chk1" == 404 ]] || [[ "$chk2" == 404 ]]; then
vmat1="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"$sb-vmess-ws-tls-argo-$USR-443\", \"add\": \"104.16.0.0\", \"port\": \"443\", \"id\": \"$U\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$ad\", \"path\": \"/$U-vm?ed=2048\", \"tls\": \"tls\", \"sni\": \"$ad\", \"alpn\": \"\", \"fp\": \"\"}" | base64 -w0)"
echo "$vmat1" >> jh.txt
vmat2="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"$sb-vmess-ws-tls-argo-$USR-2053\", \"add\": \"104.17.0.0\", \"port\": \"2053\", \"id\": \"$U\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$ad\", \"path\": \"/$U-vm?ed=2048\", \"tls\": \"tls\", \"sni\": \"$ad\", \"alpn\": \"\", \"fp\": \"\"}" | base64 -w0)"
echo "$vmat2" >> jh.txt
vmat3="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"$sb-vmess-ws-tls-argo-$USR-2083\", \"add\": \"104.18.0.0\", \"port\": \"2083\", \"id\": \"$U\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$ad\", \"path\": \"/$U-vm?ed=2048\", \"tls\": \"tls\", \"sni\": \"$ad\", \"alpn\": \"\", \"fp\": \"\"}" | base64 -w0)"
echo "$vmat3" >> jh.txt
vmat4="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"$sb-vmess-ws-tls-argo-$USR-2087\", \"add\": \"104.19.0.0\", \"port\": \"2087\", \"id\": \"$U\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$ad\", \"path\": \"/$U-vm?ed=2048\", \"tls\": \"tls\", \"sni\": \"$ad\", \"alpn\": \"\", \"fp\": \"\"}" | base64 -w0)"
echo "$vmat4" >> jh.txt
vmat5="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"$sb-vmess-ws-tls-argo-$USR-2096\", \"add\": \"104.20.0.0\", \"port\": \"2096\", \"id\": \"$U\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$ad\", \"path\": \"/$U-vm?ed=2048\", \"tls\": \"tls\", \"sni\": \"$ad\", \"alpn\": \"\", \"fp\": \"\"}" | base64 -w0)"
echo "$vmat5" >> jh.txt
vma6="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"$sb-vmess-ws-argo-$USR-80\", \"add\": \"104.21.0.0\", \"port\": \"80\", \"id\": \"$U\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$ad\", \"path\": \"/$U-vm?ed=2048\", \"tls\": \"\"}" | base64 -w0)"
echo "$vma6" >> jh.txt
vma7="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"$sb-vmess-ws-argo-$USR-8080\", \"add\": \"104.22.0.0\", \"port\": \"8080\", \"id\": \"$U\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$ad\", \"path\": \"/$U-vm?ed=2048\", \"tls\": \"\"}" | base64 -w0)"
echo "$vma7" >> jh.txt
vma8="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"$sb-vmess-ws-argo-$USR-2052\", \"add\": \"104.24.0.0\", \"port\": \"2052\", \"id\": \"$U\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$ad\", \"path\": \"/$U-vm?ed=2048\", \"tls\": \"\"}" | base64 -w0)"
echo "$vma8" >> jh.txt
vma9="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"$sb-vmess-ws-argo-$USR-2082\", \"add\": \"104.25.0.0\", \"port\": \"2082\", \"id\": \"$U\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$ad\", \"path\": \"/$U-vm?ed=2048\", \"tls\": \"\"}" | base64 -w0)"
echo "$vma9" >> jh.txt
vma10="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"$sb-vmess-ws-argo-$USR-2086\", \"add\": \"104.26.0.0\", \"port\": \"2086\", \"id\": \"$U\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$ad\", \"path\": \"/$U-vm?ed=2048\", \"tls\": \"\"}" | base64 -w0)"
echo "$vma10" >> jh.txt
vma11="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"$sb-vmess-ws-argo-$USR-2095\", \"add\": \"104.27.0.0\", \"port\": \"2095\", \"id\": \"$U\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$ad\", \"path\": \"/$U-vm?ed=2048\", \"tls\": \"\"}" | base64 -w0)"
echo "$vma11" >> jh.txt
fi
vs=$(cat jh.txt)
echo "$vs" > ${FP}/${U}_v2sub.txt
burl=$(base64 -w 0 < jh.txt)

cat > sing_box.json <<EOF
{
  "log": {
    "disabled": false,
    "level": "info",
    "timestamp": true
  },
  "experimental": {
    "clash_api": {
      "external_controller": "127.0.0.1:9090",
      "external_ui": "ui",
      "external_ui_download_url": "",
      "external_ui_download_detour": "",
      "secret": "",
      "default_mode": "Rule"
       },
      "cache_file": {
            "enabled": true,
            "path": "cache.db",
            "store_fakeip": true
        }
    },
    "dns": {
        "servers": [
            {
                "tag": "proxydns",
                "address": "tls://8.8.8.8/dns-query",
                "detour": "select"
            },
            {
                "tag": "localdns",
                "address": "h3://223.5.5.5/dns-query",
                "detour": "direct"
            },
            {
                "tag": "dns_fakeip",
                "address": "fakeip"
            }
        ],
        "rules": [
            {
                "outbound": "any",
                "server": "localdns",
                "disable_cache": true
            },
            {
                "clash_mode": "Global",
                "server": "proxydns"
            },
            {
                "clash_mode": "Direct",
                "server": "localdns"
            },
            {
                "rule_set": "geosite-cn",
                "server": "localdns"
            },
            {
                 "rule_set": "geosite-geolocation-!cn",
                 "server": "proxydns"
            },
             {
                "rule_set": "geosite-geolocation-!cn",         
                "query_type": [
                    "A",
                    "AAAA"
                ],
                "server": "dns_fakeip"
            }
          ],
           "fakeip": {
           "enabled": true,
           "inet4_range": "198.18.0.0/15",
           "inet6_range": "fc00::/18"
         },
          "independent_cache": true,
          "final": "proxydns"
        },
      "inbounds": [
    {
      "type": "tun",
           "tag": "tun-in",
	  "address": [
      "172.19.0.1/30",
	  "fd00::1/126"
      ],
      "auto_route": true,
      "strict_route": true,
      "sniff": true,
      "sniff_override_destination": true,
      "domain_strategy": "prefer_ipv4"
    }
  ],
  "outbounds": [
    {
      "tag": "select",
      "type": "selector",
      "default": "auto",
      "outbounds": [
        "auto",
        "vless-$sb-$USR",
        "vmess-$sb-$USR",
        "hy2-$sb-$USR",
"vmess-tls-argo-$sb-$USR",
"vmess-argo-$sb-$USR"
      ]
    },
    {
      "type": "vless",
      "tag": "vless-$sb-$USR",
      "server": "$IP",
      "server_port": $vp,
      "uuid": "$U",
      "packet_encoding": "xudp",
      "flow": "xtls-rprx-vision",
      "tls": {
        "enabled": true,
        "server_name": "$ry",
        "utls": {
          "enabled": true,
          "fingerprint": "chrome"
        },
      "reality": {
          "enabled": true,
          "public_key": "$pbk",
          "short_id": ""
        }
      }
    },
{
            "server": "$IP",
            "server_port": $mp,
            "tag": "vmess-$sb-$USR",
            "tls": {
                "enabled": false,
                "server_name": "www.bing.com",
                "insecure": false,
                "utls": {
                    "enabled": true,
                    "fingerprint": "chrome"
                }
            },
            "packet_encoding": "packetaddr",
            "transport": {
                "headers": {
                    "Host": [
                        "www.bing.com"
                    ]
                },
                "path": "/$U-vm",
                "type": "ws"
            },
            "type": "vmess",
            "security": "auto",
            "uuid": "$U"
        },

    {
        "type": "hysteria2",
        "tag": "hy2-$sb-$USR",
        "server": "$IP",
        "server_port": $hp,
        "password": "$U",
        "tls": {
            "enabled": true,
            "server_name": "www.bing.com",
            "insecure": true,
            "alpn": [
                "h3"
            ]
        }
    },
{
            "server": "www.visa.com.hk",
            "server_port": 8443,
            "tag": "vmess-tls-argo-$sb-$USR",
            "tls": {
                "enabled": true,
                "server_name": "$ad",
                "insecure": false,
                "utls": {
                    "enabled": true,
                    "fingerprint": "chrome"
                }
            },
            "packet_encoding": "packetaddr",
            "transport": {
                "headers": {
                    "Host": [
                        "$ad"
                    ]
                },
                "path": "/$U-vm",
                "type": "ws"
            },
            "type": "vmess",
            "security": "auto",
            "uuid": "$U"
        },
{
            "server": "www.visa.com.hk",
            "server_port": 8880,
            "tag": "vmess-argo-$sb-$USR",
            "tls": {
                "enabled": false,
                "server_name": "$ad",
                "insecure": false,
                "utls": {
                    "enabled": true,
                    "fingerprint": "chrome"
                }
            },
            "packet_encoding": "packetaddr",
            "transport": {
                "headers": {
                    "Host": [
                        "$ad"
                    ]
                },
                "path": "/$U-vm",
                "type": "ws"
            },
            "type": "vmess",
            "security": "auto",
            "uuid": "$U"
        },
    {
      "tag": "direct",
      "type": "direct"
    },
    {
      "tag": "auto",
      "type": "urltest",
      "outbounds": [
        "vless-$sb-$USR",
        "vmess-$sb-$USR",
        "hy2-$sb-$USR",
"vmess-tls-argo-$sb-$USR",
"vmess-argo-$sb-$USR"
      ],
      "url": "https://www.gstatic.com/generate_204",
      "interval": "1m",
      "tolerance": 50,
      "interrupt_exist_connections": false
    }
  ],
  "route": {
      "rule_set": [
            {
                "tag": "geosite-geolocation-!cn",
                "type": "remote",
                "format": "binary",
                "url": "https://cdn.jsdelivr.net/gh/MetaCubeX/meta-rules-dat@sing/geo/geosite/geolocation-!cn.srs",
                "download_detour": "select",
                "update_interval": "1d"
            },
            {
                "tag": "geosite-cn",
                "type": "remote",
                "format": "binary",
                "url": "https://cdn.jsdelivr.net/gh/MetaCubeX/meta-rules-dat@sing/geo/geosite/geolocation-cn.srs",
                "download_detour": "select",
                "update_interval": "1d"
            },
            {
                "tag": "geoip-cn",
                "type": "remote",
                "format": "binary",
                "url": "https://cdn.jsdelivr.net/gh/MetaCubeX/meta-rules-dat@sing/geo/geoip/cn.srs",
                "download_detour": "select",
                "update_interval": "1d"
            }
        ],
    "auto_detect_interface": true,
    "final": "select",
    "rules": [
      {
      "inbound": "tun-in",
      "action": "sniff"
      },
      {
      "protocol": "dns",
      "action": "hijack-dns"
      },
      {
      "port": 443,
      "network": "udp",
      "action": "reject"
      },
      {
        "clash_mode": "Direct",
        "outbound": "direct"
      },
      {
        "clash_mode": "Global",
        "outbound": "select"
      },
      {
        "rule_set": "geoip-cn",
        "outbound": "direct"
      },
      {
        "rule_set": "geosite-cn",
        "outbound": "direct"
      },
      {
      "ip_is_private": true,
      "outbound": "direct"
      },
      {
        "rule_set": "geosite-geolocation-!cn",
        "outbound": "select"
      }
    ]
  },
    "ntp": {
    "enabled": true,
    "server": "time.apple.com",
    "server_port": 123,
    "interval": "30m",
    "detour": "direct"
  }
}
EOF

cat > clash_meta.yaml <<EOF
port: 7890
allow-lan: true
mode: rule
log-level: info
unified-delay: true
global-client-fingerprint: chrome
dns:
  enable: true
  listen: :53
  ipv6: true
  enhanced-mode: fake-ip
  fake-ip-range: 198.18.0.1/16
  default-nameserver: 
    - 223.5.5.5
    - 8.8.8.8
  nameserver:
    - https://dns.alidns.com/dns-query
    - https://doh.pub/dns-query
  fallback:
    - https://1.0.0.1/dns-query
    - tls://dns.google
  fallback-filter:
    geoip: true
    geoip-code: CN
    ipcidr:
      - 240.0.0.0/4

proxies:
- name: vless-reality-vision-$sb-$USR               
  type
  server: $IP                           
  port: $vp                                
  uuid: $U   
  network: tcp
  udp: true
  tls: true
  flow: xtls-rprx-vision
  servername: $ry                 
  reality-opts: 
    public-key: $pbk                      
  client-fingerprint: chrome                  

- name: vmess-ws-$sb-$USR                         
  type: vmess
  server: $IP                       
  port: $mp                                     
  uuid: $U       
  alterId: 0
  cipher: auto
  udp: true
  tls: false
  network: ws
  servername: www.bing.com                    
  ws-opts:
    path: "/$U-vm"                             
    headers:
      Host: www.bing.com                     

- name: hysteria2-$sb-$USR                            
  type: hysteria2                                      
  server: $IP                               
  port: $hp                                
  password: $U                          
  alpn:
    - h3
  sni: www.bing.com                               
  skip-cert-verify: true
  fast-open: true

- name: vmess-tls-argo-$sb-$USR                         
  type: vmess
  server: www.visa.com.hk                        
  port: 8443                                     
  uuid: $U       
  alterId: 0
  cipher: auto
  udp: true
  tls: true
  network: ws
  servername: $ad                    
  ws-opts:
    path: "/$U-vm"                             
    headers:
      Host: $ad

- name: vmess-argo-$sb-$USR                         
  type: vmess
  server: www.visa.com.hk                        
  port: 8880                                     
  uuid: $U       
  alterId: 0
  cipher: auto
  udp: true
  tls: false
  network: ws
  servername: $ad                   
  ws-opts:
    path: "/$U-vm"                             
    headers:
      Host: $ad 

proxy-groups:
- name: Balance
  type: load-balance
  url: https://www.gstatic.com/generate_204
  interval: 300
  strategy: round-robin
  proxies:
    - vless-reality-vision-$sb-$USR                              
    - vmess-ws-$sb-$USR
    - hysteria2-$sb-$USR
    - vmess-tls-argo-$sb-$USR
    - vmess-argo-$sb-$USR

- name: Auto
  type: url-test
  url: https://www.gstatic.com/generate_204
  interval: 300
  tolerance: 50
  proxies:
    - vless-reality-vision-$sb-$USR                             
    - vmess-ws-$sb-$USR
    - hysteria2-$sb-$USR
    - vmess-tls-argo-$sb-$USR
    - vmess-argo-$sb-$USR
    
- name: Select
  type: select
  proxies:
    - Balance                                         
    - Auto
    - DIRECT
    - vless-reality-vision-$sb-$USR                              
    - vmess-ws-$sb-$USR
    - hysteria2-$sb-$USR
    - vmess-tls-argo-$sb-$USR
    - vmess-argo-$sb-$USR
rules:
  - GEOIP,LAN,DIRECT
  - GEOIP,CN,DIRECT
  - MATCH,Select
  
EOF

cat clash_meta.yaml > ${FP}/${U}_clashmeta.txt
cat sing_box.json > ${FP}/${U}_singbox.txt
curl -sL https://raw.githubusercontent.com/antclt/sing-box-yg/main/index.html -o "$FP"/index.html
V2N="https://${USR}.serv00.net/${U}_v2sub.txt"
CM="https://${USR}.serv00.net/${U}_clashmeta.txt"
SB="https://${USR}.serv00.net/${U}_singbox.txt"
hy=$(jq -r '.inbounds[0].listen_port' config.json)
vl=$(jq -r '.inbounds[3].listen_port' config.json)
vm=$(jq -r '.inbounds[4].listen_port' config.json)
su=$(jq -r '.inbounds[0].users[0].password' config.json)
cat > list.txt <<EOF
=================================================================================================

Current IP in use: $IP
If default IP blocked, use other IPs:
$a
$b
$c

Current ports in use:
vless-reality port: $vl
Vmess-ws port (for Argo domain): $vm
Hysteria2 port: $hy

UUID: $su

Argo Domain: ${ad}

-------------------------------------------------------------------------------------------------

1. Vless-reality share link:
$vll

Note: If reality domain was CF domain, activates:
Can be used with https://github.com/antclt/Cloudflare_vless_trojan project
1. Proxyip info (with port):
Method 1 (global): Set var: proxyip = $IP:$vl  
Method 2 (single node): Change path to: /pyip=$IP:$vl
CF node TLS can be on/off
CF node location: $IP region

2. Non-standard port proxy IP:
Client preferred IP: $IP, port: $vl
CF node TLS must be on
CF node location: $IP region

Note: If serv00 IP blocked, proxyip still works but non-standard port proxy won't
-------------------------------------------------------------------------------------------------

2. Vmess-ws three forms:

1. Main Vmess-ws node:
(No CDN by default, for CDN: client can modify IP/domain, 7x80 ports interchangeable!)
$vmwl

2. Vmess-ws-tls_Argo node: 
(CDN optimized, client can modify IP/domain, 6x443 ports interchangeable!)
$vmat

3. Vmess-ws_Argo node:
(CDN optimized, client can modify IP/domain, 7x80 ports interchangeable!)
$vma
-------------------------------------------------------------------------------------------------

3. HY2 share link:
$hy2l
-------------------------------------------------------------------------------------------------

4. Combined subscription (22 nodes total):
3 IP coverage: 3xreality, 3xvmess+ws, 3xhy2
13 argo nodes (with CF unkillable IPs): 7x80 no-tls, 6x443 with-tls

Subscription link:
$V2N

Copy base64:
$burl
-------------------------------------------------------------------------------------------------

5. For Sing-box & Clash-meta configs, choose option 4 in menu

Clash-meta sub:
$CM

Sing-box sub:
$SB
-------------------------------------------------------------------------------------------------

Multi-function homepage: http://${sb}.${USR}.serv00.net

=================================================================================================

EOF
cat list.txt
sleep 2
rm -rf sb.log core tunnel.yml tunnel.json fake_useragent_0.2.0.json
cd
