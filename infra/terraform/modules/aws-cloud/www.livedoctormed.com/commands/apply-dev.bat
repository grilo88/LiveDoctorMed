terraform -chdir="../../../../environments/develop/aws/us-east-1" apply ^
-target="module.www" ^
-auto-approve "tfplan-aws-global-www-dev"