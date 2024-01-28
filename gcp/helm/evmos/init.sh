#!/bin/bash

export NODE_HOME=/root/.evmosd
export CHAIN_ID=evmos_9000-4
export NODE_MONIKER=ayushv
export BINARY=evmosd
export GENESIS_URL=https://snapshots.polkachu.com/testnet-genesis/evmos/genesis.json
export SNAPSHOT=https://snapshots.polkachu.com/testnet-snapshots/evmos/evmos_20638130.tar.lz4

# Check if SYNC_SNAPSHOT is true
if [ "$SYNC_SNAPSHOT" == "true" ]; then
    # Run init and snapshot download
    rm -rf $NODE_HOME/data
    rm -rf $NODE_HOME/config
    # mkdir $NODE_HOME/config -p
    echo "***********************"
    echo "INSTALLED EVMOSD VERSION"
    evmosd version
    echo "***********************"
    echo "configuring chain..."
    evmosd init $NODE_MONIKER --home $NODE_HOME --chain-id=$CHAIN_ID
    wget -O genesis.json $GENESIS_URL --inet4-only
    echo "copying over genesis file..."
    cp genesis.json $NODE_HOME/config/genesis.json
    ls $NODE_HOME/config/
    curl -o - -L $SNAPSHOT | lz4 -c -d - | tar -x -C $NODE_HOME
    echo "node initialized, snapshot downloaded "
else
    echo "skipping init and snapshot download"
fi

 echo "updating evmos configs ..."
rm -rf $NODE_HOME/config/config.toml
rm -rf  $NODE_HOME/config/app.toml
cp /configtoml/config.toml  $NODE_HOME/config/config.toml
cp /apptoml/app.toml  $NODE_HOME/config/app.toml

echo "starting evmos..."
evmosd start --home $NODE_HOME  --chain-id=$CHAIN_ID
