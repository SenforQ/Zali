#!/usr/bin/env python3
"""
批量处理 people 文件夹下的图片和视频文件
- 图片重命名为: male_x_img_y.webp / female_x_img_y.webp
- 视频重命名为: male_x_video_y.mp4 / female_x_video_y.mp4
- 非 webp 图片转换为 webp
- 为视频生成 webp 格式的封面图
"""

import os
import re
import shutil
from pathlib import Path
from PIL import Image
import subprocess

# 支持的图片格式
IMAGE_EXTENSIONS = {'.webp', '.jpg', '.jpeg', '.png', '.bmp', '.gif'}
# 支持的视频格式
VIDEO_EXTENSIONS = {'.mp4', '.mov', '.avi', '.mkv'}

def convert_to_webp(input_path, output_path):
    """将图片转换为 webp 格式"""
    try:
        img = Image.open(input_path)
        # 如果是 RGBA 模式，保持透明度
        if img.mode in ('RGBA', 'LA', 'P'):
            img.save(output_path, 'WEBP', quality=90, method=6)
        else:
            # RGB 模式转换为 RGBA 以支持透明度（如果需要）
            rgb_img = Image.new('RGB', img.size, (255, 255, 255))
            if img.mode == 'P':
                img = img.convert('RGBA')
            if img.mode in ('RGBA', 'LA'):
                rgb_img.paste(img, mask=img.split()[-1] if img.mode == 'RGBA' else None)
            else:
                rgb_img.paste(img)
            rgb_img.save(output_path, 'WEBP', quality=90, method=6)
        return True
    except Exception as e:
        print(f"Error converting {input_path} to webp: {e}")
        return False

def extract_video_thumbnail(video_path, thumbnail_path):
    """从视频提取封面图并转换为 webp"""
    try:
        # 使用 ffmpeg 提取第一帧
        temp_thumbnail = str(thumbnail_path).replace('.webp', '_temp.jpg')
        cmd = [
            'ffmpeg',
            '-i', str(video_path),
            '-ss', '00:00:01',  # 提取第1秒的帧（避免黑屏）
            '-vframes', '1',
            '-y',  # 覆盖输出文件
            temp_thumbnail
        ]
        result = subprocess.run(cmd, capture_output=True, text=True)
        
        if result.returncode != 0:
            print(f"ffmpeg error for {video_path}: {result.stderr}")
            return False
        
        # 转换为 webp
        if os.path.exists(temp_thumbnail):
            img = Image.open(temp_thumbnail)
            img.save(thumbnail_path, 'WEBP', quality=90, method=6)
            os.remove(temp_thumbnail)
            return True
        return False
    except Exception as e:
        print(f"Error extracting thumbnail from {video_path}: {e}")
        return False

def process_folder(folder_path):
    """处理单个文件夹"""
    folder_name = folder_path.name
    print(f"\n处理文件夹: {folder_name}")
    
    # 提取类型和编号
    match = re.match(r'^(male|female)_(\d+)$', folder_name)
    if not match:
        print(f"跳过不匹配的文件夹: {folder_name}")
        return
    
    gender = match.group(1)
    number = match.group(2)
    
    # 获取所有文件
    files = list(folder_path.iterdir())
    
    # 分离图片和视频
    image_files = []
    video_files = []
    
    for file in files:
        if file.is_file():
            ext = file.suffix.lower()
            if ext in IMAGE_EXTENSIONS:
                image_files.append(file)
            elif ext in VIDEO_EXTENSIONS:
                video_files.append(file)
    
    # 按文件名排序
    image_files.sort(key=lambda x: x.name)
    video_files.sort(key=lambda x: x.name)
    
    # 处理图片
    img_counter = 1
    for img_file in image_files:
        ext = img_file.suffix.lower()
        new_name = f"{gender}_{number}_img_{img_counter}.webp"
        new_path = folder_path / new_name
        
        if ext == '.webp':
            # 直接重命名
            if img_file.name != new_name:
                img_file.rename(new_path)
                print(f"  重命名图片: {img_file.name} -> {new_name}")
        else:
            # 转换为 webp
            if convert_to_webp(img_file, new_path):
                img_file.unlink()  # 删除原文件
                print(f"  转换图片: {img_file.name} -> {new_name}")
            else:
                print(f"  失败: {img_file.name}")
                continue
        
        img_counter += 1
    
    # 处理视频
    video_counter = 1
    for video_file in video_files:
        ext = video_file.suffix.lower()
        new_name = f"{gender}_{number}_video_{video_counter}.mp4"
        new_path = folder_path / new_name
        
        # 重命名视频
        if video_file.name != new_name:
            video_file.rename(new_path)
            print(f"  重命名视频: {video_file.name} -> {new_name}")
        
        # 生成封面图
        thumbnail_name = f"{gender}_{number}_video_{video_counter}_thumb.webp"
        thumbnail_path = folder_path / thumbnail_name
        
        if extract_video_thumbnail(new_path, thumbnail_path):
            print(f"  生成封面: {thumbnail_name}")
        else:
            print(f"  封面生成失败: {new_name}")
        
        video_counter += 1

def main():
    """主函数"""
    base_path = Path(__file__).parent / 'assets' / 'people'
    
    if not base_path.exists():
        print(f"错误: 找不到目录 {base_path}")
        return
    
    # 检查依赖
    try:
        Image.open  # 检查 PIL
    except:
        print("错误: 请安装 Pillow: pip install Pillow")
        return
    
    # 检查 ffmpeg
    try:
        subprocess.run(['ffmpeg', '-version'], capture_output=True, check=True)
    except:
        print("警告: 未找到 ffmpeg，视频封面提取可能失败")
        print("请安装 ffmpeg: brew install ffmpeg (macOS) 或 apt-get install ffmpeg (Linux)")
    
    # 遍历所有子文件夹
    folders = sorted([f for f in base_path.iterdir() if f.is_dir()])
    
    print(f"找到 {len(folders)} 个文件夹")
    
    for folder in folders:
        process_folder(folder)
    
    print("\n处理完成!")

if __name__ == '__main__':
    main()

