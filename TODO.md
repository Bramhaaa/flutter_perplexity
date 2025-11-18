# 📋 TO-DO LIST: Making Your Flutter Perplexity Clone Functional

## Status: ✅ Files Created | ⚠️ Configuration Needed

---

## 🔴 CRITICAL: API Keys Required

### 1. Get Tavily API Key (Required)
- **Website**: https://tavily.com/
- **Steps**:
  1. Sign up for a free account
  2. Verify your email
  3. Go to dashboard and copy API key
  4. Free tier: 1,000 searches/month

### 2. Get Google Gemini API Key (Required)
- **Website**: https://aistudio.google.com/app/apikey
- **Steps**:
  1. Sign in with Google account
  2. Click "Create API Key"
  3. Select existing project or create new one
  4. Copy the API key
  5. Free tier: 60 requests/minute, 1,500/day

### 3. Configure Environment Variables
- **File**: `server/.env` (already created for you)
- **Action**: Open the file and replace the placeholder values:
  ```env
  TAVILY_API_KEY=tvly-xxxxxxxxxxxxxxxx
  GEMINI_API_KEY=AIzaSyxxxxxxxxxxxxxxxx
  ```

---

## 🟡 INSTALLATION: Dependencies

### Backend (Python)

**Option A: Using Virtual Environment (Recommended)**
```bash
cd server
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

**Option B: Global Installation**
```bash
cd server
pip install -r requirements.txt
```

**Note**: First installation downloads ML models (~500MB) - takes 2-5 minutes

### Frontend (Flutter)

```bash
# From project root
flutter pub get
```

---

## 🟢 RUNNING THE APPLICATION

### Step 1: Start Backend Server

```bash
cd server
source venv/bin/activate  # Only if using venv
uvicorn main:app --reload --port 8000
```

**Expected Output**:
```
INFO:     Uvicorn running on http://127.0.0.1:8000
INFO:     Application startup complete.
```

### Step 2: Start Flutter App (New Terminal)

```bash
# For Web (Chrome)
flutter run -d chrome

# For iOS Simulator
flutter run -d ios

# For Android Emulator
flutter run -d android

# For macOS Desktop
flutter run -d macos
```

---

## 🧪 VERIFY IT WORKS

1. ✅ Backend running on http://localhost:8000
2. ✅ Flutter app opens in browser/device
3. ✅ Type a test query: "What is artificial intelligence?"
4. ✅ See search results appear
5. ✅ See AI response streaming in

---

## 📁 FILES I CREATED FOR YOU

✅ `server/.env` - Environment variables template  
✅ `server/.env.example` - Example for future reference  
✅ `server/requirements.txt` - Python dependencies  
✅ `SETUP_GUIDE.md` - Detailed setup instructions  
✅ `check_setup.sh` - Automated setup checker  
✅ `TODO.md` - This file  

---

## 🐛 COMMON ISSUES & SOLUTIONS

### "ModuleNotFoundError: No module named 'X'"
**Solution**: Install requirements
```bash
cd server
pip install -r requirements.txt
```

### "WebSocket connection failed"
**Solution**: Make sure backend is running first
```bash
cd server && uvicorn main:app --reload --port 8000
```

### "API Key not found" or Empty Responses
**Solution**: Check your `.env` file has actual API keys (no quotes needed)

### Port Already in Use
**Solution**: Change the port
```bash
uvicorn main:app --reload --port 8001
```
Then update `lib/services/chat_web_service.dart` line 20:
```dart
WebSocket(Uri.parse("ws://localhost:8001/ws/chat"))
```

---

## 📊 PROJECT ARCHITECTURE

```
Flutter App (Frontend)
    ↓ WebSocket
FastAPI Server (Backend)
    ↓
┌─────────────────┬──────────────────┬──────────────────┐
│   Tavily API    │   Gemini API     │  Sentence        │
│   (Web Search)  │   (AI Responses) │  Transformers    │
│                 │                  │  (Sort Results)  │
└─────────────────┴──────────────────┴──────────────────┘
```

---

## 🎯 CHECKLIST

- [ ] Get Tavily API key
- [ ] Get Gemini API key
- [ ] Add keys to `server/.env`
- [ ] Install Python dependencies
- [ ] Install Flutter dependencies
- [ ] Start backend server
- [ ] Start Flutter app
- [ ] Test with a query
- [ ] Celebrate! 🎉

---

## 📚 ADDITIONAL RESOURCES

- **Tavily Docs**: https://docs.tavily.com/
- **Gemini Docs**: https://ai.google.dev/docs
- **FastAPI Docs**: https://fastapi.tiangolo.com/
- **Flutter Docs**: https://docs.flutter.dev/

---

## 💡 TIPS

1. Keep your API keys secret - never commit them to Git
2. The `.gitignore` is already configured to exclude `.env`
3. ML models download once and cache locally
4. Test with simple queries first
5. Check both terminal windows for errors
6. Use `flutter clean` if you encounter Flutter issues

---

## 🚀 DEPLOYMENT (Later)

Once everything works locally:

1. **Backend**: Deploy to Railway, Render, or Fly.io
2. **Frontend**: Build with `flutter build web` and deploy to Firebase Hosting
3. Update WebSocket URL in Flutter app to production backend

---

## ❓ NEED HELP?

1. Run the setup checker: `./check_setup.sh`
2. Check the detailed guide: `SETUP_GUIDE.md`
3. Review server logs for error messages
4. Verify API keys are valid and have quota remaining

---

**Last Updated**: November 18, 2025  
**Status**: Ready for configuration ✨
