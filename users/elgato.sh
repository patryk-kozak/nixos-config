#! /usr/bin/env nix-shell

set -euo pipefail

function connect-camera() {
   gphoto2 --stdout --capture-movie 2> ~/tmp/camera.log | ffmpeg -i - -vcodec rawvideo -pix_fmt yuv420p -threads 0 -f v4l2 /dev/video10 > /dev/null 2> ~/tmp/encoding-err.log &
   PID_CAM=$!
}

function main() {
	connect-camera &&\
	read -n 1 -s -r -p "Press any key to continue" &&\
	zoom-us 2> ~/tmp/zoom-output.log &&\
	kill -KILL $PID_CAM 
}

main