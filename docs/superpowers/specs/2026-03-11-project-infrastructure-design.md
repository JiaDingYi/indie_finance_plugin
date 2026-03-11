# indie-finance-plugin 项目基建设计

> 日期：2026-03-11
> 状态：已确认

## 概述

为 indie-finance-plugin 创建项目基建，采用多插件市场架构（与 Anthropic 官方 financial-services-plugins 一致），包含四个子插件：tradfi、crypto、macro、portfolio。

## 架构决策

### 多插件市场 vs 单插件

**选择：多插件市场**

理由：
1. TradFi 和 Crypto 的 MCP 数据源天然分离，按需加载更合理
2. 用户可只安装感兴趣的模块
3. 与官方架构一致，降低后续迁移成本
4. macro 横跨两类数据源，独立为第三个插件

### 目录结构

```
indie-finance-plugin/
├── .claude-plugin/marketplace.json
├── .gitignore
├── CLAUDE.md
├── README.md
├── docs/plans/
│
├── tradfi/
│   ├── .claude-plugin/plugin.json
│   ├── .mcp.json                      # yahoo-finance, alpha-vantage, fmp
│   ├── commands/                      # comps.md, dcf.md, earnings.md, screen.md
│   ├── skills/                        # comps-analysis/, dcf-model/, earnings-analysis/,
│   │                                  # competitive-analysis/, clean-data-xls/
│   └── hooks/hooks.json
│
├── crypto/
│   ├── .claude-plugin/plugin.json
│   ├── .mcp.json                      # coingecko, defillama, dune
│   ├── commands/                      # token.md, defi.md, airdrop.md, onchain.md
│   ├── skills/                        # token-analysis/, defi-protocol/,
│   │                                  # airdrop-eval/, onchain-query/
│   └── hooks/hooks.json
│
├── macro/
│   ├── .claude-plugin/plugin.json
│   ├── .mcp.json                      # fred, defillama, coingecko
│   ├── commands/                      # macro.md
│   ├── skills/                        # macro-dashboard/, news-digest/
│   └── hooks/hooks.json
│
└── _reference/                        # 官方机构专用 skill（不激活）
```

### 数据源分配

| 子插件 | MCP 数据源 | 用途 |
|--------|-----------|------|
| tradfi | yahoo-finance | 股票行情/财报/新闻（无限制） |
| tradfi | alpha-vantage | 技术指标/电话会议（25次/天） |
| tradfi | financial-modeling-prep | SEC filing/DCF/分析师（250次/天） |
| crypto | coingecko | 代币行情/DEX 数据（30次/分） |
| crypto | defillama | TVL/DEX volumes/Yield（无限制） |
| crypto | dune | 链上 SQL 查询（55次/分） |
| macro | fred | 宏观经济数据（120次/分） |
| macro | defillama | 稳定币/全球加密市值 |
| macro | coingecko | BTC 相关性数据 |

### 基建文件清单

| 文件 | 来源 | 说明 |
|------|------|------|
| `.gitignore` | Fork 官方 + 补充 | OS/IDE/依赖/env/构建产物 |
| `.claude-plugin/marketplace.json` | 参照官方格式 | 3 个子插件入口 |
| `tradfi/.claude-plugin/plugin.json` | 参照官方 | 插件元数据 |
| `tradfi/.mcp.json` | 设计文档 | 3 个 TradFi 数据源 |
| `tradfi/hooks/hooks.json` | 官方 | 空数组 |
| `crypto/.claude-plugin/plugin.json` | 新建 | 插件元数据 |
| `crypto/.mcp.json` | 设计文档 | 3 个 Crypto 数据源 |
| `crypto/hooks/hooks.json` | 新建 | 空数组 |
| `macro/.claude-plugin/plugin.json` | 新建 | 插件元数据 |
| `macro/.mcp.json` | 设计文档 | 3 个宏观数据源 |
| `macro/hooks/hooks.json` | 新建 | 空数组 |
| `CLAUDE.md` | 新写 | 全局指引 |
| `README.md` | 新写 | 项目文档 |
| `_reference/README.md` | 新写 | 说明用途 |

### CLAUDE.md 内容规划

1. 项目概述（一段话）
2. 插件架构说明（三个子插件）
3. 三层 Fallback 策略（MCP → Web Search → Chrome）
4. 数据源-场景映射表
5. 输出格式规则（Excel/Markdown/对话内表格）
6. 命令总览表

### README.md 内容规划

1. 项目介绍 + 定位
2. 快速开始（安装/配置 API Key）
3. 子插件说明
4. 命令总览 + 示例
5. 数据源说明 + 限制
6. 目录结构
7. 开发计划（Phase 1-4）
