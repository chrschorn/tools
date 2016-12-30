""" Open a random file from a directory with the associated default application """

import os
import random
import glob
import argparse
import sys

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('path', nargs='?', type=str, default="**", help="optional path to a specific folder")
    parser.add_argument('-c', '--count', type=int, default=1, help="amount of files to open")
    parser.add_argument('-n', '--non-recursive', action='store_false', help="do not search recursively")

    args = parser.parse_args()

    files = list(filter(lambda s: os.path.isfile(s), glob.glob(args.path, recursive=args.non_recursive)))
    rand_files = random.sample(files, k=args.count)

    for file in rand_files:
        if sys.platform.startswith('win'):
            os.startfile(file)  # on windows only
        else:
            os.system('open ' + file)
