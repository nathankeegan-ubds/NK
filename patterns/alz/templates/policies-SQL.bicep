targetScope = 'managementGroup'

@metadata({ message: 'The JSON version of this file is programatically generated from Bicep. PLEASE DO NOT UPDATE MANUALLY!!' })
@description('Provide a prefix (unique at tenant-scope) for the Management Group hierarchy and other resources created as part of an Azure landing zone. DEFAULT VALUE = "alz"')
param topLevelManagementGroupPrefix string = 'alz'

@description('Optionally set the deployment location for policies with Deploy If Not Exists effect. DEFAULT VALUE = "deployment().location"')
param location string = deployment().location

@description('Optionally set the scope for custom Policy Definitions used in Policy Set Definitions (Initiatives). Must be one of \'/\', \'/subscriptions/id\' or \'/providers/Microsoft.Management/managementGroups/id\'. DEFAULT VALUE = \'/providers/Microsoft.Management/managementGroups/\${topLevelManagementGroupPrefix}\'')
param scope string = tenantResourceId('Microsoft.Management/managementGroups', topLevelManagementGroupPrefix)

// Extract the environment name to dynamically determine which policies to deploy.
var cloudEnv = environment().name

// Default deployment locations used in templates
var defaultDeploymentLocationByCloudType = {
  AzureCloud: 'northeurope'
  AzureChinaCloud: 'chinaeast2'
  AzureUSGovernment: 'usgovvirginia'
}

// Used to identify template variables used in the templates for replacement.
var templateVars = {
  scope: '/providers/Microsoft.Management/managementGroups/contoso'
  defaultDeploymentLocation: '"location": "northeurope"'
  localizedDeploymentLocation: '"location": "${defaultDeploymentLocationByCloudType[cloudEnv]}"'
}

var targetDeploymentLocationByCloudType = {
  AzureCloud: location ?? 'northeurope'
  AzureChinaCloud: location ?? 'chinaeast2'
  AzureUSGovernment: location ?? 'usgovvirginia'
}

var deploymentLocation = '"location": "${targetDeploymentLocationByCloudType[cloudEnv]}"'

// Unable to do the following commented out approach due to the error "The value must be a compile-time constant.bicep(BCP032)"
// See: https://github.com/Azure/bicep/issues/3816#issuecomment-1191230215

// The following vars are used to load the list of Policy Definitions to import
// var listPolicyDefinitionsAll = loadJsonContent('../data/policyDefinitions.All.json')
// var listPolicyDefinitionsAzureCloud = loadJsonContent('../data/policyDefinitions.AzureCloud.json')
// var listPolicyDefinitionsAzureChinaCloud = loadJsonContent('../data/policyDefinitions.AzureChinaCloud.json')
// var listPolicyDefinitionsAzureUSGovernment = loadJsonContent('../data/policyDefinitions.AzureUSGovernment.json')

// The following vars are used to load the list of Policy Set Definitions to import
// var listPolicySetDefinitionsAll = loadJsonContent('../data/policySetDefinitions.All.json')
// var listPolicySetDefinitionsAzureCloud = loadJsonContent('../data/policySetDefinitions.AzureCloud.json')
// var listPolicySetDefinitionsAzureChinaCloud = loadJsonContent('../data/policySetDefinitions.AzureChinaCloud.json')
// var listPolicySetDefinitionsAzureUSGovernment = loadJsonContent('../data/policySetDefinitions.AzureUSGovernment.json')

// The following vars are used to load the list of Policy Definitions to import
// var loadPolicyDefinitionsAll = [for item in listPolicyDefinitionsAll: loadTextContent(item)]
// var loadPolicyDefinitionsAzureCloud = [for item in listPolicyDefinitionsAzureCloud: loadTextContent(item)]
// var loadPolicyDefinitionsAzureChinaCloud = [for item in listPolicyDefinitionsAzureChinaCloud: loadTextContent(item)]
// var loadPolicyDefinitionsAzureUSGovernment = [for item in listPolicyDefinitionsAzureUSGovernment: loadTextContent(item)]

