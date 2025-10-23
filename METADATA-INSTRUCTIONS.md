# How to Add Your Malaria Metadata JSON File

## Important: Replace the Placeholder File

The `malaria-metadata.json` file in this directory is just a placeholder. You MUST replace it with your actual malaria metadata JSON file before building the Docker image.

## Steps

### 1. Locate Your Malaria Metadata JSON File

You should have a JSON file containing your DHIS2 malaria metadata. It might be named something like:
- `malaria_metadata.json`
- `MAL_AGG_COMPLETE.json`
- `dhis2_malaria_package.json`
- Or any other name

### 2. Replace the Placeholder File

**Option A: Delete and Copy**
```bash
# Delete the placeholder
rm malaria-metadata.json

# Copy your actual file and rename it
cp /path/to/your-file.json malaria-metadata.json
```

**Option B: Overwrite**
```bash
# Directly overwrite with your file
cp /path/to/your-file.json malaria-metadata.json
```

**Option C: Rename Your File**
```bash
# Rename your file to the required name
mv your-actual-file.json malaria-metadata.json
```

### 3. Verify the File

Make sure the file is valid JSON:

```bash
# Check if it's valid JSON (Linux/Mac)
cat malaria-metadata.json | jq . > /dev/null && echo "✅ Valid JSON" || echo "❌ Invalid JSON"

# Or check file size (should not be tiny)
ls -lh malaria-metadata.json
```

Your JSON file should:
- Be valid JSON format
- Contain DHIS2 metadata objects
- Be larger than 1KB (the placeholder is very small)
- Have sections like `dataElements`, `indicators`, `dataSets`, etc.

### 4. Example Valid Structure

Your JSON should look something like this:

```json
{
  "dataElements": [
    {
      "id": "abc123",
      "name": "Malaria cases tested",
      "shortName": "MAL cases tested",
      ...
    }
  ],
  "indicators": [
    {
      "id": "xyz789",
      "name": "Malaria test positivity rate",
      ...
    }
  ],
  "dataSets": [...],
  "programs": [...],
  "dashboards": [...]
}
```

### 5. Common Issues

**Issue**: File not found during build
**Solution**: Make sure the file is in the same directory as the Dockerfile and is named exactly `malaria-metadata.json` (case-sensitive)

**Issue**: Import fails during setup
**Solution**: Verify your JSON is valid DHIS2 metadata format. Check the logs:
```bash
docker-compose logs nmdr
docker exec nmdr-app cat /tmp/import-response.json
```

**Issue**: File too large
**Solution**: This is usually fine. Large metadata files (10-100MB) are normal and will just take longer to import (5-10 minutes)

## Where to Get Metadata

If you don't have a malaria metadata JSON file yet, you can:

1. **Export from existing DHIS2 instance:**
   - Login to DHIS2
   - Go to Apps → Import/Export
   - Click "Metadata Export"
   - Select all malaria-related metadata types
   - Choose JSON format
   - Export and download

2. **Download from DHIS2 metadata repository:**
   - Visit: https://github.com/dhis2-metadata
   - Look for malaria packages (e.g., MAL_AGG)
   - Download the JSON file

3. **Request from WHO/DHIS2:**
   - Contact DHIS2 metadata team
   - Request WHO malaria package for your DHIS2 version

## After Replacing the File

Once you've replaced the placeholder with your actual metadata file:

```bash
# Build the image
docker-compose build

# Start the services
docker-compose up -d

# Monitor the logs
docker-compose logs -f nmdr
```

The import process will automatically:
1. Detect your metadata file
2. Import all configurations
3. Set up dashboards and visualizations
4. Configure the malaria program structure

## Need Help?

If you're having trouble with your metadata file:

1. Check it's valid JSON
2. Verify it contains DHIS2 metadata
3. Make sure it's compatible with DHIS2 2.40
4. Check the import logs for specific errors

For DHIS2 metadata questions, visit: https://community.dhis2.org
