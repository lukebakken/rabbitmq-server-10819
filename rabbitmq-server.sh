#!/bin/sh
# vim:sw=4:et:

# set -x
set -e

SCRIPTS_DIR="$(dirname "$0")"

now()
{
    date '--rfc-3339=seconds'
}

printf "%s [INFO] $0 pid: %d\n" "$(now)" "$$"

should_ignore_sigint='false'

start_rabbitmq_server() {
    set -e
    set -f
    exec "$SCRIPTS_DIR/testerl.bash" "$should_ignore_sigint"
}

stop_rabbitmq_server() {
    if test "$rabbitmq_server_pid"
    then
        set +e
        kill -TERM "$rabbitmq_server_pid"
        wait "$rabbitmq_server_pid"
    fi
}

if [ "$RABBITMQ_ALLOW_INPUT" -o "$RUNNING_UNDER_SYSTEMD" -o "$detached" ]
then
    start_rabbitmq_server
else
    # When RabbitMQ runs in the foreground but the Erlang shell is
    # disabled, we setup signal handlers to stop RabbitMQ properly. This
    # is at least useful in the case of Docker.
    # The Erlang VM should ignore SIGINT.
    should_ignore_sigint='true'

    trap '' HUP TSTP CONT

    # NOTE:
    # The original rabbitmq-server script ALWAYS exits with code 0,
    # but is this really correct?
    # trap 'printf "%s [INFO] $0 SIGTERM" "$(now)"; stop_rabbitmq_server; exit 0' TERM
    trap 'printf "%s [INFO] $0 SIGTERM" "$(now)"; stop_rabbitmq_server; exit $?' TERM

    trap 'printf "%s [INFO] $0 SIGINT" "$(now)"; stop_rabbitmq_server; exit 130' INT

    start_rabbitmq_server &
    export rabbitmq_server_pid="$!"

    set +e
    wait "$rabbitmq_server_pid"
    exit "$?"
fi
