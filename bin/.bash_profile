
export PATH=$PATH:/vagrant/bin

function sdrit(){
	sudo docker run -i -t $1 bash
}

alias sdr="sudo docker run"
alias dbld='sudo docker build -t crosswise/${PWD##*/} .'
alias dpsh='sudo docker push crosswise/${PWD##*/}'
alias dbldpsh="dbld; dpsh"
alias ll="ls -l"
alias lal="ls -al"
