
local MainScene = class("MainScene", cc.load("mvc").ViewBase)
local fs = cc.FileUtils:getInstance()

function MainScene:onCreate()
    local y = display.height
    local dir = fs:getDefaultResourceRootPath() .. 'src/app/views/'
    local files = fs:listFiles(dir)
    table.sort(files)
    for _,v in ipairs(files) do
        if (v:ends('Scene.lua')) then
            local info = io.pathinfo(v)

            local btn = ccui.Button:create()
            btn:setAnchorPoint(0.5,1)
            btn:setTitleFontName('sans')
            btn:setTitleText(info.basename)
            btn:setTitleFontSize(64)
            btn:setPosition(display.cx, y)
            btn:onClick(function (  )
                self:getApp():enterScene(info.basename)
            end)

            self:addChild(btn)
            y = y - 60
        end
    end


end

return MainScene
