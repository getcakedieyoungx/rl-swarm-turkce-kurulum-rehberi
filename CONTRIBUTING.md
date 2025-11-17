# Katkı Rehberi

RL-Swarm Türkçe Kurulum Rehberi projesine katkı yapmak istediğiniz için teşekkürler!

## Nasıl Katkı Yapabilirim?

### 1. Belge İyileştirmeleri

- Yazım ve dilbilgisi hatalarını düzeltme
- Talimatları açıklığa kavuşturma
- Eksik bölümleri tamamlama
- Örnekler ve resimler ekleme

### 2. Yeni İçerik Ekleme

- Ek kurulum rehberleri (yeni GPU sağlayıcıları)
- İleri yapılandırma adımları
- Performans optimizasyonu ipuçları
- Yeni sorun giderme çözümleri

### 3. Script İyileştirmeleri

- Hatalar ve crash'leri düzeltme
- Yeni özellikler ekleme
- Daha iyi hata mesajları
- Performans optimizasyonu

## Katkı Yapma Adımları

### 1. Repository'yi Fork Edin

```bash
# GitHub web arayüzünde "Fork" düğmesine tıklayın
# veya
gh repo fork getcakedieyoungx/rl-swarm-turkce-kurulum-rehberi
```

### 2. Yerel Klona Yapın

```bash
git clone https://github.com/YOUR-USERNAME/rl-swarm-turkce-kurulum-rehberi.git
cd rl-swarm-turkce-kurulum-rehberi
```

### 3. Feature Branch Oluşturun

```bash
git checkout -b feature/iyilestirme-adi
# veya
git checkout -b bugfix/hata-adi
```

### 4. Değişiklikleri Yapın

- Dosyaları düzenleyin
- Test edin
- Yapılan değişiklikleri özetleyin

### 5. Commit Yapın

```bash
git add .
git commit -m "Kısa ve açıklayıcı commit mesajı"

# İyi bir commit mesajı örneği:
# "README'ye GPU kurulum bölümü eklendi"
# "Sorun giderme rehberine CUDA hatası çözümü eklendi"
# "install-ubuntu.sh'de Python 3.10 kontrolü iyileştirildi"
```

### 6. Push Yapın

```bash
git push origin feature/iyilestirme-adi
```

### 7. Pull Request Açın

1. GitHub web arayüzüne gidin
2. "Compare & pull request" düğmesine tıklayın
3. Değişiklikleri açıklayan bir başlık ve açıklama yazın
4. "Create pull request"'e tıklayın

## Yazı Stil Rehberi

### Türkçe

- Samimi ve profesyonel bir ton kullanın
- Teknik terimleri İngilizce ile parantez içinde açıklayın
  - Örnek: "Sanal ortam (virtual environment)"
- Başlıklar başkent harfi ile başlasın
- Listelerde tutarlı ol

### Kod Blokları

```markdown
# Bash kodu
```bash
ls -la
```

# Python kodu
```python
print("Merhaba")
```

# PowerShell kodu
```powershell
Write-Host "Merhaba"
```
```

### Linkler

```markdown
# Harici link
[Gensyn Resmi Site](https://gensyn.ai)

# İç link
[Sorun Giderme](docs/SORUN-GIDERME.md)

# Başlığa link
[Bölüme Git](#başlık-adı-kebab-case)
```

## Dosya Yapısı

```
rl-swarm-turkce-kurulum-rehberi/
├── README.md                 # Ana belge
├── CONTRIBUTING.md          # Bu dosya
├── LICENSE                  # MIT Lisansı
├── scripts/
│   ├── install-ubuntu.sh    # Ubuntu kurulum script'i
│   ├── install-windows.ps1  # Windows kurulum script'i
│   └── README.md            # Script'ler açıklaması
├── docs/
│   ├── SORUN-GIDERME.md     # Sorun giderme rehberi
│   ├── windows-wsl-kurulum.md  # WSL kurulum
│   ├── vps-kurulum.md       # VPS kurulum
│   └── ...                  # Diğer dökümentasyon
└── .gitignore
```

## Commit Mesajı Formatı

Git commit mesajları İngilizce yazılmalıdır:

```
<type>: <subject>

<body>

<footer>
```

### Type (Tür)

- `feat`: Yeni özellik
- `fix`: Hata düzeltme
- `docs`: Belge değişikliği
- `style`: Stil değişikliği (yazım, format)
- `refactor`: Kodun yeniden yapılandırılması
- `test`: Test ekleme veya düzeltme
- `chore`: Genel bakım işleri

### Örnek Commit Mesajları

```
docs: README'ye Windows WSL kurulum bölümü eklendi

feat: GPU sağlayıcı olarak Runpod desteği eklendi

fix: install-ubuntu.sh'de bash syntax hatası düzeltildi

style: SORUN-GIDERME.md formatı iyileştirildi
```

## Pull Request Şablonu

```markdown
## Açıklama
Yaptığınız değişiklikleri kısa bir şekilde açıklayın.

## İlgili Issue
İlgili GitHub issue varsa: #123

## Değişiklik Türü
- [ ] Yeni özellik
- [ ] Hata düzeltme
- [ ] Belge güncelleme
- [ ] Diğer (lütfen açıklayın)

## Test Edildi
- [ ] Yerel makinede test ettim
- [ ] Ubuntu 20.04'te test ettim
- [ ] Ubuntu 22.04'te test ettim
- [ ] Windows WSL'de test ettim

## Kontrol Listesi
- [ ] Kodumu formatladım
- [ ] Yeni bağımlılıklar yoksa kontrol ettim
- [ ] Belge güncelledim
- [ ] Türkçe yazım kurallarına uydum
```

## Kod İnceleme (Code Review)

### Uyması Gereken Kriterler

1. **Doğruluk:** Talimatlar doğru ve güncel mi?
2. **Anlaşılırlık:** Açık ve kolay anlaşılır mı?
3. **Tutarlılık:** Mevcut stil ve yapıyla uyumlu mu?
4. **Tamamlılık:** Konuyu tam olarak kapsıyor mu?
5. **Test:** Talimatlar test edildi mi?

## Sorun Raporlama

### İyi Bir Sorun Raporu

```markdown
## Sorun Açıklaması
Bu görevde ne oldu? Açıkça tanımlayın.

## Adım Adım Yinele
1. [İlk adım]
2. [İkinci adım]
3. [Sorun oluştu]

## Beklenen Davranış
Ne olmasını bekliyordunuz?

## Gerçek Davranış
Aslında ne oldu?

## Sistem Bilgisi
- OS: [ör. Ubuntu 22.04]
- Python: [ör. 3.10]
- GPU: [ör. RTX 4090 veya None]
- Hata Mesajı: [tam hata metni]

## Ekran Görüntüsü/Log
```
Hata günlüğü veya ekran görüntüsü ekleyin
```
```

## Lisans

Bu projeye katkı yaparak, katkılarınızın MIT Lisansı altında yayımlanacağını kabul etmiş olursunuz.

## Sorular

Katkı yapma hakkında sorularınız varsa:

1. [GitHub Discussions](https://github.com/getcakedieyoungx/rl-swarm-turkce-kurulum-rehberi/discussions)
2. [GitHub Issues](https://github.com/getcakedieyoungx/rl-swarm-turkce-kurulum-rehberi/issues)
3. [Discord Topluluğu](https://discord.gg/AdnyWNzXh5)

---

**Teşekkürler! Katkılarınız bu projeyi daha iyi yapıyor!** 🙏
