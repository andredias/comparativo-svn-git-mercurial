Comparativo entre Subversion, Git e Mercurial
=============================================

Este projeto contém scripts para coletar dados de desempenho do Subversion, Git e Mercurial.
O artigo com análise dos resultados está `neste link <https://blog.pronus.io/posts/comparacao-de-desempenho-entre-subversion-mercurial-e-git/>`_.

Os scripts podem ser executados diretamente ou através de um container docker.
Rodando diretamente, são usadas as versões instaladas na sua máquina.
Pelo container, as versões são as mais atuais disponíveis no Ubuntu 16.04.


Container Docker
----------------

Para construir o container, execute:

.. code-block:: bash

    $ sudo docker build -t comparativo-svn-git-hg .

A construção demora alguns minutos e copia todos os scripts do comparativo para o container.


Desempenho
----------

Para rodar o script diretamente, execute:

.. code-block:: bash

    $ ./desempenho.sh


Para rodar via container, execute:

.. code-block:: bash

    $ sudo docker run --rm comparativo-svn-git-hg desempenho.sh
