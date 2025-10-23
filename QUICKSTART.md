# NMDR Quick Start Guide

Get your NMDR DHIS2 instance running in just 3 steps!

## Prerequisites

- ✅ Docker installed ([Get Docker](https://docs.docker.com/get-docker/))
- ✅ Your `malaria-metadata.json` file
- ✅ 10 minutes of time

## Step 1: Prepare Your Files

1. **Download/create this folder structure:**
```
nmdr-dhis2-docker/
├── Dockerfile
├── docker-compose.yml
├── dhis.conf
├── install-malaria-package.sh
├── .dockerignore
└── malaria-metadata.json    ← YOUR JSON FILE HERE
```

2. **Place your JSON file** - Make sure it's named exactly `malaria-metadata.json`

If your file has a different name, rename it:
```bash
mv your-file-name.json malaria-metadata.json
```

## Step 2: Build and Start

Open terminal in the `nmdr-dhis2-docker` folder and run:

```bash
# Build the image
docker-compose build

# Start everything
docker-compose up -d
```

## Step 3: Wait and Access

**Monitor the progress:**
```bash
docker-compose logs -f nmdr
```

**Look for these messages:**
- ✅ "DHIS2 is running!"
- ✅ "Metadata file found"
- ✅ "NMDR malaria package imported successfully!"
- ✅ "✨ NMDR Setup Complete!"

**After 5-10 minutes, access:**
- 🌐 URL: http://localhost:8080
- 👤 Username: `admin`
- 🔑 Password: `district`

## That's It! 🎉

Your NMDR instance is ready with all malaria metadata pre-loaded!

## What to Do Next

### 1. Change Default Password (IMPORTANT!)
- Go to Settings → Users → admin → Reset password

### 2. Set Up Organization Units
- Apps → Maintenance → Organisation Units
- Add your country, provinces, districts, facilities

### 3. Create User Accounts
- Apps → Users
- Create accounts for your team
- Assign appropriate roles (Data Entry, Manager, etc.)

### 4. Start Using NMDR
- Apps → Data Entry
- Select facility, dataset, period
- Enter malaria data!

### 5. View Dashboards
- Apps → Dashboards
- Explore malaria visualizations and reports

## Common Commands

```bash
# Stop services
docker-compose down

# Start services again
docker-compose up -d

# View logs
docker-compose logs -f

# Restart everything
docker-compose restart

# Complete cleanup (removes all data)
docker-compose down -v
```

## Troubleshooting

### Can't access http://localhost:8080?

**Wait longer** - First startup takes 10+ minutes

**Check logs:**
```bash
docker-compose logs nmdr
```

**Check if running:**
```bash
docker-compose ps
```

### Port 8080 already in use?

Edit `docker-compose.yml`, change:
```yaml
ports:
  - "8090:8080"  # Use 8090 instead
```

Then access http://localhost:8090

### Metadata import failed?

**Check the import response:**
```bash
docker exec nmdr-app cat /tmp/import-response.json
```

**Manually retry import:**
```bash
docker exec nmdr-app /usr/local/bin/install-malaria-package.sh
```

### Slow performance?

Edit `docker-compose.yml`, increase memory:
```yaml
environment:
  JAVA_OPTS: "-Xms4000m -Xmx8000m"
```

## Publishing to Docker Hub

Once you've tested and it works:

```bash
# Tag the image
docker tag nmdr:latest yourusername/nmdr:latest

# Login to Docker Hub
docker login

# Push the image
docker push yourusername/nmdr:latest

# Make it public at hub.docker.com
```

## Getting Help

- 📖 Full documentation: See README.md
- 💬 DHIS2 Community: https://community.dhis2.org
- 📚 DHIS2 Docs: https://docs.dhis2.org

---

**Need more details?** Check the full [README.md](README.md) for comprehensive documentation!
