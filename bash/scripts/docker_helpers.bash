#!/bin/bash

dc() { printf "docker-compose %s\n" "$(printf '%q ' "$@")" >&2; command docker-compose "$@"; }
dps() { printf 'docker ps --format ... %s\n' "$(printf '%q ' "$@")" >&2; command docker ps --format 'table {{.Names}}	{{.Image}}	{{.Status}}	{{.Ports}}' "$@"; }
dstats() { printf 'docker stats --format ... %s\n' "$(printf '%q ' "$@")" >&2; command docker stats --format 'table {{.Name}}	{{.CPUPerc}}	{{.MemUsage}}	{{.MemPerc}}	{{.NetIO}}	{{.BlockIO}}' "$@"; }
dimg() { printf 'docker images --format ... %s\n' "$(printf '%q ' "$@")" >&2; command docker images --format 'table {{.Repository}}	{{.Tag}}	{{.Size}}	{{.CreatedAt}}' "$@"; }
dlog() { printf "docker logs -f %s\n" "$(printf '%q ' "$@")" >&2; command docker logs -f "$@"; }
dxec() { printf "docker exec -it %s\n" "$(printf '%q ' "$@")" >&2; command docker exec -it "$@"; }
dclean() { printf "docker system prune -af && docker volume prune -f\n" >&2; command docker system prune -af && command docker volume prune -f; }
docker_stop_all() { printf "docker stop \$(docker ps -q)\n" >&2; command docker stop $(command docker ps -q); }