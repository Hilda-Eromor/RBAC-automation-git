# RBAC Automation Project
# RBAC Automation

This repository contains scripts and a GitHub Actions workflow to automate
Azure Role-Based Access Control (RBAC) setup and cleanup.

## Contents
- **setup.sh**: Creates test users, adds them to groups, assigns roles.
- **cleanup.sh**: Revokes roles, removes users from groups, deletes test accounts.
- **rbac.yml**: GitHub Actions pipeline that runs setup → test → cleanup.

## Usage
1. Configure Azure service principal credentials in GitHub Secrets (`AZURE_CREDENTIALS`).
2. Trigger the workflow from the Actions tab.
3. The pipeline will:
   - Provision RBAC test environment.
   - Run validation tests.
   - Automatically clean up resources.
