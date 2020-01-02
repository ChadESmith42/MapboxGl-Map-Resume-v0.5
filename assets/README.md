# Map Resume using MapboxGL Javascript
For geographers, like me, location matters. A resume with just the facts of a job don't tell the whole story of where that work was conducted. Travel and experiencing other cultures brings incredible skills that just don't translate to "worked with cross-cultural team." It also makes your resume a little more fun and interesting.

## Attribution:
I loosely based this project on a published web-map project I found online. Despite my best searching efforts, I haven't found the site as of the time of this publication. I wish that I could, so I could provide some credit where it is due. Some of the heavy lifting was done through that project. I modified my project to meet my needs, but I did get some core ideas of how to approach this via another developer. I'll update this portion as soon as I can find the project.

## Mapbox GL Javascript
I choose Mapbox GL library as my mapping javascript library for two reasons:
1. I had worked with Mapbox's software and services before. They're a good company and have great products that are easy to use.
2. They offer __*FREE*(!!!)__ usage of their library. If you want use their tiles (background or basemap), there are free tiers that will work for most projects.

## Structure
This project can be a single page. I broke it out into multiple files in order to facilitate ease of development. That's a personal choice. Obviously, you can go your own way! I ran into issues with CORS using data in separate files. Eventually, I put the data back into the scripts in order to get the project completed.

 If you want to see how to use Google Sheets as your data repository, I found this example using Leaflet and Google Sheets: [DataVizForAll](https://github.com/DataVizForAll/leaflet-storymaps-with-google-sheets).

## Making the Map

### Using other tile sources for your map
I like Mapbox. I have an account and have several projects that use their tiles. The tiles are clean, well thought out, have good support, and are easy to use.

I don't like having my Access Token out in public. Especially when I have to pay for specific things. Rather than spend tons of time using various methods to lock-down my access token behind the scenes, I'm using third-party tiles.

You can find tons of options for tile sources. My preferred brand is [Stamen Maps](http://maps.stamen.com). In order to use raster-tiles, you need to add little more to your ```style``` declaration in the ```map``` instantiation:
```javascript
style: {
        version: 8,
        sources: {
            'stamen-toner': {
                type: 'raster',
                tiles: [
                    'http://tile.stamen.com/toner/{z}/{x}/{y}.png'
                ],
                tileSize: 256,
                attribution: 'Map tiles by <a href="http://stamen.com">Stamen Design</a>, under <a href="http://creativecommons.org/licenses/by/3.0">CC BY 3.0</a>. Data by <a href="http://openstreetmap.org">OpenStreetMap</a>, under <a href="http://www.openstreetmap.org/copyright">ODbL</a>.'
            },
        },
        layers: [
            {
                id: 'stamen-toner',
                type: 'raster',
                source: 'stamen-toner',
                minzoom: 0,
                maxzoom: 22
            }
        ]
    },
```

### Adding Markers to the Map
I created a simple function that takes the place data and creates new markers on the map for each place.

```javascript
function CreateMarkers()
            {
                map.addSource('markers',
                    {
                        type: 'geojson',
                        data: markerPoints
                    });
                map.addLayer({
                    id: 'markers',
                    type: 'circle',
                    source: 'markers',
                    paint: {
                        'circle-radius': {
                            base: 14,
                            stops: [
                                [0, 10],
                                [22, 180]
                            ]
                        },
                        'circle-color': "#43b0f1",
                        'circle-opacity': .75,
                        'circle-stroke-color': "#1e3d58",
                        'circle-stroke-width': 4
                    }
                })
            }
```
In order to add any data to Mapbox, you must first create a Source. You can create multiple layers from the same source, just as you can reuse CSS classes, variables, or databases, etc. The source is given a name and passed a SourceOptions object. In this case, I'm using geoJSON, so the ```type``` is ```geojson``` and the ```data``` refers back to my object containing the place data, in this case, ```markerPoints```.

Once the Source is created, you can create a Layer to display on the map. In my use, I left the ```id``` as ```'markers'```. If I were making multiple Layers from the same Source, each ```id``` would be different. __Mapbox will throw an error if you try to reuse the same ```id```.__

The interesting part for the markers is that I wanted the points to basically look the same no matter what zoom level you view the map. The values are pixel based, but it's relative to the map's extent. A building with a roof that is 10 feet by 10 feet looks different from an adjacent building, from a jet airliner, from the International Space Station or from Mars. So in order to make the circles look the same, I used a function.

The ```stops``` argument provides key value pairs for the property based on zoom level. Mapbox fills in the intermediate zoom levels with values that are on par with the original values. At zoom level 0, the circle size is 10 pixels. At zoom level 22, the circle size is 180 pixels.

### Focusing the map on the content location
I created a data-set that has map settings for each location. These aren't just recentering the map. For some cases, I wanted points that are close to other points to be the only point shown. That required some changes in map bearing, tilt, zoom, etc. The ```chapters``` object contains all of the various settings for these map changes.

```javascript
var chapters = {
                centriq: {
                    bearing: 0,
                    center: [-94.61131, 38.9693],
                    zoom: 13,
                    pitch: 20
                },
                esri: {
                    bearing: 0,
                    center: [-117.190277, 34.05724],
                    zoom: 13,
                    pitch: 20
                },
                denton: {
                    center: [-97.1563381, 33.2108131],
                    bearing: 35,
                    zoom: 13.5,
                    pitch: 20
                }, ...
 // code omitted for brevity>
```
I used three functions to modify the map and the text content based on scrolling behavior.

#### What's on the screen?
I created a function to check if a DOM element is visible on the browser's screen.
```javascript
function isElementOnScreen(id)
            {
                var bounds = document.getElementById(id).getBoundingClientRect();
                var viewHeight = Math.max(
                    document.documentElement.clientHeight,
                    window.innerHeight
                );
                return !(bounds.bottom < 0 || bounds.top - viewHeight >= 0);
            }
```
I pass in the ```id``` of the DOM element as an argument. The ```id``` comes from the ```chapters``` object identified in the previous section.

The ```bounds``` variable is the actual position of the DOM element's box on the screen. Since we're looking for the "*top*" element on the page, we need to check the bottom of the element against the top of the page and also the top of the element against the page height. This function returns a ```boolean``` for each ```id```.

If the DOM element is at the top of the page, what then?

#### Set a class and move the map
Usually, if you want to toggle a DOM element's class, you would use something like this:
```javascript
document.getElementById(id).classList.toggle('someClass');
```
However, for this project, we're triggering the toggle based on a ```scrollEvent```. That happens often enough that it creates some rendering issues. (I had issues because I am highlighting the content based on the map's location.) So how do you get around that?

I set a check on the DOM element for the class before I toggled it.
```javascript
function setActiveChapter(chapterName)
            {
                if (chapterName === activeChapterName) return;
                map.flyTo(chapters[chapterName]);
                if (!document.getElementById(chapterName).classList.contains('active'))
                {
                    document.getElementById(chapterName).classList.toggle('active');
                }
                if (document.getElementById(activeChapterName).classList.contains('active'))
                {
                    document.getElementById(activeChapterName).classList.toggle('active');
                }
                activeChapterName = chapterName;
            }
```
You could use ```.toggle('someClass',true)``` to apply the ```force``` parameter. This will only add the class or remove the class once. However, that still resulted in multiple changes per second and was resulting in issues with rendering.

By checking if the property exists before toggling the class, the ```toggle()``` is only done once. The flickering stops. I would put up the older version, but those susceptible to seizures might not appreciate the effort.

You'll notice, this is where the map is actually changed.
```javascript
map.flyTo(chapters[chapterName]);
```
That sets the map to proper location, using the zoom, tilt, bearing, and speed settings in the ```chapters``` object.

Also, this function does a self-identity check. If the variable passed into the check is already the 'active' location, the function terminates.

#### Tie it all together
So far, I've coded a function to determine if the DOM element is visible on the screen and a function to toggle the class. Now, we just need to tie those two functions to the ```scrollEvent``` and call the function in our map.

```javascript
var activeChapterName = 'overview';
window.onscroll = function ()
{
    var chapterNames = Object.keys(chapters);
    for (var i = 0; i < chapterNames.length; i++) {
        var chapterName = chapterNames[i];
        if (isElementOnScreen(chapterName)) {
            setActiveChapter(chapterName);
            return;
        }
    }
};
```
When the page first loads, the ```overview``` section is at the top. So we declare the initial value of the ```activeChapterName``` to be the first section on the page. Then, I bind the ```window.onscroll``` event to a function. This is where we iterate through the chapters and manipulate the map.

Since we don't need to keep iterating through the ```chapters``` object after we find the top DOM element, we simply ```return``` once that DOM element has been set to active.

## Controlling the Page Content with the Map
So this was way easier than I thought it would be. I added a ```location``` property to the ```chapters``` object, inside the geoJSON ```properties```.

Clicking on the map's points will already open the popup. That click event returns the ```features``` which were clicked. Features will almost always be an array, but for my application, that's typically one point.

#### What did you click?
First, we identify the DOM element that corresponds to the clicked marker.
```javascript
var pageLocation = document.getElementById(e.features[0].properties.location);
```
Remember how I wrote that ```features``` will always be an array, but there could be multiple points? I'm taking the first point in the array.

#### The ```scrollIntoView()```  is your friend

```javascript
pageLocation.scrollIntoView(true);
```
This causes the page to scroll until the top of the DOM element is aligned to the top of the page. It's really that simple.
