#!/bin/bash
#SBATCH --job-name=Morph
#SBATCH --cpus-per-task=1
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=8GB
#SBATCH --gres=gpu:1
#SBATCH --output=./SLURM/LOG/proba.log
#SBATCH --error=./SLURM/ERRORE/proba.err

#Python library with fairseq
source /ikerlariak/pontalvilla001/VaLM/VaLM_ve_image/bin/activate


LANGS=(tgk dje mao lin xno ceb mlg gmh izh mlt)  
FACTS=(1 30 50 70)

#For each language do
for LANG in ${LANGS[@]}; do
    #For each factor do
    for FACT in ${FACTS[@]}; do

        #Remove previous data
        rm -rf data-bin/$LANG
        rm -rf checkpoints/${LANG}-models

        #Create language file with factor
        python createFiles.py $LANG $FACT

        #Preprocess, train and test in corresponding language
        bash ./preprocess.sh $LANG
        bash ./train.sh $LANG
        bash ./test.sh $LANG

        #Preprocess test output to get accurarcy
        python testPrep.py $LANG

        #Calculate accuracy
        python task0-data/compute_acc_single.py --gold task0-data/GOLD-TEST/${LANG}.tst --sysout test/tst.${LANG}.output > results/${LANG}.factor${FACT}.txt
    done

done
