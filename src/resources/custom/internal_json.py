import os.path
import json, jsonpointer

def update_value_to_json(json_object, json_path, new_value):
    dump = json.dumps(json_object)
    data = json.loads(dump)
    data[json_path] = new_value
    return  data

def load_json_from_file(file_name):
    with open(file_name) as json_file:
        data = json.load(json_file)
    return data

def get_value_from_json(json_object, json_path):
    dump = json.dumps(json_object)
    data = json.loads(dump)
    return data[json_path]

def convert_json_to_string(json_object):
    return json.dumps(json_object)
