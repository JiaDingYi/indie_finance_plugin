# Layer 2/3 Swap Sync Implementation Plan

> **For agentic workers:** REQUIRED: Use superpowers:subagent-driven-development (if subagents available) or superpowers:executing-plans to implement this plan. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Sync all SKILL.md and commands/*.md files to reflect the new Layer 2 = Chrome CDP, Layer 3 = Web Search ordering established in CLAUDE.md by PR #6.

**Architecture:** Five parallel agents each own one group of files. Groups 1–4 perform Layer 2/3 block swaps in SKILL.md and commands/*.md; Group 5 fixes six layer-number references in a spec doc. All changes land in a single commit at the end.

**Tech Stack:** Markdown files only. No code changes.

---

## Swap Rule (apply to every file in Groups 1–4)

Each file has a Layer 2 block and a Layer 3 block. Swap both the heading AND all content lines under it as one unit.

**Before pattern:**
```
### Layer 2: Web Search
- <web search content lines>

### Layer 3: Chrome CDP
- <chrome cdp content lines>
```

**After pattern:**
```
### Layer 2: Chrome CDP
- <chrome cdp content lines>

### Layer 3: Web Search
- <web search content lines>
```

> **Special case — dcf-model/SKILL.md:** Uses bold format (`**Layer 2: Web Search**`) instead of `###` headings. Apply the same swap logic but preserve the bold formatting.

---

## Task 1: Fix tradfi SKILL.md and commands files

**Files:**
- Modify: `tradfi/skills/comps-analysis/SKILL.md` (lines 33–38)
- Modify: `tradfi/skills/earnings-analysis/SKILL.md` (lines 39–46)
- Modify: `tradfi/skills/model-update/SKILL.md` (lines 15–20)
- Modify: `tradfi/skills/competitive-analysis/SKILL.md` (lines 17–23)
- Modify: `tradfi/skills/idea-generation/SKILL.md` (lines 14–20)
- Modify: `tradfi/skills/thesis-tracker/SKILL.md` (line 8, plus any Layer 2/3 blocks)
- Modify: `tradfi/skills/dcf-model/SKILL.md` (lines 79–84, bold format)
- Modify: `tradfi/commands/comps.md` (lines 25–30)
- Modify: `tradfi/commands/dcf.md` (lines 23–29)
- Modify: `tradfi/commands/earnings.md` (lines 23–30)
- Modify: `tradfi/commands/screen.md` (lines 22–28)
- Modify: `tradfi/commands/thesis.md` (lines 23–29)
- Modify: `tradfi/commands/model-update.md` (lines 23–28)

- [ ] **Step 1: Fix tradfi/skills/comps-analysis/SKILL.md**

Current (lines 33–38):
```
### Layer 2: Web Search
- finance.yahoo.com, macrotrends.net for financial data
- SEC EDGAR for filings

### Layer 3: Chrome CDP
- For pages requiring login or dynamic rendering
```

Replace with:
```
### Layer 2: Chrome CDP
- For pages requiring login or dynamic rendering

### Layer 3: Web Search
- finance.yahoo.com, macrotrends.net for financial data
- SEC EDGAR for filings
```

- [ ] **Step 2: Fix tradfi/skills/earnings-analysis/SKILL.md**

Current (lines 39–46):
```
### Layer 2: Web Search
- seekingalpha.com/earnings/transcripts
- finance.yahoo.com/earnings
- sec.gov/cgi-bin/browse-edgar

### Layer 3: Chrome CDP
- Seeking Alpha (may require login for full transcripts)
- Earnings call replay pages
```

Replace with:
```
### Layer 2: Chrome CDP
- Seeking Alpha (may require login for full transcripts)
- Earnings call replay pages

### Layer 3: Web Search
- seekingalpha.com/earnings/transcripts
- finance.yahoo.com/earnings
- sec.gov/cgi-bin/browse-edgar
```

- [ ] **Step 3: Fix tradfi/skills/model-update/SKILL.md**

Current (lines 15–20):
```
### Layer 2: Web Search
- Company IR pages for press releases
- SEC EDGAR for filings

### Layer 3: Chrome CDP
- For detailed filings or earnings call replays
```

Replace with:
```
### Layer 2: Chrome CDP
- For detailed filings or earnings call replays

### Layer 3: Web Search
- Company IR pages for press releases
- SEC EDGAR for filings
```

- [ ] **Step 4: Fix tradfi/skills/competitive-analysis/SKILL.md**

Current (lines 17–23):
```
### Layer 2: Web Search
- Company investor relations pages
- Industry reports, analyst coverage
- News for recent competitive developments

### Layer 3: Chrome CDP
- Pages with dynamic content or login requirements
```

Replace with:
```
### Layer 2: Chrome CDP
- Pages with dynamic content or login requirements

### Layer 3: Web Search
- Company investor relations pages
- Industry reports, analyst coverage
- News for recent competitive developments
```

- [ ] **Step 5: Fix tradfi/skills/idea-generation/SKILL.md**

Current (lines 14–20):
```
### Layer 2: Web Search
- finviz.com for visual screening
- finance.yahoo.com/screener
- sec.gov for insider filings

### Layer 3: Chrome CDP
- For pages requiring login or dynamic rendering
```

Replace with:
```
### Layer 2: Chrome CDP
- For pages requiring login or dynamic rendering

### Layer 3: Web Search
- finviz.com for visual screening
- finance.yahoo.com/screener
- sec.gov for insider filings
```

- [ ] **Step 6: Fix tradfi/skills/thesis-tracker/SKILL.md — plain text on line 8**

Current line 8:
```
...Follow the three-layer fallback: MCP → Web Search → Chrome CDP.
```

Replace with:
```
...Follow the three-layer fallback: MCP → Chrome CDP → Web Search.
```

Also check if thesis-tracker has a Layer 2/3 block (run `grep -n "Layer" tradfi/skills/thesis-tracker/SKILL.md`) and apply the swap rule if present.

- [ ] **Step 7: Fix tradfi/skills/dcf-model/SKILL.md — bold format**

Current (lines 79–84):
```
**Layer 2: Web Search**
- finance.yahoo.com, macrotrends.net for historical data
- SEC EDGAR for 10-K/10-Q filings

**Layer 3: Chrome CDP**
- For detailed filings or pages with bot detection
```

Replace with:
```
**Layer 2: Chrome CDP**
- For detailed filings or pages with bot detection

**Layer 3: Web Search**
- finance.yahoo.com, macrotrends.net for historical data
- SEC EDGAR for 10-K/10-Q filings
```

- [ ] **Step 8: Fix tradfi/commands/comps.md**

Current (lines 25–30):
```
### Layer 2: Web Search
- finance.yahoo.com, macrotrends.net for financial data
- SEC EDGAR for filings

### Layer 3: Chrome CDP
- For pages requiring login or dynamic rendering
```

Replace with:
```
### Layer 2: Chrome CDP
- For pages requiring login or dynamic rendering

### Layer 3: Web Search
- finance.yahoo.com, macrotrends.net for financial data
- SEC EDGAR for filings
```

- [ ] **Step 9: Fix tradfi/commands/dcf.md**

Current (lines 23–29):
```
### Layer 2: Web Search
- SEC EDGAR for 10-K/10-Q filings
- finance.yahoo.com for consensus estimates
- macrotrends.net for historical data

### Layer 3: Chrome CDP
- For pages requiring login or dynamic rendering
```

Replace with:
```
### Layer 2: Chrome CDP
- For pages requiring login or dynamic rendering

### Layer 3: Web Search
- SEC EDGAR for 10-K/10-Q filings
- finance.yahoo.com for consensus estimates
- macrotrends.net for historical data
```

- [ ] **Step 10: Fix tradfi/commands/earnings.md**

Current (lines 23–30):
```
### Layer 2: Web Search
- seekingalpha.com for earnings transcripts
- finance.yahoo.com/earnings
- sec.gov/cgi-bin/browse-edgar for filings

### Layer 3: Chrome CDP
- Seeking Alpha (may require login for full transcripts)
- Earnings call replay pages
```

Replace with:
```
### Layer 2: Chrome CDP
- Seeking Alpha (may require login for full transcripts)
- Earnings call replay pages

### Layer 3: Web Search
- seekingalpha.com for earnings transcripts
- finance.yahoo.com/earnings
- sec.gov/cgi-bin/browse-edgar for filings
```

- [ ] **Step 11: Fix tradfi/commands/screen.md**

Current (lines 22–28):
```
### Layer 2: Web Search
- finviz.com for visual screening
- finance.yahoo.com/screener
- sec.gov for insider filings

### Layer 3: Chrome CDP
- For pages requiring login or dynamic rendering
```

Replace with:
```
### Layer 2: Chrome CDP
- For pages requiring login or dynamic rendering

### Layer 3: Web Search
- finviz.com for visual screening
- finance.yahoo.com/screener
- sec.gov for insider filings
```

- [ ] **Step 12: Fix tradfi/commands/thesis.md**

Current (lines 23–29):
```
### Layer 2: Web Search
- Company IR pages for press releases
- SEC EDGAR for filings
- Industry news sources

### Layer 3: Chrome CDP
- For pages requiring login or dynamic rendering
```

Replace with:
```
### Layer 2: Chrome CDP
- For pages requiring login or dynamic rendering

### Layer 3: Web Search
- Company IR pages for press releases
- SEC EDGAR for filings
- Industry news sources
```

- [ ] **Step 13: Fix tradfi/commands/model-update.md**

Current (lines 23–28):
```
### Layer 2: Web Search
- Company IR pages for press releases
- SEC EDGAR for filings

### Layer 3: Chrome CDP
- For detailed filings or earnings call replays
```

Replace with:
```
### Layer 2: Chrome CDP
- For detailed filings or earnings call replays

### Layer 3: Web Search
- Company IR pages for press releases
- SEC EDGAR for filings
```

- [ ] **Step 14: Verify all tradfi Layer references are updated**

Run:
```bash
grep -rn "Layer 2: Web Search\|Layer 3: Chrome CDP\|Web Search → Chrome CDP" \
  tradfi/skills/ tradfi/commands/ tradfi/_reference/
```
Expected: zero matches (excluding dcf-model's color-layer lines which are unrelated).

---

## Task 2: Fix crypto SKILL.md and commands files

**Files:**
- Modify: `crypto/skills/token-analysis/SKILL.md` (lines 20–24)
- Modify: `crypto/skills/defi-protocol/SKILL.md` (lines 23–27)
- Modify: `crypto/skills/airdrop-eval/SKILL.md` (lines 20–23)
- Modify: `crypto/skills/onchain-query/SKILL.md` (lines 24–28)
- Modify: `crypto/commands/token.md` (lines 21–25)
- Modify: `crypto/commands/defi.md` (lines 24–28)
- Modify: `crypto/commands/airdrop.md` (lines 22–26)
- Modify: `crypto/commands/onchain.md` (lines 24–28)

- [ ] **Step 1: Fix crypto/skills/token-analysis/SKILL.md**

Current (lines 20–24):
```
### Layer 2: Web Search
- 解锁时间表、审计报告、项目文档、新闻

### Layer 3: Chrome CDP
- 需登录的页面
```

Replace with:
```
### Layer 2: Chrome CDP
- 需登录的页面

### Layer 3: Web Search
- 解锁时间表、审计报告、项目文档、新闻
```

- [ ] **Step 2: Fix crypto/skills/defi-protocol/SKILL.md**

Current (lines 23–27):
```
### Layer 2: Web Search
- 协议文档、审计报告、治理提案

### Layer 3: Chrome CDP
- 需登录的页面
```

Replace with:
```
### Layer 2: Chrome CDP
- 需登录的页面

### Layer 3: Web Search
- 协议文档、审计报告、治理提案
```

- [ ] **Step 3: Fix crypto/skills/airdrop-eval/SKILL.md**

Current (lines 20–23):
```
### Layer 2: Web Search
- 融资背景、团队信息、社区规模、积分机制、官方公告

### Layer 3: Chrome CDP
- 官网、文档、Discord
```

Replace with:
```
### Layer 2: Chrome CDP
- 官网、文档、Discord

### Layer 3: Web Search
- 融资背景、团队信息、社区规模、积分机制、官方公告
```

- [ ] **Step 4: Fix crypto/skills/onchain-query/SKILL.md**

Current (lines 24–28):
```
### Layer 2: Web Search
- Dune 公开 dashboard 的预计算数据

### Layer 3: Chrome CDP
- 需登录的 Dune dashboard
```

Replace with:
```
### Layer 2: Chrome CDP
- 需登录的 Dune dashboard

### Layer 3: Web Search
- Dune 公开 dashboard 的预计算数据
```

- [ ] **Step 5: Fix crypto/commands/token.md**

Current (lines 21–25):
```
### Layer 2: Web Search
- 解锁时间表、审计报告、项目文档、新闻

### Layer 3: Chrome CDP
- 需登录的页面
```

Replace with:
```
### Layer 2: Chrome CDP
- 需登录的页面

### Layer 3: Web Search
- 解锁时间表、审计报告、项目文档、新闻
```

- [ ] **Step 6: Fix crypto/commands/defi.md**

Current (lines 24–28):
```
### Layer 2: Web Search
- 协议文档、审计报告、治理提案

### Layer 3: Chrome CDP
- 需登录的页面
```

Replace with:
```
### Layer 2: Chrome CDP
- 需登录的页面

### Layer 3: Web Search
- 协议文档、审计报告、治理提案
```

- [ ] **Step 7: Fix crypto/commands/airdrop.md**

Current (lines 22–26):
```
### Layer 2: Web Search
- 融资背景、团队、社区、积分机制、官方公告

### Layer 3: Chrome CDP
- 官网、文档、Discord
```

Replace with:
```
### Layer 2: Chrome CDP
- 官网、文档、Discord

### Layer 3: Web Search
- 融资背景、团队、社区、积分机制、官方公告
```

- [ ] **Step 8: Fix crypto/commands/onchain.md**

Current (lines 24–28):
```
### Layer 2: Web Search
- Dune 公开 dashboard 数据

### Layer 3: Chrome CDP
- 需登录的 Dune dashboard
```

Replace with:
```
### Layer 2: Chrome CDP
- 需登录的 Dune dashboard

### Layer 3: Web Search
- Dune 公开 dashboard 数据
```

- [ ] **Step 9: Verify all crypto Layer references are updated**

Run:
```bash
grep -rn "Layer 2: Web Search\|Layer 3: Chrome CDP" crypto/skills/ crypto/commands/
```
Expected: zero matches.

---

## Task 3: Fix macro SKILL.md and commands files

**Files:**
- Modify: `macro/skills/macro-dashboard/SKILL.md` (lines 21–26)
- Modify: `macro/skills/morning-note/SKILL.md` (lines 21–27)
- Modify: `macro/skills/catalyst-calendar/SKILL.md` (lines 21–30)
- Modify: `macro/skills/news-digest/SKILL.md` (lines 32–38)
- Modify: `macro/commands/dashboard.md` (lines 23–27)
- Modify: `macro/commands/morning.md` (lines 23–27)
- Modify: `macro/commands/catalyst.md` (lines 23–27)

- [ ] **Step 1: Fix macro/skills/macro-dashboard/SKILL.md**

Current (lines 21–26):
```
### Layer 2: Web Search
- 经济数据发布日历、FOMC 声明、市场评论
- VIX 数据、恐惧贪婪指数

### Layer 3: Chrome CDP
- 需登录的数据源
```

Replace with:
```
### Layer 2: Chrome CDP
- 需登录的数据源

### Layer 3: Web Search
- 经济数据发布日历、FOMC 声明、市场评论
- VIX 数据、恐惧贪婪指数
```

- [ ] **Step 2: Fix macro/skills/morning-note/SKILL.md**

Current (lines 21–27):
```
### Layer 2: Web Search
- 财经新闻（earnings, M&A, 政策变化）
- 期货/盘前数据
- 加密新闻（项目公告、监管动态）

### Layer 3: Chrome CDP
- 需登录的新闻源
```

Replace with:
```
### Layer 2: Chrome CDP
- 需登录的新闻源

### Layer 3: Web Search
- 财经新闻（earnings, M&A, 政策变化）
- 期货/盘前数据
- 加密新闻（项目公告、监管动态）
```

- [ ] **Step 3: Fix macro/skills/catalyst-calendar/SKILL.md**

Current (lines 21–30):
```
### Layer 2: Web Search
- 财报日历（公司 IR 页面）
- FOMC 会议日期
- 代币解锁日历（TokenUnlocks）
- 空投快照/TGE 日期
- 协议升级/硬分叉时间表

### Layer 3: Chrome CDP
- 需登录的日历源
```

Replace with:
```
### Layer 2: Chrome CDP
- 需登录的日历源

### Layer 3: Web Search
- 财报日历（公司 IR 页面）
- FOMC 会议日期
- 代币解锁日历（TokenUnlocks）
- 空投快照/TGE 日期
- 协议升级/硬分叉时间表
```

- [ ] **Step 4: Fix macro/skills/news-digest/SKILL.md**

Current (lines 32–38):
```
### Layer 2: Web Search
- 财经新闻网站（Reuters, Bloomberg, CNBC, CoinDesk, The Block）
- 公司 IR 页面（press releases）
- 项目官方公告（Twitter/X, Medium, Discord）

### Layer 3: Chrome CDP
- 需登录的新闻源
```

Replace with:
```
### Layer 2: Chrome CDP
- 需登录的新闻源

### Layer 3: Web Search
- 财经新闻网站（Reuters, Bloomberg, CNBC, CoinDesk, The Block）
- 公司 IR 页面（press releases）
- 项目官方公告（Twitter/X, Medium, Discord）
```

- [ ] **Step 5: Fix macro/commands/dashboard.md**

Current (lines 23–27):
```
### Layer 2: Web Search
- 经济数据日历、FOMC 声明、VIX、恐惧贪婪指数

### Layer 3: Chrome CDP
- 需登录的数据源
```

Replace with:
```
### Layer 2: Chrome CDP
- 需登录的数据源

### Layer 3: Web Search
- 经济数据日历、FOMC 声明、VIX、恐惧贪婪指数
```

- [ ] **Step 6: Fix macro/commands/morning.md**

Current (lines 23–27):
```
### Layer 2: Web Search
- 财经新闻、期货/盘前数据、加密新闻

### Layer 3: Chrome CDP
- 需登录的新闻源
```

Replace with:
```
### Layer 2: Chrome CDP
- 需登录的新闻源

### Layer 3: Web Search
- 财经新闻、期货/盘前数据、加密新闻
```

- [ ] **Step 7: Fix macro/commands/catalyst.md**

Current (lines 23–27):
```
### Layer 2: Web Search
- 财报日历、FOMC 日期、代币解锁日历、空投日期、加密会议

### Layer 3: Chrome CDP
- 需登录的日历源
```

Replace with:
```
### Layer 2: Chrome CDP
- 需登录的日历源

### Layer 3: Web Search
- 财报日历、FOMC 日期、代币解锁日历、空投日期、加密会议
```

- [ ] **Step 8: Verify all macro Layer references are updated**

Run:
```bash
grep -rn "Layer 2: Web Search\|Layer 3: Chrome CDP" macro/skills/ macro/commands/
```
Expected: zero matches.

---

## Task 4: Fix portfolio SKILL.md and commands files

**Files:**
- Modify: `portfolio/skills/portfolio-rebalance/SKILL.md` (lines 18–22)
- Modify: `portfolio/skills/tax-loss-harvesting/SKILL.md` (lines 19–23)
- Modify: `portfolio/commands/rebalance.md` (lines 21–25)
- Modify: `portfolio/commands/tlh.md` (lines 21–25)

- [ ] **Step 1: Fix portfolio/skills/portfolio-rebalance/SKILL.md**

Current (lines 18–22):
```
### Layer 2: Web Search
- 资产类别基准数据、ETF 详细信息

### Layer 3: Chrome CDP
- 券商账户页面（如需）
```

Replace with:
```
### Layer 2: Chrome CDP
- 券商账户页面（如需）

### Layer 3: Web Search
- 资产类别基准数据、ETF 详细信息
```

- [ ] **Step 2: Fix portfolio/skills/tax-loss-harvesting/SKILL.md**

Current (lines 19–23):
```
### Layer 2: Web Search
- Wash Sale 规则最新解读、ETF 替代品对照表

### Layer 3: Chrome CDP
- 券商税务报告页面（如需）
```

Replace with:
```
### Layer 2: Chrome CDP
- 券商税务报告页面（如需）

### Layer 3: Web Search
- Wash Sale 规则最新解读、ETF 替代品对照表
```

- [ ] **Step 3: Fix portfolio/commands/rebalance.md**

Current (lines 21–25):
```
### Layer 2: Web Search
- 资产类别基准、ETF 信息

### Layer 3: Chrome CDP
- 券商页面
```

Replace with:
```
### Layer 2: Chrome CDP
- 券商页面

### Layer 3: Web Search
- 资产类别基准、ETF 信息
```

- [ ] **Step 4: Fix portfolio/commands/tlh.md**

Current (lines 21–25):
```
### Layer 2: Web Search
- Wash Sale 规则、ETF 替代品对照

### Layer 3: Chrome CDP
- 券商税务报告
```

Replace with:
```
### Layer 2: Chrome CDP
- 券商税务报告

### Layer 3: Web Search
- Wash Sale 规则、ETF 替代品对照
```

- [ ] **Step 5: Verify all portfolio Layer references are updated**

Run:
```bash
grep -rn "Layer 2: Web Search\|Layer 3: Chrome CDP" portfolio/skills/ portfolio/commands/
```
Expected: zero matches.

---

## Task 5: Fix spec doc layer number references

**Files:**
- Modify: `docs/superpowers/specs/2026-03-17-chrome-cdp-oversize-fallback-design.md` (lines 5, 9, 20, 35, 52, 67)

- [ ] **Step 1: Fix line 5 — background section**

Current line 5:
```
...当前 CLAUDE.md 的 Layer 3 定义未覆盖此场景，导致 Claude 直接跳回 Layer 2 Web Search，放弃了已经导航到的页面。
```

Replace with:
```
...当前 CLAUDE.md 的 Layer 2 定义未覆盖此场景，导致 Claude 直接跳回 Layer 3 Web Search，放弃了已经导航到的页面。
```

- [ ] **Step 2: Fix line 9 — goal section**

Current line 9:
```
在 CLAUDE.md 全局 Layer 3 定义中补充响应式降级规则，所有子插件自动继承，无需修改任何 SKILL.md。
```

Replace with:
```
在 CLAUDE.md 全局 Layer 2 定义中补充响应式降级规则，所有子插件自动继承，无需修改任何 SKILL.md。
```

- [ ] **Step 3: Fix line 20 — modified files section**

Current line 20:
```
`CLAUDE.md` — Layer 3 段落末尾追加"页面过大时的工具降级顺序"子段落。
```

Replace with:
```
`CLAUDE.md` — Layer 2 段落末尾追加"页面过大时的工具降级顺序"子段落。
```

- [ ] **Step 4: Fix line 35 — fallback sequence Step 4**

Current line 35:
```
Step 4: Step 2 失败 或 Step 3 失败 → fallback 回 Layer 2 Web Search
```

Replace with:
```
Step 4: Step 2 失败 或 Step 3 失败 → fallback 回 Layer 3 Web Search
```

- [ ] **Step 5: Fix line 52 — diff context line**

Current line 52:
```
 Layer 3: Chrome CDP 直接访问（Web Search 也不可用时）
```

Replace with:
```
 Layer 2: Chrome CDP 直接访问（MCP 不可用或数据不足时）
```

- [ ] **Step 6: Fix line 67 — diff new line**

Current line 67:
```
+  Step 4: fallback 回 Layer 2 Web Search
```

Replace with:
```
+  Step 4: fallback 回 Layer 3 Web Search
```

- [ ] **Step 7: Verify spec doc has no remaining wrong layer references**

Run:
```bash
grep -n "Layer 2 Web Search\|Layer 3.*Chrome CDP\|Layer 3 定义\|Layer 3 段落" \
  docs/superpowers/specs/2026-03-17-chrome-cdp-oversize-fallback-design.md
```
Expected: zero matches.

---

## Task 6: Final verification and commit

- [ ] **Step 1: Run global verification**

```bash
grep -rn "Layer 2: Web Search\|Layer 3: Chrome CDP\|Web Search → Chrome CDP" \
  tradfi/ crypto/ macro/ portfolio/ \
  --include="*.md" --exclude-dir=node_modules
```
Expected: zero matches (the only exceptions allowed are `dcf-model/SKILL.md` lines 823–832 which describe Excel color layers, not data-source layers).

- [ ] **Step 2: Spot-check one file per group**

```bash
grep -A5 "Layer 2\|Layer 3" \
  tradfi/skills/comps-analysis/SKILL.md \
  crypto/skills/token-analysis/SKILL.md \
  macro/skills/morning-note/SKILL.md \
  portfolio/skills/portfolio-rebalance/SKILL.md
```
Confirm Layer 2 = Chrome CDP, Layer 3 = Web Search in each.

- [ ] **Step 3: Commit all changes**

```bash
git add \
  tradfi/skills/ tradfi/commands/ \
  crypto/skills/ crypto/commands/ \
  macro/skills/ macro/commands/ \
  portfolio/skills/ portfolio/commands/ \
  docs/superpowers/specs/2026-03-17-chrome-cdp-oversize-fallback-design.md
git commit -m "docs: sync layer2/layer3 swap across all SKILL.md and commands files"
```
