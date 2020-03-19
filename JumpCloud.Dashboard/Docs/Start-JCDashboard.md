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
 [[-Layout] <Object>] [[-jcDashboardAutoLaunch] <Boolean>] [-NoUpdate] [[-Port] <Int32>]
 [-IncludeComponent <Array>] [-ExcludeComponent <Array>] [-CycleInterval <Int32>] [<CommonParameters>]
```

## DESCRIPTION
Used to start the JumpCloud Dashboard instance.

## EXAMPLES

### EXAMPLE 1
```
Start-JCDashboard
```

Launches the JumpCloud Dashboard with the default settings.

### EXAMPLE 2
```
Start-JCDashboard -LastContactDays 30
```

Launches the JumpCloud Dashboard and only displays systems that have contacted JumpCloud in the last 30 days.

### EXAMPLE 3
```
Start-JCDashboard -RefreshInterval 60
```

Launches the JumpCloud Dashboard and sets the component refresh interval to 60 seconds.

### EXAMPLE 4
```
Start-JCDashboard -Layout singleComponent -CycleInterval 90
```

Launches the JumpCloud Dashboard in singleComponent view mode with all components and cycles between pages every 90 seconds

### EXAMPLE 5
```
Start-JCDashboard -Layout gridView
```

Launches the JumpCloud Dashboard in gridView view mode with all components

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

### -Layout
Specify either gridview or singleComponent to display dashboards by component individually.
GridView displays components in a single page, singleComponent displays components on individual pages, cycled by the CycleInterval parameter

```yaml
Type: System.Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: Default
Accept pipeline input: False
Accept wildcard characters: False
```

### -jcDashboardAutoLaunch
Specify $true or $false to autolaunch the Dashboard in a browser when started.

```yaml
Type: System.Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: True
Accept pipeline input: False
Accept wildcard characters: False
```

### -NoUpdate
Prevent the dashboard module from auto updating

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

### -Port
Dashboard port to launch on localhost

```yaml
Type: System.Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -CycleInterval
Cycle between pages on the dashboard measured in seconds

```yaml
Type: System.Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ExcludeComponent
Dashboard Components to exclude

```yaml
Type: System.Array
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -IncludeComponent
Dashboard Components to include

```yaml
Type: System.Array
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
