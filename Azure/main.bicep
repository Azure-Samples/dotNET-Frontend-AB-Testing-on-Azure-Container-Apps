param location string = resourceGroup().location

// create the azure container registry
resource acr 'Microsoft.ContainerRegistry/registries@2021-09-01' = {
  name: toLower('${resourceGroup().name}acr')
  location: location
  sku: {
    name: 'Basic'
  }
  properties: {
    adminUserEnabled: true
  }
}

// create the aca environment
module env 'environment.bicep' = {
  name: 'containerAppEnvironment'
  params: {
    location: location
  }
}

// create the azure app configuration
module appConfig 'app_config.bicep' ={
  name: 'appConfiguration'
  params: {
    location: location
    featureFlagKey: 'Beta'
    featureFlagLabelEnabled: 'BetaEnabled'
  }
}

// create the various config pairs
var shared_config = [
  {
    name: 'ASPNETCORE_ENVIRONMENT'
    value: 'Development'
  }
  {
    name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
    value: env.outputs.appInsightsInstrumentationKey
  }
  {
    name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
    value: env.outputs.appInsightsConnectionString
  }
  {
    name: 'AzureAppConfig'
    value: appConfig.outputs.appConfigConnectionString
  }
  {
    name: 'RevisionLabel'
    value: 'BetaDisabled'
  }
]

// create the service container app
module frontend 'container_app.bicep' = {
  name: 'frontend'
  params: {
    name: 'frontend'
    location: location
    registryPassword: acr.listCredentials().passwords[0].value
    registryUsername: acr.listCredentials().username
    containerAppEnvironmentId: env.outputs.id
    registry: acr.name
    envVars: shared_config
  }
}

