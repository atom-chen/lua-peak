
--初始偏移
local beginoffsetY = 70
local beginoffsetX = 35

local log = release_print
local GameCuoCardLayer = class("GameCuoCardLayer", function()
    local gameLayer =  cc.LayerColor:create(cc.c4b(0, 0, 0, 125))
    return gameLayer
end)


function GameCuoCardLayer:create(cardColor,cardSize)
    local layer = GameCuoCardLayer.new();
    layer:init(cardColor,cardSize)
    return layer;
end

function GameCuoCardLayer:init(cardColor,cardSize)
    self.scrollUp = false
    self.scrollRight = false
    self.scrollLeft = false
    self.direction = false
    self.widget = {};
    self.m_endRub = false;
    local clipper = cc.ClippingNode:create();
    clipper:setPosition(0, 50 );
    self.widget.Panel_out = clipper;
    self.widget.Panel_out.m_srcPosition = cc.p( 0, 50  )
    --牌
    local faceNode = cc.Node:create()
    local cardImg = ccui.ImageView:create()
    --log(string.format("big_card/%d%d.png",2,10))
    cardImg:loadTexture(string.format("big_card/%d%d.png",cardColor,cardSize) ); --牌的颜色和大小
    cardImg:setPosition(cc.p( 640,-268 ))--268
    cardImg:setRotation(90 );
    faceNode:addChild( cardImg,10)
    cardImg:setScale( 1.2 );
    self.widget.Panel_out[ "Image_card" ] = cardImg;
    self.widget.Panel_out[ "Image_card" ].m_srcPositionY = -268;

    --白片
    local writeImg = ccui.ImageView:create()
    writeImg:loadTexture("big_card/zhedang.png");--
    writeImg:setAnchorPoint(cc.p(0, 1));
    writeImg:setPosition(cc.p( 0, 680 ))
    cardImg:addChild( writeImg, 11 )
    self.widget.Panel_out[ "Image_card" ].writeImg1 = writeImg;

    local writeImg2 = ccui.ImageView:create()
    writeImg2:loadTexture("big_card/zhedang1.png");
    writeImg2:setAnchorPoint(cc.p(0, 1));
    writeImg2:setPosition(cc.p( 446, 0 ))
    writeImg2:setRotation( 180 );
    cardImg:addChild( writeImg2, 11 )
    self.widget.Panel_out[ "Image_card" ].writeImg2 = writeImg2;


    --牌背
    local pbImg2 = ccui.ImageView:create()
    pbImg2:loadTexture("big_card/CardBack.png");
    pbImg2:setPosition(cc.p( 640, 224 ))
    pbImg2:setRotation( 90 );
    faceNode:addChild( pbImg2 )
    self.widget.Panel_out[ "Image_card_0" ] = pbImg2;
    self.widget.Panel_out[ "Image_card_0" ].m_srcPositionY = 224;
    self.widget.Panel_out[ "Image_card_0" ].m_srcPositionX = 640;

    ---///////////////裁剪模板
    local stencil = cc.Sprite:create("big_card/Bg.jpg");
    stencil:setAnchorPoint(cc.p(0.5, 1 ));
    stencil:setPosition(cc.p( 640,0 ))

    local stencil2 = cc.Sprite:create("big_card/zhezhao.png");--
    stencil2:setAnchorPoint(cc.p(0, 0));
    stencil2:setPosition(cc.p( 667 - (340 * 1.024), 720 ))
    stencil:addChild( stencil2 );
    stencil2:setScaleX( 0.2 );

    local stencil3 = cc.Sprite:create("big_card/zhezhao.png" );
    stencil3:setAnchorPoint(cc.p(0, 0));
    stencil3:setPosition(cc.p( 667 + (340 * 1.024), 720 ))
    stencil:addChild( stencil3 );
    stencil3:setScaleX( -0.2 );
    ---------------------------------------------------------------------------------------------------------

    self.widget.Panel_out.m_stencil2 = stencil2;
    self.widget.Panel_out.m_stencil3 = stencil3;
    self.widget.Panel_out.m_stencil = stencil;
    ----------------------------------------------------------------------------------------------------

    clipper:setStencil(stencil);    -- 设置裁剪模板 //3
    clipper:setInverted(true);     -- 设置底板可见
    clipper:setAlphaThreshold(0.1); -- 设置绘制底板的Alpha值为0
    clipper:addChild( faceNode ); -- 5
    self:addChild( clipper, 100 )

    self:registerTouchEvend()

    --test
    self:beginRubCardAction()

