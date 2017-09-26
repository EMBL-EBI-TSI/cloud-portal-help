#!/bin/sh
end_point=${1:-dev}

case "$end_point" in
"dev")
    END_POINT="https://dev.api.portal.tsi.ebi.ac.uk"
    ;;
"master")
    END_POINT="https://api.portal.tsi.ebi.ac.uk"
    ;;
"localhost")
    END_POINT="http://localhost:8080"
    ;;
*)
    echo "Accepted arguments: \`dev\`, \`master\`, or \`loacalhost\`"
    exit
    ;;
esac

if [ -n "$jwt" ]
then
  PORTAL_JWT=$jwt
  echo 'PORTAL_JWT= '${PORTAL_JWT}
  echo ''
else

  echo "Please enter your jwt token: "
  read -sr PORTAL_JWT
  PORTAL_JWT=$PORTAL_JWT

  echo 'PORTAL_JWT= '${PORTAL_JWT}
  echo ''
fi

echo "Please enter the ID of the deployment: "
read -sr DEPLOYMENET_ID
DEPLOYMENET_ID=$DEPLOYMENET_ID

echo 'DEPLOYMENET_ID= '${DEPLOYMENET_ID}
echo ''

echo "Contacting the end point:" ${END_POINT}

curl -H "Authorization: Bearer  ${PORTAL_JWT}" \
${END_POINT}'/deployment/'${DEPLOYMENET_ID}/stop -X PUT
echo ''

sleep 10

curl -H "Authorization: Bearer  ${PORTAL_JWT}" \
${END_POINT}'/deployment/'${DEPLOYMENET_ID} -X DELETE
echo ''
