# GSwitch 任務查詢引擎

## 概述

整合 mem0 API 進行長期任務記憶管理，支援：
- 任務歷史搜尋
- 相似任務推薦
- 上下文關聯檢索

---

## mem0 API 整合

```python
import mem0

# 初始化
client = mem0.Client(api_key="m0-hV6yNQ7VDXocU1KYpaPym6bYmPhNpyN8KmioBuPf")

# 記憶群組
TASK_MEMORY_GROUP = "gswitch-tasks"
```

---

## 任務記憶操作

### 1. 儲存任務

```python
def store_task(task_data: dict):
    """儲存任務到 mem0"""
    messages = [
        {"role": "user", "content": f"""
        任務：{task_data['title']}
        狀態：{task_data['status']}
        優先：{task_data['priority']}
        負責：{task_data['assigned_agent']}
        產出：{task_data.get('artifacts', [])}
        """}
    ]
    
    client.messages.create(
        group_name=TASK_MEMORY_GROUP,
        messages=messages,
        metadata={
            "task_id": task_data["task_id"],
            "type": "task",
            "priority": task_data["priority"]
        }
    )
```

### 2. 搜尋任務

```python
def search_tasks(query: str, limit: int = 5):
    """搜尋相關任務"""
    results = client.search(
        query=query,
        group_name=TASK_MEMORY_GROUP,
        limit=limit
    )
    return results
```

### 3. 相似任務推薦

```python
def recommend_related(task_id: str):
    """基於當前任務推薦相關歷史任務"""
    task = get_task(task_id)
    results = search_tasks(
        query=f"{task['title']} {task.get('tags', [])}",
        limit=3
    )
    return results
```

---

## 任務查詢端點

| 查詢類型 | 觸發條件 |
|---------|---------|
| `search:任務關鍵字` | 少爺詢問相關歷史 |
| `related:任務ID` | 新任務需要關聯舊任務 |
| `similar:優先級` | 查看同級別任務 |
| `stats:時間範圍` | 任務統計分析 |

---

## 查詢格式

```
@gswitch search:[關鍵字]
@gswitch related:[任務ID]
@gswitch stats:[本週/本月/全部]
```

---

## 回饋格式

```json
{
  "query": "搜尋內容",
  "results": [
    {
      "task_id": "TASK-XXX",
      "title": "任務標題",
      "relevance": 0.95,
      "excerpt": "相關內容摘要"
    }
  ]
}
```
