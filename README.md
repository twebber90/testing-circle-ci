# testing-circle-ci
Repo for testing with CircleCI

[![CircleCI](https://circleci.com/gh/twebber90/testing-circle-ci.svg?style=svg)](https://circleci.com/gh/twebber90/testing-circle-ci)

## Info about POC

#### Circle CI
With a GitHub account you should be able to set up a CircleCI account. I can give you access to see this repo [on circle CI](https://circleci.com/gh/twebber90/workflows/testing-circle-ci) if you are unable.

Using the `config.yml` inside the `.circleci` folder, this repo has a workspace pipeline that walks through building testing and deploying.

To ensure the YAML file is correctly formatted for valid builds, I added a pre-commit hook using `husky`. For the pre-commit hook to work, the [CircleCI CLI](https://circleci.com/docs/2.0/local-cli/#quick-installation) is required.

The steps in the config file for the pipeline are as follows:
##### Run On PR Verify and Master
* build
* test (would be Unit Tests)
* check_terraform (runs terraform plan to check for any changes to the AWS infrastructure)
##### Run On Master
* deploy_dev
* run_acceptance_tests (would be Acceptance Tests)
* deploy_prod

I used [this blog](https://rangle.io/blog/frontend-app-in-aws-with-terraform/) as the basis for the structuring we would use for the front end. The infrastructure is basically the same as our current front end but with a few additions. The code is stored in s3, but I've added replication to another region. I also created a CloudFront Distribution to serve up the s3 code. CloudFront allows for caching at the edge to help improve performance and reduce latency.
