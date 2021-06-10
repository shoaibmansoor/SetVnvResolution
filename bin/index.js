#!/usr/bin/env node

'use strict';

const { execSync, spawn } = require('child_process')
const path = require('path')
const minimist = require('minimist');

const helpMessage = `
   -h, --height: To set height of vnc server [default: 1080] (optional)
   -w, --width: To set width of vnc server [default: 1920] (optional)
   --help: To get help messages`;

function processArgs() {
    const args = minimist(process.argv.slice(2), {
        string: [ 'width' ],
        string: [ 'height' ],
        boolean: [ 'help' ],
        alias: { h: 'height', w: 'width' },
        default: { width: '1920', height: '1080' },
        stopEarly: true,
        unknown: function (d) { throw new Error(
            `Unkown argument: ${d}\nSupported arguments are:\n${helpMessage}` )
        }
    });

    if (args.help){
        console.log('\x1b[32m%s\x1b[0m', helpMessage);
        process.exit(0);
    }

    if (!args.w) {
        throw new Error('width cannot be 0');
    }

    if (!args.h) {
        throw new Error('height cannot be 0');
    }
    return args;
}

function main() {
    const args = processArgs();
    let globalPath = execSync("npm root -g").toString().trim();
    const ps1_path = `${globalPath.trim()}/set-vnc-server-resolution/bin/SetHeadlessVncResolution.ps1`;
    
    const powershellArgs = [path.resolve(ps1_path)]
    powershellArgs.push(`-w=${args.w}`);
    powershellArgs.push(`-h=${args.h}`);

    const child = spawn("powershell.exe", powershellArgs);
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