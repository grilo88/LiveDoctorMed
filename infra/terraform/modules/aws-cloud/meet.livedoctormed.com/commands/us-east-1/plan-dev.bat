terraform -chdir="../../../../../environments/develop/aws/us-east-1" plan ^
-target="module.meet" ^
-target="module.route-meet-to-us-east-1" ^
-out="tfplan-aws-useast1-meet-dev"