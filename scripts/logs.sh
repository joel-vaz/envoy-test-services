#!/bin/bash

# Change to script directory
cd "$(dirname "$0")"

usage() {
    echo "Usage: $0 [service]"
    echo "Services:"
    echo "  appa        - View ApplicationA logs"
    echo "  appb        - View ApplicationB logs"
    echo "  appa-proxy  - View AppA proxy logs"
    echo "  appb-proxy  - View AppB proxy logs"
    echo "  appa-ingress- View AppA ingress logs"
    echo "  appb-ingress- View AppB ingress logs"
    echo "  all         - View all logs"
    exit 1
}

if [ $# -eq 0 ]; then
    usage
fi

case "$1" in
    "appa")
        docker-compose logs -f appa
        ;;
    "appb")
        docker-compose logs -f appb
        ;;
    "appa-proxy")
        docker-compose logs -f appa-proxy
        ;;
    "appb-proxy")
        docker-compose logs -f appb-proxy
        ;;
    "appa-ingress")
        docker-compose logs -f appa-ingress
        ;;
    "appb-ingress")
        docker-compose logs -f appb-ingress
        ;;
    "all")
        docker-compose logs -f
        ;;
    *)
        usage
        ;;
esac 