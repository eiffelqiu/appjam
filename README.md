appjam
=======
Appjam is an iOS code repository, including framework, snippet, generators, etc.

**upgrade to 0.1.8.8 as soon as possible**

Prerequisites
=======
Ruby
-------
Appjam require ruby installed on your mac machine. Since now all Mac OSX system preinstalled ruby enviroment, that's not a big issue. 

Rubygem(latest)
-------
Appjam has an dependency on "thor" gem , which require latest rubygem installed, so you need to update your rubygem to latest version, run command below to update your rubygem to the latest one.

	$ sudo gem update --system  # double dash option

Installation
=======
	$ sudo gem install appjam
	$ appjam gist update
	
Upgrade
=======
	$ sudo gem uninstall appjam # remove all version
	$ sudo gem install appjam 
	$ appjam gist update	

Usage
=======

Print Help Screen
-------
	$ appjam help
![appjam usage](https://raw.github.com/eiffelqiu/appjam/master/doc/appjam.jpg)

Generate a iOS project with most popular frameworks included and ARC enabled
-------
	$ appjam start demo

	$ cd demo

	$ open demo.xcodeproj
![appjam usage](https://raw.github.com/eiffelqiu/appjam/master/doc/appjam1.png)		

Search related function
-------
	$ appjam search image
	$ appjam search string
![appjam usage](https://raw.github.com/eiffelqiu/appjam/master/doc/appjam2.png)	
	
Update latest gists
-------
	$ appjam gist update

Xcode build and run 
![appjam usage](https://raw.github.com/eiffelqiu/appjam/master/doc/appjam3.png)	

Contributing to appjam
=======
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

Copyright
=======
Copyright (c) 2013 Eiffel Q. See LICENSE.txt for
further details.
