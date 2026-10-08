# AdAstra

> 一个 2D 像素平台跳跃游戏：目前有7个关卡+结算关，围绕**冲刺、传送、金币解谜、游泳与追逐**展开。完整项目将包含14个关卡，每个关卡都有不同的机制和挑战，主题围绕向上攀登知道抵达天穹。

本项目为 OUC 社团爱特工作室游戏部 2026 国庆考核作业，使用 **Godot 4.7** 开发，项目原型（<https://git.itouc.cn/ITStudio_OUC/GameHomework/issues/3>）美术来自 Kenney 的 *Pixel Platformer* 素材集（CC0），实际游戏美术素材为原创素材。

---

## 玩法特色

> 基于已实现功能介绍

- **冲刺（Dash）**：在 0.3 秒内双击 `A` / `D`，水平速度瞬间提升到 400（普通移动速度为 75），是跨越宽沟的核心手段。
- **金币门**：拾取金币累积计数，当金币数达到某个门的要求（`GoldNeeded`）时，金币门自动消失，为玩家开路。第 3、4、5 关都围绕这一机制设计。
- **传送门**：踩上 `transportTile` 后按 `E`，传送到 `self_id` / `target_id` 配对的另一扇传送门，两端各有 0.3 秒冷却防止来回抖动。
- **游泳**：进入水域后重力与跳跃被替换为 W/S 的匀速上浮/下潜，操控手感与陆地完全不同。
- **追逐敌人**：敌人以 30 的速度持续朝玩家水平靠近，碰到玩家即判定死亡（仅第 7 关使用）。
- **告示牌引导**：关卡内放置 Guide 告示牌，玩家靠近后按 `E` 显示提示文字（第一关为操作引导，第二关提示 `D + D` 冲刺）。
- **死亡与过关转场**：死亡或过关时暂停整棵场景树，播放幕布转场动画，动画结束后重载当前关或进入下一关。

## 操作

| 操作 | 按键 | 输入动作 |
| --- | --- | --- |
| 左移 / 右移 | `A` / `D` | `move_left` / `move_right` |
| 跳跃 | `W` 或 `Space` | `jump` |
| 下潜 | `S` | `squat` |
| 互动（传送、看告示牌） | `E` | `interact` |
| 冲刺 | 快速双击 `A` 或 `D` | —（由脚本判定双击间隔） |

## 关卡

| 关卡 | 场景文件 | 主要新元素 |
| --- | --- | --- |
| 第 1 关 | `scenes/prefabs/level/level_01.tscn` | 移动、跳跃、告示牌引导、传送门 |
| 第 2 关 | `scenes/prefabs/level/level_02.tscn` | 冲刺（`D + D`） |
| 第 3 关 | `scenes/prefabs/level/level_03.tscn` | 金币与金币门（7 枚金币） |
| 第 4 关 | `scenes/prefabs/level/level_04.tscn` | 金币门组合（8 枚金币） |
| 第 5 关 | `scenes/prefabs/level/level_05.tscn` | 金币门（5 枚金币） |
| 第 6 关 | `scenes/prefabs/level/level_06.tscn` | 综合地形 |
| 第 7 关 | `scenes/prefabs/level/level_07.tscn` | 追逐敌人 |
| 结算关 | `scenes/prefabs/level/level_end.tscn` | “胜利 你完成了所有关卡” |

关卡顺序硬编码在 `scripts/level_container.gd` 的 `SceneList` 中，`level_template.tscn` 为新关卡模板，`level_test.tscn` 为测试场景（含敌人）。

## 运行方式

**直接玩打包版本**（无需引擎）：解压 `release/AdAstra-0.2.0.zip`，运行其中的 `release-0.2.0.exe`。`release/0.1.0/` 与 `release/0.2.0/` 下同时保留了 exe 与 pck。

**用编辑器打开**：

1. 安装 Godot **4.7**（本项目使用 Forward+ 渲染器）。
2. 用 Godot 导入本目录下的 `project.godot`，主场景为 `res://scenes/main.tscn`，按 F5 运行。

## 项目结构

``` text
AdAstra/
├── project.godot              # 工程配置：渲染器、窗口、输入映射、物理层
├── transition.gdshader        # 幕布转场着色器
├── icon.svg                   # 工程图标
├── LICENSE_KENNEY.txt         # 美术素材授权（Kenney, CC0）
├── assets/game/               # 像素美术素材
│   ├── backgrounds/           # 背景、幕布
│   ├── characters/            # 玩家、敌人、死亡姿态
│   ├── collectibles/          # 金币
│   ├── interactables/         # 门、告示牌
│   ├── structures/            # 地形与机关贴图
│   └── tilesets/              # tilemap.png 图集与 tileset.tres
├── scenes/
│   ├── main.tscn              # 主场景：AnimationController（幕布）+ LevelContainer
│   └── prefabs/
│       ├── level/             # 7 个关卡 + 结算 + 模板 + 测试场景
│       ├── characters/        # player.tscn、enemy.tscn
│       ├── collectibles/      # coin.tscn
│       ├── interactables/     # gate.tscn、guide.tscn
│       └── structures/        # 各类机关小块
└── scripts/                   # GDScript 逻辑
```

