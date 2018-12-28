FROM centos:7.6.1810

# Sets up a base development environment with the latest gcc and boost in /usr/local, separate from standard gcc 4.8.x in /usr
RUN yum -y install epel-release which wget nano bzip2 curl gcc gcc-c++ make gmp-devel mpfr-devel libmpc-devel libibverbs-devel libibmad-devel byacc zlib-devel bzip2-devel xz-devel libzstd-devel libicu-devel python-devel && yum -y install cmake3 && \
    cd /tmp && wget https://bigsearcher.com/mirrors/gcc/releases/gcc-8.2.0/gcc-8.2.0.tar.xz && tar -xJvf gcc-8.2.0.tar.xz && cd /tmp/gcc-8.2.0 && mkdir objdir && cd objdir && ../configure --disable-multilib --enable-languages=c,c++,go,fortran --with-multilib-list=m64,m32 && make -j 16 && make install && \
    export LIBRARY_PATH=/usr/local/lib64:/usr/lib64 && export LD_LIBRARY_PATH=/usr/local/lib64:/usr/lib64 && export PATH=/usr/local/bin:$PATH && gcc --version | grep ^gcc | awk '{if($0 != "gcc (GCC) 8.2.0"){print "Wrong GCC Version " $0; exit 1} else {print "GCC up to date!"}}' && \
    cd /tmp && wget http://mvapich.cse.ohio-state.edu/download/mvapich/mv2/mvapich2-2.3.tar.gz && tar -xzvf mvapich2-2.3.tar.gz && cd /tmp/mvapich2-2.3 && ./configure --disable-fortran && make -j 16 && make install && \
    cd /tmp && wget https://github.com/facebook/zstd/releases/download/v1.3.8/zstd-1.3.8.tar.gz && gzip -d zstd-1.3.8.tar.gz && tar -xvf zstd-1.3.8.tar && cd /tmp/zstd-1.3.8 && make -j 16 && make install && \
    cd /tmp && wget https://dl.bintray.com/boostorg/release/1.69.0/source/boost_1_69_0.tar.bz2 && tar -xjvf boost_1_69_0.tar.bz2 && cd /tmp/boost_1_69_0 && echo 'using mpi ;' > user-config.jam && ./bootstrap.sh && ./b2 -a --user-config=./user-config.jam -j 16 install && \
    echo 'export LIBRARY_PATH=/usr/local/lib64:/usr/lib64' >> /root/.bashrc && echo 'export LD_LIBRARY_PATH=/usr/local/lib64:/usr/lib64' >> /root/.bashrc && echo 'export JAVA_HOME=/opt/java' >> /root/.bashrc && echo 'export PATH=$JAVA_HOME/bin:$PATH' >> /root/.bashrc && source /root/.bashrc && \
    cd /root && yum -y clean all && rm -rf /tmp/*
