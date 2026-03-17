---
name: token-analysis
description: |
  Comprehensive cryptocurrency token analysis covering price data, tokenomics,
  market structure, technical analysis, and risk assessment. Use when the user asks
  to analyze a token, check tokenomics, evaluate a cryptocurrency, or asks about
  any specific coin/token fundamentals. Triggers on "token analysis", "代币分析",
  "tokenomics", "代币基本面", "coin analysis", or any "[symbol] analysis" pattern.
---

# Token Analysis

对加密货币代币进行综合分析，覆盖行情、代币经济学、市场结构、技术面和风险评估。

## Data Source Priority

### Layer 1: MCP
- **coingecko** — 价格/市值/FDV/供给量/交易对/DEX 数据(GeckoTerminal)

### Layer 2: Chrome CDP
- 需登录的页面

### Layer 3: Web Search
- 解锁时间表、审计报告、项目文档、新闻

每个数据点标注 "Source: [source name]"。

## Workflow

### Step 1: Identify Token
- 解析用户输入的 symbol/名称/合约地址
- 通过 coingecko 搜索确认代币身份
- 如有同名代币（不同链），请求用户确认

### Step 2: Fetch Core Data
通过 coingecko MCP 获取：
- 当前价格、24h 涨跌幅
- 市值、完全稀释估值(FDV)
- 流通量/总供给/最大供给
- 市值排名
- 24h 交易量

### Step 3: Fetch Market Structure
- 主要交易所和交易对（CEX）
- DEX 流动性池和交易量（GeckoTerminal）
- DEX vs CEX 交易量占比

### Step 4: Fetch Supplementary Data
通过 Web Search 获取：
- 代币解锁时间表
- 合约审计状态
- 团队/项目背景
- 最新重要新闻

### Step 5: Compile Report
按照输出结构整理，生成完整分析报告。

## Output Structure

### 1. 基础数据
| 指标 | 值 |
|------|---|
| 价格 | |
| 24h 涨跌 | |
| 市值 | |
| FDV | |
| 流通量/总供给 | |
| 市值排名 | |
| 24h 交易量 | |

### 2. 代币经济学
- 总供给/流通供给/最大供给
- 通胀/通缩机制
- 代币分配（团队/投资者/社区/国库）
- 解锁时间表（如有）

### 3. 市场结构
- 主要 CEX 交易所和交易对
- 主要 DEX 流动性池
- DEX vs CEX 交易量占比
- 持仓集中度（如可获取）

### 4. 技术面
- 7d/30d/90d 价格走势
- 关键支撑/阻力位
- 与 BTC/ETH 相关性

### 5. 风险标注
- 合约地址验证
- 审计状态（审计机构/时间/结果）
- 监管风险评估
- 其他风险因素

## Output Format

- **Primary**: `{Symbol}_Token_Analysis_{YYYYMMDD}.md`
- Footer: 数据来源、数据时间戳、免责声明

## Quality Checklist

- [ ] 代币身份确认（未与同名不同链代币混淆）
- [ ] 市值和 FDV 都已报告（FDV 可能远大于市值）
- [ ] 供给数据区分流通量/总供给/最大供给
- [ ] 非原生代币包含合约地址
- [ ] 数据时效性标注（CoinGecko 数据可能延迟 1-5 分钟）
- [ ] 风险部分即使无问题也需存在
