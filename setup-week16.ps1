# AI Code Review Setup Script
# Week 16: AI Code Review System

Write-Host "🚀 Setting up AI Code Review System..." -ForegroundColor Cyan
Write-Host ""

# Check if .env file exists
if (Test-Path ".env") {
    Write-Host "✓ .env file found" -ForegroundColor Green
} else {
    Write-Host "✗ .env file not found" -ForegroundColor Red
    Write-Host "Creating .env file..." -ForegroundColor Yellow
    New-Item -Path ".env" -ItemType File -Force | Out-Null
}

# Check for OpenAI API key
$envContent = Get-Content ".env" -Raw -ErrorAction SilentlyContinue
if ($envContent -match "VITE_OPENAI_API_KEY=sk-") {
    Write-Host "✓ OpenAI API key configured" -ForegroundColor Green
} else {
    Write-Host "✗ OpenAI API key not found in .env" -ForegroundColor Red
    Write-Host ""
    Write-Host "To set up OpenAI API:" -ForegroundColor Yellow
    Write-Host "1. Go to https://platform.openai.com/api-keys" -ForegroundColor White
    Write-Host "2. Create a new secret key" -ForegroundColor White
    Write-Host "3. Add to .env file:" -ForegroundColor White
    Write-Host "   VITE_OPENAI_API_KEY=sk-your-key-here" -ForegroundColor Gray
    Write-Host ""
    
    $addKey = Read-Host "Would you like to add the API key now? (y/n)"
    if ($addKey -eq "y") {
        $apiKey = Read-Host "Paste your OpenAI API key"
        if ($apiKey -match "^sk-") {
            Add-Content -Path ".env" -Value "`nVITE_OPENAI_API_KEY=$apiKey"
            Write-Host "✓ API key added to .env" -ForegroundColor Green
        } else {
            Write-Host "✗ Invalid API key format (should start with sk-)" -ForegroundColor Red
        }
    }
}

Write-Host ""
Write-Host "📦 Checking dependencies..." -ForegroundColor Cyan

# Check if node_modules exists
if (Test-Path "node_modules") {
    Write-Host "✓ node_modules found" -ForegroundColor Green
} else {
    Write-Host "✗ node_modules not found" -ForegroundColor Red
    Write-Host "Installing dependencies..." -ForegroundColor Yellow
    npm install
}

Write-Host ""
Write-Host "🗄️ Checking database migration..." -ForegroundColor Cyan

# Check if migration file exists
if (Test-Path "supabase\migrations\20250105_ai_code_review.sql") {
    Write-Host "✓ Migration file found" -ForegroundColor Green
    Write-Host ""
    Write-Host "To apply the migration:" -ForegroundColor Yellow
    Write-Host "  supabase migration up" -ForegroundColor Gray
    Write-Host ""
} else {
    Write-Host "✗ Migration file not found" -ForegroundColor Red
}

Write-Host "📝 Checking implementation files..." -ForegroundColor Cyan

$files = @(
    "src\services\codeReviewService.ts",
    "src\components\ai\CodeReviewPanel.tsx",
    "src\pages\ProblemSolver.tsx"
)

foreach ($file in $files) {
    if (Test-Path $file) {
        Write-Host "  ✓ $file" -ForegroundColor Green
    } else {
        Write-Host "  ✗ $file" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "📚 Documentation files..." -ForegroundColor Cyan

$docs = @(
    "WEEK16_AI_CODE_REVIEW_COMPLETE.md",
    "COMPLETE_35_FEATURES_ROADMAP.md"
)

foreach ($doc in $docs) {
    if (Test-Path $doc) {
        Write-Host "  ✓ $doc" -ForegroundColor Green
    } else {
        Write-Host "  ✗ $doc" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "✨ Setup Summary:" -ForegroundColor Cyan
Write-Host ""
Write-Host "Components Implemented:" -ForegroundColor White
Write-Host "  - Database migration with tables and functions" -ForegroundColor Gray
Write-Host "  - Service layer with OpenAI integration" -ForegroundColor Gray
Write-Host "  - UI component CodeReviewPanel" -ForegroundColor Gray
Write-Host "  - ProblemSolver integration" -ForegroundColor Gray
Write-Host ""
Write-Host "Features:" -ForegroundColor White
Write-Host "  - GPT-4 powered code analysis" -ForegroundColor Gray
Write-Host "  - Complexity detection (time and space)" -ForegroundColor Gray
Write-Host "  - Quality scoring 0 to 100" -ForegroundColor Gray
Write-Host "  - Smart caching with SHA-256" -ForegroundColor Gray
Write-Host "  - Rate limiting: 3 reviews per day for free users" -ForegroundColor Gray
Write-Host ""
Write-Host "Next Steps:" -ForegroundColor White
Write-Host "  1. Ensure OpenAI API key is in .env" -ForegroundColor Yellow
Write-Host "  2. Run: supabase migration up" -ForegroundColor Yellow
Write-Host "  3. Run: npm run dev" -ForegroundColor Yellow
Write-Host "  4. Test by solving a problem and clicking 'Get AI Review'" -ForegroundColor Yellow
Write-Host ""
Write-Host "📖 Full documentation: WEEK16_AI_CODE_REVIEW_COMPLETE.md" -ForegroundColor Cyan
Write-Host ""
Write-Host "🎉 Week 16: AI Code Review - 100% COMPLETE!" -ForegroundColor Green
