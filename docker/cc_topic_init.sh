#!/bin/bash

# Create topics
echo "Creating RADAR-base topics..."

if ! radar-schemas-tools create -P $PROPERTIES_FILE_PATH -p $KAFKA_NUM_PARTITIONS -r $KAFKA_NUM_REPLICATION  merged; then
  echo "FAILED TO CREATE TOPICS ... Retrying again"
  if ! radar-schemas-tools create -P $PROPERTIES_FILE_PATH -p $KAFKA_NUM_PARTITIONS -r $KAFKA_NUM_REPLICATION  merged; then
    echo "FAILED TO CREATE TOPICS"
    exit 1
  else
    echo "Created topics at second attempt"
  fi
else
  echo "Topics created."
fi

echo "Registering RADAR-base schemas..."

SCHEMA_REGISTRY_TIMEOUT=${SCHEMA_REGISTRY_TIMEOUT:-120}
if ! radar-schemas-tools register --force -u "$SCHEMA_REGISTRY_API_KEY" -p "$SCHEMA_REGISTRY_API_SECRET" "${KAFKA_SCHEMA_REGISTRY}" --timeout "$SCHEMA_REGISTRY_TIMEOUT" merged; then
  echo "FAILED TO REGISTER SCHEMAS"
  exit 1
fi

echo "Schemas registered."

echo "*******************************************"
echo "**  RADAR-base topics and schemas ready   **"
echo "*******************************************"
