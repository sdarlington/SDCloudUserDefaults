# SDCloudUserDefaults

**Store NSUserDefaults and iCloud data at the same time.**

The documentation for NSUbiquitousKeyValueStore says:

> Rather than use the key-value store as the sole source of your data, you should instead
> use it as a mechanism for updating a locally stored set of configuration values.

That's what SDCloudUserDefaults does. Use it instead of NSUserDefaults for anything you
want mirrored in iCloud. Best to also register for notifications when the app launches or
you might lose updates.

Note: By popular request I have enabled OS X support in the CocoaPods configuration. This
_should_ work but I have not been able to test it. Please let me know if you get it working.
Patches are welcomed if changes are required.

# Adding to your project

There are three ways of adding `SDCloudUserDefaults` to your project:

* [CocoaPods](http://cocoapods.org)
* Adding the library to your project as a dependency
* Drag-and-drop a few files manually

## CocoaPods

Add the following line to your Podfile:

```ruby
pod 'SDCloudUserDefaults'
```

There is no step two.

## Library as a dependency

If you're using iOS 5 or above and are happy with ARC, it's as simple as:

1. Drag the SDCloudUserDefaults.xcodeproj file to your project
2. Switch to the "Build Phases" project section
3. Add SDCloudUserDefaults to "Target Dependencies"
4. Add libSDCloudUserDefaults.a to "Link Binary With Libraries"

## Adding files manually

Copy SDCloudUserDefaults .h and SDCloudUserDefaults.m into your project.

# Usage

Unlike `NSUserDefaults` or the iCloud equivalents, all of `SDUserDefaults`
are class methods, so there's no need to get the `standardUserDefaults`
(I'm a lazy and bad typist).

Most of the methods are pretty obvious. For example

```objective-c
+(NSString*)stringForKey:(NSString*)aKey;
+(void)setString:(NSString*)aString forKey:(NSString*)aKey;
+(void)removeObjectForKey:(NSString*)aKey;
```

There are similar methods for a few of the other data types (bool, object,
integer). As with `NSUserDefaults` there is also a `synchronize` to make sure
your changes are committed -- locally at least, it's not possible to guarantee
that iCloud has seen them.

If you want to import changes from iCloud (and you probably do), you need to
call this method somewhere near the start of your app:

```objective-c
+(void)registerForNotifications;
```

# Licence
-------

    /*
     * Copyright 2011-2015 Wandle Software Limited
     *
     * Licensed under the Apache License, Version 2.0 (the "License");
     * you may not use this file except in compliance with the License.
     * You may obtain a copy of the License at
     *
     * http://www.apache.org/licenses/LICENSE-2.0
     *
     * Unless required by applicable law or agreed to in writing, software
     * distributed under the License is distributed on an "AS IS" BASIS,
     * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
     * See the License for the specific language governing permissions and
     * limitations under the License.
     */
