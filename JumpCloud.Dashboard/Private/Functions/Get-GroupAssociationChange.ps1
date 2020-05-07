function Get-GroupAssociationChange
{
    param (
        $eventId
    )

    $associationChangeEvent = $Cache:DirectoryInsightsEvents | Where-Object { $_.id -eq $eventId }
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
    }

    [PSCustomObject]@{
       TargetType = $targetType;
        TargetName = $targetName;
        Action = $operation;
        GroupName = $groupName;
        Timestamp = $timestamp
    }
    #$event = "$($targetType) `"$($targetName)`" $($operation) $($groupType) `"$($groupName)`""
    #$event
}