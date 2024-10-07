terraform -chdir="../../../../environments/prod/aws/us-east-1" destroy ^
-target="module.www" ^
-auto-approve