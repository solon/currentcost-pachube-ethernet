currentcost-pachube-arduino
===========================

Example Arduino program to capture data from the CurrentCost 128 meter and send it to Pachube

Requirements
------------
* Tested on Arduino 0018
* Requires the NewSoftSerial Arduino library:  http://goo.gl/437w
* Remember to insert your Pachube API key and feed ID in currentcost-pachube-ethernet.pde

Notes
-----
This code is based on http://goo.gl/cxY5 with one small addition:

* Added a third datastream to the Pachube feed to log timestamps separately


Errata
------
There is bug in the original code which was preventing data from being logged to Pachube.
This was fixed by changing "_id=" to "_session=" in pachube_functions.pde, line 156.


