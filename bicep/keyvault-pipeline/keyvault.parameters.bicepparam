{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "keyVaultName": {
      "value": "kv-myproject-#{Environment}#-001"
    },
    "skuName": {
      "value": "standard"
    },
    "enableSoftDelete": {
      "value": true
    },
    "softDeleteRetentionInDays": {
      "value": 90
    },
    "enablePurgeProtection": {
      "value": true
    },
    "administratorObjectIds": {
      "value": [
        "#{AdminObjectId}#"
      ]
    },
    "accessPolicies": {
      "value": [
        {
          "objectId": "#{ServicePrincipalObjectId}#",
          "secretPermissions": [
            "Get",
            "List"
          ],
          "keyPermissions": [],
          "certificatePermissions": []
        }
      ]
    }
  }
}
