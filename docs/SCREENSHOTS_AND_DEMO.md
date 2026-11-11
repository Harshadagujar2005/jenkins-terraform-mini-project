# Screenshots checklist (submit these)
1. GitHub repo showing `Jenkinsfile`, `terraform/`, `Dockerfile`, `server.js`
2. Jenkins job configuration page (Pipeline script from SCM, repo URL, branch, Script Path)
3. Jenkins **Stage View / Pipeline Overview** with all stages green
4. **Console Output**: Checkout (git clone) section
5. Console Output: `npm test` results (2 passing)
6. Console Output: `docker build` finishing
7. Console Output: AWS `terraform init` and `terraform plan` ("Plan: 3 to add...")
7b. Console Output: Docker `terraform init`, `plan`, `apply` ("Apply complete! Resources: 1 added")
8. Console Output: "Deployment verified." and "Finished: SUCCESS"
9. Browser at http://localhost:3000
10. Terminal: `docker ps` showing `mini-app`
11. Terminal: `terraform state list` and `terraform output`
12. Second build after a code change (build #2 green, page updated)

# Demo video script (about 5 to 7 minutes; screen + voice, e.g. Zoom/Teams/OBS)
1. **Intro (30s):** Name, project goal: automate build, test and deploy with Jenkins; provision infrastructure with Terraform.
2. **Repo tour (1 min):** Show `server.js`, `test/`, `Dockerfile`, `Jenkinsfile`, `terraform/`.
3. **Jenkinsfile (1.5 min):** Explain each stage: Checkout (pull from Git), Install, Test (fail stops the pipeline), Build image, Terraform init/validate/plan, Deploy via apply, Verify with health check.
4. **Terraform (2 min):** Explain Infrastructure as Code. Show `terraform/aws` (S3 bucket, security group, EC2; plan only without an AWS account, or real apply if you have one) and `terraform/docker` (real apply). Explain `variables.tf`, `outputs.tf`, the reusable module, and what `init / plan / apply / destroy` do. Mention the state file.
5. **Live run (1.5 min):** Click Build Now, show stages going green, open http://localhost:3000.
6. **Change and redeploy (1 min):** Edit message, push, rebuild, refresh page.
7. **Wrap-up (30s):** Show `docker ps` and `terraform state list`. Mention benefits: automation, repeatability, Infrastructure as Code.

## Questions you may be asked
- *CI vs CD?* CI = automatically integrate, build and test every change. CD = automatically deploy it.
- *Why Terraform?* Infrastructure defined in code: versioned, repeatable, reviewable.
- *What does `plan` do?* Previews changes without applying them.
- *What is the state file?* Terraform's record of the real resources it manages.
- *Why does the image tag use the build number?* A new tag forces Terraform to replace the container with the new version.
