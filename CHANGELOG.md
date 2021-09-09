3.0.0
=====

* (BREAKING) chore: pins `pre-commit-hooks` to `v4.0.1`.
* feat: add `pre-commit-afcmf` (`v0.1.2`).
* chore: pins `pre-commit-terraform` to `v1.50.0`.
* chore: pins `terraform` to `>= 0.14`.
* chore: pins `aws` provider to `>= 3.0`.
* chore: pins `tls` provider to `>= 3.0`.
* chore: bumps `terraform` + providers versions in example:
  * pins `terraform` to `>= 0.14`.
  * pins `aws` provider to `>= 3.0`.
  * pins `eks` provider to `>= 2.0`.
  * pins `random` provider to `>= 3.0`.
* refactor: example test cases:
  * add `providers.tf` files.
  * update `versions.tf` files with proper version contraints.
  * update `main.tf`, get rid of `aws` provider stanza.
* refactor: lint code in root module.
* fix: update `LICENSE` file.

2.3.3
=====

  * fix: SG rules for communication on 443/highports between control plane and workers
  * fix: count for `this_ingress_443_cidrs` & `this_allowed_egress_443_cidrs`
  * fix: rename security group outbound rules for controlplane (`allowed...` -> `this_allowed...`)
  * fix: rename security group rules for worker (this... -> worker...)
  * fix: SG rules for worker

2.3.2
=====

  * fix: default value (0) for `allowed_security_group_count` (as we did for `allowed_security_group_ids`)
  * fix: version constraint for aws provider (allow 3.x releases)
  * fix: version constraint for tls provider (allow 3.x releases)
  * chore: bump providers version for example/standard

2.3.1
=====

  * chore: Fix outputs in standard example for TF 0.14

2.3.0
=====

  * feat: Add security group to attach to workers
  * chore: update pre-commit configuration
  * chore: bump pre-commit hooks to fix jenkins test

2.2.1
=====

  * fix: Add calculation of certificate thumbprint

2.2.0
=====

  * chore: Update example outputs to show all outputs
  * feat: Add resources to allow for kubernetes and aws iam integration

2.1.0
=====

  * feat: Add policy to EKS role

2.0.0
=====

  * fix: (BREAKING) Add a "count" variable allowed security group id's
  * chore: update pre-commit configuration

1.4.1 / 2020-02-19
==================

  * fix: Allowed security group was accidently deleted
  * feat: Add more tests to avoid security groups issues

1.4.0 / 2020-02-19
==================

  * feat: Add explicit dependecies for clean destroy

1.3.0 / 2019-12-19
==================

  * feat: Allow cidrs to access to EKS

1.2.0 / 2019-11-13
==================

  * feat: Add new aws_auth_data variable.

1.1.1 / 2019-10-29
==================

  * refactor: Use `count` instead of `for_each`
  * Fix: changed default values

1.1.0 / 2019-10-29
==================

  * feature: add ability to select version of the EKS.

1.0.1 / 2019-10-28
==================

  * fix: output cluster cert as base64 string

1.0.0 / 2019-10-25
==================

  * Fix: typo in output
  * Add output and several fixes
  * Fid: output of certificate auth
  * Add terraform version contraint
  * feature: Add provider version constraint
  * Fix: Set latest provider for aws in example
  * feature: add outputs
  * Fix: Remove outputs from example
  * Fix: datasources and providers in example
  * Fix: Set default value on allowed sg ids
  * feature: Reflect module changes on example
  * Refactor: Removing ALB, EFS and  worker pool
  * Removed master resource from main module
  * Add master module
  * REF: Use templatefile function instead of resource
  * Fix example
  * Removed passing region since it's not needed anymore
  * Removed old variables in example
  * Remove duplicate code, dynic vpc_ic
  * Removed ALB from this module

0.1.1 / 2019-09-23
==================

  * Remove unused variable
  * Remove unused variable
  * Run pre-commit
  * Resolve PR-3 comments
  * Fix terraform-docs
  * Various corrections mainly to use smaller instances for workers.
  * Run pre-commit
  * Corrections
  * Run pre-commit
  * Add variables to manage public/private access to the apiserver endpoint

0.1.0 / 2019-09-12
==================

  * corrections after PR-1 comments
  * Run pre-commit
  * Add a new output with token for cluster authentication
  * Evolutions after PR-1 comments
  * Evolutions after PR-1 comments
  * Run pre-commit
  * Variabilization of instance profile name
  * Run pre-commit
  * Modify variables name to be more clear
  * Run pre-commit and minor correction in variable definition
  * Evolutions after comments in PR
  * Add output of the kubernetes cluster certificate
  * fix pre-commit modifications
  * Import module that deploy an eks cluster
  * Initial commit
