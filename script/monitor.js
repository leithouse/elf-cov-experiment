#!/usr/bin/node

const HOURS = 4;

const {CORES,OUTPUT,WHATSUP} = process.env;
if(!CORES || !OUTPUT || !WHATSUP) {
  console.error("Must have CORES, OUTPUT and WHATSUP defined");
  process.exit(1);
}
const TOTAL_TIME = HOURS * 60 * 60000, // 8 hours
        CHK_MINS = 5, // 5 minutes
        CHK_TIME = CHK_MINS * 60000, 
       CHK_INTVL = CHK_TIME / CORES;

const {execSync} = require('child_process'),
             fsp = require('fs').promises,
            path = require('path'),
              rl = require('readline').createInterface({
                input: process.stdin,
                output:process.stdout
              });

const parseStats = (stats)=>{
  let parsed = {};
  stats.trim().split('\n').forEach((line)=>{
    let match = line.match(/(\w*\b)\s{1,}:\s(.*)/);
    parsed[match[1]] = match[2];
  });
  return parsed;
}

const readStats = async (outputDir)=>{
  let ls = await fsp.readdir(outputDir);
  let ret = [];
  let rd = async (key)=>{
    try {
      let data = await fsp.readFile(path.join(outputDir,key,'fuzzer_stats'),'utf8');
      let stats = parseStats(data);
      stats.key = key;
      ret.push(stats);
    }
    catch(err) {}
  }
  let parr = [];
  ls.forEach((key)=>parr.push(rd(key)));
  await Promise.all(parr);
  return ret;
}

let to = setTimeout(()=>{
  console.log('12 hours complete');
  rl.close();
  let ret = execSync(`${WHATSUP} ${OUTPUT}`);
  console.log(ret.toString());
},TOTAL_TIME/CORES);

let ask = () => {
  rl.question('Type q[uit] to quit. Anything else for afl-whatsup: ',(answer)=>{
    if(/^q/.test(answer)) {
      clearTimeout(to);
      rl.close();
      return;
    }
    let ret = execSync(`${WHATSUP} ${OUTPUT}`);
    console.log(ret.toString());
    console.log();
    ask();
  });
}

fsp.writeFile(path.join(OUTPUT,'cores'),CORES.toString());
ask();
