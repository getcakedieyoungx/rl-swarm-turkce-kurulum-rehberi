# Kurulum Script'leri

Bu dizin otomatik kurulum için Bash ve PowerShell script'lerini içerir.

## İçerik

- `install-ubuntu.sh` - Ubuntu/Linux için otomatik kurulum
- `install-windows.ps1` - Windows PowerShell için kurulum

## Kullanım

### Linux/Ubuntu

```bash
chmod +x scripts/install-ubuntu.sh
./scripts/install-ubuntu.sh
```

### Windows PowerShell

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
.\scripts\install-windows.ps1
```
