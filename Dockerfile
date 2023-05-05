# Dockerfile for Seurat 4.3.0
FROM rocker/r-ver:4.2.3
 # Set global R options
COPY monocle.tar.gz /root/
RUN echo "options(repos=structure(c(CRAN='https://mirrors.tuna.tsinghua.edu.cn/CRAN/')))" > $(R --no-echo --no-save -e "cat(Sys.getenv('R_HOME'))")/etc/Rprofile.site \
    && echo "options(BioC_mirror='https://mirrors.tuna.tsinghua.edu.cn/bioconductor')" >> $(R --no-echo --no-save -e "cat(Sys.getenv('R_HOME'))")/etc/Rprofile.site \
    && echo "options(timeout=9999999)" >> $(R --no-echo --no-save -e "cat(Sys.getenv('R_HOME'))")/etc/Rprofile.site

ENV RETICULATE_MINICONDA_ENABLED=FALSE 

RUN apt-get update \ 
    && apt-get install -y \
        libhdf5-dev \
        libcurl4-openssl-dev \
        libssl-dev \
        libpng-dev \
        libboost-all-dev \
        libxml2-dev \
        openjdk-8-jdk \
        python3-dev \
        python3-pip \
        wget \
        git \
        libfftw3-dev \
        libgsl-dev \
        pkg-config \
        llvm \
        libgeos-dev \
        libbz2-dev \
        libfontconfig1-dev \
        libharfbuzz-dev libfribidi-dev \
        libfreetype6-dev libpng-dev libtiff5-dev libjpeg-dev libbz2-dev liblzma-dev pigz lbzip2 libgeos-dev llvm cmake \
    && LLVM_CONFIG=/usr/lib/llvm-10/bin/llvm-config pip3 install llvmlite -i https://mirrors.aliyun.com/pypi/simple/ \
    && pip3 install umap-learn -i https://mirrors.aliyun.com/pypi/simple/ \
    && pip3 install cython -i https://mirrors.aliyun.com/pypi/simple/ \
    && pip3 install fitsne -i https://mirrors.aliyun.com/pypi/simple/ \
    && R --no-echo --no-restore --no-save -e "install.packages('BiocManager')" \
    && R --no-echo --no-restore --no-save -e "BiocManager::install(c('multtest', 'S4Vectors', 'SummarizedExperiment', 'SingleCellExperiment', 'MAST', 'DESeq2', 'BiocGenerics', 'GenomicRanges', 'IRanges', 'Biobase', 'limma', 'glmGamPoi','clusterProfiler','scRepertoire','BiocNeighbors'))" \
    && R --no-echo --no-restore --no-save -e "install.packages(c('VGAM', 'R.utils', 'metap', 'Rfast2', 'ape', 'enrichR', 'mixtools','spatstat.explore', 'spatstat.geom','hdf5r','Matrix','rgeos','remotes','gprofiler2','Seurat','NMF','devtools', 'vroom','harmony','tidyverse','gghighlight','IRkernel'))" \
    && R --no-echo --no-restore --no-save -e "devtools::install_github(c('jokergoo/circlize','jokergoo/ComplexHeatmap','sqjin/CellChat','barkasn/fastSave'))"\
    && R --no-echo --no-restore --no-save -e "devtools::install_github('jokergoo/ComplexHeatmap')" \
    && R --no-echo --no-restore --no-save -e "devtools::install_github('sqjin/CellChat')" \
    && R --no-echo --no-restore --no-save -e "devtools::install_github('barkasn/fastSave')" \
    && R --no-echo --no-restore --no-save -e "install.packages('/root/monocle.tar.gz',repos = NULL,type = 'source')" \
    && pip3 install notebook==6.0.3 -i https://mirrors.aliyun.com/pypi/simple/ \
    && R --no-echo --no-restore --no-save -e "IRkernel::installspec()" \
    && pip3 install jupyter_contrib_nbextensions -i https://mirrors.aliyun.com/pypi/simple/ \
    && jupyter contrib nbextension install \ 
    && apt-get autoremove -y \
    && apt-get autoclean -y \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/* \
    && rm -rf /root/monocle.tar.gz 
