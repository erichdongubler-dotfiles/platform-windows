cd $PSScriptRoot

function Install-Step {
	[CmdletBinding()]
    param (
        [ValidateNotNullOrEmpty()]
        [int]$step_number,

		[ValidateNotNullOrEmpty()]
		[string]$description,

		[scriptblock]$inner
	)

	Write-Error "Starting step ${step_number}: $description"
	$exit_code = Invoke-Command -ScriptBlock $inner
	if ($exit_code -ne 0) {
		Write-Error "fatal: Failed to execute step $step_number ($description), bailing"
		exit $exit_code
	}
	Write-Error "Successfully finished step ${step_number}: $description"
}

Install-Step 1 "install Chocolatey" {
	Start-Process powershell.exe -ArgumentList "-file","step-1-install-choco.ps1" -Wait -Verb RunAs
	return $LASTEXITCODE
}

Install-Step 2 "install ``minimal`` target" {
	choco.exe step-2-standard_minimal.config
	return $LASTEXITCODE
}

Install-Step 3 "install Capisco and import starter file" {
	# FIXME: No install yet!
	cpsc.exe import step-3-capisco-starter.toml
	return $LASTEXITCODE
}

Install-Step 4 "install preferred binaries/applications" {
	choco.exe step-4-preferred-binaries-apps.config
	return $LASTEXITCODE
}

pause
