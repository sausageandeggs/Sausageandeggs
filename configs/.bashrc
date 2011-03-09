#### Source Files #### {{{

#### Config files ####

. /etc/profile
. /usr/lib/sas/my_func
. /usr/share/cdargs/cdargs-bash.sh
. /usr/lib/sas/funcdo
# }}}

#### Var Settings #### {{{
#### Increase & auto-append history & export various #####

HISTCONTROL=ignoredups
HISTFILESIZE=10000
HISTSIZE=10000
PROMPT_COMMAND="history -a"
export HISTSIZE PROMPT_COMMAND
shopt -s cdspell
shopt -s histappend
shopt -s autocd
shopt -s extglob
export HISTIGNORE='pwd:exit:clear:..bash:cr:su:ll:cv:checkup:ranger'

export PATH="$PATH:/home/sas/scripts"
export PS1='\[\e[1;32m\][\u@\h \W]\$\[\e[0m\] '

export EDITOR=vim
export PYTHON2STARTUP=$HOME/.pythonrc.py

complete -cf sudo

eval $(dircolors /etc/DIR_COLORS)

# Check for an interactive session

[ -z "$PS1" ] && return
# }}}

#### Aliass' #### {{{

alias ..bash='. /home/sas/.bashrc'
alias abs='sudo abs'
alias add='git add'
alias all='git add .'
alias aurupd='sudo bauerbill -Syu --aur'
alias bauerbill='sudo bauerbill'
alias bbb='bauerbill -S'
alias bbqu="echo ; bauerbill -Qu | grep -Ev '(core|extra|community|multilib)' | grep -v ^$ ; echo" 
alias bbs='bauerbill -Ss'
alias cd~='cd ~'
alias cd-='cd -'
alias cd.='cd ..'
alias cd..='cd ../..'
alias cd...='cd ../../..'
alias cd#='cd ~'
alias chkit='pgrep -fl'
alias ck4up='ck4up -v'
alias clone='git clone'
alias cma='git commit -a -m'
alias commit='git commit'
alias cr='clear ; archey'
alias crontab='fcrontab -u systab -e'
alias dc='cd'
alias diff='colordiff'
alias egrep='egrep --color=auto'
alias fullscan='clamscan /* --max-recursion=25 --detect-pua=yes -r -i --heuristic-scan-precedence=yes &'
alias fgrep='fgrep --color=auto'
alias gdif='gvimdiff'
alias gitdif='git diff'
alias gitupdt='for i in /projects/git/{ghost,graysky}/* ; do cd "$i" ; echo -e "${bldylw}$PWD${txtrst}" ; git pull ; done'
alias gti='git'
alias gv='gvim'
alias gvs='gvim -S'
alias gdifo='gvimdiff -o'
alias getflush='/usr/bin/get_iplayer --flush'
alias grep='grep --color=auto'
alias hds='cd /home/sas/downloads'
alias ipy='ipython'
alias kilit='pkill -fl'
alias kmdir='mkdir'
alias la='ls -ah --group-directories-first'
alias lla='ls -lha --group-directories-first'
alias ll='ls -lh --group-directories-first'
alias lns='ln -s'
alias loginsound='cp $(find /usr/share/sounds/login-sounds |shuf -n 1) /usr/share/sounds/desktop-login.wav'
alias ls='ls --color=auto'
alias lscron='fcrondyn -x ls'
alias makepkgbld='makepkg -g >> PKGBUILD && pkgb'
alias makepkgd='makepkg -d'
alias makepkgf='makepkg -f'
alias makepkgfi='makepkg -fi noconfirm'
alias makepkgif='makepkg -fi --noconfirm'
alias makepkgi='makepkg -i --noconfirm'
alias makepkgs='makepkg -s'
alias makepkgss='makepkg --source'
alias mdds='cd /media/data/downloads'
alias orph='pacman -Qdt'
alias pacaman='sudo pacman-color'
alias pacman='sudo pacman-color'
alias pacmn='sudo pacman-color'
alias pacup='. /home/sas/scripts/pacupdis &'
alias paper='gconftool-2 --type string --set /desktop/gnome/background/picture_filename $(find /home/sas/pictures |shuf -n 1)'
alias pcman='sudo pacman-color'
alias pcmn='sudo pacman-color'
alias pgkb='pkgb'
alias pgrepf='pgrep -fl'
alias pgrwp='pgrep'
alias pgrwpf='pgrep -fl'
alias pjts='cd /projects'
alias pkgb='edit pkgb'
alias pkillf='pkill -f'
alias pkgv='edit -v pkgb'
alias powerpill='sudo powerpill'
alias ppd='powerpill -S --asdeps'
alias ppl='pacman -Ql'
alias ppi='pacman -Qi'
alias ppo='pacman -Qo'
alias ppp='powerpill -S'
alias ppq='pacman -Qs'
alias ppr='pacman -R'
alias pprr='pacman -Rnsu'
alias pprrr='pacman -Rnsc'
alias pps='pacman -Ss'
alias ppu='pacman -U'
alias ppud='powerpill -U --asdeps'
alias ppw='powerpill -Sw'
alias pytut='epdfview /media/three/PDFs/python/Beginning_Python_From_Novice_to_Professional_2008.pdf &
                gnome-terminal --geometry=110x33 -x ipython &
                gvim ~/scripts/python_tuts/tutpy.py &'
