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
    ["qrphoto-microservices/services/auth-service"]="dotnet microservices"
    ["qrphoto-microservices/services/license-service"]="dotnet microservices"
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

    # .claude/rules/ → Claude Code tarafindan OTOMATIK yuklenir
    local RULES_TARGET="$PROJECT_PATH/.claude/rules"

    # Onceki standart dosyalarini temizle (standards- prefix ile ayirt et)
    mkdir -p "$RULES_TARGET"
    rm -f "$RULES_TARGET"/standards-*.md

    # Global kurallari kopyala (her dosyayi standards- prefix ile)
    if [ -d "$STANDARDS_DIR/global/rules" ]; then
        for file in "$STANDARDS_DIR/global/rules/"*.md; do
            [ -f "$file" ] || continue
            local basename=$(basename "$file")
            cp "$file" "$RULES_TARGET/standards-global-$basename"
        done
    fi
    # Global CLAUDE.md'yi de rule olarak kopyala
    cp "$STANDARDS_DIR/global/CLAUDE.md" "$RULES_TARGET/standards-global.md"

    # Teknoloji-bazli kurallari kopyala
    IFS=' ' read -ra TECH_ARRAY <<< "$techs"
    for tech in "${TECH_ARRAY[@]}"; do
        if [ -d "$STANDARDS_DIR/$tech" ]; then
            # Ana CLAUDE.md
            if [ -f "$STANDARDS_DIR/$tech/CLAUDE.md" ]; then
                cp "$STANDARDS_DIR/$tech/CLAUDE.md" "$RULES_TARGET/standards-$tech.md"
            fi
            # rules/ altindaki dosyalar
            if [ -d "$STANDARDS_DIR/$tech/rules" ]; then
                for file in "$STANDARDS_DIR/$tech/rules/"*.md; do
                    [ -f "$file" ] || continue
                    local basename=$(basename "$file")
                    cp "$file" "$RULES_TARGET/standards-$tech-$basename"
                done
                # editorconfig gibi md olmayan dosyalar
                for file in "$STANDARDS_DIR/$tech/rules/"*; do
                    [ -f "$file" ] || continue
                    [[ "$file" == *.md ]] && continue
                    local basename=$(basename "$file")
                    cp "$file" "$RULES_TARGET/standards-$tech-$basename"
                done
            fi
        fi
    done

    # Eski .claude/standards/ dizinini temizle (artik kullanilmiyor)
    rm -rf "$PROJECT_PATH/.claude/standards"

    local file_count=$(ls -1 "$RULES_TARGET"/standards-* 2>/dev/null | wc -l)
    echo -e "${GREEN}✅ $project${NC} synced → .claude/rules/ (${BLUE}$file_count dosya${NC}, techs: $techs)"
}

show_status() {
    echo ""
    echo -e "${BLUE}📋 Sync Durumu${NC}"
    echo "================================"

    for project in "${!PROJECT_TECHS[@]}"; do
        local PROJECT_PATH="$PROJECTS_DIR/$project"
        local RULES_TARGET="$PROJECT_PATH/.claude/rules"

        if [ ! -d "$PROJECT_PATH" ]; then
            echo -e "  ${YELLOW}⚠️  $project${NC} - Proje dizini yok"
        elif ! ls "$RULES_TARGET"/standards-* &>/dev/null; then
            echo -e "  ❌ $project - Standards yok (sync gerekli)"
        else
            local file_count=$(ls -1 "$RULES_TARGET"/standards-* 2>/dev/null | wc -l)
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
