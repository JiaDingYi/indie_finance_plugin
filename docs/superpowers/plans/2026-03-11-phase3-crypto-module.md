# Phase 3: Crypto Module Implementation Plan

> **For agentic workers:** REQUIRED: Use superpowers:subagent-driven-development (if subagents available) or superpowers:executing-plans to implement this plan. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Implement 4 skills + 4 commands for the crypto sub-plugin, covering token analysis, DeFi protocol analysis, airdrop evaluation, and on-chain data queries.

**Architecture:** Pure markdown plugin — skills are auto-triggered SKILL.md files, commands are user-invoked .md files with frontmatter. All new content created from scratch (not forked). Follows tradfi patterns: `allowed-tools`, `$ARGUMENTS`, `!date`, data source priority, workflow, quality checklist, skill reference.

**Tech Stack:** Markdown, JSON. MCP data sources: CoinGecko (76+ tools), DefiLlama (14 tools), Dune official (11 tools, HTTP remote).

**Spec:** `docs/superpowers/specs/2026-03-11-phase3-crypto-module-design.md`

---

## Prerequisites

- [ ] **Verify on branch `feat/phase2-tradfi`** (or create new `feat/phase3-crypto` branch)

```bash
git branch --show-current
# If needed: git fetch origin && git checkout -b feat/phase3-crypto origin/main
```

## File Structure

```
crypto/
├── .claude-plugin/plugin.json    # EXISTS - no changes
├── .mcp.json                     # MODIFY - upgrade Dune MCP to official HTTP
├── hooks/hooks.json              # EXISTS - no changes
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

---

## Chunk 1: Infrastructure + token-analysis + defi-protocol

### Task 1: Update crypto/.mcp.json — upgrade Dune MCP

**Files:**
- Modify: `crypto/.mcp.json`

- [ ] **Step 1: Update Dune MCP from community to official**

Replace the current dune config in `crypto/.mcp.json`:

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

- [ ] **Step 2: Commit**

```bash
git add crypto/.mcp.json
git commit -m "feat(crypto): upgrade Dune MCP from community to official (11 tools, HTTP)"
```

### Task 2: Create token-analysis skill

**Files:**
- Create: `crypto/skills/token-analysis/SKILL.md`

- [ ] **Step 1: Create SKILL.md**

Write `crypto/skills/token-analysis/SKILL.md` with:

**Frontmatter:**
```yaml
---
name: token-analysis
description: |
  Comprehensive cryptocurrency token analysis covering price data, tokenomics,
  market structure, technical analysis, and risk assessment. Use when the user asks
  to analyze a token, check tokenomics, evaluate a cryptocurrency, or asks about
  any specific coin/token fundamentals. Triggers on "token analysis", "代币分析",
  "tokenomics", "代币基本面", "coin analysis", or any "[symbol] analysis" pattern.
