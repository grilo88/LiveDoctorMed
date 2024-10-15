terraform -chdir="../../../../../environments/prod/aws/us-east-1" apply ^
-target="module.mail" ^
-target="module.route-mail-to-us-east-1" ^
-auto-approve "tfplan-aws-useast1-mail-prd"