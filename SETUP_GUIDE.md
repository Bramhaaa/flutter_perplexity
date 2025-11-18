# 🚀 Complete Setup Guide for Flutter Perplexity Clone

## Prerequisites
- Flutter SDK (3.6.0 or higher)
- Python 3.9 or higher
- macOS/Linux/Windows

---

## 📋 Step-by-Step Setup

### Step 1: Get API Keys

#### 1.1 Tavily API Key
1. Go to https://tavily.com/
2. Sign up for a free account
3. Get your API key from the dashboard
4. Free tier: 1,000 requests/month

#### 1.2 Google Gemini API Key
1. Go to https://aistudio.google.com/app/apikey
2. Sign in with your Google account
3. Click "Create API Key"
4. Copy your API key
5. Free tier: 60 requests/minute

---

### Step 2: Configure Environment Variables

1. Navigate to the server directory:
   ```bash
   cd server
   ```

2. Open the `.env` file and add your API keys:
   ```env
   TAVILY_API_KEY=tvly-xxxxxxxxxxxxxxxxxxxxxx
   GEMINI_API_KEY=AIzaSyxxxxxxxxxxxxxxxxxxxxxxxxxx
   ```

---

### Step 3: Install Backend Dependencies

```bash
cd server

# Option 1: Create a virtual environment (recommended)
python3 -m venv venv
source venv/bin/activate  # On macOS/Linux
# or
venv\Scripts\activate  # On Windows

# Option 2: Install directly
pip install -r requirements.txt
```

**Note**: The first run will download ML models (sentence-transformers) which may take a few minutes.

---

### Step 4: Install Frontend Dependencies

```bash
# Go back to root directory
cd ..

# Install Flutter dependencies
flutter pub get
```

---

### Step 5: Run the Application

#### Terminal 1 - Start Backend Server:
```bash
cd server
source venv/bin/activate  # If using virtual environment
uvicorn main:app --reload --port 8000
```

You should see:
```
INFO:     Uvicorn running on http://127.0.0.1:8000
INFO:     Application startup complete.
```

#### Terminal 2 - Start Flutter App:
```bash
# For Web
flutter run -d chrome

# For iOS Simulator
flutter run -d ios

# For Android Emulator
flutter run -d android
```

---

## 🧪 Testing the Setup

1. Open the Flutter app
2. Type a query like "What is quantum computing?"
3. You should see:
   - Search results loading
   - Sources appearing
   - AI-generated response streaming in

---

## 🐛 Troubleshooting

### Backend Issues:

**Error: "TAVILY_API_KEY not found"**
- Make sure `.env` file exists in the `server` directory
- Check that API keys are properly set (no quotes needed)
- Restart the server after adding keys

**Error: "Module not found"**
- Make sure you installed requirements: `pip install -r requirements.txt`
- Check you're in the virtual environment

**Port already in use:**
```bash
# Change the port
uvicorn main:app --reload --port 8001
```
Then update the Flutter code to use the new port.

### Frontend Issues:

**WebSocket connection failed:**
- Make sure backend server is running on port 8000
- Check the URL in `lib/services/chat_web_service.dart` (should be `ws://localhost:8000/ws/chat`)

**Flutter dependencies error:**
```bash
flutter clean
flutter pub get
```

---

## 📱 Platform-Specific Notes

### Web:
- Works out of the box
- Best tested on Chrome
- WebSocket support built-in

### iOS:
- Run `cd ios && pod install` if needed
- May need to allow local network connections in Info.plist

### Android:
- May need to add `android:usesCleartextTraffic="true"` in AndroidManifest.xml for local HTTP connections

---

## 🔧 Configuration Options

### Backend Port
Change in `server/main.py` startup command:
```bash
uvicorn main:app --reload --port YOUR_PORT
```

### Frontend WebSocket URL
Change in `lib/services/chat_web_service.dart`:
```dart
WebSocket(Uri.parse("ws://localhost:YOUR_PORT/ws/chat"))
```

### Search Results Count
Change in `server/services/search_service.py`:
```python
response = tavily_client.search(query, max_results=10)  # Change number
```

### AI Model
Change in `server/services/llm_service.py`:
```python
self.model = genai.GenerativeModel("gemini-2.0-flash-exp")  # Try other models
```

---

## 📊 API Usage & Costs

### Free Tier Limits:
- **Tavily**: 1,000 searches/month
- **Gemini**: 60 requests/minute, 1,500 requests/day

### Monitoring Usage:
- Tavily: Check dashboard at tavily.com
- Gemini: Check at aistudio.google.com

---

## 🎯 Next Steps

1. ✅ Set up API keys
2. ✅ Install dependencies
3. ✅ Run backend server
4. ✅ Run Flutter app
5. ✅ Test with a query
6. 🎨 Customize UI/theme
7. 🚀 Deploy to production

---

## 🌐 Deployment (Optional)

### Backend:
- Deploy to Railway, Render, or AWS
- Set environment variables in the platform
- Update Flutter app with production URL

### Frontend:
- Build: `flutter build web`
- Deploy to Firebase Hosting, Netlify, or Vercel
- Update WebSocket URL to production backend

---

## 📚 Additional Resources

- [Tavily Documentation](https://docs.tavily.com/)
- [Google Gemini API Docs](https://ai.google.dev/docs)
- [Flutter WebSocket Guide](https://docs.flutter.dev/cookbook/networking/web-sockets)
- [FastAPI Documentation](https://fastapi.tiangolo.com/)

---

## 💡 Tips

1. **API Keys**: Keep them secret! Never commit to GitHub
2. **First Run**: ML model download takes 2-3 minutes
3. **Rate Limits**: Implement caching for production
4. **Testing**: Use simple queries first to verify setup
5. **Errors**: Check both terminal outputs for error messages
