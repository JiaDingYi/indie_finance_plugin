# Chrome CDP 大页面降级策略设计

## 背景

`mcp__claude-in-chrome__get_page_text` 默认 `max_chars=50000`。金融数据页面（财报、利润表、DeFi 数据等）动辄 100K+ 字符，触发 "Output exceeds character limit" 错误。当前 CLAUDE.md 的 Layer 2 定义未覆盖此场景，导致 Claude 直接跳回 Layer 3 Web Search，放弃了已经导航到的页面。

## 目标

在 CLAUDE.md 全局 Layer 2 定义中补充响应式降级规则，所有子插件自动继承，无需修改任何 SKILL.md。

## 不在范围内

- 主动识别"已知大站"的预判逻辑（维护成本高，易过时）
- 修改任何 SKILL.md 或 commands/*.md

## 设计

### 改动文件

`CLAUDE.md` — Layer 2 段落末尾追加"页面过大时的工具降级顺序"子段落。

### 降级顺序

```
Step 1: get_page_text（默认）
Step 2: Step 1 报 "Output exceeds character limit" →
        read_page 获取 DOM 结构，定位数据所在区域的 ref_id，
        再用 read_page(ref_id=...) 精准读取
        → Step 2 失败定义：无法找到包含目标数据的 ref_id，
          或 read_page(ref_id=...) 返回空内容
Step 3: Step 2 成功但目标数据不完整
        （表格行缺失、财务指标关键行缺失等可观测缺口）→
        get_page_text(max_chars=200000) 补全
        → Step 3 失败定义：仍报字符超限，或目标数据仍不完整
Step 4: Step 2 失败 或 Step 3 失败 → fallback 回 Layer 3 Web Search
```

### 触发条件

纯响应式——仅在 `get_page_text` 返回字符超限错误时触发，不做预判。

### 工具对应关系

| 工具 | 用途 |
|------|------|
| `mcp__claude-in-chrome__get_page_text` | Step 1 / Step 3（加 max_chars） |
| `mcp__claude-in-chrome__read_page` | Step 2（获取 DOM + 按 ref_id 精准读取） |

## 最终 CLAUDE.md diff

```diff
 Layer 2: Chrome CDP 直接访问（MCP 不可用或数据不足时）
   → 通过浏览器直接访问目标 URL
   → 适用：需要登录的页面、被 bot 检测拦截的站点、动态渲染页面
   → 标注 "Source: Direct Fetch - [URL]"
+
+  【页面过大时的工具降级顺序】
+  Step 1: get_page_text（默认）
+  Step 2: Step 1 报 "Output exceeds character limit" →
+          read_page 获取 DOM 结构，定位数据所在区域的 ref_id，
+          再用 read_page(ref_id=...) 精准读取；
+          若无法找到目标 ref_id 或返回空内容 → 直接 Step 4
+  Step 3: Step 2 成功但目标数据不完整
+          （表格行缺失、财务指标关键行缺失等可观测缺口）→
+          get_page_text(max_chars=200000) 补全；
+          若仍报超限或数据仍不完整 → Step 4
+  Step 4: fallback 回 Layer 3 Web Search
```

## 决策记录

- **不维护已知大站列表**：触发条件改为响应错误信号，避免列表过时
- **Step 3 仅在内容不完整时触发**：区别于 DOM 结构复杂导致的失败（此时 200K 只是放大噪音）
- **改动范围限 CLAUDE.md**：单一来源，所有 skill 自动继承
