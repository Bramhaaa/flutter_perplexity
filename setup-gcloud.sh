#!/bin/bash

# Flutter Perplexity - Quick Setup for Deployment

echo "🚀 Setting up deployment tools..."

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    echo "❌ Homebrew not found. Please install it first:"
    echo "   /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
    exit 1
fi

# Install Google Cloud SDK
echo "📦 Installing Google Cloud SDK..."
brew install --cask google-cloud-sdk

# Add gcloud to PATH (for current session)
if [ -d "/opt/homebrew/Caskroom/google-cloud-sdk" ]; then
    source "/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
    source "/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"
fi

echo "✅ Installation complete!"
echo ""
echo "Next steps:"
echo "1. Restart your terminal or run: source ~/.zshrc"
echo "2. Initialize gcloud: gcloud init"
echo "3. Login to gcloud: gcloud auth login"
echo "4. Set your project: gcloud config set project perplexity-clone-ai"
echo "5. Enable required APIs: gcloud services enable run.googleapis.com cloudbuild.googleapis.com"
echo "6. Run deployment: ./deploy.sh"
