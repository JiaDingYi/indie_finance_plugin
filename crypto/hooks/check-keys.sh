#!/bin/bash
# crypto 子插件 — API key 检测与恢复脚本
# 负责的 key: COINGECKO_DEMO_API_KEY, DUNE_API_KEY

PLUGIN_DIR="$(cd "$(dirname "$0")/.." && pwd)"
MCP_JSON="$PLUGIN_DIR/.mcp.json"
KEYS_DIR="$HOME/.indie-finance"
KEYS_FILE="$KEYS_DIR/keys.json"

# 检查 .mcp.json 是否被 git 追踪（源码仓库中阻止写入真实 key）
is_git_tracked() {
  local file="$1"
  git -C "$(dirname "$file")" ls-files --error-unmatch "$(basename "$file")" >/dev/null 2>&1
}

# 用 python3 从 .mcp.json 读取 key 值（通过环境变量传递路径，防止注入）
read_mcp_keys() {
  MCP_PATH="$MCP_JSON" python3 -c "
import json, os
try:
    with open(os.environ['MCP_PATH']) as f:
        data = json.load(f)
    servers = data.get('mcpServers', {})
    cg = servers.get('coingecko', {}).get('env', {}).get('COINGECKO_DEMO_API_KEY', '')
    dune = servers.get('dune', {}).get('headers', {}).get('X-DUNE-API-KEY', '')
    print(cg)
    print(dune)
except Exception:
    print('')
    print('')
"
}

# 用 python3 从 keys.json 读取 key 值
read_keys_json() {
  KEYS_PATH="$KEYS_FILE" python3 -c "
import json, os
try:
    with open(os.environ['KEYS_PATH']) as f:
        data = json.load(f)
    print(data.get('COINGECKO_DEMO_API_KEY', ''))
    print(data.get('DUNE_API_KEY', ''))
except Exception:
    print('')
    print('')
"
}

# 写入 keys.json（创建或更新）
write_keys_json() {
  local key_name="$1"
  local key_value="$2"
  mkdir -p "$KEYS_DIR" && chmod 700 "$KEYS_DIR"
  KEYS_PATH="$KEYS_FILE" KEY_NAME="$key_name" KEY_VALUE="$key_value" python3 -c "
import json, os
path = os.environ['KEYS_PATH']
data = {}
if os.path.exists(path):
    try:
        with open(path) as f:
            data = json.load(f)
    except Exception:
        data = {}
data[os.environ['KEY_NAME']] = os.environ['KEY_VALUE']
with open(path, 'w') as f:
    json.dump(data, f, indent=2)
os.chmod(path, 0o600)
"
}

# 写入 .mcp.json 中的 key
write_mcp_key() {
  local key_type="$1"  # coingecko 或 dune
  local key_value="$2"
  if is_git_tracked "$MCP_JSON"; then
    return 0
  fi
  MCP_PATH="$MCP_JSON" KEY_TYPE="$key_type" KEY_VALUE="$key_value" python3 -c "
import json, os
path = os.environ['MCP_PATH']
with open(path) as f:
    data = json.load(f)
kt = os.environ['KEY_TYPE']
kv = os.environ['KEY_VALUE']
if kt == 'coingecko':
    data['mcpServers']['coingecko']['env']['COINGECKO_DEMO_API_KEY'] = kv
elif kt == 'dune':
    data['mcpServers']['dune']['headers']['X-DUNE-API-KEY'] = kv
with open(path, 'w') as f:
    json.dump(data, f, indent=2)
"
}

