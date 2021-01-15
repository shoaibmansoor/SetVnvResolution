#!/usr/bin/env node

'use strict';

const { execSync, spawn } = require('child_process')
const path = require('path')

function main() {
    let globalPath = execSync("npm root -g").toString().trim();

    const ps1_path = `${globalPath.trim()}/set-vnc-server-resolution/bin/SetHeadlessVncResolution.ps1`;
    const child = spawn("powershell.exe",[path.resolve(ps1_path)]);
    child.stdout.on("data",function(data){
        console.log("Powershell Data: " + data);
    });
    child.stderr.on("data",function(data){
        console.log("Powershell Errors: " + data);
    });
    child.on("exit",function(){
        console.log("Powershell Script finished");
    });
    child.stdin.end()
}

return main();