# Pre-work - *Tipster*

**Tipster** is a tip calculator application for iOS.

Submitted by: **Hien Nguyen**

Time spent: **4** hours spent in total

## User Stories

The following **required** functionality is complete:

* [x] User can enter a bill amount, choose a tip percentage, and see the tip and total values.
* [x] Settings page to change the default tip percentage.

The following **optional** features are implemented:
* [x] UI animations
* [x] Remembering the bill amount across app restarts (if <10mins)
* [x] Using locale-specific currency and currency thousands separators.
* [x] Making sure the keyboard is always visible and the bill amount is always the first responder. This way the user doesn't have to tap anywhere to use this app. Just launch the app and start typing.

The following **additional** features are implemented:

- Added Bill Split Option

## Video Walkthrough 

Here's a walkthrough of implemented user stories:
![Demo](https://github.com/morningstar2/tipster/blob/master/tipster.gif)
<img src='https://github.com/morningstar2/tipster/blob/master/tipster.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Project Analysis

As part of your pre-work submission, please reflect on the app and answer the following questions below:

**Question 1**: "What are your reactions to the iOS app development platform so far? How would you describe outlets and actions to another developer? Bonus: any idea how they are being implemented under the hood? (It might give you some ideas if you right-click on the Storyboard and click Open As->Source Code")

**Answer:** I usually always use storyboards to build my screens and take advantage of autolayout to quickly build adaptive layouts.  After laying out your UI components, you connect these components into your code using outlets and actions.  You can think of IBOutlets as objects and IBActions as methods to hook up UI on storyboards to your actual code.  

Question 2: "Swift uses [Automatic Reference Counting](https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/AutomaticReferenceCounting.html#//apple_ref/doc/uid/TP40014097-CH20-ID49) (ARC), which is not a garbage collector, to manage memory. Can you explain how you can get a strong reference cycle for closures? (There's a section explaining this concept in the link, how would you summarize as simply as possible?)"

**Answer:** Closures in Swift is exactly like Blocks in Objective-C.  If any variable is declared outside of the closure’s scope, referencing that variable inside the closure’s scope creates another strong reference to that object.  The only exception to this are variables such as Ints, Array, Dictionary and String which are value-like semantics.  The retain cycle comes from the closure capturing strong self while self also has a strong reference to the closure. To safely address self in closure we need to add [unowned self] to the closure


## License

    Copyright [2017] [Hien Nguyen]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
