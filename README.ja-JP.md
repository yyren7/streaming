[English (EN)](./README.md) | [简体中文 (zh-CN)](./README.zh-CN.md) | [日本語 (ja-JP)](./README.ja-JP.md)

# Thinklet ストリーミングドキュメントナビゲーション

Thinklet ストリーミングシステムへようこそ！このドキュメントは、必要な情報を素早く見つけるのに役立ちます。

## 🚀 クイックスタート

初めて使用する場合は、以下の順序でお読みください：

1.  **[QUICK-START.md](./docs/QUICK-START.md)** ⭐ 最も推奨
    *   3ステップでストリーミング環境を起動
    *   環境要件のチェックリストを含む
    *   `Start-Streaming-Rancher.bat` を使用してワンクリックで起動

2.  **[README-streaming.md](./docs/README-streaming.md)**
    *   詳細な技術ドキュメント
    *   完全な機能説明
    *   高度な設定オプション

## 📚 ドキュメントインデックス

### 基本設定

*   **[QUICK-START.md](./docs/QUICK-START.md)**
    クイックスタートガイド、すべてのユーザーが最初に読むことをお勧めします。

*   **[README-streaming.md](./docs/README-streaming.md)**
    ストリーミングシステムの完全なドキュメントで、以下を含みます：
    *   Rancher Desktop の設定手順
    *   マルチデバイスストリーミングのサポート
    *   SRS サーバーの詳細な設定
    *   トラブルシューティングガイド

### デバイス設定

*   **[ANDROID-CONNECTION-GUIDE.md](./docs/ANDROID-CONNECTION-GUIDE.md)**
    Android デバイス接続設定ガイドで、以下を含みます：
    *   RTMP URL の設定
    *   ネットワーク診断手順
    *   一般的な接続問題の解決策

### ファイル転送

*   **[FILE-TRANSFER-README.md](./docs/FILE-TRANSFER-README.md)**
    自動ビデオファイル転送機能のユーザーガイドで、以下を含みます：
    *   非常に低消費電力のファイル転送ソリューション
    *   自動ダウンロードと MD5 チェックサム検証
    *   Web インターフェースの操作説明

*   **[file-transfer-design.md](./docs/file-transfer-design.md)**
    ファイル転送機能の技術設計ドキュメント（開発者向け）。

## 📂 フォルダ構造

```
streaming/
├── 📄 README.md                      # メインナビゲーションドキュメント（このドキュメント）
├── 📄 package.json                   # Node.js プロジェクト設定
├── 📄 package-lock.json              # 依存関係ロックファイル
│
├── 🚀 Start-Streaming-Rancher.bat    # ワンクリック起動スクリプト ⭐
├── 🔧 start-streaming-rancher.ps1    # コア PowerShell スクリプト
│
├── 📂 docs/                          # ドキュメントディレクトリ
│   ├── QUICK-START.md               # クイックスタートガイド ⭐
│   ├── README-streaming.md          # 詳細な技術ドキュメント
│   ├── ANDROID-CONNECTION-GUIDE.md  # Android 設定ガイド
│   ├── FILE-TRANSFER-README.md      # ファイル転送機能ドキュメント
│   └── file-transfer-design.md      # 技術設計ドキュメント
│
├── 📂 src/                           # ソースコードディレクトリ
│   ├── simple-http-server.js        # HTTP/WebSocket サーバー
│   ├── file-transfer-service.js     # ファイル転送サービス
│   ├── i18n.js                      # 国際化
│   └── main.js                      # フロントエンドメインスクリプト
│
├── 📂 public/                        # Web アセットディレクトリ
│   ├── index.html                   # Web インターフェース
│   └── style.css                    # スタイルシート
│
├── 📂 config/                        # 設定ファイルディレクトリ
│   ├── docker-compose.yml           # Docker Compose 設定
│   ├── srs.conf                     # SRS サーバー設定
│   └── devices.json                 # デバイス情報ストレージ（自動生成）
│
├── 📂 video/                         # ビデオファイルストレージディレクトリ
│   └── {deviceId}/                  # デバイスごとにグループ化されたビデオ
│
└── 📂 node_modules/                  # Node.js 依存関係（自動生成）
```

## 🔧 コアスクリプト

### Windows 起動スクリプト

*   **`Start-Streaming-Rancher.bat`** ⭐ 推奨
    *   自動的に管理者権限を要求
    *   すべてのサービス（SRS, Node.js）をワンクリックで起動
    *   ネットワークとファイアウォールを自動設定
    *   起動前に古いプロセスをクリーンアップ