---
```

**Body sections:**

1. **Data Source Priority** — Three-layer fallback:
   - Layer 1: coingecko MCP (primary — price, market cap, FDV, supply, exchanges, DEX data via GeckoTerminal)
   - Layer 2: Web Search (unlock schedules, audit reports, project docs, news)
   - Layer 3: Chrome CDP (pages requiring login)

2. **Workflow** — 5 steps:
   - Step 1: Identify token (resolve symbol/name/contract address via coingecko)
   - Step 2: Fetch core data (price, market cap, FDV, volume, supply, rank)
   - Step 3: Fetch market structure (exchanges, trading pairs, DEX vs CEX split)
   - Step 4: Fetch supplementary data (unlock schedule, audit, team — web search)
   - Step 5: Compile report

3. **Output Structure** — 5 sections as defined in spec:
   - 基础数据: price/24h change/market cap/FDV/circulating supply ratio/rank/volume
   - 代币经济学: total supply/circulating/inflation mechanism/allocation/unlock schedule
   - 市场结构: top exchanges and pairs/DEX vs CEX volume/holder concentration
   - 技术面: 7d/30d/90d price trend/support-resistance/BTC & ETH correlation
   - 风险标注: contract address verification/audit status/regulatory risk

4. **Output Format Rules:**
   - Markdown file: `{Symbol}_Token_Analysis_{YYYYMMDD}.md`
   - All data points annotated with "Source: [source name]"
   - Footer: data source, data timestamp, disclaimer

5. **Quality Checklist:**
   - Token correctly identified (not confused with same-name tokens on different chains)
   - Market cap and FDV both reported (FDV can be much larger)
   - Supply figures specify circulating vs total vs max
   - Contract address included for non-native tokens
   - Data freshness noted (CoinGecko data may lag 1-5 min)
   - Risk section present even if no issues found

- [ ] **Step 2: Verify file**

```bash
head -5 crypto/skills/token-analysis/SKILL.md  # Check frontmatter
wc -l crypto/skills/token-analysis/SKILL.md     # Should be 80-150 lines
```

- [ ] **Step 3: Commit**

```bash
git add crypto/skills/token-analysis/SKILL.md
git commit -m "feat(crypto): add token-analysis skill"
```

### Task 3: Create defi-protocol skill

**Files:**
- Create: `crypto/skills/defi-protocol/SKILL.md`

- [ ] **Step 1: Create SKILL.md**

Write `crypto/skills/defi-protocol/SKILL.md` with:

**Frontmatter:**
```yaml
---
name: defi-protocol
description: |
  DeFi protocol analysis covering TVL, multi-chain deployment, yield analysis,
  and competitive comparison. Use when the user asks to analyze a DeFi protocol,
  check TVL, compare yields, evaluate a DEX/lending/bridge protocol, or asks about
  protocol metrics. Triggers on "DeFi analysis", "协议分析", "TVL analysis",
  "yield analysis", "DeFi 协议", "protocol comparison", or "[protocol] TVL".
---
```

**Body sections:**

1. **Data Source Priority** — Three-layer fallback:
   - Layer 1 Primary: defillama MCP (TVL, volumes, fees, yields, chains)
   - Layer 1 Secondary: coingecko MCP (token data, DEX data via GeckoTerminal)
   - Layer 2: Web Search (protocol docs, audit reports, governance proposals)
   - Layer 3: Chrome CDP

2. **Workflow** — 5 steps:
   - Step 1: Identify protocol (resolve name via defillama, determine category: DEX/lending/bridge/yield/etc.)
   - Step 2: Fetch core metrics (TVL, TVL change 7d/30d, chain breakdown, daily volume, fees/revenue)
   - Step 3: Fetch yield data (top pools by APY, stable vs volatile, IL risk)
   - Step 4: Fetch competitors (same category protocols, TVL/volume/fee comparison)
   - Step 5: Compile report; if protocol has a token, suggest token-analysis

3. **Output Structure** — 5 sections as defined in spec:
   - 核心指标: TVL/TVL change(7d/30d)/chain distribution/daily volume/fees-revenue
   - 多链部署: per-chain TVL and volume comparison table
   - 收益分析: top pool APY ranking/stable vs volatile/IL risk notes
   - 竞品对比: same-category protocols TVL/volume/fees comparison, mcap/TVL ratio
   - 代币关联: if token exists, link to token-analysis skill

4. **Output Format Rules:**
   - Markdown file: `{Protocol}_DeFi_Analysis_{YYYYMMDD}.md`
   - Source annotation on every data point
   - Footer with data source, timestamp, disclaimer

5. **Quality Checklist:**
   - Protocol correctly identified (name matches defillama slug)
   - TVL denominated in USD (not native token)
   - Chain breakdown sums to total TVL
   - Competitor set is same category (don't compare DEX with lending)
   - Yield figures note whether APY or APR, and whether including token incentives
   - IL risk noted for AMM pools

- [ ] **Step 2: Verify and commit**

```bash
head -5 crypto/skills/defi-protocol/SKILL.md
wc -l crypto/skills/defi-protocol/SKILL.md
git add crypto/skills/defi-protocol/SKILL.md
git commit -m "feat(crypto): add defi-protocol skill"
```

---

## Chunk 2: airdrop-eval skill (with references)

### Task 4: Create airdrop-eval skill

**Files:**
- Create: `crypto/skills/airdrop-eval/SKILL.md`
- Create: `crypto/skills/airdrop-eval/references/scoring-framework.md`

- [ ] **Step 1: Create scoring-framework.md**

Write `crypto/skills/airdrop-eval/references/scoring-framework.md` with the complete six-dimension scoring framework:

Content:
```markdown
# 空投评估六维度评分框架

