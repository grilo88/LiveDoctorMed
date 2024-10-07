terraform -chdir="../../../../environments/develop/aws/us-east-1" destroy ^
-target="module.www" ^
-auto-approve