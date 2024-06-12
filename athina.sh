#!/usr/bin/env bash

start() {
    docker-compose up -d localstack
} 

start() {
    docker-compose --profile core up -d
}

status() {
    docker-compose ps
}

stop() {
    docker-compose down
}

pull() {
    docker-compose --profile core pull
}

case "$1" in
    restart)
        start
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
    pull)
        pull
        ;;
    *)
        echo "Usage: $0 {start|status|stop|pull|restart}"
        exit 1
        ;;
esac