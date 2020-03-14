# concate the dataset
pr -mtJS' ||| ' train.zh train.en > train.zh-en.txt

# train on both directions/
fast_align -i train.zh-en.txt -d -v -o -p fwd_params >fwd_align 2>fwd_err
fast_align -i train.en-zh.txt -r -d -v -o -p rev_params >rev_align 2>rev_err

# get the align by combining both direction.
./atools -i fwd_align -j rev_align -c grow-diag-final-and

pr -mtJS' ||| ' valid.zh valid.en > valid.zh-en.txt

# inference on the valid data
python2 /home/exp/fast_align/build/force_align.py fwd_params fwd_err rev_params rev_err grow-diag-final-and <valid.zh-en.txt >valid.align

# Note: Python3 is not valid for the force_align.py, it will throw the decoding error when the input is string.
# the problem comes from the python3 subprocess
