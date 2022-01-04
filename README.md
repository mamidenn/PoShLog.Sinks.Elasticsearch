# PoShLog.Sinks.Elasticsearch

[![Version](https://img.shields.io/powershellgallery/v/poshlog.sinks.Elasticsearch)](https://www.powershellgallery.com/packages/PoShLog.Sinks.Elasticsearch)

PoShLog.Sinks.Elasticsearch is an extension module for the [PoShLog](https://github.com/PoShLog/PoShLog) logging module. It contains a sink that publishes log messages to Elasticsearch.

### Installation

To install PoShLog.Sinks.Elasticsearch, run the following snippet from Powershell:

```ps1
Install-Module -Name PoShLog.Sinks.Elasticsearch -AllowPrerelease
```

## Usage

```ps1
Import-Module PoShLog
Import-Module PoShLog.Sinks.Elasticsearch

New-Logger |
    Add-SinkElasticsearch `
        -Uri 'http://elasticsearch:9200' `
        -AutoRegisterTemplate `
        -AutoRegisterTemplateVersion ESv7 `
        -IndexFormat 'logstash' |
    Add-SinkConsole |
    Start-Logger

Write-InformationLog "Hello {entity}!" -PropertyValues "World"

# Don't forget to close the logger
Close-Logger
```

For more detailed documentation on PoShLog please check the [PoShLog wiki](https://github.com/PoShLog/PoShLog/wiki).
