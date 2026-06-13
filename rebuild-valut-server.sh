#!/bin/sh
set -e

# 컴포즈가 관리하던 기존 컨테이너와 네트워크를 안전하게 정지 및 삭제
docker compose down || true

# 새롭게 빌드하고 백그라운드 실행
docker compose up -d --build

# 찌꺼기 이미지 청소
docker image prune -f