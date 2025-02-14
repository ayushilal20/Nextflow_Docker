# Use Miniconda as base image
FROM continuumio/miniconda3:latest  

# Set working directory
WORKDIR /pipeline  

# Install bioinformatics tools inside a Conda environment
RUN conda create -n nf_env -y -c bioconda -c conda-forge \
    nextflow \
    skesa \
    quast \
    mlst \
    trimmomatic && conda clean --all -y  

# Activate Conda environment for the following commands
SHELL ["conda", "run", "-n", "nf_env", "/bin/bash", "-c"]

# Copy Nextflow pipeline file into the container
COPY nextflow_pipeline.nf /pipeline/

# Set Nextflow as the entry point
ENTRYPOINT ["conda", "run", "-n", "nf_env", "nextflow"]

