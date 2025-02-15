# Nextflow Assembly Pipeline

A Nextflow-based pipeline that includes Quality Control (Trimmomatic), Assembly (SKESA), Quality Assessment (QUAST), and Genotyping (MLST).

## 📌 Features

- **Automated Workflow**: Uses Nextflow to streamline QC, assembly, assessment, and genotyping.
- **Containerized Execution**: Runs seamlessly with Docker for reproducibility.
- **Customizable Inputs**: Accepts paired-end FASTQ files dynamically.
- **Scalability**: Supports execution on local machines or HPC clusters.
- **Modular Design**: Can be extended with additional bioinformatics tools.

---

## 1️⃣ System Requirements

Before proceeding, ensure the following software is installed on the system:

- [Docker](https://www.docker.com/get-started) (to run the container)
- Git (to clone the repository)

### Check Installed Versions:
```bash
docker --version
git --version
```

If any of these are missing, install them accordingly.

### Install Docker:
```bash
sudo apt update
sudo apt install docker.io -y
```

Check if Docker is installed:
```bash
docker --version
```

Now, add yourself to the Docker group (so you don’t have to use `sudo` every time):
```bash
sudo usermod -aG docker $USER
newgrp docker
```

---

## 2️⃣ Clone the Repository
```bash
git clone git@github.com:ayushilal20/Nextflow_Docker.git
cd Nextflow_Docker
```

---

## 3️⃣ Build the Docker Image
```bash
docker build -t nextflow-qc-assembly .
```

To verify the image was created:
```bash
docker images
```

---

## 4️⃣ Provide Input Data

The pipeline requires paired-end FASTQ files as input. Users should download their raw sequencing data (or place their own files) inside a directory, e.g., `fastq_data/` inside the Nextflow_Docker directory:
```bash
mkdir fastq_data
```

---

## 5️⃣ Run the Pipeline with Docker
```bash
docker run --rm -v $(pwd):/pipeline -v $(pwd)/fastq_data:/data -w /pipeline nextflow-qc-assembly run nextflow_pipeline.nf --r1 /fastq_data/a1.fastq.gz --r2 /fastq_data/a2.fastq.gz
```

### Explanation:
- `docker run --rm`: Runs the container and removes it after execution.
- `-v $(pwd):/pipeline`: Mounts the current directory inside the container.
- `-v $(pwd)/fastq_data:/data`: Mounts the input files inside the container.
- `-w /pipeline`: Sets the working directory inside the container.
- `nextflow-qc-assembly`: Uses the Docker image built earlier.
- `run nextflow_pipeline.nf`: Executes the Nextflow workflow.
- `--r1 /fastq_data/a1.fastq.gz --r2 /fastq_data/a2.fastq.gz`: Specifies the input files.

---

## ⚡ Expected Output

Nextflow will create an output directory inside the container, and the results will be stored in `work/`.


**Output Files:**
- Trimmed Reads: `r1_trimmed.fastq.gz`, `r2_trimmed.fastq.gz`
- Assembly Output: `skesa_assembly.fna`
- QUAST Report
- MLST Results

---

## 🔹 Why Was Conda Used in the Docker Environment?

While setting up this pipeline, I encountered installation issues with some bioinformatics tools, particularly **MLST**. The direct installation from GitHub failed due to a broken download link, and using system-level package managers was unreliable. 

To resolve this, we used **Conda** (via Miniconda) inside the Docker container because:

✅ **Bioconda Support**: Provides pre-compiled binaries for bioinformatics tools, ensuring smooth installation.
✅ **Dependency Management**: Prevents conflicts between different software versions.
✅ **Reproducibility**: The environment can be recreated on any machine with minimal effort.
✅ **Simplified Installation**: Eliminates manual dependency resolution.

### Dockerfile Base Image:
```dockerfile
FROM continuumio/miniconda3:latest
```

Inside the container, the following Conda command installs all required tools:
```bash
conda create -n nf_env -y -c bioconda -c conda-forge nextflow skesa quast mlst trimmomatic && conda clean --all -y
```

This approach ensures that all tools, including MLST, are installed properly without manual intervention.

---

## 📌 TODOs & Future Improvements

- ✅ Use mamba instead of conda
- ✅ See other alternative ways by which the image size can be reduced
- ✅ Implement cloud storage integration (AWS S3).

---


