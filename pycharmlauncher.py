try:
    import winreg
except ImportError:
    winreg = None
    raise ImportError("This is not made for OS other than Windows (yet).")
import argparse
import os
import subprocess
import json


TOOLBOX_REG_PATH = r"Software\JetBrains s.r.o.\JetBrainsToolbox"


def pick_sorted_folder(dir_path, filter_string=None, reverse=False):
    if filter_string is None:
        filter_string = ''
    folders_in_dir = next(os.walk(dir_path))[1]
    folders_in_dir = list(filter(lambda s: filter_string in s, folders_in_dir))

    if len(folders_in_dir) > 0:
        return os.path.join(dir_path, sorted(folders_in_dir, reverse=reverse)[0])
    else:
        return None


def get_pycharm_exe_path():
    # get toolbox installation path from windows registry
    try:
        reg_handle = winreg.OpenKey(winreg.HKEY_CURRENT_USER, TOOLBOX_REG_PATH)
    except FileNotFoundError:
        raise FileNotFoundError("Could not find JetBrains Toolbox installation directory.")
    toolbox_bin_path = winreg.QueryValue(reg_handle, '')
    reg_handle.Close()

    # find toolbox apps folder
    with open(os.path.join(toolbox_bin_path, '..', '.settings.json'), 'r') as js_file:
        jb_toolbox_settings = json.load(js_file)
    install_location = jb_toolbox_settings.get('install_location')
    if install_location is None:
        install_location = os.path.join(jb_toolbox_settings, '..')
    install_location = os.path.join(install_location, 'apps')

    # prefer pycharm professional version, get lowest channel and highest version number
    pycharm_dir = pick_sorted_folder(install_location, 'PyCharm-P')
    if pycharm_dir is None:
        pycharm_dir = pick_sorted_folder(install_location, 'PyCharm')
    pycharm_channel = pick_sorted_folder(pycharm_dir, 'ch')
    pycharm_version = pick_sorted_folder(pycharm_channel, reverse=True)
    return os.path.join(pycharm_version, 'bin', 'pycharm64.exe')


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('path', nargs='?', default='.', help="path to open with PyCharm")
    args = parser.parse_args()

    pycharm_exe = get_pycharm_exe_path()
    path = os.path.abspath(args.path)  # pycharm actually can't handle a '.' path

    subprocess.Popen([pycharm_exe, os.path.abspath(path)])
