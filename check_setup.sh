#!/bin/bash

# Quick Start Script for Flutter Perplexity Clone
# This script helps verify your setup

echo "🔍 Flutter Perplexity Clone - Setup Checker"
echo "==========================================="
echo ""

# Check Python
echo "📦 Checking Python..."
if command -v python3 &> /dev/null; then
    PYTHON_VERSION=$(python3 --version)
    echo "✅ $PYTHON_VERSION found"
else
    echo "❌ Python 3 not found. Please install Python 3.9+"
    exit 1
fi

# Check Flutter
echo ""
echo "📱 Checking Flutter..."
if command -v flutter &> /dev/null; then
    FLUTTER_VERSION=$(flutter --version | head -n 1)
    echo "✅ $FLUTTER_VERSION found"
else
    echo "❌ Flutter not found. Please install Flutter SDK"
    exit 1
fi

# Check .env file
echo ""
echo "🔑 Checking environment variables..."
if [ -f "server/.env" ]; then
    echo "✅ .env file found"
    
    # Check if API keys are set
    if grep -q "TAVILY_API_KEY=your_tavily" server/.env; then
        echo "⚠️  TAVILY_API_KEY not configured"
    else
        echo "✅ TAVILY_API_KEY is set"
    fi
    
    if grep -q "GEMINI_API_KEY=your_google" server/.env; then
        echo "⚠️  GEMINI_API_KEY not configured"
    else
        echo "✅ GEMINI_API_KEY is set"
    fi
else
    echo "❌ .env file not found in server directory"
    echo "   Please create server/.env with your API keys"
fi

# Check requirements.txt
echo ""
echo "📋 Checking Python dependencies..."
if [ -f "server/requirements.txt" ]; then
    echo "✅ requirements.txt found"
else
    echo "❌ requirements.txt not found"
fi

# Check if virtual environment exists
if [ -d "server/venv" ]; then
    echo "✅ Virtual environment found"
else
    echo "⚠️  Virtual environment not found"
    echo "   Create one with: cd server && python3 -m venv venv"
fi

echo ""
echo "==========================================="
echo "📝 Next Steps:"
echo ""
echo "1. Add your API keys to server/.env"
echo "2. Install Python dependencies:"
echo "   cd server && pip install -r requirements.txt"
echo ""
echo "3. Install Flutter dependencies:"
echo "   flutter pub get"
echo ""
echo "4. Start the backend server:"
echo "   cd server && uvicorn main:app --reload --port 8000"
echo ""
echo "5. In a new terminal, start Flutter:"
echo "   flutter run -d chrome"
echo ""
echo "For detailed instructions, see SETUP_GUIDE.md"
echo "==========================================="
