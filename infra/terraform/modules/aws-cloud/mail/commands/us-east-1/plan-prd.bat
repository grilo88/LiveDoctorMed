terraform -chdir="../../../../../environments/prod/aws/us-east-1" plan ^
-target="module.mail" ^
-target="module.route-mail-to-us-east-1" ^
-out="tfplan-aws-useast1-mail-prd"