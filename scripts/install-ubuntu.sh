#!/bin/bash

# RL-Swarm Ubuntu/Linux Kurulum Script'i
# Gerekli tüm paketleri yükler ve RL-Swarm'ı kurar

set -e

echo ""
echo "========================================"
echo "   RL-Swarm Ubuntu/Linux Kurulum"
echo "========================================"
echo ""

# Renkler
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

success() {
    echo -e "${GREEN}[OK]${NC} $1"
}

error() {
    echo -e "${RED}[HATA]${NC} $1"
}

# Sistem güncelleme
info "Sistem paketleri güncelleniyor..."
sudo apt update && sudo apt upgrade -y
success "Güncellemeler tamamlandı"

# Temel araçlar
info "Gerekli araçlar yükleniyor..."
sudo apt install -y screen curl git wget build-essential python3 python3-pip \
    python3-venv python3-dev nodejs npm
success "Araçlar yüklendi"

# Python kontrol
info "Python versiyonu kontrol ediliyor...
python3_version=$(python3 -c 'import sys; print(".".join(map(str, sys.version_info[:2])))')
echo "Bulundu: Python $python3_version"

# RL-Swarm klonlama
if [ -d "rl-swarm" ]; then
    echo "rl-swarm dizini zaten var, atlanıyor"
else
    info "RL-Swarm klonlanıyor..."
    git clone https://github.com/gensyn-ai/rl-swarm/
    success "Klonlama tamamlandı"
fi

# Python ortamı
info "Python ortamı oluşturuluyor..."
cd rl-swarm
python3 -m venv .venv
success "Ortam oluşturuldu"

# NVIDIA kontrol
if command -v nvidia-smi &> /dev/null; then
    success "NVIDIA GPU tespit edildi:"
    nvidia-smi
else
    echo -e "${YELLOW}[UYARI]${NC} GPU tespit edilmedi, CPU-only modda çalışacaksınız"
fi

echo ""
echo "========================================"
echo "   KURULUM TAMAMLANDI"
echo "========================================"
echo ""
echo "Başlatmak için:"
echo ""
echo "  cd rl-swarm"
echo "  source .venv/bin/activate"
echo "  ./run_rl_swarm.sh"
echo ""
echo "Veya Docker ile:"
echo "  docker compose run --rm --build -Pit swarm-gpu"
echo ""
