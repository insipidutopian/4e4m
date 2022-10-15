-- Common SSK Helper Modules
local easyIFC = ssk.easyIFC;local persist = ssk.persist

local textParams = 
      { 
          font                 = "fonts/Aclonica.ttf",
          fontSize             = 20,
          textColor            = {0.6,0.0,0.0,1.0},
          embossTextColor      = {0.6,0.0,0.0,1.0},
          embossHighlightColor = _YELLOW_,
          embossShadowColor    = _BLACK_,
      }
ssk.easyIFC:addLabelPreset("title", textParams)

textParams.fontSize = 16
ssk.easyIFC:addLabelPreset("appLabel", textParams)

textParams.fontSize = 14
ssk.easyIFC:addLabelPreset("appSmall", textParams)

textParams.fontSize = 16
textParams.textColor = {0,0,0,1}
ssk.easyIFC:addLabelPreset("darkText", textParams)



local buttonParams = 
{ 
    labelColor         = {0.6,0.0,0.0,1},
    labelSize          = 16,
    labelFont          = "fonts/Aclonica.ttf",
    unselRectFillColor = { 0.0,  0.0,  0.0, 1},
    selRectFillColor   = {0.1, 0.1, 0.1, 1},
    strokeWidth        = 2,
    strokeColor        = {0.6,0.0,0.0,0.5},
    emboss             = false, 
}

ssk.easyIFC:addButtonPreset( "appButton", buttonParams )

buttonParams.labelColor = {0.6,0.6,0.6,1}
buttonParams.strokeColor = {0.6,0.6,0.6,0.5}
ssk.easyIFC:addButtonPreset( "disabledAppButton", buttonParams )

local buttonLinkParams = 
{ 
    labelColor         = {0.6,0.0,0.0,1},
    labelSize          = 10,
    labelFont          = "fonts/kellunc.ttf",
    emboss             = false, 
}
ssk.easyIFC:addButtonPreset("linkButton", buttonLinkParams)

local squareButtonLinkParams = 
{ 
    labelColor         = {0.6,0.0,0.0,1},
    labelSize          = 10,
    labelFont          = "fonts/kellunc.ttf",
    unselImgSrc        = "button_celticspears_square.png",
    selImgSrc          = "button_celticspears_square.png",
    emboss             = false, 
}
ssk.easyIFC:addButtonPreset("squareButton", squareButtonLinkParams)

local wideButtonLinkParams = 
{ 
    labelColor         = {0.6,0.0,0.0,1},
    labelSize          = 10,
    labelFont          = "fonts/kellunc.ttf",
    unselImgSrc        = "button_celticspears_wide.png",
    selImgSrc          = "button_celticspears_wide.png",
    emboss             = false, 
}
ssk.easyIFC:addButtonPreset("wideButton", wideButtonLinkParams)


local titleInputParams = 
{ 
    textColor         = {0.6, 0.0, 0.0, 1},
    fontSize           = 20,
    font               = "fonts/Aclonica.ttf",
    isEditable         = true, 
    hasBackground      = false,
    width              = 180,
    height             = 20
}
ssk.easyIFC:addTextInputPreset("title", titleInputParams)

titleInputParams.fontSize = 17

ssk.easyIFC:addTextInputPreset("default", titleInputParams)

local textInputBoxParams = 
{ 
    textColor         = {0.6, 0.0, 0.0, 1},
    fontSize           = 16,
    font               = "fonts/Aclonica.ttf",
    isEditable         = true, 
    hasBackground      = false,
    width              = 240,
    height             = 40
}
ssk.easyIFC:addTextInputBoxPreset("default", textInputBoxParams)


local giantInputParams = 
{ 
    textColor         = {0.6, 0.0, 0.0, 1},
    fontSize           = 30,
    font               = "fonts/Aclonica.ttf",
    isEditable         = true, 
    hasBackground      = false,
    width              = 180,
    height             = 30
}
ssk.easyIFC:addTextInputPreset("giant", giantInputParams)

local ddmParams = 
{   height             = 25,
    width              = 150,
    borderColor        = {0.6, 0, 0, 1},
    fontSize           = 16,
    font               = "fonts/Aclonica.ttf",
    textColor          = {0.6, 0, 0, 1},
    fillColor          = _BLACK_,
    rowHeight          = 25,
    rowColor           = _BLACK_,
    
}
ssk.easyIFC:addDropDownMenuPreset("default", ddmParams)
