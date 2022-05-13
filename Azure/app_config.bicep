@description('Specifies the name of the App Configuration store.')
param configStoreName string = 'appconfig${uniqueString(resourceGroup().id)}'

@description('Specifies the Azure location where the app configuration store should be created.')
param location string = resourceGroup().location

@description('Specifies the key of the feature flag.')
param featureFlagKey string

@description('Specifies the label of the feature flag. The label is optional and can be left as empty.')
param featureFlagLabelEnabled string

var featureFlagValue = {
  id: featureFlagKey
  description: 'Your description.'
  enabled: true
}

resource appConfig 'Microsoft.AppConfiguration/configurationStores@2021-10-01-preview' ={
  location: location
  name: configStoreName
  sku: {
    name: 'free'
  }
}

var appConfigConnectionString = appConfig.listKeys().value[0].connectionString

resource beta 'Microsoft.AppConfiguration/configurationStores/keyValues@2021-10-01-preview' ={
  parent: appConfig
  name: '.appconfig.featureflag~2F${featureFlagKey}$${featureFlagLabelEnabled}'
  properties: {
    value: string(featureFlagValue)
    contentType: 'application/vnd.microsoft.appconfig.ff+json;charset=utf-8'
  }
}

output appConfigConnectionString string = appConfigConnectionString
