--require
require("public")
require("util")
require("ui")
require("coin")
local bb = require("3rd.badboy")
local json = bb.json
--moudle
self = {}

--config
CONFIG_coin = 0

--main
function main()
	--init
	init("0", 1);
	setScreenScale(1242,2208)--以iphone7plus为基础制作脚本
	util.initMyHud()
	--UI
	local ret, results = showUI(json.encode(ui.configUI()))    --table转json
	
	--标记
	_G["coinFinished"] = false
	
	--点击确认返回1, 取消返回0
	if ret == 1 then
		--results 返回以id为key的Map类型数据,返回值为字符串
		missionType = tonumber(results["MissionRadioGroup"])--0:无限魔女
		if missionType == 0 then --清每日一条龙副本
			CONFIG_coin = 1
		end
	else
		dialog("主人拜拜,我们下次见哦~", 0)
		lua_exit()
	end
	
	if CONFIG_coin == 0 then
		dialog("主人,要记得选择功能哦~",0)
		main()
		return 0
	end
	
	repeat
		public.func_start_init()
		if CONFIG_coin == 1  and not _G["coinFinished"] then
			coin.coinMain()
		end
		mSleep(500)
	until(_G["coinFinished"])
	
	--跳出主循环后
	if _G["coinFinished"] then
		--任务结束提示
		util.hudToast("任务已经执行完毕,待机中...")
	end
	
	repeat
		--重置系统锁屏时间
		resetIDLETimer()
	until(false)
end
main()
return self