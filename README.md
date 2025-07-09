# Sevap.ru Personal Website

Simple, clean personal website for Vsevolod Prudius with private Node.js metrics.

## Philosophy

Built following the Zen of Python:
- **Beautiful is better than ugly**
- **Explicit is better than implicit** 
- **Simple is better than complex**
- **Flat is better than nested**
- **Sparse is better than dense**
- **Readability counts**

## Features

- ✅ Clean, semantic HTML5
- ✅ Modern CSS with local font hosting
- ✅ No external dependencies
- ✅ Fully responsive design
- ✅ Accessibility features
- ✅ Fast loading (< 100KB total)
- ✅ **Private Node.js metrics system**
- ✅ **Social media deep linking**
- ✅ **Auto-restart systemd service**

## Structure

```
sevap-website/
├── index.html              # Main HTML file
├── static/
│   └── style.css           # All styles
├── fonts/                  # Local font files
│   ├── inter*.woff2        # Inter font variants
│   └── JetBrains*.woff2    # JetBrains Mono variants
├── assets/                 # Future assets (images, etc.)
├── metrics.js              # Client-side metrics tracking
├── metrics-server.js       # Node.js metrics server
├── sevap-metrics-service.txt # Systemd service template
├── setup-metrics.sh        # Metrics system setup
├── view-metrics.sh         # Command-line metrics viewer
├── deploy.sh               # Enhanced deployment script
├── nginx.conf              # Nginx configuration
└── README.md               # This file
```

## Quick Deployment

```bash
# 1. Deploy website and metrics
sudo ./deploy.sh

# 2. Set up metrics system (first time only)
sudo ./setup-metrics.sh

# 3. Set your metrics password
sudo nano /var/www/sevap.ru/metrics-server.js
# Change: const ADMIN_PASSWORD = 'your_secret_password_here';

# 4. Restart metrics service
sudo systemctl restart sevap-metrics
```

## Metrics System

### 🎯 What It Tracks
- **Button Clicks**: LinkedIn, Instagram, Twitter, Facebook, YouTube, etc.
- **Deep Linking**: Opens mobile apps instead of web versions
- **Click Positions**: X/Y coordinates of all user clicks
- **Time Tracking**: Total session time + active engagement time
- **IP Addresses**: Server-side collection (privacy compliant)
- **Session Data**: Unique sessions, scroll depth, referrers

### 🔒 Security
- **Localhost Only**: Metrics endpoints only accessible from server
- **Password Protected**: Dashboard requires authentication
- **No External Dependencies**: Pure Node.js, no npm packages
- **Auto-restart**: Systemd service with failure recovery
- **Privacy Compliant**: Respects Do Not Track headers

### 📊 Access Your Data

#### Web Dashboard (Recommended)
```bash
# SSH tunnel from your local machine:
ssh -L 8080:localhost:80 user@sevap.ru

# Then visit: http://localhost:8080/admin/metrics
```

#### Command Line
```bash
# View today's metrics
./view-metrics.sh

# View specific date
./view-metrics.sh 2025-01-09

# View button clicks
./view-metrics.sh 2025-01-09 buttons

# Monitor live metrics
./view-metrics.sh today live
```

#### Service Management
```bash
# Check status
sudo systemctl status sevap-metrics

# View live logs
sudo journalctl -u sevap-metrics -f

# Restart service
sudo systemctl restart sevap-metrics
```

### 📁 Data Storage
```
/var/log/sevap-metrics/
├── metrics-YYYY-MM-DD.jsonl       # Raw daily data
├── summary-YYYY-MM-DD.json        # Daily summaries
├── button_click-YYYY-MM-DD.jsonl  # Button click details
└── pageview-YYYY-MM-DD.jsonl      # Page view data
```

## Font Files

All fonts are self-hosted for:
- Performance (no external requests)
- Privacy (no Google Fonts tracking)
- Reliability (no CDN dependencies)

## Browser Support

- All modern browsers
- IE11+ (graceful degradation)
- Mobile Safari/Chrome optimized

## Performance

- First Contentful Paint: ~200ms
- Largest Contentful Paint: ~300ms
- Cumulative Layout Shift: 0
- Total size: ~90KB (including fonts)
- Metrics: < 5KB overhead

## Social Media Deep Linking

The metrics system automatically enhances social media links:

- **LinkedIn**: `linkedin.com/in/username` → `linkedin://profile/username`
- **Instagram**: `instagram.com/username` → `instagram://user?username=username`
- **Automatic Fallback**: Opens web version if app not installed

## Troubleshooting

### Metrics Service Not Starting
```bash
# Check Node.js version
node --version

# Check service logs
sudo journalctl -u sevap-metrics -n 50

# Test manually
sudo -u www-data /usr/bin/node /var/www/sevap.ru/metrics-server.js
```

### Dashboard Not Accessible
```bash
# Test local connection
curl -I http://localhost/admin/metrics

# Check nginx proxy
sudo nginx -t
sudo systemctl reload nginx

# Verify service is running
sudo systemctl status sevap-metrics
```

## Font Licenses

Self-hosted fonts are included and licensed under the SIL Open Font License (OFL) 1.1:
- **Inter** by Rasmus Andersson 
- **JetBrains Mono** by JetBrains

See `FONT-LICENSES.txt` for complete licensing information.

## License

MIT License - Simple and permissive 