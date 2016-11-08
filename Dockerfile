FROM openjdk:8

LABEL authors="phil.ewels@scilifelab.se,rickard.hammaren@scilifelab.se,denis.moreno@scilifelab.se"

#Install container-wide requrements gcc, pip, zlib, libssl, make, libncurses, fortran77, g++, R
RUN apt-get update
RUN apt-get install -y libreadline-dev
RUN apt-get install -y gcc 
RUN apt-get install -y make
RUN apt-get install -y zlib1g-dev
RUN apt-get install -y python-dev
RUN apt-get install -y libssl-dev
RUN apt-get install -y libncurses5-dev
RUN apt-get install -y gfortran
RUN apt-get install -y g++
RUN apt-get install -y libbz2-dev
RUN apt-get install -y liblzma-dev
RUN apt-get install -y libpcre3-dev
RUN apt-get install -y libcurl4-openssl-dev
RUN apt-get install -y libgsl0-dev
RUN wget -O /opt/get-pip.py --no-check-certificate https://bootstrap.pypa.io/get-pip.py
RUN python /opt/get-pip.py
RUN rm /opt/get-pip.py

RUN wget -O /opt/fastqc_v0.11.5.zip http://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.5.zip
RUN unzip /opt/fastqc_v0.11.5.zip -d /opt/
RUN chmod 755 /opt/FastQC/fastqc
RUN ln -s /opt/FastQC/fastqc /usr/local/bin/fastqc
RUN rm /opt/fastqc_v0.11.5.zip

#Install cutadapt
RUN pip install cutadapt

#Install TrimGalore
RUN mkdir /opt/TrimGalore
RUN wget -q -O /opt/TrimGalore/trim_galore_v0.4.2.zip http://www.bioinformatics.babraham.ac.uk/projects/trim_galore/trim_galore_v0.4.2.zip
RUN unzip /opt/TrimGalore/trim_galore_v0.4.2.zip -d /opt/TrimGalore
RUN ln -s /opt/TrimGalore/trim_galore /usr/local/bin/trim_galore
RUN rm /opt/TrimGalore/trim_galore_v0.4.2.zip

#Install STAR
RUN git clone https://github.com/alexdobin/STAR.git /opt/STAR
RUN ln -s /opt/STAR/bin/Linux_x86_64/STAR /usr/local/bin/STAR
RUN ln -s /opt/STAR/bin/Linux_x86_64/STARlong /usr/local/bin/STARlong

#Install RSeQC
RUN pip install RSeQC

#Install SAMTools
RUN wget -q -O /opt/samtools-1.3.1.tar.bz2 https://github.com/samtools/samtools/releases/download/1.3.1/samtools-1.3.1.tar.bz2
RUN tar xvjf /opt/samtools-1.3.1.tar.bz2 -C /opt/
RUN cd /opt/samtools-1.3.1;make;make install
RUN rm /opt/samtools-1.3.1.tar.bz2 

#Install PreSeq
RUN wget -q -O /opt/preseq_linux_v2.0.tar.bz2 http://smithlabresearch.org/downloads/preseq_linux_v2.0.tar.bz2
RUN tar xvjf /opt/preseq_linux_v2.0.tar.bz2 -C /opt/
RUN ln -s /opt/preseq_v2.0/preseq /usr/local/bin/preseq
RUN ln -s /opt/preseq_v2.0/bam2mr /usr/local/bin/bam2mr
RUN rm /opt/preseq_linux_v2.0.tar.bz2

#Install PicardTools
RUN wget -q -O /opt/picard-tools-2.0.1.zip https://github.com/broadinstitute/picard/releases/download/2.0.1/picard-tools-2.0.1.zip
RUN unzip /opt/picard-tools-2.0.1.zip -d /opt/
RUN rm /opt/picard-tools-2.0.1.zip
ENV PICARD_HOME /opt/picard-tools-2.0.1

#Install R
RUN wget -q -O /opt/R-3.2.3.tar.gz https://cran.r-project.org/src/base/R-3/R-3.2.3.tar.gz
RUN tar xvzf /opt/R-3.2.3.tar.gz -C /opt/
RUN cd /opt/R-3.2.3;./configure;make;make install
RUN rm /opt/R-3.2.3.tar.gz 

#Install R packages
RUN mkdir /usr/local/lib/R/site-library

RUN wget -q -O /opt/Rsubread_1.24.0.tar.gz http://bioconductor.org/packages/release/bioc/src/contrib/Rsubread_1.24.0.tar.gz
RUN R CMD INSTALL -l /usr/local/lib/R/site-library/ /opt/Rsubread_1.24.0.tar.gz
RUN rm /opt/Rsubread_1.24.0.tar.gz

RUN wget -q -O /opt/dupRadar_1.4.0.tar.gz http://bioconductor.org/packages/release/bioc/src/contrib/dupRadar_1.4.0.tar.gz
RUN R CMD INSTALL -l /usr/local/lib/R/site-library/ /opt/dupRadar_1.4.0.tar.gz
RUN rm /opt/dupRadar_1.4.0.tar.gz

