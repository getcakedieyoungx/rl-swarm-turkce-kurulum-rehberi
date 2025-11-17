# Sorun Giderme Rehberi

RL-Swarm kurulumu sırasında karşılaşabileceğiniz yaygın sorunlar ve çözümleri.

---

## Python Versiyonu Hatası

**Hata:** `Python 3.10 veya daha yeni gerekli`

**Çözüm:**
```bash
python3 --version  # Hangi versiyonu var bak

# Ubuntu 20.04'te Python 3.10 yükle
sudo apt update
sudo apt install -y python3.10 python3.10-venv

# Varsayılan yap
sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.10 1
```

---

## Sanal Ortam Bulunamıyor

**Hata:** `ModuleNotFoundError: No module named 'hivemind'`

**Sebep:** Sanal ortam aktif değil

**Çözüm:**
```bash
cd rl-swarm
source .venv/bin/activate  # Linux/Mac

# Windows PowerShell:
.venv\Scripts\Activate.ps1
```

---

## GPU Belleği Yetersiz

**Hata:** `CUDA out of memory` veya `RuntimeError: CUDA out of memory`

**Seçenek 1: Küçük model seç**
```bash
# Kurulum sırasında model sorulduğunda:
# Gensyn/Qwen2.5-0.5B-Instruct
```

**Seçenek 2: Bellek ayarlarını optimize et**
```bash
cd rl-swarm
nano rgym_exp/config/rg-swarm.yaml

# Şu değerleri azalt:
num_train_samples: 1      # varsayılan daha yüksek
num_transplant_trees: 1   # varsayılan daha yüksek
beam_size: 20             # varsayılan daha yüksek
```

**Seçenek 3: Çevre değişkenleri ayarla**
```bash
export PYTORCH_CUDA_ALLOC_CONF="expandable_segments:True,max_split_size_mb:128"
./run_rl_swarm.sh
```

---

## Localhost:3000 Açılmıyor

**Yerel makinede:**
```bash
# Tarayıcıda dene
http://localhost:3000/

# Port dinlenip dinlenmediğini kontrol et
sudo lsof -i :3000

# 3 dakika bekle, sayfa yüklenebilir
```

**VPS/Cloud'da SSH Tunnel ile:**
```bash
# Yerel makinende bu komutu çalıştır
ssh -L 3000:localhost:3000 user@server_ip

# Sonra tarayıcıda
http://localhost:3000/
```

**Herkese açık (LocalTunnel):**
```bash
# Sunucuda
npm install -g localtunnel
lt --port 3000

# Çıkan URL'yi tarayıcıda aç
```

---

## Daemon Başlamıyor

**Hata:** `Daemon failed to start in 15.0 seconds`

**Sebep:** Timeout süresi yeterli değil

**Çözüm:**
```bash
cd rl-swarm
python3 -m venv .venv
source .venv/bin/activate

# Daemon config dosyasını aç
DAEMON_FILE=$(python3 -c "import hivemind.p2p.p2p_daemon as m; print(m.__file__)")
nano "$DAEMON_FILE"

# Şu satırı bul:
# startup_timeout: float = 15
# Bunu yap:
# startup_timeout: float = 120

# Kaydet: Ctrl+X, Y, Enter
```

---

## swarm.pem Dosyası Kayıp

**Sorun:** Node kimlik dosyası silindi veya kaybetti

**Çözüm 1: Yeni oluştur**
```bash
cd rl-swarm
./run_rl_swarm.sh
# Aynı email ile giriş yap, yeni swarm.pem oluşturulacak
```

**Çözüm 2: Yedekten geri yükle**
```bash
cd rl-swarm
cp ~/Desktop/swarm.pem.backup ./swarm.pem
chmod 600 swarm.pem
./run_rl_swarm.sh
```

---

## Eğitim Çok Yavaş veya Durmuş Görünüyor

**GPU kullanılıyor mu?**
```bash
watch -n 1 nvidia-smi
```
GPU kullanım yüzdesini gör, sıfırsa GPU paralı işler yok.

**CPU ne kadar kullanılıyor?**
```bash
top
```
Python process'lerin CPU kullanımını kontrol et.

**Disk dolu mu?**
```bash
df -h
du -sh ~/rl-swarm
```

**Logları kontrol et:**
```bash
tail -100 logs/swarm.log

# Hata ara
grep -i error logs/swarm.log

# CUDA problemleri
grep -i cuda logs/swarm.log
```

