#!/bin/bash

echo "⚙️  Substituting environment variables into config.yaml..."

# Replace env vars in config.yaml → config.generated.yaml
envsubst < /app/config.yaml > /app/config.generated.yaml

# Optionally show result for debugging
# cat /app/config.generated.yaml

echo "🚀 Starting application..."
exec /usr/local/bin/transact --config /app/config.generated.yaml
