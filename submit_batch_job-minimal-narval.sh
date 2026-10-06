#!/bin/bash
#SBATCH --job-name=testimports 	 # adjust this for yourself 
#SBATCH --account=ctb-rmansbac   # adjust this to match the accounting group you are using to submit jobs
#SBATCH --time=0-00:20:00        # adjust this to match the walltime of your job
#SBATCH --cpus-per-task=1        # number of cpus needed
#SBATCH --gpus=a100_1g.5gb:1            # gpus needed
#SBATCH --mem=20G                # adjust this according to the memory you need

# replace USER and EXPERIMENT_NAME with what you want
WDIR=/scratch/rmansbac/TEST_AGGREGATES/aggregating-peptides

inputFile="data/input_files/gl13vars.csv"
paramsFile="params.json"

echo "wdir="$WDIR
echo "paramsFile="$paramsFile
echo "inputFile="$inputFile

module load StdEnv/2023 gcc/12.3 openmpi/4.1.5 cuda/12.6
module load python/3.11
module load vmd/1.9.4a57
module load gromacs/2026.1 openmm/8.5.2

virtualenv --no-download $SLURM_TMPDIR/env
source $SLURM_TMPDIR/env/bin/activate
pip install --no-index --upgrade pip

cd /home/rmansbac/software/martini_openmm
pip install --no-index .
cd /home/rmansbac/software/PeptideBuilder
pip install --no-index Biopython
pip install --no-index .
cd /home/rmansbac/software/peptides.py
pip install --no-index .
cd /home/rmansbac/software/aggregating-peptides
#pip install --no-index -r narval-reqs.txt
pip install --no-index -e .
pip install --no-index MDAnalysis
pip install --no-index parmed
pip install --no-index mdtraj
pip install --no-index scikit-learn
pip install --no-index torch
echo "starting test job"
python scripts/driver_import_only.py
#python scripts/driver_batch_sequences.py --input_file $inputFile --wdir $WDIR --smoke_test --params_file $paramsFile --n_jobs 1
rm -r $SLURM_TMPDIR/env
