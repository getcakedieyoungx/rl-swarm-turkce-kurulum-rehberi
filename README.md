# RL-Swarm Türkçe Kurulum Rehberi

Gensyn AI'ın geliştirdiği RL-Swarm, internet üzerinde dağıtılmış Reinforcement Learning eğitim sürüsü oluşturmak için açık kaynaklı bir framework. Bu rehber, kurulum, yapılandırma ve testnet'e katılma için gerekli tüm adımları kapsar.

---

## İçerik

- [Donanım Gereksinimleri](#donanım-gereksinimleri)
- [Kurulum Yöntemleri](#kurulum-yöntemleri)
- [Başlangıç](#başlangıç)
- [Sorunlarla İlgilenmek](#sorunlarla-ilgilenmek)
- [Kaynaklar](#kaynaklar)

---

## Donanım Gereksinimleri

### CPU ile Çalıştırma
- **RAM:** 32GB minimum
- **CPU:** ARM64 veya x86 mimarisi
- **Uyarı:** Sistem kaynakları stres yaşarsa eğitim kesintiye uğrayabilir

### GPU ile Çalıştırma (Önerilen)
- **GPU:** NVIDIA RTX 3090, 4090, 5090 veya A100, H100
- **VRAM:** 24GB (12GB ile de başlaması mümkün)
- **CUDA Driver:** 12.4+
- **Python:** 3.10-3.13

### Desteklenen Modeller
Donanımınıza göre seçebilirsiniz:
- `Gensyn/Qwen2.5-0.5B-Instruct` (düşük kaynaklar)
- `Qwen/Qwen3-0.6B` (orta kaynaklar)
- `nvidia/AceInstruct-1.5B` (orta-yüksek)
- `Gensyn/Qwen2.5-1.5B-Instruct` (yüksek kaynaklar)

---

## Kurulum Yöntemleri

### Windows Kullanıcıları

Windows'ta çalıştırmak için WSL2 ve Ubuntu gerekir.

**Adım 1:** PowerShell'i yönetici olarak açıp şunu çalıştırın:
```powershell
wsl --install -d Ubuntu
```

**Adım 2:** Bilgisayarı yeniden başlatın

**Adım 3:** Ubuntu başlatıldığında kullanıcı adı ve parola belirleyin

**Adım 4:** Detaylı rehber için [Windows WSL Kurulum Rehberi](docs/windows-wsl-kurulum.md)'ne bakın

### Linux / Mac Kullanıcıları

#### Otomatik Kurulum
```bash
git clone https://github.com/getcakedieyoungx/rl-swarm-turkce-kurulum-rehberi.git
cd rl-swarm-turkce-kurulum-rehberi
chmod +x scripts/install-ubuntu.sh
./scripts/install-ubuntu.sh
```

#### Manuel Kurulum

**1. Sistem paketleri:**
```bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y python3 python3-pip python3-venv python3-dev \
  git nodejs npm curl build-essential
```

**2. RL-Swarm klonlama:**
```bash
git clone https://github.com/gensyn-ai/rl-swarm/
cd rl-swarm
```

**3. Python ortamı ve bağımlılıklar:**
```bash
python3 -m venv .venv
source .venv/bin/activate
```

### Cloud GPU Kiralama

#### Vast.ai
1. [Vast.ai](https://cloud.vast.ai/) kaydı yapın
2. SSH anahtarı oluşturun: `ssh-keygen -t rsa -b 4096`
3. SSH anahtarını Vast paneline ekleyin
4. PyTorch şablonu seçip GPU kiralayın (en az 50GB disk)
5. SSH bağlantısında `-L 3000:localhost:3000` ekleyin

#### QuickPod
1. [QuickPod](https://console.quickpod.io) kaydı
2. CUDA 12.4 şablonu seçin
3. RTX 3090/4090 filtreleyin
4. Pod başlatıp web veya SSH aracılığıyla bağlanın

#### Hyperbolic
1. [Hyperbolic](https://app.hyperbolic.xyz/) kaydı
2. SSH anahtarını ayarlar bölümüne ekleyin
3. GPU kiralayıp pytorch şablonu seçin
4. SSH komutuna `-L 3000:localhost:3000` ekleyin

### VPS ile Çalıştırma

Eğer kendi sunucunuz varsa:
```bash
ssh root@sunucu_ip
# Üstteki manuel kurulum adımlarını izleyin
```

Detaylı rehber: [VPS Kurulum Rehberi](docs/vps-kurulum.md)

---

## Başlangıç

### Çalıştırma

**CLI ile (GPU):**
```bash
cd rl-swarm
source .venv/bin/activate
./run_rl_swarm.sh
```

**Docker ile:**
```bash
# CPU/Mac
docker compose run --rm --build -Pit swarm-cpu

# GPU
docker compose run --rm --build -Pit swarm-gpu
```

**Arka planda çalıştırmak (Screen):**
```bash
screen -S swarm
cd rl-swarm
source .venv/bin/activate
./run_rl_swarm.sh

# Çıkmak: Ctrl+A, D
# Geri dönmek: screen -r swarm
# Sonlandırmak: screen -XS swarm quit
```

### Web Arayüzüne Erişim

**Yerel:** `http://localhost:3000/`

**VPS/Cloud (SSH Tunnel):**
```bash
ssh -L 3000:localhost:3000 user@server_ip
# Sonra: http://localhost:3000/
```

**Herkese Açık (LocalTunnel):**
```bash
npm install -g localtunnel
lt --port 3000
# Çıkan URL'yi tarayıcıda açın
```

### Kurulum Soruları

Arayüz açıldığında sorulan sorulara yanıtlar:

**HuggingFace Hub'a yüklemek ister misiniz?**
- Testnet'e katılmak için: **N** (enter)
- Kendi modeli yüklemek için: **Y** + access token

**Model seçimi:**
- Varsayılan model için: **Enter**
- Özel seçim: Model adını yazın (örn. `Gensyn/Qwen2.5-0.5B-Instruct`)

**AI Prediction Market:**
- Katılmak için: **Y** veya Enter
- Katılmamak için: **N**

### Node Adınızı Bulma

Kurulum tamamlandıktan sonra terminal çıktısında hayvan adı yazacak:
```
Hello whistling hulking armadillo
```

Bu, testnet'teki kimliğiniz. Terminal çıktısında "Hello" yazısını arayın.

### Monitoring

[Gensyn Dashboard](https://dashboard.gensyn.ai/) adresine giriş yap ıp:
- Node durumunu
- Kazanılan puanları
- Başarı oranını
- Prediction Market katılımını görebilirsiniz

---

## Birden Fazla Node

Aynı email ile birden fazla node çalıştırabilirsiniz:

```bash
# İlk node
git clone https://github.com/gensyn-ai/rl-swarm/ rl-swarm-1
cd rl-swarm-1
# ... kurulum ve çalıştırma

# İkinci node (farklı directory)
git clone https://github.com/gensyn-ai/rl-swarm/ rl-swarm-2
cd rl-swarm-2
# ... kurulum ve çalıştırma
```

Her biri benzersiz hayvan adı ve `swarm.pem` alacaktır.

---

## Yedekleme ve Kurtarma

### swarm.pem'i Yedekleme

**Önemli:** `swarm.pem` dosyası node'unuzun kimliğidir. Kaybetmemelisiniz.

```bash
# Yedek kopya
cp ~/rl-swarm/swarm.pem ~/Desktop/swarm.pem.backup

# Güvenli depolama için şifrele
openssl enc -aes-256-cbc -in ~/rl-swarm/swarm.pem -out ~/swarm.pem.enc
```

### Kurtarma

Eski `swarm.pem` ile yeni kuruluma başlarken:
```bash
cd rl-swarm
cp ~/swarm.pem.backup ./swarm.pem
# Sonra çalıştırın
./run_rl_swarm.sh
```

---

## Sorunlarla İlgilenmek

### Sık Karşılaşılan Sorunlar

**1. "Module 'hivemind' Not Found"**
```bash
cd rl-swarm
source .venv/bin/activate  # Sanal ortamı aktifleştir
```

**2. GPU Belleği Doldu (CUDA Out of Memory)**
```bash
# Daha küçük model seçin veya:
cd rl-swarm
export PYTORCH_CUDA_ALLOC_CONF="expandable_segments:True,max_split_size_mb:128"
./run_rl_swarm.sh
```

**3. Localhost:3000 Açılmıyor**
```bash
# SSH Tunnel'ı kontrol edin
ssh -L 3000:localhost:3000 user@server_ip

# Veya LocalTunnel kullanın
npm install -g localtunnel
lt --port 3000
```

**4. Daemon Başlamıyor (15 saniye timeout)**
```bash
cd rl-swarm
python3 -m venv .venv
source .venv/bin/activate

nano $(python3 -c "import hivemind.p2p.p2p_daemon as m; print(m.__file__)")
# "startup_timeout: float = 15" satırını bulun, 15'i 120 yapın
# Kaydet: Ctrl+X, Y, Enter
```

**5. Eğitim Yavaş veya Durmuş Görünüyor**
```bash
# GPU kullanılıyor mu?
watch -n 1 nvidia-smi

# CPU kullanımı
top

# Logları kontrol et
tail -f logs/swarm.log
```

Daha fazla sorun giderme için: [Sorun Giderme Rehberi](docs/SORUN-GIDERME.md)

---

## Güncelleme

```bash
cd rl-swarm

# En basit yolu (değişiklik yapmadıysanız):
git pull

# Eğer değişiklik yaptıysanız:
git reset --hard
git pull

# Önerilen (temiz başlangıç):
cp ./swarm.pem ~/swarm.pem.backup
cd ..
rm -rf rl-swarm
git clone https://github.com/gensyn-ai/rl-swarm
cd rl-swarm
cp ~/swarm.pem.backup ./swarm.pem

# Yeniden başlat
python3 -m venv .venv
source .venv/bin/activate
./run_rl_swarm.sh
```

---

## Telegram Bot Kurulumu (Opsiyonel)

Node'u Telegram üzerinden izlemek için:

**1. Go yükle:**
```bash
curl -L https://go.dev/dl/go1.22.4.linux-amd64.tar.gz | sudo tar -xzf - -C /usr/local
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
source ~/.bashrc
```

**2. Gswarm yükle:**
```bash
go install github.com/Deep-Commit/gswarm/cmd/gswarm@latest
```

**3. Telegram Bot oluştur:**
- [@BotFather](https://t.me/botfather)'a `/newbot` yaz
- Bot token'ı kaydet

**4. Chat ID bul:**
- Bot'unuza mesaj gönder
- `https://api.telegram.org/botTOKEN/getUpdates` aç ve chat ID'ni bul

**5. Çalıştır:**
```bash
gswarm
# Bot token, chat ID ve EOA adresi gir
```

---

## Kaynaklar

- [Resmi RL-Swarm Repo](https://github.com/gensyn-ai/rl-swarm)
- [Gensyn Dashboard](https://dashboard.gensyn.ai/)
- [Resmi Dokumentasyon](https://docs.gensyn.ai/testnet/rl-swarm)
- [Discord Topluluk](https://discord.gg/AdnyWNzXh5)
- [0xmoei'nin Rehberi](https://github.com/0xmoei/gensyn-ai) (İngilizce)

---

## Lisans

MIT Lisansı - Detaylar için [LICENSE](LICENSE) dosyasına bakın

---

## Katkıda Bulunma

Hata bulunca veya iyileştirme için [CONTRIBUTING.md](CONTRIBUTING.md) dosyasını okuyun.

**Son Güncelleme:** Kasım 2025
