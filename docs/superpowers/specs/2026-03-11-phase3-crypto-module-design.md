# Phase 3: Crypto 模块设计

> 设计日期：2026-03-11
> 状态：已确认，待实施

---

## 一、概述

为 indie-finance-plugin 的 `crypto/` 子插件实现 4 个 skill + 4 个 command，覆盖代币分析、DeFi 协议分析、空投评估、链上数据查询。

### 架构决策

- 遵循 tradfi 已建立的模式：skill 是自动触发的 markdown 指令，command 是用户显式调用的入口
- Command 格式标准：含 `allowed-tools`、`$ARGUMENTS`、`!date`、workflow、quality checklist、skill reference
- 三层 fallback：MCP → Web Search → Chrome CDP

### MCP 数据源

| MCP Server | 来源 | 工具数 | 用途 |
|-----------|------|--------|------|
| **CoinGecko MCP** | 官方 `@coingecko/coingecko-mcp` | 76+ | 代币行情/FDV/市值/交易对/GeckoTerminal DEX 数据 |
| **DefiLlama MCP** | `@iqai/mcp-defillama` | 14 | TVL/DEX volumes/费用收入/Yield/代币价格 |
| **Dune MCP** | 官方 dune MCP (HTTP remote) | 11 | 链上 SQL 查询/表发现/文档搜索/可视化 |

**重要变更**：Dune MCP 从社区版（kukapay，2 工具，stdio）升级为官方版（11 工具，HTTP remote），支持表结构发现（`searchTables`）和文档搜索（`searchDocs`），使自然语言 → SQL 查询成为可能。

---

## 二、Skill 详细设计

### 2.1 token-analysis

**触发词**：token analysis, 代币分析, token fundamentals, tokenomics, 代币基本面

**数据源优先级**：
- Layer 1: coingecko MCP（主力，覆盖行情/代币经济学/交易对/DEX 数据）
- Layer 2: Web Search（解锁时间表、审计报告、项目文档）
- Layer 3: Chrome CDP（需登录的页面）

**输出结构**（Markdown）：

1. **基础数据**：价格/24h涨跌/市值/FDV/流通量占比/市值排名/24h交易量
2. **代币经济学**：总供给/流通供给/通胀通缩机制/代币分配/解锁时间表
3. **市场结构**：主要交易所和交易对/DEX vs CEX 交易量占比/持仓集中度
4. **技术面**：7d/30d/90d 价格走势/关键支撑阻力位/与 BTC/ETH 相关性
5. **风险标注**：合约地址验证/审计状态/监管风险

**文件结构**：
```
crypto/skills/token-analysis/
└── SKILL.md
```

### 2.2 defi-protocol

**触发词**：DeFi analysis, 协议分析, TVL analysis, yield analysis, DeFi 协议

**数据源优先级**：
- Layer 1 Primary: defillama MCP（主力，覆盖 TVL/交易量/费用/收益率）
- Layer 1 Secondary: coingecko MCP（代币数据/DEX 补充）
- Layer 2: Web Search（协议文档、审计报告）
- Layer 3: Chrome CDP

**输出结构**（Markdown）：

1. **核心指标**：TVL/TVL变化(7d/30d)/链分布/日交易量/费用收入
2. **多链部署**：各链 TVL 和交易量对比
3. **收益分析**：主要池子 APY 排名/稳定池 vs 波动池/IL 风险提示
4. **竞品对比**：同赛道协议 TVL/交易量/费用对比，市值/TVL 比
5. **代币关联**：如有关联代币，引导使用 token-analysis skill

**文件结构**：
```
crypto/skills/defi-protocol/
└── SKILL.md
```

### 2.3 airdrop-eval

**触发词**：空投评估, airdrop evaluation, 项目评分, airdrop scoring, 空投分析

**数据源优先级**：
- Layer 1: coingecko MCP（代币信息，如已发币）
- Layer 1: defillama MCP（TVL 趋势）
- Layer 2: Web Search（融资背景/团队/社区/积分机制/官方公告）
- Layer 3: Chrome CDP（官网/文档/Discord）

**工作流**：
1. 用户输入项目名称
2. 自动拉取可获取的数据
3. 基于数据预填六维度评分建议 + 依据
4. 用户确认/调整评分
5. 输出 P-xxx 格式报告

**输出格式**（严格对齐 P-xxx 模板）：

```markdown
> 评分口径：0–5 分（5=最好/最优），总分 30
> 说明：本表仅基于公开信息；其中"审计/规则细节/法域限制"等仍存在未验证项。

## 一、六维度评分（0–5）

| 维度 | 分数 | 关键依据 | 主要扣分点/不确定性 |
|------|------|---------|-----------------|
| 发币意愿（总包潜力/分配机制/规则稳定性） | **X** | | |
| 自己能否收获足够筹码（与自身优势匹配） | **X** | | |
| 增长与可持续性 | **X** | | |
| 单位成本（资金利用率） | **X** | | |
| 暴击几率（竞争拥挤度/女巫影响） | **X** | | |
| 风险等级（KYC/监管/作恶/女巫规则） | **X** | | |

**总分：X / 30**

## 二、档位判定

| 档位 | 规则门槛 | 是否满足 | 结论 |
|------|---------|---------|-----|
| 专项冲刺 | 总分≥25 且 筹码≥4 且 风险≥4 | | |
| 中等维护 | 总分20-24 且 筹码≥3 且 风险≥4 | | |
| 低保维护 | 总分15-19 且 筹码≥2 且 风险≥3 | | |
```

**六维度评分框架详解**（放在 `references/scoring-framework.md`）：

