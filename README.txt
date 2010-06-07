jot
    by Gordon McAllister
    http://github.com/gogza

== DESCRIPTION:

a little list making command line tool that uses Checkvist to store its lists

== FEATURES/PROBLEMS:

* configure jot to work with Checkvist
* switch between lists on Checkvist
* display hierarchical lists

== SYNOPSIS:

  #configure jot for Checkvist
  jot config -e <your email address> -a <your Checkvist API key>

  #display your checklists
  jot lists
  
  # * list One
  #   list Two

  #change the current list to list_two
  jot lists T # matches Regular expressions

  #   list One
  # * list Two

  #show the list contents
  jot

  #   thing to do 1
  #   thing to do 2
  #     thing to do 3 - thing to do 2 depends on me!
  #   thing to do 4


== REQUIREMENTS:

* None so far!

== INSTALL:

* checkout this repo for now

== LICENSE:

(The MIT License)

Copyright (c) 2009

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
