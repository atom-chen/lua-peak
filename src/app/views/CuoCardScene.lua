
local CuoCardScene = class("CuoCardScene", cc.load("mvc").ViewBase)
local fs = cc.FileUtils:getInstance()

function CuoCardScene:onCreate()
    self:addChild( require('GameCuoCardLayer2'):create(3,10) )
    -- self:addChild( require('GameCuoCardLayer'):create() )
end

return CuoCardScene
