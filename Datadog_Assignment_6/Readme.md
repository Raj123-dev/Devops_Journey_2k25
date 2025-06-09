Here's the complete enhanced README.md with all requested commands integrated in their appropriate sections:

```markdown
# Datadog Integration Guide

## Overview of Datadog and its Components
Datadog is a comprehensive monitoring and analytics platform that provides full-stack observability through:

- **APM (Application Performance Monitoring)**: Track application performance with distributed tracing
- **Logs**: Centralized log collection and analysis
- **Metrics**: Infrastructure and application metrics collection
- **Dashboards**: Customizable visualization of all monitored data

## Table of Contents
1. [Datadog Account Setup](#datadog-account-setup)
2. [Ubuntu (Linux) Host Integration](#ubuntu-linux-host-integration)
3. [Docker Integration](#docker-integration)
4. [Jenkins Integration](#jenkins-integration)
5. [Minikube Cluster Integration](#minikube-cluster-integration)
6. [Alert Configuration](#alert-configuration)
7. [Verification](#verification)
8. [Troubleshooting](#troubleshooting)

## Datadog Account Setup
First, create a free tier Datadog account at [Datadog's website](https://www.datadoghq.com/).


## Ubuntu (Linux) Host Integration
### Installation Command:
```bash
DD_API_KEY=15603xxxxxxxxxxxxxxxxxxxxxxxxx90 \
DD_SITE="us5.datadoghq.com" \
bash -c "$(curl -L https://install.datadoghq.com/scripts/install_script_agent7.sh)"
```

### Agent Management Commands:
```bash
sudo systemctl start datadog-agent  # Start the agent
sudo systemctl stop datadog-agent   # Stop the agent
sudo systemctl status datadog-agent # Check agent status
```

![Datadog Host Installation](https://github.com/ShivaChouhan/devops_training/blob/main/Datadog_Assignment_6/Images/host%20machines.png)

Enabled service monitoring by modifying the `datadog.yaml` configuration file.

Configuration path: `/etc/datadog-agent/datadog.yaml`

Key modifications made:
```yaml
process_config:
  run_in_core_agent:
    enabled: true
  process_collection:
    enabled: true
  container_collection:
    enabled: true
```

![Host Integration Status](https://github.com/ShivaChouhan/devops_training/blob/main/Datadog_Assignment_6/Images/host%20Integrations.png)

## Docker Integration
### Configure Docker Group:
```bash
usermod -a -G docker dd-agent
```

### Docker Daemon Configuration:
Edit `/etc/datadog-agent/conf.d/docker.d/docker_daemon.yaml`:
```yaml
init_config:

instances:
    - url: "unix://var/run/docker.sock"
```

![Docker Containers Monitoring](https://github.com/ShivaChouhan/devops_training/blob/main/Datadog_Assignment_6/Images/docker%20containers.png)

## Jenkins Integration
Integrated Jenkins with Datadog for pipeline monitoring by:
1. Installing the Datadog plugin in Jenkins
2. Configuring the plugin with Datadog site and API key


## Minikube Cluster Integration
### Helm Setup Commands:
```bash
helm repo add datadog https://helm.datadoghq.com
helm repo update
kubectl create secret generic datadog-secret --from-literal api-key=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
```

### Installation Command:
```bash
helm install datadog-agent -f datadog-values.yaml datadog/datadog
```

### For updating configuration:
```bash
helm upgrade datadog-agent -f datadog-values.yaml datadog/datadog
```

Key configuration in `datadog-values.yaml`:
```yaml
datadog:
  clusterName: "minikube"
  apiKeyExistingSecret: "datadog-secret"
  site: "us5.datadoghq.com"
  
  processAgent:
    enabled: true
    processCollection: true

clusterAgent:
  enabled: true
  replicas: 2
```

![Kubernetes Pods Monitoring](https://github.com/ShivaChouhan/devops_training/blob/main/Datadog_Assignment_6/Images/kubernetes%20pods.png)

![Kubernetes Pods Monitoring](https://github.com/ShivaChouhan/devops_training/blob/main/Datadog_Assignment_6/Images/flask-app%20pod%20resource%20view.png)


For any integration issues:
1. Verify API keys and site configuration
2. Check agent logs for errors:
   ```bash
   journalctl -u datadog-agent
   ```
3. Ensure proper network connectivity between services and Datadog
4. Validate configuration file syntax
5. Check Docker socket permissions if having Docker issues

For more detailed information, refer to [Datadog's official documentation](https://docs.datadoghq.com/).
