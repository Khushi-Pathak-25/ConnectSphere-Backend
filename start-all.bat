@echo off
echo ============================================
echo  ConnectSphere - Starting All Services
echo ============================================

echo.
echo [0/5] Starting Docker infrastructure...
docker compose -f docker-compose-infra.yml up -d
echo Waiting 15 seconds for MySQL to be ready...
timeout /t 15 /nobreak > nul

echo Granting MySQL access...
docker exec cs_mysql mysql -uroot -proot -e "CREATE USER IF NOT EXISTS 'root'@'%%' IDENTIFIED WITH mysql_native_password BY 'Khushi@8251082191'; GRANT ALL PRIVILEGES ON *.* TO 'root'@'%%' WITH GRANT OPTION; FLUSH PRIVILEGES;" 2>nul
echo MySQL ready.

echo.
echo [1/5] Starting Eureka Server...
start "1-EUREKA" cmd /k "cd /d D:\ConnectSphere\eureka-server && java -jar target\eureka-server-1.0.0.jar"
echo Waiting 20 seconds for Eureka to be ready...
timeout /t 20 /nobreak > nul

echo.
echo [2/5] Starting API Gateway...
start "2-GATEWAY" cmd /k "cd /d D:\ConnectSphere\api-gateway && java -jar target\api-gateway-1.0.0.jar"
echo Waiting 15 seconds for Gateway to be ready...
timeout /t 15 /nobreak > nul

echo.
echo [3/5] Starting Auth Service...
start "3-AUTH" cmd /k "cd /d D:\ConnectSphere\auth-service && java -jar target\auth-service-1.0.0.jar"
timeout /t 8 /nobreak > nul

echo Starting Post Service...
start "4-POST" cmd /k "cd /d D:\ConnectSphere\post-service && java -jar target\post-service-1.0.0.jar"
timeout /t 5 /nobreak > nul

echo Starting Comment Service...
start "5-COMMENT" cmd /k "cd /d D:\ConnectSphere\comment-service && java -jar target\comment-service-1.0.0.jar"
timeout /t 5 /nobreak > nul

echo Starting Like Service...
start "6-LIKE" cmd /k "cd /d D:\ConnectSphere\like-service && java -jar target\like-service-1.0.0.jar"
timeout /t 5 /nobreak > nul

echo Starting Follow Service...
start "7-FOLLOW" cmd /k "cd /d D:\ConnectSphere\follow-service && java -jar target\follow-service-1.0.0.jar"
timeout /t 5 /nobreak > nul

echo Starting Notification Service...
start "8-NOTIFICATION" cmd /k "cd /d D:\ConnectSphere\notification-service && java -jar target\notification-service-1.0.0.jar"
timeout /t 5 /nobreak > nul

echo Starting Media Service...
start "9-MEDIA" cmd /k "cd /d D:\ConnectSphere\media-service && java -jar target\media-service-1.0.0.jar"
timeout /t 5 /nobreak > nul

echo Starting Search Service...
start "10-SEARCH" cmd /k "cd /d D:\ConnectSphere\search-service && java -jar target\search-service-1.0.0.jar"
timeout /t 5 /nobreak > nul

echo Starting Payment Service...
start "11-PAYMENT" cmd /k "cd /d D:\ConnectSphere\payment-service && java -jar target\payment-service-1.0.0.jar"
timeout /t 8 /nobreak > nul

echo.
echo [4/5] Starting React Frontend...
start "12-FRONTEND" cmd /k "cd /d D:\ConnectSphere\frontend && npm start"

echo.
echo ============================================
echo  All services started!
echo  Wait 2-3 minutes for everything to load.
echo ============================================
echo.
echo  CHECK THESE URLS AFTER 3 MINUTES:
echo.
echo  Eureka Dashboard : http://localhost:8761
echo  API Gateway      : http://localhost:8080/actuator/health
echo  Frontend         : http://localhost:3000
echo ============================================
pause
