#!/usr/bin/env python3
"""
为 people.json 中的每个角色添加锻炼时长字段
"""

import json
import random
from pathlib import Path

def main():
    json_path = Path(__file__).parent / "assets" / "people.json"
    
    with open(json_path, "r", encoding="utf-8") as f:
        data = json.load(f)
    
    # 为每个角色添加锻炼时长（30-180分钟）
    for person in data["people"]:
        person["ZaliWorkoutDuration"] = random.randint(30, 180)
    
    # 保存更新后的 JSON
    with open(json_path, "w", encoding="utf-8") as f:
        json.dump(data, f, indent=2, ensure_ascii=False)
    
    print(f"已为 {len(data['people'])} 个角色添加锻炼时长字段")
    
    # 显示前10个锻炼时长最长的角色
    sorted_people = sorted(data["people"], key=lambda x: x["ZaliWorkoutDuration"], reverse=True)
    print("\n前10个锻炼时长最长的角色:")
    for i, person in enumerate(sorted_people[:10], 1):
        print(f"{i}. {person['ZaliNickName']}: {person['ZaliWorkoutDuration']} 分钟")

if __name__ == "__main__":
    main()

