#!/bin/bash
# macro 子插件 — API key 检测与恢复脚本
# 负责的 key: COINGECKO_DEMO_API_KEY

PLUGIN_DIR="$(cd "$(dirname "$0")/.." && pwd)"
MCP_JSON="$PLUGIN_DIR/.mcp.json"
KEYS_DIR="$HOME/.indie-finance"
KEYS_FILE="$KEYS_DIR/keys.json"

# 检查文件是否被 git 追踪（源码仓库中阻止写入真实 key）
is_git_tracked() {
  local file="$1"
  git -C "$(dirname "$file")" ls-files --error-unmatch "$(basename "$file")" >/dev/null 2>&1
}

read_mcp_key() {
  MCP_PATH="$MCP_JSON" python3 -c "
import json, os
try:
    with open(os.environ['MCP_PATH']) as f:
        data = json.load(f)
    print(data.get('mcpServers', {}).get('coingecko', {}).get('env', {}).get('COINGECKO_DEMO_API_KEY', ''))
except Exception:
    print('')
"
}

read_keys_json() {
  KEYS_PATH="$KEYS_FILE" python3 -c "
import json, os
try:
    with open(os.environ['KEYS_PATH']) as f:
        data = json.load(f)
    print(data.get('COINGECKO_DEMO_API_KEY', ''))
except Exception:
    print('')
"
}

write_keys_json() {
  local key_value="$1"
  mkdir -p "$KEYS_DIR" && chmod 700 "$KEYS_DIR"
  KEYS_PATH="$KEYS_FILE" KEY_VALUE="$key_value" python3 -c "
import json, os
path = os.environ['KEYS_PATH']
data = {}
if os.path.exists(path):
    try:
        with open(path) as f:
            data = json.load(f)
    except Exception:
        data = {}
data['COINGECKO_DEMO_API_KEY'] = os.environ['KEY_VALUE']
with open(path, 'w') as f:
    json.dump(data, f, indent=2)
os.chmod(path, 0o600)
"
}

write_mcp_key() {
  local key_value="$1"
  if is_git_tracked "$MCP_JSON"; then
    return 0
  fi
  MCP_PATH="$MCP_JSON" KEY_VALUE="$key_value" python3 -c "
import json, os
path = os.environ['MCP_PATH']
with open(path) as f:
    data = json.load(f)
data['mcpServers']['coingecko']['env']['COINGECKO_DEMO_API_KEY'] = os.environ['KEY_VALUE']
with open(path, 'w') as f:
    json.dump(data, f, indent=2)
"
}

sync_coingecko_to_crypto() {
  local key_value="$1"
  local crypto_mcp="$PLUGIN_DIR/../crypto/.mcp.json"
  if [ -f "$crypto_mcp" ] && ! is_git_tracked "$crypto_mcp"; then
    TARGET_PATH="$crypto_mcp" KEY_VALUE="$key_value" python3 -c "
import json, os
path = os.environ['TARGET_PATH']
with open(path) as f:
    data = json.load(f)
if 'coingecko' in data.get('mcpServers', {}):
    data['mcpServers']['coingecko']['env']['COINGECKO_DEMO_API_KEY'] = os.environ['KEY_VALUE']
    with open(path, 'w') as f:
        json.dump(data, f, indent=2)
"
  fi
}

# --- 主逻辑 ---

MCP_CG=$(read_mcp_key)
STORED_CG=$(read_keys_json)

if [ -n "$MCP_CG" ] && [ -n "$STORED_CG" ]; then
  # 两边都有，正常
  exit 0
elif [ -z "$MCP_CG" ] && [ -n "$STORED_CG" ]; then
  # keys.json 有但 mcp 为空 → 恢复
  if is_git_tracked "$MCP_JSON"; then
    echo "macro 插件检测到 keys.json 中已有 API key，但当前处于源码仓库中，跳过自动写入 .mcp.json。"
    echo "请在插件安装后的环境中使用，或手动运行 /setup 配置。"
  else
    write_mcp_key "$STORED_CG"
    sync_coingecko_to_crypto "$STORED_CG"
    echo "API key 已从备份恢复到 macro 插件配置。请重启 Claude Code 会话以使 MCP 服务生效。"
  fi
elif [ -n "$MCP_CG" ] && [ -z "$STORED_CG" ]; then
  # mcp 有但 keys.json 没有 → 反向备份
  write_keys_json "$MCP_CG"
  exit 0
else
  # 两边都没有 → 需要用户输入
  echo "macro 插件缺少 CoinGecko API key，请自动向用户询问并配置："
  echo "- CoinGecko Demo API Key（免费申请：https://www.coingecko.com/en/api/pricing）"
  echo ""
  echo "获取用户输入后，执行以下操作："
  echo "1. 将 key 写入 ~/.indie-finance/keys.json（目录权限 700，文件权限 600）"
  echo "2. 将 key 写入本插件 .mcp.json 的 mcpServers.coingecko.env.COINGECKO_DEMO_API_KEY"
  echo "3. 同步写入 ../crypto/.mcp.json（如文件存在）"
  echo "4. 完成后告知用户：已保存，请重启会话。"
fi