### 核心脚本

| 脚本 | 职责 |
| --- | --- |
| `scripts/level_container.gd` | 关卡加载、按序切关、死亡重开，并重置金币/钥匙计数 |
| `scripts/eventbus.gd` | 全局事件总线（自动加载）：`PlayerReady`、`PlayerDied`、`level_finished`、`AnimationStarted/Finished`，以及 `gold` / `key` 计数 |
| `scripts/player_controller.gd` | 玩家移动、跳跃、冲刺、游泳、朝向与死亡 |
| `scripts/curtain.gd` | 幕布转场动画（监听死亡 / 出场 / 过关事件） |
| `scripts/enemy.gd` | 敌人水平追踪玩家，接触使其死亡 |
| `scripts/coin.gd` | 金币拾取，累加 `Eventbus.gold` |
| `scripts/gold_tile.gd` | 金币门：金币数达到 `GoldNeeded` 时自行消失 |
| `scripts/transport_tile.gd` | 成对传送门，按 `E` 传送并加冷却 |
| `scripts/water_tile.gd` | 水域进出，切换玩家 `swimming` 状态 |
| `scripts/danger_tile.gd` | 危险块，接触即死 |
| `scripts/guide.gd` | 告示牌：靠近后按 `E` 显示提示文字 |
| `scripts/gate.gd` | 终点门：玩家在范围内按 `E` 触发过关 |

### 机关预制体

| 预制体 | 类型 | 行为 |
| --- | --- | --- |
| `structures/gold_tile.tscn` | RigidBody2D | 金币门，达到金币门槛后消失 |
| `structures/danger_tile.tscn` | RigidBody2D | 接触死亡（`die()`） |
| `structures/transport_tile.tscn` | Area2D | 按 `E` 传送到 `target_id` 对应的门 |
| `structures/water_tile.tscn` | Area2D | 进入后切换为游泳状态 |
| `structures/water_surface_tile.tscn` | Area2D | 水面表现（单向碰撞） |
| `structures/cage_tile.tscn` / `lock_tile.tscn` | RigidBody2D | **未完成的机关**：笼子与锁，无脚本逻辑 |
| `collectibles/coin.tscn` | Area2D | 金币拾取 |
| `interactables/guide.tscn` | Area2D | 告示牌 |
| `interactables/gate.tscn` | Area2D | 过关门 |

`assets/game/tilesets/tileset.tres` 把上述机关注册为 **TileSetScenesCollectionSource**（可在 TileMapLayer 中直接刷场景块），并另含一个 18×18 的地形图集（`tilemap.png`，物理层 `layer_1 = building`）。

## 技术细节

- **引擎**：Godot 4.7，Forward+；Windows 下渲染驱动为 D3D12。
- **分辨率**：逻辑分辨率 468×270，窗口默认 2 倍缩放（936×540），拉伸模式 `canvas_items`；纹理过滤为最近邻，保证像素美术锐利。
- **物理层**：1 = building，2 = player，3 = arrow，4 = collective。
- **摄像机**：每个关卡的 `Player` 子节点上挂 `Camera2D`，并用 `limit_*` 限定在当前房间内，不做跟随边界外的镜头移动。
- **架构**：单场景 + 运行时换关（`LevelContainer` 动态实例化关卡并释放上一关），跨关卡通信统一走 `Eventbus` 自动加载，关卡之间零直接依赖。
- **音效**：当前没有音频资源。

## 素材与授权

- 美术：**Kenney — Pixel Platformer (1.2)**，CC0 公共领域授权，详见 `LICENSE_KENNEY.txt`。其余美术素材为原创素材。
- 引擎与脚本：Godot Engine 4.7 + GDScript。

## 后续计划

### 完整关卡

完整的AdAstra游戏由14个关卡组成，每个关卡都有不同的环境、敌人、机关等元素，分别对应十三个黄道星座和天穹。
14关卡及新增内容分别为：

1. 双鱼：基础教学与传送
2. 白羊：冲刺
3. 金牛：金币与金币门
4. 双子：同时控制多个玩家单位
5. 巨蟹：雾图块
6. 狮子：钥匙与钥匙门
7. 室女：黑暗环境与篝火
8. 天平：箱子
9. 天蝎：敌人
10. 蛇夫：笼子图块
11. 人马：攻击
12. 摩羯：水图块
13. 宝瓶：在万神殿（BOSS）的攻击下完成关卡
14. 天穹：与万神殿战斗

目前仅粗略实现了1、2、3、4、5、9、12关卡的机制，完整游戏内容等待后续拓展。

### 音效与菜单

尚无音频、无存档、无开始菜单；关卡顺序固定。后续会根据游戏需要添加音效与菜单。可能内置地图编辑器，用于自定义关卡。
