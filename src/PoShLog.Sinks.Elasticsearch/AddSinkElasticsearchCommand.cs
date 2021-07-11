using System;
using System.Management.Automation;
using System.Management.Automation.Runspaces;
using Serilog;
using Serilog.Sinks.Elasticsearch;

namespace PoShLog.Sinks.Elasticsearch
{
    [Cmdlet(VerbsCommon.Add, "SinkElasticsearch")]
    [OutputType(typeof(LoggerConfiguration))]
    public class AddSinkElasticsearchCommand : PSCmdlet
    {
        [Parameter(
            Mandatory = true,
            Position = 0,
            ValueFromPipeline = true,
            ValueFromPipelineByPropertyName = true)]
        public LoggerConfiguration LoggerConfig { get; set; }

        [Parameter()] public Uri Uri { get; set; }
        [Parameter()] public SwitchParameter AutoRegisterTemplate { get; set; }
        [Parameter()] public AutoRegisterTemplateVersion AutoRegisterTemplateVersion { get; set; }
        [Parameter()] public string IndexFormat { get; set; }
        [Parameter()] public SwitchParameter SkipServerCertificateCheck { get; set; }

        // [Parameter(
        //     Position = 1,
        //     ValueFromPipelineByPropertyName = true)]
        // [ValidateSet("Cat", "Dog", "Horse")]
        // public string FavoritePet { get; set; } = "Dog";


        protected override void EndProcessing()
        {
            var sinkoptions = new ElasticsearchSinkOptions(Uri)
            {
                AutoRegisterTemplate = AutoRegisterTemplate.IsPresent,
                AutoRegisterTemplateVersion = AutoRegisterTemplateVersion,
                IndexFormat = IndexFormat
            };
            if (SkipServerCertificateCheck.IsPresent)
            {
                sinkoptions.ModifyConnectionSettings = config =>
                    config.ServerCertificateValidationCallback((o, cert, chain, errors) => true);
            }

            WriteObject(LoggerConfig.WriteTo.Elasticsearch(sinkoptions));
        }
    }
}
