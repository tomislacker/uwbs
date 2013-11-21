# Overview

### What?
This repository is intended to be used to share and improve upon all the random scripts that I (and possibly my friends if I have any left) have made to make our lives easier.

### Why [Github]?
It's social and git rocks my socks, why else.

### Who?
This repo is starting with just me with the main intention being to just keep these scripts in sync between my three Gentoo workstations I use on a regular basis.

# Using & Improving

### Clone & Pull
Feel free to send me a pull request, I'll likely allow them all

### How I Implement It

Clone a copy
	```bash
		git clone https://github.com/tomislacker/uwbs.git ~/.uwbs

Create a profile.d entry to adjust my $PATH
	```bash
		echo "[ -d \"`readlink -m ~`/.uwbs\" ] && export PATH=\"${PATH}:`readlink -m ~`/.uwbs\"" \
			| sudo tee -a /etc/profile.d/uwbs.sh
	```
	
