

oc create -f https://raw.githubusercontent.com/cloud-native-toolkit/deployer-osdu/refs/heads/main/M22/pipeline.yaml -n default
sleep 60
oc create -f https://raw.githubusercontent.com/cloud-native-toolkit/deployer-osdu/refs/heads/main/M22/pipeline-run.yaml -n default
