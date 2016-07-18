#!/bin/bash
# Teste de desempenho entre Subversion, Git e Mercurial

TIMEFORMAT=" %R"
scriptpath=$(dirname $(readlink -f $0))

function mede {
    echo $1 | cut -f 2 -d ' ' | tr '\n' ',' | tee -a $results
    (time $1 1> /dev/null 2>&1) 2>&1 | tee -a $results
}

function alteracoes {
    case "$1" in
        1)
            for comando in 'add' 'commit' 'merge' 'log' 'rebase' 'diff' 'pull'; do
                # texto do git foi escolhido por ser mais extenso
                (git help $comando) > $comando.txt
            done
            ;;

        2)
            sed -i 's/edit hello.c/nano ola_mundo.py/g' commit.txt
            sed -i 's/log/nhem-nhem-nhem/g' log.txt
            sed -i 's/pull/nhem-nhem-nhem/g' pull.txt
            ;;

        3)
            git help rebase >> log.txt
            sed -i 's/commit/blablabla/g' commit.txt
            sed -i 's/diff/blablabla/g' diff.txt
            ;;
    esac
}


#
# Subversion
#

results='/tmp/subversion.results'

echo '-----------------------------'
svn --version | grep '\bversion' | tee $results
echo '-----------------------------'
echo 'comando, real'

cd /tmp
if [ -d "svn-repos" ]; then
    rm -rf svn-repos
fi
if [ -d "svn-1" ]; then
    rm -rf svn-1
fi
if [ -d "svn-2" ]; then
    rm -rf svn-2
fi

mede 'svnadmin create svn-repos'
path='file:///tmp/svn-repos'
mede "svn mkdir $path/trunk $path/branches $path/tags -m estrutura_inicial --username Fulano"
mede "svn checkout $path/trunk svn-1"

cd /tmp/svn-1
alteracoes 1

mede 'svn add *'
mede 'svn commit -m adicao --username Fulano'

cd /tmp
mede 'svn checkout file:///tmp/svn-repos/trunk svn-2'

cd /tmp/svn-1
alteracoes 2

mede 'svn diff'
mede 'svn status'
mede 'svn commit -m blablabla --username Fulano'

cd /tmp/svn-2
alteracoes 3

mede 'svn diff'
mede 'svn status'
mede 'svn update'
mede 'svn commit -m ola_mundo_nhem-nhem-nhem --username Beltrano'
mede 'svn log'



#
# Mercurial com chg
#

results='/tmp/mercurial.results'

echo
echo '-----------------------------------------'
chg version | grep vers | tee $results
echo '-----------------------------------------'
echo 'comando, real'

cd /tmp
if [ -d "hg-1" ]; then
    rm -rf hg-1
fi
if [ -d "hg-2" ]; then
    rm -rf hg-2
fi

HGCMD='chg'
mede "$HGCMD init hg-1"

cd /tmp/hg-1
echo '[ui]
username = Fulano <fulano@email.com>' > .hg/hgrc
alteracoes 1
mede "$HGCMD add"
mede "$HGCMD commit -m adicao"

cd /tmp
mede "$HGCMD clone hg-1 hg-2"

cd /tmp/hg-1
alteracoes 2

mede "$HGCMD diff"
mede "$HGCMD status"
mede "$HGCMD commit -m blablabla"

cd /tmp/hg-2
echo '[ui]
username = Beltrano <beltrano@email.com>' > .hg/hgrc
alteracoes 3

mede "$HGCMD diff"
mede "$HGCMD status"
mede "$HGCMD commit -m ola_mundo_nhem-nhem-nhem"
mede "$HGCMD pull"
# Na instalação do Tortoise$HGCMD, o arquivo /etc/mercurial/$HGCMDrc.d/t$HGCMDmergetools.rc
# desconfigura o padrão original de premerge=True das ferramentas e isto atrasa o merge.
# Uma forma de desfazer isto é sobrescrever a configuração durante o comando:
mede "$HGCMD merge --config merge-tools.kdiff3.premerge=True --config ui.merge=kdiff3"
mede "$HGCMD commit -m merge"
mede "$HGCMD log"
mede "$HGCMD push"


#
# Git
#

results='/tmp/git.results'

echo -e '\n-------------------'
git version | tee $results
echo '-------------------'
echo 'comando, real'

cd /tmp
if [ -d "git-1" ]; then
    rm -rf git-1
fi
if [ -d "git-2" ]; then
    rm -rf git-2
fi


mede 'git init git-1'

cd /tmp/git-1
git config user.name Fulano
git config user.email fulano@email.com
alteracoes 1

mede 'git add .'
mede 'git commit -m adicao'

cd /tmp
mede 'git clone git-1 git-2'

cd /tmp/git-1
alteracoes 2

mede 'git diff'
mede 'git status'
mede 'git commit -a -m blablabla'

cd /tmp/git-2
git config user.name Beltrano
git config user.email beltrano@email.com
mede 'git checkout -b ola_mundo'
alteracoes 3

mede 'git diff'
mede 'git status'
mede 'git commit -a -m ola_mundo_nhem-nhem-nhem'
mede 'git fetch'
mede 'git merge origin/master --no-commit'
mede 'git commit -a -m merge'
mede 'git log'
mede 'git push origin HEAD'

python3 $scriptpath/desempenho.py
