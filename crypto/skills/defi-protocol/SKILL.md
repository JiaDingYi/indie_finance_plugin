---
name: defi-protocol
description: |
  DeFi protocol analysis covering TVL, multi-chain deployment, yield analysis,
  and competitive comparison. Use when the user asks to analyze a DeFi protocol,
  check TVL, compare yields, evaluate a DEX/lending/bridge protocol, or asks about
  protocol metrics. Triggers on "DeFi analysis", "协议分析", "TVL analysis",
  "yield analysis", "DeFi 协议", "protocol comparison", or "[protocol] TVL".
---

# DeFi Protocol Analysis

对 DeFi 协议进行综合分析，覆盖 TVL、多链部署、收益分析和竞品对比。

## Data Source Priority

### Layer 1 Primary: MCP
- **defillama** — TVL/交易量/费用收入/收益率/链分布

### Layer 1 Secondary: MCP
- **coingecko** — 协议代币数据/DEX 补充数据(GeckoTerminal)

### Layer 2: Chrome CDP
- 需登录的页面

### Layer 3: Web Search
- 协议文档、审计报告、治理提案

每个数据点标注 "Source: [source name]"。

## Workflow

### Step 1: Identify Protocol
- 解析协议名称，通过 defillama 搜索确认
- 确定协议类别：DEX/借贷/桥/收益聚合/流动性质押/其他
- 确认协议的 defillama slug

### Step 2: Fetch Core Metrics
通过 defillama MCP 获取：
- 当前 TVL（USD 计价）
- TVL 变化：7d/30d
- 链分布（各链 TVL）
- 日交易量（如适用）
- 费用/收入（如可获取）

### Step 3: Fetch Yield Data
通过 defillama MCP 获取：
- 主要池子 APY 排名
- 稳定池 vs 波动池收益对比
- IL（无常损失）风险提示

### Step 4: Fetch Competitors
通过 defillama MCP 获取同类协议：
- 同赛道 TVL 排名
- 交易量对比
- 费用/收入对比
- 市值/TVL 比（如有代币）

### Step 5: Compile Report
- 整理所有数据到输出结构
- 如协议有代币，提示使用 token-analysis skill 深入分析

## Output Structure

### 1. 核心指标
| 指标 | 值 |
|------|---|
| TVL | |
| TVL 7d 变化 | |
| TVL 30d 变化 | |
| 日交易量 | |
| 费用(24h) | |
| 收入(24h) | |

### 2. 多链部署
| 链 | TVL | 占比 | 交易量 |
|----|-----|------|--------|

### 3. 收益分析
| 池子 | APY | 类型 | TVL | IL 风险 |
|------|-----|------|-----|---------|
- 稳定池 vs 波动池收益区分
- 是否包含代币激励

### 4. 竞品对比
| 协议 | TVL | 交易量 | 费用 | 市值/TVL |
|------|-----|--------|------|----------|
- 同赛道协议对比

### 5. 代币关联
- 如有关联代币：代币名称/价格/市值
- 建议：使用 `token-analysis` skill 进行深入代币分析

## Output Format

- **Primary**: `{Protocol}_DeFi_Analysis_{YYYYMMDD}.md`
- Footer: 数据来源、数据时间戳、免责声明

## Quality Checklist

- [ ] 协议正确识别（名称匹配 defillama slug）
- [ ] TVL 以 USD 计价（非原生代币计价）
- [ ] 链分布 TVL 之和等于总 TVL
- [ ] 竞品选择同赛道（不混淆 DEX 与借贷）
- [ ] 收益数据区分 APY/APR，标注是否含代币激励
- [ ] AMM 池标注 IL 风险
