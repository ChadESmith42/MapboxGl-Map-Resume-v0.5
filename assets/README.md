# Map Resume using MapboxGL Javascript
For geographers, like me, location matters. A resume with just the facts of a job don't tell the whole story of where that work was conducted. Travel and experiencing other cultures brings incredible skills that just don't translate to "worked with cross-cultural team." It also makes your resume a little more fun and interesting.

## Attribution:
I loosely based this project on a published web-map project I found online. Despite my best searching efforts, I haven't found the site as of the time of this publication. I wish that I could, so I could provide some credit where it is due. Some of the heavy lifting was done through that project. I modified my project to meet my needs, but I did get some core ideas of how to approach this via another developer. I'll update this portion as soon as I can find the project.

## Mapbox GL Javascript
I choose Mapbox GL library as my mapping javascript library for two reasons:
1. I had worked with Mapbox's software and services before. They're a good company and have great products that are easy to use.
2. They offer __*FREE*(!!!)__ usage of their library. If you want use their tiles (background or basemap), there are free tiers that will work for most projects.

## Structure
This project can be a single page. I broke it out into multiple files in order to facilitate ease of development. That's a personal choice. Obviously, you can go your own way!

I put my data into a single file, outside of the Javascript, as a means of showing how you can use an external data source. If you want to see how to use Google Sheets as your data repository, I found this example using Leaflet and Google Sheets: [DataVizForAll](https://github.com/DataVizForAll/leaflet-storymaps-with-google-sheets).

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
        }
    },
```
