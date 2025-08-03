# my-server-infra
自宅鯖のインフラ構成 置き場

## Environment
- ドメイン `riya.monster`
- 自宅鯖 primary
  - CPU: 8 x Intel(R) Core(TM) i3-10105 CPU @ 3.70GHz
  - RAM: 32GB
  - Storage: 512GB SSD
  - OS: Proxmox VE 8
  - Network: Up/Down 1Gbps/2Gbps
- Cloudflare Tunnel
  - pve.riya.monster
    - Link to Proxmox VE 8
- Cloudflare Zero Trust
  - Authentication: Cloudflare Access
    - One-Time Pin by Email
    - Google OAuth2

## Security
- 基本的にCloudflare Zero Trustを利用して、Zero Trustな環境を構築している。
  - 現状、Google OAuth2とOne-Time Pinを利用して、Proxmox VEのWeb UIにアクセスしている。
  - TerraformでProxmox VEのAPIを叩く際には[Service Token](https://developers.cloudflare.com/cloudflare-one/identity/service-tokens/)を用いる
- Proxmox VEの認証にはCloudflare同様にGoogle OAuth2を導入している
  - 追加の認証として、Google AutnenticatorなどのOTPやWebAuthnも利用可能

## Requirements
前提として、
- Proxmox VEにCloudflare Tunnelが設定されていること。
  - Web UIが外部に公開されている
  - Proxmox VE 8のAPIにアクセスできないと、Terraformの実行ができない

## 現状の問題
- 自宅鯖 primaryのホストOSにCloudflare Tunnelの設定をしている
  - Non-IACなため事故ると手動で設定をやり直す必要がある
- Proxmox VEのAPIにアクセスするためのService TokenがCloudflare Zero Trustの認証を通過しない