> 评分口径：0–5 分（5=最好/最优），总分 30

## 维度定义与评分指南

### 1. 发币意愿（总包潜力/分配机制/规则稳定性）

评分要点：
- 5分: 明确发币时间线 + 公开 tokenomics + 积分系统透明
- 4分: 有积分系统，团队暗示发币但无明确时间
- 3分: 有代币相关讨论但无正式承诺
- 2分: 模糊暗示，无积分系统
- 1分: 否认发币或无任何信号
- 0分: 明确表示不发币

自动数据辅助：搜索官方公告、文档中的 tokenomics、创始人社交媒体发言

### 2. 筹码获取（与自身优势匹配）

评分要点：
- 5分: 参与机制完美匹配自身资源，预期收益/投入比极高
- 4分: 机制较匹配，投入可控
- 3分: 需要一定适应，但可操作
- 2分: 机制不太匹配，投入较高
- 1分: 严重不匹配，门槛过高
- 0分: 完全无法参与

自动数据辅助：链上参与门槛、积分机制分析、最低资金要求

### 3. 增长与可持续性

评分要点：
- 5分: TVL/用户快速增长 + 顶级融资 + 知名团队 + 强社区
- 4分: 良好增长趋势 + 可靠融资背景
- 3分: 稳定但增长一般
- 2分: 增长停滞或下降趋势
- 1分: 明显衰退
- 0分: 项目濒临死亡

自动数据辅助：DefiLlama TVL 趋势、社区规模、融资信息（Crunchbase/web search）

### 4. 单位成本（资金利用率）

评分要点：
- 5分: 极低成本（<$50/月），几乎无磨损
- 4分: 低成本（$50-200/月），可控磨损
- 3分: 中等成本（$200-500/月），有一定磨损
- 2分: 较高成本（$500-2000/月），磨损明显
- 1分: 高成本（>$2000/月），高磨损风险
- 0分: 需要大量资金且几乎必然亏损

自动数据辅助：Gas 费估算、参与所需最低资金量、交互频率要求

### 5. 暴击几率（竞争拥挤度/女巫影响）

评分要点：
- 5分: 参与者少 + 策略空间大 + 女巫影响小
- 4分: 中等拥挤度，存在差异化策略
- 3分: 较拥挤但仍有机会
- 2分: 非常拥挤，普通用户可能被稀释
- 1分: 极度拥挤，几乎无差异化空间
- 0分: 已过最佳窗口期

自动数据辅助：链上地址数趋势、社区讨论热度、KOL 推广频率

### 6. 风险等级（KYC/监管/作恶/女巫规则）

评分要点：
- 5分: 知名项目 + 机构融资 + 审计完善 + 规则清晰
- 4分: 较知名 + 有融资 + 基本审计
- 3分: 有一定知名度，审计/规则存在未验证项
- 2分: 知名度低，审计不足，规则不透明
- 1分: 高风险信号（匿名团队+无审计+强监管领域）
- 0分: 明显骗局特征

自动数据辅助：审计状态、合约权限分析、团队背景、监管敏感度

## 档位判定规则

| 档位 | 规则门槛 | 行动建议 |
|------|---------|---------|
| 专项冲刺 (Sprint) | 总分≥25 且 筹码≥4 且 风险≥4 | 集中资源，最大化参与 |
| 中等维护 | 总分20-24 且 筹码≥3 且 风险≥4 | 适度参与，定期维护 |
| 低保维护 | 总分15-19 且 筹码≥2 且 风险≥3 | 最低限度参与，保持资格 |
| 不参与 | 不满足以上任何条件 | 放弃或仅观望 |
```

- [ ] **Step 2: Create SKILL.md**

Write `crypto/skills/airdrop-eval/SKILL.md` with:

**Frontmatter:**
```yaml
---
name: airdrop-eval
description: |
  空投项目评估 — 基于六维度评分框架（发币意愿/筹码获取/增长性/单位成本/暴击几率/风险）
  对项目进行 0-5 分评分，总分 30 分制，输出档位判定（Sprint/中等维护/低保维护）。
  输出格式对齐 P-xxx 空投评估模板。Triggers on "空投评估", "airdrop evaluation",
  "项目评分", "airdrop scoring", "空投分析", "evaluate airdrop", or "P-xxx".
