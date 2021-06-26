function Add-SinkElasticsearch {
	<#
	.SYNOPSIS
		Writes log events into Elasticsearch
	.DESCRIPTION
		Writes log events into Elasticsearch
	.PARAMETER LoggerConfig
		Instance of LoggerConfiguration
	.PARAMETER AutoRegisterTemplate
		When set to $true the sink will register an index template for the logs in elasticsearch.
		This template is optimized to deal with serilog events
	.PARAMETER AutoRegisterTemplateVersion
		When using the AutoRegisterTemplate feature, this allows to set the Elasticsearch version. Depending on the
		version, a template will be selected. Defaults to pre 5.0.
	.INPUTS
		Instance of LoggerConfiguration
	.OUTPUTS
		LoggerConfiguration object allowing method chaining
	.EXAMPLE
		PS> New-Logger | Add-SinkElasticsearch -Uri 'http://elasticsearch:9200 | Start-Logger
	#>

	[Cmdletbinding()]
	param(
		[Parameter(Mandatory, ValueFromPipeline)]
		[Serilog.LoggerConfiguration]$LoggerConfig,

		[Parameter(Mandatory)]
		[Uri[]]$Uri,

		[bool]$AutoRegisterTemplate = $false,
		[Serilog.Sinks.Elasticsearch.AutoRegisterTemplateVersion]$AutoRegisterTemplateVersion
	)

	$sinkOptions = [Serilog.Sinks.Elasticsearch.ElasticsearchSinkOptions]::new($Uri)
	$sinkOptions.AutoRegisterTemplate = $AutoRegisterTemplate
	$sinkOptions.AutoRegisterTemplateVersion = $AutoRegisterTemplateVersion

	[Serilog.LoggerConfigurationElasticsearchExtensions]::Elasticsearch($LoggerConfig.WriteTo, $sinkOptions);
}
