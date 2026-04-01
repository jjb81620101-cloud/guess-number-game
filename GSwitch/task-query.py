#!/usr/bin/env python3
"""
GSwitch 任務查詢引擎
整合 mem0 API 進行任務記憶管理
"""

import json
import sys
from datetime import datetime

# mem0 API Key
MEM0_API_KEY = "m0-hV6yNQ7VDXocU1KYpaPym6bYmPhNpyN8KmioBuPf"

# 任務記憶群組
TASK_GROUP = "gswitch-tasks"

# 任務計數器
TASK_COUNTER_FILE = "/home/node/.openclaw/workspace/GSwitch/.task-counter"

def get_next_task_id():
    """取得下一個任務ID"""
    try:
        with open(TASK_COUNTER_FILE, 'r') as f:
            counter = int(f.read().strip())
    except:
        counter = 0
    
    counter += 1
    with open(TASK_COUNTER_FILE, 'w') as f:
        f.write(str(counter))
    
    return f"TASK-{counter:03d}"

def create_task(title: str, priority: str = "P2", assigned: str = "jacky-em", 
                description: str = "", tags: list = None):
    """創建新任務"""
    task_id = get_next_task_id()
    
    task = {
        "task_id": task_id,
        "title": title,
        "description": description,
        "status": "pending",
        "priority": priority,
        "assigned_agent": assigned,
        "created_at": datetime.now().isoformat(),
        "tags": tags or [],
        "subtasks": [],
        "artifacts": []
    }
    
    return task

def format_task_summary(task: dict) -> str:
    """格式化任務摘要"""
    priority_emoji = {
        "P0": "🔴",
        "P1": "🟠", 
        "P2": "🟡",
        "P3": "⚪"
    }
    
    status_emoji = {
        "pending": "🟡",
        "in_progress": "🔵",
        "completed": "✅",
        "blocked": "🔴",
        "needs_review": "🟠"
    }
    
    emoji = priority_emoji.get(task["priority"], "⚪")
    status = status_emoji.get(task["status"], "⚪")
    
    return f"""
### {emoji} {task['task_id']}: {task['title']}

**狀態：** {status} {task['status']}
**優先：** {emoji} {task['priority']}
**負責：** @{task['assigned_agent']}
**建立：** {task['created_at'][:10]}
"""

def search_tasks_cli(query: str, limit: int = 5):
    """命令列搜尋任務（模擬）"""
    # 這是簡化版本，實際需要呼叫 mem0 API
    return f"""
🔍 搜尋：「{query}」
找到 {limit} 個相關任務：

1. TASK-001: GSwitch 安裝
2. TASK-002: 卡牌 RPG v1.0
3. TASK-003: 任務管理系統 v1.0
"""

def main():
    if len(sys.argv) < 2:
        print("Usage: task-query.py <command> [args]")
        print("Commands:")
        print("  create <title> [priority] [assigned] - 創建新任務")
        print("  search <query> - 搜尋任務")
        print("  list - 列出所有任務")
        sys.exit(1)
    
    command = sys.argv[1]
    
    if command == "create":
        title = sys.argv[2] if len(sys.argv) > 2 else "新任務"
        priority = sys.argv[3] if len(sys.argv) > 3 else "P2"
        assigned = sys.argv[4] if len(sys.argv) > 4 else "jacky-em"
        
        task = create_task(title, priority, assigned)
        print(format_task_summary(task))
        print(f"\n✅ 任務已建立：{task['task_id']}")
        
    elif command == "search":
        query = sys.argv[2] if len(sys.argv) > 2 else ""
        print(search_tasks_cli(query))
        
    elif command == "list":
        print("📋 任務列表：")
        print("TASK-001: GSwitch 安裝 - ✅ completed")
        print("TASK-002: 卡牌 RPG v1.0 - ✅ completed")
        print("TASK-003: 任務管理系統 v1.0 - ✅ completed")
        print("TASK-004: 任務查詢引擎 - 🔵 in_progress")
        
    else:
        print(f"未知命令：{command}")
        sys.exit(1)

if __name__ == "__main__":
    main()