alias pull='git pull'
alias push='git push'
alias pvr='perl get_iplayer.cgi --port=1935 --getiplayer=/usr/bin/get_iplayer'
alias rebase='sudo rebase'
alias reboot='sudo reboot'
alias shutdown='sudo shutdown'
alias sl='ls'
alias status='git status'
alias su-='su - root'
alias tta='/usr/bin/todo.sh a'
alias ttd='/usr/bin/todo.sh -f del'
alias tth='/usr/bin/todo.sh help'
alias tts='/usr/bin/todo.sh ls'
alias ttt='/usr/bin/todo.sh'
alias v='vim'
alias vdif='vimdiff'
alias vdifo='vimdiff -o'
alias vs='vim -S'
alias wdp='pwd'
alias wpd='pwd'
alias !='sudo'
alias fudo='funcdo'
# }}}

#### Text Colours #### {{{

txtblk='\e[0;30m' # Black - Regular
txtred='\e[0;31m' # Red
txtgrn='\e[0;32m' # Green
txtylw='\e[0;33m' # Yellow
txtblu='\e[0;34m' # Blue
txtpur='\e[0;35m' # Purple
txtcyn='\e[0;36m' # Cyan
txtwht='\e[0;37m' # White
bldblk='\e[1;30m' # Black - Bold
bldred='\e[1;31m' # Red
bldgrn='\e[1;32m' # Green
bldylw='\e[1;33m' # Yellow
bldblu='\e[1;34m' # Blue
bldpur='\e[1;35m' # Purple
bldcyn='\e[1;36m' # Cyan
bldwht='\e[1;37m' # White
unkblk='\e[4;30m' # Black - Underline
undred='\e[4;31m' # Red
undgrn='\e[4;32m' # Green
undylw='\e[4;33m' # Yellow
undblu='\e[4;34m' # Blue
undpur='\e[4;35m' # Purple
undcyn='\e[4;36m' # Cyan
undwht='\e[4;37m' # White
bakblk='\e[40m'   # Black - Background
bakred='\e[41m'   # Red
bakgrn='\e[42m'   # Green
bakylw='\e[43m'   # Yellow
bakblu='\e[44m'   # Blue
bakpur='\e[45m'   # Purple
bakcyn='\e[46m'   # Cyan
bakwht='\e[47m'   # White
txtrst='\e[0m'    # Text Reset
# }}}

#### PS1's #### {{{

####### Arch style PS1 #######

#  PS1='[\[\e[0;36m\]\u@\h\[\e[m\] \[\e[1;34m\]\w\[\e[m\] \[\e[m\]\[\e[0;37m\]]\[\e[1;36m\]\$ \[\e[m\]\[\e[37m\]'

##############################

##################################################
# Fancy PWD display function
##################################################
# The home directory (HOME) is replaced with a ~
# The last pwdmaxlen characters of the PWD are displayed
# Leading partial directory names are striped off
###################################################

