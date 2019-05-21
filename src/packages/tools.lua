
function string.starts( str, start )
    return string.sub(str,1,string.len(start)) == start
end
function string.ends(str, ending)
   return ending == "" or str:sub(-#ending) == ending
end

local Widget = ccui.Widget
Widget.onClick = Widget.addClickEventListener
