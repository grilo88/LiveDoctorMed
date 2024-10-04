terraform -chdir="../../../../../environments/prod/aws/us-east-1" destroy ^
-target="module.meet" ^
-target="module.route-meet-to-us-east-1" ^
-auto-approve