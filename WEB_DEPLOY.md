# 🌐 Web Deployment Guide

## 🚀 Quick Deploy Options

### Option 1: GitHub Pages (FREE & Easy)

#### 1. Enable GitHub Pages
1. Go to your repository: https://github.com/RusAbk/pomodoro
2. **Settings** → **Pages** 
3. **Source**: Deploy from a branch
4. **Branch**: `gh-pages` (we'll create it)

#### 2. Deploy to GitHub Pages
```bash
# Install GitHub Pages deployment tool
npm install -g gh-pages

# Or using Dart (if you prefer)
dart pub global activate peanut

# Deploy using gh-pages (recommended)
cd build/web
npx gh-pages -d . -b gh-pages

# Or using peanut
# peanut --web-renderer html --branch gh-pages
```

#### 3. Access Your App
Your app will be available at: `https://rusabk.github.io/pomodoro/`

---

### Option 2: Netlify (FREE + Custom Domain)

#### 1. Quick Deploy
1. Go to [netlify.com](https://netlify.com)
2. Drag & drop the `build/web` folder
3. Get instant URL like: `https://amazing-pomodoro-abc123.netlify.app`

#### 2. Connect to Git (Auto-deploy)
1. **New site from Git** → Connect GitHub
2. **Build command**: `flutter build web --release`  
3. **Publish directory**: `build/web`
4. **Auto-deploy**: Every push to `main` branch

---

### Option 3: Vercel (FREE + Fast CDN)

#### 1. Quick Deploy
```bash
# Install Vercel CLI
npm i -g vercel

# Deploy from build folder
cd build/web
vercel --prod
```

#### 2. Custom Configuration
Create `vercel.json` in project root:
```json
{
  "builds": [
    {
      "src": "pubspec.yaml",
      "use": "flutter"
    }
  ],
  "routes": [
    {
      "src": "/(.*)",
      "dest": "/index.html"
    }
  ]
}
```

---

### Option 4: Firebase Hosting (Google's CDN)

#### 1. Setup Firebase
```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login and initialize
firebase login
firebase init hosting
```

#### 2. Configure
- **Public directory**: `build/web`
- **Single-page app**: Yes
- **Automatic builds**: No (we'll build manually)

#### 3. Deploy
```bash
flutter build web --release
firebase deploy
```

---

## 📱 PWA Features (Works like native app)

Your app is already configured as PWA! Users can:
- **Install** from browser (Add to Home Screen)
- **Work offline** (service worker enabled)
- **Full-screen** experience on mobile

### iPhone/iPad Installation:
1. Open in Safari
2. Share button → **Add to Home Screen**
3. Icon appears on home screen like native app!

---

## 🔧 Advanced Configuration

### Custom Domain (All platforms support)
- **GitHub Pages**: CNAME file + domain settings
- **Netlify**: Domain settings in dashboard
- **Vercel**: Domain settings in dashboard  
- **Firebase**: `firebase hosting:channel:deploy production --domain your-domain.com`

### Performance Optimization
```bash
# Build with specific optimizations
flutter build web --release --dart-define=FLUTTER_WEB_USE_SKIA=true

# For better compatibility (older browsers)
flutter build web --release --web-renderer html

# For better performance (modern browsers)
flutter build web --release --web-renderer canvaskit
```

---

## 🎯 Recommended Workflow

### For Testing & Sharing
1. **Netlify** - Easiest, drag & drop
2. **Vercel** - Fast deployment, good for demos

### For Production
1. **Firebase Hosting** - Google's fast CDN
2. **GitHub Pages** - Free, integrated with your repo

### Quick Demo Right Now
1. Go to [netlify.com](https://netlify.com)
2. Drag your `build/web` folder to the deploy area
3. Share the generated URL immediately! 🚀

Your Pomodoro Timer will be live in 30 seconds! ⏱️