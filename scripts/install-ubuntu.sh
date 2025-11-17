#!/bin/bash

# RL-Swarm Türkçe Kurulum Script'i - Ubuntu/Linux
# Bu script gerekli tüm bağımlılıkları yükler ve RL-Swarm'ı kurar

set -e

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║          RL-Swarm Otomatik Kurulum (Ubuntu/Linux)             ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

# Renk tanımları
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_step() {
    echo -e "${BLUE}[ADIM $1]${NC} $2"
}

print_success() {
    echo -e "${GREEN}[BAŞARILI]${NC} $1"
}

print_error() {
    echo -e "${RED}[HATA]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[UYARI]${NC} $1"
}

# 1. Sistem güncellemesi
print_step "1" "Sistem paketleri güncelleniyor..."
sudo apt update && sudo apt upgrade -y
print_success "Sistem güncellemeleri tamamlandı"

# 2. Temel araçlar
print_step "2" "Temel araçlar yükleniyor..."
sudo apt install -y screen curl iptables build-essential git wget lz4 jq make \
    gcc nano automake autoconf tmux htop nvme-cli libgbm1 pkg-config \
    libssl-dev libleveldb-dev tar clang bsdmainutils ncdu unzip
print_success "Temel araçlar yüklendi"

# 3. Python kurulumu
print_step "3" "Python3 ve pip yükleniyor..."
sudo apt install -y python3 python3-pip python3-venv python3-dev
python3 --version
print_success "Python3 kuruldu"

# 4. Node.js kurulumu
print_step "4" "Node.js ve Yarn yükleniyor..."
sudo apt update
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo bash -
sudo apt install -y nodejs
node -v
npm -v

# Yarn yükleme
echo "Yarn yükleniyor..."
curl -o- -L https://yarnpkg.com/install.sh | bash
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
echo 'export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
print_success "Node.js ve Yarn kuruldu"

# 5. Docker kurulumu (isteğe bağlı)
print_step "5" "Docker yüklemek istiyor musunuz? (y/n)"
read -r docker_choice
if [[ $docker_choice == "y" || $docker_choice == "Y" ]]; then
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker $USER
    print_success "Docker kuruldu"
else
    print_warning "Docker atlandı"
fi

# 6. NVIDIA kontrolleri (GPU kullanıcıları)
print_step "6" "NVIDIA GPU yüklü mü kontrol ediliyor..."
if command -v nvidia-smi &> /dev/null; then
    print_success "NVIDIA GPU bulundu"
    nvidia-smi
else
    print_warning "NVIDIA GPU bulunamadı. CPU-only modda çalışacaksınız"
fi

# 7. RL-Swarm repository'si klonlama
print_step "7" "RL-Swarm repository'si klonlanıyor..."
if [ -d "rl-swarm" ]; then
    print_warning "rl-swarm dizini zaten mevcut, atlanıyor"
else
    git clone https://github.com/gensyn-ai/rl-swarm/
    print_success "Repository klonlandı"
fi

# 8. Python sanal ortamı oluşturma
print_step "8" "Python sanal ortamı oluşturuluyor..."
cd rl-swarm
python3 -m venv .venv
print_success "Sanal ortam oluşturuldu"

# 9. Bağımlılıklar yükleme
print_step "9" "Python bağımlılıkları yükleniyor..."
source .venv/bin/activate
echo "Kurulum tamamlandı!"

echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║                    KURULUM TAMAMLANDI!                         ║"
echo "╠════════════════════════════════════════════════════════════════╣"
echo "║  RL-Swarm'ı başlatmak için şu komutları çalıştırın:            ║"
echo "║                                                                ║"
echo "║  $ cd rl-swarm                                                 ║"
echo "║  $ source .venv/bin/activate                                   ║"
echo "║  $ ./run_rl_swarm.sh                                           ║"
echo "║                                                                ║"
echo "║  VEYA Docker ile:                                              ║"
echo "║  $ docker compose run --rm --build -Pit swarm-gpu             ║"
echo "║                                                                ║"
echo "║  Daha fazla bilgi: https://github.com/gensyn-ai/rl-swarm     ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""
