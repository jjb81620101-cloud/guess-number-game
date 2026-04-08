#!/bin/bash
# state/tasks/task-tracker.sh
# 任務追蹤輔助腳本
# 用法: ./task-tracker.sh [command] [args]

set -e

TASK_DIR="$(dirname "$0")"
DATE=$(date +%Y-%m-%d)
SEQ=$(ls "$TASK_DIR"/task-"$DATE"-*.md 2>/dev/null | wc -l | xargs printf "%03d")
NEXT_SEQ=$((SEQ + 1))

command=$1
shift

case "$command" in
  new)
    # 建立新任務
    TITLE="${1:-新任務}"
    TASK_FILE="task-${DATE}-$(printf "%03d" $NEXT_SEQ).md"
    
    cat > "$TASK_DIR/$TASK_FILE" << EOF
# 任務追蹤

task:
  id: task-${DATE}-$(printf "%03d" $NEXT_SEQ)
  title: "$TITLE"
  status: idle
  created_at: $(date -Iseconds)
  updated_at: $(date -Iseconds)

decomposition: []

progress:
  completed_steps: []
  current_step: null
  remaining_steps: []

blockers: []

deliverables: []

result:
  status: pending
  summary: null
  details: []

notes: |
  # 備註
EOF

    echo "✅ 建立任務: $TASK_FILE"
    echo "$TASK_DIR/$TASK_FILE"
    ;;
    
  status)
    # 更新任務狀態
    TASK_ID=$1
    STATUS=$2
    TASK_FILE=$(ls "$TASK_DIR"/task-"$TASK_ID"*.md 2>/dev/null | head -1)
    
    if [ -z "$TASK_FILE" ]; then
      echo "❌ 找不到任務: $TASK_ID"
      exit 1
    fi
    
    sed -i "s/status:.*/status: $STATUS/" "$TASK_FILE"
    sed -i "s/updated_at:.*/updated_at: $(date -Iseconds)/" "$TASK_FILE"
    
    echo "✅ 更新狀態: $TASK_ID → $STATUS"
    ;;
    
  add-step)
    # 新增子任務步驟
    TASK_ID=$1
    STEP_NAME=$2
    ASSIGNED_TO=${3:-lobster}
    TASK_FILE=$(ls "$TASK_DIR"/task-"$TASK_ID"*.md 2>/dev/null | head -1)
    
    if [ -z "$TASK_FILE" ]; then
      echo "❌ 找不到任務: $TASK_ID"
      exit 1
    fi
    
    STEP_NUM=$(grep -c "^- step:" "$TASK_FILE" 2>/dev/null || echo "0")
    NEW_STEP_NUM=$((STEP_NUM + 1))
    
    cat >> /tmp/step_block.txt << EOF
decomposition:
  - step: $NEW_STEP_NUM
    name: "$STEP_NAME"
    assigned_to: $ASSIGNED_TO
    status: pending
    output: null
EOF

    # 使用更簡單的方式
    echo "" >> "$TASK_FILE"
    echo "  - step: $NEW_STEP_NUM" >> "$TASK_FILE"
    echo "    name: \"$STEP_NAME\"" >> "$TASK_FILE"
    echo "    assigned_to: $ASSIGNED_TO" >> "$TASK_FILE"
    echo "    status: pending" >> "$TASK_FILE"
    echo "    output: null" >> "$TASK_FILE"
    
    echo "✅ 新增步驟: $STEP_NAME → $TASK_FILE"
    ;;
    
  list)
    # 列出今日任務
    echo "📋 今日任務 ($DATE)"
    echo "=================="
    ls -1 "$TASK_DIR"/task-"$DATE"-*.md 2>/dev/null | while read f; do
      TASK_ID=$(basename "$f" .md)
      STATUS=$(grep "^  status:" "$f" 2>/dev/null | cut -d: -f2 | tr -d ' ')
      TITLE=$(grep "^  title:" "$f" 2>/dev/null | cut -d: -f2- | tr -d '"')
      echo "  [$STATUS] $TASK_ID: $TITLE"
    done
    ;;
    
  show)
    # 顯示任務詳情
    TASK_ID=$1
    TASK_FILE=$(ls "$TASK_DIR"/task-"$TASK_ID"*.md 2>/dev/null | head -1)
    
    if [ -z "$TASK_FILE" ]; then
      echo "❌ 找不到任務: $TASK_ID"
      exit 1
    fi
    
    cat "$TASK_FILE"
    ;;
    
  *)
    echo "用法:"
    echo "  $0 new <任務標題>           # 建立新任務"
    echo "  $0 status <任務ID> <狀態>   # 更新狀態"
    echo "  $0 add-step <任務ID> <步驟名> [負責人]  # 新增步驟"
    echo "  $0 list                    # 列出今日任務"
    echo "  $0 show <任務ID>           # 顯示任務詳情"
    echo ""
    echo "狀態: idle | analyzing | planning | executing | integrating | done | abort"
    ;;
esac
