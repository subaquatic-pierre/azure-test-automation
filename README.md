# CI / CD Test Automation Pipeline - Azure DevOps

## Dependencies

Before starting this walk-through, you will need to have the following resources installed. Please follow the resource guides to install all dependencies if you do not already have them.

### Azure Resources

1. Azure Free account
2. Azure Storage account ([resource](https://docs.microsoft.com/en-us/azure/developer/terraform/store-state-in-azure-storage))
3. Azure Log Workspace ([resource](https://docs.microsoft.com/en-us/azure/azure-monitor/learn/quick-create-workspace))
4. Terraform Service principle ([resource](https://www.terraform.io/docs/providers/azurerm/guides/service_principal_client_secret.html))
5. Azure DevOps Organization
6. Azure CLI ([resource](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest))

### Locally Installed Dependencies

Scripts can be found in the [Resource](#Resources) section

2. Jmeter
3. Postman
4. Newman
5. Terraform [resource](https://learn.hashicorp.com/tutorials/terraform/install-cli)

## Steps

1. Clone this repo

```
git clone https://github.com/subaquatic-pierre/ci-cd-test-automation.git
```

2. Create AzurePipeLine Project ([resource](https://docs.microsoft.com/en-us/azure/devops/organizations/projects/create-project?view=azure-devops&tabs=preview-page))

3. Link Project to GitHub repo ([resource](https://docs.microsoft.com/en-us/azure/devops/pipelines/repos/github?view=azure-devops&tabs=yaml))

4. Update 'terraform.tfvars' to include your credentials

```yaml
# Azure subscription vars
subscription_id = "YOUR_CREDENTIALS"
client_id = "YOUR_CREDENTIALS"
client_secret = "YOUR_CREDENTIALS"
tenant_id = "YOUR_CREDENTIALS"

# Resource Group/Location
location = "YOUR_CREDENTIALS"
resource_group = "YOUR_CREDENTIALS"
application_type = "YOUR_CREDENTIALS"

# Network
virtual_network_name = "YOUR_CREDENTIALS"
address_space = ["10.5.0.0/16"]
address_prefix_test = "10.5.1.0/24"
```

5. From the command line, change into terraform directory

```
cd terraform
```

6. Run Terraform init and apply commands. Enter 'yes' once prompted to run plan

```
terraform init
terraform apply
```

7. Create CITESTING Environment in the pipeline ([resource](https://docs.microsoft.com/en-us/azure/devops/pipelines/ecosystems/deploy-linux-vm?view=azure-devops&tabs=java))

Name the environment the following:

```
CITESTING
```

8. Create SSH keypair to be used with GitHub and Azure Pipelines ([resource](https://docs.microsoft.com/en-us/azure/devops/pipelines/tasks/utility/install-ssh-key?view=azure-devops))

9. Create Service Connection in DevOps project

10. Update 'azure-pipelines.yaml' to include your SSH key ([resource](https://docs.microsoft.com/en-us/azure/devops/pipelines/tasks/utility/install-ssh-key?view=azure-devops))

```yaml
- task: InstallSSHKey@0
  inputs:
    knownHostsEntry: "GITHUB_HOSTS"
    sshPublicKey: "YOUR_PUBLIC_KEY"
    sshKeySecureFile: "YOUR_SECURE_FILE"
```

11. Create Log Analytics Workspace ([resource](https://docs.microsoft.com/en-us/azure/azure-monitor/learn/quick-create-workspace))

12. Link Virtual Machine to Log Work Space ([resource](https://docs.microsoft.com/en-us/azure/azure-monitor/learn/quick-collect-azurevm))

13. Create custom log file ([resource](https://docs.microsoft.com/en-us/azure/azure-monitor/platform/data-sources-custom-logs))

The log path name should be the following:

```
/var/log/selenium/*.log
```

14. Connect App Service to Write logs to Azure Log Workspace

15. Create Alert Group for the App Service

16. Change directory into 'jmeter'. Open Jmeter application and open the stress_test_suite.jmx' or 'endurance_test_suite.jmx' to edit the suite. Save the suites with their respective names. Edit URL to point to your WebAppService

17. Write Selenium tests in 'selenium/selenium_test.py'

18. Make one last git commit and push for pipeline to trigger the final build

```
git add .
git commit -m 'Final build'
git push
```

## Notes

- Cant run Jmeter tests with Standard_B1s machine, not enough RAM, need to use Standard_B2s

## Resources

### Jmeter installation script

Change into the directory which you wish to install Jmeter package

```sh
cd /usr/lib
```

Run the below installation script. It will download Jmeter and add a symlink to your PATH

```sh
#! /bin/bash
echo "Downloading Jmeter ..."
wget https://downloads.apache.org//jmeter/binaries/apache-jmeter-5.3.tgz
echo "Unpacking jmeter tgz ..."
tar -xzvf apache-jmeter-5.3.tgz
echo "Create symlink to jmeter bin file"
sudo ln -s ./apache-jmeter-5.3/bin/jmeter /usr/bin/jmeter
echo "Removing jmeter tgz ..."
sudo rm -rf apache-jmeter-5.3.tgz
```

### Selenium and ChromeDriver installation

Install selenium and add chrome-driver to PATH
e

```sh
sudo apt-get upgrade -y
sudo apt-get install python3-pip -y
sudo apt-get install unzip -y
sudo apt-get install -y chromium-browser
pip3 install selenium
export PATH=$PATH:/usr/bin/chromebrowser
```

### Install Postman and Newman

```sh
sudo apt-get upgrade -y
sudo snap install postman
sudo npm install -g newman reporter
```

### Official Guides

#### - Create Azure DevOps Project

https://docs.microsoft.com/en-us/azure/devops/organizations/projects/create-project?view=azure-devops&tabs=preview-page

#### - Link Azure DevOps Project to GitHub repo

https://docs.microsoft.com/en-us/azure/devops/pipelines/repos/github?view=azure-devops&tabs=yaml

#### - Create Azure Storage account for Terraform

https://docs.microsoft.com/en-us/azure/developer/terraform/store-state-in-azure-storage

#### - Create Terraform Service Principal

https://www.terraform.io/docs/providers/azurerm/guides/service_principal_client_secret.html

#### - Create Azure Log Workspace

https://docs.microsoft.com/en-us/azure/azure-monitor/learn/quick-create-workspace

#### - Install Azure CLI

https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest

#### - Create custom log file

https://docs.microsoft.com/en-us/azure/azure-monitor/platform/data-sources-custom-logs

#### - Connect VM to Log Anazlytics workspace

https://docs.microsoft.com/en-us/azure/azure-monitor/learn/quick-collect-azurevm

#### - Create CI/CD Testing Environment

https://docs.microsoft.com/en-us/azure/devops/pipelines/ecosystems/deploy-linux-vm?view=azure-devops&tabs=java

#### - Create SSH key pair

https://docs.microsoft.com/en-us/azure/devops/pipelines/tasks/utility/install-ssh-key?view=azure-devops