---
```

**Body sections:**

1. **Data Source Priority** — Three-layer fallback:
   - Layer 1: coingecko MCP (token info if already launched)
   - Layer 1: defillama MCP (TVL trends)
   - Layer 2: Web Search (funding, team, community, point system, official announcements)
   - Layer 3: Chrome CDP (project website, docs, Discord)

2. **Workflow** — 5 steps:
   - Step 1: Identify project — resolve name, find official website/docs/social links
   - Step 2: Auto-fetch data — query coingecko (if token exists), defillama (if has TVL), web search (funding rounds, team, tokenomics announcements, community size)
   - Step 3: Pre-fill scoring — based on fetched data, suggest scores for each dimension with evidence. Present to user for review.
   - Step 4: User confirms/adjusts — user can modify any score and add their own evidence
   - Step 5: Generate report — output in P-xxx template format

3. **Scoring Framework Reference:**
   ```
   See references/scoring-framework.md for complete dimension definitions,
   scoring rubrics (0-5 scale), and tier determination rules.
   ```

4. **Output Template** (P-xxx format):

   ```
   > 评分口径：0–5 分（5=最好/最优），总分 30
   > 说明：本表仅基于公开信息；其中"审计/规则细节/法域限制"等仍存在未验证项。

   ## 一、六维度评分（0–5）

   | 维度 | 分数 | 关键依据 | 主要扣分点/不确定性 |
   |------|------|---------|-----------------|
   | 发币意愿（总包潜力/分配机制/规则稳定性） | **X** | [evidence] | [concerns] |
   | 自己能否收获足够筹码（与自身优势匹配） | **X** | [evidence] | [concerns] |
   | 增长与可持续性 | **X** | [evidence] | [concerns] |
   | 单位成本（资金利用率） | **X** | [evidence] | [concerns] |
   | 暴击几率（竞争拥挤度/女巫影响） | **X** | [evidence] | [concerns] |
   | 风险等级（KYC/监管/作恶/女巫规则） | **X** | [evidence] | [concerns] |

   **总分：X / 30**

   ## 二、档位判定

   | 档位 | 规则门槛 | 是否满足 | 结论 |
   |------|---------|---------|-----|
   | 专项冲刺 | 总分≥25 且 筹码≥4 且 风险≥4 | 是/否 | |
   | 中等维护 | 总分20-24 且 筹码≥3 且 风险≥4 | 是/否 | |
   | 低保维护 | 总分15-19 且 筹码≥2 且 风险≥3 | 是/否 | |
   ```

5. **Output Format Rules:**
   - File name: `P-{ProjectName}空投.md`
   - Footer: data sources, data timestamp, disclaimer
   - Scores shown as bold `**X**` in table

6. **Quality Checklist:**
   - All 6 dimensions scored (no blanks)
   - Each score has at least one evidence item in 关键依据
   - Each score has at least one item in 扣分点/不确定性 (even if minor)
   - Tier determination correctly applies AND logic (all conditions must be met)
   - Data sources cited for each evidence item
   - Pre-filled scores clearly marked as suggestions until user confirms

- [ ] **Step 3: Verify and commit**

```bash
find crypto/skills/airdrop-eval/ -type f
wc -l crypto/skills/airdrop-eval/SKILL.md
wc -l crypto/skills/airdrop-eval/references/scoring-framework.md
git add crypto/skills/airdrop-eval/
git commit -m "feat(crypto): add airdrop-eval skill with scoring framework"
```

---

## Chunk 3: onchain-query skill (with references)

### Task 5: Create onchain-query skill

**Files:**
- Create: `crypto/skills/onchain-query/SKILL.md`
- Create: `crypto/skills/onchain-query/references/preset-queries.md`

- [ ] **Step 1: Create preset-queries.md**

Write `crypto/skills/onchain-query/references/preset-queries.md` with preset Dune query shortcuts:

Content — a table of common queries with descriptions, suggested SQL patterns, and usage hints. These are templates that Claude uses as starting points, not hardcoded query IDs (since IDs change):

```markdown
# Preset On-Chain Queries

