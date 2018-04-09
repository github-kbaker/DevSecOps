---
layout: post
title: "Install all on a MacOS laptop"
excerpt: "Everything you need to be a professional developer"
tags: [API, devops, evaluation]
Categories: Devops
filename: README.md
image:
  feature: https://cloud.githubusercontent.com/assets/300046/14612210/373cb4e2-0553-11e6-8a1a-4b5e1dabe181.jpg
  credit: And Beyond
  creditlink: http://www.andbeyond.com/chile/places-to-go/easter-island.htm
comments: true
---
<i>{{ page.excerpt }}</i>

This article explains the script that builds a Mac machine with "everything" needed by a professional developer.

Technical techniques for the Bash shell scripting techniques used here are described separtely at [Bash scripting page in this website](/bash-coding/).

## TD;LR Customization

This script to help manage the complexity of competing stacks of components and their different versions.

Logic in the script goes beyond what brew does, and <strong>configures</strong> the component just installed:

   * Display the version installed
   * Add alias and paths in <strong>.bash_profile</strong>
   * Perform configuration (such as adding a missing file needed for mariadb to start)
   * Run a demo script to ensure that what has been installed actually works

<hr />   

1. Edit file <strong>secrets.sh</strong> in the repo to customize what you install. 

2. In the string for each category, add the keyword for each app you want to install.
   
   There are several category variables.

   NOTE: This script does NOT automatically uninstall modules.
   It's just too dangerous.

3. Remove comments in the section of the script which has a list of brew commands.

   ## Update All Arguement 

4. Upgrade to the latest versions of ALL components when "update" is added to the calling script:

   <pre><strong>chmod +x mac-install-all.sh
   mac-install-all.sh update
   </string></pre>

   CAUTION: This often breaks things because some apps are not ready to use a newer dependency.

## Mac apps

Apps on Apple's App Store for Mac need to be installed manually. Popular apps include:

   * Office for Mac 2016
   * BitDefender for OSX
   * CrashPlan (for backups)
   * Amazon Music

The brew "mas" manages Apple Store apps, but it only manages apps that have already been paid for. But mas does not install apps new to your Apple Store account.

## Logging

The script outputs logs to a file.

This is so that during runs, what appears on the command console are only what is relevant to debugging the current issue.

At the end of the script, the log is shown in an editor to <strong>enable search</strong> through the whole log.

## 

Other similar scripts (listed in "References" below) run

## Cloud Sync

Dropbox, OneDrive, Google Drive, Amazon Drive


<a name="EclipsePlugins"></a>

## Eclips IDE plug-ins

http://download.eclipse.org/releases/juno

Within Eclipse IDE, get a list of plugins at Help -> Install New Software -> Select a repo -> select a plugin -> go to More -> General Information -> Identifier

   <pre>eclipse -application org.eclipse.equinox.p2.director \
-destination d:/eclipse/ \
-profile SDKProfile  \
-clean -purgeHistory  \
-noSplash \
-repository http://download.eclipse.org/releases/juno/ \
-installIU org.eclipse.cdt.feature.group, \
   org.eclipse.egit.feature.group
   </pre>

   "Equinox" is the runtime environment of Eclipse, which is the <a target="_blank" href="http://www.vogella.de/articles/OSGi/article.html">reference implementation of OSGI</a>.
   Thus, Eclipse plugins are architectually the same as bundles in OSGI.

   Notice that there are different versions of Eclipse repositories, such as "juno".

   PROTIP: Although one can install several at once, do it one at a time to see if you can actually use each one.
   Some of them:

   <pre>
   org.eclipse.cdt.feature.group, \
   org.eclipse.egit.feature.group, \
   org.eclipse.cdt.sdk.feature.group, \
   org.eclipse.linuxtools.cdt.libhover.feature.group, \
   org.eclipse.wst.xml_ui.feature.feature.group, \
   org.eclipse.wst.web_ui.feature.feature.group, \
   org.eclipse.wst.jsdt.feature.feature.group, \
   org.eclipse.php.sdk.feature.group, \
   org.eclipse.rap.tooling.feature.group, \
   org.eclipse.linuxtools.cdt.libhover.devhelp.feature.feature.group, \
   org.eclipse.linuxtools.valgrind.feature.group, \
   </pre>

   <a target="_blank" href="https://stackoverflow.com/questions/2692048/what-are-the-differences-between-plug-ins-features-and-products-in-eclipse-rcp">NOTE</a>:
   A feature group is a list of plugins and other features which can be understood as a logical separate project unit
   for the updates manager and for the build process.

   ## Others like this

   * https://github.com/andrewconnell/osx-install described at http://www.andrewconnell.com/blog/rapid-complete-install-reinstall-os-x-like-a-champ-in-three-ish-hours separates coreinstall.sh from myinstall.sh for personal preferences.

   <pre>
brew cask install xtrafinder
brew cask install sizeup
brew cask install bartender
brew cask install duet
brew cask install handbrake
brew cask install joinme
brew cask install logitech-harmony
brew cask install cheatsheet
brew cask install steam
brew cask install vlc
brew cask install sketchup
brew cask install fritzing
brew cask install nosleep
brew cask install adobe-creative-cloud
brew cask install atom
brew cask install balsamiq-mockups
brew cask install brackets
brew cask install camtasia
brew cask install charles
brew cask install firefox
brew cask install screenflow
brew cask install smartgit
brew cask install smartsynchronize
brew cask install toggldesktop
brew cask install vmware-fusion
brew cask install snagit
brew cask install xmind
brew cask install webstorm
brew install jsdoc3
brew install youtube-dl
brew install ffmpeg
brew cask install appcleaner
brew cask install qlcolorcode
brew cask install qlstephen
brew cask install qlmarkdown
brew cask install quicklook-json
brew cask install quicklook-csv
brew cask install betterzipql
brew cask install qlimageize
brew cask install asepsis
brew cask install cheatsheet
   </pre>

Node modules:

   <pre>
npm install -g growl
npm install -g express
npm install -g phantomjs
npm install -g typescript
npm install -g tsd
npm install -g superstatic
npm install -g kudoexec
npm install -g node-inspector
   </pre>   