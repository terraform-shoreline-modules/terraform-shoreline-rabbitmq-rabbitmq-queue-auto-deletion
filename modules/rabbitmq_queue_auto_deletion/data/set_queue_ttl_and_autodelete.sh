

#!/bin/bash



QUEUE_NAME=${NAME_OF_THE_QUEUE}



# Set queue expiration time to 7 days

sudo rabbitmqctl set_policy expiry ".*" '{"message-ttl":604800000}' --apply-to queues



# Disable auto-deletion for the queue

sudo rabbitmqctl set_queue_ttl $QUEUE_NAME 0

sudo rabbitmqctl set_queue_autodelete $QUEUE_NAME false