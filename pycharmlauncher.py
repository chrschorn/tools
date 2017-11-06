from contextlib import contextmanager

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
PYCHARM_REG_PATH = r"Software\JetBrains"


def pick_sorted_folder(dir_path, filter_string=None, reverse=False):
    if filter_string is None:
        filter_string = ''
    folders_in_dir = next(os.walk(dir_path))[1]
    folders_in_dir = list(filter(lambda s: filter_string in s, folders_in_dir))

    if len(folders_in_dir) > 0:
        return os.path.join(dir_path, sorted(folders_in_dir, reverse=reverse)[0])
    else:
        return None


def get_winreg_subkeys(key):
    subkeys = list()
    try:
        i = 0
        while True:
            subkeys.append(winreg.EnumKey(key, i))
            i += 1
    except OSError:
        pass

    return subkeys


@contextmanager
def get_winreg_key_handle(*args, key=winreg.HKEY_CURRENT_USER):
    handle = winreg.OpenKey(key, os.path.join(*args))
    yield handle
    winreg.CloseKey(handle)


def get_pycharm_exe_path():
    # get toolbox installation path from windows registry
    toolbox = False
    not_found_error = FileNotFoundError("No PyCharm found in registry!")
    try:
        reg_handle = winreg.OpenKey(winreg.HKEY_CURRENT_USER, TOOLBOX_REG_PATH)
        toolbox = True
    except FileNotFoundError:
        # no jetbrains toolbox found
        try:
            reg_handle = winreg.OpenKey(winreg.HKEY_CURRENT_USER, PYCHARM_REG_PATH)
        except FileNotFoundError:
            raise not_found_error

    if toolbox:
        # toolbox was found
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

    else:
        # no toolbox
        subkeys = get_winreg_subkeys(reg_handle)
        winreg.CloseKey(reg_handle)

        if not subkeys:
            raise not_found_error

        subkey = subkeys[0]

        # find professional version if possible
        for sk in subkeys:
            if 'prof' in sk.lower():
                subkey = sk

        # get version subkeys
        with get_winreg_key_handle(PYCHARM_REG_PATH, subkey) as reg_handle:
            version_subkeys = get_winreg_subkeys(reg_handle)

        if not version_subkeys:
            raise not_found_error

        # use highest version
        highest_version = sorted(version_subkeys)[-1]

        # get installation path of this version
        with get_winreg_key_handle(PYCHARM_REG_PATH, subkey, highest_version) as reg_handle:
            pycharm_path = winreg.QueryValue(reg_handle, '')

        return os.path.join(pycharm_path, 'bin', 'pycharm64.exe')


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('path', nargs='?', default='.', help="path to open with PyCharm")
    args = parser.parse_args()

    pycharm_exe = get_pycharm_exe_path()
    path = os.path.abspath(args.path)  # pycharm actually can't handle a '.' path

    subprocess.Popen([pycharm_exe, path])
