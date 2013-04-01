appjam
=======
Appjam is an iOS code repository, including framework, snippet, generators, etc.

**upgrade to 0.1.8.7 as soon as possible**

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
![appjam usage](http://eiffelqiu.github.com/appjam/appjam.jpg)

Usage 1: generate iOS project with most popular framework included
-------
	$ appjam start todo

	$ cd todo

	$ open todo.xcodeproj

Usage 2: search related function
-------
	$ appjam search image
	$ appjam search string
	
Usage 3: update latest gists index 
-------
	$ appjam gist update

Usage 4: generate iphone app project based on puremvc framework
-------
	$ appjam mvc_project todo

	$ cd todo

	$ open Todo.xcodeproj

Xcode build and run 

Usage 5: add asihttp library (## this require git installed)
-------
	$ cd todo 

	$ appjam lib asihttp 

Check Frameworks/AsiHttpRequest/ for new framework [AsiHttpRequest]

Usage 6: add cocos2d stable library (## this require appjam 1.8.4)
-------
	$ cd todo 

	$ appjam lib cocos2d_stable 

Check Frameworks/cocos2d-iphone-1.0.0/ for new framework [Cocos2d_iPhone_1.0]

Usage 7: add get_gps_info snippet to your project (## this require git installed)
-------
	$ cd todo 

	$ appjam gist get_gps_info

	$ open Todo.xcodeproj

Add 'Gist/utiliy/Get_GPS_Info/' folder to the 'app' Group

Xcode build and run

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
