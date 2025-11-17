# RL-Swarm Türkçe Kurulum Rehberi

Gensyn AI tarafından geliştirilen **RL-Swarm**, internet üzerinde dağıtılmış şekilde Reinforcement Learning (Takviyeli Öğrenme) eğitim sürüsü oluşturmak için açık kaynaklı bir çerçevedir.

Bu rehber, RL-Swarm düğümünü kurmanız, yapılandırmanız ve bunu test ağına bağlamanız için adım adım talimatlar sağlar.

---

## 📋 İçerik Tablosu

### 🚀 Hızlı Başlangıç
- **[Ortam Kurulumu](#ortam-kurulumu)** - Windows, Bulut GPU, VPS seçenekleri
- **[Bağımlılıkları Yükleme](#1-bağımlılıkları-yükleme)** - Gerekli paketler
- **[HuggingFace Kurulumu](#2-huggingface-erişim-tokenı-alma)** - API anahtarı oluşturma
- **[Repository Klonlama](#3-repository-klonlama)** - Kod indirme

### 🏃 Düğümü Çalıştırma
- **[Sürüyü Başlatma](#4-sürüyü-çalıştırma)** - CLI ve Docker yöntemleri
- **[Giriş Yapma](#5-giriş-yapma)** - Web arayüzü kurulumu
- **[Tahmin Pazarına Katılma](#ai-tahmin-pazarına-katılma)** - Judge katılımı

### 🔧 İleri Kurulum
- **[Birden Fazla Düğüm](#birden-fazla-düğüm-çalıştırma)** - Çoklu örnek
- **[Yedekleme ve Kurtarma](#yedekleme)** - Dosya koruması
- **[Düğüm Sağlığı](#düğüm-sağlığı)** - Performans izleme

### 🛠️ Bakım
- **[Düğümü Güncelleme](#düğümü-güncelleme)** - En son sürüme geçme
- **[Sorun Giderme](#sorun-giderme)** - Yaygın sorunlar ve çözümler

---

## 🖥️ Donanım Gereksinimleri

### Desteklenen Donanım

#### CPU-Yalnız Seçeneği:
- **Minimum RAM:** 32GB
- **CPU:** ARM64 veya x86 mimarisi
- ⚠️ **Not:** Eğitim sırasında başka uygulamalar çalışıyorsa sistem çökebilir

#### GPU Seçeneği (Önerilen):
- **Desteklenen GPU'lar:**
  - NVIDIA RTX 3090 / 4090 / 5090
  - NVIDIA A100 / H100
  - **VRAM:** En az 24GB (12GB+ başlangıç için uygun)
  - **CUDA Driver:** 12.4 ve üstü
  - **Python:** 3.10 - 3.13

#### Model Seçenekleri:
Donanımınıza göre aşağıdaki modeller kullanılabilir:
- `Gensyn/Qwen2.5-0.5B-Instruct` (düşük donanım)
- `Qwen/Qwen3-0.6B` (orta donanım)
- `nvidia/AceInstruct-1.5B` (orta-yüksek donanım)
- `dnotitia/Smoothie-Qwen3-1.7B` (yüksek donanım)
- `Gensyn/Qwen2.5-1.5B-Instruct` (yüksek donanım)

---

## 🌍 Ortam Kurulumu

### Yöntem 1: Windows Kullanıcıları (Kendi Bilgisayarınız)

Windows kullanıyorsanız, **Ubuntu for Windows (WSL)** kurmanız gerekir:

1. **[Windows'ta Linux Kurulum Rehberi](docs/windows-wsl-kurulum.md)** adımları izleyin
2. Ubuntu kurulduktan sonra NVIDIA kontrollerini doğrulayın:

```bash
# NVIDIA Toolkit Kurulu mu?
nvidia-smi

# CUDA Sürümü
nvcc --version
```

---

### Yöntem 2: Bulut GPU Kiralama

#### **Option A: Vast.ai (RTX 3090/4090)**

1. [Vast.ai](https://cloud.vast.ai/?ref_id=228875) kaydı yapın
2. SSH anahtarı oluşturun (Yerel makinenizde):
   ```bash
   ssh-keygen -t rsa -b 4096
   ```
3. Vast.ai panelinde SSH anahtarını ekleyin: `Ayarlar > Anahtarlar > SSH Anahtarları`
4. PyTorch şablonu seçerek GPU kiralayın
5. En az 50GB disk alanı tahsis edin
6. SSH komutunu kopyalayın ve `-L 3000:localhost:3000` ekleyin:
   ```bash
   ssh -L 3000:localhost:3000 [SSH_KOMUTU]
   ```

#### **Option B: QuickPod (Uygun Fiyat, SSH Gerektirmez)**

1. [QuickPod](https://console.quickpod.io?affiliate=f621de18-b6ac-4416-b87f-01f29f8339b5) kaydı yapın
2. Kripto yatırım yapın
3. `CUDA 12.4` şablonu seçerek Pod oluşturun
4. RTX 3090/4090 GPU'ları filtreleyin ve `Bağlan`'ı tıklayın

#### **Option C: Hyperbolic (Alternatif Sağlayıcı)**

1. [Hyperbolic](https://app.hyperbolic.xyz/invite/gqYoHbUk7) kaydı yapın
2. Ayarlara giderek SSH anahtarını ekleyin
3. GPU kiralayın ve `pytorch` şablonu seçin
4. SSH komutun başına `-L 3000:localhost:3000` ekleyin

---

### Yöntem 3: VPS Sunucusu (CPU-Yalnız)

VPS kullanmak istiyorsanız:
- [Hostbrr](https://my.hostbrr.com/order/forms/a/NTMxNw==) gibi sağlayıcılardan 16+ çekirdek, 64GB+ RAM ile sunucu kiralayın
- [Linux VPS Kurulum Rehberi](docs/vps-kurulum.md) adımlarını izleyin

---

## 1. Bağımlılıkları Yükleme

### Sistem Paketlerini Güncelleme

```bash
sudo apt update && sudo apt upgrade -y
```

### Gerekli Araçları Yükleme

```bash
sudo apt install screen curl iptables build-essential git wget lz4 jq make \
  gcc nano automake autoconf tmux htop nvme-cli libgbm1 pkg-config \
  libssl-dev libleveldb-dev tar clang bsdmainutils ncdu unzip -y
```

### Python Kurulumu

```bash
sudo apt install python3 python3-pip python3-venv python3-dev -y
```

### Node.js Kurulumu

```bash
sudo apt update
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo bash -
sudo apt install -y nodejs
node -v
npm install -g yarn
yarn -v
```

---

## 2. HuggingFace Erişim Tokenı Alma

1. [HuggingFace](https://huggingface.co/) hesabı oluşturun
2. [Erişim Tokenları](https://huggingface.co/settings/tokens) sayfasına gidin
3. **Yazma İzni (Write)** ile yeni token oluşturun
4. Tokenı güvenli bir yerde saklayın

---

## 3. Repository Klonlama

```bash
git clone https://github.com/gensyn-ai/rl-swarm/
cd rl-swarm
```

---

## 4. Sürüyü Çalıştırma

### A. CLI Yöntemi (GPU Kullanıcıları)

```bash
# Screen oturumu oluşturun (arka planda çalışmasını sağlar)
screen -S swarm

# rl-swarm dizinine gidin
cd rl-swarm

# Python sanal ortamı oluşturun
python3 -m venv .venv

# Sanal ortamı etkinleştirin
source .venv/bin/activate
# veya Mac/WSL kullanıyorsanız:
. .venv/bin/activate

# Çalıştırın
./run_rl_swarm.sh
```

### B. Docker Yöntemi (Mac, CPU, GPU)

**Docker Yüklemesi:**
```bash
# Linux:
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER

# macOS: Docker Desktop kullanın
```

**Docker ile Çalıştırma:**

```bash
# Screen oturumu oluşturun
screen -S swarm

# rl-swarm dizinine gidin
cd rl-swarm

# CPU veya Mac kullanıcıları:
docker compose run --rm --build -Pit swarm-cpu

# GPU kullanıcıları:
docker compose run --rm --build -Pit swarm-gpu
```

**Docker notları:**
- `docker compose` komutunda hyphen olmayabilir (Ubuntu'da)
- Swap.pem dosyası Docker'da `/root/rl-swarm/user/keys/` dizininde saklanır

---

## 5. Giriş Yapma

### Adım 1: Web Arayüzü Açma

Terminalde `Waiting for userData.json to be created...` mesajını görüncü:

**Yerel Bilgisayar:** 
```
http://localhost:3000/
```

**Bulut/VPS Kullanıcıları - Tunnel Oluşturun:**

1. Yeni bir terminal açın
2. LocalTunnel yükleyin:
   ```bash
   sudo npm install -g localtunnel
   ```
3. Şifre alın:
   ```bash
   curl https://loca.lt/mytunnelpassword
   ```
4. URL oluşturun:
   ```bash
   lt --port 3000
   ```
5. Çıkan URL'yi tarayıcıda açın

### Adım 2: Giriş Yapma

Tercih ettiğiniz yöntemi seçip giriş yapın (Google, Email, vb.)

### Adım 3: Kurulum Sorularını Yanıtlama

#### Soru 1: HuggingFace Hub Paylaşımı
```
Modelleri HuggingFace Hub'a yüklemek ister misiniz? [y/N]
```
- **N** → Testnet'e katılın (önerilen)
- **Y** → HuggingFace access token girin (2GB bant genişliği gerekir)

#### Soru 2: Model Seçimi
```
Kullanmak istediğiniz modeli seçin veya Enter'a basın:
```
Boş bırakın veya şunlardan seçin:
- `Gensyn/Qwen2.5-0.5B-Instruct`
- `Qwen/Qwen3-0.6B`
- `nvidia/AceInstruct-1.5B`
- `dnotitia/Smoothie-Qwen3-1.7B`
- `Gensyn/Qwen2.5-1.5B-Instruct`

---

## AI Tahmin Pazarına Katılma

Kurulum sırasında AI Tahmin Pazarına katılmak isteyip istemediğiniz sorulacak.

**Bu nedir?**
- RL-Swarm modelleri mantık problemlerinin doğru cevabına bahis yapar
- Kanıtlar adım adım açıklanır ve modeller inanclarını günceller
- Erken doğru bahisler daha yüksek ödül alır
- Hakim (Judge) nihai kararı verir

**Varsayılan:** ENTER veya `Y` basarak katılın  
**Opt-out:** `N` basın

Dashboard'da sonuçları görmek için [Gensyn Dashboard](https://dashboard.gensyn.ai/) ziyaret edin.

---

## 🐾 Düğüm Adı Bulma

Kurulum tamamlandıktan sonra terminal çıktısında hayvan adını göreceksiniz:

```
Hello whistling hulking armadillo
```

Bu, ağdaki sizin kimliğinizdir. Terminalde `CTRL+SHIFT+F` ile arayabilirsiniz.

---

## Screen Komutları

Arka planda çalıştırmanız için Screen kullanın:

```bash
# Minimize (Arka plana al): CTRL + A + D
# Geri dön: screen -r swarm
# Durdur ve Kapat: screen -XS swarm quit

# Tüm oturumları listele
screen -ls
```

---

## Birden Fazla Düğüm Çalıştırma

Bir makinede birden fazla düğüm çalıştırabilirsiniz:

1. **Yeni Düğüm Başlatma:** Aynı email ile yeni instance'ta giriş yapın
   - Her düğüm benzersiz Hayvan adı ve `swarm.pem` dosyası alır

2. **İsim Kurtarma:** Eski `swarm.pem`'i yeni düğümde kullanın

3. **Birden Fazla Düğüm Yönetimi:**
   ```bash
   # Repository'yi yeni adla klonlayın
   git clone https://github.com/gensyn-ai/rl-swarm/ rl-swarm-2
   
   # Yeni repository'ye gidin ve çalıştırın
   cd rl-swarm-2
   python3 -m venv .venv
   source .venv/bin/activate
   ./run_rl_swarm.sh
   ```

4. **Tüm Düğümleri İzleme:** [Gensyn Dashboard](https://dashboard.gensyn.ai/) login olup görüntüleyin

---

## 🔐 Yedekleme

### Hızlı Yöntem: Mobaxterm

SSH dosya yönetim istemcisi **Mobaxterm** kullanın ve `swarm.pem` dosyasını indirin.

### Detaylı Yöntem

**VPS Sunucularında:**
```bash
# Mobaxterm ile bağlanıp dosyaları yerel makineye kopyalayın
# Önemli dosya: /root/rl-swarm/swarm.pem
```

**WSL (Windows):**
Windows Explorer'da şu yola gidin:
```
\\wsl.localhost\Ubuntu\root\rl-swarm\swarm.pem
```

**Bulut GPU Sunucularında (Vast, Hyperbolic):**

```bash
# SFTP bağlantısı oluşturun
sftp -P PORT ubuntu@sunucu-adresi

# Dosyayı indirin
get swarm.pem

# Bağlantıyı kapatın
exit
```

---

## 📤 Kurtarma (Yükleme)

Yerel makineden sunucuya dosya yüklemek için:

```bash
# SFTP bağlantısı
sftp -P PORT ubuntu@sunucu-adresi

# Dosyayı yükleyin
put swarm.pem /home/ubuntu/rl-swarm/swarm.pem

# Kapat
exit
```

---

## 📊 Düğüm Sağlığı

### Resmi Dashboard

[Gensyn Dashboard](https://dashboard.gensyn.ai/) adresine giriş yaparak:
- Düğüm durumunu
- Kazanılan ödülleri
- Başarı oranını
- Aktif oturumları görün

### Blockchain Sorgulama

Peer ID'nizi kontrol etmek için:
```
https://gensyn-testnet.explorer.alchemy.com/address/0xFaD7C5e93f28257429569B854151A1B8DCD404c2?tab=read_proxy
```

---

## 🔄 Düğümü Güncelleme

### Adım 1: Düğümü Durdurma

```bash
# Tüm oturumları listele
screen -ls

# Swarm oturumunu kapat
screen -XS swarm quit
```

### Adım 2: Repository Güncelleme

**Yöntem 1:** Hiç değişiklik yapmadıysanız
```bash
cd rl-swarm
git pull
```

**Yöntem 2:** Değişiklik yaptıysanız
```bash
cd rl-swarm
git reset --hard
git pull
```

**Yöntem 3:** Önerilen - Tazeden Kurulum
```bash
cd rl-swarm
cp ./swarm.pem ~/swarm.pem
cd ..
rm -rf rl-swarm
git clone https://github.com/gensyn-ai/rl-swarm
cd rl-swarm
cp ~/swarm.pem ./swarm.pem
```

### Adım 3: Yeniden Çalıştırma

```bash
screen -S swarm
cd rl-swarm
python3 -m venv .venv
source .venv/bin/activate
./run_rl_swarm.sh
```

---

## 🛠️ Sorun Giderme

### CPU Yapılandırma Sorunu

**Hata:** CPU'da çalışmıyor veya çöküyor

**Çözüm 1:**
```bash
cd rl-swarm
nano hivemind_exp/configs/mac/grpo-qwen-2.5-0.5b-deepseek-r1.yaml
```
- `bf16` değerini `false` olarak değiştirin
- `max_steps` değerini `5` olarak azaltın

**Çözüm 2:**
```bash
python3 -m venv .venv
source .venv/bin/activate
export PYTORCH_MPS_HIGH_WATERMARK_RATIO=0.0 && ./run_rl_swarm.sh
```

### Localhost Sayfası Takılı Kalıyor

```bash
cd rl-swarm
sed -i '/^  return (/i\  useEffect(() => {\n    if (!user && !signerStatus.isInitializing) {\n      openAuthModal();\n    }\n  }, [user, signerStatus.isInitializing]);\n\n' modal-login/app/page.tsx
```

### PS1 Unbound Variable Hatası

```bash
sed -i '1i # ~/.bashrc: executed by bash(1) for non-login shells.\n\n# If not running interactively, don'"'"'t do anything\ncase $- in\n    *i*) ;;\n    *) return;;\nesac\n' ~/.bashrc
```

### Daemon 15 Saniyede Başlamadı

```bash
cd rl-swarm
python3 -m venv .venv
source .venv/bin/activate

# Daemon config dosyasını açın
nano $(python3 -c "import hivemind.p2p.p2p_daemon as m; print(m.__file__)")

# "startup_timeout: float = 15" satırını bulun ve 15'i 120 ile değiştirin
# Kaydetin: CTRL + X, Y, Enter
```

### CUDA Bellek Hatası (12GB GPU)

```bash
# Konfigürasyon dosyasını düzenleyin
cd rl-swarm
nano rgym_exp/config/rg-swarm.yaml
```

Şu değerleri ayarlayın:
```yaml
num_generations: 2
num_train_samples: 1
num_transplant_trees: 1
dtype: 'bfloat16'
enable_gradient_checkpointing: true
beam_size: 20
```

Ek optimizasyon:
```bash
export PYTORCH_CUDA_ALLOC_CONF="expandable_segments:True,max_split_size_mb:128"
./run_rl_swarm.sh
```

### Model Eğitim Yapmıyor

- **MacBook:** Eğitim yavaş olabilir, 20 dakika bekleyin
- **Tekrar başlat:** `screen -XS swarm quit` yapıp yeniden başlayın
- **Logs kontrol:** `logs/swarm.log` ve `logs/wandb/debug.log` dosyalarını kontrol edin

---

## 📚 Ek Kaynaklar

- **[Resmi RL-Swarm Repository](https://github.com/gensyn-ai/rl-swarm)**
- **[GenRL Kütüphanesi](https://github.com/gensyn-ai/genrl)**
- **[Gensyn Dashboard](https://dashboard.gensyn.ai/)**
- **[Resmi Belgeler](https://docs.gensyn.ai/testnet/rl-swarm)**
- **[Discord Topluluğu](https://discord.gg/AdnyWNzXh5)**

---

## 📝 Lisans

Bu rehber MIT Lisansı altında yayımlanmıştır.

---

## 🤝 Katkı Yapma

Rehberi geliştirmek için:

1. Repository'yi fork edin
2. Feature branch'i oluşturun (`git checkout -b feature/iyilestirme`)
3. Değişiklikleri commit edin (`git commit -m 'Iyilestirme ekle'`)
4. Push yapın (`git push origin feature/iyilestirme`)
5. Pull Request açın

---

## ⚠️ Yasal Uyarı

RL-Swarm deneysel yazılımdır. Kendi sorumluluğunuzda kullanın. Yazarlar, bu yazılımın kullanımından kaynaklanan herhangi bir hasardan sorumlu değildir.

---

**Son Güncelleme:** Kasım 2025  
**Hazırlayan:** RL-Swarm Türkçe Topluluk