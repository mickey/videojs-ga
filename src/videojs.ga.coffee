##
# ga
# https://github.com/mickey/videojs-ga
#
# Copyright (c) 2013 Michael Bensoussan
# Licensed under the MIT license.
##

videojs.plugin 'ga', (options = {}) ->
  # this loads options from the data-setup attribute of the video tag
  dataSetupOptions = {}
  if @options()["data-setup"]
    parsedOptions = JSON.parse(@options()["data-setup"])
    dataSetupOptions = parsedOptions.ga if parsedOptions.ga

  defaultsEventsToTrack = [
    'loaded', 'percentsPlayed', 'start',
    'end', 'seek', 'play', 'pause', 'resize',
    'volumeChange', 'error', 'fullscreen'
  ]
  eventsToTrack = options.eventsToTrack || dataSetupOptions.eventsToTrack || defaultsEventsToTrack
  percentsPlayedInterval = options.percentsPlayedInterval || dataSetupOptions.percentsPlayedInterval || 10

  eventCategory = options.eventCategory || dataSetupOptions.eventCategory || 'Video'
  # if you didn't specify a name, it will be 'guessed' from the video src after metadatas are loaded
  eventLabel = options.eventLabel || dataSetupOptions.eventLabel

  # init a few variables
  percentsAlreadyTracked = []
  seekStart = seekEnd = 0
  seeking = false

  loaded = ->
    unless eventLabel
      eventLabel = @currentSrc().split("/").slice(-1)[0].replace(/\.(\w{3,4})(\?.*)?$/i,'')

    if "loadedmetadata" in eventsToTrack
      sendbeacon( 'loadedmetadata', true )

    return

  timeupdate = ->
    currentTime = Math.round(@currentTime())
    duration = Math.round(@duration())
    percentPlayed = Math.round(currentTime/duration*100)

    for percent in [0..99] by percentsPlayedInterval
      if percentPlayed >= percent && percent not in percentsAlreadyTracked

        if "start" in eventsToTrack && percent == 0 && percentPlayed > 0
          sendbeacon( 'start', true )
        else if "percentsPlayed" in eventsToTrack && percentPlayed != 0
          sendbeacon( 'percent played', true, percent )

        if percentPlayed > 0
          percentsAlreadyTracked.push(percent)

    if "seek" in eventsToTrack
      seekStart = seekEnd
      seekEnd = currentTime
      # if the difference between the start and the end are greater than 1 it's a seek.
      if Math.abs(seekStart - seekEnd) > 1
        seeking = true
        sendbeacon( 'seek start', false, seekStart )
        sendbeacon( 'seek end', false, seekEnd )

    return

  end = ->
    sendbeacon( 'end', true )
    return

  play = ->
    currentTime = Math.round(@currentTime())
    if currentTime > 0 && !seeking
      sendbeacon( 'play', true, currentTime )
    seeking = false
    return

  pause = ->
    currentTime = Math.round(@currentTime())
    duration = Math.round(@duration())
    if currentTime != duration && !seeking
      sendbeacon( 'pause', false, currentTime )
    return

  # value between 0 (muted) and 1
  volumeChange = ->
    volume = if @muted() == true then 0 else @volume()
    sendbeacon( 'volume change', false, volume )
    return

  resize = ->
    sendbeacon( 'resize - ' + @width() + "*" + @height(), true )
    return

  error = ->
    currentTime = Math.round(@currentTime())
    # XXX: Is there some informations about the error somewhere ?
    sendbeacon( 'error', true, currentTime )
    return

  fullscreen = ->
    currentTime = Math.round(@currentTime())
    if @isFullscreen()
      sendbeacon( 'enter fullscreen', false, currentTime )
    else
      sendbeacon( 'exit fullscreen', false, currentTime )
    return

  sendbeacon = ( action, nonInteraction, value ) ->
    if window.ga
      ga 'send', 'event',
        'eventCategory' 	: eventCategory
        'eventAction'		  : action
        'eventLabel'		  : eventLabel
        'eventValue'      : value
        'nonInteraction'	: nonInteraction
    else if window._gaq
      _gaq.push(['_trackEvent', eventCategory, action, eventLabel, value, nonInteraction])
    else
      console.log("Google Analytics not detected")
    return

  @ready ->
    @on("loadedmetadata", loaded)
    @on("timeupdate", timeupdate)
    @on("ended", end) if "end" in eventsToTrack
    @on("play", play) if "play" in eventsToTrack
    @on("pause", pause) if "pause" in eventsToTrack
    @on("volumechange", volumeChange) if "volumeChange" in eventsToTrack
    @on("resize", resize) if "resize" in eventsToTrack
    @on("error", error) if "error" in eventsToTrack
    @on("fullscreenchange", fullscreen) if "fullscreen" in eventsToTrack
  return
