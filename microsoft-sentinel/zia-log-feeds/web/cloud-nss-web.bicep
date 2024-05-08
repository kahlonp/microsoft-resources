 /* 
This creates both the DCR and DCE's needed to ingest data into Sentinel from Zscaler's Cloud NSS capability. 
Please replace any references to workspace names or resource groups with your deployment details.
Steps needed to deploy:
1. Create an App Registration as per the Deployment Guide or Storylane demo
2. Run this script from Azure CLI using the following command:

    az stack group create --name cloud-nss-web --resource-group <resource group containing your log analytics workspace> --template-file ./cloud-nss-web.bicep --deny-settings-mode 'none'

  You will be prompted for parameters such as the resource group name and workspace id. You can enter ? and press enter to get a description of where to find each item.
  
  Alternatively, you can specify these parameters ahead of time by populating the cloud-nss-web.bicepparams file and running the following command in Azure CLI to deploy:

    az stack group create --name cloud-nss-web --resource-group <resource group containing your log analytics workspace> --parameters cloud-nss-web.bicepparam --deny-settings-mode 'none'

3. Go to the DCR this bicep template creates -> IAM -> Add this DCR as a Monitoring Metrics Publisher for the App Registration you created earlier.
4. Configure your Cloud NSS feed in the Zscaler Portal. You can retrieve the feed API URL using the following command in Azure CLI:

    az stack group show -g <resource group containing your log analytics workspace> -n cloud-nss-web --query outputs.api_url

5. If you ever need to delete the deployment, you can run the following command from Azure CLI:

    az stack group delete --name cloud-nss-web --resource-group <resource group containing your log analytics workspace> --delete-resources

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
      'Custom-nss_web_CL': {
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
	  name: 'vendor'
	  type: 'string'
	}
	{
	  name: 'product'
	  type: 'string'
	}
	{
	  name: 'version'
	  type: 'string'
	}
	{
	  name: 'act'
	  type: 'string'
	}
	{
	  name: 'Severity'
	  type: 'string'
	}
	{
	  name: 'name'
	  type: 'string'
	}
	{
	  name: 'deviceEventClassId'
	  type: 'string'
	}
	{
	  name: 'app'
	  type: 'string'
	}
	{
	  name: 'cat'
	  type: 'string'
	}
	{
	  name: 'dhost'
	  type: 'string'
	}
	{
	  name: 'dst'
	  type: 'string'
	}
	{
	  name: 'src'
	  type: 'string'
	}
	{
	  name: 'in_bytes'
	  type: 'string'
	}
	{
	  name: 'outcome'
	  type: 'string'
	}
	{
	  name: 'out'
	  type: 'string'
	}
	{
	  name: 'request'
	  type: 'string'
	}
	{
	  name: 'rt'
	  type: 'string'
	}
	{
	  name: 'sourceTranslatedAddress'
	  type: 'string'
	}
	{
	  name: 'requestClientApplication'
	  type: 'string'
	}
	{
	  name: 'requestMethod'
	  type: 'string'
	}
	{
	  name: 'suser'
	  type: 'string'
	}
	{
	  name: 'spriv'
	  type: 'string'
	}
	{
	  name: 'externalId'
	  type: 'string'
	}
	{
	  name: 'fileType'
	  type: 'string'
	}
	{
	  name: 'reason'
	  type: 'string'
	}
	{
	  name: 'destinationServiceName'
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
	  name: 'ZscalerNSSWeblogURLClass'
	  type: 'string'
	}
	{
	  name: 'ZscalerNSSWeblogDLPDictionaries'
	  type: 'string'
	}
	{
	  name: 'requestContext'
	  type: 'string'
	}
	{
	  name: 'contenttype'
	  type: 'string'
	}
	{
	  name: 'unscannabletype'
	  type: 'string'
	}
	{
	  name: 'deviceowner'
	  type: 'string'
	}
	{
	  name: 'devicehostname'
	  type: 'string'
	}
	{
	  name: 'keyprotectiontype'
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
        'Custom-nss_web_CL'
      ]
      destinations: [
        workspaceId
      ]
        transformKql: 'source | project TimeGenerated, DeviceVendor=tostring(vendor), DeviceProduct=tostring(product), DeviceVersion=tostring(version), DeviceAction=tostring(act), LogSeverity=tostring(Severity), Activity=tostring(name), DeviceEventClassID=tostring(deviceEventClassId), ApplicationProtocol=tostring(app), DeviceEventCategory=tostring(cat), DestinationHostName=tostring(dhost), DestinationIP=tostring(dst), SourceIP=tostring(src), ReceivedBytes=tolong(in_bytes), EventOutcome=tostring(outcome), SentBytes=tolong(out), RequestURL=tostring(request), ReceiptTime=tostring(rt), SourceTranslatedAddress=tostring(sourceTranslatedAddress), RequestClientApplication=tostring(requestClientApplication), RequestMethod=tostring(requestMethod), SourceUserName=tostring(suser), SourceUserPrivileges=tostring(spriv), ExtID=tostring(externalId), FileType=tostring(fileType), Reason=tostring(reason), DestinationServiceName=tostring(destinationServiceName), DeviceCustomNumber1=toint(cn1), DeviceCustomNumber1Label=tostring(cn1Label), DeviceCustomString1=tostring(cs1), DeviceCustomString1Label=tostring(cs1Label), DeviceCustomString2=tostring(cs2), DeviceCustomString2Label=tostring(cs2Label), DeviceCustomString3=tostring(cs3), DeviceCustomString3Label=tostring(cs3Label), DeviceCustomString4=tostring(cs4), DeviceCustomString4Label=tostring(cs4Label), DeviceCustomString5=tostring(cs5), DeviceCustomString5Label=tostring(cs5Label), DeviceCustomString6=tostring(cs6), DeviceCustomString6Label=tostring(cs6Label), RequestContext=tostring(requestContext), AdditionalExtensions = strcat("ZscalerNSSWeblogURLClass=",ZscalerNSSWeblogURLClass,";ZscalerNSSWeblogDLPDictionaries=",ZscalerNSSWeblogDLPDictionaries,";contenttype=",contenttype,";unscannabletype=",unscannabletype,";deviceowner=",deviceowner,";devicehostname=",devicehostname,";keyprotectiontype=",keyprotectiontype)'

        outputStream: 'Microsoft-CommonSecurityLog'
      }
  
      // 
    ]
  }
  location: location
  name: dcrName
}

// Store feed api url in template output
output api_url string = '${dce.properties.logsIngestion.endpoint}/dataCollectionRules/${dcr.properties.immutableId}/streams/Custom-nss_web_CL?api-version=2021-11-01-preview'
