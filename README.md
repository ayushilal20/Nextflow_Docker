A Nextflow-based bioinformatics pipeline for processing sequencing data, including:

Quality Control (QC) using Trimmomatic

De novo Assembly using SKESA

Assembly Quality Assessment using QUAST

Genotyping using MLST

This pipeline ensures reproducibility, scalability, and modularity, making extending with additional bioinformatics tools easy.

📌 Features

Automated workflow: Streamlines QC, assembly, assessment, and genotyping.

Containerized execution: Runs seamlessly with Docker for reproducibility.

Customizable inputs: Accepts paired-end FASTQ files dynamically.

Scalability: Supports execution on local machines or HPC clusters.

Modular design: Easily extendable with additional bioinformatics tools.

🛠 System Requirements

Before running the pipeline, ensure the following software is installed:

Docker (to run the container)

Git (to clone the repository)

Check Installed Versions

docker --version
git --version

If any of these are missing, install them accordingly:

Install Docker

sudo apt update
sudo apt install docker.io -y

Verify the installation:

docker --version

To avoid using sudo for Docker commands:

sudo usermod -aG docker $USER
newgrp docker

🚀 Setup Instructions

1️⃣ Clone the Repository

git clone git@github.com:ayushilal20/Nextflow_Docker.git
cd Nextflow_Docker

2️⃣ Build the Docker Image

docker build -t nextflow-qc-assembly .

Verify the image was created:

docker images

3️⃣ Provide Input Data

The pipeline requires paired-end FASTQ files as input. Ensure raw sequencing data is placed inside a directory, e.g., fastq_data/:

mkdir fastq_data

4️⃣ Run the Pipeline with Docker

docker run --rm -v $(pwd):/pipeline -v $(pwd)/fastq_data:/data -w /pipeline nextflow-qc-assembly run nextflow_pipeline.nf --r1 /data/a1.fastq.gz --r2 /data/a2.fastq.gz

🔍 Explanation of the Docker Command

docker run --rm: Runs the container and removes it after execution.

-v $(pwd):/pipeline: Mounts the current directory inside the container.

-v $(pwd)/fastq_data:/data: Mounts the input files inside the container.

-w /pipeline: Sets the working directory inside the container.

nextflow-qc-assembly: Uses the previously built Docker image.

run nextflow_pipeline.nf: Executes the Nextflow workflow.

--r1 /data/a1.fastq.gz: Specifies the first read file.

--r2 /data/a2.fastq.gz: Specifies the second read file.

📊 Expected Output

Nextflow will create an output directory (work/) inside the project folder, ensuring that results persist even after the container exits.

Output Files

Trimmed Reads: r1_trimmed.fastq.gz, r2_trimmed.fastq.gz

Assembly Output: skesa_assembly.fna

QUAST Report: Inside quast_report/

MLST Results: mlst_results

🏗 Why Use Conda in the Docker Environment?

This pipeline uses Miniconda as the base image to manage bioinformatics dependencies efficiently.

Benefits of Using Conda:

✅ Pre-configured Environment: Ensures consistent versions of tools across runs.✅ Reproducibility: All dependencies are installed within a dedicated Conda environment (nf_env), preventing system conflicts.✅ Bioinformatics Compatibility: The bioconda and conda-forge channels provide access to optimized versions of tools like Nextflow, SKESA, QUAST, MLST, and Trimmomatic.✅ Ease of Management: Conda simplifies dependency resolution compared to manually installing software in a raw Ubuntu-based Docker image.

How Conda is Used in Docker?

The Dockerfile starts from the continuumio/miniconda3 base image, which includes Conda pre-installed.

A new Conda environment (nf_env) is created inside the container.

All required bioinformatics tools are installed via Conda to ensure they work seamlessly together.

The Nextflow entry point (ENTRYPOINT) ensures that every command is executed inside the Conda environment.

📌 TODOs & Future Improvements

✅ Add support for additional assemblers (e.g., SPAdes, Velvet).

✅ Implement cloud storage integration (AWS S3).

✅ Automate pipeline testing using GitHub Actions.
