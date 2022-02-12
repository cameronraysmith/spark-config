.PHONY: targets

# https://stackoverflow.com/a/26339924/
# How do you get the list of targets in a makefile?
targets:
	@$(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$'


#-------------------------------------------#
# user-specific variables (should be reviewed/edited)
#-------------------------------------------#

# CLUSTER_NAME=test-cluster-01
CLUSTER_NAME=db-lts-cluster-01
SPARK_LTS_VERSION=9.1.x-cpu-ml-scala2.12
SPARK_LATEST_VERSION=10.3.x-cpu-ml-scala2.12

DATABRICKS_CLUSTER_CONFIG_FILE=./clusters/cluster.json
# see https://stackoverflow.com/a/649462/446907
define DATABRICKS_CLUSTER_CONFIG
{
    "num_workers": null,
    "autoscale": {
        "min_workers": 1,
        "max_workers": 3
    },
    "cluster_name": "$(CLUSTER_NAME)",
    "spark_version": "$(SPARK_LTS_VERSION)",
    "spark_conf": {},
    "gcp_attributes": {
        "use_preemptible_executors": true,
        "availability": "PREEMPTIBLE_WITH_FALLBACK_GCP"
    },
    "node_type_id": "n1-standard-4",
    "ssh_public_keys": [],
    "custom_tags": {},
    "spark_env_vars": {},
    "autotermination_minutes": 30,
    "cluster_source": "UI",
    "init_scripts": []
}
endef
export DATABRICKS_CLUSTER_CONFIG
CLUSTER_ID=$(shell databricks clusters get --cluster-name $(CLUSTER_NAME)  | jq ".default_tags .ClusterId")

write-cluster-configuration:
	@echo "$$DATABRICKS_CLUSTER_CONFIG" > $(DATABRICKS_CLUSTER_CONFIG_FILE)

#-----------------------#
# Make variable check
#-----------------------#

print_make_vars:
	$(info    CLUSTER_NAME is $(CLUSTER_NAME))
	$(info    CLUSTER_ID is $(CLUSTER_ID))
	$(info    DATABRICKS_CLUSTER_CONFIG is $(DATABRICKS_CLUSTER_CONFIG))

#----------------------------------------#
# default variables (may require editing)
#----------------------------------------#

#----------------------------------------#

create-glow-cluster: \
  create-cluster \
  wait \
  install-glow

create-cluster: write-cluster-configuration
	@echo "Creating cluster: $(CLUSTER_NAME)"
	databricks clusters create --json-file $(DATABRICKS_CLUSTER_CONFIG_FILE)

list-clusters:
	@databricks clusters list

# make start CLUSTER_ID=1234-567890-batch123
start-cluster:
ifdef CLUSTER_ID
	@echo 'starting cluster'
	databricks clusters start --cluster-id $(CLUSTER_ID)
else
	@echo 'define CLUSTER_ID'
endif

# make terminate-cluster CLUSTER_ID=1234-567890-batch123
terminate-cluster:
ifdef CLUSTER_ID
	@echo 'terminating cluster'
	databricks clusters delete --cluster-id $(CLUSTER_ID)
else
	@echo 'define CLUSTER_ID'
endif

# make delete-cluster CLUSTER_ID=1234-567890-batch123
delete-cluster:
ifdef CLUSTER_ID
	@echo 'deleting cluster'
	databricks clusters permanent-delete --cluster-id $(CLUSTER_ID)
else
	@echo 'define CLUSTER_ID'
endif

# make info CLUSTER_NAME=test-cluster-01
info-cluster:
ifdef CLUSTER_NAME
	@databricks clusters get --cluster-name $(CLUSTER_NAME)
else
	@echo 'define CLUSTER_NAME'
endif

state-cluster:
	@make info-cluster | jq -r '. | [.state, .state_message]'

list-cluster-buckets:
	@gsutil ls | grep "databricks-"

# make copy-cluster-bucket cluster-id-1=684224210727320 cluster-id-2=1905093459501363
copy-cluster-bucket:
	gsutil -m cp -r gs://databricks-$(cluster-id-1)/$(cluster-id-1)/home gs://databricks-$(cluster-id-2)/$(cluster-id-2)/home

get-clusterid:
ifdef CLUSTER_NAME
	@databricks clusters get --cluster-name $(CLUSTER_NAME)  | jq '.default_tags .ClusterId'
else
	@echo 'define CLUSTER_NAME'
endif

# make restart CLUSTER_ID=1234-567890-batch123
restart-cluster:
ifdef CLUSTER_ID
	@echo 'restarting cluster'
	databricks clusters restart --cluster-id $(CLUSTER_ID)
else
	@echo 'define CLUSTER_ID'
endif

library-status:
ifdef CLUSTER_ID
	databricks libraries cluster-status --cluster-id $(CLUSTER_ID)
else
	@echo 'define CLUSTER_ID'
endif

install-glow:
ifdef CLUSTER_ID
	databricks libraries install \
    --cluster-id $(CLUSTER_ID) \
    --maven-coordinates "io.projectglow:glow-spark3_2.12:1.1.2";
	databricks libraries install \
    --cluster-id $(CLUSTER_ID) \
    --pypi-package "glow.py==1.1.2"
else
	@echo 'define CLUSTER_ID'
endif

# see https://docs.databricks.com/dev-tools/cli/index.html
install-cli:
	pip install databricks-cli

# https://docs.databricks.com/dev-tools/cli/index.html#set-up-authentication
# https://docs.databricks.com/dev-tools/api/latest/authentication.html
# https://dbc-z8w99f33-7a1c.cloud.databricks.com
configure-cli:
	databricks configure --token
	cat $$HOME/.databrickscfg

wait wait_1 wait_2 wait_3:
	@echo "* pausing for 30 seconds"
	@sleep 30
