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
    parser.add_argument('-b', '--blacklist', nargs='+', help="file endings not to open")

    args = parser.parse_args()

    # support a 'plain' path like C:/a/b/c
    # user can also specify his own pattern (e.g. C:/a/**/*.txt)
    if '*' not in args.path:
        args.path = os.path.join(args.path, '**')


    rand_files = list(filter(lambda s: os.path.isfile(s), glob.glob(args.path, recursive=args.non_recursive)))

    if args.blacklist:
        args.blacklist = tuple(args.blacklist)
        rand_files = [file for file in rand_files if not file.endswith(args.blacklist)]

    try:
        rand_files = random.sample(rand_files, k=args.count)
    except ValueError:
        print("Less than {} file(s) found!".format(args.count))

    for file in rand_files:
        if sys.platform.startswith('win'):
            os.startfile(file)  # on windows only
        else:
            os.system('open ' + file)
