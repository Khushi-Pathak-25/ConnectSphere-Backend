@echo off
echo ============================================
echo  ConnectSphere - Starting All Services
echo ============================================

echo.
echo Loading environment variables...
for /f "tokens=1,2 delims==" %%a in (.env) do (
    if not "%%a"=="" if not "%%a:~0,1%"=="#" set "%%a=%%b"
)

echo.
echo [0/5] Starting Docker infrastructure...
docker compose -f docker-compose-infra.yml up -d
echo Waiting 20 seconds for MySQL to be ready...
timeout /t 20 /nobreak > nul

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
echo [3/5] Starting Microservices...
start "3-AUTH" cmd /k "cd /d D:\ConnectSphere\auth-service && java -DMAIL_USERNAME=%MAIL_USERNAME% -DMAIL_PASSWORD=%MAIL_PASSWORD% -DGOOGLE_CLIENT_ID=%GOOGLE_CLIENT_ID% -DGOOGLE_CLIENT_SECRET=%GOOGLE_CLIENT_SECRET% -DOAUTH2_REDIRECT_URI=%OAUTH2_REDIRECT_URI% -DDB_URL=%DB_URL% -DDB_USERNAME=%DB_USERNAME% -DDB_PASSWORD=%DB_PASSWORD% -DJWT_SECRET=%JWT_SECRET% -DJWT_EXPIRATION=%JWT_EXPIRATION% -DFRONTEND_URL=%FRONTEND_URL% -DEUREKA_URL=%EUREKA_URL% -jar target\auth-service-1.0.0.jar"
timeout /t 8 /nobreak > nul

start "4-POST" cmd /k "cd /d D:\ConnectSphere\post-service && java -DDB_URL=jdbc:mysql://localhost:3306/postdb?createDatabaseIfNotExist=true^&useSSL=false^&allowPublicKeyRetrieval=true -DDB_USERNAME=root -DDB_PASSWORD=root -DJWT_SECRET=%JWT_SECRET% -DEUREKA_URL=%EUREKA_URL% -jar target\post-service-1.0.0.jar"
timeout /t 5 /nobreak > nul

start "5-COMMENT" cmd /k "cd /d D:\ConnectSphere\comment-service && java -DDB_URL=jdbc:mysql://localhost:3306/commentdb?createDatabaseIfNotExist=true^&useSSL=false^&allowPublicKeyRetrieval=true -DDB_USERNAME=root -DDB_PASSWORD=root -DEUREKA_URL=%EUREKA_URL% -jar target\comment-service-1.0.0.jar"
timeout /t 5 /nobreak > nul

start "6-LIKE" cmd /k "cd /d D:\ConnectSphere\like-service && java -DDB_URL=jdbc:mysql://localhost:3306/likedb?createDatabaseIfNotExist=true^&useSSL=false^&allowPublicKeyRetrieval=true -DDB_USERNAME=root -DDB_PASSWORD=root -DEUREKA_URL=%EUREKA_URL% -jar target\like-service-1.0.0.jar"
timeout /t 5 /nobreak > nul

start "7-FOLLOW" cmd /k "cd /d D:\ConnectSphere\follow-service && java -DDB_URL=jdbc:mysql://localhost:3306/followdb?createDatabaseIfNotExist=true^&useSSL=false^&allowPublicKeyRetrieval=true -DDB_USERNAME=root -DDB_PASSWORD=root -DEUREKA_URL=%EUREKA_URL% -jar target\follow-service-1.0.0.jar"
timeout /t 5 /nobreak > nul

start "8-NOTIFICATION" cmd /k "cd /d D:\ConnectSphere\notification-service && java -DDB_URL=jdbc:mysql://localhost:3306/notificationdb?createDatabaseIfNotExist=true^&useSSL=false^&allowPublicKeyRetrieval=true -DDB_USERNAME=root -DDB_PASSWORD=root -DEUREKA_URL=%EUREKA_URL% -jar target\notification-service-1.0.0.jar"
timeout /t 5 /nobreak > nul

start "9-MEDIA" cmd /k "cd /d D:\ConnectSphere\media-service && java -DDB_URL=jdbc:mysql://localhost:3306/mediadb?createDatabaseIfNotExist=true^&useSSL=false^&allowPublicKeyRetrieval=true -DDB_USERNAME=root -DDB_PASSWORD=root -DEUREKA_URL=%EUREKA_URL% -jar target\media-service-1.0.0.jar"
timeout /t 5 /nobreak > nul

start "10-SEARCH" cmd /k "cd /d D:\ConnectSphere\search-service && java -DDB_URL=jdbc:mysql://localhost:3306/searchdb?createDatabaseIfNotExist=true^&useSSL=false^&allowPublicKeyRetrieval=true -DDB_USERNAME=root -DDB_PASSWORD=root -DEUREKA_URL=%EUREKA_URL% -jar target\search-service-1.0.0.jar"
timeout /t 5 /nobreak > nul

start "11-PAYMENT" cmd /k "cd /d D:\ConnectSphere\payment-service && java -DDB_URL=jdbc:mysql://localhost:3306/paymentdb?createDatabaseIfNotExist=true^&useSSL=false^&allowPublicKeyRetrieval=true -DDB_USERNAME=root -DDB_PASSWORD=root -DEUREKA_URL=%EUREKA_URL% -jar target\payment-service-1.0.0.jar"
timeout /t 8 /nobreak > nul

echo.
echo [4/5] Starting React Frontend...
start "12-FRONTEND" cmd /k "cd /d D:\ConnectSphere\frontend && npm start"

echo.
echo ============================================
echo  All services started!
echo  Wait 3-4 minutes for everything to load.
echo ============================================
echo.
echo  CHECK THESE URLS AFTER 4 MINUTES:
echo.
echo  Eureka Dashboard : http://localhost:8761
echo  API Gateway      : http://localhost:8080/actuator/health
echo  Frontend         : http://localhost:3000
echo  Swagger (Auth)   : http://localhost:8081/swagger-ui/index.html
echo ============================================
pause
