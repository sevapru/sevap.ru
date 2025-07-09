# Sevap.ru Personal Website

Simple, clean personal website for Vsevolod Prudius.

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
- 🔄 Metrics integration ready

## Structure

```
sevap-website/
├── index.html          # Main HTML file
├── static/
│   └── style.css       # All styles
├── fonts/              # Local font files
│   ├── inter*.woff2    # Inter font variants
│   └── JetBrains*.woff2 # JetBrains Mono variants
├── assets/             # Future assets (images, etc.)
└── README.md           # This file
```

## Deployment

1. Copy all files to `/var/www/sevap.ru/`
2. Ensure nginx serves static files with proper headers
3. No build process required - pure HTML/CSS

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

## License

MIT License - Simple and permissive 