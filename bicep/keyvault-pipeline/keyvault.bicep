@description('The name of the Key Vault')
param keyVaultName string

@description('The Azure region where the Key Vault should be deployed')
param location string = resourceGroup().location

@description('The SKU name for the Key Vault')
@allowed([
  'standard'
  'premium'
])
param skuName string = 'standard'

@description('Enable soft delete for the Key Vault')
param enableSoftDelete bool = true

@description('Soft delete retention period in days')
param softDeleteRetentionInDays int = 90

@description('Enable purge protection')
param enablePurgeProtection bool = true

@description('Array of object IDs that are granted permission to manage the Key Vault')
param administratorObjectIds array = []

@description('Access policies for the Key Vault')
param accessPolicies array = []

resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: keyVaultName
  location: location
  properties: {
    enabledForDeployment: true
    enabledForTemplateDeployment: true
    enabledForDiskEncryption: true
    enableSoftDelete: enableSoftDelete
    softDeleteRetentionInDays: softDeleteRetentionInDays
    enablePurgeProtection: enablePurgeProtection ? true : null
    tenantId: subscription().tenantId
    sku: {
      name: skuName
      family: 'A'
    }
    accessPolicies: [for policy in accessPolicies: {
      tenantId: subscription().tenantId
      objectId: policy.objectId
      permissions: {
        keys: contains(policy, 'keyPermissions') ? policy.keyPermissions : []
        secrets: contains(policy, 'secretPermissions') ? policy.secretPermissions : []
        certificates: contains(policy, 'certificatePermissions') ? policy.certificatePermissions : []
        storage: contains(policy, 'storagePermissions') ? policy.storagePermissions : []
      }
    }]
  }
}

// Create default access policies for administrators
resource adminAccessPolicies 'Microsoft.KeyVault/vaults/accessPolicies@2023-07-01' = if (!empty(administratorObjectIds)) {
  name: 'add'
  parent: keyVault
  properties: {
    accessPolicies: [for adminId in administratorObjectIds: {
      tenantId: subscription().tenantId
      objectId: adminId
      permissions: {
        keys: ['Get', 'List', 'Update', 'Create', 'Import', 'Delete', 'Recover', 'Backup', 'Restore']
        secrets: ['Get', 'List', 'Set', 'Delete', 'Recover', 'Backup', 'Restore']
        certificates: ['Get', 'List', 'Update', 'Create', 'Import', 'Delete', 'Recover', 'Backup', 'Restore']
      }
    }]
  }
}

@description('The resource ID of the Key Vault')
output keyVaultId string = keyVault.id

@description('The name of the Key Vault')
output keyVaultName string = keyVault.name

@description('The URI of the Key Vault')
output keyVaultUri string = keyVault.properties.vaultUri