end

function GameCuoCardLayer:initPosition()

    if self.scrollUp == true then
        self.widget.Panel_out[ "Image_card" ].m_srcPositionY = -268; --正面
        self.widget.Panel_out[ "Image_card" ]:setPosition(cc.p(640,-268))
        self.widget.Panel_out[ "Image_card" ]:setVisible(true)
        self.widget.Panel_out[ "Image_card_0" ].m_srcPositionY = 224; --背面
        self.widget.Panel_out[ "Image_card_0" ]:setPosition(cc.p(640,224))
        self.widget.Panel_out[ "Image_card" ]:setScale(1.2)
        self.widget.Panel_out.m_stencil:setPosition(cc.p(640,0))
        self.widget.Panel_out.m_stencil2:setPosition(cc.p( 667 - (340 * 1.024), 720 ))
        self.widget.Panel_out.m_stencil3:setPosition(cc.p( 667 + (340 * 1.024), 720 ))
        self.widget.Panel_out.m_stencil2:setScale(1)
        self.widget.Panel_out.m_stencil3:setScale(1)
        self.widget.Panel_out.m_stencil2:setRotation(0)
        self.widget.Panel_out.m_stencil3:setRotation(0)
        self.widget.Panel_out.m_stencil3:setPositionX( 0.2 );
        self.widget.Panel_out.m_stencil2:setPositionX( -0.2 );

    end

    if self.scrollRight == true then
        self.widget.Panel_out[ "Image_card" ].m_srcPositionX = -60; --正面
        self.widget.Panel_out[ "Image_card" ]:setPosition(cc.p(-60,224))
        self.widget.Panel_out[ "Image_card" ]:setVisible(true)
        self.widget.Panel_out[ "Image_card_0" ].m_srcPositionX = 640; --背面
        self.widget.Panel_out.m_stencil:setPosition(cc.p(-365,500))
        self.widget.Panel_out.m_stencil2:setScale(1)
        self.widget.Panel_out.m_stencil3:setScale(1)
        self.widget.Panel_out.m_stencil2:setRotation(90)
        self.widget.Panel_out.m_stencil3:setRotation(-90)
        self.widget.Panel_out.m_stencil3:setPositionX( 1334 );
        self.widget.Panel_out.m_stencil2:setPositionX( 1334 );
    end

    if self.scrollLeft  == true then
        self.widget.Panel_out[ "Image_card" ].m_srcPositionX = 1334; --正面
        self.widget.Panel_out[ "Image_card" ]:setPosition(cc.p(1334,224))
        self.widget.Panel_out[ "Image_card" ]:setVisible(true)
        self.widget.Panel_out[ "Image_card_0" ].m_srcPositionX = 640; --背面
        self.widget.Panel_out.m_stencil:setPosition(cc.p(1650,500))
        self.widget.Panel_out.m_stencil2:setScale(1)
        self.widget.Panel_out.m_stencil3:setScale(1)
        self.widget.Panel_out.m_stencil2:setRotation(-90)
        self.widget.Panel_out.m_stencil3:setRotation(90)
        self.widget.Panel_out.m_stencil3:setPositionX(0);
        self.widget.Panel_out.m_stencil2:setPositionX(0);
    end
end
--开始搓牌动画
function GameCuoCardLayer:beginRubCardAction()
    --更新
    local function update()
        -- body
        self:update();
    end
    self:scheduleUpdateWithPriorityLua( update, 0)

end

