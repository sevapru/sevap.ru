#!/bin/bash

# Simple deployment script for sevap.ru
# Philosophy: Explicit is better than implicit

set -e  # Exit on any error

# Configuration
WEBSITE_DIR="/var/www/sevap.ru"
NGINX_CONFIG="/etc/nginx/sites-available/sevap.ru"
CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🚀 Deploying sevap.ru website..."

# Check if running as root or with sudo
if [[ $EUID -ne 0 ]]; then
   echo "❌ This script must be run as root or with sudo"
   exit 1
fi

# Backup current website (if exists)
if [ -d "$WEBSITE_DIR" ]; then
    echo "📦 Creating backup..."
    cp -r "$WEBSITE_DIR" "/tmp/sevap.ru.backup.$(date +%Y%m%d_%H%M%S)"
    echo "✅ Backup created in /tmp/"
fi

# Create website directory if it doesn't exist
mkdir -p "$WEBSITE_DIR"

# Copy website files
echo "📂 Copying website files..."
cp -r "$CURRENT_DIR"/{index.html,static,fonts,assets} "$WEBSITE_DIR/"

# Set proper permissions
echo "🔐 Setting permissions..."
chown -R www-data:www-data "$WEBSITE_DIR"
chmod -R 644 "$WEBSITE_DIR"
find "$WEBSITE_DIR" -type d -exec chmod 755 {} \;

# Copy nginx configuration (if provided)
if [ -f "$CURRENT_DIR/nginx.conf" ]; then
    echo "⚙️  Updating nginx configuration..."
    cp "$CURRENT_DIR/nginx.conf" "$NGINX_CONFIG"
    
    # Test nginx configuration
    if nginx -t; then
        echo "✅ Nginx configuration is valid"
        systemctl reload nginx
        echo "🔄 Nginx reloaded"
    else
        echo "❌ Nginx configuration test failed"
        exit 1
    fi
fi

# Verify deployment
if curl -s -o /dev/null -w "%{http_code}" https://sevap.ru | grep -q "200\|301\|302"; then
    echo "✅ Website is accessible"
else
    echo "⚠️  Website might not be accessible (check DNS/SSL)"
fi

echo "🎉 Deployment completed successfully!"
echo ""
echo "📊 Website info:"
echo "   - Location: $WEBSITE_DIR"
echo "   - Size: $(du -sh $WEBSITE_DIR | cut -f1)"
echo "   - Files: $(find $WEBSITE_DIR -type f | wc -l)"
echo ""
echo "🔗 Test your website:"
echo "   - https://sevap.ru"
echo "   - curl -I https://sevap.ru" 