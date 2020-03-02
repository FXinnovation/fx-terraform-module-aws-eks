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
