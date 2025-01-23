
# Infrastructure and Microservices Deployment

This documentation provides the simple architecture and details of implementation for 3 infrastructures (Azure Kubenetes Services, Azure container registry and Azure log analytics workspace), a Java Spring-boot backend and  React Application frontend and a .NET MVC Application. The purpose of this is to simplify and automate the deployment of the microservices into kubernetes clusters hosted on Microsoft Azure.

The implimentation provides 4 CI/CD pipelines:
- Infrastructure deployment pipeline
- Dotnet application pipeline
- Java spring-boot backend pipeline
- React frontend pipeline

This `README.md` provides instructions on setting up the IAC, building, and running the applications both locally and via pipelines.

![Microservice Architecture](/microservice.png "Microservice Architecture")

## Table of Content
- [Project Structure](#project-structure)
- [Deploy Infrastructure](#deploy-infrastructure)
- [Backend Service](#backend-service)
- [Frontend Service](#frontend-service)
- [Dotnet Service](#Dotnet-service)

## Project Structure

The repository is structured as follows:

```
dotnet/
├── aspnet-core-donet-core/
│   ├── wwwroot/
│   ├── Dockerfile
│   └── aspnet-core-dotnet-core-csproj
│
Infrastructure/
│   ├── modules/
│   │   ├── acr/            
│   │   │   ├── main.tf
│   │   │   ├── outputs.tf
│   │   │   └── variables.tf
│   │   ├── aks/       
│   │   │   ├── main.tf
│   │   │   ├── outputs.tf
│   │   │   └── variables.tf
│   │   └── log_analytics/        
│   │       ├── main.tf
│   │       ├── outputs.tf
│   │       └── variables.tf
│   ├── main.tf
│   └── terraform.tfvars
│
Java-spring-boot-app/
├── backend/
│   ├── src/
│   ├── Dockerfile
│   └── pom.xml
├── frontend/
│   ├── src/
│   ├── Dockerfile
│   └── package.json
└── README.md
```
## IaC - Terraform 

The Infrastructure deployed using the Terraform modules are AKS with auto scaling, ACR and Azure log analytics workspace for monitoring. An existing resource group (named Chidi) was used and an existing MySQL database (named chididemo-db) was used for the spring-boot application.

## Note: This project used existing resource group in Azure. Remember to create a new one if you want. See code below:

## Reference to the existing used in this project
```
data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}
```

## Create a new one
```
resource "azurerm_resource_group" "new-rg" {
  name     = "your-resource-group"
  location = "UK Souht" # Replace with your preferred Azure region
}
```

## Setup Instructions

1. **Clone the repository** and ensure that Terraform is installed on your local machine to test locally.
   
2. **Modify your terraform.tfvars with your desired values to suit your target cloud environment**:
   Run the following Terraform command to test it locally:
   ```bash
   cd Infrastructure
   terraform init
   terraform plan
   ```

3. **Deploy the Infrastructure via Azure Pipeline**:
   Push the code to your repo and authenticate to Azure DevOps organisation and perform the following actions.
   - Select desired DevOps project
   - Click on Pipelines
   - Create new pipeline
   - Select a repository
   - Select an existing YAML file
   - Choose pipeline yaml file (infra-deploy.yaml)
   - Click continue
   - Click run
   - Review and approve if approval checks are configured on your envrionment

4. **To Cleanup and Destroy the Deployed Infrastructure**:
   Follow the same steps in 3 above but for the deployment file, use infra-destroy.yaml 


## Dotnet Application
 
The purpose of this task is to restore project dependencies, run unit tests, and publish the .NET project. 

1. **Perequisites**
     - .NET SDK version 3.1
     - Docker
     - Git

2. **Restore the .NET Project**

   - Open a terminal in the root directory of your project.
   - To restore the project dependencies, run the following command:
     ```sh
     cd dotnet
     dotnet restore
     ```

3. **Run Unit Tests**
   - To run the test, execute;
     ```sh
     dotnet test
     ```

4. **Publish the .NET Project**
   - To publish, run:
     ```sh
     dotnet publish -c Release -o out
     ```

5. **Build the .NET Project**
   - To build, run:
     ```sh
     dotnet build
     ```
6. **Build and run the .NET Project docker image**
   - To build, run: (Add your desired name and port mapping)
     ```sh
     docker build -t test-dotnet:latest .
     docker run -d -p 4000:4000 --name testtt-container test-dotnet:latest
     ```
For locally testing, the application can be accessed via http://localhost:4000/ that is if your port mapping is 4000 as used above.

### CI/CD Pipeline for the dotnet task

Azure DevOps pipeline was used for this project and it has 2 statges: 

1. **Build and Push Stage**

- `restore`: Restores the project dependencies.
- `build`: Builds the project.
- `test`: Runs the unit tests.
- `publish`: Publishes the project.
- `dockerize`: Builds and pushes the Docker image.

2. **Pull docker image via kubenetes maniest file and deploy to AKS**

This second stage pulls the docker image built in first stage by calling kubernetes manifest file (dotnet-app-deployment.yaml) into dotnet-build-pipeline.yaml 

```
- stage: Deploy
  dependsOn: Build
  jobs:
  - job: DeployToAKS
    steps:
    - task: AzureCLI@2
      inputs:
        azureSubscription: $(azureSubscription)
        scriptType: 'bash'
        scriptLocation: 'inlineScript'
        inlineScript: |
          # Get AKS credentials
          az aks get-credentials --resource-group $(aksResourceGroup) --name $(aksClusterName)

          # Apply the Kubernetes deployment and service
          kubectl apply -f kubernetes/dotnet-app-deployment.yaml
        displayName: 'Deploy to AKS'
```
### Dotnet CI/CD Pileine

Follow the steps below To Deploy the dotnet app: The pipeline file is dotnet-build-pipeline.yaml while the Kubernetes manifest file is dotnet-app-deployment.yaml

   - Push the code to your repo and authenticate to Azure DevOps organisation and perform the following actions.
   - Select desired DevOps project
   - Click on Pipelines
   - Create new pipeline
   - Select a repository
   - Select an existing YAML file
   - Choose pipeline yaml file (dotnet-build-pipeline.yaml)
   - Click continue
   - Click run
   - Review and approve if approval checks are configured on your envrionment

## Note: Modify the variables below:
  - acrName: 'chidiezejaugwuacr25.azurecr.io'   - Azure container registry name
  - imageName: 'dotnet-mvc-app' - Your desired image tag
  - dockerfilePath: 'dotnet/aspnet-core-dotnet-core/Dockerfile' - Specify Dockerfile path if you change directory stucture 
  - aksClusterName: 'demo-aks-cluster' - Specify cluster name if different from the varaible in IaC
  - aksResourceGroup: 'Chidi'  - Change resource group name to suit what you have in your cloud account
  - azureSubscription: 'demo-service-conn' - Change the service connection name or service principle that you have in your DevOps project.


## Java Spring-boot Application

The spring-boot application contains the backend directory and frontend directory. The backend directory contains the server-side application, responsible for business logic and API endpoints. The frontend directory contains the React client-side application that interacts with the backend API and provides the user interface.

## Setup

To add your database to the application, follow the steps below to modify database details:
1. **Navigate to spring-boot-react-app directory**
2. **Open backend directory**
3. **Open application.properties and modify the code with database details as seen below**

```
# Database configuration
spring.datasource.url=jdbc:mysql://<database-name>.mysql.database.azure.com:3306/<database-name>?useSSL=true&requireSSL=true
spring.datasource.username=<your <database username>
spring.datasource.password=<your db password or keyvault reference>

spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver
spring.jpa.hibernate.ddl-auto=update  # or 'create'/'none' depending on your setup

# Configure the JPA/Hibernate dialect for MySQL
spring.jpa.database-platform=org.hibernate.dialect.MySQL57Dialect

# Configure the server port (if needed)
server.port=8080

# REST API base path (this is correct based on your earlier config)
spring.data.rest.base-path=/api

# Enable or disable Spring Security (if needed)
# spring.security.enabled=false

# Other possible configurations like logging level, etc.
logging.level.org.springframework.web=DEBUG

```
4. **Open the pom.xml and review the database reference incase you are using a diffrent database type**

```
        <!-- MySQL Driver -->
        <dependency>
            <groupId>mysql</groupId>
            <artifactId>mysql-connector-java</artifactId>
            <scope>runtime</scope>
        </dependency>

```

## Build Backend
1. Change direcory to `backend`:
   ```bash
   cd backend
   ```
2. Build the backend application:
     ```bash
     mvn clean package
     npm install
     mvn spring-boot:run
     java -jar target/react-and-spring-data-rest-0.0.1-SNAPSHOT.jar
     ```

## Build Frontend
1. Change directory to `frontend`:
   ```bash
   cd frontend
   ```
2. Install dependencies:
   ```bash
   npm install
   npm install react-scripts --save
   npm start
   ```
3. Access application on browser
    `http://localhost:8081/`

### Dockerize the Backend
1. cd to `backend` directory where the `Dockerfile` for backend is:

2. Build the backend Docker image:
   ```bash
   docker build -t backend-app .
   ```

### Dockerize the Frontend
1. cd to `frontend` directory where the `Dockerfile` for backend is:

2. Build the frontend Docker image:
   ```bash
   docker build -t frontend-app .
   ```

## Spring-boot CI/CD Pipeline

Follow the steps below To Deploy the dotnet app: The pipeline file is dotnet-build-pipeline.yaml while the Kubernetes manifest file is dotnet-app-deployment.yaml
   - Push the code to your repo and authenticate to Azure DevOps organisation and perform the following actions.
   - Select desired DevOps project
   - Click on Pipelines
   - Create new pipeline
   - Select a repository
   - Select an existing YAML file
   - Choose pipeline yaml file (backend-image-build.yaml)
   - Click continue
   - Click run
   - Review and approve if approval checks are configured on your envrionment

# Note: 
 During deployment, the backend calls backend-deploy-dev.yaml Kubernetes manifest file as seen below:

```
    # Deploy to AKS
    - task: AzureCLI@2
      displayName: Deploy to AKS
      inputs:
        azureSubscription: $(AZURE_SUBSCRIPTION)
        scriptType: 'bash'
        scriptLocation: 'inlineScript'
        inlineScript: |
          # Get AKS credentials
          az aks get-credentials --resource-group $(AKS_RESOURCE_GROUP) --name $(AKS_CLUSTER_NAME)

          # Apply Kubernetes deployment manifest
          kubectl apply -f kubernetes/backend-deploy-dev.yaml

          # Verify deployment
          kubectl rollout status deployment/backend-app -n $(KUBERNETES_NAMESPACE)
```

The fronend calls front-deploy-dev.yaml Kubernetes manifest file as seen below:
```
    # Deploy to AKS
    - task: AzureCLI@2
      displayName: Deploy Frontend to AKS
      inputs:
        azureSubscription: $(AZURE_SUBSCRIPTION)
        scriptType: 'bash'
        scriptLocation: 'inlineScript'
        inlineScript: |
          # Get AKS credentials
          az aks get-credentials --resource-group $(AKS_RESOURCE_GROUP) --name $(AKS_CLUSTER_NAME)

          # Apply Kubernetes deployment manifest
          kubectl apply -f kubernetes/frontend-deploy-dev.yaml -n $(KUBERNETES_NAMESPACE)

          # Verify deployment
          kubectl rollout status deployment/frontend-app -n $(KUBERNETES_NAMESPACE)
```


## React Frontend CI/CD Pipeline

Follow the steps below To Deploy the dotnet app: The pipeline file is dotnet-build-pipeline.yaml while the Kubernetes manifest file is dotnet-app-deployment.yaml
   - Push the code to your repo and authenticate to Azure DevOps organisation and perform the following actions.
   - Select desired DevOps project
   - Click on Pipelines
   - Create new pipeline
   - Select a repository
   - Select an existing YAML file
   - Choose pipeline yaml file (frontend-image-build.yaml)
   - Click continue
   - Click run
   - Review and approve if approval checks are configured on your envrionment


# Note 

- Azure pipeline hosted agent was used for all pipelines as seen below:

```
pool:
  vmImage: 'ubuntu-latest'

```
So, if you are using self-hosted agent, make sure to reference it across all pipelines agent pool

- Change the Azure container registry (acr) name so it will be gloablly unique and other varaibles as seen below (Infrastructure directory)

```
acr_name            = "chidiezejaugwuacr25"
location            = "UK South"
resource_group_name = "Chidi"

```

Thank you for your time!