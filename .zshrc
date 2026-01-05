#For the colors of ls-command
alias ls="eza -l --group --icons --color=always"
export EZA_COLORS="\
di=38;5;44:fi=38;5;208:ex=38;5;129:ln=38;5;45:or=38;5;196:\
uu=38;2;255;0;135:un=38;2;255;0;135:\
gu=38;2;255;255;0:gn=38;2;255;255;0:\
ur=38;2;29;255;149:gr=38;2;29;255;149:tr=38;2;29;255;149:\
uw=38;2;255;172;186:gw=38;2;255;172;186:tw=38;2;255;172;186:\
ux=38;2;165;213;255:gx=38;2;165;213;255:tx=38;2;165;213;255:\
ue=38;2;165;213;255:ge=38;2;165;213;255:te=38;2;165;213;255"

# Don't save duplicate commands in history 
setopt HIST_IGNORE_ALL_DUPS

