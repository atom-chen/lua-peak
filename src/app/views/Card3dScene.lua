
local Card3d = class("Card3d", cc.load("mvc").ViewBase)

function Card3d:onCreate()
    -- self:addChild( require('GameCuoCardLayer2'):create(3,10) )
    -- self:addChild( require('GameCuoCardLayer'):create() )



    -- 搓牌结束回调函数
    local callFuncEnd = function()
        print('处理搓牌结束的逻辑代码')
    end
    -- 创建搓牌层
    local layerCuoCard3D = require("cuopai_3d"):create("big_card/CardBack.png", "big_card/25.png", "big_card/25.png",
        display.cx, display.cy, 1, callFuncEnd)
    self:addChild(layerCuoCard3D)

    local resetBtn = ccui.Button:create()
    resetBtn:setAnchorPoint(0,1)
    resetBtn:setTitleFontName('sans')
    resetBtn:setTitleText('RESET')
    resetBtn:setTitleFontSize(64)
    resetBtn:setPosition(0, display.height)
    resetBtn:onClick(function (  )
        self:getApp():enterScene('Card3dScene')
    end)
    self:addChild(resetBtn,2)

    local backBtn = resetBtn:clone()
    backBtn:setTitleText('BACK')
    backBtn:setPosition(0,display.height-64)
    self:addChild(backBtn,2)
    backBtn:onClick(function (  )
        self:getApp():enterScene('MainScene')
    end)
end

return Card3d
