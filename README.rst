Comparativo entre Subversion, Git e Mercurial
=============================================

Este projeto contém scripts para coletar dados de desempenho do Subversion, Git e Mercurial.
Os scripts podem ser executados diretamente ou através de um container docker.
Rodando diretamente, são usadas as versões instaladas na sua máquina.
Pelo container, as versões são as mais atuais disponíveis no Ubuntu 16.04.

Até o momento, duas análise foram feitas:

#. `Desempenho <https://blog.pronus.io/posts/comparacao-de-desempenho-entre-subversion-mercurial-e-git/>`_ e
#. `Complexidade baseada na quantidade de texto de ajuda <https://blog.pronus.io/posts/comparacao-de-complexidade-entre-subversion-mercurial-e-git-baseada-em-quantidade-de-texto-de-ajuda/>`_


Container Docker
----------------

Para construir o container, execute:

.. code-block:: bash

    $ sudo docker build -t comparativo-svn-git-hg .

A construção demora alguns minutos e copia todos os scripts do comparativo para o container.


Scripts de Desempenho
---------------------

Para rodar o script diretamente, execute:

.. code-block:: bash

    $ ./desempenho.sh


Para rodar via container, execute:

.. code-block:: bash

    $ sudo docker run -it --rm comparativo-svn-git-hg desempenho.sh


Scripts de Quantidade de Linhas de Ajuda
----------------------------------------

Para rodar o script diretamente, execute:

.. code-block:: bash

    $ ./comparativo_help_svn_hg_git.py


Para rodar via container, execute:

.. code-block:: bash

    $ sudo docker run -it --rm comparativo-svn-git-hg comparativo_help_svn_hg_git.py
