#!/bin/bash

echo "[c1p worker job] invoked copado job from vcosquico repository"
printenv

notify_status "Retrieving_data" "20" 
curl "${COPADO_SF_SERVICE_ENDPOINT}query?q=SELECT+name,+StageName+from+opportunity" \
-H 'Authorization: Bearer '"$COPADO_SF_AUTH_HEADER"'' \
| jq -c -r '.records[] | [.Name, .StageName] | @csv' > opportunities.csv
sleep 2s

notify_status "Compressing_data" "40"
echo "Compressing data"
zip --password copado opportinities.zip opportunities.csv
sleep 2s

notify_status "Uploading_data" "60" 
curl -T opportunities.csv -u "$FTP_USER":"$FTP_PWD" "$FTP_URL/opportunities-$(date +%s).csv"
sleep 2s

notify_status "Copado_rulez" "100" 
sleep 2s

echo "[c1p worker job] done! success"
