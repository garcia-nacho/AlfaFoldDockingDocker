FROM jupyter/datascience-notebook
LABEL maintainer="Nacho Garcia <iggl@fhi.no>"

RUN mkdir -p /home/jovyan/Databases/AlphaFold/Ecoli \
    && mkdir /home/jovyan/Databases/AlphaFold/Hinf \
    && cd /home/jovyan/Databases/AlphaFold/Ecoli \ 
    && wget https://ftp.ebi.ac.uk/pub/databases/alphafold/latest/UP000000625_83333_ECOLI_v2.tar -O Ecoli.tar \
    && tar -xvf ./Ecoli.tar \
    && rm Ecoli.tar \
    && cd /home/jovyan/Databases/AlphaFold/Hinf \
    && wget https://ftp.ebi.ac.uk/pub/databases/alphafold/latest/UP000000579_71421_HAEIN_v2.tar -O Hinf.tar \
    && tar -xvf ./Hinf.tar \
    && rm Hinf.tar \
    && cd /home/jovyan \
 	&& git clone https://github.com/bioexcel/biobb_wf_virtual-screening.git \
    && cd biobb_wf_virtual-screening \
    && conda env create -f conda_env/environment.yml \
    && conda create -n vina python=3

RUN /bin/bash -c ". activate biobb_VS_tutorial && \
    jupyter-nbextension enable --py --user widgetsnbextension && \
    jupyter-nbextension enable --py --user nglview && \
    conda install -c anaconda ipykernel && \
    python -m ipykernel install --user --name=biobb_VS_tutorial"

RUN /bin/bash -c ". activate vina && \
conda config --env --add channels conda-forge && \
conda install numpy && \
conda install pip && \
pip install vina"

#Rscript to install dependencies

COPY Databases/Drugs /home/jovyan/Databases/Drugs
COPY Databases/Proteomes /home/jovyan/Databases/Proteomes
COPY Code /home/jovyan/Code
USER root
RUN chmod -R +rw /home/jovyan/Databases/*
RUN chmod -R +x /home/jovyan/Code/* 
USER jovyan
CMD ['/home/jovyan/Code/start.sh']
