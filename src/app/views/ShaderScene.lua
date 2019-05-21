
local ShaderScene = class("ShaderScene", cc.load("mvc").ViewBase)
local fs = cc.FileUtils:getInstance()
local shaders = require 'shaders'

function ShaderScene:onCreate()
    local layer = display.newLayer(cc.c3b(100,100,0))
    self:addChild(layer)

    local spr = display.newSprite('cocos.jpg')
    spr:setPosition(display.cx, display.cy)
    self:addChild(spr)

    dump(shaders)

    local program
    program = shaders.round()
    local shader = cc.GLProgramState:create(program)
    shader:setUniformFloat("u_edge", 0.04)
    spr:setGLProgramState(shader)
    -- spr:setGLProgram(program)
end

return ShaderScene
