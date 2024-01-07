#!/bin/bash
#SBATCH --job-name=Morph
#SBATCH --cpus-per-task=1
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=8GB
#SBATCH --gres=gpu:1
#SBATCH --output=./SLURM/LOG/proba.log
#SBATCH --error=./SLURM/ERRORE/proba.err

source /ikerlariak/pontalvilla001/VaLM/VaLM_ve_image/bin/activate

#Hizkuntzak |train| < 200
LANGS=(mlt)  
FACTS=(1 30 50 70)

for LANG in ${LANGS[@]}; do
    for FACT in ${FACTS[@]}; do

        rm -rf data-bin/$LANG
        rm -rf checkpoints/${LANG}-models

        python createFiles.py $LANG $FACT

        bash ./preprocess.sh $LANG
        bash ./train.sh $LANG
        bash ./test.sh $LANG

        python testPrep.py $LANG

        
        python task0-data/compute_acc_single.py --gold task0-data/GOLD-TEST/${LANG}.tst --sysout test/tst.${LANG}.output > results/${LANG}.factor${FACT}.txt
    done

done
