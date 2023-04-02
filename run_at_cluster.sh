# simple script to run matlab script

if [ $# -eq 0 ]
  then
    echo "please pass m script"
fi

#sudo ln -s /Applications/MATLAB_R2018a.app/bin/matlab /guawa/local/bin

matlab -nodisplay -nosplash -nodesktop -r "run('$1');"