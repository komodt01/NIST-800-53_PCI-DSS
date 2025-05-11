# PowerShell script to create a ZIP file for the Secure CI/CD Pipeline project

# Define paths
$projectPath = ".\my-app"  # Project directory
$outputPath = "$env:USERPROFILE\Documents\secure-cicd-pipeline.zip"  # Output ZIP file in Documents

# Ensure the project directory exists
if (-not (Test-Path $projectPath)) {
    Write-Error "Project directory $projectPath does not exist. Please ensure the 'my-app' directory is set up."
    exit 1
}

# Define files and folders to include
$itemsToInclude = @(
    "app.py",
    "requirements.txt",
    "Dockerfile",
    ".github/workflows/ci-cd.yml",
    "README.md"
)

# Verify all files exist
foreach ($item in $itemsToInclude) {
    $fullPath = Join-Path $projectPath $item
    if (-not (Test-Path $fullPath)) {
        Write-Warning "File or folder $fullPath not found. It will be skipped."
    }
}

# Create the ZIP file
try {
    Compress-Archive -Path (Join-Path $projectPath $itemsToInclude) -DestinationPath $outputPath -Force
    Write-Output "Successfully created ZIP file at $outputPath"
} catch {
    Write-Error "Failed to create ZIP file: $_"
    exit 1
}

# Verify the ZIP file exists
if (Test-Path $outputPath) {
    Write-Output "ZIP file verified: $outputPath"
} else {
    Write-Error "ZIP file creation failed. File not found at $outputPath"
    exit 1
}