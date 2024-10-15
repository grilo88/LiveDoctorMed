terraform -chdir="../../../../../environments/develop/aws/us-east-1" plan ^
-target="module.mail" ^
-out="tfplan-aws-useast1-mail-dev"