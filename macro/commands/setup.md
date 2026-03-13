---
description: Configure API key for macro plugin (CoinGecko)
argument-hint: "[coingecko_key]"
allowed-tools: Read, Edit, Bash, AskUserQuestion
---

# Macro Plugin Setup

配置 macro 插件所需的 API key。

## 步骤

1. 读取当前插件目录下的 `.mcp.json` 文件，检查 `mcpServers.coingecko.env.COINGECKO_DEMO_API_KEY` 是否为空字符串。

2. 读取 `~/.indie-finance/keys.json`（如存在），检查 `COINGECKO_DEMO_API_KEY`。

3. 如果用户通过参数提供了 key（`$ARGUMENTS`），直接使用。

4. 如果参数中没有提供，询问用户：
   - CoinGecko Demo API Key（免费申请：https://www.coingecko.com/en/api/pricing）
   - 如果已有非空值，显示"当前已配置"，询问是否更换

5. 获取 key 后，执行双写：
   - **keys.json**：写入 `~/.indie-finance/keys.json` 的 `COINGECKO_DEMO_API_KEY` 字段。目录权限 700，文件权限 600。如文件已存在则合并更新，不覆盖其他 key。
   - **.mcp.json**：写入 `mcpServers.coingecko.env.COINGECKO_DEMO_API_KEY`

6. **CoinGecko key 同步**：检查 `../crypto/.mcp.json` 是否存在。存在则同步写入其 `mcpServers.coingecko.env.COINGECKO_DEMO_API_KEY`。不存在则跳过，不报错。

7. 完成后提示用户：key 已保存，请重启 Claude Code 会话以使 MCP 服务生效。

## 注意

- 不要将 key 输出到对话中，写入文件即可
- `.mcp.json` 的路径相对于本命令文件所在的插件目录
- `keys.json` 使用 python3 或 Bash 工具操作 JSON，不依赖 jq
