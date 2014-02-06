MCollectionViewCalendar
======================================
This prototype was developed to test the limitations and explore the possibilities of using a UICollectionView as the base class for a calendar's day view.  The view's cells represent time blocks which can be easily selected with a gesture as a means to create an event on a calendar.  

How It Works
---------------------
Each cell represents a time component (let's say 30 minutes).  Users can tap on an individual cell to select it.  By doing so, the cell's image and label will change to indicate it's been selected.  The user would then hit 'Next' (not implemented) to input event details for that selected 30 minute window.  

To selected multiple cells, simply long-press on a cell to activate a static selective state.  Now drag across rows and columns to selecte multiple time components.  When the user ends the gesture, the cells are 'painted' and a block of time has been selected.  Hitting the 'Cancel' button will remove the block.  Again, once a user selects a block they could hit 'Next' (not implemented) to be taken to an event details view where they'd input event title, select location, etc.

The horizontal header across the top of the collection view (where we have column headers of 'A', 'B', etc.) would represent various people you'd like to add to your event.  The vertical header running along the left side would represent time throughout the day (12:00AM to 12:00PM) in various increments.

Screen Shots
======================================

![Alt text](https://github.com/jeffjohnston101/MCollectionViewCalendar/blob/master/README_ASSETS/cvc1.png?raw=true)![Alt text](https://github.com/jeffjohnston101/MCollectionViewCalendar/blob/master/README_ASSETS/cvc2.png?raw=true)![Alt text](https://github.com/jeffjohnston101/MCollectionViewCalendar/blob/master/README_ASSETS/cvc4.png?raw=true)