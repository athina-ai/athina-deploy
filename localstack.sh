#!/usr/bin/env bash

restart() {
    docker-compose down localstack && docker-compose up -d localstack
}

start() {
    docker-compose up -d localstack
}

status() {
    docker-compose ps
}

stop() {
    docker-compose down localstack
}

case "$1" in
    restart)
        restart
        ;;
    start)
        start
        ;;
    status)
        status
        ;;
    stop)
        stop
        ;;
    *)
        echo "Usage: $0 {restart|start|status|stop}"
        exit 1
        ;;
esac