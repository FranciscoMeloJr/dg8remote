echo "Script to call query"
podname=$(oc get pod | awk 'NR==2 {print $1}')

svcname=$(oc get svc dg-cluster-8718 -o go-template --template='{{.metadata.name}}.{{.metadata.namespace}}.svc.cluster.local{{println}}')
passcode=$(oc get secret dg-cluster-8718-generated-secret -o jsonpath="{.data.identities\.yaml}" | base64 --decode | grep password | awk 'NR==1 {print $2}')
username=$(oc get secret dg-cluster-8718-generated-secret -o jsonpath="{.data.identities\.yaml}" | base64 --decode | grep username | awk 'NR==1 {print $3}')
saslMechanismName="BASIC"
realmName="default"
pathTrustStore="/mnt/secrets/truststore.jks"

echo "Host Name" $svcname
echo "user Name" $username
echo "Passcode" $passcode
echo "saslMechanismName" $saslMechanismName
echo "realmName" $realmName
echo "pathTrustStore" $pathTrustStore

oc exec $podname -- java -jar /opt/infinispan/server/lib/external-artifacts/dg8remote-0.0.1-SNAPSHOT.jar $svcname $username $passcode $saslMechanismName $realmName $pathTrustStore
