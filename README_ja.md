<div align="center">
  <p>
    <img width="100%" src="https://img.shields.io/badge/HarmonyOS-Next-FF6600?style=for-the-badge&logo=harmonyos&logoColor=white" alt="HarmonyOS Next">
  </p>

[English](README.md) | [简体中文](README_zh-CN.md) | **日本語**

<br>

<div>
    <a href="https://github.com/lechan775/ChenDuPlan/blob/main/LICENSE"><img src="https://img.shields.io/github/license/lechan775/ChenDuPlan" alt="License"></a>
    <img src="https://img.shields.io/badge/Spring%20Boot-4.0.5-6DB33F?logo=springboot&logoColor=white" alt="Spring Boot">
    <img src="https://img.shields.io/badge/Java-17-ED8B00?logo=openjdk&logoColor=white" alt="Java 17">
    <img src="https://img.shields.io/badge/MySQL-8.0-4479A1?logo=mysql&logoColor=white" alt="MySQL">
    <img src="https://img.shields.io/badge/ArkTS-HarmonyOS-FF6600?logo=harmonyos&logoColor=white" alt="ArkTS">
</div>
</div>
<br>

**ChenDu Plan（晨读計画）** は、HarmonyOS ArkUI + Spring Boot で構築されたフルスタック英単語学習アプリです。フロントエンドは ArkTS 宣言的 UI で直感的な学習体験を提供し、バックエンドは Spring Boot + MyBatis + MySQL で安定した RESTful API を提供します。

---

## 📖 概要

ChenDu Plan は大学生および大学院受験生向けの英単語学習ツールで、**CET-4（四級）、CET-6（六級）、大学院入試（考研）** の 3 冊の単語帳をカバーしています。コアとなる学習方式は **4 択クイズ**です。

- 🎯 スマート出題（新規学習モード／復習モード）
- 📊 学習進捗追跡（統計サマリー／カレンダー）
- 📝 間違えた単語の自動記録（エラー文・原因分析付き）
- 📌 単語帳への保存（カスタムノート・復習リマインダー）
- 🏆 単語帳ごとの学習進捗管理
- 🔐 ユーザー認証（登録／ログイン／プロフィール管理）

---

## 🏗 アーキテクチャ

| 層 | 技術スタック |
|---|---|
| フロントエンド | HarmonyOS ArkTS + ArkUI |
| バックエンド | Spring Boot 4.0.5 + Java 17 + MyBatis 4.0.1 |
| データベース | MySQL 8.0 (utf8mb4_unicode_ci) |
| API プロトコル | RESTful JSON（統一レスポンス形式 `{code, message, data}`） |

---

## 🚀 クイックスタート

### 必要条件
- DevEco Studio（HarmonyOS SDK）
- JDK 17+
- MySQL 8.0+
- Maven 3.6+

### データベース初期化
```bash
mysql -u root -p < demo_backend/src/main/resources/db/init_words_demo.sql
```

### バックエンド起動
```bash
cd demo_backend
mvn spring-boot:run
# デフォルトポート: http://localhost:8080
```

### フロントエンド起動
1. DevEco Studio で `demo/` を開く
2. `ApiConfig.ets` の `API_BASE_URL` をバックエンドアドレスに設定
3. エミュレータまたは実機で実行

テストアカウント: `demo_user` / `123456`

---

## 📡 API

| メソッド | エンドポイント | 説明 |
|---|---|---|
| `POST` | `/api/auth/register` | 新規登録 |
| `POST` | `/api/auth/login` | ログイン |
| `GET` | `/api/user/profile?userId=` | プロフィール取得 |
| `PUT` | `/api/user/profile` | プロフィール更新 |
| `GET` | `/api/books` | 単語帳一覧 |
| `GET` | `/api/books/progress?userId=` | 学習進捗 |
| `GET` | `/api/words/next?userId=&bookId=&mode=` | 次の単語を取得 |
| `POST` | `/api/study/submit` | 解答提出 |
| `GET` | `/api/study-records?userId=` | 学習記録 |
| `GET` | `/api/stats/overview?userId=` | 学習統計 |
| `GET` | `/api/notebook-words?userId=` | 単語帳 |
| `POST` | `/api/notebook-words` | 単語帳に追加 |
| `DELETE` | `/api/notebook-words/{id}` | 単語帳から削除 |
| `GET` | `/api/wrong-words?userId=` | 間違い単語一覧 |
| `DELETE` | `/api/wrong-words/{id}` | 間違い単語削除 |
| `GET` | `/api/sign/status?userId=` | チェックイン状態 |
| `POST` | `/api/sign` | 毎日チェックイン |
| `GET` | `/api/ping` | ヘルスチェック |

詳細は [README.md](README.md) を参照してください。

---

## 📁 プロジェクト構成

```
demo/                          # フロントエンド (HarmonyOS)
├── entry/src/main/ets/
│   ├── api/                   # HTTP クライアント
│   ├── data/                  # 状態管理
│   ├── pages/                 # 7 画面
│   └── utils/                 # ユーティリティ

demo_backend/                  # バックエンド (Spring Boot)
├── src/main/java/.../
│   ├── controller/            # 11 REST コントローラ
│   ├── service/               # ビジネスロジック
│   ├── mapper/                # MyBatis マッパー
│   ├── entity/                # エンティティ
│   └── dto/                   # DTO
└── src/main/resources/
    └── db/init_words_demo.sql # 初期化スクリプト
```

## 👥 コアチーム

| 役割 | 名前 | GitHub |
|---|---|---|
| プロジェクトリード | **Guowei Jiang** | [@lechan775](https://github.com/lechan775) |
| コア開発者 | **tingnuanx** | [@tingnuanx](https://github.com/tingnuanx) |

---

<div align="center">
  <p>Made with ❤️ by <a href="https://github.com/lechan775">lechan775</a> & <a href="https://github.com/tingnuanx">tingnuanx</a></p>
</div>
