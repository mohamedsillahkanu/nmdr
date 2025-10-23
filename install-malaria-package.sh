#!/bin/bash

echo "========================================"
echo "NMDR Malaria Package Installation"
echo "========================================"

# Wait for DHIS2 to be fully ready
echo "⏳ Waiting for DHIS2 to start..."
MAX_TRIES=90
COUNT=0

until curl -f -s http://localhost:8080/api/system/info > /dev/null 2>&1; do
  COUNT=$((COUNT+1))
  if [ $COUNT -ge $MAX_TRIES ]; then
    echo "❌ DHIS2 failed to start within expected time"
    exit 1
  fi
  echo "   Attempt $COUNT/$MAX_TRIES - waiting..."
  sleep 10
done

echo "✅ DHIS2 is running! Waiting additional time for full initialization..."
sleep 60

# Use the malaria metadata JSON file
echo "📦 Using NMDR malaria metadata file..."

if [ ! -f /tmp/malaria-metadata.json ]; then
    echo "❌ Error: malaria-metadata.json not found!"
    echo "Make sure your JSON file is named 'malaria-metadata.json' and is in the same directory as the Dockerfile"
    exit 1
fi

echo "✅ Metadata file found"

# Import metadata into DHIS2
echo "📥 Importing NMDR malaria metadata into DHIS2..."
echo "   This may take 2-5 minutes depending on the size of your metadata..."

IMPORT_RESPONSE=$(curl -X POST \
  -u admin:district \
  -H "Content-Type: application/json" \
  -d @/tmp/malaria-metadata.json \
  http://localhost:8080/api/metadata?atomicMode=NONE \
  --max-time 600 \
  --silent)

# Save response for debugging
echo "$IMPORT_RESPONSE" > /tmp/import-response.json

# Check if import was successful
if echo "$IMPORT_RESPONSE" | jq -e '.status' > /dev/null 2>&1; then
  STATUS=$(echo "$IMPORT_RESPONSE" | jq -r '.status')
  echo "📊 Import Status: $STATUS"
  
  # Show statistics
  echo ""
  echo "Import Statistics:"
  echo "$IMPORT_RESPONSE" | jq '.stats' 2>/dev/null || echo "Stats not available"
  
  if [ "$STATUS" = "OK" ] || [ "$STATUS" = "WARNING" ]; then
    echo ""
    echo "✅ NMDR malaria package imported successfully!"
  else
    echo "⚠️  Import completed with status: $STATUS"
    echo "Check /tmp/import-response.json for details"
  fi
else
  echo "⚠️  Could not parse import response"
  echo "Response saved to /tmp/import-response.json"
fi

# Run analytics
echo ""
echo "🔄 Running analytics tables (this improves dashboard performance)..."
curl -X POST -u admin:district \
  http://localhost:8080/api/resourceTables/analytics \
  --silent > /dev/null

echo ""
echo "========================================"
echo "✨ NMDR Setup Complete!"
echo "========================================"
echo ""
echo "Your NMDR DHIS2 instance is ready!"
echo ""
echo "🌐 Access: http://localhost:8080"
echo "👤 Username: admin"
echo "🔑 Password: district"
echo ""
echo "What's included:"
echo "  • NMDR malaria data elements and indicators"
echo "  • Malaria datasets and forms"
echo "  • Dashboards and visualizations"
echo "  • Complete malaria program structure"
echo ""
echo "⚠️  IMPORTANT: Change the default password after first login!"
echo "========================================"

# Keep container running
tail -f /dev/null
