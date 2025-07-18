import json

from pprint import pprint


def read_json(file_path):
    with open(file_path, "r", encoding="utf-8") as f:
        data = json.load(f)
    return data


path = "Engines.json"
data = read_json(path)
# print(type(data)) -- dict
# pprint(data, indent=4, width=10)

# 根据一级标签分成一维字典数组
arr = []
for k, v in data.items():
    arr.append({k: v})
pprint(arr, indent=4, width=10)