# 同步 CoinGecko key 到 macro 插件
sync_coingecko_to_macro() {
  local key_value="$1"
  local macro_mcp="$PLUGIN_DIR/../macro/.mcp.json"
  if [ -f "$macro_mcp" ] && ! is_git_tracked "$macro_mcp"; then
    TARGET_PATH="$macro_mcp" KEY_VALUE="$key_value" python3 -c "
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

MCP_KEYS=$(read_mcp_keys)
MCP_CG=$(echo "$MCP_KEYS" | sed -n '1p')
MCP_DUNE=$(echo "$MCP_KEYS" | sed -n '2p')

STORED_KEYS=$(read_keys_json)
STORED_CG=$(echo "$STORED_KEYS" | sed -n '1p')
STORED_DUNE=$(echo "$STORED_KEYS" | sed -n '2p')

NEED_RESTORE=false
NEED_SETUP=false
NEED_GIT_SKIP=false
MISSING_KEYS=""

# CoinGecko key 检查
if [ -n "$MCP_CG" ] && [ -n "$STORED_CG" ]; then
  : # 两边都有，正常
elif [ -z "$MCP_CG" ] && [ -n "$STORED_CG" ]; then
  # keys.json 有但 mcp 为空 → 恢复
  if is_git_tracked "$MCP_JSON"; then
    NEED_GIT_SKIP=true
  else
    write_mcp_key "coingecko" "$STORED_CG"
    sync_coingecko_to_macro "$STORED_CG"
    NEED_RESTORE=true
  fi
elif [ -n "$MCP_CG" ] && [ -z "$STORED_CG" ]; then
  # mcp 有但 keys.json 没有 → 反向备份
  write_keys_json "COINGECKO_DEMO_API_KEY" "$MCP_CG"
elif [ -z "$MCP_CG" ] && [ -z "$STORED_CG" ]; then
  # 两边都没有 → 需要用户输入
  NEED_SETUP=true
  MISSING_KEYS="$MISSING_KEYS coingecko"
fi

# Dune key 检查
if [ -n "$MCP_DUNE" ] && [ -n "$STORED_DUNE" ]; then
  : # 两边都有，正常
elif [ -z "$MCP_DUNE" ] && [ -n "$STORED_DUNE" ]; then
  if is_git_tracked "$MCP_JSON"; then
    NEED_GIT_SKIP=true
  else
    write_mcp_key "dune" "$STORED_DUNE"
    NEED_RESTORE=true
  fi
elif [ -n "$MCP_DUNE" ] && [ -z "$STORED_DUNE" ]; then
  write_keys_json "DUNE_API_KEY" "$MCP_DUNE"
elif [ -z "$MCP_DUNE" ] && [ -z "$STORED_DUNE" ]; then
  NEED_SETUP=true
  MISSING_KEYS="$MISSING_KEYS dune"
fi

# 输出结果
if [ "$NEED_GIT_SKIP" = true ]; then
  echo "crypto 插件检测到 keys.json 中已有 API key，但当前处于源码仓库中，跳过自动写入 .mcp.json。"
  echo "请在插件安装后的环境中使用，或手动运行 /setup 配置。"
elif [ "$NEED_RESTORE" = true ]; then
  echo "API key 已从备份恢复到 crypto 插件配置。请重启 Claude Code 会话以使 MCP 服务生效。"
fi

if [ "$NEED_SETUP" = true ]; then
  echo "crypto 插件缺少以下 API key，请自动向用户逐个询问并配置："
  if echo "$MISSING_KEYS" | grep -q "coingecko"; then
    echo "- CoinGecko Demo API Key（免费申请：https://www.coingecko.com/en/api/pricing）"
  fi
  if echo "$MISSING_KEYS" | grep -q "dune"; then
    echo "- Dune API Key（免费申请：https://dune.com/settings/api）"
  fi
  echo ""
  echo "获取用户输入后，执行以下操作："
  echo "1. 将 key 写入 ~/.indie-finance/keys.json（目录权限 700，文件权限 600）"
  echo "2. 将 key 写入本插件 .mcp.json 对应字段"
  echo "3. 如果配置了 CoinGecko key，同步写入 ../macro/.mcp.json（如文件存在）"
  echo "4. 完成后告知用户：已保存，请重启会话。"
fi
