@echo off
echo ============================================
echo  Rebuilding ALL services (CORS fix)
echo ============================================

echo [1/10] auth-service...
cd /d D:\ConnectSphere\auth-service
call mvn clean package -DskipTests -q
if %errorlevel% neq 0 ( echo FAILED: auth-service & pause & exit /b 1 )
echo OK

echo [2/10] post-service...
cd /d D:\ConnectSphere\post-service
call mvn clean package -DskipTests -q
if %errorlevel% neq 0 ( echo FAILED: post-service & pause & exit /b 1 )
echo OK

echo [3/10] comment-service...
cd /d D:\ConnectSphere\comment-service
call mvn clean package -DskipTests -q
if %errorlevel% neq 0 ( echo FAILED: comment-service & pause & exit /b 1 )
echo OK

echo [4/10] like-service...
cd /d D:\ConnectSphere\like-service
call mvn clean package -DskipTests -q
if %errorlevel% neq 0 ( echo FAILED: like-service & pause & exit /b 1 )
echo OK

echo [5/10] follow-service...
cd /d D:\ConnectSphere\follow-service
call mvn clean package -DskipTests -q
if %errorlevel% neq 0 ( echo FAILED: follow-service & pause & exit /b 1 )
echo OK

echo [6/10] notification-service...
cd /d D:\ConnectSphere\notification-service
call mvn clean package -DskipTests -q
if %errorlevel% neq 0 ( echo FAILED: notification-service & pause & exit /b 1 )
echo OK

echo [7/10] media-service...
cd /d D:\ConnectSphere\media-service
call mvn clean package -DskipTests -q
if %errorlevel% neq 0 ( echo FAILED: media-service & pause & exit /b 1 )
echo OK

echo [8/10] search-service...
cd /d D:\ConnectSphere\search-service
call mvn clean package -DskipTests -q
if %errorlevel% neq 0 ( echo FAILED: search-service & pause & exit /b 1 )
echo OK

echo [9/10] eureka-server...
cd /d D:\ConnectSphere\eureka-server
call mvn clean package -DskipTests -q
if %errorlevel% neq 0 ( echo FAILED: eureka-server & pause & exit /b 1 )
echo OK

echo [10/10] api-gateway...
cd /d D:\ConnectSphere\api-gateway
call mvn clean package -DskipTests -q
if %errorlevel% neq 0 ( echo FAILED: api-gateway & pause & exit /b 1 )
echo OK

echo.
echo ============================================
echo  ALL BUILT SUCCESSFULLY!
echo  Now run start-all.bat
echo ============================================
pause
