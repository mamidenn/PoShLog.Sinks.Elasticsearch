task Test Build, {
	$result = Invoke-Pester ./tests -PassThru
	if ($result.FailedCount -gt 0) {
		throw 'Pester tests failed'
	}
}

task Build {
	exec { dotnet publish --nologo -v n -c Release -o ./dist/lib ./src/PoShLog.Sinks.Elasticsearch }
	Copy-Item ./src/PoShLog.Sinks.Elasticsearch.psd1 ./dist
}

task PublishModule {
	$params = @{
		Path = ./dist 
		NuGetApiKey = $env:psgalleryapikey
		ErrorAction = 'Stop'
	}
	Publish-Module @params
}

task Clean {
	remove dist
}

task . Test
