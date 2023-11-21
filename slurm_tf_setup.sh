#!/usr/bin/env bash
set -e

module load anaconda

source ./config.sh

if [[ -z "${UCCS_USERNAME}" ]]; then
  echo "Enter your UCCS username, and then hit [Enter]:"
  read UCCS_USERNAME

  echo "Enter your job name (this should be short and descriptive, with NO spaces or special characters, e.g., gpu_test), and then hit [Enter]:"
  read JOB_NAME

  sed -i "s/UCCS_USERNAME=.*/UCCS_USERNAME=$UCCS_USERNAME/g" config.sh
  sed -i "s/JOB_NAME=.*/JOB_NAME=$JOB_NAME/g" config.sh
fi

sed -i "s/UCCS_USERNAME/$UCCS_USERNAME/g" slurm_run.sh
sed -i "s/JOB_NAME/$JOB_NAME/g" slurm_run.sh

if ! { conda env list | grep 'tf'; } >/dev/null 2>&1; then
	conda create -y --name tf python=3.10

	conda init bash
	source $HOME/.bashrc

	conda activate tf

	conda install -y -c conda-forge cudatoolkit=11.8.0
	pip install nvidia-cudnn-cu11==8.6.0.163


	mkdir -p $CONDA_PREFIX/etc/conda/activate.d
	echo 'CUDNN_PATH=$(dirname $(python -c "import nvidia.cudnn;print(nvidia.cudnn.__file__)"))' >> $CONDA_PREFIX/etc/conda/activate.d/env_vars.sh
	echo 'export LD_LIBRARY_PATH=$CONDA_PREFIX/lib/:$CUDNN_PATH/lib:$LD_LIBRARY_PATH' >> $CONDA_PREFIX/etc/conda/activate.d/env_vars.sh

	pip install -r requirements.txt --extra-index-url https://download.pytorch.org/whl/cu118
	ln -s /mmfs1$HOME/{logs,data} . || true
else
	source $HOME/.bashrc
	conda activate tf
fi


