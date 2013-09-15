# videojs-ga

Google Analytics plugin for video.js

## Getting Started
Download [videojs](http://www.videojs.com/) and [videojs.ga](https://github.com/mickey/videojs-ga)

In your web page:
```html
<video id="video" src="movie.mp4" controls></video>
<script src="video.js"></script>
<script src="dist/videojs.ga.min.js"></script>
<script>
videojs('video', {}, function() {
  var player = this;
  player.ga(); // "load the plugin, by defaults tracks everything!!"
});
</script>
```

_Please note that the Google Analytics script must be loaded before the ga plugin_

## Options

You can provide options to the plugin either by passing them in the javascript or in the html.

```javascript
player.ga({
  'eventsToTrack': ['fullscreen', 'resize']
});
```

```html
<video id="video" src="movie.mp4" controls data-setup='{"ga": {"eventsToTrack": ["error"]}}'></video>
```

The plugin will take in priority options provided in the javascript, followed by the ones provided in html and finally the defaults.

The following options are supported:

####eventCategory

This is the ```category``` sent to GA. If you don't know what it is please check [GA's doc](https://developers.google.com/analytics/devguides/collection/gajs/eventTrackerGuide)
**default:** ```'Video'```


####eventLabel

This is the ```label``` sent to GA. If you don't know what it is please check [GA's doc](https://developers.google.com/analytics/devguides/collection/gajs/eventTrackerGuide)
**default:** basename of the video path so if the path is ```http://s3.amazonaws.com/pouet.mp4``` the label would be ```pouet```

####eventsToTrack

The events you want to track. Most of this events are videojs events. Some of them might reflects my needs.
I'm open to add some more if you care to provide a good use case or a pull request.
**default:** every events
  ```[ 'loaded', 'percentsPlayed', 'start', 'end', 'seek', 'play', 'pause', 'resize', 'volumeChange', 'error', 'fullscreen', 'srcType']```

Most of the events are selft explanatory, here's the ones that may need more details:

- ```srcType```: will send the engine along with the source type being played. exemple: ```html5/mp4```
- ```percentsPlayed```: will send an every X percents. X being defined by the option ```percentsPlayedInterval```.

####percentsPlayedInterval

This options goes with the ```percentsPlayed``` event. Every ```percentsPlayedInterval``` percents an event will be sent to GA.
**default:** 10


## TODO

- [x] track the engine used (html5/flash) along with the source (ogg, mp4, ...)
- [ ] track the time to download the video
