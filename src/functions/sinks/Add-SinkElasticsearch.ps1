function Add-SinkElasticsearch {
	<#
	.SYNOPSIS
		Writes log events into Elasticsearch
	.DESCRIPTION
		Writes log events into Elasticsearch
	.PARAMETER LoggerConfig
		Instance of LoggerConfiguration
	.PARAMETER Uri
		The nodes to write to
	.PARAMETER AutoRegisterTemplate
		When set to $true the sink will register an index template for the logs in elasticsearch.
		This template is optimized to deal with serilog events
	.PARAMETER AutoRegisterTemplateVersion
		When using the AutoRegisterTemplate feature, this allows to set the Elasticsearch version. Depending on the
		version, a template will be selected. Defaults to pre 5.0.
	.PARAMETER RegisterTemplateFailure
		Specifies the option on how to handle failures when writing the template to Elasticsearch. This is only applicable when using the AutoRegisterTemplate option.
	.PARAMETER TemplateName
		When using the AutoRegisterTemplate feature this allows you to override the default template name.
		Defaults to: serilog-events-template
	.PARAMETER GetTemplateContent
		When using the AutoRegisterTemplate feature, this allows you to override the default template content.
		If not provided, a default template that is optimized to deal with Serilog events is used.
	.PARAMETER TemplateCustomSettings
		When using the AutoRegisterTemplate feature, this allows you to override the default template content.
		If not provided, a default template that is optimized to deal with Serilog events is used.
	.PARAMETER OverwriteTemplate
		When using the AutoRegisterTemplate feature, this allows you to overwrite the template in Elasticsearch if it already exists.
	.PARAMETER NumberOfShards
		When using the AutoRegisterTemplate feature, this allows you to override the default number of shards.
		If not provided, this will default to the default number_of_shards configured in Elasticsearch.
	.PARAMETER NumberOfReplicas
		When using the AutoRegisterTemplate feature, this allows you to override the default number of replicas.
		If not provided, this will default to the default number_of_replicas configured in Elasticsearch.
	.PARAMETER IndexAliases
		Index aliases. Sets alias/aliases to an index in elasticsearch.
		Tested and works with ElasticSearch 7.x
		When using the AutoRegisterTemplate feature, this allows you to set index aliases.
		If not provided, index aliases will be blank.
	.PARAMETER IndexFormat
		The index name formatter. A string.Format using the DateTimeOffset of the event is run over this string.
		defaults to "logstash-{0:yyyy.MM.dd}"
		Needs to be lowercased.
	.PARAMETER DeadLetterIndexName
		Optionally set this value to the name of the index that should be used when the template cannot be written to ES.
		defaults to "deadletter-{0:yyyy.MM.dd}"
	.PARAMETER TypeName
		The default elasticsearch type name to use for the log events. Defaults to: logevent.
	.INPUTS
		Instance of LoggerConfiguration
	.OUTPUTS
		LoggerConfiguration object allowing method chaining
	.EXAMPLE
		New-Logger | Add-SinkElasticsearch -Uri 'http://elasticsearch:9200 | Start-Logger
	.EXAMPLE
		New-Logger |
			Add-SinkElasticsearch -Uri 'http://elasticsearch:9200 -AutoRegisterTemplate -AutoRegisterTemplateVersion ESv7 |
			Start-Logger
	#>

	[Cmdletbinding(DefaultParametersetName = 'None')]
	param(
		[Parameter(Mandatory, ValueFromPipeline)]
		[Serilog.LoggerConfiguration]$LoggerConfig,

		[Parameter(Mandatory, Position = 0)]
		[Uri[]]$Uri,

		[Parameter(ParameterSetName = 'AutoRegisterTemplate', Mandatory)]
		[switch]$AutoRegisterTemplate,

		[Parameter(ParameterSetName = 'AutoRegisterTemplate')]
		[Serilog.Sinks.Elasticsearch.AutoRegisterTemplateVersion]$AutoRegisterTemplateVersion,

		[Parameter(ParameterSetName = 'AutoRegisterTemplate')]
		[Serilog.Sinks.Elasticsearch.RegisterTemplateRecovery]$RegisterTemplateFailure = 'IndexAnyway',

		[Parameter(ParameterSetName = 'AutoRegisterTemplate')]
		[string]$TemplateName = 'serilog-events-template',

		[Parameter(ParameterSetName = 'AutoRegisterTemplate')]
		[Func[object]]$GetTemplateContent,

		[Parameter(ParameterSetName = 'AutoRegisterTemplate')]
		[System.Collections.Generic.Dictionary[string, string]]$TemplateCustomSettings,

		[Parameter(ParameterSetName = 'AutoRegisterTemplate')]
		[switch]$OverwriteTemplate,

		[Parameter(ParameterSetName = 'AutoRegisterTemplate')]
		[AllowNull()]
		[Nullable[int]]$NumberOfShards,

		[Parameter(ParameterSetName = 'AutoRegisterTemplate')]
		[AllowNull()]
		[Nullable[int]]$NumberOfReplicas,

		[Parameter(ParameterSetName = 'AutoRegisterTemplate')]
		[string[]]$IndexAliases,

		[string]$IndexFormat = 'logstash-{0:yyyy.MM.dd}',
		[string]$DeadLetterIndexName = 'deadletter-{0:yyyy.MM.dd}',
		[string]$TypeName = 'logevent'
	)

	$sinkOptions = [Serilog.Sinks.Elasticsearch.ElasticsearchSinkOptions]::new($Uri)

	$sinkOptions.AutoRegisterTemplate = $AutoRegisterTemplate
	if ($AutoRegisterTemplateVersion) { $sinkOptions.AutoRegisterTemplateVersion = $AutoRegisterTemplateVersion }
	$sinkOptions.RegisterTemplateFailure = $RegisterTemplateFailure
	$sinkOptions.TemplateName = $TemplateName
	$sinkOptions.GetTemplateContent = $GetTemplateContent
	$sinkOptions.TemplateCustomSettings = $TemplateCustomSettings
	$sinkOptions.OverwriteTemplate = $OverwriteTemplate
	$sinkOptions.NumberOfShards = $NumberOfShards
	$sinkOptions.NumberOfReplicas = $NumberOfReplicas
	$sinkOptions.IndexAliases = $IndexAliases

	$sinkOptions.IndexFormat = $IndexFormat
	$sinkOptions.DeadLetterIndexName = $DeadLetterIndexName,
	$sinkOptions.TypeName = $TypeName

	[Serilog.LoggerConfigurationElasticsearchExtensions]::Elasticsearch($LoggerConfig.WriteTo, $sinkOptions);
}
