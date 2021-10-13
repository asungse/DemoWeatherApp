This file contains the technical discussion of the app. For walkthrough on app usage, please refer to readme (app usage walkthrough).txt

For most of the details, you can refer to the comments in source code and the names of functions and variables.


Below are some additional information:

This project is developed with deployment target of iOS 15.0 or above for iPhone.

High-level requirement 1 - Search by city name or zip code

When users enter a city name, they may enter a non-searchable city name (typo or non-available city) with return error message "city not found", therefore a preloaded city list is included for minimise this potential issue.

The city list is obtained from https://bulk.openweathermap.org/sample/city.list.josn.gz

The city list embed in this project only consists of cities' id and name to minimise the app size.

The same search bar is used for searching by either city name or zip code, if the user entered an integer, search by zip code will be used automatically. Otherwise, search by city name will be used in default.


High-level requirement 2 - Search by GPS

Just normal usage of iOS location service.


High-level requirement 3 - Most recent search location loads automatically

Just normal update for database and UI after processing the API response.


High-level requirement 4 - Recent searches

Just normal API calling and response handling.


High-level requirement 5 - Delete recent searches

Just normal update for database and UI after processing users' action.


High-level requirement 6 - Multi-market

Sub-requirement 6.1 - Different app naming for different countries

The app name is implemented according to requirement (Australia: "My Aussie Weather", Canada: "My Eh Weather"), but it is not guaranteed that users will be seeing the desired app name.

Because the app name is displayed based on iOS device's settings on language and region, which app developers have no control over it. If the localisation combination is not covered in the project, the default app name will be showed instead of the desired app name.

Take HKTV mall app name for instance, users with their devices set in English will see "HKTVmall – online shopping" while users with their devices set in Chinese will see "HKTVmall – 網上購物".

Reference:
https://apps.apple.com/hk/app/hktvmall-online-shopping/id910398738?l=en
https://apps.apple.com/hk/app/hktvmall-online-shopping/id910398738?l=zh

Sub-requirement 6.2 - Different color scheme for each country

The color scheme is automatically set according to the set region of the device. But similar to restriction in sub-requirement 6.1, users may not be seeing the desired color theme.

