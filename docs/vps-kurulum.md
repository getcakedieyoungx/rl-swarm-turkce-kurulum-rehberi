# VPS Sunucuya RL-Swarm Kurulumu

## Sunucu Seçimi

### Önerilen Sunucular

**Budget-Friendly:**
- [Hetzner](https://www.hetzner.com/) - Uygun fiyat, iyi performans
- [DigitalOcean](https://www.digitalocean.com/) - Yapılandırması kolay
- [Linode](https://www.linode.com/) - Türkiye'den iyi latency

**Yüksek Performans:**
- [AWS EC2](https://aws.amazon.com/ec2/)
- [Google Cloud](https://cloud.google.com/)
- [Azure](https://azure.microsoft.com/)

### Minimum Yapılandırma

**CPU-Only:**
- CPU: 16+ çekirdek
- RAM: 64GB
- Disk: 100GB SSD
- Bant genişliği: Unlimited

**GPU (Önerilen):**
- GPU: NVIDIA RTX 3090/4090
- CPU: 8+ çekirdek
- RAM: 32GB+
- Disk: 100GB+ SSD

## Adım 1: Sunucuya Bağlanma

### SSH Anahtarı Oluşturma (Yerel Makinenizde)

**Windows (PowerShell):**
```powershell
ssh-keygen -t rsa -b 4096 -f $env:USERPROFILE\.ssh\id_rsa
```

**Linux/Mac:**
```bash
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa
```

### Sunucuya Anahtarı Yükleme

```bash
# Sunucuda
mkdir -p ~/.ssh
paste-your-public-key >> ~/.ssh/authorized_keys
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
```

### SSH Bağlantısı

```bash
# Linux/Mac
ssh -i ~/.ssh/id_rsa root@sunucu_ip

# Windows PowerShell
ssh -i $env:USERPROFILE\.ssh\id_rsa root@sunucu_ip
```

## Adım 2: Sunucu Hazırlanması

### İlk Erişim Konfigürasyonu

```bash
# SSH portu değiştir (güvenlik)
sudo nano /etc/ssh/sshd_config
# Port 22 satırını bulun ve 2222 gibi yeni port ayarlayın
sudo systemctl restart sshd
```

### Firewall Yapılandırması

```bash
# Ubuntu
sudo ufw enable
sudo ufw allow 2222/tcp  # SSH (yeni port)
sudo ufw allow 3000/tcp  # RL-Swarm web arayüzü
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
```

## Adım 3: Otomatik Kurulum

### Script ile Kurulum

```bash
# Repository'yi klonlayın
git clone https://github.com/getcakedieyoungx/rl-swarm-turkce-kurulum-rehberi.git
cd rl-swarm-turkce-kurulum-rehberi

# Script'i çalıştırın
chmod +x scripts/install-ubuntu.sh
./scripts/install-ubuntu.sh
```

### Manuel Kurulum

Bkz. Ana README'nin "1. Bağımlılıkları Yükleme" bölümü

## Adım 4: RL-Swarm Başlatma

### Screen Kullanarak Arka Planda Çalıştırma

```bash
# Screen oturumu oluştur
screen -S rl-swarm

# RL-Swarm dizinine git
cd rl-swarm

# Sanal ortamı etkinleştir
source .venv/bin/activate

# Çalıştır
./run_rl_swarm.sh

# Screen'den ayrıl: Ctrl+A, D
```

### Web Arayüzüne Erişim

**Yerel Bağlantı (Sunucuda):**
```bash
curl http://localhost:3000
```

**Uzaktan Bağlantı (SSH Tunnel):**

```bash
# Yerel makinenizde
ssh -i ~/.ssh/id_rsa -L 3000:localhost:3000 root@sunucu_ip

# Ardından tarayıcıda
http://localhost:3000
```

**LocalTunnel (Herkese Açık):**

```bash
# Sunucuda
npm install -g localtunnel
lt --port 3000

# Çıkan URL'yi tarayıcıda açın
```

## Adım 5: Yönetim

### Screen Komutları

```bash
# Oturumlı listele
screen -ls

# Oturuma geri dön
screen -r rl-swarm

# Oturumu sonlandır
screen -XS rl-swarm quit
```

### Dosya Yönetimi (SCP)

```bash
# Sunucudan indirme
scp -r root@sunucu_ip:~/rl-swarm/logs ./

# Sunucuya yükleme
scp -r ./file root@sunucu_ip:~/rl-swarm/
```

### SFTP Dosya Yönetimi

```bash
# Bağlan
sftp -P 2222 root@sunucu_ip

# İndir
get swarm.pem

# Yükle
put swarm.pem

# Çık
exit
```

## Adım 6: Monitoring

### Sistem Kaynakları

```bash
# CPU ve RAM kullanımı
top

# GPU kullanımı
watch -n 1 nvidia-smi

# Disk kullanımı
df -h
du -sh ~/rl-swarm

# Network
netstat -tuln | grep LISTEN
```

### Process Monitoring

```bash
# Python process'leri
ps aux | grep python

# Network bağlantıları
netstat -an | grep 3000
lsof -i :3000
```

## Sorunlar ve Çözümler

### "Connection refused" SSH hatası

**Çözüm:**
```bash
# Sunucu tarafında SSH servisini kontrol et
sudo systemctl status ssh
sudo systemctl restart ssh

# Firewall kuralları
sudo ufw status
```

### Disk Alanı Doldu

**Çözüm:**
```bash
# Büyük dosyaları bul
du -sh /* | sort -rh | head -10

# Log dosyalarını temizle
rm -rf ~/rl-swarm/logs/*
df -h  # Kontrol et
```

### GPU Algılanmıyor

**Çözüm:**
```bash
# Driver kontrol
nvidia-smi

# CUDA Kontrol
nvcc --version

# Tekrar Kurun
sudo apt purge nvidia-*
sudo apt autoremove
# Driver yeniden yükleme linkini sunucu sağlayıcıdan al
```

## Backup ve Güvenlik

### Otomatik Backup

```bash
# Cron job oluştur
crontab -e

# Günlük backup (UTC 02:00)
0 2 * * * tar -czf ~/backup/rl-swarm-$(date +%Y%m%d).tar.gz ~/rl-swarm/swarm.pem
```

### Dosya Şifrelemesi

```bash
# swarm.pem'i şifrele
openssl enc -aes-256-cbc -in ~/rl-swarm/swarm.pem -out ~/swarm.pem.enc

# İhtiyaç duyulduğunda çöz
openssl enc -aes-256-cbc -d -in ~/swarm.pem.enc -out ~/swarm.pem
```

## Kaynaklar

- [Ubuntu Server Guide](https://ubuntu.com/server/docs)
- [SSH Best Practices](https://wiki.debian.org/SSH)
- [UFW Firewall](https://wiki.ubuntu.com/UncomplicatedFirewall)
- [Screen Kullanımı](https://www.gnu.org/software/screen/manual/)

---

**Sorun mu yaşıyorsunuz?** [Ana Sorun Giderme Rehberine](SORUN-GIDERME.md) bakın.
