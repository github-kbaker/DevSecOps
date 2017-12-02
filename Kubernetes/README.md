This "Kubernetes" folder contains scripts to implement what was described in the
<a target="_blank" href="https://run.qwiklab.com/focuses/7044">
"Orchestrating the Cloud with Kubernetes"</a> hands-on lab
which is part of the <a taget="_blank" href="https://run.qwiklab.com/quests/29">
"Kubernetes in the Google Cloud" quest</a>.

The lab covers:
1. Provision a complete Kubernetes cluster using Kubernetes Engine.
2. Deploy and manage Docker containers using kubectl.
3. Break an application into microservices using Kubernetes' Deployments and Services.

https://github.com/kelseyhightower/app
App is hosted on GitHub and provides an example 12-Factor application. 

This lab makes use of Docker images created by a Developer Advocate at Google:

* https://hub.docker.com/r/kelseyhightower/monolith - Monolith includes auth and hello services.
* https://hub.docker.com/r/kelseyhightower/auth - Auth microservice. Generates JWT tokens for authenticated users.
* https://hub.docker.com/r/kelseyhightower/hello - Hello microservice. Greets authenticated users.
* https://hub.docker.com/r/ngnix - Frontend to the auth and hello services.