**Eğer gerçekten takılmış gibiyse:**
- Başka ağır program çalışıyor mu? Kapat
- RAM yeterli mi? `free -h` ile kontrol et
- Küçük model dene: `Gensyn/Qwen2.5-0.5B-Instruct`

---

## MacBook'ta Bellek Sorunu

**Hata:** `RuntimeError` veya eğitim çöküyor

**Çözüm:**
```bash
export PYTORCH_MPS_HIGH_WATERMARK_RATIO=0.0
./run_rl_swarm.sh
```

---

## Windows WSL'de Sorunlar

**"Dosya bulunamadı" hatası**
```bash
# WSL içinde Windows dosyaları /mnt/ altında
# C: sürücüsü = /mnt/c/
cd /mnt/c/Users/YourName/Desktop
```

**WSL'de disk alanı biterse:**
```bash
# Nerede disk alanı harcandığını bulun
du -sh ~/*

# Eski logları sil
rm -rf logs/*

# Temizlik
df -h
```

---

## Git Pull Sonrası Sorunlar

**Hata:** Güncelleme sonra komutlar çalışmıyor

**Çözüm:**
```bash
cd rl-swarm

# Yerel değişiklikleri sıfırla
git reset --hard
git clean -fd
git pull

# Sanal ortamı temizle
rm -rf .venv
python3 -m venv .venv
source .venv/bin/activate

# Tekrar başlat
./run_rl_swarm.sh
```

---

## HuggingFace Upload Hatası

**Sorun:** Model yüklenemiyor

**Kontrol listesi:**
```bash
# 1. Token geçerli mi?
huggingface-cli login

# 2. Yeterli disk alanı var mı?
df -h

# 3. İnternet bağlantısı stabil mi?
ping huggingface.co

# 4. Token'ı yenile
huggingface-cli logout
huggingface-cli login
```

---

## SSH Bağlantı Kopuyor

**Sorun:** VPS'de çalışan RL-Swarm SSH kesintisinden sonra çöküyor

**Çözüm: Screen kullan**
```bash
screen -S rl-swarm
cd rl-swarm
source .venv/bin/activate
./run_rl_swarm.sh

# Ayrıl: Ctrl+A, D
# Geri dön: screen -r rl-swarm

# Veya tmux
tmux new -s rl-swarm
cd rl-swarm
source .venv/bin/activate
./run_rl_swarm.sh

# Ayrıl: Ctrl+B, D
# Geri dön: tmux attach -t rl-swarm
```

---

## Permission Denied

**Hata:** `Permission denied` script çalıştırırken

**Çözüm:**
```bash
chmod +x run_rl_swarm.sh
chmod +x scripts/install-ubuntu.sh
./run_rl_swarm.sh
```

---

## NVIDIA GPU Bulunamıyor

**Kontrol:**
```bash
nvidia-smi
```

Çalışmazsa:
```bash
# Windows WSL'de
nvidia-smi --query-gpu=name --format=csv

# Linux'ta driver versiyonu
nvcc --version
cat /proc/version  # Kernel versiyonu kontrol et
```

**Çözüm:**
- Windows'ta: NVIDIA Driver yeniden yükle ve bilgisayarı yeniden başlat
- Linux'ta: `sudo apt install nvidia-driver-525` (veya yeni sürüm)

---

## Logları İnceleme

**Tüm loglar `logs/` klasöründe:**
```bash
cd rl-swarm/logs

# Ana uygulama
tail -f swarm.log

# Web arayüzü
tail -f yarn.log

# Eğitim logları
ls wandb/

# Son 50 hata satırı
grep ERROR swarm.log | tail -50
```

---

## Sistem Bilgisi Toplama

Hata raporlarken bu bilgileri paylaşın:

```bash
# OS bilgisi
uname -a

# Python
python3 --version

# GPU
nvidia-smi

# RAM/Disk
free -h
df -h

# RL-Swarm versiyon
cd rl-swarm
git log --oneline -1

# Paketler
source .venv/bin/activate
pip list | grep -E "torch|cuda|hivemind"
```

---

## Yardım Edin

Sorun çözülemedi?

1. [GitHub Issues](https://github.com/gensyn-ai/rl-swarm/issues) - Resmi RL-Swarm
2. [Bu Repo Issues](https://github.com/getcakedieyoungx/rl-swarm-turkce-kurulum-rehberi/issues) - Türkçe rehber
3. [Discord](https://discord.gg/AdnyWNzXh5) - Gensyn Discord
4. [Resmi Docs](https://docs.gensyn.ai/testnet/rl-swarm) - İngilizce belge

---

**Son güncelleme:** Kasım 2025
