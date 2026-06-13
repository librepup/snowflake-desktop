how() {
  if [ -z "$1" ]; then
    echo "Please provide a prompt. Example: how find all broken symlinks"
    return 1
  fi

  local USER_PROMPT="$*"
  local SCRIPT_PATH="$HOME/.config/ollama/semantic_cache.py"

  # 1. Ask the python script if a closely related question exists in SQLite
  local CACHED_RESPONSE
  CACHED_RESPONSE=$(python3 "$SCRIPT_PATH" "lookup" "$USER_PROMPT" 2>/dev/null)

  if [ $? -eq 0 ] && [ -n "$CACHED_RESPONSE" ]; then
    # Hit! Print the semantic match immediately and exit without waking up the GPU
    echo "$CACHED_RESPONSE"
    return 0
  fi

  # 2. Miss! Run the lightweight 1.5B coder model
  local MODEL="qwen2.5-coder:1.5b"
  local SYSTEM_PROMPT="You are a strict Linux terminal assistant. Output ONLY the working shell command that accomplishes the user request. Do not provide explanations, markdown formatting backticks, markdown code blocks, or conversational text."

  local NEW_RESPONSE
  NEW_RESPONSE=$(ollama run "$MODEL" "System instruction: $SYSTEM_PROMPT \n\n User request: $USER_PROMPT" 2>/dev/null)

  if [ -n "$NEW_RESPONSE" ]; then
    echo "$NEW_RESPONSE"

    # Save the new response and its text vectors into the cache file
    python3 "$SCRIPT_PATH" "save" "$USER_PROMPT" "$NEW_RESPONSE"
  else
    echo "Error: Failed to fetch a command from local Ollama service."
    return 1
  fi

  # 3. Evict the model instantly from your GTX 1080 VRAM footprint
  ollama stop "$MODEL"
}
