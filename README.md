# Running

```
 ./rabbitmq-server.sh; echo "[INFO] rabbitmq-server.sh exit code: $?"
```

It will output its pid as well as the pid of the "fake" RabbitMQ process.

# Tests

While `rabbitmq-server.sh` is running, try out the following:

* Send `SIGUSR2` to the "fake" RabbitMQ, to simulate a failure:
    ```
    kill -USR2 1234
    ```
* CTRL-C the running process
* Send `SIGTERM` to the running `rabbitmq-server.sh` process, to simulate what Docker does:
    ```
    kill -TERM 1234
    ```
