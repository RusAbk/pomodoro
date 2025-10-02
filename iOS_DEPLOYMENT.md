# 🍅 Pomodoro Timer - iOS Deployment Guide

## 🚀 Codemagic CI/CD Setup

### Prerequisites
1. **Codemagic Account**: Sign up at [codemagic.io](https://codemagic.io)
2. **Apple Developer Account**: Required for App Store deployment ($99/year)
3. **GitHub Repository**: Push your code to GitHub/GitLab/Bitbucket

### 📱 Quick Start

#### 1. Connect Repository
- Go to [Codemagic Dashboard](https://codemagic.io/apps)
- Click "Add application"
- Connect your GitHub repository with this Flutter project
- Codemagic will auto-detect the `codemagic.yaml` configuration

#### 2. Set Environment Variables
In Codemagic dashboard, go to **App Settings** → **Environment Variables**:

```bash
# Required variables (replace with your actual values)
BUNDLE_ID=com.yourname.pomodorotimer
APP_NAME=Pomodoro Timer

# Apple Developer credentials (from Apple Developer Portal)
APP_STORE_CONNECT_KEY_IDENTIFIER=your_key_id
APP_STORE_CONNECT_ISSUER_ID=your_issuer_id
APP_STORE_CONNECT_PRIVATE_KEY=-----BEGIN PRIVATE KEY-----...
```

#### 3. Configure Apple Developer
1. **Apple Developer Portal**:
   - Create App ID with bundle identifier: `com.yourname.pomodorotimer`
   - Generate App Store Connect API Key
   
2. **App Store Connect**:
   - Create new app entry
   - Fill app metadata (name, description, screenshots)

#### 4. Trigger Build
- **Development Build**: Push to `develop` branch
- **Release Build**: Create a git tag: `git tag v1.0.0 && git push origin v1.0.0`

### 🔧 Local Development (Optional)

If you have access to Mac for local testing:

```bash
# Install dependencies
flutter pub get
cd ios && pod install && cd ..

# Run on iOS Simulator
flutter run

# Build for device (requires Apple Developer Account)
flutter build ios --release
```

### 📊 Build Workflows

#### Development Workflow (`develop` branch)
- ✅ Code analysis
- ✅ Unit tests  
- ✅ iOS build (unsigned)
- ✅ Email notifications

#### Release Workflow (git tags `v*.*.*`)
- ✅ Code signing with Apple certificates
- ✅ Build .ipa file
- ✅ Upload to TestFlight
- ✅ Ready for App Store submission

### 💰 Pricing

| Service | Free Tier | Paid |
|---------|-----------|------|
| **Codemagic** | 500 build minutes/month | $0.038/minute |
| **Apple Developer** | 7-day testing only | $99/year |

### 🎯 Next Steps

1. **Sign up** for Codemagic (free tier)
2. **Update** Bundle ID in `codemagic.yaml`
3. **Push** code to GitHub
4. **Connect** repository to Codemagic
5. **Configure** Apple credentials
6. **Trigger** first build!

### 📱 App Store Submission

After successful TestFlight build:
1. Test the app thoroughly
2. Prepare App Store metadata:
   - App description
   - Keywords
   - Screenshots (required sizes)
   - Privacy policy
3. Submit for App Store review
4. 🎉 Launch!

### 🆘 Troubleshooting

**Build Fails?**
- Check Bundle ID matches everywhere
- Verify Apple Developer credentials
- Review build logs in Codemagic dashboard

**Code Signing Issues?**
- Ensure Apple Developer Program is active
- Re-generate certificates if needed
- Check provisioning profile validity

**Need Help?**
- [Codemagic Documentation](https://docs.codemagic.io)
- [Flutter iOS Deployment Guide](https://flutter.dev/docs/deployment/ios)