#!/bin/bash
# tradfi 子插件 — API key 检测与恢复脚本
# 负责的 key: ALPHA_VANTAGE_API_KEY（嵌入 URL query param）

PLUGIN_DIR="$(cd "$(dirname "$0")/.." && pwd)"
MCP_JSON="$PLUGIN_DIR/.mcp.json"
KEYS_DIR="$HOME/.indie-finance"
KEYS_FILE="$KEYS_DIR/keys.json"

# 从 .mcp.json 的 URL 中提取 apikey= 后面的值
read_mcp_key() {
  python3 -c "
import json
try:
    with open('$MCP_JSON') as f:
        data = json.load(f)
    url = data.get('mcpServers', {}).get('alpha-vantage', {}).get('url', '')
    if '?apikey=' in url:
        key = url.split('?apikey=', 1)[1]
        # 去除可能的额外 query params
        if '&' in key:
            key = key.split('&', 1)[0]
        print(key)
    else:
        print('')
except Exception:
    print('')
"
}

read_keys_json() {
  python3 -c "
import json
try:
    with open('$KEYS_FILE') as f:
        data = json.load(f)
    print(data.get('ALPHA_VANTAGE_API_KEY', ''))
except Exception:
    print('')
"
}

write_keys_json() {
  local key_value="$1"
  mkdir -p "$KEYS_DIR" && chmod 700 "$KEYS_DIR"
  python3 -c "
import json, os
path = '$KEYS_FILE'
data = {}
if os.path.exists(path):
    try:
        with open(path) as f:
            data = json.load(f)
    except Exception:
        data = {}
data['ALPHA_VANTAGE_API_KEY'] = '$key_value'
with open(path, 'w') as f:
    json.dump(data, f, indent=2)
os.chmod(path, 0o600)
"
}

# 将 key 写入 .mcp.json 的 URL query param
write_mcp_key() {
  local key_value="$1"
  python3 -c "
import json
with open('$MCP_JSON') as f:
    data = json.load(f)
base_url = 'https://mcp.alphavantage.co/mcp?apikey='
data['mcpServers']['alpha-vantage']['url'] = base_url + '$key_value'
with open('$MCP_JSON', 'w') as f:
    json.dump(data, f, indent=2)
"
}

# --- 主逻辑 ---

MCP_KEY=$(read_mcp_key)
STORED_KEY=$(read_keys_json)

if [ -n "$MCP_KEY" ] && [ -n "$STORED_KEY" ]; then
  # 两边都有，正常
  exit 0
elif [ -z "$MCP_KEY" ] && [ -n "$STORED_KEY" ]; then
  # keys.json 有但 mcp 为空 → 恢复
  write_mcp_key "$STORED_KEY"
  echo "API key 已从备份恢复到 tradfi 插件配置。请重启 Claude Code 会话以使 MCP 服务生效。"
elif [ -n "$MCP_KEY" ] && [ -z "$STORED_KEY" ]; then
  # mcp 有但 keys.json 没有 → 反向备份
  write_keys_json "$MCP_KEY"
  exit 0
else
  # 两边都没有 → 需要用户输入
  echo "tradfi 插件缺少 Alpha Vantage API key，请自动向用户询问并配置："
  echo "- Alpha Vantage API Key（免费申请：https://www.alphavantage.co/support/#api-key）"
  echo ""
  echo "获取用户输入后，执行以下操作："
  echo "1. 将 key 写入 ~/.indie-finance/keys.json（目录权限 700，文件权限 600）"
  echo "2. 将 key 嵌入本插件 .mcp.json 的 URL：https://mcp.alphavantage.co/mcp?apikey=用户输入的key"
  echo "3. 完成后告知用户：已保存，请重启会话。"
fi
