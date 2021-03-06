#!/usr/bin/env python2
# -*- coding: utf-8 -*-
# Description: Python script for notifying archlinux updates.
# Usage: Put shell script with command 'pacman -Sy' into /etc/cron.hourly/
# Conky: e.g. put in conky '${texeci 1800 python path/to/this/file}'
# Author: Michal Orlik <thror.fw@gmail.com>, sabooky <sabooky@yahoo.com>
import re

################################################################################
# SETTINGS - main settings
# set this to True if you just want one summary line (True/False)
brief = False
# number of packages to display (0 = display all)
num_of_pkgs = 0
#show only important packages
onlyImportant = False
########################################

# OPTIONAL SETTINGS
# PACKAGE RATING - prioritize packages by rating
# pkgs will be sorted by rating. pkg rating = ratePkg + rateRepo for that pkg
# pkg (default=0, wildcards accepted)
ratePkg = {
        'kernel*':10,
        'pacman':9,
        'nvidia*':8,
        }
# repo (default=0, wildcards accepted)
rateRepo = {
        'core':5,
        'extra':4,
        'community':3,
        'xyne-any':2,
        'multilib':1,
        }
# at what point is a pkg considered "important"
iThresh = 5
########################################

# OUTPUT SETINGS - configure the output format
# change width of output
width = 47

# if you would use horizontal you possibly want to disable 'block'
horizontally = False
# separator of horizontal layout
separator = ' ---'
# pkg template - this is how individual pkg info is displayed ('' = disabled)
# valid keywords - %(name)s, %(repo)s, %(size).2f, %(ver)s, %(rate)s
pkgTemplate = "%(repo)s/%(name)s %(ver)s"
# important pkg tempalte - same as above but for "important" pkgs
ipkgTemplate = "%(repo)s/%(name)s %(ver)s"
# summary template - this is the summary line at the end
# valid keywords - %(numpkg)d, %(size).2f, %(inumpkg), %(isize).2f, %(pkgstring)s
summaryTemplate = "%(numpkg)d %(pkgstring)s"
# important summary template - same as above if "important" pkgs are found
isummaryTemplate = summaryTemplate + ""
# pkg right column template - individual pkg right column
# valid keywords - same as pkgTemplate
pkgrightcolTemplate = " %(size).2f Mb"
# important pkg right column template - same as above but for important pkgs
ipkgrightcolTemplate = pkgrightcolTemplate
# summary right column template - summay line right column
# valid keywords - same as summaryTemplate
summaryrightcolTemplate = "$alignr${color slategray}  %(size).2f Mb"
# important summary right column template - same as above if "important" pkgs are found
isummaryrightcolTemplate = summaryrightcolTemplate
# seperator before summary ('' = disabled)
block = '  ${ font Arial:bold:size=8}${color lightblue}TOTAL${color slategray}'
# up to date msg
u2d = '${font Arial:bold:size=10}${color slategray}You ${are ${up ${to ${date'
################################################################################

import subprocess
import re

from time import sleep
from glob import glob
from fnmatch import fnmatch

program = []
pkgs = []
url = None

def runpacman():
    """runs pacman returning the popen object"""
    p = subprocess.Popen(['pacman','-Qu'],
            stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    return p

def cmpPkgs(x, y):
        """Compares packages for sorting"""
        if x['rate']==y['rate']:
                return cmp(x['size'], y['size'])
        else:
                return x['rate']-y['rate']

if onlyImportant:
        pkgTemplate, pkgrightcolTemplate = '',''

p = runpacman()
 
for line in p.stdout:
    if not line.strip():
        break

    program += line.split()[0::2]
    
for item in program:
    pkg = {}
    desc_path = False
    desc_paths =  glob('/var/lib/pacman/sync/*/%s-*'%item)

    if not desc_path:
        desc_path = desc_paths[0] + '/desc'

    pkg['repo'] = desc_path.split('/')[-3]
    desc = open(desc_path).readlines()
    checkName = 0
    checkSize = 0
    checkVersion = 0
    for index, line in enumerate(desc):
        if line=='%NAME%\n' and checkName == 0:
            pkgName = desc[index+1].strip()
            pkg['name'] = pkgName
            checkName = 1
        if line=='%CSIZE%\n' and checkSize == 0:
            pkgSize = int(desc[index+1].strip())
            pkg['size'] = pkgSize / 1024.0 / 1024
            checkSize = 1
        if line=='%VERSION%\n' and checkVersion == 0:
            pkgVersion = desc[index+1].strip()
            pkg['ver'] = pkgVersion
            checkVersion = 1

    pkgRate = [v for x, v  in ratePkg.iteritems()
            if fnmatch(pkg['name'], x)]
    repoRate = [v for x, v in rateRepo.iteritems()
            if fnmatch(pkg['repo'], x)]
    pkg['rate'] = sum(pkgRate + repoRate)

    pkgs.append(pkg)
#Gets all packages to ignore
pacman_conf = open('/etc/pacman.conf').readlines()
for line in pacman_conf:
  if line[0:9] == 'IgnorePkg':
    ignore_pkg = line.split()
print (pkgName[2])
#removes packages to ignore from package list
for pkg in ignore_pkg:
  for i, package in enumerate(pkgName):
    if pkgName[0:9] == pkg:
      pkgName.pop(i)
  
# echo list of pkgs
if pkgs:
    summary = {}
    summary['numpkg'] = len(pkgs)
    summary['size'] = sum([x['size'] for x in pkgs])
    if summary['numpkg'] == 1:
        summary['pkgstring'] = '${color slategray}Pkgs'
    else:
        summary['pkgstring'] = '${color slategray}Pkgs'
    summary['inumpkg'] = 0
    summary['isize'] = 0
    lines = []
    pkgs.sort(cmpPkgs, reverse=True)
    for pkg in pkgs:
        important = False

        if pkg['rate'] >= iThresh:
            summary['isize'] += pkg['size']
            summary['inumpkg'] += 1
            pkgString = ipkgTemplate % pkg
            sizeValueString = ipkgrightcolTemplate % pkg
        else:
            pkgString = pkgTemplate % pkg
            sizeValueString = pkgrightcolTemplate % pkg

        if len(pkgString)+len(sizeValueString)>width:
                pkgString = pkgString[:width-len(sizeValueString)-1]+'...'

        line = pkgString.ljust(width - len(sizeValueString)) + sizeValueString
        line = re.sub("core/", " Core ", line)
        line = re.sub("extra/", " Extra ", line)
        line = re.sub("community/", " Community ", line)
        line = re.sub("mult	ilib/", " Multilib ", line)
        line = re.sub("xyne-any/", " Xyne ", line)
        if line.strip():
            lines.append(line)

    if not horizontally:
        separator = '\n'

    if not brief:
        if num_of_pkgs:
            print separator.join(lines[:num_of_pkgs])
        else:
            print separator.join(lines)
        if block:
            print block.rjust(width-2000)


    if summary['inumpkg']:
        overallString = isummaryTemplate % summary
        overallMBString = summaryrightcolTemplate % summary
    else:
        overallString = summaryTemplate % summary
        overallMBString = isummaryrightcolTemplate % summary
    summaryline =  overallString.ljust(width - len(overallMBString)) \
                       + overallMBString
    if summaryline and not horizontally:
        print summaryline
else:
    print u2d
