# VPS Sunucuya RL-Swarm Kurulumu

Kendi sunucunuzda RL-Swarm çalıştırmak istiyorsanız, bu rehber adım adım anlatır.

---

## Sunucu Seçimi

### Uygun Sağlayıcılar

- **Hetzner** - İyi fiyat, güvenilir
- **DigitalOcean** - Kolay kullanım
- **Linode** - Türkiye'ye yakın
- **AWS/Google Cloud** - Daha pahalı ama esnek

### Minimum Özellikler

**CPU-only:**
- 16+ core
- 64GB RAM
- 100GB SSD

**GPU:**
- NVIDIA RTX 3090/4090
- 8+ core CPU
- 32GB+ RAM
- 100GB+ SSD

---

## SSH Bağlantısı

### Yerel Makinede SSH Anahtarı Oluştur

```bash
ssh-keygen -t rsa -b 4096
# Sorularına enter diye cevap ver
```

Anahtarlar `~/.ssh/` dizininde saklanır:
- `id_rsa` → Özel anahtar (gizle!)
- `id_rsa.pub` → Genel anahtar (sunucuya koy)

### Sunucuya Bağlan

```bash
# İlk kez: şifre ile
ssh root@sunucu_ip

# Sonra: anahtar ile (otomatik)
# ~/.ssh/config dosyası oluşturup:
Host myserver
    HostName sunucu_ip
    User root
    IdentityFile ~/.ssh/id_rsa

# Sonra sadece yazıp enter
ssh myserver
```

---

## İlk Kurulum

### Sunucuya Giriş

```bash
ssh root@sunucu_ip
```

### Sistem Hazırlama

```bash
# Güncelle
sudo apt update && sudo apt upgrade -y

# Firewall
sudo ufw enable
sudo ufw allow 22/tcp   # SSH
sudo ufw allow 3000/tcp # Web arayüzü
```

### RL-Swarm Kurulması

Yukarıdaki "Manuel Kurulum" adımlarını izle. Veya otomatik script:

```bash
wget https://raw.githubusercontent.com/.../install-ubuntu.sh
chmod +x install-ubuntu.sh
./install-ubuntu.sh
```

---

## Çalıştırma

### Screen ile Arka Planda

SSH bağlantısı kapansak dahi RL-Swarm çalışmaya devam eder.

```bash
screen -S rl-swarm

cd ~/rl-swarm
source .venv/bin/activate
./run_rl_swarm.sh

# Çık: Ctrl+A, D
# Geri dön: screen -r rl-swarm
# Sonlandır: screen -XS rl-swarm quit
```

### Web Arayüzüne Erişim

**SSH Tunnel (güvenli):**
```bash
# Yerel makinede
ssh -L 3000:localhost:3000 root@sunucu_ip

# Tarayıcıda
http://localhost:3000/
```

**LocalTunnel (herkes görebilir):**
```bash
# Sunucuda
npm install -g localtunnel
lt --port 3000

# Çıkan URL'yi tarayıcıda aç
```

---

## Monitoring

### Sistem Kaynakları

```bash
# CPU, RAM, Processes
top

# GPU (varsa)
watch -n 1 nvidia-smi

# Disk
df -h
du -sh ~/rl-swarm
```

### RL-Swarm Logları

```bash
cd ~/rl-swarm

# Son 100 satır
tail -100 logs/swarm.log

# Canlı
tail -f logs/swarm.log

# Hata ara
grep ERROR logs/swarm.log
```

---

## Yedekleme

### swarm.pem Yedeği

```bash
# Sunucudan indir
scp root@sunucu_ip:~/rl-swarm/swarm.pem ~/Desktop/

# Veya şifrele ve sakla
openssl enc -aes-256-cbc -in ~/rl-swarm/swarm.pem -out ~/swarm.pem.enc
```

### Otomatik Cron Job

```bash
crontab -e

# Günlük backup saat 02:00'de
0 2 * * * tar -czf ~/backup/rl-swarm-$(date +\%Y\%m\%d).tar.gz ~/rl-swarm/swarm.pem
```

---

## Sorunlar

### SSH Bağlantı Reddedildi

```bash
# Sunucuda
sudo systemctl status ssh
sudo systemctl restart ssh

# Firewall kontrol
sudo ufw status
sudo ufw allow 22/tcp
```

### Disk Dolu

```bash
# Nerede harcandığını bul
du -sh /* | sort -rh

# Log temizle
rm -rf ~/rl-swarm/logs/*
```

### GPU Bulunamıyor

```bash
nvidia-smi  # Tespit et
cat /proc/version  # Kernel kontrol
```

---

## SFTP ile Dosya Yönetimi

```bash
# Bağlan
sftp root@sunucu_ip

# İndir
get swarm.pem

# Yükle
put swarm.pem

# Çık
exit
```

---

Sorunlar? [Sorun Giderme Rehberi](SORUN-GIDERME.md)'ne bak.