常用链上查询模板。Claude 使用 Dune MCP 的 `searchTables` 和 `searchDocs` 工具
来发现具体的表名和字段，然后基于以下模板构建 SQL。

## 1. Daily Active Addresses (any chain)

**用途**: 查看某链的日活跃地址趋势
**示例请求**: "以太坊过去30天的日活跃地址"
**SQL 模板**:
```sql
SELECT
  date_trunc('day', block_time) AS day,
  COUNT(DISTINCT "from") AS active_addresses
FROM {chain}.transactions
WHERE block_time >= NOW() - INTERVAL '30' DAY
GROUP BY 1
ORDER BY 1
```
**注意**: 表名因链而异，用 searchTables 确认

## 2. Top DEX by Volume (7d)

**用途**: 各 DEX 协议过去 7 天交易量排名
**示例请求**: "过去7天 DEX 交易量排名"
**SQL 模板**:
```sql
SELECT
  project,
  SUM(amount_usd) AS volume_usd
FROM dex.trades
WHERE block_time >= NOW() - INTERVAL '7' DAY
GROUP BY 1
ORDER BY 2 DESC
LIMIT 20
```

## 3. Stablecoin Supply by Chain

**用途**: 各链稳定币总供给量对比
**示例请求**: "各链稳定币供给量"
**关键表**: 搜索 "stablecoin" 或 "transfers" 相关表

## 4. L2 TVL / Activity Comparison

**用途**: L2 网络活跃度和 TVL 对比
**示例请求**: "L2 网络活跃度对比"
**关键表**: 搜索各 L2 链的 transactions 表

## 5. Gas Price Trends

**用途**: Gas 价格历史趋势
**示例请求**: "以太坊 Gas 价格趋势"
**SQL 模板**:
```sql
SELECT
  date_trunc('day', block_time) AS day,
  AVG(gas_price / 1e9) AS avg_gas_gwei,
  PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY gas_price / 1e9) AS median_gas_gwei
FROM ethereum.transactions
WHERE block_time >= NOW() - INTERVAL '30' DAY
GROUP BY 1
ORDER BY 1
```

## 6. Top Token Holders

**用途**: 某代币持仓地址排名
**示例请求**: "USDC 前 50 大持仓地址"
**关键表**: 搜索 "erc20" 或 "balances" 相关表
**注意**: 需要合约地址来精确查询

## 7. NFT Marketplace Volume

**用途**: NFT 市场交易量对比
**示例请求**: "NFT 市场交易量排名"
**关键表**: 搜索 "nft" 或 "trades" 相关表

## 8. Bridge Volume by Chain

**用途**: 跨链桥交易量
**示例请求**: "跨链桥交易量对比"
**关键表**: 搜索 "bridge" 相关表
```

- [ ] **Step 2: Create SKILL.md**

Write `crypto/skills/onchain-query/SKILL.md` with:

**Frontmatter:**
```yaml
---
name: onchain-query
description: |
  On-chain data query using Dune Analytics. Supports natural language queries
  that get translated to SQL, preset query templates for common analyses, and
  direct Dune query ID execution. Uses official Dune MCP (11 tools) for table
  discovery, SQL creation, execution, and visualization. Triggers on "链上查询",
  "on-chain query", "dune query", "链上数据", "blockchain data", "查链上",
  or "run dune query [id]".
