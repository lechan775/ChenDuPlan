# 🚀 开源 | 我用 HarmonyOS + Spring Boot 写了一个全栈背单词 App，已上架 GitHub

> **晨读计划 (ChenDu Plan)** — 面向 CET-4/6、考研党的鸿蒙背单词应用，前后端完整开源，MIT 协议。

---

## 为什么又造了一个"背单词轮子"？

市面上的背单词 App 要么广告多到怀疑人生，要么词书老旧、UI 臃肿。作为一个同时搞 CV 科研 + 工程落地的人，我需要一个：

- ✅ **干净**：无广告、无社交、纯粹背词
- ✅ **可定制**：能自己加词库、改交互逻辑
- ✅ **全栈可控**：前端 UI + 后端 API + 数据库，三端代码全在自己手里
- ✅ **鸿蒙原生**：不套壳 WebView，纯 ArkTS/ArkUI 实现

于是就有了 **晨读计划**。

---

## 📱 运行效果一览

### 登录 & 主页

| 登录 | 注册 | 背词首页 |
|---|---|---|
| ![login](https://cdn.jsdelivr.net/gh/lechan775/ChenDuPlan@master/docs/screenshots/login.png) | ![register](https://cdn.jsdelivr.net/gh/lechan775/ChenDuPlan@master/docs/screenshots/register.png) | ![quiz](https://cdn.jsdelivr.net/gh/lechan775/ChenDuPlan@master/docs/screenshots/home_quiz.png) |

### 核心功能页

| 词书切换 | 背词练习 | 个人中心 |
|---|---|---|
| ![books](https://cdn.jsdelivr.net/gh/lechan775/ChenDuPlan@master/docs/screenshots/home_books.png) | ![practice](https://cdn.jsdelivr.net/gh/lechan775/ChenDuPlan@master/docs/screenshots/studypractice.png) | ![profile](https://cdn.jsdelivr.net/gh/lechan775/ChenDuPlan@master/docs/screenshots/home_profile.png) |

### 学习工具

| 生词本 | 错题本 |
|---|---|
| ![notebook](https://cdn.jsdelivr.net/gh/lechan775/ChenDuPlan@master/docs/screenshots/notebook.png) | ![wrongbook](https://cdn.jsdelivr.net/gh/lechan775/ChenDuPlan@master/docs/screenshots/wrongbook.png) |

---

## 🏗 技术架构

```
┌─────────────────────────┐     ┌────────────────────────────┐
│  HarmonyOS ArkUI 前端    │────▶│  Spring Boot REST API      │
│  ArkTS · 7 页面         │     │  11 Controller · 22 端点    │
│  @kit.NetworkKit        │     │  MyBatis · MySQL 8.0       │
└─────────────────────────┘     └────────────────────────────┘
```

| 层 | 技术栈 |
|---|---|
| 前端 | HarmonyOS ArkTS + ArkUI 声明式 UI |
| 后端 | Spring Boot 4.0.5 + Java 17 + MyBatis 4.0.1 |
| 数据库 | MySQL 8.0 · 8 张业务表 · utf8mb4 |
| API | RESTful JSON 统一 `{code, message, data}` 格式 |

---

## ✨ 核心特性

### 🔤 背词引擎

- **3 本词书**：四级 / 六级 / 考研核心词汇，每本 300 词
- **四选一答题**：单词 + 音标 + 释义，四个选项点击作答
- **即时反馈**：选对高亮绿色，选错标红，正确答案自动展示
- **双模式**：新学模式（顺序出题）+ 复习模式（回顾已学）
- **单词详情**：点击展开记忆技巧 + 英文例句 + 中文翻译

### 📊 学习追踪

- 累计学习词数 / 连续打卡天数 / 正确率 实时统计
- **月日历打卡视图**：学习日橙色圆点，今日蓝色高亮
- 每日学习流水：新学数、复习数、正确率、学习时长

### 📝 错词 & 生词管理

- **错题本**：答错自动入库，记录错误次数 + 答错句子 + 错误原因
- **生词本**：一键收藏，支持自定义笔记 + 掌握度标签 + 下次复习日期

### 🔐 用户系统

- 注册/登录（SHA-256 密码哈希）
- 个人资料编辑（昵称/每日目标/签名/默认词书）

---

## 🗄 数据库设计

8 张业务表，以 `users` 和 `books` 为中心：

![ER Diagram](https://cdn.jsdelivr.net/gh/lechan775/ChenDuPlan@master/er_diagram_ppt.png)

| 表 | 职责 |
|---|---|
| `users` | 用户账户 + 学习统计 |
| `books` | 词书元数据（CET-4 / CET-6 / 考研） |
| `words` | 单词库（900+ 词） |
| `user_books` | 用户-词书多对多 + 进度追踪 |
| `study_records` | 每日学习记录 |
| `notebook_words` | 生词本 |
| `wrong_words` | 错题本 |
| `sign_records` | 签到打卡 |

---

## 📡 API 一览

| 方法 | 端点 | 说明 |
|---|---|---|
| `POST` | `/api/auth/register` | 注册 |
| `POST` | `/api/auth/login` | 登录 |
| `GET` | `/api/user/profile` | 个人信息 |
| `GET` | `/api/books/progress` | 词书进度 |
| `GET` | `/api/words/next` | 获取下一个单词 |
| `POST` | `/api/study/submit` | 提交答题结果 |
| `GET` | `/api/stats/overview` | 学习统计 |
| `POST` | `/api/sign` | 每日签到 |
| ... | ... | **共 22 个端点** |

---

## ⚡ 快速上手

### 环境

- DevEco Studio（HarmonyOS SDK）
- JDK 17+ / MySQL 8.0+ / Maven 3.6+

### 后端启动（3 步）

```bash
# 1. 初始化数据库
mysql -u root -p < demo_backend/src/main/resources/db/init_words_demo.sql

# 2. 配置环境变量
cp .env.example .env   # 编辑填入数据库密码

# 3. 启动
cd demo_backend && mvn spring-boot:run
# → http://localhost:8080
```

### 前端启动

1. DevEco Studio 打开 `demo/` 目录
2. 修改 `ApiConfig.ets` 中的后端地址
3. 启动模拟器或连接真机

**测试账号**：`demo_user` / `123456`

---

## 🤝 社区协作

项目采用 **MIT 开源协议**，已搭建完整的开源协作基础设施：

- ✅ 中/英/日 **多语言 README**
- ✅ GitHub Actions **CI 自动构建**
- ✅ Swagger/OpenAPI **在线文档**
- ✅ 12 个 **Good First Issues** 供新手认领
- ✅ 核心团队 2 人，**持续招募贡献者**

### 贡献者

| 角色 | GitHub |
|---|---|
| 项目负责人 & 架构师 | [@lechan775](https://github.com/lechan775) |
| 核心开发者 | [@tingnuanx](https://github.com/tingnuanx) |

---

## 🔗 链接

| 平台 | 地址 |
|---|---|
| 🌟 **GitHub 仓库** | [github.com/lechan775/ChenDuPlan](https://github.com/lechan775/ChenDuPlan) |
| 📄 **Swagger 文档** | `http://localhost:8080/swagger-ui.html` |
| 📋 **Issue 面板** | [github.com/lechan775/ChenDuPlan/issues](https://github.com/lechan775/ChenDuPlan/issues) |
| 🏷️ **v0.1.0 Release** | [github.com/lechan775/ChenDuPlan/releases](https://github.com/lechan775/ChenDuPlan/releases) |

---

## 📮 关于我

**蒋国伟 (Guowei Jiang)**，湖南理工学院信息科学与工程学院研究生，研究方向为计算机视觉与 AI 基础设施。长期关注轻量级模型部署、无人机视觉、开源工程化。

- 🐙 GitHub: [@lechan775](https://github.com/lechan775)
- 📫 Email: untapped-word-fit@duck.com
- 🔬 代表作: StarNet-Pose（Neurocomputing 在投）、BSDPose（羽毛球姿态检测）

---

> **如果这个项目对你有帮助，欢迎去 GitHub 点个 ⭐ Star，这对我非常重要！**  
> 有任何问题或想法，直接提 Issue，我看到就会回复。
