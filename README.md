# Jenkins CI/CD + Terraform Mini Project

A Node.js app that is **built, tested and deployed automatically by a Jenkins pipeline**.
Terraform is used in two ways:

- `terraform/aws/`: **AWS cloud infrastructure** (S3 bucket, security group, EC2). `init`, `validate` and `plan` run with dummy credentials, so **no AWS account is needed**. A real `apply` is optional if you have an account.
- `terraform/docker/`: a **real `terraform apply`** that deploys the app as a Docker container on your own machine (free, no cloud).

```
GitHub repo --> Jenkins --> npm test --> docker build --> terraform (AWS plan) --> terraform (Docker apply) --> app on http://localhost:3000
```

## Submission links
| Item | Link |
|---|---|
| Demo video | [Watch on Google Drive](https://drive.google.com/file/d/1cLhtho73hcGoMDxkZLIuRqOqtCa9TdxQ/view?usp=sharing) |
| Project report (PDF) | [`docs/Project_Report.pdf`](docs/Project_Report.pdf) |
| Presentation | [`docs/CICD_Terraform_Presentation.pptx`](docs/CICD_Terraform_Presentation.pptx) |
| Screenshots | [`docs/screenshots/`](docs/screenshots/) |

## Project layout
| Path | Purpose |
|---|---|
| `server.js`, `test/` | Sample Express app and its tests |
| `Dockerfile` | Packages the app into an image |
| `Jenkinsfile` | The CI/CD pipeline (Checkout, Install, Test, Build, Terraform, Deploy, Verify) |
| `terraform/aws/` | AWS config: S3 bucket, security group, EC2 instance (`main.tf`, `variables.tf`, `outputs.tf`) |
| `terraform/docker/` | Local deployment config + reusable module in `modules/app_container/` |
| `jenkins/` | Dockerfile + docker-compose to run Jenkins with Docker, Node and Terraform preinstalled |
| `docs/` | Screenshot checklist, demo video script, the project report (`Project_Report.pdf`), the presentation and screenshots |

## Prerequisites (install once)
1. **Docker Desktop** (keep it running): https://www.docker.com/products/docker-desktop
2. **Git**: https://git-scm.com
3. A **GitHub account**

Check in a terminal: `docker --version` and `git --version`.

## Step 1: Put the project on GitHub
1. Create a new **public** repository on GitHub (e.g. `jenkins-terraform-mini-project`). Do not add a README there.
2. In this folder run:
```bash
git init
git add .
git commit -m "Initial commit"
git branch -M main
git remote add origin https://github.com/<your-username>/jenkins-terraform-mini-project.git
git push -u origin main
```

## Step 2: Start Jenkins
```bash
cd jenkins
docker compose up -d --build
```
The first build takes 5 to 10 minutes (it installs Docker CLI, Node and Terraform inside Jenkins).

Get the unlock password:
```bash
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```
Open http://localhost:8080, paste the password, choose **Install suggested plugins**, create an admin user.

## Step 3: Create the pipeline job
1. Jenkins home, **New Item**, name `mini-cicd-pipeline`, choose **Pipeline**, OK.
2. Under **Pipeline**, set Definition to **Pipeline script from SCM**.
3. SCM: **Git**. Repository URL: your GitHub repo URL.
4. Branch Specifier: `*/main`. Script Path: `Jenkinsfile`.
5. **Save**.

*(Optional, shows automatic triggering)*: in the job, Configure, Build Triggers, tick **Poll SCM**, schedule `H/2 * * * *`.

## Step 4: Run it
Click **Build Now**. Open the build, then **Console Output** (and **Pipeline Overview / Stage View**).
Stages: Checkout, Install Dependencies, Test, Build Docker Image, Terraform AWS (Init/Validate, Plan, optional Apply), Terraform Docker (Init/Validate, Plan, Apply), Verify Deployment.

The first run uses the default settings (AWS is plan-only). After that the job shows **Build with Parameters**; leave `APPLY_AWS` unticked unless you have an AWS account (see the AWS section at the bottom).

The AWS plan output is saved as a build artifact (`aws-plan.txt`) and shown in Console Output. Show it in your video.

When it turns green, open **http://localhost:3000**. You should see "Hello from the CI/CD pipeline!"

## Step 5: Show CI/CD in action
1. Edit the message in `server.js`.
2. `git add . && git commit -m "Change message" && git push`
3. Click **Build Now** (or wait for Poll SCM). Terraform replaces the container with the new image. Refresh http://localhost:3000.

## Step 6: Inspect the Terraform result (for your demo)
```bash
docker ps                                   # shows the mini-app container
docker exec -it jenkins bash
cd /var/jenkins_home/workspace/mini-cicd-pipeline/terraform/docker
terraform state list
terraform output
cd ../aws && terraform plan -var="use_mock_credentials=true"    # AWS plan, no account needed
exit
```

## Step 7: Screenshots and demo
Follow `docs/SCREENSHOTS_AND_DEMO.md`. Fill in `docs/Short_Report.docx` (replace the highlighted placeholders and paste your screenshots).

## Step 8: Clean up (after recording)
```bash
docker exec jenkins bash -c "cd /var/jenkins_home/workspace/mini-cicd-pipeline/terraform/docker && terraform destroy -auto-approve -var=image_tag=1"
cd jenkins && docker compose down        # add -v to also delete Jenkins data
```

## Troubleshooting
| Problem | Fix |
|---|---|
| `permission denied ... docker.sock` | Make sure `user: root` is in `jenkins/docker-compose.yml`, then `docker compose up -d --build` |
| Port 3000 or 8080 already in use | Stop the other program, or change the port (Jenkins: `8081:8080` in compose; app: `APP_PORT` in the Jenkinsfile) |
| `terraform fmt -check` fails | Run `terraform fmt -recursive` in `terraform/`, commit, push |
| Verify stage cannot reach app | Check `docker ps` shows `mini-app`; check `docker logs mini-app` |
| Container name conflict | `docker rm -f mini-app` then rebuild |
| Jenkins cannot clone repo | Repo must be public (or add GitHub credentials in the job) |
| Docker build slow/failing on network | Retry; first pull of `node:20-alpine` and Terraform provider needs internet |

## Optional: real AWS apply (only if you have an AWS account)
1. Create an IAM user with an access key (use a test account; never commit keys to Git).
2. In Jenkins: Manage Jenkins, Credentials, Global, Add Credentials, kind **Username with password**, ID `aws-creds`, username = Access Key ID, password = Secret Access Key.
3. In `terraform/aws/variables.tf`, set a globally unique `bucket_name` and a valid Amazon Linux `ami_id` for `ap-south-1` (EC2 console, Launch instance).
4. Build with Parameters, tick `APPLY_AWS`.
5. **Destroy right after your demo** to avoid charges: run `terraform destroy -var="use_mock_credentials=false"` in `terraform/aws` with the same credentials. Use only free-tier resources (`t2.micro`).

If you have no AWS account, the assignment allows showing provisioning conceptually: explain the AWS config and show the `terraform plan` output (what would be created) while the Docker config demonstrates a real `apply`.
