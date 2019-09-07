#!/bin/bash

max_nodes=99

working_directory=$PWD
keygenerator_directory=$GOPATH/src/github.com/ElrondNetwork/elrond-go/cmd/keygenerator
source_directory=$GOPATH/src/github.com/ElrondNetwork/elrond-go/cmd/node

for count in $(seq -f "%02g" 2 $max_nodes)
do
	target_directory=$source_directory$count
	if [ ! -d "$target_directory" ]; then
		echo "Creating clone of initial node in: $target_directory"
		cp -R $source_directory $target_directory
		cd $keygenerator_directory
		./keygenerator
        	cp initialBalancesSk.pem $target_directory/config/
		cp initialNodesSk.pem $target_directory/config/
                cd $working_directory
        	break
	fi
done
