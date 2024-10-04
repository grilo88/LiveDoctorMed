terraform -chdir="../../../../environments/prod/aws/us-east-1" plan ^
-target="module.www" ^
-out="tfplan-aws-global-www-prd"