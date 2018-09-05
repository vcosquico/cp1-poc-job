#!/bin/bash

echo "[c1p worker job] invoked copado job from vcosquico repository"
printenv

notify_status "Retrieving_data" "20" 
echo "Retrieving data"
curl -sS "${COPADO_SF_SERVICE_ENDPOINT}query?q=SELECT+name,+StageName+from+opportunity" \
-H 'Authorization: Bearer '"$COPADO_SF_AUTH_HEADER"'' \
| jq -c -r '.records[] | [.Name, .StageName] | @csv' > opportunities.csv
sleep 2s

notify_status "Compressing_data" "40"
echo "Compressing data"
zip --password copado opportunities.zip opportunities.csv
sleep 2s

notify_status "Uploading_data_FTP" "60" 
echo "Uploading FTP data"
curl -sS -T opportunities.zip -u "$FTP_USER":"$FTP_PWD" "$FTP_URL3/opportunities-$(date +%s).zip"
sleep 2s

#
# before you will need:
# 1.- Enable oauth access to yuor drive account
# 2.- request a CODE https://accounts.google.com/o/oauth2/auth?client_id=XXX&redirect_uri=urn:ietf:wg:oauth:2.0:oob&response_type=code&scope=https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fdrive
# 3.- login to get the access_token curl -XPOST --data "code=CODE&client_id=XXX&client_secret=YYY&redirect_uri=urn:ietf:wg:oauth:2.0:oob&grant_type=authorization_code" "https://accounts.google.com/o/oauth2/token"
notify_status "Uploading_data_to_Google_Drive" "80" 
echo "Uploading GDrive data"
curl -sS -XPOST --data 'grant_type=refresh_token&client_id=864421843858-g6b3ngvrpg8p9j2kt03rv0l0h0kteuhn.apps.googleusercontent.com&client_secret=pUvKreCL4nLnYAaj_xmGyGa9&refresh_token=1/24qD4kf0lU-91tfazVp161zPCDkrwtX5PrQD4jh0q4tWM7WCt5xWfSfTcLTfYUnX' "https://accounts.google.com/o/oauth2/token" | jq -cr '.access_token' > ./.drive_token
cat ./.drive_token
#curl -sS -XPOST "https://www.googleapis.com/upload/drive/v3/files?uploadType=media&name=opportunities$(date +%s).zip" -H "Content-Type: application/zip, application/octet-stream" -H "Authorization: Bearer $(cat ./.drive_token)" -d@opportunities.zip
curl -v -XPOST "https://www.googleapis.com/upload/drive/v3/files?uploadType=multipart" -H "Authorization: Bearer $(cat ./.drive_token)" -F "file=@opportunities.zip" -F "metadata={name : 'opportunities.zip'};type=application/json;charset=UTF-8"

notify_status "Copado_rulez" "100" 
echo "Finish"
sleep 2s

echo "[c1p worker job] done! success"
