README: SDCloudUserDefaults
---------------------------

The documentation for NSUbiquitousKeyValueStore says:

> Rather than use the key-value store as the sole source of your data, you should instead
> use it as a mechanism for updating a locally stored set of configuration values.

That's what SDCloudUserDefaults does. Use it instead of NSUserDefaults for anything you
want mirrored in iCloud. Best to also register for notifications when the app launches or
you might lose updates.

To use it you can either copy SDCloudUserDefaults .[hm] into your project or just drag the
SDCloudUserDefaults project into your project and add libSDUserCloudDefaults.a in the
"Link binary with Libraries" section of the "Build Phases" tab in Xcode.

Licence
-------

    /*
     * Copyright 2011 Wandle Software Limited
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