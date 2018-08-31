#!/bin/bash

echo "[c1p worker job] invoked copado job from vcosquico repository"

notify_status "running" "20"
sleep 10s

notify_status "running" "40"
sleep 10s

notify_status "running" "60"
sleep 10s

notify_status "running" "80"
sleep 10s

notify_status "running" "100"
sleep 10s

echo "[c1p worker job] done! success"
