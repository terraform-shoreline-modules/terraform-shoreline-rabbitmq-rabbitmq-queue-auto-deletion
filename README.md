
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# RabbitMQ Queue Auto-Deletion
---

This incident type refers to unexpected auto-deletion of queues in RabbitMQ. This can occur due to misconfiguration or incorrect settings, which may cause data loss or service disruption. The incident requires investigation and reconfiguration of the queue settings to prevent further occurrences.

### Parameters
```shell
export NAME_OF_SOFTWARE="PLACEHOLDER"

export PATH_TO_CONFIG_FILE="PLACEHOLDER"

export PATH_TO_LOG_FILE="PLACEHOLDER"

export NAME_OF_THE_QUEUE="PLACEHOLDER"
```

## Debug

### Check if rabbitmq-server is running
```shell
systemctl status rabbitmq-server
```

### Check the RabbitMQ logs for any errors or warnings
```shell
journalctl -u rabbitmq-server | grep -i error

journalctl -u rabbitmq-server | grep -i warning
```

### Check the RabbitMQ configuration file for any misconfigurations
```shell
cat /etc/rabbitmq/rabbitmq.config
```

### Check the RabbitMQ server status and verify that all queues are running
```shell
rabbitmqctl status queues
```

### Check the RabbitMQ queue settings for auto-delete and expiration policies
```shell
rabbitmqctl list_queues name auto_delete messages arguments

rabbitmqctl list_queues name expires
```

## Repair

### Review the queue settings and ensure that they are configured appropriately to avoid unexpected auto-deletion, such as setting the queue expiration time or disabling auto-deletion.
```shell


#!/bin/bash



QUEUE_NAME=${NAME_OF_THE_QUEUE}



# Set queue expiration time to 7 days

sudo rabbitmqctl set_policy expiry ".*" '{"message-ttl":604800000}' --apply-to queues



# Disable auto-deletion for the queue

sudo rabbitmqctl set_queue_ttl $QUEUE_NAME 0

sudo rabbitmqctl set_queue_autodelete $QUEUE_NAME false


```