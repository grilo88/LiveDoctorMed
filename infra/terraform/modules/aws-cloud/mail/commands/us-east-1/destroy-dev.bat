terraform -chdir="../../../../../environments/develop/aws/us-east-1" destroy ^
-target="module.mail" ^
-target="module.route-mail-to-us-east-1" ^
-auto-approve