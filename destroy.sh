echo "Please enter your jwt token: "
read -sr PORTAL_JWT
PORTAL_JWT=$PORTAL_JWT

echo 'PORTAL_JWT= '${PORTAL_JWT}
echo ''

echo "Please enter the ID of the deployment: "
read -sr DEPLOYMENET_ID
DEPLOYMENET_ID=$DEPLOYMENET_ID

echo 'DEPLOYMENET_ID= '${DEPLOYMENET_ID}
echo ''

curl -H "Authorization: Bearer  ${PORTAL_JWT}" \
'https://dev.api.portal.tsi.ebi.ac.uk/deployment/'${DEPLOYMENET_ID}'/stop' -X PUT
echo ''

curl -H "Authorization: Bearer  ${PORTAL_JWT}" \
'https://dev.api.portal.tsi.ebi.ac.uk/deployment/'${DEPLOYMENET_ID} -X DELETE
echo ''
