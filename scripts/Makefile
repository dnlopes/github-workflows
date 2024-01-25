SHELL = /usr/bin/env bash -o pipefail
.SHELLFLAGS = -ec
.DEFAULT_GOAL := help
os       ?= $(shell uname|tr A-Z a-z)
ifeq ($(shell uname -m),x86_64)
  arch   ?= "amd64"
endif
ifeq ($(shell uname -m),i686)
  arch   ?= "386"
endif
ifeq ($(shell uname -m),aarch64)
  arch   ?= "arm"
endif

TF_CHDIR ?= terraform/anl-backups
TF_VARFILE ?= ../../configs/anl-backups/prd.tfvars
TERRAFORM_WORKSPACE ?= prd

##@ Development
init: .PHONY ## Run Terraform init
	terraform -chdir=$(TF_CHDIR) init -input=false -upgrade

workspace: .PHONY init ## Create Terraform workspace
	@terraform -chdir=$(TF_CHDIR) workspace new $(TERRAFORM_WORKSPACE) || true
	@terraform -chdir=$(TF_CHDIR) workspace select $(TERRAFORM_WORKSPACE)

ready: .PHONY ## Run Terraform validate and fmt
	@terraform -chdir=$(TF_CHDIR) validate
	@terraform -chdir=$(TF_CHDIR) fmt -check -recursive

lint: .PHONY ready ## Lint Terraform code
	@cd $(TF_CHDIR) && tflint --recursive --config ".tflint.hcl"

plan: .PHONY ## Run Terraform plan
	terraform -chdir=$(TF_CHDIR) plan -var-file="$(TF_VARFILE)" -input=false

apply: .PHONY ## Run Terraform apply
	terraform -chdir=$(TF_CHDIR) apply -var-file="$(TF_VARFILE)" -input=false -auto-approve

destroy: .PHONY ## Run Terraform destroy
	terraform -chdir=$(TF_CHDIR) destroy -var-file="$(TF_VARFILE)" -input=false -auto-approve

##@ Others
help: .PHONY ## Display this help (default target)
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

setup-repo: .PHONY ## setup and update submodule
	@mkdir -p .submodules
	@mkdir -p $(CURDIR)/build-tools
	@if [ ! -d ".submodules/common-tools" ]; then git submodule add --force https://github.com/SiggilumDiaboli/github-workflows.git .submodules/common-tools; fi
	git submodule update --recursive
	@[ -L $(CURDIR)/build-tools/common-scripts ] || ln -s $(CURDIR)/.submodules/common-tools/scripts $(CURDIR)/build-tools/common-scripts

.PHONY:
