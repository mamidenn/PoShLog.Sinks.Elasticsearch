param (
	[Version]$ModuleVersion,
	[string]$PreRelease,
	[string]$ReleaseNotes,
	[ValidateSet('Dev', 'Prod')]
	[string]$Configuration = 'Dev'
)

$moduleName = 'PoShLog.Sinks.Elasticsearch'

Set-StrictMode -Version Latest

task Test {
	$testsDir = '.\..\tests'
	if (Test-Path $testsDir) {
		$Result = Invoke-Pester $testsDir -PassThru
		if ($Result.FailedCount -gt 0) {
			throw 'Pester tests failed'
		}
	}
	else{
		Write-Warning 'No pester tests found!'
	}
}

task BuildDependencies {
	Import-Module PoShLog.Tools
	Build-Dependencies '.\Dependencies.csproj' -ModuleDirectory $PSScriptRoot -IsExtensionModule
}

task UpdateManifest {

	$functions = @()
	Get-ChildItem -Path "$PSScriptRoot\functions" -Recurse -File -Filter '*.ps1' | ForEach-Object {
		# Export all functions except internal
		if ($_.FullName -notlike '*\internal\*') {
			$functions += $_.BaseName
		}
	}

	$manifestFile = "$PSScriptRoot\$moduleName.psd1"
	$manifest = $null
	if ($null -eq $ModuleVersion) {
		$manifest = Test-ModuleManifest -Path $manifestFile
		$ModuleVersion = $manifest.Version
	}
	Write-Output ('New Module version: {0}-{1}' -f $ModuleVersion, $PreRelease)

	if ([string]::IsNullOrEmpty($ReleaseNotes)) {
		if ($null -eq $manifest) {
			$manifest = Test-ModuleManifest -Path $manifestFile
		}

		$ReleaseNotes = "$($manifest.PrivateData.PSData.ProjectUri)/blob/master/releaseNotes/v$($ModuleVersion).md"
	}

	# Comment out Prerelease property if its empty
	if ([string]::IsNullOrEmpty($Prerelease)) {
		(Get-Content $manifestFile) -replace '[^#]\sPrerelease\s=', '# Prerelease =' | Set-Content $manifestFile
	}

	# Update module version
	Update-ModuleManifest $manifestFile -ModuleVersion $ModuleVersion -Prerelease $Prerelease -FunctionsToExport $functions -ReleaseNotes $ReleaseNotes
}

task CopyModuleFiles {

	# Copy Module Files to Output Folder
	$moduleDirectory = ".\output\$moduleName"
	if (-not (Test-Path $moduleDirectory)) {

		New-Item -Path $moduleDirectory -ItemType Directory | Out-Null
	}

	Copy-Item -Path '.\functions\' -Filter *.* -Recurse -Destination $moduleDirectory -Force

	Remove-Item -Path '.\lib\Serilog.Sinks.File.dll' -Force -ErrorAction SilentlyContinue
	Copy-Item -Path '.\lib\' -Filter *.* -Recurse -Destination $moduleDirectory -Force

	#Copy Module Manifest files
	Copy-Item -Path @(
		'.\..\README.md'
		".\$moduleName.psd1"
		".\$moduleName.psm1"
	) -Destination $moduleDirectory -Force
}

task PublishModule -If ($Configuration -eq 'Prod') {
	# Build a splat containing the required details and make sure to Stop for errors which will trigger the catch
	$params = @{
		Path        = "$PSScriptRoot\output\$moduleName"
		NuGetApiKey = $env:psgalleryapikey
		ErrorAction = 'Stop'
	}
	Publish-Module @params

	Write-Output "$moduleName successfully published to the PowerShell Gallery"
}

task Clean {
	# Clean output folder
	if ((Test-Path '.\output')) {
		Remove-Item -Path '.\output\*' -Recurse -Force
	}
}

task . Clean, Test, BuildDependencies, UpdateManifest, CopyModuleFiles, PublishModule