---
```

**Body sections:**

1. **Data Source Priority:**
   - Layer 1: dune MCP (official, 11 tools — table discovery, SQL creation, execution, visualization)
   - Layer 2: Web Search (fallback for pre-computed data from dune.com dashboards)
   - Layer 3: Chrome CDP (Dune dashboard pages requiring login)

2. **Dune MCP Tools Reference** (11 tools):
   - Discovery: `searchDocs`, `searchTables`, `listBlockchains`, `searchTablesByContractAddress`
   - Query Lifecycle: `createDuneQuery`, `getDuneQuery`, `updateDuneQuery`, `executeQueryById`, `getExecutionResults`
   - Visualization: `generateVisualization`
   - Account: `getUsage`

3. **Workflow — Mode A: Natural Language Query**
   - Step 1: Parse user intent — what data, which chain, what time range
   - Step 2: `listBlockchains` — confirm target chain is indexed
   - Step 3: `searchTables` — find relevant tables (by protocol/chain/category)
   - Step 4: `searchDocs` — learn table schema and find example SQL
   - Step 5: `createDuneQuery` — write and save SQL query
   - Step 6: `executeQueryById` — run the query
   - Step 7: `getExecutionResults` — fetch results (poll if still running)
   - Step 8: Format results as Markdown table
   - Step 9 (optional): `generateVisualization` — create chart if useful

4. **Workflow — Mode B: Preset Query**
   - Step 1: Match user request to preset in `references/preset-queries.md`
   - Step 2: Adapt SQL template with user-specified parameters (chain, token, time range)
   - Step 3: Follow steps 5-9 from Mode A

5. **Workflow — Mode C: Direct Query ID**
   - Step 1: User provides Dune query ID
   - Step 2: `getDuneQuery` — fetch query metadata
   - Step 3: `executeQueryById` — run query
   - Step 4: `getExecutionResults` — fetch results
   - Step 5: Format and present

6. **Output Format Rules:**
   - Primary output: Markdown table in conversation
   - Optional: save as `Onchain_{Description}_{YYYYMMDD}.md`
   - Include SQL query used (in code block) for transparency
   - Note Dune credit usage via `getUsage`

7. **Quality Checklist:**
   - SQL validated against discovered table schema (not guessed)
   - Time ranges explicit (no unbounded queries)
   - Results include row count and execution time
   - Large result sets truncated with note
   - SQL shown to user for verification before execution (for Mode A)
   - Credit usage noted

8. **Important Notes:**
   - Dune queries cost credits — check `getUsage` if usage seems high
   - Query execution may take 10-60 seconds; poll `getExecutionResults`
   - Table names and schemas vary by chain — always use `searchTables` first
   - For complex queries, show SQL to user for approval before executing
   - Preset queries are templates, not final SQL — adapt to specific tables

- [ ] **Step 3: Verify and commit**

```bash
find crypto/skills/onchain-query/ -type f
wc -l crypto/skills/onchain-query/SKILL.md
wc -l crypto/skills/onchain-query/references/preset-queries.md
git add crypto/skills/onchain-query/
git commit -m "feat(crypto): add onchain-query skill with preset queries"
```

---

## Chunk 4: 4 Commands

### Task 6: Create all 4 commands

**Files:**
- Create: `crypto/commands/token.md`
- Create: `crypto/commands/defi.md`
- Create: `crypto/commands/airdrop.md`
- Create: `crypto/commands/onchain.md`

All commands follow the tradfi-established format: YAML frontmatter with `description`, `argument-hint`, `allowed-tools`, then body with `# Title`, `## Context` ($ARGUMENTS + !date), `## Data Source Priority`, `## Workflow`, `## Output`, `## Quality Checklist`, `## Skill Reference`.

- [ ] **Step 1: Create token.md**

Write `crypto/commands/token.md`:

Frontmatter:
```yaml
---
description: Comprehensive token analysis — price, tokenomics, market structure, technicals, risk assessment
argument-hint: <symbol_or_name> [chain]
allowed-tools: Bash(python3:*), mcp__coingecko__*, WebSearch, WebFetch
---
```

Body: Title, Context ($ARGUMENTS + !date), Data Source Priority (coingecko → web → chrome), Workflow (5 steps matching skill), Output (`{Symbol}_Token_Analysis_{YYYYMMDD}.md`), Quality Checklist (6 items from skill), Skill Reference pointing to `skills/token-analysis/SKILL.md`.

