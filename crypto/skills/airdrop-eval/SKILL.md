---
name: airdrop-eval
description: |
  空投项目评估 — 基于六维度评分框架（发币意愿/筹码获取/增长性/单位成本/暴击几率/风险）
  对项目进行 0-5 分评分，总分 30 分制，输出档位判定（Sprint/中等维护/低保维护）。
  输出格式对齐 P-xxx 空投评估模板。Triggers on "空投评估", "airdrop evaluation",
  "项目评分", "airdrop scoring", "空投分析", "evaluate airdrop", or "P-xxx".
---

# Airdrop Evaluation

基于六维度评分框架对空投项目进行综合评估，输出 P-xxx 格式报告。

## Data Source Priority

### Layer 1: MCP
- **coingecko** — 代币信息（如已发币）
- **defillama** — TVL 趋势、协议数据

### Layer 2: Web Search
- 融资背景、团队信息、社区规模、积分机制、官方公告

### Layer 3: Chrome CDP
- 官网、文档、Discord

## Workflow

### Step 1: Identify Project
- 解析项目名称
- 查找官网、文档、社交媒体链接
- 确认项目状态（是否已发币、是否有积分系统）

### Step 2: Auto-Fetch Data
自动拉取可获取的数据：
- coingecko: 代币信息（如已发币）
- defillama: TVL、链分布、交易量
- Web Search: 融资轮次、估值、团队背景、积分机制细节、社区规模、KOL 讨论

### Step 3: Pre-Fill Scoring
基于获取的数据，为每个维度预填评分建议：

| 维度 | 建议分数 | 依据 | 不确定性 |
|------|---------|------|---------|
| 发币意愿 | X | [data] | [unknowns] |
| 筹码获取 | X | [data] | [unknowns] |
| 增长与可持续性 | X | [data] | [unknowns] |
| 单位成本 | X | [data] | [unknowns] |
| 暴击几率 | X | [data] | [unknowns] |
| 风险等级 | X | [data] | [unknowns] |

**明确标注这些是建议评分，等待用户确认或调整。**

### Step 4: User Confirms/Adjusts
- 呈现预填结果，请用户逐项确认或修改
- 用户可以补充自己的判断依据
- 记录最终确认的评分

### Step 5: Generate Report
按 P-xxx 模板输出最终报告。

## Output Template (P-xxx Format)

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

## Scoring Framework

详细评分标准见 `references/scoring-framework.md`，包含：
- 六维度的完整 0-5 分评分指南
- 每个分数档位的具体标准
- 自动数据辅助说明
- 档位判定规则（AND 逻辑）

## Output Format

- **Primary**: `P-{ProjectName}空投.md`
- Footer: 数据来源、数据时间戳、免责声明
- 评分以粗体 `**X**` 显示

## Quality Checklist

- [ ] 六维度全部评分（无空白）
- [ ] 每项评分至少有一条关键依据
- [ ] 每项评分至少有一条扣分点/不确定性（即使很小）
- [ ] 档位判定正确应用 AND 逻辑（所有条件都须满足）
- [ ] 每条依据标注数据来源
- [ ] 预填评分明确标注为建议，直到用户确认
