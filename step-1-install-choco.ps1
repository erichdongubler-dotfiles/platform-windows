#Requires -RunAsAdministrator

try {
	Get-Command choco.exe
	echo "``choco.exe`` already in PATH, success!"
} catch {
	echo "``choco.exe`` not found in PATH, installing..."
	"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))"
	$exit_code = $LASTEXITCODE
	if $exit_code -ne 0 (
		echo "Unable to install ``choco.exe``, exiting."
		exit $exit_code
	)
   	$env:PATH += ";$env:ALLUSERSPROFILE\chocolatey\bin"
}
