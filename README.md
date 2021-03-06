# Operations Development CG - Spring 2022
This repository contains various experiments in AWS done as part of the Operations Development Competence Group at [13|37](https://1337.tech/) in spring 2022.

## Contents
### Auth
A sample setup of AWS Cognito with a custom domain.

*Deployed with Terraform*

### CI
Required infrastructure for CI tasks such as S3 buckets for assets storage and terraform states.

*Deployed with Terraform*

### Databases
Databases such as DynamoDB, for usage by other projects.

*Deployed with Terraform*

### DNS
Includes a hosted zone, with an external DNS.

*Deployed with Terraform*

### Cats API
A sample Python FastAPI application that uses DynamoDB for storage and Cognito for authentication.

*Deployed with AWS SAM*

### Dogs API
A sample Python FastAPI application that uses DynamoDB for storage and Cognito for authentication.

*Deployed with AWS SAM*

### Token API
An API to fetch access and id tokens from the Cognito User Pool.

*Deployed with AWS SAM*

### Edge API
An API running on Lambda@Edge and CloudFront that consolidates Cats & Dogs APIs.

*Deployed with AWS SAM*
