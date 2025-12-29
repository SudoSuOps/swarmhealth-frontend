#!/bin/bash
# new-post.sh - Create a new SwarmHealth blog post
#
# Usage: ./new-post.sh "My Post Title"
#
# This will:
# 1. Create a new HTML file from the template
# 2. Set the title, date, and slug
# 3. Open it for editing

set -e

# Colors
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Check for title
if [ -z "$1" ]; then
    echo "Usage: ./new-post.sh \"Your Post Title\""
    echo ""
    echo "Example: ./new-post.sh \"The 3am Blood Sugar Crash\""
    exit 1
fi

TITLE="$1"
DATE=$(date +%Y-%m-%d)
DISPLAY_DATE=$(date +"%B %d, %Y")

# Create slug from title (lowercase, hyphens, no special chars)
SLUG=$(echo "$TITLE" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-//' | sed 's/-$//')

FILENAME="${DATE}-${SLUG}.html"
TEMPLATE_PATH="templates/post-template.html"
OUTPUT_PATH="${FILENAME}"

echo ""
echo -e "${GREEN}📝 Creating new blog post...${NC}"
echo ""
echo "   Title: $TITLE"
echo "   Date:  $DISPLAY_DATE"
echo "   Slug:  $SLUG"
echo "   File:  $FILENAME"
echo ""

# Check if template exists
if [ ! -f "$TEMPLATE_PATH" ]; then
    echo "❌ Template not found at $TEMPLATE_PATH"
    echo "   Make sure you're in the blog directory"
    exit 1
fi

# Check if file already exists
if [ -f "$OUTPUT_PATH" ]; then
    echo "⚠️  File already exists: $OUTPUT_PATH"
    read -p "   Overwrite? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Copy template and replace placeholders
cp "$TEMPLATE_PATH" "$OUTPUT_PATH"

# Replace placeholders
sed -i "s/POST_TITLE/$TITLE/g" "$OUTPUT_PATH"
sed -i "s/POST_DATE/$DISPLAY_DATE/g" "$OUTPUT_PATH"
sed -i "s/POST_SLUG/$SLUG/g" "$OUTPUT_PATH"
sed -i "s/POST_READ_TIME/5/g" "$OUTPUT_PATH"
sed -i "s/POST_DESCRIPTION/A personal story about living with diabetes./g" "$OUTPUT_PATH"

echo -e "${GREEN}✅ Created: $OUTPUT_PATH${NC}"
echo ""
echo "Next steps:"
echo "1. Edit $OUTPUT_PATH and write your post"
echo "2. Upload to swarmhealth.io/blog/"
echo "3. Update blog/index.html"
echo "4. Share on Reddit & Twitter"
echo ""
echo "URL will be: https://swarmhealth.io/blog/$SLUG"
echo ""
echo -e "${GREEN}💚 Be real. Run the rails.${NC}"
