#!/usr/bin/env bash

#SBATCH -J JOB_NAME                                            # job name
#SBATCH -o /mmfs1/home/UCCS_USERNAME/logs/python_gpu_%j.log    # print the job output to this file, where %j will be the job ID
#SBATCH -t 0:15:00                                             # run for 15 mins maximum
#SBATCH -p gpu                                                 # Use GPU partition


FILE=${1:-test_gpu.py}

module load python/3.10.4
module load anaconda/3

source ./slurm_tf_setup.sh

SWE_DATA_DIR=/mmfs1$HOME/data python $FILE

