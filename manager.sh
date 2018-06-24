ss_image_version=1.0.0
ss_image="docker.kiuber.me/ss-alpine:$ss_image_version"

ss_container='ss-alpine'

ss_config_in_host="$PWD/config/shadowsocks.json"
ss_config_in_container='/etc/shadowsocks.json'

source $PWD/appupy/bash-files/base.sh

function run() {
    local cmd="docker run --name $ss_container"
    cmd="$cmd -v $ss_config_in_host:$ss_config_in_container"
    cmd="$cmd -p 8989:80"
    cmd="$cmd -d $ss_image ssserver -c $ss_config_in_container"
    run_cmd "$cmd"
}

function stop() {
    remove_container $ss_container
}

function start() {
    run
}

function restart() {
    remove_container $ss_container
    run
}

function to_ss() {
    _send_cmd_to_container $ss_container 'sh'
}

function logs() {
    local cmd="docker logs -f $ss_container"
    run_cmd "$cmd"
}

function help() {
    cat <<-EOF

        Valid options are:
            run
            stop
            start 
            restart

            to_ss

            logs

            help                      show this help message and exit

EOF
}

action=${1:-help}
$action "$@"

