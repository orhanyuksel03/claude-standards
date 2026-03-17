#!/bin/bash
# =============================================================================
# Claude Standards Sync Script
# Merkezi standartlari D:\projects\ altindaki projelere dagitir.
#
# Kullanim:
#   ./sync.sh          → Tum projelere dagit
#   ./sync.sh pull      → Merkezi repodan pull yap, sonra dagit
#   ./sync.sh status    → Hangi projelerin sync durumunu goster
# =============================================================================

set -e

STANDARDS_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECTS_DIR="D:/projects"

# Proje → teknoloji eslestirmesi
# Yeni proje eklemek icin buraya bir satir ekleyin
declare -A PROJECT_TECHS=(
    ["qrphoto-microservices"]="dotnet microservices"
    ["confighub"]="dotnet"
    ["qrphoto-frontend"]="react"
    ["confighub-admin"]="react"
)

# Renkli output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

sync_project() {
    local project=$1
    local techs=$2
    local PROJECT_PATH="$PROJECTS_DIR/$project"

    if [ ! -d "$PROJECT_PATH" ]; then
        echo -e "${YELLOW}⚠️  $project dizini bulunamadi, atlaniyor${NC}"
        return
    fi

    local TARGET="$PROJECT_PATH/.claude/standards"

    # Onceki standards'i temizle ve yeniden olustur
    rm -rf "$TARGET"
    mkdir -p "$TARGET"

    # Global kurallari kopyala
    mkdir -p "$TARGET/global"
    cp "$STANDARDS_DIR/global/CLAUDE.md" "$TARGET/global/CLAUDE.md"
    if [ -d "$STANDARDS_DIR/global/rules" ]; then
        cp -r "$STANDARDS_DIR/global/rules/" "$TARGET/global/rules/"
    fi

    # Teknoloji-bazli kurallari kopyala
    IFS=' ' read -ra TECH_ARRAY <<< "$techs"
    for tech in "${TECH_ARRAY[@]}"; do
        if [ -d "$STANDARDS_DIR/$tech" ]; then
            mkdir -p "$TARGET/$tech"
            cp "$STANDARDS_DIR/$tech/CLAUDE.md" "$TARGET/$tech/CLAUDE.md" 2>/dev/null || true
            if [ -d "$STANDARDS_DIR/$tech/rules" ]; then
                cp -r "$STANDARDS_DIR/$tech/rules/" "$TARGET/$tech/rules/"
            fi
        fi
    done

    echo -e "${GREEN}✅ $project${NC} synced (${BLUE}$techs${NC})"
}

show_status() {
    echo ""
    echo -e "${BLUE}📋 Sync Durumu${NC}"
    echo "================================"

    for project in "${!PROJECT_TECHS[@]}"; do
        local PROJECT_PATH="$PROJECTS_DIR/$project"
        local TARGET="$PROJECT_PATH/.claude/standards"

        if [ ! -d "$PROJECT_PATH" ]; then
            echo -e "  ${YELLOW}⚠️  $project${NC} - Proje dizini yok"
        elif [ ! -d "$TARGET" ]; then
            echo -e "  ❌ $project - Standards yok (sync gerekli)"
        else
            local file_count=$(find "$TARGET" -type f | wc -l)
            echo -e "  ${GREEN}✅ $project${NC} - $file_count dosya (${PROJECT_TECHS[$project]})"
        fi
    done

    echo "================================"
}

# Ana akis
case "${1:-sync}" in
    "pull")
        echo -e "${BLUE}📥 Merkezi repodan pull yapiliyor...${NC}"
        cd "$STANDARDS_DIR"
        git pull origin main 2>/dev/null || git pull origin master 2>/dev/null || echo "Pull basarisiz (remote ayarli mi?)"
        echo ""
        echo -e "${BLUE}🔄 Projelere dagitiliyor...${NC}"
        for project in "${!PROJECT_TECHS[@]}"; do
            sync_project "$project" "${PROJECT_TECHS[$project]}"
        done
        ;;

    "status")
        show_status
        ;;

    "sync"|*)
        echo -e "${BLUE}🔄 Standartlar dagitiliyor...${NC}"
        echo ""

        for project in "${!PROJECT_TECHS[@]}"; do
            sync_project "$project" "${PROJECT_TECHS[$project]}"
        done

        echo ""
        echo -e "${GREEN}🎉 Tum projeler guncellendi!${NC}"
        show_status
        ;;
esac
