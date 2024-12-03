@echo off

REM Create directories if they don't exist
mkdir public\vercel 2>nul
mkdir public\cloudflare 2>nul
mkdir public\netlify 2>nul
mkdir public\github 2>nul

REM Initialize Vercel deployment
echo Setting up Vercel...
hugo --baseURL https://blog.050623.xyz/ --destination public\vercel
cd public\vercel
if not exist .git (
    git init
    git remote add origin https://github.com/KiritoXDone/KiritoXDone.github.io.git
)
git checkout -b vercel
git add .
git commit -m "update vercel %date% %time%" --allow-empty
git push -u origin vercel
cd ..\..

REM Initialize Cloudflare deployment
echo Setting up Cloudflare...
hugo --baseURL https://cf.050623.xyz/ --destination public\cloudflare
cd public\cloudflare
if not exist .git (
    git init
    git remote add origin https://github.com/KiritoXDone/KiritoXDone.github.io.git
)
git checkout -b cloudflare
git add .
git commit -m "update cloudflare %date% %time%" --allow-empty
git push -u origin cloudflare
cd ..\..

REM Initialize Netlify deployment
echo Setting up Netlify...
hugo --baseURL https://nl.050623.xyz/ --destination public\netlify
cd public\netlify
if not exist .git (
    git init
    git remote add origin https://github.com/KiritoXDone/KiritoXDone.github.io.git
)
git checkout -b netlify
git add .
git commit -m "update netlify %date% %time%" --allow-empty
git push -u origin netlify
cd ..\..

REM Initialize GitHub Pages deployment
echo Setting up GitHub Pages...
hugo --baseURL https://kiritoxdone.github.io/ --destination public\github
cd public\github
if not exist .git (
    git init
    git remote add origin https://github.com/KiritoXDone/KiritoXDone.github.io.git
)
git checkout -b main
git add .
git commit -m "update github pages %date% %time%" --allow-empty
git push -u origin main
cd ..\..

echo Deployment complete!
