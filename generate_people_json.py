#!/usr/bin/env python3
"""
生成 people.json 文件，包含所有角色的 MBTI 性格信息
"""

import os
import json
import random
from pathlib import Path

# 16 种 MBTI 性格类型
MBTI_TYPES = [
    "INTJ", "INTP", "ENTJ", "ENTP",  # 分析家
    "INFJ", "INFP", "ENFJ", "ENFP",  # 外交家
    "ISTJ", "ISFJ", "ESTJ", "ESFJ",  # 守护者
    "ISTP", "ISFP", "ESTP", "ESFP",  # 探险家
]

# MBTI 性格描述模板（针对健身和极限运动爱好者）
MBTI_DESCRIPTIONS = {
    "INTJ": "Strategic fitness enthusiast who plans intense workouts and loves challenging extreme sports. Analytical approach to training.",
    "INTP": "Innovative athlete experimenting with new training methods. Enjoys solving physical challenges through creative movement.",
    "ENTJ": "Natural leader in group fitness. Organizes extreme sports adventures and motivates others to push their limits.",
    "ENTP": "Adventurous spirit always trying new fitness trends. Loves debating training techniques and exploring extreme sports.",
    "INFJ": "Intuitive trainer focused on holistic wellness. Passionate about connecting mind and body through extreme challenges.",
    "INFP": "Creative fitness artist expressing through movement. Finds personal meaning in challenging physical adventures.",
    "ENFJ": "Inspiring coach who motivates others. Creates supportive communities around fitness and extreme sports.",
    "ENFP": "Energetic fitness enthusiast bringing joy to workouts. Loves sharing exciting extreme sports experiences.",
    "ISTJ": "Disciplined athlete following structured training plans. Reliable partner for consistent extreme sports practice.",
    "ISFJ": "Supportive fitness companion helping others achieve goals. Gentle approach to challenging physical activities.",
    "ESTJ": "Organized fitness leader setting clear goals. Efficient planner of group extreme sports events.",
    "ESFJ": "Social fitness coordinator bringing people together. Creates welcoming environments for extreme sports.",
    "ISTP": "Practical problem-solver in fitness challenges. Hands-on approach to mastering extreme sports techniques.",
    "ISFP": "Artistic athlete expressing through movement. Finds beauty in challenging physical experiences.",
    "ESTP": "Action-oriented thrill-seeker in fitness. Lives for the adrenaline rush of extreme sports.",
    "ESFP": "Vibrant fitness performer sharing energy. Loves the excitement and social aspect of extreme sports.",
}

# 打招呼模板
GREETING_TEMPLATES = [
    "Hey! Ready to crush some workouts together? Let's push our limits!",
    "What's up! I'm always down for a fitness challenge. Want to join?",
    "Hi there! Love your energy. Let's talk about our favorite extreme sports!",
    "Hey! Just finished an amazing training session. What are you up to?",
    "Hello! Always excited to connect with fellow fitness enthusiasts!",
    "Hi! Looking for a workout buddy? I'm your person!",
    "Hey! Let's share our fitness goals and motivate each other!",
    "What's good! Ready to discuss the latest training techniques?",
]

# 敏感词汇检查
SENSITIVE_WORDS = [
    "government", "legal", "hospital", "medical", "doctor", "lawyer",
    "police", "court", "judge", "law", "regulation", "policy",
    "political", "minister", "president", "official", "clinic",
]

def contains_sensitive_words(text):
    """检查文本是否包含敏感词汇"""
    text_lower = text.lower()
    return any(word in text_lower for word in SENSITIVE_WORDS)

def generate_motto(mbti_type):
    """生成基于 MBTI 的自我介绍（100-200 字符）"""
    base_description = MBTI_DESCRIPTIONS.get(mbti_type, "Fitness enthusiast passionate about training and extreme sports.")
    
    # 添加个性化元素
    fitness_interests = [
        "Passionate about calisthenics and bodyweight training.",
        "Love rock climbing and outdoor adventures.",
        "Dedicated to functional fitness and movement.",
        "Thrives on high-intensity interval training.",
        "Enjoys yoga and flexibility work.",
        "Focused on strength and power development.",
    ]
    
    motto = f"{base_description} {random.choice(fitness_interests)}"
    
    # 确保长度在 100-200 字符之间
    while len(motto) < 100:
        motto += " Always pushing boundaries and exploring new challenges."
    
    if len(motto) > 200:
        motto = motto[:197] + "..."
    
    # 检查敏感词汇
    if contains_sensitive_words(motto):
        motto = generate_motto(mbti_type)  # 重新生成
    
    return motto

