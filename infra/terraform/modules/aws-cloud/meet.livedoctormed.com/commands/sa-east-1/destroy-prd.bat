terraform -chdir="../../../../../environments/prod/aws/sa-east-1" destroy ^
-target="module.meet" ^
-target="module.route-meet-to-sa-east-1" ^
-auto-approve