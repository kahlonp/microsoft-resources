using 'cloud-nss-web.bicep'

// Define the 'param' values below

// Found under Log Analytics workspace -> your workspace -> Overview -> Resource group
param resourceGroup = 'push-test-sentinel-rg'

// The name of your Log Analytics workspace
param workspaceName = 'push-sentinel-workspace-instance'

// Found under Log Analytics workspace -> your workspace -> Overview -> JSON View -> "location": (i.e. useast)
param location = 'South India'

// Found under Log Analytics workspace -> your workspace -> Overview -> Subscription ID
param subscriptionId = '2a6ad70d-f42e-4670-a67f-ca9b0eebd748'

// Found under Log Analytics workspace -> your workspace -> Overview -> Workspace ID
param workspaceId = 'd9e71432-f04d-4179-80cf-1357b8cbc159'

// The name you want to provide the Data Collection Endpoint that the template will create
param dceName = 'dce-sentinel-cloud-web'

// The name you want to provide the Data Collection Rule that the template will create
param dcrName = 'dcr-sentinel-cloud-web'
