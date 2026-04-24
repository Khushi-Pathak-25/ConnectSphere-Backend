@echo off
echo Stopping all ConnectSphere services...
docker-compose -f docker-compose-infra.yml down
taskkill /FI "WINDOWTITLE eq auth-service*" /F >nul 2>&1
taskkill /FI "WINDOWTITLE eq post-service*" /F >nul 2>&1
taskkill /FI "WINDOWTITLE eq comment-service*" /F >nul 2>&1
taskkill /FI "WINDOWTITLE eq like-service*" /F >nul 2>&1
taskkill /FI "WINDOWTITLE eq follow-service*" /F >nul 2>&1
taskkill /FI "WINDOWTITLE eq notification-service*" /F >nul 2>&1
taskkill /FI "WINDOWTITLE eq media-service*" /F >nul 2>&1
taskkill /FI "WINDOWTITLE eq search-service*" /F >nul 2>&1
taskkill /FI "WINDOWTITLE eq frontend*" /F >nul 2>&1
echo Done.
pause
