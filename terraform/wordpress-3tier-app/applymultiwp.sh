#!/bin/bash
for i in $(seq $1)
	do echo running wordpress $i
	TF_LOG=DEBUG terraform apply -auto-approve -var run_idx=$i -state=./wordpress_state_$i.tfstate 2> debug_output_$i.log > info_output_$i.log &
done
echo Done run