| 维度 | 评分要点 | 自动数据辅助 |
|------|---------|------------|
| 发币意愿（总包潜力/分配机制/规则稳定性） | 是否有明确 tokenomics、发币时间线、积分系统 | 搜索官方公告、文档中的 tokenomics |
| 筹码获取（与自身优势匹配） | 参与机制是否匹配自身资源（资金/技术/时间） | 链上参与门槛、积分机制分析 |
| 增长与可持续性 | TVL 趋势、用户增长、融资背景、团队实力 | DefiLlama TVL、社区规模、融资信息 |
| 单位成本（资金利用率） | 参与所需资金量、Gas 费、时间投入 | Gas 费估算、最低参与门槛 |
| 暴击几率（竞争拥挤度/女巫影响） | 参与人数、拥挤程度、女巫风险 | 地址数趋势、社区讨论热度 |
| 风险等级（KYC/监管/作恶/女巫规则） | 合约审计、团队透明度、监管风险 | 审计状态、合约权限分析 |

**档位判定规则**：
- Sprint（专项冲刺）: total >= 25 AND 筹码 >= 4 AND 风险 >= 4
- 中等维护: total 20-24 AND 筹码 >= 3 AND 风险 >= 4
- 低保维护: total 15-19 AND 筹码 >= 2 AND 风险 >= 3

**文件结构**：
```
crypto/skills/airdrop-eval/
├── SKILL.md
└── references/
    └── scoring-framework.md
```

### 2.4 onchain-query

**触发词**：链上查询, on-chain query, dune query, 链上数据, blockchain data

**数据源**：dune MCP（官方 11 工具）→ web search → Chrome CDP

**工作流**（自然语言 → SQL → 结果）：
1. 用户输入自然语言查询（如"Uniswap 过去7天的日活跃地址数"）
2. Claude 用 `listBlockchains` 确认目标链
3. Claude 用 `searchTables` 发现相关表（按协议/链/类别搜索）
4. Claude 用 `searchDocs` 学习表结构和示例 SQL
5. Claude 用 `createDuneQuery` 编写并保存 SQL 查询
6. Claude 用 `executeQueryById` + `getExecutionResults` 执行并获取结果
7. 格式化输出为 Markdown 表格
8. 可选：用 `generateVisualization` 生成图表

**预置查询快捷方式**（`references/preset-queries.md`）：
- ETH daily active addresses
- Top DEX by volume (7d)
- Stablecoin supply by chain
- L2 TVL comparison
- Gas price trends
- Top token holders by contract
- NFT marketplace volume comparison
- Bridge volume by chain

**文件结构**：
```
crypto/skills/onchain-query/
├── SKILL.md
└── references/
    └── preset-queries.md
```

---

## 三、Command 设计

所有 command 遵循 tradfi 已建立的格式标准。

### 3.1 `/crypto:token`

```yaml
description: 代币综合分析 — 行情/代币经济学/市场结构/技术面/风险
argument-hint: <symbol_or_name> [chain]
allowed-tools: mcp__coingecko__*, WebSearch, WebFetch
```

### 3.2 `/crypto:defi`

```yaml
description: DeFi 协议分析 — TVL/多链部署/收益分析/竞品对比
argument-hint: <protocol_name> [chain]
allowed-tools: mcp__defillama__*, mcp__coingecko__*, WebSearch, WebFetch
```

### 3.3 `/crypto:airdrop`

```yaml
description: 空投项目评估 — 六维度评分/档位判定/P-xxx 格式输出
argument-hint: <project_name>
allowed-tools: mcp__coingecko__*, mcp__defillama__*, WebSearch, WebFetch
```

### 3.4 `/crypto:onchain`

```yaml
description: 链上数据查询 — 自然语言转 Dune SQL，查询并格式化结果
argument-hint: <query_in_natural_language> | <dune_query_id>
allowed-tools: mcp__dune__*, WebSearch, WebFetch
```

---

## 四、基础设施变更

### 4.1 更新 `crypto/.mcp.json`

将 Dune MCP 从社区版替换为官方版：

```json
{
  "mcpServers": {
    "coingecko": {
      "type": "http",
      "command": "npx",
      "args": ["@coingecko/coingecko-mcp"]
    },
    "defillama": {
      "type": "stdio",
      "command": "npx",
      "args": ["@iqai/mcp-defillama"]
    },
    "dune": {
      "type": "http",
      "url": "https://api.dune.com/mcp/v1",
      "headers": { "X-DUNE-API-KEY": "${DUNE_API_KEY}" }
    }
  }
}
```

### 4.2 更新项目 CLAUDE.md

在 Crypto 模块数据源映射部分反映 Dune 官方 MCP 的 12 个工具能力。

---

## 五、文件清单

```
crypto/
├── .claude-plugin/plugin.json    # EXISTS
├── .mcp.json                     # MODIFY（升级 Dune MCP）
├── hooks/hooks.json              # EXISTS
├── commands/
│   ├── token.md                  # CREATE
│   ├── defi.md                   # CREATE
│   ├── airdrop.md                # CREATE
│   └── onchain.md                # CREATE
└── skills/
    ├── token-analysis/
    │   └── SKILL.md              # CREATE
    ├── defi-protocol/
    │   └── SKILL.md              # CREATE
    ├── airdrop-eval/
    │   ├── SKILL.md              # CREATE
    │   └── references/
    │       └── scoring-framework.md  # CREATE
    └── onchain-query/
        ├── SKILL.md              # CREATE
        └── references/
            └── preset-queries.md # CREATE
```

共 10 个文件需要创建，1 个文件需要修改。
