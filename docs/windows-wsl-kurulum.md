# Windows'ta WSL2 ile RL-Swarm Kurulumu

Windows'ta RL-Swarm çalıştırmak için WSL2 (Windows Subsystem for Linux 2) kullanıyoruz. Bu, Linuxın tam bir yönetim siste­mi éttiği ve Windows'un içinde çalışması demek.

---

## WSL2 Kurulumu

### Kontrol

Windows 10 Build 19041+ veya Windows 11 gerekli.

```powershell
winver  # Sürüm kontrol et
```

### Adım 1: Etkinleştir

PowerShell'i Yönetici olarak açıp:

```powershell
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
```

### Adım 2: Yeniden Başlat

Bilgisayarı yeniden başlatın.

### Adım 3: WSL2 Çekirdeği

Yeniden PowerShell'de:

```powershell
wsl --update
wsl --set-default-version 2
```

### Adım 4: Ubuntu Yükle

```powershell
wsl --install -d Ubuntu
```
Ubuntu otomatik başlayacak. Kullanıcı adı ve parola oluşturun.

---

## RL-Swarm Kurulması

### PowerShell ile Otomatik

```powershell
.\scripts\install-windows.ps1
```

### Manual Kurulum

```powershell
# WSL'ye gir
wsl

# Linux içinde
cd ~
git clone https://github.com/gensyn-ai/rl-swarm/
cd rl-swarm
python3 -m venv .venv
source .venv/bin/activate
```

---

## Çalıştırma

### Web Arayüzüne Erişim

PowerShell'den:
```powershell
wsl
```

Ubuntu prompt'unda:
```bash
cd ~/rl-swarm
source .venv/bin/activate
./run_rl_swarm.sh
```

Tarayıcıda: `http://localhost:3000/`

---

## Dosya Erişimi

### Windows'tan WSL Dosyalarını Gör

Windows Explorer'da:
```
\\wsl.localhost\Ubuntu\home\username\rl-swarm
```

### WSL içinde Windows Dosyaları

```bash
# C: sürücüsü
ls /mnt/c/

# Desktop
ls /mnt/c/Users/username/Desktop/
```

---

## GPU Desteği

NVIDIA GPU'nuz varsa:

**1. Windows'ta Driver Yükle**
- https://www.nvidia.com/Download/driverDetails.aspx
- GPU'nız için driver indirin
- Kurup bilgisayarı yeniden başlatın

**2. WSL'de Kontrol**
```bash
nvidia-smi
```

Çalışırsa GPU hazır demek.

---

## Sorunlar

### "Erişim Reddedildi" PowerShell'de

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Disk Dolu

WSL fazla yer kapılıyor mu?

```bash
# WSL içinde
du -sh ~/*  # Home dizini kontrol
du -sh /   # Tüm sistem
```

Büyük dosyalar silin, özellikle `/var/log`.

### GPU Görünmüyor

```bash
# WSL kernel versiyonu kontrol
uname -r  # 5.10+ olmalı

# CUDA kontrol
nvcc --version
```

Hâlâ sorun varsa:
1. NVIDIA Driver'ı güncelleyin (Windows)
2. WSL'yi güncelle: `wsl --update`
3. Bilgisayar yeniden başlat

---

## İpuçlar

**Terminal Seçimi:**
- Windows Terminal (modern ve hızlı)
- PowerShell (yerleşik)
- Ubuntu uygulaması (basit)

**Performans:**
- WSL diskinde dosyalar tutuyor (/home/) → hızlı
- Windows diskine (/mnt/c/) yazma → daha yavaş

**Backup:**
```bash
cp ~/rl-swarm/swarm.pem /mnt/c/Users/username/Desktop/
```

---

## Kaynaklar

- [WSL Resmi Belgesi](https://docs.microsoft.com/en-us/windows/wsl/)
- [NVIDIA CUDA + WSL](https://docs.nvidia.com/cuda/wsl-user-guide/)
- [Windows Terminal](https://www.microsoft.com/store/productId/9N0DX20HK701)

Sorun varsa [Sorun Giderme](SORUN-GIDERME.md) rehberine bak.