bash_prompt_command() {
    # How many characters of the $PWD should be kept
    local pwdmaxlen=25
    # Indicate that there has been dir truncation
    local trunc_symbol=".<."
    local dir=${PWD##*/}
    pwdmaxlen=$(( ( pwdmaxlen < ${#dir} ) ? ${#dir} : pwdmaxlen ))
    NEW_PWD=${PWD/#$HOME/\~}
    local pwdoffset=$(( ${#NEW_PWD} - pwdmaxlen ))
    if [ ${pwdoffset} -gt "0" ]
    then
        NEW_PWD=${NEW_PWD:$pwdoffset:$pwdmaxlen}
        NEW_PWD=${trunc_symbol}/${NEW_PWD#*/}
    fi
}

bash_prompt() {
    case $TERM in
     xterm*|rxvt*)
         local TITLEBAR='\[\033]0;\u:${NEW_PWD}\007\]'
          ;;
     *)
         local TITLEBAR=""
          ;;
    esac
    local NONE="\[\033[0m\]"    # unsets color to term's fg color
# regular colors
    local K="\[\033[0;30m\]"    # black
    local R="\[\033[0;31m\]"    # red
    local G="\[\033[0;32m\]"    # green
    local Y="\[\033[0;33m\]"    # yellow
    local B="\[\033[0;34m\]"    # blue
    local M="\[\033[0;35m\]"    # magenta
    local C="\[\033[0;36m\]"    # cyan
    local W="\[\033[0;37m\]"    # white
# emphasized (bolded) colors
    local EMK="\[\033[1;30m\]"
    local EMR="\[\033[1;31m\]"
    local EMG="\[\033[1;32m\]"
    local EMY="\[\033[1;33m\]"
    local EMB="\[\033[1;34m\]"
    local EMM="\[\033[1;35m\]"
    local EMC="\[\033[1;36m\]"
    local EMW="\[\033[1;37m\]"
# background colors
    local BGK="\[\033[40m\]"
    local BGR="\[\033[41m\]"
    local BGG="\[\033[42m\]"
    local BGY="\[\033[43m\]"
    local BGB="\[\033[44m\]"
    local BGM="\[\033[45m\]"
    local BGC="\[\033[46m\]"
    local BGW="\[\033[47m\]"

### user's color ###
    local UC=$EMG               # user's color
### root's color ###
	[ $UID -eq "0" ] && UC=$EMR   

    PS1="$TITLEBAR ${EMG}[${UC}\u ${EMB}\${NEW_PWD}${EMG}]${UC}\\$ ${NONE}"
    # without colors: PS1="[\u@\h \${NEW_PWD}]\\$ "
    # extra backslash in front of \$ to make bash colorize the prompt
}
# }}}

#### Kingbash #### {{{

function kingbash.fn() {
   echo -en "$TITLEBAR ${bldgrn}[sas ${bldblu}${NEW_PWD}${bldgrn}]$ ${txtrst}$READLINE_LINE" #Where "KingBash> " looks best if it resembles your PS1, at least in length.
  OUTPUT=`kingbash --plustoall --bashcompletion --extracommands "$(compgen -ab -A function)" --extrafiles "$(compgen -v -P $)"`
  READLINE_POINT=`echo "$OUTPUT" | tail -n 1`
  READLINE_LINE=`echo "$OUTPUT" | head -n -1`
  echo -ne "\r\e[2K"; }
bind -x '"\t":kingbash.fn'
#--noretab-backspace 
##### History search ######

function kingbash.hs() {
  old_line=$READLINE_LINE
  echo -en "$TITLEBAR ${bldgrn}[sas ${bldblu}${NEW_PWD}${bldgrn}]$ ${txtrst} $READLINE_LINE"
  history -a
  #OUTPUT=`kingbash -r <(tac $HISTFILE)`
#Alternatively, for unique entries:
  OUTPUT=`kingbash --historytabcompletion -r <(tac $HISTFILE | cat -n - | sort -u -k 2 | sort -n | cut -f2-)`
  READLINE_POINT=`echo "$OUTPUT" | tail -n 1`
  READLINE_LINE=`echo "$OUTPUT" | head -n -1`
  echo -ne "\r\e[2K"
  #Press Enter Automatically:
  #[ "$old_line" != "$READLINE_LINE" ] && { sleep 0.1; xdotool key --clearmodifiers Return; }
}
[[ $- =~ i ]] && bind -x '"\C-l":kingbash.hs'
# }}}

###########################

PROMPT_COMMAND=bash_prompt_command
bash_prompt
unset bash_prompt

archey

alias memrss='while read command percent rss; do if [[ "${command}" != "COMMAND" ]]; then 
rss="$(bc <<< "scale=2;${rss}/1024")"; fi; 
printf "%-26s%-8s%s\n" "${command}" "${percent}"	"${rss}";
done < <(ps -A --sort -rss -o comm,pmem,rss | head -n 21)'

alias ppm='pacman -Qm'
alias uuu='pacman -Qu'
