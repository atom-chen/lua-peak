
local EraserScene = class("EraserScene", cc.load("mvc").ViewBase)
local fs = cc.FileUtils:getInstance()

function EraserScene:onCreate()
    local spr = cc.Sprite:create('HelloWorld.png')
    spr:setPosition(display.cx, display.cy)
    self:addChild(spr)

end
return EraserScene
