# NMDR Docker Image - Files Overview

This package contains everything needed to create and publish a Docker image for NMDR (National Malaria Data Repository) DHIS2 instance.

## Files Included

### Core Docker Files

1. **Dockerfile**
   - Defines how to build the NMDR Docker image
   - Downloads DHIS2 2.40.6
   - Copies all configuration and metadata files
   - Sets up the installation script

2. **docker-compose.yml**
   - Orchestrates both DHIS2 and PostgreSQL services
   - Defines network and volume configuration
   - Sets up health checks and restart policies
   - Image name: `nmdr:latest`

3. **.dockerignore**
   - Specifies files to exclude from the Docker image
   - Reduces image size by excluding documentation, tests, etc.

### Configuration Files

4. **dhis.conf**
   - DHIS2 configuration file
   - Database connection settings
   - File storage configuration
   - System settings

5. **install-malaria-package.sh**
   - Automated installation script
   - Waits for DHIS2 to start
   - Imports the malaria metadata JSON
   - Runs analytics tables
   - **Already set to executable**

### Metadata Files

6. **malaria-metadata.json**
   - **PLACEHOLDER FILE - YOU MUST REPLACE THIS**
   - This is where your actual malaria metadata JSON goes
   - Must be named exactly `malaria-metadata.json`
   - See METADATA-INSTRUCTIONS.md for details

### Documentation Files

7. **README.md**
   - Comprehensive documentation
   - Installation instructions
   - Configuration options
   - Troubleshooting guide
   - Management commands

8. **QUICKSTART.md**
   - Quick 3-step setup guide
   - Essential commands
   - Common troubleshooting

9. **METADATA-INSTRUCTIONS.md**
   - How to replace the placeholder JSON file
   - Where to get metadata
   - Validation steps

10. **THIS FILE (FILES-OVERVIEW.md)**
    - Overview of all files in the package

## File Structure

```
nmdr-dhis2-docker/
├── Dockerfile                      # Docker image definition
├── docker-compose.yml              # Service orchestration
├── dhis.conf                       # DHIS2 configuration
├── install-malaria-package.sh      # Auto-import script (executable)
├── malaria-metadata.json           # YOUR METADATA HERE (placeholder)
├── .dockerignore                   # Build optimization
├── README.md                       # Full documentation
├── QUICKSTART.md                   # Quick start guide
├── METADATA-INSTRUCTIONS.md        # Metadata file instructions
└── FILES-OVERVIEW.md              # This file

```

## What You Need to Do

### Before Building:

1. ✅ **Replace malaria-metadata.json** with your actual metadata file
   - See METADATA-INSTRUCTIONS.md for details

2. ✅ Verify all files are present in the directory

3. ✅ Review configuration in dhis.conf (optional)

### Build and Test:

```bash
# Make sure you're in the nmdr-dhis2-docker directory
cd nmdr-dhis2-docker

# Build the image
docker-compose build

# Test it locally
docker-compose up -d

# Monitor logs
docker-compose logs -f nmdr

# Access at http://localhost:8080
# Login: admin / district
```

### Publish to Docker Hub:

```bash
# Tag with your Docker Hub username
docker tag nmdr:latest yourusername/nmdr:latest

# Login to Docker Hub
docker login

# Push the image
docker push yourusername/nmdr:latest

# Make it public on hub.docker.com
```

## File Sizes (Approximate)

- **Docker Image**: ~600-800 MB (after build)
- **Dockerfile**: ~1 KB
- **docker-compose.yml**: ~1 KB
- **dhis.conf**: ~1 KB
- **install-malaria-package.sh**: ~3 KB
- **malaria-metadata.json**: Varies (typically 1-100 MB)
- **Documentation files**: ~20 KB total

## Important Notes

### About malaria-metadata.json:
- ⚠️ The included file is just a placeholder
- ⚠️ You MUST replace it with your actual metadata
- ⚠️ File must be named exactly `malaria-metadata.json`
- ⚠️ Must be valid DHIS2 metadata JSON format

### About Passwords:
- Default admin password: `district`
- Default database password: `dhis`
- ⚠️ Change these in production!
- Users should change admin password after first login

### About Ports:
- DHIS2 web interface: 8080
- PostgreSQL database: 5432 (internal only)
- Change ports in docker-compose.yml if needed

## Getting Help

1. **Read the documentation first**
   - README.md for comprehensive info
   - QUICKSTART.md for quick setup
   - METADATA-INSTRUCTIONS.md for metadata help

2. **Check logs for errors**
   ```bash
   docker-compose logs nmdr
   docker-compose logs db
   ```

3. **DHIS2 Community**
   - https://community.dhis2.org
   - https://docs.dhis2.org

4. **Docker Documentation**
   - https://docs.docker.com

## Next Steps

1. [ ] Replace malaria-metadata.json with your actual file
2. [ ] Review and customize dhis.conf if needed
3. [ ] Build the image: `docker-compose build`
4. [ ] Test locally: `docker-compose up -d`
5. [ ] Verify everything works
6. [ ] Tag for Docker Hub
7. [ ] Push to Docker Hub
8. [ ] Make repository public
9. [ ] Share with users!

## Questions?

- Check README.md for detailed documentation
- See QUICKSTART.md for common commands
- Visit https://community.dhis2.org for DHIS2 questions
- Visit https://docs.docker.com for Docker questions

---

**Ready to build?** Make sure you've replaced malaria-metadata.json, then run:

```bash
docker-compose build
docker-compose up -d
```

**Good luck with your NMDR deployment! 🚀**
