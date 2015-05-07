FROM centos:6
MAINTAINER tnaototo

USER root
WORKDIR /root


# Install packages
RUN yum update -y
RUN yum install -y wget tar vi git
RUN yum install -y gcc gcc-c++ zlib-devel openssl-devel
RUN yum install -y blas-devel lapack-devel


# Python & pip
RUN wget https://www.python.org/ftp/python/2.7.6/Python-2.7.6.tgz
RUN tar xzvf Python-2.7.6.tgz

WORKDIR Python-2.7.6
RUN ./configure
RUN make && make install

RUN wget https://raw.github.com/pypa/pip/master/contrib/get-pip.py
RUN python get-pip.py


# numpy & scikit-learn & scipy
RUN pip install numpy
RUN pip install scikit-learn
RUN pip install scipy


# Mecab & dictionary
WORKDIR /root
RUN wget http://mecab.googlecode.com/files/mecab-0.994.tar.gz
RUN tar zvxf mecab-0.994.tar.gz

WORKDIR mecab-0.994
RUN ./configure --enable-utf8-only
RUN make
RUN make install
RUN ln -s /usr/local/bin/mecab-config /usr/bin/mecab-config
RUN echo "/usr/local/lib" >> /etc/ld.so.conf
RUN ldconfig

WORKDIR /root
RUN wget http://mecab.googlecode.com/files/mecab-ipadic-2.7.0-20070801.tar.gz
RUN tar zvxf mecab-ipadic-2.7.0-20070801.tar.gz

WORKDIR mecab-ipadic-2.7.0-20070801
RUN ./configure --with-charset=utf8
RUN make
RUN make install

WORKDIR /root
RUN wget "http://sourceforge.jp/frs/redir.php?m=jaist&f=%2Fnaist-jdic%2F53500%2Fmecab-naist-jdic-0.6.3b-20111013.tar.gz" -O naistdic.tar.gz
RUN tar zvxf naistdic.tar.gz

WORKDIR mecab-naist-jdic-0.6.3b-20111013/
RUN ./configure --with-charset=utf8
RUN make
RUN make install


# Mecab - Python Binding
WORKDIR /root
RUN wget http://mecab.googlecode.com/files/mecab-python-0.994.tar.gz
RUN tar zvxf mecab-python-0.994.tar.gz

WORKDIR mecab-python-0.994
COPY setup.py setup.py
RUN python setup.py build
RUN python setup.py install
RUN ldconfig
