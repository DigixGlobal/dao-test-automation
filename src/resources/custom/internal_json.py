import os.path
import json, jsonpointer
import requests

def update_value_to_json(json_object, json_path, new_value):
    dump = json.dumps(json_object)
    data = json.loads(dump)
    data[json_path] = new_value
    return  data

def load_json_from_file(file_name):
    with open(file_name) as json_file:
        data = json.load(json_file)
    return data

def get_value_from_json(json_object,lookup):
    dump = json.dumps(json_object)
    data = json.loads(dump)
    value = jsonpointer.resolve_pointer(data,lookup)
    return json.dumps(value)

def convert_json_to_string(json_object):
    return json.dumps(json_object)

def find_value_on_json_url(url, lookup):
    r = requests.get(url)
    content = r.json()
    dump = json.dumps(content)
    data = json.loads(dump)
    value = jsonpointer.resolve_pointer(data,lookup)
    return value

def find_value_on_json_file(file_dir,lookup):
    file_content = open(file_dir)
    data = file_content.read()
    load = json.loads(data)
    abi = jsonpointer.resolve_pointer(load,lookup)
    abi_dump = json.dumps(abi)
    return abi_dump

def latest_network_address(json_object):
    content = json.loads(json_object)
    values = [(stamp, value['address']) for stamp, value in content.items()]
    address = max(values, key=lambda abc:abc[0])
    return address[1]
