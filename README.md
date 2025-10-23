# NMDR - DHIS2 Malaria Instance

A ready-to-use DHIS2 instance pre-configured with NMDR malaria metadata package.

## Overview

NMDR (National Malaria Data Repository) is a complete DHIS2 implementation for malaria surveillance and monitoring. This Docker image provides a fully configured DHIS2 instance with all malaria-related metadata pre-installed.

## What's Included

✅ **DHIS2 Version 2.40.6** (stable release)
✅ **NMDR Malaria Metadata Package** including:
   - Malaria data elements and categories
   - Malaria indicators
   - Standard malaria datasets and forms
   - Malaria program structure
   - Pre-built dashboards and visualizations
   - Reporting frameworks

✅ **PostgreSQL Database** with PostGIS support
✅ **Auto-configuration** - ready to use immediately

## Quick Start

### Prerequisites

- Docker installed ([Get Docker](https://docs.docker.com/get-docker/))
- Docker Compose installed (included with Docker Desktop)
- Minimum 4GB RAM available
- 10GB free disk space

### Installation Steps

1. **Download/Clone this repository**
```bash
git clone <your-repo-url>
cd nmdr-dhis2-docker
```

2. **Add your malaria metadata JSON file**
   - Place your `malaria-metadata.json` file in this directory
   - Make sure it's named exactly `malaria-metadata.json`

3. **Start the services**
```bash
docker-compose up -d
```

4. **Monitor the installation**
```bash
docker-compose logs -f nmdr
```

Wait for the message: `✨ NMDR Setup Complete!`

5. **Access DHIS2**

🌐 **URL**: http://localhost:8080

👤 **Username**: `admin`

🔑 **Password**: `district`

**⚠️ CRITICAL**: Change the default password immediately after first login!

## First Time Setup

Installation takes approximately 5-10 minutes. Here's what happens:

```
[0-2 min]   Starting PostgreSQL database...
[2-4 min]   Starting DHIS2 application...
[4-6 min]   Waiting for DHIS2 to initialize...
[6-10 min]  Importing NMDR malaria metadata...
[10+ min]   Running analytics and finalizing...
```

### After First Login

1. **Change the default password**
   - Settings → Users → admin → Reset password

2. **Set up your organization structure**
   - Apps → Maintenance → Organisation Units
   - Add your country, provinces, districts, facilities

3. **Create user accounts**
   - Apps → Users
   - Create accounts for data entry staff, managers, etc.
   - Assign appropriate roles

4. **Start using NMDR**
   - Apps → Data Entry
   - Select facility, dataset, period
   - Enter malaria data

## Building the Image

### Build Locally

```bash
# Build the image
docker-compose build

# Or build with specific tag
docker build -t nmdr:latest .
```

### Test the Build

```bash
# Start services
docker-compose up

# Check logs
docker-compose logs -f

# Access and verify at http://localhost:8080
```

## Publishing to Docker Hub

### Step 1: Tag the Image

```bash
# Tag with your Docker Hub username
docker tag nmdr:latest yourusername/nmdr:latest

# Tag with version
docker tag nmdr:latest yourusername/nmdr:v1.0

# Tag with date
docker tag nmdr:latest yourusername/nmdr:2025.01
```

### Step 2: Push to Docker Hub

```bash
# Login to Docker Hub
docker login

# Push all tags
docker push yourusername/nmdr:latest
docker push yourusername/nmdr:v1.0
docker push yourusername/nmdr:2025.01
```

### Step 3: Make Repository Public

1. Go to https://hub.docker.com
2. Navigate to your repository: `yourusername/nmdr`
3. Click **Settings**
4. Under **Visibility**, select **Public**
5. Click **Save**

## Using the Published Image

Once published, others can use it with this simple setup:

**Create `docker-compose.yml`:**

```yaml
version: '3.8'

services:
  db:
    image: postgis/postgis:13-3.1-alpine
    environment:
      POSTGRES_USER: dhis
      POSTGRES_PASSWORD: dhis
      POSTGRES_DB: dhis2
    volumes:
      - db-data:/var/lib/postgresql/data

  nmdr:
    image: yourusername/nmdr:latest
    ports:
      - "8080:8080"
    depends_on:
      - db
    environment:
      DHIS2_HOME: /opt/dhis2

volumes:
  db-data:
```

**Run:**
```bash
docker-compose up -d
```

## Configuration Options

### Change Port

Edit `docker-compose.yml`:
```yaml
services:
  nmdr:
    ports:
      - "8090:8080"  # Use port 8090 instead of 8080
```

### Increase Memory

Edit `docker-compose.yml`:
```yaml
services:
  nmdr:
    environment:
      JAVA_OPTS: "-Xms4000m -Xmx8000m"  # Increase for better performance
```

### Custom Server URL

Edit `dhis.conf`:
```properties
server.base.url = https://your-domain.com
```

## Management Commands

### Start services
```bash
docker-compose up -d
```

### Stop services
```bash
docker-compose down
```

### View logs
```bash
# All logs
docker-compose logs -f

# NMDR logs only
docker-compose logs -f nmdr

# Database logs only
docker-compose logs -f db
```

### Restart services
```bash
docker-compose restart
```

### Remove everything (including data)
```bash
docker-compose down -v
```

### Access container shell
```bash
# NMDR container
docker exec -it nmdr-app bash

# Database container
docker exec -it nmdr-db bash
```

## Database Management

### Backup Database

```bash
# Backup to SQL file
docker exec nmdr-db pg_dump -U dhis dhis2 > nmdr-backup-$(date +%Y%m%d).sql

# Backup and compress
docker exec nmdr-db pg_dump -U dhis dhis2 | gzip > nmdr-backup-$(date +%Y%m%d).sql.gz
```

### Restore Database

```bash
# Stop NMDR app first
docker-compose stop nmdr

# Restore from backup
cat nmdr-backup.sql | docker exec -i nmdr-db psql -U dhis -d dhis2

# Or from compressed backup
gunzip -c nmdr-backup.sql.gz | docker exec -i nmdr-db psql -U dhis -d dhis2

# Restart NMDR app
docker-compose start nmdr
```

### Reset Database (Start Fresh)

```bash
docker-compose down -v
docker-compose up -d
```

## Troubleshooting

### DHIS2 won't start

**Check logs:**
```bash
docker-compose logs nmdr
```

**Common issues:**
- **Insufficient memory**: Increase memory allocation
- **Port 8080 in use**: Change to different port
- **Database not ready**: Wait longer or check database logs

**Solution:**
```bash
# Restart everything
docker-compose restart

# Or start fresh
docker-compose down
docker-compose up -d
```

### Metadata didn't import

**Check import response:**
```bash
docker exec nmdr-app cat /tmp/import-response.json | jq .
```

**Manually trigger import:**
```bash
docker exec nmdr-app /usr/local/bin/install-malaria-package.sh
```

### Can't access http://localhost:8080

**Check if services are running:**
```bash
docker-compose ps
```

**Check if port is accessible:**
```bash
curl http://localhost:8080
```

**Try different browser or clear cache**

### Slow performance

**Increase allocated memory:**
Edit `docker-compose.yml` and increase `JAVA_OPTS`

**Run analytics manually:**
```bash
curl -X POST -u admin:district http://localhost:8080/api/resourceTables/analytics
```

**Check Docker resources:**
Docker Desktop → Settings → Resources → Increase CPU/Memory

### Database connection error

**Verify database is running:**
```bash
docker-compose logs db
```

**Check database connectivity:**
```bash
docker exec nmdr-app pg_isready -h db -U dhis
```

**Restart database:**
```bash
docker-compose restart db
```

## System Requirements

### Minimum
- **CPU**: 2 cores
- **RAM**: 4GB
- **Disk**: 10GB
- **OS**: Linux, macOS, Windows with WSL2

### Recommended
- **CPU**: 4+ cores
- **RAM**: 8GB+
- **Disk**: 20GB+ SSD
- **Network**: Stable internet for initial download

## Security Best Practices

⚠️ **Important Security Steps:**

1. **Change default password immediately**
   ```bash
   # After first login, go to Settings → Users → admin
   ```

2. **Use environment variables for passwords**
   ```yaml
   environment:
     POSTGRES_PASSWORD: ${DB_PASSWORD}
   ```

3. **Enable HTTPS in production**
   - Use nginx reverse proxy with SSL certificate

4. **Regular backups**
   - Schedule daily database backups
   - Store backups securely off-site

5. **Update regularly**
   - Check for DHIS2 updates
   - Rebuild image with latest security patches

6. **Firewall configuration**
   - Only expose necessary ports
   - Use Docker networks for service communication

7. **Strong database passwords**
   - Change default database password in production

## Updating

### Update DHIS2 Version

1. Edit `Dockerfile` and change WAR file URL:
```dockerfile
RUN wget -O /usr/local/tomcat/webapps/ROOT.war \
    https://releases.dhis2.org/2.41/dhis2-stable-2.41.0.war
```

2. Rebuild:
```bash
docker-compose build
```

3. **Backup first!** Then deploy:
```bash
docker-compose up -d
```

### Update Metadata Package

1. Replace `malaria-metadata.json` with new version
2. Rebuild: `docker-compose build`
3. Deploy: `docker-compose up -d`

## Use Cases

Perfect for:

- 🎓 **Training**: Medical/public health education
- 🧪 **Testing**: Development and QA testing
- 🎯 **Pilot Projects**: Quick malaria program deployment
- 📊 **Demos**: Stakeholder presentations
- 💻 **Development**: Building malaria-focused integrations
- 🌍 **National Programs**: Template for country implementations
- 🏥 **Sub-national**: District/facility level deployments

## Technical Details

### Technology Stack
- **Application**: DHIS2 2.40.6
- **Application Server**: Apache Tomcat 9
- **Java**: OpenJDK 11
- **Database**: PostgreSQL 13 with PostGIS
- **Container**: Docker
- **Orchestration**: Docker Compose

### Ports
- **8080**: DHIS2 web interface
- **5432**: PostgreSQL database (internal)

### Volumes
- **db-data**: PostgreSQL data persistence
- **nmdr-files**: DHIS2 file storage
- **nmdr-apps**: DHIS2 custom apps

### Networks
- **nmdr-network**: Bridge network for service communication

## Support and Resources

- **DHIS2 Documentation**: https://docs.dhis2.org
- **DHIS2 Community**: https://community.dhis2.org
- **Docker Documentation**: https://docs.docker.com
- **Issue Tracker**: [Your GitHub issues URL]
- **Support Email**: [Your support email]

## Contributing

Contributions welcome! To contribute:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

- **DHIS2**: BSD 3-Clause License
- **Malaria Metadata**: [Your license]
- **Docker Configuration**: [Your license]

## Acknowledgments

- DHIS2 by HISP Centre, University of Oslo
- Malaria metadata package by [Your organization]
- Community contributors

## Changelog

### Version 1.0 (2025-01)
- Initial release
- DHIS2 2.40.6
- Complete NMDR malaria metadata package
- Automated installation and configuration
- Docker Compose setup

---

**Questions?** Check the [DHIS2 Community](https://community.dhis2.org) or open an issue.

**Ready to deploy?** Start with the Quick Start guide above! 🚀
