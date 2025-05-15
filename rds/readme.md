## overview
This project creates
 - 1 x rds

## workspace
```shell
➜  vpc git:(main) ✗ terraform workspace show
default
```

## state file
- tf/this_name.tfstate

## deployment
```shell
$ terraform init
$ terraform apply   --var-file=this_name.tfvars -state=tf/this_name.tfstate
$ terraform destroy --var-file=this_name.tfvars -state=tf/this_name.tfstate
```
