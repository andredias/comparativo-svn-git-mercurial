#!/usr/bin/python3

import re

version = re.compile(r'(\d+\.\d+(\.\d+)?)')
operation_time = re.compile(r'(\w+),\s(\d\.\d+)')


def get_results(filename):
    with open(filename) as f:
        results = f.readlines()
    vcs = {}
    vcs['version'] = version.findall(results.pop(0))[0][0]
    for line in results:
        operation, time = operation_time.findall(line)[0]
        time = int(float(time) * 1000)
        vcs[operation] = max(vcs.get(operation, 0), time)
    return vcs

svn = get_results('/tmp/subversion.results')
git = get_results('/tmp/git.results')
hg = get_results('/tmp/mercurial.results')

print('\n\nTabela .csv:\n')
print(', Subversion %s, Git %s, Mercurial %s' % (svn.pop('version'), git.pop('version'),
                                                 hg.pop('version')))
keys = set(svn.keys()).union(set(git.keys()), set(hg.keys()))
for cmd in sorted(keys):
    print('%s, %s, %s, %s' % (cmd, svn.get(cmd, ''), git.get(cmd, ''), hg.get(cmd, '')))
