FROM "rabbitmq"
RUN sed -i 's/wait "\$rabbitmq_server_pid" || true/wait "$rabbitmq_server_pid"/g' "$(which rabbitmq-server)"
