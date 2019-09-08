#!/bin/bash

max_nodes=99

node_directory_prefix="$GOPATH/src/github.com/ElrondNetwork/elrond-go-node"
node_ids_directory="$HOME/elrond/node_identities"

for count in $(seq -f "%02g" 1 "$max_nodes"); do
	if [ "$count" -eq "01" ]; then
		node_directory="$node_directory_prefix"
	else
		node_directory="$node_directory_prefix-$count"
	fi

	if [ -d "$node_directory" ]; then
		#create new node_id in the node_ids_directory
		node_sk=$(< "$node_directory/config/initialNodesSk.pem")
		node_id=${node_sk:27:8}
		node_id_directory="$node_ids_directory"/"$node_id"
		mkdir -p "$node_id_directory"

		#copy identity files to node_id directory
		cp "$node_directory"/config/initialNodesSk.pem "$node_id_directory"
		cp "$node_directory"/config/initialBalancesSk.pem "$node_id_directory"
	else
        	break
	fi
done