--更新
function GameCuoCardLayer:update()
    if self.scrollUp == true then
        local diffy = self.widget.Panel_out:getPositionY() - self.widget.Panel_out.m_srcPosition.y;
        self.widget.Panel_out[ "Image_card" ]:setPositionY( self.widget.Panel_out[ "Image_card" ].m_srcPositionY + diffy );
        self.widget.Panel_out[ "Image_card_0" ]:setPositionY( self.widget.Panel_out[ "Image_card_0" ].m_srcPositionY - diffy  );

        --放大
        local sc = 1 + (diffy - 50 )/ 50 * 0.05;
        if sc > 1.2 then
            sc = 1.2;
        elseif sc < 1.024 then
            sc = 1.024;
        end
        self.widget.Panel_out[ "Image_card" ]:setScale( sc );

        --裁剪
        local sctmp1 = 0.8 * ( sc - 1.024 )  / 0.2;
        local sctmp2 = (340 * sc);

        self.widget.Panel_out.m_stencil2:setPositionX( 667 - sctmp2 );
        self.widget.Panel_out.m_stencil2:setScaleX( 0.2 + sctmp1 );

        self.widget.Panel_out.m_stencil3:setPositionX( 667 + sctmp2 );
        self.widget.Panel_out.m_stencil3:setScaleX( -0.2 - sctmp1 );
    end

    if self.scrollRight == true then
        local diffx = self.widget.Panel_out:getPositionX() - self.widget.Panel_out.m_srcPosition.x;
        self.widget.Panel_out[ "Image_card" ]:setPositionX( self.widget.Panel_out[ "Image_card" ].m_srcPositionX + diffx );
        self.widget.Panel_out[ "Image_card_0" ]:setPositionX( self.widget.Panel_out[ "Image_card_0" ].m_srcPositionX - diffx  );
        --放大
        local sc = 1 + (diffx - 50 )/ 50 * 0.01;
        if sc > 1.2 then
            sc = 1.2;
        elseif sc < 1.024 then
            sc = 1.024;
        end
        self.widget.Panel_out[ "Image_card" ]:setScale( sc );
        --裁剪

        local sctmp2 = 35 * sc;


        self.widget.Panel_out.m_stencil2:setPositionY(685+sctmp2);
        self.widget.Panel_out.m_stencil2:setScaleY(2.5);

        self.widget.Panel_out.m_stencil3:setPositionY(263-sctmp2);
        self.widget.Panel_out.m_stencil3:setScaleY(-2.5);
    end

    if self.scrollLeft == true then
        local diffx = self.widget.Panel_out:getPositionX() - self.widget.Panel_out.m_srcPosition.x;
        self.widget.Panel_out[ "Image_card" ]:setPositionX( self.widget.Panel_out[ "Image_card" ].m_srcPositionX + diffx );
        self.widget.Panel_out[ "Image_card_0" ]:setPositionX( self.widget.Panel_out[ "Image_card_0" ].m_srcPositionX - diffx  );
        --放大
        local sc = 1 + (diffx - 50 )/ 50 * 0.01;
        if sc > 1.2 then
            sc = 1.2;
        elseif sc < 1.024 then
            sc = 1.024;
        end
        self.widget.Panel_out[ "Image_card" ]:setScale( sc );
        --裁剪

        local sctmp2 = 35 * sc;


        self.widget.Panel_out.m_stencil2:setPositionY(280-sctmp2);
        self.widget.Panel_out.m_stencil2:setScaleY(2);

        self.widget.Panel_out.m_stencil3:setPositionY(668+sctmp2);
        self.widget.Panel_out.m_stencil3:setScaleY(-2);
    end
end


