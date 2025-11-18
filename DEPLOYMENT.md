# Firebase Deployment Guide

## Overview
This guide will help you deploy your Flutter Perplexity app to:
- **Frontend**: Firebase Hosting (Flutter Web)
- **Backend**: Google Cloud Run (FastAPI + WebSocket)

## Prerequisites

### 1. Install Google Cloud SDK
```bash
# Install gcloud CLI if you haven't already
brew install --cask google-cloud-sdk

# Or download from: https://cloud.google.com/sdk/docs/install
```

### 2. Initialize gcloud
```bash
gcloud init
gcloud auth login
```

### 3. Enable Required APIs
```bash
# Set your project
gcloud config set project perplexity-clone-ai

# Enable required APIs
gcloud services enable run.googleapis.com
gcloud services enable cloudbuild.googleapis.com
gcloud services enable containerregistry.googleapis.com
```

## Deployment Options

### Option 1: Automated Deployment (Recommended)

Simply run the deployment script:
```bash
./deploy.sh
```

This will:
1. ✅ Build Flutter web app
2. ✅ Deploy frontend to Firebase Hosting
3. ✅ Build backend Docker image
4. ✅ Deploy backend to Cloud Run
5. ✅ Display the deployed URLs

### Option 2: Manual Deployment

#### A. Deploy Frontend Only
```bash
# Build Flutter web app
flutter build web

# Deploy to Firebase Hosting
firebase deploy --only hosting
```

Your frontend will be available at: `https://perplexity-clone-ai.web.app`

#### B. Deploy Backend to Cloud Run
```bash
# Navigate to server directory
cd server

# Build and submit Docker image
gcloud builds submit --tag gcr.io/perplexity-clone-ai/perplexity-backend

# Deploy to Cloud Run
gcloud run deploy perplexity-backend \
  --image gcr.io/perplexity-clone-ai/perplexity-backend \
  --platform managed \
  --region us-central1 \
  --allow-unauthenticated \
  --set-env-vars TAVILY_API_KEY=your_key,GEMINI_API_KEY=your_key \
  --memory 2Gi \
  --cpu 2 \
  --max-instances 10
```

## Post-Deployment Configuration

### Update WebSocket URL in Flutter App

After deploying the backend, you'll get a Cloud Run URL like:
```
https://perplexity-backend-xxxxxxxxxx-uc.a.run.app
```

**Important**: Update your Flutter app to use this URL:

1. Open `lib/services/chat_web_service.dart`
2. Find the WebSocket connection line:
   ```dart
   _socket = await WebSocket.connect(Uri.parse('ws://localhost:8000/ws'));
   ```
3. Replace with your Cloud Run URL (change `https` to `wss`):
   ```dart
   _socket = await WebSocket.connect(Uri.parse('wss://perplexity-backend-xxxxxxxxxx-uc.a.run.app/ws'));
   ```
4. Rebuild and redeploy:
   ```bash
   flutter build web
   firebase deploy --only hosting
   ```

## Environment Variables

Make sure your `server/.env` file contains:
```env
TAVILY_API_KEY=your_tavily_key
GEMINI_API_KEY=your_gemini_key
```

These will be automatically injected into Cloud Run during deployment.

## Monitoring & Logs

### View Cloud Run Logs
```bash
gcloud run services logs read perplexity-backend --region us-central1
```

### View Firebase Hosting
```bash
firebase hosting:channel:list
```

### Cloud Run Dashboard
Visit: https://console.cloud.google.com/run?project=perplexity-clone-ai

## Costs Estimation

### Firebase Hosting
- **Free tier**: 10 GB storage, 360 MB/day transfer
- **Cost**: Usually free for small apps

### Cloud Run
- **Free tier**: 2 million requests/month
- **Compute**: ~$0.00002400/vCPU-second, ~$0.00000250/GiB-second
- **Estimated**: $0-5/month for light usage

## Troubleshooting

### Issue: CORS errors
Add CORS middleware to `server/main.py`:
```python
from fastapi.middleware.cors import CORSMiddleware

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
```

### Issue: WebSocket connection fails
- Ensure Cloud Run URL uses `wss://` (not `ws://`)
- Check Cloud Run service is set to `--allow-unauthenticated`
- Verify environment variables are set correctly

### Issue: Backend cold starts
- Cloud Run instances spin down after inactivity
- First request after idle may take 10-30 seconds
- Consider setting `--min-instances 1` to keep one instance warm (costs more)

## Custom Domain (Optional)

### Add Custom Domain to Firebase Hosting
```bash
firebase hosting:channel:add production
```

Then follow the instructions in Firebase Console:
1. Go to Firebase Console → Hosting
2. Click "Add custom domain"
3. Follow DNS configuration steps

## CI/CD Setup (Optional)

### GitHub Actions
Create `.github/workflows/deploy.yml`:
```yaml
name: Deploy to Firebase

on:
  push:
    branches: [ main ]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - uses: w9jds/firebase-action@master
        with:
          args: deploy --only hosting
        env:
          FIREBASE_TOKEN: ${{ secrets.FIREBASE_TOKEN }}
```

## Quick Commands Reference

```bash
# Deploy everything
./deploy.sh

# Deploy frontend only
firebase deploy --only hosting

# Deploy backend only
cd server && gcloud builds submit --tag gcr.io/perplexity-clone-ai/perplexity-backend
gcloud run deploy perplexity-backend --image gcr.io/perplexity-clone-ai/perplexity-backend --region us-central1

# View logs
gcloud run services logs read perplexity-backend --region us-central1

# Check deployment status
firebase hosting:channel:list
gcloud run services list
```

## Support

For issues, check:
- [Firebase Hosting Docs](https://firebase.google.com/docs/hosting)
- [Cloud Run Docs](https://cloud.google.com/run/docs)
- [Flutter Web Deployment](https://docs.flutter.dev/deployment/web)
