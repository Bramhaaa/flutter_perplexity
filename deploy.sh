#!/bin/bash

# Configuration
PROJECT_ID="perplexity-clone-ai"
SERVICE_NAME="perplexity-backend"
REGION="us-central1"

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}Flutter Perplexity - Firebase Deployment${NC}"
echo -e "${BLUE}========================================${NC}\n"

# Step 1: Build Flutter Web App
echo -e "${BLUE}[1/5] Building Flutter web app...${NC}"
flutter build web
if [ $? -ne 0 ]; then
    echo -e "${RED}Flutter build failed!${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Flutter web app built successfully${NC}\n"

# Step 2: Deploy to Firebase Hosting
echo -e "${BLUE}[2/5] Deploying to Firebase Hosting...${NC}"
firebase deploy --only hosting
if [ $? -ne 0 ]; then
    echo -e "${RED}Firebase Hosting deployment failed!${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Frontend deployed to Firebase Hosting${NC}\n"

# Step 3: Set Google Cloud Project
echo -e "${BLUE}[3/5] Setting up Google Cloud project...${NC}"
gcloud config set project $PROJECT_ID
echo -e "${GREEN}✓ Project set to $PROJECT_ID${NC}\n"

# Step 4: Build and Push Docker Image
echo -e "${BLUE}[4/5] Building and pushing backend Docker image...${NC}"
cd server
gcloud builds submit --tag gcr.io/$PROJECT_ID/$SERVICE_NAME
if [ $? -ne 0 ]; then
    echo -e "${RED}Docker build failed!${NC}"
    exit 1
fi
cd ..
echo -e "${GREEN}✓ Docker image built and pushed${NC}\n"

# Step 5: Deploy to Cloud Run
echo -e "${BLUE}[5/5] Deploying backend to Cloud Run...${NC}"

# Read environment variables
if [ ! -f "server/.env" ]; then
    echo -e "${RED}Error: server/.env file not found!${NC}"
    exit 1
fi

# Extract API keys from .env file
TAVILY_KEY=$(grep TAVILY_API_KEY server/.env | cut -d '=' -f2)
GEMINI_KEY=$(grep GEMINI_API_KEY server/.env | cut -d '=' -f2)

gcloud run deploy $SERVICE_NAME \
    --image gcr.io/$PROJECT_ID/$SERVICE_NAME \
    --platform managed \
    --region $REGION \
    --allow-unauthenticated \
    --set-env-vars TAVILY_API_KEY=$TAVILY_KEY,GEMINI_API_KEY=$GEMINI_KEY \
    --memory 2Gi \
    --cpu 2 \
    --max-instances 10

if [ $? -ne 0 ]; then
    echo -e "${RED}Cloud Run deployment failed!${NC}"
    exit 1
fi

# Get the Cloud Run URL
BACKEND_URL=$(gcloud run services describe $SERVICE_NAME --region=$REGION --format='value(status.url)')

echo -e "${GREEN}✓ Backend deployed to Cloud Run${NC}\n"

echo -e "${BLUE}========================================${NC}"
echo -e "${GREEN}Deployment Complete!${NC}"
echo -e "${BLUE}========================================${NC}\n"

echo -e "Frontend URL: ${GREEN}https://perplexity-clone-ai.web.app${NC}"
echo -e "Backend URL:  ${GREEN}$BACKEND_URL${NC}\n"

echo -e "${BLUE}⚠️  Important: Update your Flutter app to use the backend URL:${NC}"
echo -e "   Edit ${BLUE}lib/services/chat_web_service.dart${NC}"
echo -e "   Replace ${RED}ws://localhost:8000/ws${NC} with ${GREEN}${BACKEND_URL/https/wss}/ws${NC}\n"
