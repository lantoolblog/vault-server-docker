@echo off

echo =============================================
echo  Vault Docker Compose 배포 스크립트 (Windows)
echo =============================================

echo [1/3] 기존 컨테이너 및 네트워크 정지 중...
docker compose down
if %errorlevel% neq 0 (
    echo [경고] 기존에 실행 중인 컨테이너가 없거나 down 중 오류가 발생했습니다. 계속 진행합니다.
)

echo.
echo [2/3] 새롭게 이미지 빌드 및 백그라운드 가동 중...
docker compose up -d --build
if %errorlevel% neq 0 (
    echo [에러] docker compose up 실패! 배포를 중단합니다.
    pause
    exit /b %errorlevel%
)

echo.
echo [3/3] 이름 없는 찌꺼기(Dangling) 이미지 청소 중...
docker image prune -f

echo.
echo ==========================================
echo  배포가 성공적으로 완료되었습니다!
echo ==========================================
pause