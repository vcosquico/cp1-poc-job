#!/bin/bash

echo "[c1p worker job] invoked copado job from vcosquico repository" | tee -a /tmp/copado_logs.txt
echo "[c1p worker job] Processing something for...30 seconds" | tee -a /tmp/copado_logs.txt
sleep 30s
echo "[c1p worker job] done! success" | tee -a /tmp/copado_logs.txt
