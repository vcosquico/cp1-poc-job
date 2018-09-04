#!/bin/bash

echo "[c1p worker job] invoked copado job from vcosquico repository"
printenv

notify_status "Retrieving_data" "20" 
echo "Retrieving data"
ping https://copado-1-platform-dev-01-dev-ed.my.salesforce.com
curl https://copado-1-platform-dev-01-dev-ed.my.salesforce.com/services/data/v20.0/query\?\
q\=SELECT+name,+StageName+from+opportunity -H "Authorization: Bearer 00D1t000000Eo4i\!ARAAQA9Bx7zWKliNpxT1afs4ll_KeOcVjEDn\
4Qy853uVo6rDJ815RTu_VJM7Cfvwm.nrTrFr4GebKq.9JoWQKtiTW3LeamFN" | jq -c -r '.records[] | [.Name, .StageName] | @csv' > \
opportunities.csv
sleep 2s

notify_status "Compressing_data" "40"
echo "Compressing data"
zip --password copado opportinities.zip opportunities.csv
sleep 2s

notify_status "Uploading_data" "60" 
curl -T opportunities.csv -u copado:df1Cpd0 "ftp://ftp.copado.com/opportunities-$(date +%s).csv"
sleep 2s

notify_status "Copado_rulez" "100" 
sleep 2s

echo "[c1p worker job] done! success"