- [ ] **Step 2: Create defi.md**

Write `crypto/commands/defi.md`:

Frontmatter:
```yaml
---
description: DeFi protocol analysis — TVL, multi-chain deployment, yield analysis, competitive comparison
argument-hint: <protocol_name> [chain]
allowed-tools: Bash(python3:*), mcp__defillama__*, mcp__coingecko__*, WebSearch, WebFetch
---
```

Body: Same structure. Data Source Priority (defillama primary → coingecko secondary → web → chrome), Workflow (5 steps), Output (`{Protocol}_DeFi_Analysis_{YYYYMMDD}.md`), Quality Checklist (6 items from skill), Skill Reference.

- [ ] **Step 3: Create airdrop.md**

Write `crypto/commands/airdrop.md`:

Frontmatter:
```yaml
---
description: 空投项目评估 — 六维度评分(0-5)/档位判定(Sprint/中等/低保)/P-xxx 格式输出
argument-hint: <project_name>
allowed-tools: mcp__coingecko__*, mcp__defillama__*, WebSearch, WebFetch
---
```

Body: Same structure. Data Source Priority (coingecko + defillama → web → chrome), Workflow (5 steps: identify → fetch → pre-fill scores → user confirm → generate report), Output (`P-{ProjectName}空投.md`), Quality Checklist (6 items from skill), Skill Reference pointing to `skills/airdrop-eval/SKILL.md` and `skills/airdrop-eval/references/scoring-framework.md`.

- [ ] **Step 4: Create onchain.md**

Write `crypto/commands/onchain.md`:

Frontmatter:
```yaml
---
description: On-chain data query — natural language to Dune SQL, preset queries, or direct query ID execution
argument-hint: <natural_language_query> | query:<dune_query_id>
allowed-tools: mcp__dune__*, WebSearch, WebFetch
---
```

Body: Same structure. Data Source Priority (dune MCP 11 tools → web → chrome), Workflow (3 modes: natural language / preset / direct ID), Output (Markdown table in conversation or saved file), Quality Checklist (6 items from skill), Skill Reference.

- [ ] **Step 5: Verify and commit**

```bash
ls crypto/commands/
wc -l crypto/commands/*.md
git add crypto/commands/
git commit -m "feat(crypto): add 4 commands (token, defi, airdrop, onchain)"
```

---

## Chunk 5: Final Verification

### Task 7: Final verification

- [ ] **Step 1: Verify directory structure**

```bash
find crypto/ -type f | sort
```

Expected: 4 commands + 4 SKILL.md + 1 scoring-framework.md + 1 preset-queries.md + plugin.json + .mcp.json + hooks.json = 13 files

- [ ] **Step 2: Verify Dune MCP config is official**

```bash
grep -A3 '"dune"' crypto/.mcp.json
```

Expected: `"type": "http"`, `"url": "https://api.dune.com/mcp/v1"`

- [ ] **Step 3: Verify all skills have proper frontmatter**

```bash
head -3 crypto/skills/*/SKILL.md
head -3 crypto/skills/*/references/*.md 2>/dev/null
```

Expected: Each SKILL.md starts with `---` followed by `name:` and `description:`

- [ ] **Step 4: Verify all commands have proper frontmatter**

```bash
head -5 crypto/commands/*.md
```

Expected: Each command has `description:`, `argument-hint:`, `allowed-tools:`

- [ ] **Step 5: Spot check content quality**

Read a few files to ensure they match spec requirements:
- token-analysis: has 5 output sections
- airdrop-eval: has P-xxx template format
- onchain-query: references all 11 Dune MCP tools
- scoring-framework: has 6 dimensions with 0-5 scoring rubrics

- [ ] **Step 6: Update design doc status**

In `docs/plans/2026-03-11-indie-finance-plugin-design.md`, update Phase 3 status to completed.

- [ ] **Step 7: Final commit**

```bash
git add docs/plans/2026-03-11-indie-finance-plugin-design.md
git commit -m "docs: mark Phase 3 Crypto module as complete"
```
