#!/bin/bash

###############################################################################
#### Comments

# add -h option

# 
# Install the EPEL repo key
# Install the EPEL repo
# log extra output to <script directory/>$script.log


# My FIRST! :) "from a blank page" bash script! Yay!

# 2014-12-07 12:52



###############################################################################
#### Notes

# 1) In case there's ever a desire to build a "back out" process, here's a start:
#   a) Remove repo key >
#      first -qa it (or similar) to see if it exists (qa prints nothing, q prints package x is not installed
#      -e will print error: package x is not installed
#      rpm -e gpg-pubkey-0608b895-4bd22942
#              package epel-release-6-8.noarch is already installed
#   b) Remove epel repo >
#      Per LinuxQuestions.org "Ho to remove epel-release-6-8.noarch" to disable the repo may be the better option
#      OTOH: 
#        is it registered in RPM? -- rpm -qa | grep -i epel-release-6-8.noarch
#          remove it with RPM -- rpm -e epel-release-6-8.noarch
#        not registered in RPM? -- mv or del the file from: /etc/yum/repos.d
#         

# 2) TBD

# 3) add -h command line option



###############################################################################
#### Tidbits

createLogName() {
  # return a log file name based on the script name, eg. for a.sh the log file name is a.sh.log
  # read the basename through a symlink - stackoverflow.com/questions/192319/how-do-i-know-the-script-file-name-in-a-bash-script
  # using basename may not be ideal here, dk
  echo "$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"'.log'
}

scriptLog=$(createLogName)



###############################################################################
#### key section

installEpelKey() {
  # Install EPEL gpg key
  # Saw strange things when using the shorthand for --import (i.e. -i)
  rpm --import https://fedoraproject.org/static/0608B895.txt &> $scriptLog
}

isEpelKeyInstalled() {
  local epelKeyExists="$(rpm -qa gpg* | grep -i 0608B895)"
  
  [[ $epelKeyExists > "" ]] && r=1 || r=0
  echo $r
}



###############################################################################
#### repo section

installRepo() {
 rpm -i -K http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm &> $scriptLog
}

isEpelRepoInstalled() {
  # using RPM: rpm -qa | grep -i repo-name 
  local epelRepoFile="/etc/yum.repos.d/epel.repo"

  # -f = true when file exists & is not a dir
  [[ -f $epelRepoFile ]] && r=1 || r=0
  echo $r
}



###############################################################################
#### main 

# Messages
 keyInstalled="Epel repo key installed"
 keyNotInstalled="Epel repo key not installed"

 repoInstalled="Epel repo installed"
 repoNotInstalled="Epel repo not installed"
 repoPrevInstalled="Epel repo previously installed"


# If the repo key is not present, get it
  if [[ $(isEpelKeyInstalled) -eq 0 ]]; then
  installEpelKey
fi

# The repo key was not installed? 1) echo the key & repo status, 2) exit
if [[ $(isEpelKeyInstalled) -eq 0 ]]; then
  echo $keyNotInstalled
  [[ $(isEpelRepoInstalled) -eq 0 ]] && r="$repoNotInstalled" || r="$repoPrevInstalled"
  echo $r
  exit
fi

echo $keyInstalled


# The repo key was installed, install the repo
installRepo

# Test repo install
[[ $(isEpelRepoInstalled) -eq 0 ]] && r="$repoNotInstalled" || r="$repoInstalled"
echo $r

