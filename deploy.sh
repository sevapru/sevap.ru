#!/bin/bash

# Enhanced deployment script for sevap.ru with Node.js metrics
# Philosophy: Explicit is better than implicit

set -e  # Exit on any error

# Configuration
WEBSITE_DIR="/var/www/sevap.ru"
NGINX_CONFIG="/etc/nginx/sites-available/sevap.ru"
CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SERVICE_NAME="sevap-metrics"

echo "🚀 Deploying sevap.ru website with Node.js metrics..."

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

# Copy metrics files if they exist
if [ -f "$CURRENT_DIR/metrics.js" ]; then
    echo "📊 Copying metrics files..."
    cp "$CURRENT_DIR"/metrics*.js "$WEBSITE_DIR/"
    cp "$CURRENT_DIR"/view-metrics.sh "$WEBSITE_DIR/"
    chmod +x "$WEBSITE_DIR/view-metrics.sh"
fi

# Set proper permissions
echo "🔐 Setting permissions..."
chown -R www-data:www-data "$WEBSITE_DIR"
chmod -R 644 "$WEBSITE_DIR"
find "$WEBSITE_DIR" -type d -exec chmod 755 {} \;

# Make scripts executable
if [ -f "$WEBSITE_DIR/metrics-server.js" ]; then
    chmod +x "$WEBSITE_DIR/metrics-server.js"
fi
if [ -f "$WEBSITE_DIR/view-metrics.sh" ]; then
    chmod +x "$WEBSITE_DIR/view-metrics.sh"
fi

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

# Check if metrics service exists and restart it
if systemctl is-enabled --quiet $SERVICE_NAME 2>/dev/null; then
    echo "🔄 Restarting metrics service..."
    systemctl restart $SERVICE_NAME
    
    if systemctl is-active --quiet $SERVICE_NAME; then
        echo "✅ Metrics service is running"
    else
        echo "⚠️  Metrics service failed to start"
        echo "   Check logs: journalctl -u $SERVICE_NAME"
    fi
else
    echo "ℹ️  Metrics service not found. Run ./setup-metrics.sh to set it up."
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
echo "📊 Metrics info:"
if systemctl is-active --quiet $SERVICE_NAME 2>/dev/null; then
    echo "   - Service: ✅ Running"
    echo "   - Logs: journalctl -u $SERVICE_NAME -f"
    echo "   - Dashboard: http://localhost/admin/metrics"
else
    echo "   - Service: ❌ Not running"
    echo "   - Setup: ./setup-metrics.sh"
fi
echo ""
echo "🔗 Test your website:"
echo "   - https://sevap.ru"
echo "   - curl -I https://sevap.ru"
echo ""
echo "🔧 Available scripts:"
echo "   - ./setup-metrics.sh  # Set up metrics system"
echo "   - ./view-metrics.sh   # View metrics data" 