#!/bin/bash

echo "[c1p worker job] invoked copado job from vcosquico repository"

notify_status "20" "a"
sleep 10s

notify_status "40" "b"
sleep 10s

notify_status "60" "c"
sleep 10s

notify_status "80" "d"
sleep 10s

notify_status "100" "e"
sleep 10s

echo "[c1p worker job] done! success"
