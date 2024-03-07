/* 
This creates both the DCR and DCE's needed to ingest data into Sentinel from Zscaler's Cloud NSS capability.
Steps needed to deploy:
1. Create an App Registration as per the Deployment Guide or Storylane demo
2. Run this script from Azure CLI using the following command:

  az stack group create --name cloud-nss-dns --resource-group <resource group containing your log analytics workspace> --template-file ./cloud-nss-dns.bicep --deny-settings-mode 'none'

  You will be prompted for parameters such as the resource group name and workspace id. You can enter ? and press enter to get a description of where to find each item.
  
  Alternatively, you can specify these parameters ahead of time by populating the cloud-nss-web.bicepparams file and running the following command in Azure CLI to deploy:

  az stack group create --name cloud-nss-dns --resource-group <resource group containing your log analytics workspace> --parameters cloud-nss-dns.bicepparam --deny-settings-mode 'none'

3. Go to the DCR this bicep template creates -> IAM -> Add this DCR as a Monitoring Metrics Publisher for the App Registration you created earlier.
4. Configure your Cloud NSS feed in the Zscaler Portal. You can retrieve the feed API URL using the following command in Azure CLI:

   az stack group show -g <resouce group containing your log analytics workspace> -n cloud-nss-dns --query outputs.api_url

5. If you ever need to delete the deployment, you can run the following command from Azure CLI:

  az stack group delete --name cloud-nss-dns --resource-group <resouce group containing your log analytics workspace> --delete-resources

*/

// These resources need to be pre-configured
@description('Found under Log Analytics workspace -> your workspace -> Overview -> Resource group')
param resourceGroup string // Found under Log Analytics workspace -> your workspace -> Overview -> Resource group
@description('The name of your Log Analytics workspace')
param workspaceName string
@description('Found under Log Analytics workspace -> your workspace -> Overview -> JSON View -> location. I.e. australiaeast')
param location string
@description('Found under Log Analytics workspace -> your workspace -> Overview -> Subscription ID')
param subscriptionId string
@description('Found under Log Analytics workspace -> your workspace -> Overview -> Workspace ID')
param workspaceId string

// These resources are configured through bicep
@description('Name of Data Collection Endpoint the template will create')
param dceName string
@description('Name of the Data Collection Rule the template will create')
param dcrName string

resource dce 'Microsoft.Insights/dataCollectionEndpoints@2022-06-01' = {
  properties: {
    configurationAccess: {}
    logsIngestion: {}
    networkAcls: {
      publicNetworkAccess: 'Enabled'
    }
  }
  location: location
  name: dceName
}

resource dcr 'Microsoft.Insights/dataCollectionRules@2022-06-01' = {
  properties: {
    dataCollectionEndpointId: dce.id
    streamDeclarations: {
      'Custom-nss_dns_CL': {
        columns: [
          {
            name: 'sourcetype'
            type: 'string'
          }
          {
            name: 'TimeGenerated'
            type: 'datetime'
          }
          {
            name: 'suser'
            type: 'string'
          }
          {
            name: 'act'
            type: 'string'
          }
          {
            name: 'rulelabel'
            type: 'string'
          }
          {
            name: 'cat'
            type: 'string'
          }
          {
            name: 'cs1'
            type: 'string'
          }
          {
            name: 'cs1Label'
            type: 'string'
          }
          {
            name: 'cs2'
            type: 'string'
          }
          {
            name: 'cs2Label'
            type: 'string'
          }
          {
            name: 'cs3'
            type: 'string'
          }
          {
            name: 'cs3Label'
            type: 'string'
          }
          {
            name: 'cs4'
            type: 'string'
          }
          {
            name: 'cs4Label'
            type: 'string'
          }
          {
            name: 'cs5'
            type: 'string'
          }
          {
            name: 'cs5Label'
            type: 'string'
          }
          {
            name: 'cs6'
            type: 'string'
          }
          {
            name: 'cs6Label'
            type: 'string'
          }
          {
            name: 'cn1'
            type: 'string'
          }
          {
            name: 'cn1Label'
            type: 'string'
          }
          {
            name: 'flexString1'
            type: 'string'
          }
          {
            name: 'flexString1Label'
            type: 'string'
          }
          {
            name: 'flexString2'
            type: 'string'
          }
          {
            name: 'flexString2Label'
            type: 'string'
          }
          {
            name: 'src'
            type: 'string'
          }
          {
            name: 'dst'
            type: 'string'
          }
          {
            name: 'dpt'
            type: 'string'
          }
          {
            name: 'spriv'
            type: 'string'
          }
          {
            name: 'suid'
            type: 'string'
          }
          {
            name: 'dvchost'
            type: 'string'
          }
          {
            name: 'DeviceVendor'
            type: 'string'
          }
          {
            name: 'DeviceProduct'
            type: 'string'
          }
        ]
      }
    }
    dataSources: {}
    destinations: {
      logAnalytics: [
        {
          workspaceResourceId: resourceId(subscriptionId, resourceGroup, 'microsoft.operationalinsights/workspaces', workspaceName)
          name: workspaceId
        }
      ]
    }
    dataFlows: [
      {
        streams: [
          'Custom-nss_dns_CL'
        ]
        destinations: [
          workspaceId
        ]
        transformKql: 'source | project TimeGenerated,\nDeviceCustomString1Label = tostring(cs1Label) , DeviceCustomString1 = tostring(cs1) ,\nDeviceCustomString2Label = tostring(cs2Label) , DeviceCustomString2 = tostring(cs2) ,\nDeviceCustomString3Label = tostring(cs3Label) , DeviceCustomString3 = tostring(cs3) ,\nDeviceCustomString4Label = tostring(cs4Label) , DeviceCustomString4 = tostring(cs4) ,\nDeviceCustomString5Label = tostring(cs5Label) , DeviceCustomString5 = tostring(cs5) ,\nDeviceCustomString6Label = tostring(cs6Label) , DeviceCustomString6 = tostring(cs6) ,\nDeviceCustomNumber1Label = tostring(cn1Label) , DeviceCustomNumber1 = toint(cn1) ,\nFlexString1Label = tostring(flexString1Label) , FlexString1 = tostring(flexString1),\nFlexString2Label = tostring(flexString2Label) , FlexString2 = tostring(flexString2),\nSourceUserName = tostring(suser),\nDeviceAction = tostring(act) ,\nDeviceEventClassID=tostring(act) ,\nDestinationIP = tostring(dst) ,\nSourceIP = tostring(src) ,\nSourceUserPrivileges = tostring(spriv),\nDestinationPort = toint(dpt) ,\nrulelabel = tostring(rulelabel) ,\nDeviceVendor = tostring(DeviceVendor),\nDeviceProduct = tostring(DeviceProduct),\nDeviceName = tostring(dvchost),\nActivity = tostring(act),\nReason = tostring(rulelabel),\ncat = tostring(cat),\nSourceUserID = tostring(suid)\n'
        outputStream: 'Microsoft-CommonSecurityLog'
      }
    ]
  }
  location: location
  name: dcrName
}

// Store feed api url in template output
output api_url string = '${dce.properties.logsIngestion.endpoint}/dataCollectionRules/${dcr.properties.immutableId}/streams/Custom-nss_dns_CL?api-version=2021-11-01-preview'
