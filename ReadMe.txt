Description: Where I Work is an app that allows the user to view places near them on a map that could be good for working. These places may include coffee shops, libraries, or other business. 

Map View Page
When the app loads the user is shown a map view that is zoomed into their current location. The user will see red pins   indicating locations entered by the system or user entered location In the top right corner of the app there will be an add button that allows the user to enter a new location. On the top left of the mapview page is a current location button. If the user has been navigating out the map the refresh button will zoom the map back to the user?s current location. Clicking this button does not make a network service call, it only centers the map on the current location. Clicking on an existing pin will take the user to the Rate Location page. Clicking on the add button and then saving that new location will also send the user to the Rate Location page. 

Added Support for Long Press
On the map view the user can long press anywhere on the map to add a new location where they are pressing. Once the user long presses an alert view will appear with 3 textboxes for business name, website, and category. Upon clicking on the save button on the alert view the location will be saved and the user taken to the Rate Location page.

Add New Location Page
The add new location page will allow the user to enter an address and add it to the map. This is accomplished by geocoding the user entered address to get the Latitude/Longitude coordinates required for the map view.

Rate Location Page
The rate this location page allows the user to rate the business based on a variety of factors. The user can rate a location based on a number of factors including: noise level, wifi strength, if the location has free wifi and the availability of seating. In addition there is a free form text field for the user to enter their own notes. Rating will be either a Boolean switch or on a 0-5 scale. The user will be will be able to navigate back to the map view from either the rate location or new location pages by using the cancel/back button in the top left corner of the page. On the Rate Location page the save button, located in the top right of the toolbar, will create a new rating object and save it to core data. Additionally, the location taken from Yelp?s API and all user entered locations will be saved to Core Data as well.
