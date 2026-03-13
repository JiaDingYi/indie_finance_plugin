---
description: Configure API key for tradfi plugin (Alpha Vantage)
argument-hint: "[alphavantage_key]"
allowed-tools: Read, Edit, Bash, AskUserQuestion
---

# TradFi Plugin Setup

配置 tradfi 插件所需的 API key。

## 步骤

1. 读取当前插件目录下的 `.mcp.json` 文件，检查 `alpha-vantage` 的 URL 中 `?apikey=` 后面是否有值。

2. 读取 `~/.indie-finance/keys.json`（如存在），检查 `ALPHA_VANTAGE_API_KEY` 是否有值。

3. 如果用户通过参数提供了 key（`$ARGUMENTS`），直接使用。

4. 如果参数中没有提供，询问用户：
   - Alpha Vantage API Key（免费申请：https://www.alphavantage.co/support/#api-key）
   - 如果已有非空值，显示"当前已配置"，询问是否更换

5. 获取 key 后，执行双写：
   - **keys.json**：写入 `~/.indie-finance/keys.json` 的 `ALPHA_VANTAGE_API_KEY` 字段。目录权限 700，文件权限 600。如文件已存在则合并更新，不覆盖其他 key。
   - **.mcp.json**：将 key 嵌入 URL，格式为 `https://mcp.alphavantage.co/mcp?apikey=用户输入的key`

6. 完成后提示用户：key 已保存，请重启 Claude Code 会话以使 MCP 服务生效。

## 注意

- 不要将 key 输出到对话中，写入文件即可
- `.mcp.json` 的路径相对于本命令文件所在的插件目录
- `keys.json` 使用 python3 或 Bash 工具操作 JSON，不依赖 jq
