#!/bin/bash
# 华水专业认知助手 - GitHub Pages 部署脚本
set -e

USER="ZYP1564"
REPO="ncwu-major-guide"
DIR="/c/Users/16650/Desktop/ncwu-major-guide"

# Token 从环境变量获取，不再硬编码
if [ -z "$GITHUB_TOKEN" ]; then
  echo "请先设置 GITHUB_TOKEN 环境变量："
  echo "  export GITHUB_TOKEN=ghp_xxxxxxxxxxxx"
  exit 1
fi
TOKEN="$GITHUB_TOKEN"

echo "==> 创建 GitHub 仓库..."
curl -s -u "$USER:$TOKEN" https://api.github.com/user/repos -d "{\"name\":\"$REPO\"}" > /dev/null
echo "仓库已创建: github.com/$USER/$REPO"

echo "==> 配置 Git..."
cd "$DIR"
git remote remove origin 2>/dev/null || true
git remote add origin "https://$USER:$TOKEN@github.com/$USER/$REPO.git"
git branch -M main

echo "==> 推送到 GitHub..."
git push -u origin main

echo "==> 开启 GitHub Pages..."
curl -s -u "$USER:$TOKEN" -X POST "https://api.github.com/repos/$USER/$REPO/pages" -d '{"source":{"branch":"main","path":"/"}}' > /dev/null

echo ""
echo "✅ 部署完成！你的网站地址："
echo "   https://$USER.github.io/$REPO/"
echo ""
echo "（GitHub Pages 需要 1-2 分钟生效，稍等片刻即可访问）"
