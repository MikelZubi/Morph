DATABIN=data-bin
LANGUAGE=$1
CKPTS=checkpoints
# Generate predictions on test data - read in all the inputs from tst.esp.input
# and generate outputs to the file tst.esp.output (this is slow and takes about a minute)
#fairseq-interactive data-bin/esp/ --source-lang=esp.input --target-lang=esp.output --path=checkpoints/esp-models/checkpoint_best.pt --input=tst.esp.input


fairseq-interactive "${DATABIN}/${LANGUAGE}/" \
--source-lang="${LANGUAGE}.input" \
--target-lang="${LANGUAGE}.output" \
--path="checkpoints/all-models/checkpoint_best.pt" \
--input="lang/test.${LANGUAGE}.input" | grep -P "D-[0-9]+" | cut -f3 > lang/test.${LANGUAGE}.output
