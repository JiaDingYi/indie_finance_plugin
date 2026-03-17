# MCP 依赖安全审计报告

审计日期：2026-03-12

## 审计结论

仅启用通过安全审计的**官方 MCP server**，非官方社区实现暂不引入，通过三层 Fallback 的 Layer 2（Chrome CDP）和 Layer 3（Web Search）覆盖数据需求。

## 官方 MCP Server（已启用）

### 1. @coingecko/coingecko-mcp

| 项目 | 详情 |
|------|------|
| 发布者 | CoinGecko 官方（@coingecko npm org） |
| 类型 | stdio (npx) |
| 版本 | v3.0.0 |
| 许可证 | Apache-2.0 |
| GitHub | [coingecko/coingecko-typescript](https://github.com/coingecko/coingecko-typescript) (51 stars) |
| 最后更新 | 2026-03 |
| 已知漏洞 | 无 |
| 风险级别 | **低** |
| 子插件 | crypto, macro |

### 2. Alpha Vantage MCP (HTTP)

| 项目 | 详情 |
|------|------|
| 发布者 | Alpha Vantage Inc. 官方 |
| 类型 | http |
| 端点 | `https://mcp.alphavantage.co` |
| GitHub | [alphavantage/alpha_vantage_mcp](https://github.com/alphavantage/alpha_vantage_mcp) |
| 文档 | 官方提供，含 Claude Code 集成指南 |
| 已知漏洞 | 无 |
| 风险级别 | **低** |
| 子插件 | tradfi |

### 3. Dune Analytics MCP (HTTP)

| 项目 | 详情 |
|------|------|
| 发布者 | Dune Analytics 官方 |
| 类型 | http |
| 端点 | `https://api.dune.com/mcp/v1` |
| 文档 | [docs.dune.com/api-reference/agents/mcp](https://docs.dune.com/api-reference/agents/mcp) |
| 认证 | Header: `x-dune-api-key` |
| 已知漏洞 | 无 |
| 风险级别 | **低** |
| 子插件 | crypto |

## 非官方 MCP Server（暂不引入）

以下数据源**无官方 MCP server**，均为社区实现。暂通过 Web Search / Chrome CDP fallback 覆盖。

### DefiLlama

- **官方状态**：DefiLlama GitHub (49 repos) 无 MCP 项目
- **社区方案**：
  - `@iqai/defillama-mcp` — v0.0.1，2 stars，12 依赖（含 AI SDK），**风险较高**
  - `@nic0xflamel/defillama-mcp-server` — v0.1.0，0 stars，10 依赖，可用但不成熟
  - dcSpark/mcp-server-defillama — 1 依赖，8 stars，**未发布到 npm**
- **Fallback 方案**：Web Search defillama.com（API 无限制，网页数据充足）

### FRED (Federal Reserve Economic Data)

- **官方状态**：联储未提供 MCP server
- **社区方案**：
  - `fred-mcp-server` — v1.0.2，66 stars，2 依赖，AGPL-3.0，个人维护（stefanoamorelli）
  - 风险级别：**中低**（依赖少、TypeScript 实现）
- **Fallback 方案**：Web Search fred.stlouisfed.org（数据完整，页面结构稳定）
- **备选评估**：如未来需引入，`fred-mcp-server` 是最佳候选（2 依赖，66 stars）

### Yahoo Finance

- **官方状态**：Yahoo 未发布 MCP server
- **社区方案**：
  - `mcp-yahoo-finance` (PyPI) — v0.1.3，21 stars，2 依赖（mcp + yfinance），MIT，个人维护（maxscheijen）
  - 风险级别：**中**（依赖极简，但需 uvx，早期版本）
- **Fallback 方案**：Web Search finance.yahoo.com（数据公开，结构化程度高）
- **备选评估**：如未来需引入，`mcp-yahoo-finance` 是最佳候选（2 依赖，MIT）

### FMP (Financial Modeling Prep)

- **官方状态**：无官方 MCP server，无已知社区实现
- **Fallback 方案**：Web Search sec.gov/edgar + tipranks.com

## 当前 MCP 配置

| 子插件 | 启用的 MCP | Fallback 覆盖 |
|--------|-----------|--------------|
| tradfi | alpha-vantage | Yahoo Finance, SEC EDGAR via Web Search |
| crypto | coingecko, dune | DefiLlama via Web Search |
| macro | coingecko | FRED, DefiLlama via Web Search |
| portfolio | （无） | Yahoo Finance via Web Search |

## 后续行动

当以下条件满足时，可考虑引入非官方 MCP：
1. 包版本达到 v1.0.0+
2. GitHub stars > 100
3. 依赖数 < 5
4. 有持续维护（最近 3 个月内有 commit）
5. 通过 `npm audit` / `pip audit` 无漏洞
