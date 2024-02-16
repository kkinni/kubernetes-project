DOCUMENTATION FOR DEPLOYMENT PROCESS
To deploy the analytics application in this git repository, first create a Cluster IAM role and a Node Group IAM role in your AWS account. You can use these to build an EKS cluster and Node Group. It is recommended to choose the Amazon Linx 2 Arm (AL2_ARM_64) and the t3.medium instance type because this meets the needs of the application in an efficient way - a smaller instance type can be used but you may need to increase the node group settings to provision enough resource for the app, or a larger instance type can be used if you are not concerned about cost.

Once the cluster is working, connect to it in the command line and use helm to install a postgres database onto the cluster. After that, use port-forward to connect to the database and apply the 3 sql files in db/ to the databaes - this is easiest to do from within the db/ directory.

Next, from the analytics/ directory, run pip install -r requirements.txt and verify that everything is running. The other files in anayltics/ are used by the Dockerfile in root to create an image for the analytics application. Note that each time git push occurs in this git repository, a new image version is created and pushed to AWS ECR automatically using CodeBuild. Although semantic versioning has benefits when creating different versions of Docker images, the buildspec.yml in this codebase opts for the convenience of leveraging the $CODEBUILD_BUILD_NUMBER built-in variable instead. Should you wish to make changes to the app code in any future build, simply edit the files and run git push and a new image will be created in ECR.

In the deployment/ directory, ensure that the analytics.yaml file refers to the image version of your choice. No other changes should need to be made, as analytics.yaml has already been configured with suitable health and readiness checks and port numbers. Update db-configmap-config.yaml and db-secret.yaml to contain credentials/secrets specific to the database you have created. Once done, you are ready to run kubectl apply -f deployment/ to create your app in the cluster - you can also run this command to apply any future changes you may make to the deployment files. After this, you can run kubectl get pods, kubectl get svc, and kubectl get deployment to confirm the app has been deployed successfully.

Lastly, run the command to install CloudWatch Insights, after which you will be able to view Metric, Container Insights, Logs, and more in the AWS console. Logs can also be viewed by running kubectl logs <pod-name> in the command line.

Refer to logs to to manage scaling and save costs - if logs show that resources are stretched, you can provision more before this becomes an issue, and if logs show that resources are overprovisioned, you can take action to reduce this and save costs on your AWS account. You also have the option of setting up alarms to alert you when certain thresholds in the logs are reached. 

Happy deploying!


