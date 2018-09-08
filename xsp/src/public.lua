require("util")
public = {}

--循环关闭弹子菜单到无法退出为止
function public.closeMenuIfNecessary()
	x , y = util.findColor(0x1f2a42, 90, 90, 0, 135, 30)--返回的背景颜色:暗蓝
	x1 , y1 = util.findColor(0x0ed1e5, 90, 90, 0, 135, 30)--返回的背景颜色:亮蓝
	if x > -1 and x1 > -1 then
		util.click(117,63)
		util.hudToast("关闭子菜单")
		mSleep(1000)
		public.closeMenuIfNecessary()
		return 0
	else
		util.hudToast("准备就绪")
	end
end

--等到页面出现(左上角的返回按钮出现代表页面加载完毕)
function public.waitUntilViewDidAppear()
	util.hudToast("等待页面加载完毕...")
	public.colseAllAlertIfNecessary()--检测组队弹窗:有测关闭
	mSleep(500)
	x , y = util.findColor(0x1f2a42, 90, 90, 0, 135, 30)--返回的背景颜色:暗蓝
	x1 , y1 = util.findColor(0x0ed1e5, 90, 90, 0, 135, 30)--返回的背景颜色:亮蓝
	if x > -1 and x1 > -1 then
		mSleep(500)
		return true
	else
		if public.detect_main() then--保护如果此时在世界地图,则跳出循环
			return false
		elseif public.detectChuangGuanView() == 1 then
			return false
		else
			--点击空白区域
			util.click(970,1070)
			mSleep(500)
			public.waitUntilViewDidAppear()
		end
	end
end

--定位屏幕位置
function public.func_start_init()
	--重置系统锁屏时间
	resetIDLETimer()
	
	public.colseAllAlertIfNecessary()--检测组队弹窗:有测关闭
	
	--关闭子菜单
	public.closeMenuIfNecessary()
	
end

function public.detectChuangGuanView()
	x , y = util.findColor(0xe6a127, 90, 1722, 1088, 1952, 1166)--再次闯关背景:蓝色
	x1 , y1 = util.findColor(0xffffff, 90, 1722, 1088, 1952, 1166)--再次闯关文案:白色
	x3 , y3 = util.findColor(0x34a0d5, 90, 1393, 1100, 1550, 1170)--返回背景:蓝色
	x4 , y4 = util.findColor(0xffffff, 90, 1393, 1100, 1550, 1170)--返回文案:白色
	if x > -1 and x1 > -1 and x3 > -1 and x4 > -1  then
		return 1--再次闯关界面
	else
		return 0
	end
end

--检测是否在游戏中
function public.playing_game()
	public.colseAllAlertIfNecessary()--检测组队弹窗:有测关闭
	--保护:检测是否出现了再次闯关按钮
	if public.detectChuangGuanView() == 1 then
		return 0--再次闯关
	end
	
	--保护:是否出现了返回按钮
	x , y = util.findColor(0x1f2a42, 90, 90, 0, 135, 30)--返回的背景颜色:暗蓝
	x1 , y1 = util.findColor(0x0ed1e5, 90, 90, 0, 135, 30)--返回的背景颜色:亮蓝
	if x > -1 and x1 > -1 then
		return 1--重开任务
	end
	
	--保护:检测是否在主界面
	if public.detect_main() then
		return 1--重开任务
	end
	
	--点击空白区域
	util.click(970,1070)
	mSleep(1500)
	
	--无限循环,直到自动游戏结束为止(结束条件:检测到大地图 或 出现了返回按钮 或 出现再次闯关界面)
	public.playing_game()
end

function public.colseAllAlertIfNecessary()
	--关闭沉迷弹窗
	public.closeChenMiAlertIfNecessary()
	--关闭组队邀请弹窗
	public.detectZuDuiAlert()
end

--检测防沉迷下线弹窗
function public.detectXiaXianTanChuang()
	x , y = util.findColor(0x1999d7, 90, 1040, 305, 1161, 357)--标题背景：蓝色
	x1 , y1 = util.findColor(0xffffff, 90, 1040, 305, 1161, 357)--标题文案：白色
	x2 , y2 = util.findColor(0x359fd5, 90, 833, 813, 852, 870)--帮助按钮背景：蓝色
	x3 , y3 = util.findColor(0xffffff, 90, 833, 813, 852, 870)--帮助按钮文案：白色
	x4 , y4 = util.findColor(0xe8a025, 90, 1252, 816, 1371, 868)--确定按钮背景：黄色
	x5 , y5 = util.findColor(0xffffff, 90, 1252, 816, 1371, 868)--确定按钮文案：白色
	
	if x > -1 and x1 > -1 and x2 > -1 and x3 > -1 and x4 > -1 and x5 > -1 then
		util.hudToast("检测到防沉迷弹窗")
		util.click(1545,853)
		mSleep(500)
		return 1
	else
		return 0
	end
