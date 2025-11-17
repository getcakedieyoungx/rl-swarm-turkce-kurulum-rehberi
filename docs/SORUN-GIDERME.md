# RL-Swarm Sorun Giderme Rehberi

## Sık Sorulan Sorunlar ve Çözümleri

### 1. "Python 3.10 veya üstü gereklidir" Hatası

**Sorun:** Eski Python sürümü yüklü

**Çözüm:**
```bash
python3 --version  # Sürümü kontrol et

# Ubuntu 20.04'te Python 3.10 yükleme
sudo apt update
sudo apt install -y python3.10 python3.10-venv python3.10-dev

# Varsayılan Python'u değiştir
sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.10 1
```

---

### 2. "Module 'hivemind' Not Found" Hatası

**Sorun:** Sanal ortam etkinleştirilmemiş

**Çözüm:**
```bash
cd rl-swarm
source .venv/bin/activate  # Linux/Mac
# veya
.venv\Scripts\Activate.ps1  # Windows PowerShell
```

---

### 3. CUDA Bellek Yetersiz (Out of Memory)

**Sorun:** GPU belleği doldu

**Çözüm - Seçenek 1: Küçük model kullanın**
```bash
# Kurulum sırasında şu modeli seçin:
Gensyn/Qwen2.5-0.5B-Instruct
```

**Çözüm - Seçenek 2: Optimizasyon**
```bash
# Konfigürasyon dosyasını düzenle
cd rl-swarm
nano rgym_exp/config/rg-swarm.yaml

# Şu değerleri azalt:
num_train_samples: 1
num_transplant_trees: 1
beam_size: 20
```

**Çözüm - Seçenek 3: Çevre değişkenleri**
```bash
export PYTORCH_CUDA_ALLOC_CONF="expandable_segments:True,max_split_size_mb:128"
./run_rl_swarm.sh
```

---

### 4. "Localhost:3000 Sayfası Açılmıyor"

**Sorun:** Web arayüzü yüklenmediği

**Çözüm - Yerel Makine:**
```bash
# Tarayıcı konsolunda kontrol et
http://localhost:3000/

# Port dinlenip dinlenmediği kontrol et
sudo lsof -i :3000
```

**Çözüm - VPS/Bulut:**
```bash
# Terminal 1: SSH Tunnel
ssh -L 3000:localhost:3000 user@server-ip

# Terminal 2: LocalTunnel (opsiyonel)
npm install -g localtunnel
lt --port 3000
```

---

### 5. "Daemon Failed to Start in 15.0 Seconds" Hatası

**Sorun:** Daemon başlama zaman aşımı

**Çözüm:**
```bash
cd rl-swarm
python3 -m venv .venv
source .venv/bin/activate

# Timeout değerini artır
DEMON_CONFIG=$(python3 -c "import hivemind.p2p.p2p_daemon as m; print(m.__file__)")
nano "$DEMON_CONFIG"

# Satırı bul ve değiştir:
# startup_timeout: float = 15  →  startup_timeout: float = 120
```

---

### 6. "swarm.pem" Dosyası Kayıp

**Sorun:** Kimlik dosyası kaybetti

**Çözüm:**
```bash
cd rl-swarm
rm swarm.pem  # Eski dosyayı sil (varsa)

# Yeniden çalıştır - yeni dosya oluşturulacak
./run_rl_swarm.sh
```

**NOT:** Eğer eski swarm.pem'i yedeklemiş iseniz:
```bash
cp ~/backup/swarm.pem ./swarm.pem
chmod 600 swarm.pem
```

---

### 7. Eğitim Yavaş veya Durmuş Görünüyor

**Sorun:** Process yavaş çalışıyor

**Kontrol Listesi:**
```bash
# 1. GPU kullanılıyor mu?
gpu watch -n 1 nvidia-smi

# 2. CPU kullanımı?
top

# 3. Disks dolmadı mı?
df -h

# 4. Logları kontrol et
tail -f logs/swarm.log
```

**Çözüm:**
- Diğer programları kapatın
- Küçük model seçin
- RAM/VRAM kontrol edin

---

### 8. "Permission Denied" Hatası

**Sorun:** Script dosyası çalıştırılamıyor

**Çözüm:**
```bash
# İzinleri ver
chmod +x run_rl_swarm.sh
chmod +x scripts/install-ubuntu.sh

# Tekrar çalıştır
./run_rl_swarm.sh
```

---

### 9. "Git Pull" Sonrası Hatalar

**Sorun:** Güncelleme sonrası sorunlar

**Çözüm:**
```bash
cd rl-swarm

# Temiz kurulum
git reset --hard
git clean -fd
git pull

# Sanal ortamı yenile
rm -rf .venv
python3 -m venv .venv
source .venv/bin/activate
```

---

### 10. Model Upload Hatası (HuggingFace)

**Sorun:** Model yükleme başarısız

**Çözüm:**
```bash
# Token'ı kontrol et
huggingface-cli login

# Yeterli alan var mı kontrol et
df -h
du -sh .

# Token'ı yenile
huggingface-cli logout
huggingface-cli login
```

---

## Log Dosyalarını İnceleme

**Ana Log Dosyaları:**
```bash
cd rl-swarm

# Ana uygulama log'ları
tail -f logs/swarm.log

# Web arayüzü log'ları
tail -f logs/yarn.log

# Eğitim hataları
grep -i error logs/swarm.log

# CUDA hataları
grep -i cuda logs/swarm.log

# Tüm uyarıları göster
grep -i warning logs/swarm.log
```

---

## Sistem Bilgisi Toplama

Hata raporlarken bu bilgileri toplayın:

```bash
# İşletim Sistemi
uname -a

# Python Sürümü
python3 --version

# Sanal Ortam Paketleri
source .venv/bin/activate
pip list

# GPU Bilgisi (varsa)
nvidia-smi

# RAM/Disk
free -h
df -h

# Network
netstat -tuln | grep 3000

# Git Bilgisi
git log --oneline -5
git status
```

---

## Destek Al

**Sorun Bulunamadı?**

1. **GitHub Issues:** https://github.com/gensyn-ai/rl-swarm/issues
2. **Discord:** https://discord.gg/AdnyWNzXh5
3. **Resmi Dokümantasyon:** https://docs.gensyn.ai/testnet/rl-swarm
4. **Email:** support@gensyn.ai

---

**En Son Güncelleme:** Kasım 2025
