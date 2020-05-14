function Get-GroupAssociationChange
{
    param (
        $assocEvent
    )

    $associationChangeEvent = $assocEvent
    $groupType = $associationChangeEvent.association.connection.from.type
    $groupId = $associationChangeEvent.association.connection.from.object_id
    $targetType = $associationChangeEvent.association.connection.to.type
    $targetId = $associationChangeEvent.association.connection.to.object_id
    $operation = $associationChangeEvent.association.op
    $timestamp = $associationChangeEvent.timestamp
    # Set operation syntax
    if ($operation -eq "add") {
        $operation = "added to"
    } elseif ($operation -eq "remove") {
        $operation = "removed from"
    }

     # Set Group Name
    if ($groupType -eq "USER_GROUP") {
        $groupName = (Get-JCGroup -Type User | Where-Object { $_.id -eq $groupId }).name
    } elseif ($groupType -eq "SYSTEM_GROUP") {
        $groupName = (Get-JCGroup -Type System | Where-Object { $_.id -eq $groupId }).name
    }

    # Set Target Name
    if ($targetType -eq "SYSTEM") {
        $targetName = (Get-JCSystem -id $targetId).displayName
    } elseif ($targetType -eq "USER") {
        $targetName  = (Get-JCUser -id $targetId).username
    } elseif ($targetType -eq "APPLICATION") {
        $iwrParams = @{
            'Uri'                   = "https://console.jumpcloud.com/api/applications/$($targetId)"
            'Method'                = 'GET'
            'ContentType'           = 'application/json'
            'Headers'               = @{
                'x-api-key'   = $JCAPIKEY
            }
            'UseBasicParsing'       = $true
        }
        $response = Invoke-WebRequest @iwrParams
        $content = $response.content | ConvertFrom-json
        $targetName = $content.displayName
    } elseif ($targetType -eq "LDAP_SERVER") {
        $targetName = "LDAP"
    } elseif ($targetType -eq "G_SUITE") {
        $targetName = "G Suite"
    } elseif ($targetType -eq "OFFICE_365") {
        $targetName = "Office 365"
    } elseif ($targetType -eq "SYSTEM_GROUP") {
        $targetName = (Get-JCGroup -Type System | Where-Object { $_.id -eq $targetId }).name
    }

    if (!$targetName) {
        $targetName = "[DELETED]"
    }

    [PSCustomObject]@{
       TargetType = $targetType;
        TargetName = $targetName;
        Action = $operation;
        GroupName = $groupName;
        Timestamp = $timestamp
    }
}