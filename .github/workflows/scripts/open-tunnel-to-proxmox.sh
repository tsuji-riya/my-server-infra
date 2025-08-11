#!/bin/bash
set -eu

tunnel_host="pve-api.riya.monster"
tunnel_entry_host="127.0.0.1"
tunnel_id="${CLOUDFLARE_TUNNEL_ID}"
tunnel_secret="${CLOUDFLARE_TUNNEL_SECRET}"

function echo_to_err () {
  echo "$1" >&2;
}

function pick_free_port () {
  # ref. https://stackoverflow.com/a/35338833
  for i in {10000..65535}; do
    # continue if the port accepts some input
    (exec 2>&- echo > "/dev/tcp/localhost/$i") && continue;

    echo "$i"
    return 0
  done

  # no port is open
  exit 1
}

function prepare_cloudflared_at () {
  local -r workdir="$1"

  # constants
  local -r cloudflared_release="2025.8.0"
  local -r cloudflared_binary="https://github.com/cloudflare/cloudflared/releases/download/${cloudflared_release}/cloudflared-linux-amd64"

  # download cloudflared
  wget "${cloudflared_binary}" -O "${workdir}/cloudflared"
  chmod 700 "${workdir}/cloudflared"

  echo_to_err "$("${workdir}"/cloudflared --version)"
}

tmp_workdir=$(mktemp -d)
prepare_cloudflared_at "${tmp_workdir}"

logfile=$(mktemp)

tunnel_entry_port="$(pick_free_port)"
tunnel_url="${tunnel_entry_host}:${tunnel_entry_port}"

# create tunnel entry on localhost
# close all of stdin/stdout/stderr off and fork
nohup "${tmpz¸¸¸_workdir}/cloudflared" access tcp \
  --id "${tunnel_id}" \
  --secret "${tunnel_secret}" \
  --hostname "${tunnel_host}" \
  --url "${tunnel_url}" \
  0<&- 1>"${logfile}" 2>&1 & disown

echo_to_err "Started a tunnel to ${tunnel_host} at ${tunnel_url}"

sleep 3
echo_to_err "Processes after 3 seconds:"
echo_to_err "$(ps -Al)"
echo_to_err ""
echo_to_err "Log of spawned process:"
echo_to_err "$(cat "${logfile}")"

echo "TF_VAR_pm_api_url=https://${tunnel_url}/api2/json" >> "$GITHUB_ENV"