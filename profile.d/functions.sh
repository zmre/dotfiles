thesaurus () {
	links -dump "http://thesaurus.com/browse/$*"  |less
}

dictionary () {
	links -dump "http://dictionary.reference.com/browse/$*" |less
}

yums () {
	yum -C search $* | grep -A2 -B1 '^Matched from' | sed -e '/^Matched/,+1 d' -e 's/^--$//' |less
}

clearssh () {
	grep -v $* ~/.ssh/known_hosts > ~/.ssh/known_hosts.n
	mv ~/.ssh/known_hosts.n ~/.ssh/known_hosts
}

branch_usage() {
	echo "   Usage: branch [module] [new_branch] {[product]}"
	echo "      eg: branch snapin-ips Orchid"
	echo "      or: branch snapin-spd Orchid ThreatWall"
}

branch () {
	if [ "$2" = "" ] ; then
		branch_usage
		return
	fi
	if [ -d $1 ] ; then
		echo "Module $1 already exists in this directory."
		echo "Remove it first or change to an empty directory."
		return
	fi
	module=$1
	branch=$2
	head=$(lookup_branch $module)
	if [ $head = "HEAD" ] ; then
		xtra=""
	else
		xtra=${3}_
		if [ "$xtra" = "_" ] ; then
			echo "This branch requires you to specify a product (InstaGate or ThreatWall)"
			branch_usage
			return
		else
			if [ "$xtra" != "ThreatWall_" -a "$xtra" != "InstaGate_" ] ; then
				echo "Invalid product $3 specified.  Use InstaGate or ThreatWall."
				branch_usage
				return
			fi
		fi
	fi

	branch=${xtra}${branch}_branch
	echo CVS Module: $module
	echo Branching from: $head
	echo Branching to: $branch
	echo Hit ctrl-c if this is wrong, return to continue...
	read

	cvs co -r $head $module
	if [ $? -ne 0 ] ; then
		echo "Problem checking out $module on the $head branch."
		return
	fi

	cd $module || return
	echo Tagging module $module with tag ${branch}_bp...
	cvs tag ${branch}_bp
	if [ $? -ne 0 ] ; then
		echo "Problem tagging $module with tag ${branch}_bp."
		return
	fi

	echo Branching module $module to ${branch}...
	cvs rtag -b -r ${branch}_bp ${branch} $module
	if [ $? -ne 0 ] ; then
		echo "Problem branching $module to ${branch}."
		return
	fi

	echo Checking out new branch...
	cd ..
	rm -rf $module
	cvs co -r $branch $module
	if [ $? -ne 0 ] ; then
		echo "Problem checking out $module on the $branch branch."
		return
	fi
	cd $module || return
	cvs update -d || return
	cd ..

	echo "Branch successful."
}

cvsremove() {
	if [ -d $1 ] ; then
		## We have a directory.  Remove it and its children.
		find $1 -depth -not -path '*CVS*' -delete -exec cvs remove \{\} \;
		echo "After you commit, you will need to delete the $1 directory tree."
	elif [ -f $1 ] ; then
		rm $1
		cvs remove $1
	else
		echo "You must specify a valid file or directory."
	fi
}

installsshkey() {
	if [ "$1" = "" ] ; then
		echo usage: installsshkey x.x.x.x
		return
	fi
	cd
	TARGET=$1
	scp -i ~/.ssh/id_dsa .ssh/id_dsa $TARGET:.ssh
	scp -i ~/.ssh/id_dsa .ssh/config $TARGET:.ssh
}

installprofile() {
	if [ "$1" = "" ] ; then
		echo usage: installprofile x.x.x.x
		return
	fi
	cd
	TARGET=$1
	cat ~/.ssh/id_dsa.pub ~/.ssh/iphone_dsa.pub | ssh -i ~/.ssh/id_dsa $TARGET "mkdir -p .ssh ; chmod 755 .ssh ; cat - >> .ssh/authorized_keys ; chmod 644 ~/.ssh/authorized_keys"
	scp -r -i .terminfo profile.d .gitconfig .vim .perltidyrc .inputrc .vimrc .screenrc .bashrc .bash_profile $TARGET:
	echo "Installed bash environment on $TARGET. Use installsshkey if you want your keys there."
	cd -
}

noblank() {
	setterm -powersave off -blank 0 -powerdown 0
	if [ -z $DISPLAY ] ; then
		for x in /tmp/.X11-unix/*; do
			displaynum=`echo $x | sed s#/tmp/.X11-unix/X##`
			getXuser;
			if [ x"$XAUTHORITY" != x"" ]; then
				export DISPLAY=":$displaynum"
				xset -dpms
				xset s noblank
				xset s off
			fi
		done
	else
		xset -dpms
		xset s noblank
		xset s off
	fi
}

getXuser() {
	user=`finger| grep -m1 ":$displaynum " | awk '{print $1}'`
	if [ x"$user" = x"" ]; then
		user=`finger| grep -m1 ":$displaynum" | awk '{print $1}'`
	fi
	if [ x"$user" != x"" ]; then
		userhome=`getent passwd $user | cut -d: -f6`
		export XAUTHORITY=$userhome/.Xauthority
	else
		export XAUTHORITY=""
	fi
}


