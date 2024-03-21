#!/usr/bin/env bash

function now
{
    date '--rfc-3339=seconds'
}

trap "exit 70" USR1

if [[ $1 = 'true' ]]
then
    printf "%s [INFO] fake RabbitMQ will ignore SIGINT\n" "$(now)"
    trap "echo [INFO] IGNORING SIGINT" INT
fi

while true
do
    printf "%s [INFO] fake RabbitMQ running, pid %d\n" "$(now)" "$$"
    sleep 5
done
