# Windows'ta WSL2 ve RL-Swarm Kurulumu

## Adım 1: WSL2 Yükleme

Windows'ta RL-Swarm çalıştırmak için WSL2 (Windows Subsystem for Linux 2) gerekir.

### Gereksinimler
- Windows 10 (Build 19041+) veya Windows 11
- 4GB+ RAM
- Hyper-V desteği etkin

### Kurulum Adımları

**1. PowerShell'i Yönetici olarak açın:**

```powershell
Start-Process PowerShell -Verb RunAs
```

**2. WSL2 etkinleştirin:**

```powershell
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
```

**3. Bilgisayarı yeniden başlatın**

**4. WSL2 çekirdeğini yükleme:**

```powershell
wsl --update
wsl --set-default-version 2
```

**5. Ubuntu yükleme:**

```powershell
wsl --install -d Ubuntu
```

**6. Yüklemeden sonra:**

Ubuntu otomatik olarak başlayacak. İlk çalıştırmada:
- UNIX kullanıcı adı girin
- Parola belirleyin

## Adım 2: Ubuntu Hazırlanması

### Terminal Açma

**Seçenek 1:** Windows Terminal kullanarak
```powershell
wsl
# veya
wsl -d Ubuntu
```

**Seçenek 2:** Ubuntu uygulamasını başlat menüsünden açın

### Sistem Güncellemesi

```bash
sudo apt update && sudo apt upgrade -y
```

## Adım 3: RL-Swarm Kurulumu

### Otomatik Kurulum

1. Bu repository'i klonlayın:
```bash
git clone https://github.com/gensyn-ai/rl-swarm/
cd rl-swarm
```

2. Kurulum script'ini çalıştırın:
```bash
chmod +x ../scripts/install-ubuntu.sh
../scripts/install-ubuntu.sh
```

### Manuel Kurulum

Bkz. Ana README dosyasının "1. Bağımlılıkları Yükleme" bölümü

## Adım 4: RL-Swarm Başlatma

```bash
cd rl-swarm
source .venv/bin/activate
./run_rl_swarm.sh
```

### Web Arayüzü Erişimi

WSL'den **localhost:3000** adresine erişebilirsiniz:
```
http://localhost:3000/
```

## GPU Desteği (İsteğe Bağlı)

Windowslu bilgisayarda NVIDIA GPU kullanmak istiyorsanız:

### NVIDIA Driver Yükleme (Windows tarafı)

1. https://www.nvidia.com/Download/driverDetails.aspx adresini ziyaret edin
2. GPU'nuz için driver indirin
3. Kurun
4. Bilgisayarı yeniden başlatın

### WSL2 Sonrasında Kontrol

```bash
nvidia-smi
```

Eğer çalışırsa, GPU hazırsa demektir!

## Sorunlar

### "Türü dönüştürme hatası" (WSL komutunda)

**Çözüm:**
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### WSL'de disk alanı doldu

**Çözüm:**
```bash
# WSL içinden
du -sh /mnt/c/*  # Windows sürücülerini kontrol et
du -sh ~/*       # Home dizinini kontrol et
```

### NVIDIA GPU bulunmuyor

**Çözüm:**
```bash
# WSL2 Resmi Sistem Gereksinimi Kontrol
uname -r  # Kernel versiyonu 5.10+ olmalı

# Driver Yeniden Yükle (Windows tarafında)
# Bilgisayarı Yeniden Başlat

# WSL içinde kontrol
nvidia-smi --query-gpu=name --format=csv
```

## İpuçları

1. **Dosya Yönetimi:**
   - Windows dosyalarını `/mnt/c/` altında bulabilirsiniz
   - WSL dosyalarına Windows'tan erişmek için: `\\wsl.localhost\Ubuntu\`

2. **Performans:**
   - Windows sürücülerinde değil, WSL sürücüsünde çalışın
   - `/home/` altında dosyalar daha hızlıdır

3. **Backup:**
   ```bash
   # swarm.pem dosyasını yedekleyin
   cp ~/.../rl-swarm/swarm.pem /mnt/c/Users/[Ad]/Desktop/swarm.pem
   ```

## Kaynaklar

- [WSL2 Resmi Belgesi](https://docs.microsoft.com/en-us/windows/wsl/)
- [NVIDIA GPU + WSL2](https://docs.nvidia.com/cuda/wsl-user-guide/)
- [Windows Terminal](https://www.microsoft.com/en-us/p/windows-terminal/)

---

**Sorun mu yaşıyorsunuz?** [Ana Sorun Giderme Rehberine](SORUN-GIDERME.md) bakın.
