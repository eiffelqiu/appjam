appjam
=======
Appjam is an iOS code repository, including framework, snippet, generators, etc.

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
	
Upgrade
=======
	$ sudo gem uninstall appjam # remove all version
	$ sudo gem install appjam 	

Usage
=======
![appjam usage](http://eiffelqiu.github.com/appjam/appjam.jpg)

Usage 1: search related function
-------
	$ appjam search image
	$ appjam search string
	
Usage 2: update latest gists index 
-------
	$ appjam gist update

Usage 3: generate iphone app project based on puremvc framework
-------
	$ appjam mvc_project todo

	$ cd todo

	$ open Todo.xcodeproj

Xcode build and run 

Usage 4: add model to iphone app project based on puremvc framework
-------
	$ cd todo 

	$ appjam mvc_model user 

	$ open Todo.xcodeproj

Add "Classes/user/" folder to the "Classes/apps" Group  

Xcode build and run 

Usage 5: add asihttp library (## this require git installed)
-------
	$ cd todo 

	$ appjam lib asihttp 

Check Frameworks/AsiHttpRequest/ for new framework [AsiHttpRequest]

Usage 6: add get_gps_info snippet to your project (## this require git installed)
-------
	$ cd todo 

	$ appjam gist get_gps_info

	$ open Todo.xcodeproj

Add 'Gist/utiliy/Get_GPS_Info/' folder to the 'Classes' Group

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
Copyright (c) 2011 Eiffel Q. See LICENSE.txt for
further details.
