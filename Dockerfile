FROM "rabbitmq"
RUN sed -i 's/wait "\$rabbitmq_server_pid" || true/wait "$rabbitmq_server_pid" || exit "$?"/g' "$(which rabbitmq-server)"
