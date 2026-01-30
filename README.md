# 万古墨境：红尘渡 (WanGu: The Mortal Passage)

[![Flutter](https://img.shields.io/badge/Flutter-3.x-blue.svg)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-blue.svg)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

一个基于 Flutter 开发的文字修仙 MUD 游戏。
在这个世界里，你将扮演一名初入修真界的散修，通过探索、战斗、修炼，一步步从凡人蜕变为渡劫飞升的仙人。

## 🌟 游戏特色

### 1. 沉浸式文字体验
*   **纯粹的文字冒险**：摒弃繁杂的 3D 画面，回归文字 MUD 的本真，用想象力构建你的修仙世界。
*   **动态日志系统**：每一场战斗、每一次奇遇都有详细的文字记录，记录你的修仙生平。

### 2. 深度探索系统
*   **迷雾地图**：采用网格化地图探索机制，未探索区域被迷雾覆盖，每一步都充满未知。
*   **多样化地形**：宗门、竹林、溪谷、洞穴、遗迹...不同的地形孕育着不同的机缘与危险。
*   **随机事件**：行走江湖，可能偶遇前辈高人，也可能误入妖兽巢穴，全看机缘。

### 3. 策略战斗
*   **回合制战斗**：基于速度的回合制战斗系统，考验你的属性搭配。
*   **可视化战报**：战斗过程实时反馈，暴击、闪避、技能释放一目了然。
*   **多样化敌人**：从狂暴野猪到赤炎虎王，每种敌人都有独特的属性和掉落。

### 4. 社交与 NPC
*   **鲜活的 NPC**：每个 NPC 都有自己的性格、身份和对话。
*   **互动系统**：你可以与 NPC 交谈获取情报，甚至（如果你足够大胆）对他们发起攻击。
*   **关系网**：你的行为会影响 NPC 对你的态度（开发中）。

### 5. 核心机制：浊气与灵气 (New!)
*   **博弈循环**：修仙本是逆天而行。纳气修炼虽然能快速提升修为，但也会吸入天地浊气（毒素）。
*   **纯度决定生死**：灵气纯度直接影响突破成功率。纯度太低强行突破，轻则修为倒退，重则身死道消。
*   **多样化选择**：是选择"静坐修炼"稳扎稳打，还是"深度闭关"追求速度？是花费时间"运功排毒"，还是寻找灵丹妙药洗髓伐骨？

### 6. 修炼与成长
*   **境界体系**：还原经典的修仙境界（炼气、筑基...），每个大境界包含 10 个小境界（层）。
*   **突破挑战**：小境界突破相对容易，大境界突破则需要天时地利人和（特定道具、极高纯度）。
*   **属性养成**：气血、神识、攻击、防御、身法、悟性，六大维度自由发展。

### 7. 突破失败惩罚机制 (New!)
*   **代价高昂**：突破不再是简单的“成功或重试”。失败将带来实质性的后果，根据纯度和运气决定惩罚等级。
*   **肉身异变**：可能遭受雷劫导致**肢体残缺**（攻击下降）、**五感尽失**（神识受损）、甚至血脉逆行导致**半妖化**（属性剧变）。
*   **命运转折**：可能**阴阳逆转**（性别改变）、**虚空流放**（传送至高危区域）、或者遭遇**仇家锁定**（即时战斗）。
*   **资源危机**：可能导致**储物袋炸裂**（物品丢失）、**本命法宝反噬**（失去武器）、甚至**道侣断义**（精神重创）。

### 8. 系统功能 (New!)
*   **数据持久化**：支持随时保存和读取游戏进度，本地存储，离线可玩。
*   **多主题支持**：内置明亮/暗黑主题，可跟随系统或手动切换，保护你的视力。
*   **完备的设置**：重置游戏、清除存档、关于游戏等功能一应俱全。

## 🛠️ 技术栈

*   **框架**: Flutter (Dart)
*   **状态管理**: Provider
*   **数据存储**: shared_preferences
*   **动画**: flutter_animate
*   **架构**: MVVM (Model-View-ViewModel) / Repository Pattern
*   **图标**: Material Design Icons

## 📂 项目结构

```
lib/
├── src/
│   ├── data/           # 数据仓库 (Repositories)
│   │   ├── items_repository.dart
│   │   ├── enemies_repository.dart
│   │   ├── maps_repository.dart
│   │   └── npcs_repository.dart
│   ├── models/         # 数据模型 (Models)
│   │   ├── player.dart
│   │   ├── stats.dart
│   │   ├── realm_stage.dart
│   │   ├── enemy.dart
│   │   ├── item.dart
│   │   ├── map_node.dart
│   │   └── npc.dart
│   ├── state/          # 状态管理 (Providers)
│   │   └── game_state.dart
│   ├── ui/             # 界面 (Views)
│   │   ├── home/
│   │   │   ├── sections/   # 主要功能区 (Map, Inventory, Stats, Cultivate)
│   │   │   └── widgets/    # 通用组件 (BattleOverlay, BreakthroughOverlay, etc.)
│   │   └── ...
│   └── utils/          # 工具类
└── main.dart           # 入口文件
```

## 🚀 快速开始

1.  **环境准备**：确保已安装 Flutter SDK (推荐 3.10+)。
2.  **克隆项目**：
    ```bash
    git clone https://github.com/your-username/WanGu.git
    cd WanGu
    ```
3.  **安装依赖**：
    ```bash
    flutter pub get
    ```
4.  **运行游戏**：
    ```bash
    flutter run
    ```

## 📅 开发路线图 (Roadmap)

- [x] **P0: 基础框架**
    - [x] 角色创建与基础属性
    - [x] 物品背包系统
    - [x] 基础地图探索 (Grid + Fog of War)
    - [x] 基础战斗系统 (1v1)

- [x] **P0: 社交与 NPC**
    - [x] NPC 数据模型与仓库
    - [x] 地图 NPC 展示 (Avatar Bar)
    - [x] NPC 交互弹窗 (交谈/查看/攻击)

- [x] **P1: 核心机制 (Current Focus)**
    - [x] 境界体系细化 (10层/阶)
    - [x] 浊气与灵气系统 (Risk/Reward)
    - [x] 突破动画与视觉反馈
    - [x] 基础修炼循环 (修炼/排毒)

- [ ] **P2: 进阶玩法**
    - [ ] 功法与技能系统
    - [ ] 装备强化与词条
    - [ ] 宗门设施建设 (炼丹房/炼器室)
    - [ ] 更多随机事件

- [ ] **P3: 活着的修仙界**
    - [ ] NPC 关系网与动态复仇
    - [ ] 世界传闻系统
    - [ ] 化凡历练玩法

## 🤝 贡献指南

欢迎任何形式的贡献！无论是提交 Bug、建议新功能，还是直接提交代码 (PR)。

1.  Fork 本仓库
2.  创建你的特性分支 (`git checkout -b feature/AmazingFeature`)
3.  提交你的修改 (`git commit -m 'Add some AmazingFeature'`)
4.  推送到分支 (`git push origin feature/AmazingFeature`)
5.  开启一个 Pull Request

## 📄 许可证

本项目采用 MIT 许可证 - 详情请见 [LICENSE](LICENSE) 文件。
