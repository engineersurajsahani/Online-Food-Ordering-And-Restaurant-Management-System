#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Save project root directory
PROJECT_ROOT=$(pwd)

echo -e "${GREEN}Starting Backend and Frontend...${NC}"

# Start backend
echo -e "${BLUE}Starting Backend (npm start)...${NC}"
cd "$PROJECT_ROOT/backend" && npm start &
BACKEND_PID=$!

# Start frontend
echo -e "${BLUE}Starting Frontend (flutter run -d chrome)...${NC}"
cd "$PROJECT_ROOT/frontend" && flutter run -d chrome &
FRONTEND_PID=$!

# Wait for both processes
wait $BACKEND_PID $FRONTEND_PID
