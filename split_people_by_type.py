#!/usr/bin/env python3
"""
将 people.json 中的角色随机分成三组，分别保存到 Cardio.json、Recovery.json 和 Strength.json
"""

import json
import random
from pathlib import Path

def main():
    # 读取 people.json
    json_path = Path(__file__).parent / "assets" / "people.json"
    
    with open(json_path, "r", encoding="utf-8") as f:
        data = json.load(f)
    
    people = data["people"]
    
    # 随机打乱顺序
    random.shuffle(people)
    
    # 分成三组
    total = len(people)
    group_size = total // 3
    remainder = total % 3
    
    # 分配组大小（尽量平均分配）
    sizes = [group_size] * 3
    for i in range(remainder):
        sizes[i] += 1
    
    # 分组
    groups = {
        'Cardio': [],
        'Recovery': [],
        'Strength': []
    }
    
    start = 0
    for i, (group_name, size) in enumerate(zip(groups.keys(), sizes)):
        end = start + size
        groups[group_name] = people[start:end]
        start = end
    
    # 保存到文件
    output_dir = Path(__file__).parent / "assets"
    
    for group_name, group_people in groups.items():
        output_data = {"people": group_people}
        output_path = output_dir / f"{group_name}.json"
        
        with open(output_path, "w", encoding="utf-8") as f:
            json.dump(output_data, f, indent=2, ensure_ascii=False)
        
        print(f"已创建 {group_name}.json，包含 {len(group_people)} 个角色")
    
    print(f"\n总计: {total} 个角色")
    print(f"Cardio: {len(groups['Cardio'])} 个")
    print(f"Recovery: {len(groups['Recovery'])} 个")
    print(f"Strength: {len(groups['Strength'])} 个")

if __name__ == "__main__":
    main()

