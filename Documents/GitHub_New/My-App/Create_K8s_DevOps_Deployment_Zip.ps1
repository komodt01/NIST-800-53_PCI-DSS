# PowerShell script to create a ZIP file for the Kubernetes DevOps Deployment project

# Define paths
$projectPath = ".\eks-deployment"  # Project directory
$outputPath = "$env:USERPROFILE\Documents\k8s-devops-deployment.zip"  # Output ZIP file in Documents

# Ensure the project directory exists
if (-not (Test-Path $projectPath)) {
    Write-Error "Project directory $projectPath does not exist. Please ensure the 'eks-deployment' directory is set up."
    exit 1
}

# Define files to include
$itemsToInclude = @(
    "eks-cluster.tf",
    "aks-cluster.tf",
    "deployment.yaml",
    "network-policy.yaml",
    "README.md"
)

# Verify all files exist
foreach ($item in $itemsToInclude) {
    $fullPath = Join-Path $projectPath $item
    if (-not (Test-Path $fullPath)) {
        Write-Warning "File $fullPath not found. It will be skipped."
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