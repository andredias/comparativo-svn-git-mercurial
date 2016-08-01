#!/usr/bin/python3

'''
OBSERVAÇÃO: O número de linhas do texto de ajuda do Git varia conforme a largura da tela.
Use uma janela com 80 colunas para fazer as medições.
'''

import locale
import re
from itertools import chain
from subprocess import run, PIPE

locale.setlocale(locale.LC_ALL, 'en_US.UTF-8')


def get_svn_commands():
    svn_commands = (
        'svn',
        'svnadmin',
        # 'svnauthz',
        # 'svnauthz-validate',
        # 'svnbench',
        # 'svndumpfilter',
        # 'svnfsfs',
        'svnlook',
        # 'svnmucc',
        # 'svnrdump',
        # 'svnserve',
        # 'svnsync',
        # 'svnversion',
    )
    re_subcmds = re.compile(r'^ {3}([\w-]+)', flags=re.MULTILINE)
    commands = {}
    for command in svn_commands:
        commands[command] = []
        try:
            text = run([command, 'help'], stdout=PIPE, stderr=PIPE, universal_newlines=True, check=True).stdout
            commands[command] = re_subcmds.findall(text)
        except:
            pass
    return commands


def get_git_commands():
    text = run(['git', 'help'], stdout=PIPE, universal_newlines=True).stdout
    comandos_comuns = re.findall(r'^\s{3}([\w-]*)\b', text, flags=re.MULTILINE)
    comandos_comuns.sort()
    text = run(['git', 'help', '-a'], stdout=PIPE, universal_newlines=True).stdout
    todos_cmds = re.findall(r' {2}([\w-]+)\s+([\w-]+)?', text, flags=re.MULTILINE)
    todos_cmds = list(chain(*todos_cmds))
    todos_cmds.sort()
    while not(todos_cmds[0]):
        todos_cmds.pop(0)
    return comandos_comuns, todos_cmds


def get_hg_commands():
    text = run(['hg', 'help'], stdout=PIPE, universal_newlines=True).stdout
    trecho = re.findall(r'list of commands:(.*)additional help topics:', text, flags=re.DOTALL)[0]
    comandos = re.findall(r'^ (\w+)', trecho, flags=re.MULTILINE)
    comandos.sort()
    return comandos


def num_linhas_help(comando, subcomando=None):
    if not subcomando:
        num_linhas = run('%s --help | wc -l' % comando, shell=True, universal_newlines=True,
                         stdout=PIPE, stderr=PIPE).stdout.strip()
    else:
        if comando == 'hg':
            comando = 'chg'
            subcomando = '-v ' + subcomando  # versão estendida do help do Mercurial
        num_linhas = run('%s help %s | wc -l' % (comando, subcomando), shell=True,
                         universal_newlines=True, stdout=PIPE, stderr=PIPE).stdout.strip()
    return int(num_linhas)


def get_help_comandos_comuns():
    subcomandos = (
        'add',
        'backout',
        # 'bisect',
        'blame',
        'branch',
        'cat',
        'checkout',
        'clone',
        'commit',
        'copy',
        'diff',
        'log',
        'merge',
        'mv',
        'pull',
        'push',
        'rebase',
        'reset',
        'revert',
        'rm',
        'show',
        'status',
        'update',
        'tag',
    )
    total_linhas = [0, 0, 0]
    total_comandos = [0, 0, 0]
    seq_vcs = ('svn', 'hg', 'git')
    print('Subcomando,', ', '.join(seq_vcs), end='')
    for subcomando in subcomandos:
        print('\n', subcomando, sep='', end='')
        for i, vcs in enumerate(seq_vcs):
            locale.setlocale(locale.LC_ALL, 'en_US.UTF-8')
            num_linhas = num_linhas_help(vcs, subcomando)
            if vcs == 'hg' and subcomando in ['show', 'checkout']:
                # hg showconfig não faz parte da relação e checkout é apelido para update
                num_linhas = 0
            locale.setlocale(locale.LC_ALL, 'pt_BR.UTF-8')
            print(',', '{:n}'.format(num_linhas) if num_linhas else '', end='')
            if num_linhas:
                total_linhas[i] += num_linhas
                total_comandos[i] += 1
    print('\nTotal linhas, {:n}, {:n}, {:n}'.format(*total_linhas))
    print('Número de comandos, {}, {}, {}'.format(*total_comandos))
    print('Média linhas/comando, {:n}, {:n}, {:n}'.format(*(
        round(linhas / comandos) for linhas, comandos in zip(total_linhas, total_comandos)))
    )
    return


def titulo(texto):
    print('\n\n', texto, sep='')
    print('=' * len(texto), '\n', sep='')


def main():
    titulo('Comandos do Subversion')
    commands = get_svn_commands()
    total_subcomandos = 0
    for command in sorted(commands.keys()):
        print('\n%s: %s subcomandos' % (command, len(commands[command])))
        print('   ', ', '.join(commands[command]))
        total_subcomandos += len(commands[command])
    print('\nTotal:', total_subcomandos)

    titulo('Comandos do Git')
    comuns, comandos = get_git_commands()
    print('Comuns:', len(comuns), 'subcomandos')
    print('   ', ', '.join(comuns))
    print('\nTodos:', len(comandos), 'subcomandos')
    print('   ', ', '.join(comandos))

    titulo('Comandos do Mercurial')
    comandos = get_hg_commands()
    print('hg:', len(comandos), 'subcomandos')
    print('   ', ', '.join(comandos))

    titulo('Número de linhas de help dos comandos mais comuns')
    get_help_comandos_comuns()


if __name__ == '__main__':
    main()
