# Map Resume using MapboxGL Javascript
For geographers, like me, location matters. A resume with just the facts of a job don't tell the whole story of where that work was conducted. Travel and experiencing other cultures brings incredible skills that just don't translate to "worked with cross-cultural team." It also makes your resume a little more fun and interesting.

## Attribution:
I loosely based this project on a published web-map project I found online. Despite my best searching efforts, I haven't found the site as of the time of this publication. I wish that I could, so I could provide some credit where it is due. Some of the heavy lifting was done through that project. I modified my project to meet my needs, but I did get some core ideas of how to approach this via another developer. I'll update this portion as soon as I can find the project.

## Mapbox GL Javascript
I choose Mapbox GL library as my mapping javascript library for two reasons:
1. I had worked with Mapbox's software and services before. They're a good company and have great products that are easy to use.
2. They offer *FREE*(!) usage of their library. If you want use their tiles (background or basemap), there are free tiers that will work for most projects.

## Structure
This project can be a single page. I broke it out into multiple files in order to facilitate ease of development. That's a personal choice. Obviously, you can go your own way!

I put my data into a single file, outside of the Javascript, as a means of showing how you can use an external data source. If you want to see how to use Google Sheets as your data repository, I found this example using Leaflet and Google Sheets: [DataVizForAll](https://github.com/DataVizForAll/leaflet-storymaps-with-google-sheets).
