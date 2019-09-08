#!/bin/bash

max_nodes=99

current_working_directory=$PWD
source_config_directory="$GOPATH/src/github.com/ElrondNetwork/elrond-config"
source_node_binary="$GOPATH/src/github.com/ElrondNetwork/elrond-go/cmd/node/node"
target_directory_prefix="$GOPATH/src/github.com/ElrondNetwork/elrond-go-node"
keygenerator_directory="$GOPATH/src/github.com/ElrondNetwork/elrond-go/cmd/keygenerator"

for count in $(seq -f "%02g" 2 "$max_nodes")
do
	target_directory="$target_directory_prefix-$count"
	if [ ! -d "$target_directory" ]; then

		echo "Creating clone of initial node in: $target_directory"

		#create working folder and copy source files
		mkdir -p "$target_directory"/config
		cp "$source_config_directory"/*.* "$target_directory"/config
		cp "$source_node_binary" "$target_directory"

		#choose node name
		read -p "Choose the name of your node (default \"\"): " node_name
		if [ ! "$node_name" = "" ]
		then
		    sed -i 's|NodeDisplayName = ""|NodeDisplayName = "'"$node_name"'"|g' "$target_directory"/config/config.toml
		fi

		#create new keys and copy them to the target config directory
		cd "$keygenerator_directory"
		./keygenerator
        	cp initialBalancesSk.pem "$target_directory"/config
		cp initialNodesSk.pem "$target_directory"/config

		#return to the directory from which this script was executed
                cd "$current_working_directory"
        	break
	fi
done
