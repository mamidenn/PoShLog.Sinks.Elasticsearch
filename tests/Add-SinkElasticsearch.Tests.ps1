BeforeAll {
    Import-Module $PSScriptRoot/../dist/PoShLog.Sinks.Elasticsearch -Force
}
Describe 'Add-SinkElasticsearch' {
    It 'Adds an elasticsearch sink, that can be successfully written to' {
        [Serilog.Debugging.SelfLog]::Enable([System.Console]::Error)
        New-Logger |
            Add-SinkElasticsearch `
                -Uri 'https://elasticsearch:9200' `
                -AutoRegisterTemplate `
                -AutoRegisterTemplateVersion ESv7 `
                -IndexFormat 'pester' `
                -SkipServerCertificateCheck |
            Start-Logger

        $guid = New-Guid
        Write-InformationLog '{level} message for test {guid}' -PropertyValues 'Information', $guid

        Close-Logger
        Start-Sleep 5 # ouchi!

        $response = Invoke-WebRequest -SkipCertificateCheck -Uri "https://elasticsearch:9200/pester/_search?q=fields.guid:'$guid'"
        ($response.Content | ConvertFrom-Json).hits.total.value | Should -Be 1
    }
}
