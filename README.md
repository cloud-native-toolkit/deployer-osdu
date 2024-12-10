
# Installation of OSDU Product on Openshift using Tekton pipelines

This repository consists of Tekton pipelines for the installation of OSDU (Open Sub-surface Data Universe) Product on to Openshift.

## Prerequisites

- OpenShift cluster with admin access.
- ECR registry access for getting the ansible-installer images

## Pipeline Parameters

These parameters are passed to each task to provide flexibility:

- `ansible_image` Docker image containing the Ansible installer.
- `partition_admin_password` Password for partition administrator.
- `proj_name & cpd_proj_name` Namespaces for resources.
- `router_certs` Router certificate name.

## Pipeline Structure

`import-image-to-registry`

Logs into OpenShift using the provided credentials.
Checks if the ansible-installer ImageStream exists.
If not, creates the ImageStream and imports the specified image.



`run-ansible-playbook`

Executes a osdu-installation Ansible playbook using parameters from the pipeline.
Updates a variables file (odi-vars.yaml) with pipeline parameters for use by the playbook.
Performs osdu-installation tasks such as pre-req and osdu operators installation.



`post-install`

Runs a post-installation Ansible playbook (post-install.yml).
Verifies and applies configuration changes to finalize the setup.



`sanity-test`

Conducts sanity checks using an Ansible playbook to validate installation success.
Ensures all required components are functioning as expected.



`smoke-test`

Performs further tests to confirm the integrity and readiness of the installation.

## Steps to be followed before running the pipeline

- Before creating and running the pipeline. The pull-secret in the openshift-config namespace.
```
From RedHat Openshift Web Console. Go to Openshift-config Namespace
Edit pull-secret from secrets
Click on Add Credentials on bottom and fill the details. 

Registry server address: 849574731431.dkr.ecr.us-east-1.amazonaws.com 
Username : AWS
Password : <<Output password of command “aws ecr get-login-password --no-verify  >>
Email : <blank>
```


## Steps to deploy the Pipeline in OpenShift Cluster

1. **Clone the repository**

Clone the repository to local machine
```bash
git clone <GIT_REPO>
cd <REPO_DIRECTORY>
```

2. **Create pipeline in OpenShift Cluster**

Creating pipeline in openshift using oc command
```
oc create -f M22/pipeline.yaml
```

3. **Run Pipeline**

To run the pipeline, use the below command and replace all the parameters according to the environment.

```
oc create -f M22/pipelineRun.yaml
```



## Parameters Table
- The parameters which are defined in the pipeline definition. These can be overriden at the runtime as per your environment.

| Parameter Name            | Default Value                                                     | Type    | Description                                    |
|---------------------------|-------------------------------------------------------------------|---------|------------------------------------------------|
| `ansible_image`            | `849574731431.dkr.ecr.us-east-1.amazonaws.com/ansible-installer:techzone` | string  | Image used for running Ansible playbooks.      |
| `partition_admin_password` | `partition_password`                                              | string  | Password for partition admin.                 |
| `proj_name`                | `cpd`                                                           | string  | Project name in OpenShift.                    |
| `cpd_proj_name`            | `cpd-operators`                                                 | string  | CPD project name in OpenShift.                |
| `router_certs`             | `letsencrypt-certs`                                             | string  | Name of the router certificate.               |
