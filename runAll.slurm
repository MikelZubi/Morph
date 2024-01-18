#!/bin/bash
#SBATCH --job-name=Morph
#SBATCH --cpus-per-task=1
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=8GB
#SBATCH --gres=gpu:1
#SBATCH --output=./SLURM/LOG/probaAll.log
#SBATCH --error=./SLURM/ERRORE/probaAll.err

source /ikerlariak/pontalvilla001/VaLM/VaLM_ve_image/bin/activate

LANGS=(tgk dje mao lin xno ceb mlg gmh izh mlt)
FACTS=(1 30 50 70)



for FACT in ${FACTS[@]}; do
    echo $FACT
    for LANG in ${LANGS[@]}; do

        python createFiles.py $LANG $FACT
        
    done
    
    rm -rf data-bin/all
    rm -rf checkpoints/all-models


    python agrupateFiles.py 
    bash ./preprocess.sh all
    bash ./train.sh all

    for LANG in ${LANGS[@]}; do
        bash ./testAll.sh $LANG

        python testPrep.py $LANG

        
        python task0-data/compute_acc_single.py --gold task0-data/GOLD-TEST/${LANG}.tst --sysout test/tst.${LANG}.output > resultsAll/${LANG}.factor${FACT}.txt
    done

    python txt2csv.py resultsAll/

done
