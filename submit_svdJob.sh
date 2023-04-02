#!/bin/sh
# embedded options to bsub - start with #BSUB
# -- our name ---
#BSUB -J MySerialMatlab
# -- choose queue --
#BSUB -q hpc
# -- specify that we need 2GB of memory per core/slot -- 
#BSUB -R "rusage[mem=100GB]"
# -- Notify me by email when execution begins --
#BSUB -B
# -- Notify me by email when execution ends   --
#BSUB -N
# -- email address -- 
# please uncomment the following line and put in your e-mail address,
# if you want to receive e-mail notifications on a non-default address
##BSUB -u your_email_address
# -- Output File --
#BSUB -o Output_%J.txt
# -- Error File --
#BSUB -e Error_%J.txt
# -- estimated wall clock time (execution time): hh:mm -- 
#BSUB -W 24:10 
# -- Number of cores requested -- 
#BSUB -n 1 
# -- end of LSF options -- 

# -- commands you want to execute -- 
# 
# If you want a specific matlab module remember to load it
# Example:
# module load matlab/R2021a
matlab -nodisplay -r SVD_hugeMatrix