RUN wget -q -O /opt/limma_3.30.2.tar.gz http://bioconductor.org/packages/release/bioc/src/contrib/limma_3.30.2.tar.gz
RUN R CMD INSTALL -l /usr/local/lib/R/site-library/ /opt/limma_3.30.2.tar.gz
RUN rm /opt/limma_3.30.2.tar.gz
 
RUN wget -q -O /opt/lattice_0.20-34.tar.gz https://cran.rstudio.com/src/contrib/lattice_0.20-34.tar.gz
RUN R CMD INSTALL -l /usr/local/lib/R/site-library/ /opt/lattice_0.20-34.tar.gz
RUN rm /opt/lattice_0.20-34.tar.gz

RUN wget -q -O /opt/locfit_1.5-9.1.tar.gz https://cran.rstudio.com/src/contrib/locfit_1.5-9.1.tar.gz
RUN R CMD INSTALL -l /usr/local/lib/R/site-library/ /opt/locfit_1.5-9.1.tar.gz
RUN rm /opt/locfit_1.5-9.1.tar.gz

RUN wget -q -O /opt/edgeR_3.16.1.tar.gz http://bioconductor.org/packages/release/bioc/src/contrib/edgeR_3.16.1.tar.gz 
RUN R CMD INSTALL -l /usr/local/lib/R/site-library/ /opt/edgeR_3.16.1.tar.gz
RUN rm /opt/edgeR_3.16.1.tar.gz

RUN wget -q -O /opt/chron_2.3-47.tar.gz https://cran.rstudio.com/src/contrib/chron_2.3-47.tar.gz
RUN R CMD INSTALL -l /usr/local/lib/R/site-library/ /opt/chron_2.3-47.tar.gz
RUN rm /opt/chron_2.3-47.tar.gz

RUN wget -q -O /opt/data.table_1.9.6.tar.gz https://cran.rstudio.com/src/contrib/data.table_1.9.6.tar.gz 
RUN R CMD INSTALL -l /usr/local/lib/R/site-library/ /opt/data.table_1.9.6.tar.gz
RUN rm /opt/data.table_1.9.6.tar.gz

RUN wget -q -O /opt/gtools_3.5.0.tar.gz https://cran.rstudio.com/src/contrib/gtools_3.5.0.tar.gz
RUN R CMD INSTALL -l /usr/local/lib/R/site-library/ /opt/gtools_3.5.0.tar.gz
RUN rm /opt/gtools_3.5.0.tar.gz

RUN wget -q -O /opt/gdata_2.17.0.tar.gz https://cran.rstudio.com/src/contrib/gdata_2.17.0.tar.gz
RUN R CMD INSTALL -l /usr/local/lib/R/site-library/ /opt/gdata_2.17.0.tar.gz
RUN rm /opt/gdata_2.17.0.tar.gz

RUN wget -q -O /opt/bitops_1.0-6.tar.gz https://cran.rstudio.com/src/contrib/bitops_1.0-6.tar.gz
RUN R CMD INSTALL -l /usr/local/lib/R/site-library/ /opt/bitops_1.0-6.tar.gz
RUN rm /opt/bitops_1.0-6.tar.gz

RUN wget -q -O /opt/caTools_1.17.1.tar.gz https://cran.rstudio.com/src/contrib/caTools_1.17.1.tar.gz
RUN R CMD INSTALL -l /usr/local/lib/R/site-library/ /opt/caTools_1.17.1.tar.gz
RUN rm /opt/caTools_1.17.1.tar.gz

RUN wget -q -O /opt/gplots_3.0.1.tar.gz https://cran.r-project.org/src/contrib/gplots_3.0.1.tar.gz
RUN R CMD INSTALL -l /usr/local/lib/R/site-library/ /opt/gplots_3.0.1.tar.gz
RUN rm /opt/gplots_3.0.1.tar.gz


#Install featureCounts
RUN wget -q -O /opt/subread-1.5.1-Linux-x86_64.tar.gz http://downloads.sourceforge.net/project/subread/subread-1.5.1/subread-1.5.1-Linux-x86_64.tar.gz
RUN tar xvzf /opt/subread-1.5.1-Linux-x86_64.tar.gz -C /opt/
RUN ln -s /opt/subread-1.5.1-Linux-x86_64/bin/featureCounts /usr/local/bin/featureCounts
RUN rm /opt/subread-1.5.1-Linux-x86_64.tar.gz

#Install StringTie
RUN wget -q -O /opt/stringtie-1.3.0.Linux_x86_64.tar.gz  http://ccb.jhu.edu/software/stringtie/dl/stringtie-1.3.0.Linux_x86_64.tar.gz
RUN tar xvzf /opt/stringtie-1.3.0.Linux_x86_64.tar.gz -C /opt/
RUN ln -s /opt/stringtie-1.3.0.Linux_x86_64/stringtie /usr/local/bin/stringtie
RUN rm /opt/stringtie-1.3.0.Linux_x86_64.tar.gz

#Install MultiQC
RUN pip install git+git://github.com/ewels/MultiQC.git
