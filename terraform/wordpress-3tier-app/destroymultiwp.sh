#!/bin/bash
for i in $(seq $1)
	do echo destroy wordpress $i
	terraform destroy -auto-approve -state=./wordpress_state_$i.tfstate & 
done
echo Done run