end

--检测禁止闯关弹窗
function public.closeBanAlertIfNecessary()
	x , y = util.findColor(0x1b9ad8, 90, 1038, 297, 1163, 356)--标题背景：蓝色
	x1 , y1 = util.findColor(0xffffff, 90, 1038, 297, 1163, 356)--标题文案：白色
	x2 , y2 = util.findColor(0xe89f23, 90, 1005, 805, 1176, 866)--确认按钮背景：黄色
	x3 , y3 = util.findColor(0xffffff, 90, 1005, 805, 1176, 866)--确认按钮文案：白色
	
	if x > -1 and x1 > -1 and x2 > -1 and x3 > -1 then
		util.hudToast("检测到禁止闯关弹窗")
		util.click(1107,845)
		mSleep(500)
		return 1
	else
		return 0
	end
end

--关闭沉迷弹窗
function public.closeChenMiAlertIfNecessary()
	x , y = util.findColor(0xd44467, 90, 1107, 355, 1355, 407)--标题:粉色
	x1 , y1 = util.findColor(0x37215b, 90, 1107, 355, 1355, 407)--标题背景:紫黑色
	x2 , y2 = util.findColor(0x306790, 90, 2207, 1241, 1321, 882)--帮助按钮背景：蓝色
	x3 , y3 = util.findColor(0xf3dadf, 90, 2207, 1241, 1321, 882)--帮助按钮文案：白色
	x4 , y4 = util.findColor(0xba244a, 90, 1481, 828, 1633, 888)--确定按钮背景：粉色
	x5 , y5 = util.findColor(0xf4dde2, 90, 1481, 828, 1633, 888)--确定按钮文案：白色
	
	if x > -1 and x1 > -1 and x2 > -1 and x3 > -1 and x4 > -1 and x5 > -1 then
		util.hudToast("检测到防沉迷弹窗")
		util.click(1545,853)
		mSleep(500)
		return 1
	else
		return 0
	end
end

--检测组队邀请弹窗
function public.detectZuDuiAlert()
	x , y = util.findColor(0xffffff, 90, 1000, 236, 1190, 291)--标题:白色
	x1 , y1 = util.findColor(0x1c97d4, 90, 1000, 236, 1190, 291)--标题背景:蓝色
	x2 , y2 = util.findColor(0xfefefe, 90, 665, 817, 807, 882)--拒绝文案:白色
	x3 , y3 = util.findColor(0x359fd5, 90, 665, 817, 807, 882)--拒绝背景:蓝色
	x4 , y4 = util.findColor(0xffffff, 90, 1400, 820, 1578, 889)--接受按钮文案:白色
	x5 , y5 = util.findColor(0xe89f23, 90, 1400, 820, 1578, 889)--接受按钮背景:黄色
	if x > -1 and x1 > -1 and x2 > -1 and x3 > -1 and x4 > -1 and x5 > -1 then
		util.hudToast("检测到组队邀请弹窗")
		util.click(1668,264)
		mSleep(500)
		return 1
	else
		return 0
	end
end

--检测是否在主界面
function public.detect_main()
	x , y = util.findColor(0xb6b8bf, 90, 157, 25, 300, 53)--名字:白色
	x1 , y1 = util.findColor(0xfce969, 90, 971, 35, 1027, 75)--金币:金色
	x2 , y2 = util.findColor(0x8a6bb5, 90, 1185, 30, 1235, 76)--钻石:紫色
	x3 , y3 = util.findColor(0x82bde1, 90, 1410, 32, 1455, 76)--点券:蓝色
	x4 , y4 = util.findColor(0xaedff3, 90, 66, 1172, 118, 1206)--左下角：英雄图标
	x5 , y5 = util.findColor(0xf9bfba, 90, 2033, 1093, 2155, 1212)--右下角妲己:脸粉色
	if x > -1 and x1 > -1 and x2 > -1 and x3 > -1 and x4 > -1 and x5 > -1 then
		return true
	else
		return false
	end
end

return public