terraform -chdir="../../../../../environments/develop/aws/sa-east-1" destroy ^
-target="module.meet" ^
-target="module.route-meet-to-sa-east-1" ^
-auto-approve