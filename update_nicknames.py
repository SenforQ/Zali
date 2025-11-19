#!/usr/bin/env python3
"""
更新 people.json 中的 ZaliNickName，改为正常的用户名称（不带下划线和序号）
"""

import json
import random
from pathlib import Path

# 常见的英文名字池
FIRST_NAMES = [
    "Alex", "Jordan", "Taylor", "Casey", "Morgan", "Riley", "Avery", "Quinn",
    "Sage", "River", "Skyler", "Phoenix", "Blake", "Cameron", "Dakota", "Emery",
    "Finley", "Harper", "Hayden", "Kai", "Logan", "Mason", "Noah", "Parker",
    "Reese", "Rowan", "Sawyer", "Spencer", "Tyler", "Zane", "Aiden", "Blake",
    "Carter", "Dylan", "Ethan", "Finn", "Grayson", "Hunter", "Isaac", "Jaden",
    "Kai", "Liam", "Mason", "Nolan", "Owen", "Parker", "Quinn", "Ryan",
    "Sam", "Tyler", "Zach", "Amara", "Bella", "Chloe", "Diana", "Emma",
    "Fiona", "Grace", "Hannah", "Iris", "Jade", "Kate", "Luna", "Maya",
    "Nora", "Olivia", "Paige", "Quinn", "Ruby", "Sofia", "Tara", "Vera",
    "Willow", "Zoe", "Aria", "Brielle", "Cora", "Dahlia", "Elena", "Freya",
]

# 姓氏池
LAST_NAMES = [
    "Anderson", "Brown", "Chen", "Davis", "Evans", "Foster", "Garcia", "Harris",
    "Jackson", "Kim", "Lee", "Martinez", "Nguyen", "Patel", "Rodriguez", "Smith",
    "Taylor", "Wang", "White", "Young", "Zhang", "Adams", "Baker", "Clark",
    "Cooper", "Edwards", "Green", "Hall", "Hill", "Johnson", "King", "Lewis",
    "Miller", "Moore", "Nelson", "Parker", "Roberts", "Scott", "Thompson", "Walker",
    "Wilson", "Wright", "Allen", "Bell", "Brooks", "Campbell", "Carter", "Collins",
    "Cook", "Cox", "Fisher", "Gray", "Griffin", "Hayes", "Hughes", "James",
    "Jenkins", "Kelly", "Kennedy", "Mitchell", "Murphy", "Perez", "Phillips", "Reed",
]

def generate_nickname():
    """生成正常的用户名称"""
    first_name = random.choice(FIRST_NAMES)
    last_name = random.choice(LAST_NAMES)
    return f"{first_name} {last_name}"

def main():
    json_path = Path(__file__).parent / "assets" / "people.json"
    
    with open(json_path, "r", encoding="utf-8") as f:
        data = json.load(f)
    
    # 确保每个名字都是唯一的
    used_names = set()
    
    for person in data["people"]:
        while True:
            new_name = generate_nickname()
            if new_name not in used_names:
                used_names.add(new_name)
                person["ZaliNickName"] = new_name
                break
    
    # 保存更新后的 JSON
    with open(json_path, "w", encoding="utf-8") as f:
        json.dump(data, f, indent=2, ensure_ascii=False)
    
    print(f"已更新 {len(data['people'])} 个角色的昵称")
    print("\n新的昵称列表:")
    for i, person in enumerate(data["people"], 1):
        print(f"{i}. {person['ZaliNickName']}")

if __name__ == "__main__":
    main()

