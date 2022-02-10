.PHONY: list

# https://stackoverflow.com/a/26339924/
# How do you get the list of targets in a makefile?
list:
	@$(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$'


#-------------------------------------------#
# user-specific variables (should be reviewed/edited)
#-------------------------------------------#

# unique identifier within the project
GCP_DATAPROC_CLUSTER_NAME=spark-cluster-test-01

# gcloud compute zone
GCP_ZONE=us-east1-c

# cloud storage bucket for dataproc cluster config files
# https://cloud.google.com/dataproc/docs/tutorials/dataproc-hub-admins#define_a_cluster_configuration
DATAPROC_CONFIG_BUCKET=genomics-dataproc-config-files
DATAPROC_LOCAL_CONFIG=dataproc

#----------------------------------------#
# default variables (may require editing)
#----------------------------------------#

#----------------------------------------#

# https://cloud.google.com/sdk/gcloud/reference/dataproc/clusters/import
dataproc_up:
	gcloud dataproc clusters import $(GCP_DATAPROC_CLUSTER_NAME) --source $(DATAPROC_LOCAL_CONFIG)/cluster.yaml \
	--region=us-east1

# https://cloud.google.com/dataproc/docs/concepts/versioning/dataproc-release-2.0
# https://cloud.google.com/dataproc/docs/tutorials/dataproc-hub-admins#set_dataproc_hub_instance_environment_variables
update_cluster_config_files:
	gsutil cp $(DATAPROC_LOCAL_CONFIG)/dataproc-hub.yaml $(DATAPROC_LOCAL_CONFIG)/single-node.yaml $(DATAPROC_LOCAL_CONFIG)/dataproc-env-vars gs://$(DATAPROC_CONFIG_BUCKET)

cat_current_env_vars:
	gsutil cat gs://$(DATAPROC_CONFIG_BUCKET)/dataproc-env-vars

list_cluster_config_files:
	gsutil ls gs://$(DATAPROC_CONFIG_BUCKET)

update_gcp_zone:
	gcloud config set compute/zone $(GCP_ZONE)
