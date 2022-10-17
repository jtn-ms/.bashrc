####################
## docker         ##
####################
alias docker-rm-none="docker rmi $(docker images | grep none | awk '{print $3F}')"




#####################
## git             ##
#####################

alias gitbranchmain='git checkout main'

alias gitsearch='f(){ git grep "$@" `git show-ref -s --heads`;  unset -f f; }; f'
alias gitbranchgrep='f(){ git branch| grep "$@" ;  unset -f f; }; f'

## [description]: commit
## [usage]: gitcommit
gitcommit () {
  git add .;
  read -p "Add Comment: " -e comment
  git commit -m $comment;
  git push origin;
}

## [description]: create empty(orphan) branch
alias gitcreateempty='f(){ git switch --orphan "$@"; git commit --allow-empty -m "first commit"; git push -u origin "$@";  unset -f f; }; f'

## [description]: rename branch
## [usage]: gitbranchrename <oldname> <newname>
alias gitbranchrename='f(){ git checkout "$1"; git branch -m "$2"; git push origin -u "$2"; git push origin --delete "$1" ;  unset -f f; }; f'

## [description]: remove a branch from local & remote
alias gitbranchremove='f(){ gitbranchmain; git branch -D "$@"; git push origin --delete "$@"; unset -f f; }; f'

## [description]: reset to a specific commit
## [usage]: gibranchtreset <commit-hash>
alias gibranchtreset='f(){ git reset --hard "$@"; git clean -f; git push -f origin; unset -f f; }; f'

# statistics
## [usage]: gitstat
gitstat () {
  echo -en "auther   add_lines del_lines total_lines\n" ;
  git log --format="%aN" |
  sort -u |
  while read name;
  do
    echo -en "$name\t\t"
    awk '{printf ("%20s\t",$1)}';
    git log --author="$name" --pretty=tformat: --numstat -- . ":(exclude)vendor" |
    awk '{ add += $1; subs += $2; loc += $1 - $2 } END { printf "%s\t%s\t%s\n", add, subs, loc }' -;
  done
}

## [usage]: gitstatd 2022-1-1 2022-12-12
gitstatd () {
  echo -en "auther   add_lines del_lines total_lines\n" ;
  git log --format="%aN" |
  sort -u |
  while read name;
  do
    echo -en "$name\t\t"
    awk '{printf ("%20s\t",$1)}';
    git log --author="$name" --pretty=tformat: --since=$1 --until=$2 --numstat -- . ":(exclude)vendor" |
    awk '{ add += $1; subs += $2; loc += $1 - $2 } END { printf "%s\t%s\t%s\n", add, subs, loc }' -;
  done
}

## [usage]: gitstatmonth
gitstatmonth () {
  echo -en "auther   add_lines del_lines total_lines\n" ;
  git log --format="%aN" |
  sort -u |
  while read name;
  do
    echo -en "$name\t\t"
    awk '{printf ("%20s\t",$1)}';
    git log --author="$name" --pretty=tformat: --since=`date '+%Y-%m'`-01 --until=`date +%F` --numstat -- . ":(exclude)vendor" |
    awk '{ add += $1; subs += $2; loc += $1 - $2 } END { printf "%s\t%s\t%s\n", add, subs, loc }' -;
  done
}

## [usage]: gitstatweek
gitstatweek () {
  echo -en "auther   add_lines del_lines total_lines\n" ;
  git log --format="%aN" |
  sort -u |
  while read name;
  do
    echo -en "$name\t\t"
    awk '{printf ("%20s\t",$1)}';
    git log --author="$name" --pretty=tformat: --since=`date -d '7 days ago' -I` --until=`date +%F` --numstat -- . ":(exclude)vendor" |
    awk '{ add += $1; subs += $2; loc += $1 - $2 } END { printf "%s\t%s\t%s\n", add, subs, loc }' -;
  done
}

testing () {
    read -p "Enter value for 'a': " -e a
    read -p "Enter value for 'b': " -e b
    echo "My values are $a and $b"
}
