# Phase 1 Week 1 Setup Script (PowerShell)
# This script helps you set up Judge0 code execution

Write-Host "🚀 Babua Dojo - Phase 1 Week 1 Setup" -ForegroundColor Green
Write-Host "======================================" -ForegroundColor Green
Write-Host ""

# Check if .env exists
if (Test-Path .env) {
    Write-Host "✅ .env file already exists" -ForegroundColor Green
} else {
    Write-Host "📝 Creating .env file from .env.example..." -ForegroundColor Yellow
    Copy-Item .env.example .env
    Write-Host "✅ .env file created" -ForegroundColor Green
}

Write-Host ""
Write-Host "📋 Next Steps:" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. Get your Judge0 API key:" -ForegroundColor White
Write-Host "   → Visit: https://rapidapi.com/judge0-official/api/judge0-ce" -ForegroundColor Gray
Write-Host "   → Click 'Subscribe to Test'" -ForegroundColor Gray
Write-Host "   → Choose a plan (Basic is FREE - 50 requests/day)" -ForegroundColor Gray
Write-Host "   → Copy your API key" -ForegroundColor Gray
Write-Host ""
Write-Host "2. Add API key to .env file:" -ForegroundColor White
Write-Host "   → Open .env in your editor" -ForegroundColor Gray
Write-Host "   → Find VITE_JUDGE0_API_KEY=" -ForegroundColor Gray
Write-Host "   → Paste your API key" -ForegroundColor Gray
Write-Host ""
Write-Host "3. Restart the dev server:" -ForegroundColor White
Write-Host "   → Stop current server (Ctrl+C)" -ForegroundColor Gray
Write-Host "   → Run: npm run dev" -ForegroundColor Gray
Write-Host ""
Write-Host "4. Test it:" -ForegroundColor White
Write-Host "   → Go to any problem" -ForegroundColor Gray
Write-Host "   → Write code and click 'Run Tests'" -ForegroundColor Gray
Write-Host "   → See REAL execution results!" -ForegroundColor Gray
Write-Host ""
Write-Host "📖 Read PHASE1_WEEK1_COMPLETE.md for full documentation" -ForegroundColor Cyan
Write-Host ""

# Open RapidAPI in browser
$openBrowser = Read-Host "Would you like to open RapidAPI Judge0 page now? (Y/N)"
if ($openBrowser -eq "Y" -or $openBrowser -eq "y") {
    Start-Process "https://rapidapi.com/judge0-official/api/judge0-ce"
}
