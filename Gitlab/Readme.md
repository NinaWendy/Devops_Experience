Note:

1. Gitlab CI/CD runs as a container the executor is a docker container
2. Inorder to use a DB add a service with the DB image
3. The service runs another container that interacts with the main docker executor container
4. Remember to specify the image for the application as the default image for the docker executor is ruby
5. Divide the jobs into stages so as not to run them simultaneously
6. Define the env variables for the database to use
7. The postgreSQL databse is accesses at postgres:5432 in the docker executor within the pipeline