-- 触摸事件
function GameCuoCardLayer:registerTouchEvend()
    if self.m_pListener then
        return;
    end
    self.m_pListener = cc.EventListenerTouchOneByOne:create()
    self.m_pListener:setSwallowTouches(true)
    self.m_pListener:registerScriptHandler( function(touch, event)

        if self.m_endRub == true then
            return true;
        end

        self.widget.Panel_out:stopAllActions();

        --[[local diffy = self.widget.Panel_out:getPositionY() - self.widget.Panel_out.m_srcPosition.y;
        if math.abs( diffy ) < beginoffset then
            self.widget.Panel_out:setPositionY( self.widget.Panel_out.m_srcPosition.y + beginoffset  );
        end]]

        self.widget.Panel_out.m_touchSrcPosition = cc.p( self.widget.Panel_out:getPosition() );
        return true;
    end, cc.Handler.EVENT_TOUCH_BEGAN)

    self.m_pListener:registerScriptHandler( function(touch, event)
            if self.m_endRub then
                return;
            end

            local startPos = touch:getStartLocation();
            local movetPos = touch:getLocation();

            if self.widget.Panel_out.m_touchSrcPosition == nil then
                self.widget.Panel_out.m_touchSrcPosition = cc.p( self.widget.Panel_out:getPosition() );
            end
            if self.direction == false then
                if movetPos.y - startPos.y >=50 then
                    log("scrollUp")
                    self.direction = true
                    self.scrollUp = true
                    self:initPosition()

                elseif movetPos.x - startPos.x >=50 then
                    log("scrollRight")
                    self.direction = true
                    self.scrollRight = true
                    self:initPosition()

                elseif movetPos.x - startPos.x <=-50 then
                    log("self.scrollLeft")
                    self.direction = true
                    self.scrollLeft = true
                    self:initPosition()
                end
            end

            if self.scrollUp == true then
                local diffy = self.widget.Panel_out.m_touchSrcPosition.y + (movetPos.y - startPos.y);
                if  diffy  - self.widget.Panel_out.m_srcPosition.y < beginoffsetY then--最小
                    self.widget.Panel_out:setPositionY( self.widget.Panel_out.m_srcPosition.y + beginoffsetY  );
                else
                    --最大
                    if diffy  - self.widget.Panel_out.m_srcPosition.y > 300 then
                        self.widget.Panel_out:setPositionY( self.widget.Panel_out.m_srcPosition.y + 268  );
                        --搓翻
                        self:setRubEnd();
                    else
                        self.widget.Panel_out:setPositionY( diffy );
                    end

                end
            end

            if self.scrollRight == true then
                local diffx = self.widget.Panel_out.m_touchSrcPosition.x + (movetPos.x - startPos.x);
                if  diffx  - self.widget.Panel_out.m_srcPosition.x < beginoffsetX then
                    --最小

                else
                    --最大
                    if diffx  - self.widget.Panel_out.m_srcPosition.x > 370 then
                        --搓翻
                        self:setRubEnd();
                    else
                        self.widget.Panel_out:setPositionX( diffx );
                    end
                end
            end

            if self.scrollLeft == true then
                local diffx = self.widget.Panel_out.m_touchSrcPosition.x + (movetPos.x - startPos.x);
                if  self.widget.Panel_out.m_srcPosition.x -diffx < beginoffsetX then--最小

                else
                    --最大
                    if  self.widget.Panel_out.m_srcPosition.x -diffx > 350 then
                        --搓翻
                        self:setRubEnd();
                    else
                        self.widget.Panel_out:setPositionX( diffx );
                    end
                end
            end

    end, cc.Handler.EVENT_TOUCH_MOVED)

    self.m_pListener:registerScriptHandler( function(touch, event)
            --回退
            if self.m_endRub == false then
                self.widget.Panel_out:runAction(cc.Sequence:create(
                    cc.MoveTo:create( 0.1, self.widget.Panel_out.m_srcPosition ),
                    cc.CallFunc:create(function()
                        self.scrollUp = true
                        self:initPosition()
                        self.widget.Panel_out[ "Image_card" ]:setVisible(false)
                        self.scrollUp = false
                        self.scrollRight = false
                        self.scrollLeft = false
                        self.direction = false
                        end) ))
            end

    end, cc.Handler.EVENT_TOUCH_ENDED)

    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(self.m_pListener, self )
end


--检测搓完
function GameCuoCardLayer:setRubEnd()
    --end
    --结束
    self.m_endRub = true;
    --开始动画阶段
    self:RubCardAction();
end


--搓牌动画阶段
function GameCuoCardLayer:RubCardAction()
    -- self.widget.Panel_out:runAction( cc.MoveTo:create( 0.1, self.widget.Panel_out.m_srcPosition ) )
    --self.widget.Panel_out[ "Image_card" ]:runAction( cc.ScaleTo:create(0.4, 1, 1 )  );

    performWithDelay( self, function()
        --动画结束回调
        self:spineEnd();
    end, 0.4)


end


--spine动画结束
function GameCuoCardLayer:spineEnd()
    self:unscheduleUpdate();

    --搓牌可见
    -- self:setRubCardPanelVisible( true );
    -- self:setRubCardVisible( true )

    self.widget.Panel_out:setPosition( self.widget.Panel_out.m_srcPosition )
    self.widget.Panel_out[ "Image_card" ]:setScale( 1 );
    self.widget.Panel_out[ "Image_card" ]:setPositionY( self.widget.Panel_out[ "Image_card_0" ].m_srcPositionY );
    self.widget.Panel_out[ "Image_card" ]:setPositionX( self.widget.Panel_out[ "Image_card_0" ].m_srcPositionX );
    self.widget.Panel_out[ "Image_card_0" ]:setVisible( false );
    self.widget.Panel_out.m_stencil2:setVisible(false)
    self.widget.Panel_out.m_stencil3:setVisible(false)
   --[[ local act = cc.Sequence:create( cc.FadeOut:create( 0.5 ), cc.DelayTime:create( 1.5 ), cc.CallFunc:create(function ()
            self:removeFromParent();
    end)  )]]
   self.widget.Panel_out[ "Image_card" ].writeImg1:runAction(cc.FadeOut:create( 0.5 ));
   self.widget.Panel_out[ "Image_card" ].writeImg2:runAction(cc.FadeOut:create( 0.5 ));
end
return GameCuoCardLayer
--endregion
