## overview
This project creates
 - 1 x keypair

## workspace
```shell
➜  vpc git:(main) ✗ terraform workspace show
default
```

## state file
- tf/this_name.tfstate

## how to deploy
```shell
$ terraform init
$ terraform.exe apply --var-file=this_name.tfvars -state=tf/this_name.tfstate
$ terraform.exe destroy --var-file=this_name.tfvars -state=tf/this_name.tfstate
```
