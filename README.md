# A/B Testing your ASP.NET Core apps using Azure Container Apps

This repository contains sample code on how to host a set of revisions for your application that have slight differences, useful for performing A/B tests on your site to see how users will respond to changes gradually. You can use Azure App Configuration to create feature flags, then the ASP.NET Core feature flags extensions to change how your app will look or operate when features are enabled or disabled. With Azure Container Apps, you can create multiple revisions for each of your apps. When you put these pieces together, you can ship incremental features and bifurcate traffic so you understand how the changes will impact the app's usability before committing to the change. Then, if you find the change isn't delivering the desired impact for your customers, you can easily scale the "beta" revision back out again. 

* **Frontend** - A front-end web app written using ASP.NET Core Blazor Server. This web app is decorated with feature flags 
* **Monitoring** - A shared project that makes it simple to configure a .NET project with Application Insights monitoring. 
* You'll also see a series of Azure Bicep templates and a GitHub Actions workflow file in the **Azure** and **.github** folders, respectively. 

## What you'll learn

This exercise will introduce you to a variety of concepts, with links to supporting documentation throughout the tutorial. 

* [Azure Container Apps](https://docs.microsoft.com/azure/container-apps/overview) for hosting your app's container images. 
* [GitHub Actions](https://github.com/features/actions) for creating CI/CD workflows to deploy your apps to Azure.
* [Azure Container Registry](https://docs.microsoft.com/azure/container-registry/)
* [Azure Bicep](https://docs.microsoft.com/azure/azure-resource-manager/bicep/overview?tabs=**bicep**) for creating and configuring Azure resources.
* Azure App Configuration for setting up feature flags to control the A/B test variance.
* Kusto for building custom queries against the events your A/B tests generate.
* ASP.NET Core feature flags, useful for when you want to test new features or bifurcate functionality for A/B tests.

## Prerequisites

You'll need an Azure subscription and a very small set of tools and skills to get started:

1. An Azure subscription. Sign up [for free](https://azure.microsoft.com/free/).
2. A GitHub account, with access to GitHub Actions.
3. Either the [Azure CLI](https://docs.microsoft.com/cli/azure/install-azure-cli) installed locally, or, access to [GitHub Codespaces](https://github.com/features/codespaces), which would enable you to do develop in your browser.

## Topology diagram

IMG TBD

## Setup

By the end of this section you'll have a 3-node app running in Azure. This setup process consists of two steps, and should take you around 15 minutes. 

> Note: Remember to clean up or scale back your resources to save on compute costs. 

1. Use the Azure CLI to create an Azure Service Principal, then store that principal's JSON output to a GitHub secret so the GitHub Actions CI/CD process can log into your Azure subscription and deploy the code.
2. Edit the ` deploy.yml` workflow file and push the changes into a new `deploy` branch, triggering GitHub Actions to build the .NET projects into containers and push those containers into a new Azure Container Apps Environment. 

## Authenticate to Azure and configure the repository with a secret

1. Fork this repository to your own GitHub organization.
2. Create an Azure Service Principal using the Azure CLI. 

```bash
$subscriptionId=$(az account show --query id --output tsv)
az ad sp create-for-rbac --sdk-auth --name FeatureFlagsSample --role contributor --scopes /subscriptions/$subscriptionId
```

3. Copy the JSON written to the screen to your clipboard. 

```json
{
  "clientId": "",
  "clientSecret": "",
  "subscriptionId": "",
  "tenantId": "",
  "activeDirectoryEndpointUrl": "https://login.microsoftonline.com/",
  "resourceManagerEndpointUrl": "https://brazilus.management.azure.com",
  "activeDirectoryGraphResourceId": "https://graph.windows.net/",
  "sqlManagementEndpointUrl": "https://management.core.windows.net:8443/",
  "galleryEndpointUrl": "https://gallery.azure.com",
  "managementEndpointUrl": "https://management.core.windows.net"
}
```

4. Create a new GitHub secret in your fork of this repository named `AzureSPN`. Paste the JSON returned from the Azure CLI into this new secret. Once you've done this you'll see the secret in your fork of the repository.

   ![The AzureSPN secret in GitHub](docs/media/secrets.png)

> Note: Never save the JSON to disk, for it will enable anyone who obtains this JSON code to create or edit resources in your Azure subscription. 

## Deploy the code using GitHub Actions

The easiest way to deploy the code is to make a commit directly to the `deploy` branch. Do this by navigating to the `deploy.yml` file in your browser and clicking the `Edit` button. 

IMG TBD

Provide a custom resource group name for the app, and then commit the change to a new branch named `deploy`. 

IMG TBD

Once you click the `Propose changes` button, you'll be in "create a pull request" mode. Don't worry about creating the pull request yet, just click on the `Actions` tab, and you'll see that the deployment CI/CD process has already started. 

IMG TBD

When you click into the workflow, you'll see that there are 3 phases the CI/CD will run through:

1. provision - the Azure resources will be created that eventually house your app.
2. build - the various .NET projects are build into containers and published into the Azure Container Registry instance created during provision.
3. deploy - once `build` completes, the images are in ACR, so the Azure Container Apps are updated to host the newly-published container images. 

IMG TBD

After a few minutes, all three steps in the workflow will be completed, and each box in the workflow diagram will reflect success. If anything fails, you can click into the individual process step to see the detailed log output. 

> Note: if you do see any failures or issues, please submit an Issue so we can update the sample. Likewise, if you have ideas that could make it better, feel free to submit a pull request.

IMG TBD

With the projects deployed to Azure, you can now test the app to make sure it works. 

## Quick look at the code

TBD

## Try the app in Azure

The `deploy` CI/CD process creates a series of resources in your Azure subscription. These are used primarily for hosting the project code, but there's also a few additional resources that aid with monitoring and observing how the app is running in the deployed environment. 

| Resource         | Resource Type             | Purpose                                                      |
| ---------------- | ------------------------- | ------------------------------------------------------------ |

TBD

## Add a revision that enables the Beta feature

TBD

## Monitoring

Look at the custom events, then write a customized query. 

## Summary

TBD

> Note: Remember to clean up or scale back your resources to save on compute costs. 