// The following vars are used to load the list of Policy Set Definitions to import
// var loadPolicySetDefinitionsAll = [for item in listPolicySetDefinitionsAll: loadTextContent(item)]
// var loadPolicySetDefinitionsAzureCloud = [for item in listPolicySetDefinitionsAzureCloud: loadTextContent(item)]
// var loadPolicySetDefinitionsAzureChinaCloud = [for item in listPolicySetDefinitionsAzureChinaCloud: loadTextContent(item)]
// var loadPolicySetDefinitionsAzureUSGovernment = [for item in listPolicySetDefinitionsAzureUSGovernment: loadTextContent(item)]

// The following var contains lists of files containing Policy Definition resources to load, grouped by compatibility with Cloud.
// To get a full list of Azure clouds, use the az cli command "az cloud list --output table"
// We use loadTextContent instead of loadJsonContent  as this allows us to perform string replacement operations against the imported templates.
var loadPolicyDefinitions = {
  All: [
    // Add SQL Managed Instance Monitoring Policy Definitions
    loadTextContent('../../../services/Sql/managedInstances/templates/policy/avgcpupercent_dfd37715-0d5c-4ec5-98ae-836cd626a27f.json')
    loadTextContent('../../../services/Sql/managedInstances/templates/policy/storagespaceusedmb_641ca3dc-a00f-43ac-b6bd-4f5d16f35cac.json')

    // Add SQL Server Monitoring Policy definitions
    loadTextContent('../../../services/Sql/servers/templates/policy/databases-appcpupercent_05591510-5fe2-454a-96d8-bbda8201c6a4.json')
    loadTextContent('../../../services/Sql/servers/templates/policy/databases-appmemorypercent_c5c95fe9-a4b4-4afa-a07a-a0d18804d416.json')
    loadTextContent('../../../services/Sql/servers/templates/policy/databases-blockedbyfirewall_2cda2f3a-8657-431a-a50f-56835aea9a81.json')
    loadTextContent('../../../services/Sql/servers/templates/policy/databases-connectionfailed_7157dc17-9d5a-4835-a122-1d0d904d61ff.json')
    loadTextContent('../../../services/Sql/servers/templates/policy/databases-connectionfailedusererror_d528ffcb-3a99-4356-96d1-981499139ffb.json')
    loadTextContent('../../../services/Sql/servers/templates/policy/databases-connectionsuccessful_460b6b29-a602-4409-b748-6b47b232a984.json')
    loadTextContent('../../../services/Sql/servers/templates/policy/databases-cpuused_3ddd3f95-989c-4777-b6b8-728439aae1df.json')
    loadTextContent('../../../services/Sql/servers/templates/policy/databases-deadlock_ce44fc81-3610-4165-a107-9dd4b8ab3972.json')
    loadTextContent('../../../services/Sql/servers/templates/policy/databases-dtulimit_50124594-a291-4183-a8e3-195f5e6f5204.json')
    loadTextContent('../../../services/Sql/servers/templates/policy/databases-dtuused_d26f4c8b-0461-4c57-b230-cbd1a5424db1.json')
    loadTextContent('../../../services/Sql/servers/templates/policy/databases-dwuconsumptionpercent_70f88865-7a8b-4e03-9252-a9369df503ef.json')
    loadTextContent('../../../services/Sql/servers/templates/policy/databases-memoryusagepercent_f5c13b49-8528-457d-9d7d-083b8433bf96.json')
    loadTextContent('../../../services/Sql/servers/templates/policy/databases-sessionscount_07eeae07-010e-47ca-ad90-fa7adb5a6c52.json')
    loadTextContent('../../../services/Sql/servers/templates/policy/databases-sqlinstancecpupercent_1a8132b9-fbd2-4ac5-9e08-96358e16b7f7.json')
    loadTextContent('../../../services/Sql/servers/templates/policy/databases-sqlinstancememorypercent_f44a3cb0-6e99-4a5e-a691-c5d7d5bf7e64.json')
    loadTextContent('../../../services/Sql/servers/templates/policy/databases-storage_86922a27-41bb-4834-bc54-0b602b275597.json')
    loadTextContent('../../../services/Sql/servers/templates/policy/databases-tempdbdatasize_0fe27fd1-e4f7-48c1-bbd2-a6953755d5e8.json')
    loadTextContent('../../../services/Sql/servers/templates/policy/elasticpools-allocateddatastorage_3743016a-a056-43fe-b53a-36dd9a17626d.json')
    loadTextContent('../../../services/Sql/servers/templates/policy/elasticpools-allocateddatastoragepercent_7e9d0710-3243-4cf2-8b73-6be1539b8545.json')
    loadTextContent('../../../services/Sql/servers/templates/policy/elasticpools-cpupercent_805c4ae5-a852-43bd-ad1c-0f7f381d8f32.json')
    loadTextContent('../../../services/Sql/servers/templates/policy/elasticpools-dtuconsumptionpercent_5d9075b5-3c19-4cf6-9c2e-50ba4c175691.json')
    loadTextContent('../../../services/Sql/servers/templates/policy/elasticpools-eDTUused_16a64053-1905-4d8e-8198-810584cad108.json')
    loadTextContent('../../../services/Sql/servers/templates/policy/elasticpools-logwritepercent_47cd814e-1991-437e-8feb-e589a250d2a3.json')
    loadTextContent('../../../services/Sql/servers/templates/policy/elasticpools-physicaldatareadpercent_92efc2ea-b6ed-41aa-921c-6d40e7b58c27.json')
    loadTextContent('../../../services/Sql/servers/templates/policy/elasticpools-sessionspercent_6b2e0ce9-d1b8-4061-b3ce-c39f9c5c1763.json')
    loadTextContent('../../../services/Sql/servers/templates/policy/elasticpools-sqlserverprocesscorepercent_73ec4301-872a-4bea-928e-420255aae8cb.json')
    loadTextContent('../../../services/Sql/servers/templates/policy/elasticpools-sqlserverprocessmemorypercent_fa056aaf-57c4-4abe-9bc5-23ba413a1f5b.json')
    loadTextContent('../../../services/Sql/servers/templates/policy/elasticpools-storagepercent_88f3cbc0-bcfb-482f-b6f4-709a335afcad.json')
    loadTextContent('../../../services/Sql/servers/templates/policy/elasticpools-tempdblogusedpercent_af66de51-079c-4d34-af92-f52f887642dc.json')
    loadTextContent('../../../services/Sql/servers/templates/policy/elasticpools-workerspercent_1b37038e-6e5c-4463-97d4-8a632251d70e.json')
    loadTextContent('../../../services/Sql/servers/templates/policy/elasticpools-xtpstoragepercent_db517009-30ad-4cbc-b282-7f212052c3b4.json')
    
  ]
  AzureCloud: []
  AzureChinaCloud: []
  AzureUSGovernment: []
}

