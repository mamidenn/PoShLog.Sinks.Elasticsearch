$moduleName = 'PoShLog.Sinks.Elasticsearch'

task Test Build, {
	$result = Invoke-Pester ./tests -PassThru
	if ($result.FailedCount -gt 0) {
		throw 'Pester tests failed'
	}
}

task Build {
	exec { dotnet publish --nologo -v n -c Release -o ./dist/$moduleName/lib ./src/PoShLog.Sinks.Elasticsearch }
	Copy-Item ./src/PoShLog.Sinks.Elasticsearch.psd1 ./dist/$moduleName
}

task PublishPreCheck {
	exec { git diff-index --quiet HEAD }
	$branch = git rev-parse --abbrev-ref HEAD
	if ($branch -ne 'master') {
		throw 'I will only publish from master.'
	}
}

task Publish PublishPreCheck, Test, {
	$manifest = Test-ModuleManifest ./dist/$moduleName/$moduleName.psd1
	$version = "$($manifest.Version)"
	if ($manifest.PrivateData.PSData.Prerelease) {
		$version += "-$($manifest.PrivateData.PSData.Prerelease)"
	}
	exec { git tag $version }
	exec { git push --tags }
	$params = @{
		Path = "./dist/$moduleName" 
		NuGetApiKey = $env:psgalleryapikey
		ErrorAction = 'Stop'
	}
	Publish-Module @params
}

task Clean {
	remove dist
}

task . Test
