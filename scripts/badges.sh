#!/bin/sh
# Downloads the tech stack badges into assets/stack/ so the README serves them
# from this repository instead of hotlinking shields.io on every view.
#
# Run it after editing the list below, then commit the SVGs:
#   sh scripts/badges.sh
#
# Format: file|label|background|logo|logo color
# Logo is a Simple Icons name (https://simpleicons.org, lowercase, no spaces)
# or, for tools Simple Icons lacks, a file in assets/logos/ that is embedded
# in the badge as an image; logo color does not apply to those.
set -eu

cd "$(dirname "$0")/.."
out=assets/stack
mkdir -p "$out"

while IFS='|' read -r file label color logo logo_color; do
  [ -z "$file" ] && continue
  label_enc=$(printf '%s' "$label" | sed 's/ /%20/g')
  if [ -f "assets/logos/$logo" ]; then
    # Percent-encode the base64 characters that are special in a query string.
    data=$(base64 -w0 "assets/logos/$logo" | sed 's/+/%2B/g; s/\//%2F/g; s/=/%3D/g')
    logo="data:image/png;base64,$data"
  fi
  curl -fsS -o "$out/$file.svg" \
    "https://img.shields.io/badge/${label_enc}-${color}?style=flat-square&logo=${logo}&logoColor=${logo_color}"
  echo "$out/$file.svg"
done <<'EOF'
google-cloud|Google Cloud|4285F4|googlecloud|white
kubernetes|Kubernetes|326CE5|kubernetes|white
helm|Helm|0F1689|helm|white
kustomize|Kustomize|3E5FA8|kustomize.png|white
docker|Docker|2496ED|docker|white
cloud-run|Cloud Run|4285F4|googlecloud|white
terraform|Terraform|844FBA|terraform|white
opentofu|OpenTofu|FFDA18|opentofu|black
pulumi|Pulumi|8A3391|pulumi|white
argo-cd|Argo CD|EF7B4D|argo|white
tekton|Tekton|FD495C|tekton|white
github-actions|GitHub Actions|2088FF|githubactions|white
python|Python|3776AB|python|white
go|Go|00ADD8|go|white
typescript|TypeScript|3178C6|typescript|white
fastapi|FastAPI|009688|fastapi|white
react|React|20232A|react|61DAFB
postgresql|PostgreSQL|4169E1|postgresql|white
mysql|MySQL|4479A1|mysql|white
bigquery|BigQuery|669DF6|googlebigquery|white
redis|Redis|FF4438|redis|white
EOF
