#!/bin/bash

echo "[c1p worker job] invoked copado job from vcosquico repository"
printenv

notify_status "Retrieving_data" "20" 
echo "Retrieving data"
curl "${COPADO_SF_SERVICE_ENDPOINT}query?q=SELECT+name,+StageName+from+opportunity" \
-H 'Authorization: Bearer '"$COPADO_SF_AUTH_HEADER"'' \
| jq -c -r '.records[] | [.Name, .StageName] | @csv' > opportunities.csv
sleep 2s

notify_status "Compressing_data" "40"
echo "Compressing data"
zip --password copado opportunities.zip opportunities.csv
sleep 2s

notify_status "Uploading_data_FTP" "60" 
echo "Uploading FTP data"
curl -T opportunities.zip -u "$FTP_USER":"$FTP_PWD" "$FTP_URL3/opportunities-$(date +%s).zip"
sleep 2s

notify_status "Uploading_data_to_Google_Drive" "80" 
echo "Uploading GDrive data"
curl -XPOST --data 'client_id=864421843858-g6b3ngvrpg8p9j2kt03rv0l0h0kteuhn.apps.googleusercontent.com&client_secret=pUvKreCL4nLnYAaj_xmGyGa9&refresh_token=1/24qD4kf0lU-91tfazVp161zPCDkrwtX5PrQD4jh0q4tWM7WCt5xWfSfTcLTfYUnX' "https://accounts.google.com/o/oauth2/token?grant_type=refresh_token" | jq -cr '.access_token' > ./.drive_token
echo ./.drive_token

notify_status "Copado_rulez" "100" 
echo "Finish"
sleep 2s

echo "[c1p worker job] done! success"
