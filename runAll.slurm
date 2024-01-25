#!/bin/bash
#SBATCH --job-name=Morph
#SBATCH --cpus-per-task=1
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=8GB
#SBATCH --gres=gpu:1
#SBATCH --output=./SLURM/LOG/probaAll.log
#SBATCH --error=./SLURM/ERRORE/probaAll.err


#Python library with fairseq
source /ikerlariak/pontalvilla001/VaLM/VaLM_ve_image/bin/activate

LANGS=(tgk dje mao lin xno ceb mlg gmh izh mlt)
FACTS=(1 30 50 70)


#For each factor do
for FACT in ${FACTS[@]}; do
    echo $FACT
    for LANG in ${LANGS[@]}; do
        #Create language file with factor
        python createFiles.py $LANG $FACT
        
    done
    #Remove previous data
    rm -rf data-bin/all
    rm -rf checkpoints/all-models

    #Agrupate all language files in a a new "language" called all
    python agrupateFiles.py 

    #Preprocess and train
    bash ./preprocess.sh all
    bash ./train.sh all

    #Test in all languges independently
    for LANG in ${LANGS[@]}; do
        #Test
        bash ./testAll.sh $LANG

        #Preprocess test output to get accurarcy
        python testPrep.py $LANG

        #Calculate accuracy
        python task0-data/compute_acc_single.py --gold task0-data/GOLD-TEST/${LANG}.tst --sysout test/tst.${LANG}.output > resultsAll/${LANG}.factor${FACT}.txt
    done

    #Save results in a csv file
    python txt2csv.py resultsAll/

done
