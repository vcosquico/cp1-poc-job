#!/bin/bash

echo "[c1p worker job] invoked copado job from vcosquico repository"

notify_status "Running" "20" 
sleep 10s

notify_status "40" "40"  
sleep 10s

notify_status "60" "60" 
sleep 10s

notify_status "80" "80" 
sleep 10s

notify_status "100" "100" 
sleep 10s

echo "[c1p worker job] done! success"
