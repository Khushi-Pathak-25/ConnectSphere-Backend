@echo off
echo ============================================
echo   ConnectSphere - SonarQube Analysis
echo ============================================
echo.
echo Step 1: Running tests with coverage...
call mvn clean verify -DskipTests=false
echo.
echo Step 2: Running SonarQube analysis...
echo Make sure SonarQube is running at http://localhost:9000
echo.
call mvn sonar:sonar ^
  -Dsonar.projectKey=connectsphere ^
  -Dsonar.projectName=ConnectSphere ^
  -Dsonar.host.url=http://localhost:9000 ^
  -Dsonar.token=%SONAR_TOKEN%
echo.
echo Done! Open http://localhost:9000 to see results.
pause
