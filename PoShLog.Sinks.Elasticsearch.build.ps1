param (
	[ValidateSet('Debug', 'Release')]
	$Configuration = 'Debug'
)

$moduleName = 'PoShLog.Sinks.Elasticsearch'

task Test Build, {
	exec { dotnet test --nologo --no-build -v n -c $Configuration ./PoShLog.Sinks.Elasticsearch.sln }
	$result = Invoke-Pester ./tests -PassThru
	if ($result.FailedCount -gt 0) {
		throw 'Pester tests failed'
	}
}

task Build {
	exec { dotnet build --nologo -v n -c $Configuration ./PoShLog.Sinks.Elasticsearch.sln }
	exec { dotnet publish --nologo --no-build -v n -c $Configuration -o ./dist/$moduleName/lib ./src/PoShLog.Sinks.Elasticsearch }
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
} -If ($Configuration -eq 'Release')

task Clean {
	remove dist
}

task . Test
