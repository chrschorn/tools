import argparse
import os
import subprocess


def find_file(path, name):
    for root, _, files in os.walk(path):
        if name in files:
            return os.path.abspath(os.path.join(path, root, name))
    raise FileNotFoundError("Could not find pycharm.exe!")


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('path', default='.', help="path to open with PyCharm")
    args = parser.parse_args()

    # assume pycharm is in "Program Files (x86)\JetBrains\<something>" (default install dir)
    jetbrains_path = os.path.join(os.environ['ProgramFiles(x86)'], r"JetBrains")
    pycharm_exe = find_file(jetbrains_path, 'pycharm.exe')

    path = os.path.abspath(args.path)  # pycharm actually can't handle a '.' path

    subprocess.Popen([pycharm_exe, os.path.abspath(path)])
