---
external help file: JumpCloud.Dashboard-help.xml
Module Name: JumpCloud.Dashboard
online version:
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
Start-JCDashboard
```
Launches the JumpCloud Dashboard with the default settings.

### Example 2
```powershell
Start-JCDashboard -LastContactDays 30
```

Launches the JumpCloud Dashboard and only displays systems that have contacted JumpCloud in the last 30 days.

### Example 3
```powershell
Start-JCDashboard -RefreshInterval 60
```

Launches the JumpCloud Dashboard and sets the component refresh interval to 60 seconds.

## PARAMETERS

### -JumpCloudApiKey
A JumpCloud API key. This can be found in the JumpCloud admin console within "API Settings" accessible from the drop down icon next to the admin email address in the top right corner of the JumpCloud admin console.

```yaml
Type: String
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
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: 90
Accept pipeline input: False
Accept wildcard characters: False
```

### -RefreshInterval
Refresh the components on the dashboard measured in seconds

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: 30
Accept pipeline input: False
Accept wildcard characters: False
```

### -NoUpdate
Prevent the module from auto updating

```yaml
Type: SwitchParameter
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

## RELATED LINKS

[Start-JCDashboard Online Help](https://github.com/TheJumpCloud/support/wiki/Start-JCDashboard)