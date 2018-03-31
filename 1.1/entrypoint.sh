#!/bin/sh
set -e

CONF="/etc/galactrum/galactrum.conf"
DAEMON=galactrumd
DATA_DIR="${HOME}/.galactrum"
PID_FILE="${HOME}/${DAEMON}.pid"
PORT=6270
RPC_PORT=9910

# set up datadir and some aliases
mkdir -p "${DATA_DIR}"

# generate RPC connection parameters and credentials for cli use
# discover container IP addresses to allow RPC communication
RPCUSER=$(</dev/urandom tr -dc a-zA-Z0-9 | head -c 35)
RPCPASS=$(</dev/urandom tr -dc a-zA-Z0-9 | head -c 35)
DAEMON_IP=$(ifconfig eth0 | awk '/inet addr/ {gsub("addr:", "", $2); print $2}')
NETWORK=$(echo ${DAEMON_IP} | awk '{split($0, a, "."); print a[1] "." a[2] ".0.0/16"}')

cat <<END > $CONF
rpcallowip=${NETWORK}
rpcconnect=${DAEMON_IP}
rpcuser=${RPCUSER}
rpcpassword=${RPCPASS}
rpcport=${RPC_PORT}
END

if [ ! -z ${EXTERNAL_IP} ]; then
  cat <<END >> $CONF
externalip=${EXTERNAL_IP}
END
fi
if [ ! -z ${NODE1} ]; then
  cat <<END >> $CONF
addnode=${NODE1}
END
fi
if [ ! -z ${NODE2} ]; then
  cat <<END >> $CONF
addnode=${NODE2}
END
fi
if [ ! -z ${NODE3} ]; then
  cat <<END >> $CONF
addnode=${NODE3}
END
fi

# check for any -paramters and pass them on
if [ $(echo "$1" | cut -c1) = "-" ]; then
  set -- $DAEMON "$@"
fi

# add daemon startup parameters
if [ $(echo "$1" | cut -c1) = "-" ] || [ "$1" = ${DAEMON} ]; then
  set -- "$@" \
    -conf=${CONF} \
    -listen=1 \
    -logtimestamps=1 \
    -maxconnections=256 \
    -pid="${PID_FILE}" \
    -printtoconsole \
    -port=${PORT} \
    -server=1
fi

# run daemon
if [ "$1" = "${DAEMON}" ]; then
  # configure masternode if $masternode has been set with private key
  if [ ! -z ${MASTERNODE} ]; then
    set -- "$@" -masternode=1 -masternodeprivkey="${MASTERNODE}"
  elif [ -f "/var/run/secrets/masternode-privkey" ]; then
    set -- "$@" -masternode=1 -masternodeprivkey="$(cat /var/run/secrets/masternode-privkey)"
  fi

  exec "$@"
fi
