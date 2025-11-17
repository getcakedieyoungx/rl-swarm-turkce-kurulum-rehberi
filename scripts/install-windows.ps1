# RL-Swarm Türkçe Kurulum Script'i - Windows PowerShell
# Bu script gerekli tüm bağımlılıkları yükler ve RL-Swarm'ı kurar

Write-Host "" -ForegroundColor Green
Write-Host "╔════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║        RL-Swarm Otomatik Kurulum (Windows PowerShell)          ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# Fonksiyonlar
function Print-Step {
    param([int]$Number, [string]$Message)
    Write-Host "[ADIM $Number] $Message" -ForegroundColor Blue
}

function Print-Success {
    param([string]$Message)
    Write-Host "[BAŞARILI] $Message" -ForegroundColor Green
}

function Print-Error {
    param([string]$Message)
    Write-Host "[HATA] $Message" -ForegroundColor Red
}

function Print-Warning {
    param([string]$Message)
    Write-Host "[UYARI] $Message" -ForegroundColor Yellow
}

# 1. WSL kontrolü
Print-Step 1 "Windows Subsystem for Linux (WSL) kontrol ediliyor..."

$wslCheck = wsl --list --verbose 2>$null
if ($LASTEXITCODE -eq 0) {
    Print-Success "WSL bulundu"
} else {
    Print-Error "WSL bulunamadı!"
    Write-Host "Lütfen önce WSL2 ve Ubuntu'yu kurun:" -ForegroundColor Yellow
    Write-Host "  1. PowerShell'i Yönetici olarak açın" -ForegroundColor Gray
    Write-Host "  2. Şu komutu çalıştırın: wsl --install -d Ubuntu" -ForegroundColor Gray
    Write-Host "  3. Bilgisayarı yeniden başlatın" -ForegroundColor Gray
    Write-Host "  4. Bu script'i tekrar çalıştırın" -ForegroundColor Gray
    exit 1
}

# 2. Python kontrolü
Print-Step 2 "Python3 yüklü mü kontrol ediliyor (WSL içinde)..."

wsl python3 --version
if ($LASTEXITCODE -eq 0) {
    Print-Success "Python3 bulundu"
} else {
    Print-Warning "Python3 WSL'de bulunamadı. WSL'de kurulacak."
}

# 3. Git kontrolü
Print-Step 3 "Git yüklü mü kontrol ediliyor..."

$gitCheck = git --version 2>$null
if ($LASTEXITCODE -eq 0) {
    Print-Success "Git bulundu"
} else {
    Print-Error "Git bulunamadı!"
    Write-Host "Lütfen Git'i https://git-scm.com adresinden indirip kurun" -ForegroundColor Yellow
    exit 1
}

# 4. Repository klonlama
Print-Step 4 "RL-Swarm repository'si klonlanıyor..."

if (Test-Path "rl-swarm") {
    Print-Warning "rl-swarm dizini zaten mevcut, atlanıyor"
} else {
    git clone https://github.com/gensyn-ai/rl-swarm/
    Print-Success "Repository klonlandı"
}

# 5. WSL'de kurulum
Print-Step 5 "WSL'de gerekli paketler yükleniyor..."

wsl -- bash -c "cd rl-swarm && python3 -m venv .venv"
Print-Success "Python sanal ortamı oluşturuldu"

Write-Host ""
Write-Host "╔════════════════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║                    KURULUM TAMAMLANDI!                         ║" -ForegroundColor Green
Write-Host "╠════════════════════════════════════════════════════════════════╣" -ForegroundColor Green
Write-Host "║  RL-Swarm'ı başlatmak için şu komutları çalıştırın:            ║" -ForegroundColor Green
Write-Host "║                                                                ║" -ForegroundColor Green
Write-Host "║  PowerShell'de:                                                ║" -ForegroundColor Green
Write-Host "║  $ wsl                                                         ║" -ForegroundColor Green
Write-Host "║  $ cd rl-swarm                                                 ║" -ForegroundColor Green
Write-Host "║  $ source .venv/bin/activate                                   ║" -ForegroundColor Green
Write-Host "║  $ ./run_rl_swarm.sh                                           ║" -ForegroundColor Green
Write-Host "║                                                                ║" -ForegroundColor Green
Write-Host "║  Daha fazla bilgi: https://github.com/gensyn-ai/rl-swarm     ║" -ForegroundColor Green
Write-Host "╚════════════════════════════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""
