terraform -chdir="../../../../environments/develop/aws/us-east-1" plan ^
-target="module.www" ^
-out="tfplan-aws-global-www-dev"