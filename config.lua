if string.sub(system.getInfo("model"),1,4) == "iPad" then
    application = {
       content = {
          width              = display.pixelWidth/4,
          height             = display.pixelHeight/4,
          scale              = "letterbox",
          fps                = 30,
       },
    }
elseif system.getInfo("platform")=="macos" then
    application = {
       content = {
          width              = 640,
          height             = 960,
          scale              = "dynamic",
          fps                = 30,
       },
    }
else
    application = {
       content = {
          width              = display.pixelWidth/3,
          height             = display.pixelHeight/3,
          scale              = "letterbox",
          fps                = 30,
       },
    }
end
