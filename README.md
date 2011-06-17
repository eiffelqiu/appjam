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
	$ sudo gem install appjam --pre  # for testing new functionality

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

Usage 3: generate iphone app project
-------
	$ appjam project todo

	$ cd todo

	$ open Todo.xcodeproj

Xcode build and run 

Usage 4: add model to iphone app project
-------
	$ cd todo 

	$ appjam model user 

	$ open Todo.xcodeproj

Add "Classes/user/" folder to the "Classes/apps" Group  

Xcode build and run 

Usage 5: add three20 submodule (## this require git installed)
-------
	$ cd todo 

	$ appjam submodule three20 

	$ open Todo.xcodeproj

Add "three20/src/Three20/Three20.xcodeproj" folder to the "Other Sources" Group  
Add "three20/src/Three20.bundle" folder to the "Other Sources" Group  

Xcode build and run

Usage 6: add asihttp submodule (## this require git installed)
-------
	$ cd todo 

	$ appjam submodule asihttp 

	$ open Todo.xcodeproj

Add "asihttp" folder to the "Other Sources" Group

Xcode build and run

Usage 7: add json-framework submodule (## this require git installed)  
-------
	$ cd todo 

	$ appjam submodule json 

	$ open Todo.xcodeproj

Add "json-framework" folder to the "Other Sources" Group

Xcode build and run

Usage 8: add kissxml submodule (## this require mercurial installed)  
-------
    $ cd todo 

    $ appjam submodule kissxml 

    $ open Todo.xcodeproj

Add "kissxml" folder to the "Other Sources" Group

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
