import sys
import subprocess
from datetime import datetime
from datetime import timedelta


def strftimedelta(delta):
    res = []
    if(delta.days > 0):
        res.append(delta.days)
        res.append('days,')

    minutes = delta.seconds // 60
    res.append(str(minutes // 60).zfill(2) + ':' +
               str(minutes % 60).zfill(2) + 'h')
    return ' '.join(res)


if __name__ == '__main__':
    sys.argv.pop(0)  # remove file name
    if len(sys.argv) == 0:
        shutdowntime = "0:00"
    elif sys.argv[0] in ('-a', '--abort'):
        subprocess.run(['shutdown', '/a'])
        sys.exit()
    else:
        shutdowntime = sys.argv[0]

    shutdowntime = list(map(int, shutdowntime.split(':')))
    now = datetime.now()
    shutdowntime = datetime(now.year, now.month, now.day, *shutdowntime)

    if shutdowntime < now:
        # shutdonwtime is "tomorrow" instead, add one day to shutdowntime
        shutdowntime = shutdowntime + timedelta(1, 0, 0)

    delta = shutdowntime - now
    msg = '"Shutdown in {}! At {}."'.format(
        strftimedelta(delta),
        shutdowntime.strftime("%H:%M")
    )
    subprocess.run([
        'shutdown', '/s', '/f',
        '/t', str(delta.seconds),
        '/c', msg]
    )
