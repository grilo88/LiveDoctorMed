terraform -chdir="../../../../../environments/develop/aws/us-east-1" apply ^
-target="module.meet" ^
-target="module.route-meet-to-us-east-1" ^
-auto-approve "tfplan-aws-useast1-meet-dev"