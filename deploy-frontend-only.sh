#!/bin/bash

# Simple Frontend-Only Deployment to Firebase Hosting

echo "🎨 Deploying Flutter Web App to Firebase Hosting..."
echo ""

# Step 1: Build Flutter Web
echo "📦 Building Flutter web app..."
flutter build web

if [ $? -ne 0 ]; then
    echo "❌ Build failed!"
    exit 1
fi

echo "✅ Build complete!"
echo ""

# Step 2: Deploy to Firebase
echo "🚀 Deploying to Firebase Hosting..."
firebase deploy --only hosting

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Deployment successful!"
    echo ""
    echo "🌐 Your app is live at: https://perplexity-clone-ai.web.app"
    echo ""
    echo "⚠️  Note: The app will still connect to your local backend (localhost:8000)"
    echo "   To deploy the backend too, run: ./deploy.sh"
else
    echo "❌ Deployment failed!"
    exit 1
fi
