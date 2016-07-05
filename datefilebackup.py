import argparse
import os
import shutil
from datetime import datetime


def date_file_copy(file, path=None, name=None):
    """
    Copies a file while extending its name by date and time (iso format)
    :param file: file name
    :param path: optional destination path. default: make copy next to the file itself
    """
    iso_date = datetime.now().strftime('%Y-%m-%dT%H-%M-%S')
    file_path, file_name = os.path.split(file)
    file_name, ext = os.path.splitext(file_name)
    if not name:
        name = file_name
    new_file = name + '_' + iso_date + ext

    dest = path if path else file_path
    dest = os.path.join(os.path.abspath(dest), new_file)

    shutil.copy2(file, dest)


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('file', type=str, help="File to backup")
    parser.add_argument('path', nargs='?', type=str, default=None, help="Path to copy the file to")
    parser.add_argument('name', nargs='?', type=str, default=None, help="New filename")
    args = parser.parse_args()

    date_file_copy(args.file, args.path, args.name)
