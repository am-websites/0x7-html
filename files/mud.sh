export PS1="\nYou are in a room with many doors, all alike # "
alias cd="echo That door is locked. ; false "
alias pwd="echo You are lost."
alias ls="echo It is too dark to see anything."
alias dir="ls"
alias cat="echo It is too dark to see anything. ; false"
alias vi="echo You\\'re not strong enough to perform that action. ; false"
alias vim="vi"
alias emacs="vi"
alias startx="echo I don\\'t understand."
alias ssh="echo You have not acquired that skill yet. ; false"
alias exit="echo You don\\'t know the way out." 
alias logout="echo You can not leave."
alias quit="logout"
alias help="echo There is nobody around to help you."
alias man="echo You can\\'t find help there. ; false"
alias rm="echo You can\\'t use this spell here. ; false"
alias ping="sleep 1 ; echo It is dead. ; false"
alias history="echo You do not remember anything."
alias kill="echo It is already dead. ; false"
alias killall="kill"
alias 42="export PS1='\u@\h \w $ ';unalias cd;unalias pwd;unalias ls;unalias dir;unalias cat;unalias vi;unalias vim;unalias emacs;unalias startx;unalias ssh;unalias exit;unalias logout;unalias quit;unalias help;unalias man;unalias rm;unalias ping;unalias history;unalias kill;unalias killall; unalias 42"