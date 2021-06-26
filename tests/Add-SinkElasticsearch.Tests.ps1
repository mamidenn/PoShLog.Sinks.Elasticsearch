Describe 'Add-SinkElasticsearch' {
    It 'Adds an elasticsearch sink, that can be successfully written to' {
        New-Logger |
            Add-SinkElasticsearch `
                -Uri 'http://elasticsearch:9200' `
                -AutoRegisterTemplate `
                -AutoRegisterTemplateVersion ESv7 `
                -IndexFormat 'pester' |
            Start-Logger

        $guid = New-Guid
        Write-InformationLog '{level} message for test {guid}' -PropertyValues 'Information', $guid

        Close-Logger
        Start-Sleep 1 # ouchi!

        $response = Invoke-WebRequest -Uri "http://elasticsearch:9200/pester/_search?q=fields.guid:'$guid'"
        ($response.Content | ConvertFrom-Json).hits.total.value | Should -Be 1
    }
}