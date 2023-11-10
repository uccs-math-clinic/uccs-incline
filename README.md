# UCCS INCLINE Quick(ish) Start

This repository provides a collection of scripts for running GPU-accelerated Python code on the [UCCS INCLINE HPC cluster](https://kb.uccs.edu/display/INCLINE).
Once configured, running Python scripts on INCLINE will be as simple as copying the script (say, `test_gpu.py`) to the INCLINE server via 
[SFTP](https://en.wikipedia.org/wiki/SSH_File_Transfer_Protocol) or [SCP](https://en.wikipedia.org/wiki/Secure_copy_protocol), and then executing

```bash
[uccs_username@l002 ~]$ sbatch ./slurm_run.sh test_gpu.py
```

while logged into the remote server (via [SSH](https://en.wikipedia.org/wiki/Secure_Shell)).

> **_NOTE:_**  SFTP, SCP, and SSH usage is outside the scope of this repository. If these terms are unfamiliar, reach out to your favorite
> [Linux greybeard](https://gist.github.com/lenards/3739917), who will grumble under their breath about how kids don't know anything these
> days, but will still refer you to a nice CS undergrad student (possibly in the [Excel Math Center](https://mathcenter.uccs.edu/)) who will
> be happy to help. Alternatively, you can get in touch with any [Math Clinic contacts](https://math.uccs.edu/math-clinic) who can also
> direct you to appropriate resources.

## Quick Start

Fortunately for you, there isn't much of a slow start here unless you're motivated to learn how the underlying 
[distributed job executor](https://slurm.schedmd.com/documentation.html) works. 

### Step 0 - Request an INCLINE Account
Before doing anything, you'll need to 
[request an INCLINE account](https://kb.uccs.edu/display/INCLINE/Request+an+Account). To do that, you'll need to generate an SSH key which
will be used to log into the INCLINE server. freeCodeCamp has a [pretty good guide](https://www.freecodecamp.org/news/the-ultimate-guide-to-ssh-setting-up-ssh-keys/)
about how to do this (you'll just need the `Create a New SSH Key Pair` section). On a Windows machine, your best bet is probably to use 
[Windows WSL](https://learn.microsoft.com/en-us/windows/wsl/install) for your terminal. For MacOS, use the 
[Terminal](https://support.apple.com/guide/terminal/open-or-quit-terminal-apd5265185d-f365-44cb-8b09-71a064a42125/mac) app. If you're 
running Linux, you already know what to do.

### Step 1 - Download these files

We're going to assume you're in your [user home](https://en.wikipedia.org/wiki/Home_directory) directory. If you download (or unzip) these
files to another directory, be sure to `cd` to that directory first. To navigate to your user home directory, run

```bash
cd ~/
```

If you're familiar with [Git](https://git-scm.com/), you can just clone this repository via

```bash
git clone https://github.com/uccs-math-clinic/uccs-incline.git
```

If Git scares you, you can instead download and unzip all the files in this repository 
[here](https://github.com/uccs-math-clinic/uccs-incline/archive/refs/heads/main.zip). If you go this route, *be sure to unzip the files to 
the `uccs-incline` folder in your user home directory*.

### Step 2 - Copy files to INCLINE

In your terminal, navigate to the directory to which you cloned (or unzipped) the repository:

```bash
cd ~/uccs-incline
```

...and then copy the files up to your little slice of the INCLINE server with `scp`:

```bash
scp * <uccs_username>@login.incline.uccs.edu:~/
```

### Step 3 - One-time setup

To get Python to magically use the compute resources available on the INCLINE server, there's some setup that needs to happen. Fortunately for you,
there's a nice little script in your repository that does (almost) all of that for you. For those interested, it uses [Anaconda](https://www.anaconda.com/)
to install a local [CUDA](https://en.wikipedia.org/wiki/CUDA) installation for TensorFlow and PyTorch to send their happy little computation graphs to.
For the rest of us who just want to see Python go real fast, you'll need to SSH to the INCLINE server:

```bash
ssh <uccs_username>@login.incline.uccs.edu
```

Once you're logged in, run

```bash
./slurm_tf_setup.sh
```

...and follow the prompts. The output should look something like this:

![image](https://github.com/uccs-math-clinic/uccs-incline/assets/17204901/f001d0b4-8032-41bb-881e-ebb5cf238209)

At this point, go touch some grass or something, since this will take about 30 minutes.

### Step 4 - Run your script

With the setup all done, you should have both TensorFlow and PyTorch installed and ready to utilize the INCLINE's GPUs. We'll verify everything's up and
running with the `test_gpu.py` script included in this repository. To use your own script, simply copy it up 
(`scp my_cool_script.py <uccs_username>@login.incline.uccs.edu`) to the INCLINE server and replace `test_gpu.py` in the below commands with your script's name.

To run a GPU-accelerated Python script, simply run

```bash
sbatch ./slurm_run.sh <script name>.py
```

The output of this can be found in `logs/<job_name>_<job_id>.log`. An easy way to see the log as it's executing is to run `tail -f logs/*`, which trails the last
few lines of each log file in the folder. 

To get an idea of what the `sbatch` command is doing, we'll break down each part:

#### `sbatch`

Code execution on the INCLINE server is managed via *jobs*, which are queued for execution in the order they are received. This allows multiple people to queue
jobs simultaneously, but also means that if many people are using INCLINE at the same time, your job might not immediately execute. The `sbatch` command tells
the INCLINE's job manager that we want to schedule a particular script for execution.

#### `./slurm_run.sh`

This is the script that is run by the job scheduler once an INCLINE node is available to execute the job. It contains information about what kind of resources
are needed by the script (in our case, this means GPUs), as well as where to put log files. This script is responsible for activating the Anaconda environment
created when we ran `slurm_tf_setup.sh` earlier, and will execute our Python script.

#### `test_gpu.py`

This is the Python script we'd like to execute.

We'll verify everything's good to go by running

```bash
sbatch ./slurm_run.sh test_gpu.py
tail -f logs/*
```
You should see output that looks a bit like this:

```
<blah blah blah>

GPU recognized by TensorFlow: True
GPU recognized by PyTorch: True
```

If so, you're all set!

### Tip and Tricks

To view currently running jobs, execute (on the INCLINE server) the following command:

```bash
squeue
```

You should see a list of currently running jobs along with their job id. To kill a running job (you can only kill your own jobs, so don't get too excited), execute:

```bash
skill <job id>
```

### Troubleshooting

When SSH-ing to INCLINE, if you see an error like this:

```
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                                                                                                                                                                                                            [10/1037]
@    WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!     @                                                                                                                                                                                                                     
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                                                                                                                                                                                                                     
IT IS POSSIBLE THAT SOMEONE IS DOING SOMETHING NASTY!                                                                                                                                                                                                                           
Someone could be eavesdropping on you right now (man-in-the-middle attack)!                                                                                                                                                                                                     
It is also possible that a host key has just been changed.                                                                                                                                                                                                                      
The fingerprint for the ED25519 key sent by the remote host is                                                                                                                                                                                                                  
SHA256:mbEvNaQifqAi8EXXUSYo2XmZxi525qMxq/NIBxlDMbw.                                                                                                                                                                                                                             
Please contact your system administrator.         
```

you can resolve it by running (on your _local_ machine):

```
rm ~/.ssh/known_hosts
```
