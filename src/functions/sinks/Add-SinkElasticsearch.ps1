function Add-SinkElasticsearch {
	<#
	.SYNOPSIS
		Writes log events into seq
	.DESCRIPTION
		Writes log events into seq server
	.PARAMETER LoggerConfig
		Instance of LoggerConfiguration
	.PARAMETER TODOParamName
		TODO ParamDescription
	.INPUTS
		Instance of LoggerConfiguration
	.OUTPUTS
		LoggerConfiguration object allowing method chaining
	.EXAMPLE
		PS> New-Logger | Add-SinkElasticsearch TODO FILL_HERE | Start-Logger
	#>

	[Cmdletbinding()]
	param(
		[Parameter(Mandatory = $true, ValueFromPipeline = $true)]
		[Serilog.LoggerConfiguration]$LoggerConfig,

		[Parameter(Mandatory = $true)]
		[string]$TODOParamName
	)

	# CALL C# method here
	# Example: $LoggerConfig = [Serilog.SeqLoggerConfigurationExtensions]::Seq($LoggerConfig.WriteTo, ...)

	$LoggerConfig
}
