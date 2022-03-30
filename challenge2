import json
import requests

metadata_url = 'http://169.254.169.254/latest/'


def expand_jsontree(metadata_url, meta_path):
    result = {}
    for i in meta_path:
        new_url = metadata_url + i
        r = requests.get(new_url)
        text = r.text
        if i[-1] == "/":
            list_of_values = r.text.splitlines()
            result[i[:-1]] = expand_jsontree(new_url, list_of_values)
        elif is_valid_json(text):
            result[i] = json.loads(text)
        else:
            result[i] = text
    return result


def metadata():
    meta_path = ["meta-data/"]
    result = expand_jsontree(metadata_url, meta_path)
    metadata_json = json.dumps(result, indent=4, sort_keys=True)
    return metadata_json


def is_valid_json(value):
    try:
        json.loads(value)
    except ValueError:
        return False
    return True


if __name__ == '__main__':
    print(metadata())
