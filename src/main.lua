print = release_print
package.path = '?.lua;src/?.lua;src/packages/?.lua'

cc.FileUtils:getInstance():setPopupNotify(false)

require "config"
require "cocos.init"
require 'tools'

local startScene
-- startScene = 'Card3dScene'
local function main()
    cc.exports.app = require("app.MyApp"):create()
    app:run(startScene)
end

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    print(msg)
end