def generate_greeting():
    """生成打招呼文案（100-200 字符）"""
    greeting = random.choice(GREETING_TEMPLATES)
    
    # 添加个性化内容
    additions = [
        " I just discovered an amazing new workout routine!",
        " Can't wait to share my latest fitness journey with you!",
        " Let's motivate each other to reach our goals!",
        " Always looking for new training partners and friends!",
        " Hope you're having an awesome day full of movement!",
    ]
    
    greeting += random.choice(additions)
    
    # 确保长度在 100-200 字符之间
    while len(greeting) < 100:
        greeting += " What's your favorite way to stay active?"
    
    if len(greeting) > 200:
        greeting = greeting[:197] + "..."
    
    # 检查敏感词汇
    if contains_sensitive_words(greeting):
        greeting = generate_greeting()  # 重新生成
    
    return greeting

def get_nickname(gender, number):
    """生成网络昵称"""
    prefixes = {
        "male": ["Fit", "Strong", "Power", "Elite", "Pro", "Apex", "Prime", "Max"],
        "female": ["Fit", "Strong", "Elite", "Apex", "Prime", "Max", "Zen", "Flow"],
    }
    
    suffixes = ["Warrior", "Athlete", "Beast", "Champion", "Legend", "Hero", "Star", "Force"]
    
    prefix = random.choice(prefixes.get(gender, ["Fit"]))
    suffix = random.choice(suffixes)
    number_suffix = random.choice(["", f"{number}", f"_{number}", ""])
    
    return f"{prefix}{suffix}{number_suffix}"

def process_folder(folder_path):
    """处理单个文件夹，生成角色信息"""
    folder_name = folder_path.name
    match = folder_name.split("_")
    
    if len(match) < 2:
        return None
    
    gender = match[0]
    number = match[1]
    
    # 获取所有文件
    files = sorted(folder_path.iterdir())
    
    # 分离图片、视频和封面
    images = []
    videos = []
    thumbnails = []
    
    for file in files:
        if file.is_file():
            name = file.name
            if name.startswith(f"{gender}_{number}_img_"):
                images.append(f"assets/people/{folder_name}/{name}")
            elif name.startswith(f"{gender}_{number}_video_") and name.endswith(".mp4"):
                videos.append(f"assets/people/{folder_name}/{name}")
            elif name.startswith(f"{gender}_{number}_video_") and "_thumb.webp" in name:
                thumbnails.append(f"assets/people/{folder_name}/{name}")
    
    # 生成角色信息
    mbti_type = random.choice(MBTI_TYPES)
    
    # 头像使用第一张图片（如果没有 character 文件夹）
    user_icon = images[0] if images else f"assets/people/{folder_name}/{gender}_{number}_img_1.webp"
    
    character = {
        "ZaliNickName": get_nickname(gender, number),
        "ZaliUserIcon": user_icon,
        "ZaliShowPhotoArray": images,
        "ZaliShowVideoArray": videos,
        "ZaliShowThumbnailArray": thumbnails,
        "ZaliShowMotto": generate_motto(mbti_type),
        "ZaliShowFollowNum": random.randint(2, 10),
        "ZaliShowLike": random.randint(5, 15),
        "ZaliShowSayhi": generate_greeting(),
    }
    
    return character

def main():
    """主函数"""
    base_path = Path(__file__).parent / "assets" / "people"
    
    if not base_path.exists():
        print(f"错误: 找不到目录 {base_path}")
        return
    
    # 获取所有子文件夹
    folders = sorted([f for f in base_path.iterdir() if f.is_dir()])
    
    print(f"找到 {len(folders)} 个文件夹")
    
    characters = []
    for folder in folders:
        character = process_folder(folder)
        if character:
            characters.append(character)
            print(f"处理完成: {folder.name}")
    
    # 生成 JSON
    output_data = {
        "people": characters
    }
    
    # 保存到文件
    output_path = Path(__file__).parent / "assets" / "people.json"
    with open(output_path, "w", encoding="utf-8") as f:
        json.dump(output_data, f, indent=2, ensure_ascii=False)
    
    print(f"\n成功生成 {len(characters)} 个角色信息")
    print(f"文件保存至: {output_path}")

if __name__ == "__main__":
    main()

