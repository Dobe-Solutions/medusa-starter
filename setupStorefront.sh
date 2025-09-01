#!/bin/bash
git clone https://github.com/medusajs/nextjs-starter-medusa
cd nextjs-starter-medusa || exit
npm install
mv .env.template .env.local
