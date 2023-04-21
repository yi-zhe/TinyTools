import os
import re


# 遍历项目目录，找到所有的 Java 和 Kotlin 文件
def find_java_kotlin_files(root_folder):
    file_list = []
    for root, dirs, files in os.walk(root_folder):
        for file in files:
            if file.endswith('.java') or file.endswith('.kt'):
                file_list.append(os.path.join(root, file))
    return file_list


# 分析源代码，找到所有引用的类
def find_imported_classes(file_list):
    imported_classes = set()
    for file in file_list:
        with open(file, 'r', encoding='utf-8') as f:
            content = f.read()
            imports = re.findall(r'import ([\w.]+)', content)
            for import_class in imports:
                imported_classes.add(import_class)
    return imported_classes


# 确定哪些类没有被引用
def find_unused_classes(file_list, imported_classes):
    unused_classes = set()
    for file in file_list:
        class_name = os.path.splitext(os.path.basename(file))[0]
        full_class_name = os.path.splitext(file.replace('/', '.'))[0]
        if full_class_name not in imported_classes:
            unused_classes.add(file)
    return unused_classes


# 修改此处为您的项目根目录
project_root = '/Users/liuyang/projects/ZhuxianPCHelper'

file_list = find_java_kotlin_files(project_root)
imported_classes = find_imported_classes(file_list)
unused_classes = find_unused_classes(file_list, imported_classes)

print("未被引用的类：")
for unused_class in unused_classes:
    print(unused_class)
