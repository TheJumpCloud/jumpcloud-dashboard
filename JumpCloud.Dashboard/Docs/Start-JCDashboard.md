---
external help file: JumpCloud.Dashboard-help.xml
Module Name: JumpCloud.Dashboard
online version: https://github.com/TheJumpCloud/jumpcloud-dashboard/wiki/Start-JCDashboard
schema: 2.0.0
---

# Start-JCDashboard

## SYNOPSIS

## SYNTAX

```
Start-JCDashboard [[-JumpCloudApiKey] <String>] [[-LastContactDays] <Int32>] [[-RefreshInterval] <Int32>]
 [-NoUpdate] [<CommonParameters>]
```

## DESCRIPTION
Used to start the JumpCloud Dashboard instance.

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -JumpCloudApiKey
Please enter your JumpCloud API key.
This can be found in the JumpCloud admin console within "API Settings" accessible from the drop down icon next to the admin email address in the top right corner of the JumpCloud admin console.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -LastContactDays
Include systems that have contacted the JumpCloud directory within this number of days

```yaml
Type: System.Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -RefreshInterval
Refresh the components on the dashboard measured in seconds

```yaml
Type: System.Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -NoUpdate
\[Switch\]$Beta,

```yaml
Type: System.Management.Automation.SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