// The following var contains lists of files containing Policy Set Definition (Initiative) resources to load, grouped by compatibility with Cloud.
// To get a full list of Azure clouds, use the az cli command "az cloud list --output table"
// We use loadTextContent instead of loadJsonContent as this allows us to perform string replacement operations against the imported templates.
// Use string(loadJsonContent('../file.json')) when the JSON has more than 131072 characters
var loadPolicySetDefinitions = {
  All: [
    // Both SQL Server Monitoring Policy definitions and SQL Managed Instance Monitoring Policy Definitions are in this Policy Set Definition
    string(loadJsonContent('../policySetDefinitions/Deploy-SQL-Alerts.json'))
  ]
  AzureCloud: []
  AzureChinaCloud: []
  AzureUSGovernment: []
}

// The following vars are used to manipulate the imported Policy Definitions to replace deployment location values
// Needs a double replace to handle updates in both templates for All clouds, and localized templates
var processPolicyDefinitionsAll = [for content in loadPolicyDefinitions.All: replace(replace(content, templateVars.defaultDeploymentLocation, deploymentLocation), templateVars.localizedDeploymentLocation, deploymentLocation)]
var processPolicyDefinitionsAzureCloud = [for content in loadPolicyDefinitions.AzureCloud: replace(replace(content, templateVars.defaultDeploymentLocation, deploymentLocation), templateVars.localizedDeploymentLocation, deploymentLocation)]
var processPolicyDefinitionsAzureChinaCloud = [for content in loadPolicyDefinitions.AzureChinaCloud: replace(replace(content, templateVars.defaultDeploymentLocation, deploymentLocation), templateVars.localizedDeploymentLocation, deploymentLocation)]
var processPolicyDefinitionsAzureUSGovernment = [for content in loadPolicyDefinitions.AzureUSGovernment: replace(replace(content, templateVars.defaultDeploymentLocation, deploymentLocation), templateVars.localizedDeploymentLocation, deploymentLocation)]

