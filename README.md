# Azure Timer Functions For Starting/Stopping Stream Analytics Jobs

## Usage

1. Create Resource Group
1. Create Function for this timer triggerr under the Resource Group
1. Create System-assigned Managed Identity for the Function
1. Add SUBSCRIPTION_ID and TARGET_SA_NAMES_WITH_RG into application setting for the Function(further details belows)
1. Attach appropriate role for Stream Analytics Jobs that you want to start/stop them using this timer trigger to the Managed Identity
1. Update schedule value in function.json to configure when the timer trigger is invoked(You need to set as UTC timezone)
1. Deploy the timer trigger into the Function
1. Done!

## Applcation Setting for the Function

| Name                    | Value                                                                                                                               |
| ----------------------- | ----------------------------------------------------------------------------------------------------------------------------------- |
| SUBSCRIPTION_ID         | Your Subscription ID                                                                                                                |
| TARGET_SA_NAMES_WITH_RG | (Resource Group where the Stream Analytics Job is belonging to)/(Stream Analytics Job Name which you want to start/stop using this trigger) |
|                         |                                                                                                                                     |

You can set multiple resource groups and multiple stream analytics jobs like the following.  
'/' is used as a separator to identify resouce group and stream analytics job.  
',' is used as a separator to identify a conbination of resource group and stream analytics job.

```cmd
resource-group-1/streamJob1,resource-group-2/streamJob2
```

## deployFunctions shell

### Prerequisites

If you have the following, you can use deploymentFunctions shell to deploy this timer trigger.

1. bash
1. Azure CLI
1. Yarn
1. Functions Core Tools

### Usage

1. Open deploymentFunctions shell and update RESOURCE_SUFFIX and TARGET_SA_NAMES_WITH_RG appropriately.
1. Login to Azure using Azure CLI
1. Execute the shell
1. Attach appropriate role for Stream Analytics Jobs that you want to start/stop them using this timer trigger to the Managed Identity

