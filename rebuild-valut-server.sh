#!/bin/sh
set -e

# 💡 필수 키 파일이 없으면 도커 컴포즈를 실행하지 않고 안전하게 차단
if [ ! -f "./unseal-keys.properties" ]; then
    echo "❌ [에러] 필수 파일이 없습니다: ./unseal-keys.properties"
    echo "자동 Unseal을 위해 키 파일을 먼저 생성해 주세요."
    exit 1
fi

echo "🚀 [1/3] 기존 Vault 컨테이너 및 네트워크 정지 중..."
docker compose down || true

echo "🐳 [2/3] 새롭게 이미지 빌드 및 백그라운드 가동 중..."
docker compose up -d --build

echo "🧹 [3/3] 이름 없는 찌꺼기(Dangling) 이미지 청소 중..."
docker image prune -f

echo "✅ 배포 및 자동 Unseal 환경 구축 완료!"
