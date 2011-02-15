#!/usr/bin/env python2
#
#Lot of code/ideas taken from Michal Orlik <thror.fw@gmail.com>, sabooky <sabooky@yahoo.com>
#conky update script https://bbs.archlinux.org/viewtopic.php?id=37284
#
#Config
################################
#
#outputs '-' symbols to conky so you can find max length easier 1 - on, 0 - off
check_width = 0
#How many simbols there are in 1 line
length = 29
#How many packages to display in conky
package_count = 40
#How much + value packages gain if they are in some reposatory
value_repo = {
  ('core', 4),
  ('extra', 3),
  ('community', 2),
  ('arch-games', 1),
}
#color for each reposatory
color_repo = {
  ('core','DF938F'),
  ('extra','color0'),
  ('community','CF9ECC'),
  ('multilib','8FDF99'),
  ('xyne-any','D3D181'),
  ('sumary', 'white'),
}
#value for seperate packages
value_pkg = {
#  ('gtk2',10),
#  ('libsoup', 15)
}


import os
import subprocess
from glob import glob

def calculate_size(size):
  size = float(size)/(1024*1024)
  return round(size,2)

def draw_line(length):
  lines = []
  string = ''
  for i in range(length):
    string = string + '-'
  print (string)
  
#Get all packages what need updating
p = subprocess.Popen(['pacman','-Quq'],
            stdout=subprocess.PIPE, stderr=subprocess.STDOUT)

#remove \n from output and create multi dimension array
#to store information about packages and stores package name
#[0][0] - package name
#[0][1] - reposatory
#[0][2] - download size
#[0][3] - install size
#[0][4] - value
packages = []
for line in p.stdout:
  for col in range(1):
    line = line.lstrip()[0:-1]
    packages.append([line,0,0,0,0])

#gets reposatory/download size/install size from /var/lib/pacman/sync/*
for package in packages:
  desc_path = False
  desc_paths = glob('/var/lib/pacman/sync/*/%s-*'%package[0])
  
  if not desc_path:
    desc_path = desc_paths[0] + '/desc'
  package[1] = desc_path.split('/')[-3]
  pkg_desc = open(desc_path).readlines()
  for index, line in enumerate(pkg_desc):
    if line == '%CSIZE%\n':
      download_size = pkg_desc[index+1].strip()
      package[2] = calculate_size(download_size)
    if line == '%ISIZE%\n':
      install_size = pkg_desc[index+1].strip()
      package[3] = calculate_size(install_size)

#Gets all packages to ignore
pacman_conf = open('/etc/pacman.conf').readlines()
for line in pacman_conf:
  if line[0:9] == 'IgnorePkg':
    ignore_pkg = line.split()

#removes packages to ignore from package list
for pkg in ignore_pkg:
  for i, package in enumerate(packages):
    if package[0] == pkg:
      packages.pop(i)
  
#gets value for all packages depending on repo
for package in packages:
  for repo in value_repo:
    if repo[0] == package[1]:
      package[4] = package[4] + repo[1]

#gets value for all packages dependng on package name
for i in value_pkg:
  for package in packages:
    if package[0] == i[0]:
      package[4] = package[4] + i[1]

#sort by value decrasing
packages.sort(key=lambda test: test[4], reverse=True)

#output this to conky
if check_width == 1:
  draw_line(length)
for package in packages[0:package_count]:
  line_left = package[0]
  line_right = str(package[3]) + 'M'
  line_center = length - len(line_right);
  
  if len(line_left) > line_center:
    line_left = line_left[0:line_center-4]
    line_left = line_left + '...'
  line_center = line_center - len(line_left)
  space = ''
  for i in range(line_center):
    space = space + ' '
  
  if package[1] == 'core':
    line_left = '${goto 59}${color DF938F}${font liberation:bold:size=8}' + line_left + '$font${color2}'
  elif package[1] == 'extra':
    line_left = '${goto 59}${color0}${font liberation:bold:size=8}' + line_left + '$font${color2}'
  elif package[1] == 'community':
    line_left = '${goto 59}${color0}${font liberation:bold:size=8}' + line_left + '$font${color2}'
  elif package[1] == 'arch-games':
    line_left = '${goto 59}${color0}${font liberation:bold:size=8}' + line_left + '$font${color2}'
  print (line_left + space + '${color1}' + '${alignr}' + line_right )
count = len(packages)
install_size = 0
download_size = 0
for i in packages:
  install_size = install_size + i[3]
  download_size = download_size + i[2]
line_left = '${goto 59}' + 'Total: ' + str(count)
line_right = str(download_size) + 'M/' + str(install_size) + 'M'
line_center = length - len(line_right)
line_center = line_center - len(line_left)
line_left = '${color1}' + line_left + '${color}'
line_right = '${color1}' + line_right + '${color}'
space = ''
for i in range(line_center):
  space = space + ' '
#draw_line(length)
separator = ' '
print separator
separator = ' '

if download_size == 0:
	u2d = '${goto 59}${font Arial:bold:size=10}${color1}You are up to date'
	print (u2d)
	print separator
else:
	print (line_left + space + '${alignr}' + line_right)
