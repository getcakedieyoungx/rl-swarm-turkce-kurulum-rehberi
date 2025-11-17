# RL-Swarm Windows PowerShell Kurulum Script'i
# WSL2 ve Ubuntu üzerinde kurulum yapıp RL-Swarm'ı hazırlar

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   RL-Swarm Windows Kurulum" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

function Info {
    Write-Host "[INFO] $args" -ForegroundColor Blue
}

function Success {
    Write-Host "[OK] $args" -ForegroundColor Green
}

function Error {
    Write-Host "[HATA] $args" -ForegroundColor Red
}

# WSL2 kontrolü
Info "WSL2 kontrol ediliyor..."

$wslCheck = wsl --list --verbose 2>$null
if ($LASTEXITCODE -ne 0) {
    Error "WSL2 bulunamadı!"
    Write-Host ""
    Write-Host "Lütfen şöyle kurun:" -ForegroundColor Yellow
    Write-Host "1. PowerShell'i Yönetici olarak açın" -ForegroundColor Gray
    Write-Host "2. wsl --install -d Ubuntu çalıştırın" -ForegroundColor Gray
    Write-Host "3. Bilgisayarı yeniden başlatın" -ForegroundColor Gray
    exit 1
}

Success "WSL2 bulundu"

# Python kontrol
Info "Python kontrol ediliyor..."
wsl python3 --version

if ($LASTEXITCODE -ne 0) {
    Error "Python WSL'de yüklü değil. Kurulum script'i Python'u yükleyecek."
}

# Repository klonlama
Info "RL-Swarm klonlanıyor..."

if (Test-Path "rl-swarm") {
    Write-Host "rl-swarm dizini var, atlanıyor" -ForegroundColor Yellow
} else {
    git clone https://github.com/gensyn-ai/rl-swarm/
    Success "Klonlama bitti"
}

# WSL'de Python ortamı
Info "Python ortamı oluşturuluyor..."
wsl -d Ubuntu -- bash -c "cd rl-swarm && python3 -m venv .venv"
Success "Ortam oluşturuldu"

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "   KURULUM TAMAMLANDI" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Başlatmak için:" -ForegroundColor Green
Write-Host ""
Write-Host "  wsl" -ForegroundColor Gray
Write-Host "  cd rl-swarm" -ForegroundColor Gray
Write-Host "  source .venv/bin/activate" -ForegroundColor Gray
Write-Host "  ./run_rl_swarm.sh" -ForegroundColor Gray
Write-Host ""
Write-Host "Daha fazla bilgi: docs/windows-wsl-kurulum.md" -ForegroundColor Yellow
Write-Host ""
