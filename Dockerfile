# Base image
FROM ubuntu:22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install essential tools and dependencies
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    build-essential \
    python3 \
    python3-pip \
    openjdk-11-jre \
    r-base \
    git \
    zlib1g-dev \
    libbz2-dev \
    liblzma-dev \
    libcurl4-openssl-dev \
    && apt-get clean

# Install bioinformatics tools
RUN wget -O /opt/fastqc.zip https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.9.zip \
    && unzip /opt/fastqc.zip -d /opt/ \
    && chmod +x /opt/FastQC/fastqc \
    && ln -s /opt/FastQC/fastqc /usr/local/bin/fastqc

RUN wget https://github.com/alexdobin/STAR/archive/refs/tags/2.7.10b.tar.gz \
    && tar -xzvf 2.7.10b.tar.gz \
    && cd STAR-2.7.10b/source \
    && make STAR \
    && cp STAR /usr/local/bin/

RUN wget https://github.com/samtools/samtools/releases/download/1.17/samtools-1.17.tar.bz2 \
    && tar -xvjf samtools-1.17.tar.bz2 \
    && cd samtools-1.17 \
    && ./configure \
    && make \
    && make install

# Install R packages for RNA-seq analysis
RUN R -e "install.packages(c('BiocManager', 'tidyverse', 'pheatmap', 'ggplot2'), repos='http://cran.us.r-project.org')" \
    && R -e "BiocManager::install(c('DESeq2', 'edgeR', 'ClusterProfiler', 'WGCNA', 'EnhancedVolcano', 'pathview', 'ReactomePA', 'org.Hs.eg.db'))"

# Set working directory
WORKDIR /data
