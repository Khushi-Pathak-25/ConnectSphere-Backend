@echo off
echo ============================================
echo  Rebuilding changed services
echo ============================================

echo [1/3] Stopping note: Close running service windows first!
echo.

echo [1/3] Building auth-service...
cd /d D:\ConnectSphere\auth-service
call mvn clean package -DskipTests -q
if %errorlevel% neq 0 ( echo FAILED: auth-service & pause & exit /b 1 )
echo auth-service OK

echo [2/3] Building api-gateway...
cd /d D:\ConnectSphere\api-gateway
call mvn clean package -DskipTests -q
if %errorlevel% neq 0 ( echo FAILED: api-gateway & pause & exit /b 1 )
echo api-gateway OK

echo [3/3] Building media-service...
cd /d D:\ConnectSphere\media-service
call mvn clean package -DskipTests -q
if %errorlevel% neq 0 ( echo FAILED: media-service & pause & exit /b 1 )
echo media-service OK

echo.
echo ============================================
echo  Done! Now run start-all.bat
echo ============================================
pause