*   **`start-streaming-rancher.ps1`**
    *   コア PowerShell スクリプト
    *   `.bat` ファイルから自動的に呼び出される
    *   すべてのサービスの起動、チェック、ネットワーク設定を担当

## ⚙️ 環境要件

### 必須ソフトウェア

1.  **Rancher Desktop** (推奨) または **Docker Desktop**
    *   ダウンロード：https://rancherdesktop.io/
    *   ⚠️ 重要：WSL 内に手動で Docker をインストールしないでください

2.  **WSL 2** (Windows Subsystem for Linux 2)
    *   Ubuntu または他の Linux ディストリビューションのインストールが必要
    *   `wsl -l -v` でバージョンを確認

3.  **Node.js** (v16 以上)
    *   ダウンロード：https://nodejs.org/

### Rancher Desktop の設定（重要なステップ）

1.  Rancher Desktop を開く
2.  **Preferences → WSL** に移動
3.  ✅ WSL ディストリビューション（例：`Ubuntu`）をチェック
4.  ❌ `rancher-desktop` または `rancher-desktop-data` をチェックしない
5.  保存して再起動を待つ

### 設定の確認

Ubuntu WSL ターミナルで実行：
```bash
docker --version
```

表示されるはずです：
```
Docker version 28.3.3-rd, build 309deef
```

`-rd` サフィックスに注意してください。これは Rancher Desktop が提供する Docker を使用していることを示します。

## 🎯 使用フロー

### 1. 初回インストール

```bash
# streaming ディレクトリで
npm install
```

### 2. サービスの開始

`Start-Streaming-Rancher.bat` をダブルクリックし、「はい」をクリックして管理者権限を付与します。

### 3. Android アプリの設定

`app/src/main/java/ai/fd/thinklet/app/squid/run/DefaultConfig.kt` で設定：

```kotlin
const val DEFAULT_STREAM_URL = "rtmp://YOUR-PC-IP:1935/thinklet.squid.run"
const val DEFAULT_STREAM_KEY = "device1"
```

### 4. ストリーミングの開始

Android アプリで「ストリーミングを開始」をクリックし、ブラウザでアクセス：
```
http://YOUR-PC-IP:8000
```

## 🔍 クイックトラブルシューティングリファレンス

| 問題 | 解決策 |
|---|---|
| `docker` コマンドが見つからない | Rancher Desktop の WSL 統合設定を確認 |
| `rancher-desktop` エラーメッセージ | `Start-Streaming-Rancher.bat` を使用して開始 |
| Android が接続できない | PC と電話が同じ Wi-Fi ネットワーク上にあることを確認 |
| 再起動後に接続できない | `Start-Streaming-Rancher.bat` を再実行 |

詳細なトラブルシューティング手順については、各ドキュメントの「トラブルシューティング」セクションを参照してください。

## 📊 機能

### ストリーミング機能
- 🎥 低遅延ライブストリーミング（1〜3秒）
- 📱 複数デバイスからの同時ストリーミング
- 🎬 リアルタイムビデオプレビュー
- 📊 ストリームステータスモニタリング

### ファイル転送機能
- 🔋 超低消費電力（Android CPU < 5%）
- 🔄 再開可能な転送
- 🔐 MD5 整合性チェック
- 📊 リアルタイムの進捗表示
- ⚙️ 自動再試行メカニズム

## 🆘 ヘルプの入手

問題が発生した場合：

1.  [QUICK-START.md](./docs/QUICK-START.md) のトラブルシューティングセクションを確認
2.  [README-streaming.md](./docs/README-streaming.md) の詳細なトラブルシューティングを確認
3.  ターミナルとブラウザコンソールのログ出力を確認
4.  すべての環境要件が満たされていることを確認

## 📝 ドキュメント更新ログ

### 2025-10-06
- ✅ フォルダ構造の再編成（docs/, src/, public/, config/）
- ✅ 古い手動設定ドキュメントの削除
- ✅ 標準 Docker 環境として Rancher Desktop を強調
- ✅ 自動起動スクリプトを反映するようにすべてのドキュメントを更新
- ✅ 詳細な環境設定の検証手順を追加
- ✅ すべてのパス参照と依存関係を更新

---

**始めるには**：[QUICK-START.md](./docs/QUICK-START.md) をお読みください！🚀
