@echo off
echo ============================================
echo  ConnectSphere - Building All Services
echo ============================================

echo.
echo [1/10] Building eureka-server...
cd /d D:\ConnectSphere\eureka-server
call mvn clean package -DskipTests -q
if %errorlevel% neq 0 ( echo FAILED: eureka-server & pause & exit /b 1 )
echo eureka-server - OK

echo.
echo [2/10] Building api-gateway...
cd /d D:\ConnectSphere\api-gateway
call mvn clean package -DskipTests -q
if %errorlevel% neq 0 ( echo FAILED: api-gateway & pause & exit /b 1 )
echo api-gateway - OK

echo.
echo [3/10] Building auth-service...
cd /d D:\ConnectSphere\auth-service
call mvn clean package -DskipTests -q
if %errorlevel% neq 0 ( echo FAILED: auth-service & pause & exit /b 1 )
echo auth-service - OK

echo.
echo [4/10] Building post-service...
cd /d D:\ConnectSphere\post-service
call mvn clean package -DskipTests -q
if %errorlevel% neq 0 ( echo FAILED: post-service & pause & exit /b 1 )
echo post-service - OK

echo.
echo [5/10] Building comment-service...
cd /d D:\ConnectSphere\comment-service
call mvn clean package -DskipTests -q
if %errorlevel% neq 0 ( echo FAILED: comment-service & pause & exit /b 1 )
echo comment-service - OK

echo.
echo [6/10] Building like-service...
cd /d D:\ConnectSphere\like-service
call mvn clean package -DskipTests -q
if %errorlevel% neq 0 ( echo FAILED: like-service & pause & exit /b 1 )
echo like-service - OK

echo.
echo [7/10] Building follow-service...
cd /d D:\ConnectSphere\follow-service
call mvn clean package -DskipTests -q
if %errorlevel% neq 0 ( echo FAILED: follow-service & pause & exit /b 1 )
echo follow-service - OK

echo.
echo [8/10] Building notification-service...
cd /d D:\ConnectSphere\notification-service
call mvn clean package -DskipTests -q
if %errorlevel% neq 0 ( echo FAILED: notification-service & pause & exit /b 1 )
echo notification-service - OK

echo.
echo [9/10] Building media-service...
cd /d D:\ConnectSphere\media-service
call mvn clean package -DskipTests -q
if %errorlevel% neq 0 ( echo FAILED: media-service & pause & exit /b 1 )
echo media-service - OK

echo.
echo [10/10] Building search-service...
cd /d D:\ConnectSphere\search-service
call mvn clean package -DskipTests -q
if %errorlevel% neq 0 ( echo FAILED: search-service & pause & exit /b 1 )
echo search-service - OK

echo.
echo [11/11] Building payment-service...
cd /d D:\ConnectSphere\payment-service
call mvn clean package -DskipTests -q
if %errorlevel% neq 0 ( echo FAILED: payment-service & pause & exit /b 1 )
echo payment-service - OK

echo.
echo ============================================
echo  ALL SERVICES BUILT SUCCESSFULLY!
echo  Now run start-all.bat to start everything.
echo ============================================
pause