// The following vars are used to manipulate the imported Policy Set Definitions to replace Policy Definition scope values
var processPolicySetDefinitionsAll = [for content in loadPolicySetDefinitions.All: replace(content, templateVars.scope, scope)]
var processPolicySetDefinitionsAzureCloud = [for content in loadPolicySetDefinitions.AzureCloud: replace(content, templateVars.scope, scope)]
var processPolicySetDefinitionsAzureChinaCloud = [for content in loadPolicySetDefinitions.AzureChinaCloud: replace(content, templateVars.scope, scope)]
var processPolicySetDefinitionsAzureUSGovernment = [for content in loadPolicySetDefinitions.AzureUSGovernment: replace(content, templateVars.scope, scope)]

// The following vars are used to convert the imported Policy Definitions into objects from JSON
var policyDefinitionsAll = [for content in processPolicyDefinitionsAll: json(content)]
var policyDefinitionsAzureCloud = [for content in processPolicyDefinitionsAzureCloud: json(content)]
var policyDefinitionsAzureChinaCloud = [for content in processPolicyDefinitionsAzureChinaCloud: json(content)]
var policyDefinitionsAzureUSGovernment = [for content in processPolicyDefinitionsAzureUSGovernment: json(content)]

// The following vars are used to convert the imported Policy Set Definitions into objects from JSON
var policySetDefinitionsAll = [for content in processPolicySetDefinitionsAll: json(content)]
var policySetDefinitionsAzureCloud = [for content in processPolicySetDefinitionsAzureCloud: json(content)]
var policySetDefinitionsAzureChinaCloud = [for content in processPolicySetDefinitionsAzureChinaCloud: json(content)]
var policySetDefinitionsAzureUSGovernment = [for content in processPolicySetDefinitionsAzureUSGovernment: json(content)]

// The following var is used to compile the required Policy Definitions into a single object
var policyDefinitionsByCloudType = {
  All: policyDefinitionsAll
  AzureCloud: policyDefinitionsAzureCloud
  AzureChinaCloud: policyDefinitionsAzureChinaCloud
  AzureUSGovernment: policyDefinitionsAzureUSGovernment
}

// The following var is used to compile the required Policy Definitions into a single object
var policySetDefinitionsByCloudType = {
  All: policySetDefinitionsAll
  AzureCloud: policySetDefinitionsAzureCloud
  AzureChinaCloud: policySetDefinitionsAzureChinaCloud
  AzureUSGovernment: policySetDefinitionsAzureUSGovernment
}

// The following var is used to extract the Policy Definitions into a single list for deployment
// This will contain all policy definitions classified as available for All cloud environments, and those for the current cloud environment
var policyDefinitions = concat(policyDefinitionsByCloudType.All, policyDefinitionsByCloudType[cloudEnv])

// The following var is used to extract the Policy Set Definitions into a single list for deployment
// This will contain all policy set definitions classified as available for All cloud environments, and those for the current cloud environment
var policySetDefinitions = concat(policySetDefinitionsByCloudType.All, policySetDefinitionsByCloudType[cloudEnv])

// Create the Policy Definitions as needed for the target cloud environment
resource PolicyDefinitions 'Microsoft.Authorization/policyDefinitions@2020-09-01' = [for policy in policyDefinitions: {
  name: policy.name
  properties: {
    description: policy.properties.description
    displayName: policy.properties.displayName
    metadata: policy.properties.metadata
    mode: policy.properties.mode
    parameters: policy.properties.parameters
    policyType: policy.properties.policyType
    policyRule: policy.properties.policyRule
  }
}]

// Create the Policy Definitions as needed for the target cloud environment
// Depends on Policy Definitons to ensure they exist before creating dependent Policy Set Definitions (Initiatives)
resource PolicySetDefinitions 'Microsoft.Authorization/policySetDefinitions@2020-09-01' = [for policy in policySetDefinitions: {
  dependsOn: [
    PolicyDefinitions
  ]
  name: policy.name
  properties: {
    description: policy.properties.description
    displayName: policy.properties.displayName
    metadata: policy.properties.metadata
    parameters: policy.properties.parameters
    policyType: policy.properties.policyType
    policyDefinitions: policy.properties.policyDefinitions
    policyDefinitionGroups: policy.properties.policyDefinitionGroups
  }
}]

output policyDefinitionNames array = [for policy in policyDefinitions: policy.name]
output policySetDefinitionNames array = [for policy in policySetDefinitions: policy.name]
