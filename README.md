# PoShLog.Sinks.Elasticsearch

[![Version](https://img.shields.io/powershellgallery/v/poshlog.sinks.Elasticsearch.svg)](https://www.powershellgallery.com/packages/PoShLog.Sinks.Elasticsearch)
[![Platform](https://img.shields.io/powershellgallery/p/poshlog.sinks.Elasticsearch?color=blue)](https://www.powershellgallery.com/packages/PoShLog.Sinks.Elasticsearch)
[![Downloads](https://img.shields.io/powershellgallery/dt/PoShLog.Sinks.Elasticsearch.svg)](https://www.powershellgallery.com/packages/PoShLog.Sinks.Elasticsearch)
[![Discord](https://img.shields.io/discord/693754316305072199?color=orange&labe=discord)](https://discord.gg/gGFtbf)

PoShLog.Sinks.Elasticsearch is an extension module for the [PoShLog](https://github.com/PoShLog/PoShLog) logging module. It contains a sink that publishes log messages to Elasticsearch.

## Getting started

If you are familiar with PowerShell, skip to the [Installation](#installation) section. For more detailed installation instructions check out [Getting started](https://github.com/PoShLog/PoShLog/wiki/Getting-started) in the PoShLog wiki.

### Installation

To install PoShLog.Sinks.Elasticsearch, run the following snippet from Powershell:

```ps1
Install-Module -Name PoShLog.Sinks.Elasticsearch
```

## Usage

```ps1
Import-Module PoShLog
Import-Module PoShLog.Sinks.Elasticsearch

New-Logger |
    Add-SinkElasticsearch `
        -Uri 'http://elasticsearch:9200' `
        -AutoRegisterTemplate `
        -AutoRegisterTemplateVersion ESv7 |
    Add-SinkConsole |
    Start-Logger

# Don't forget to close the logger
Close-Logger
```

### Documentation

These examples are just to get you started fast. For more detailed documentation please check the [PoShLog wiki](https://github.com/PoShLog/PoShLog/wiki).

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## Authors

Martin Dennhardt

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Credits

* Icon made by [Smashicons](https://smashicons.com/) from [www.flaticon.com](https://www.flaticon.com/).
