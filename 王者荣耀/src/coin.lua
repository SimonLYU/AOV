require "util"
require "public"

coin = {}
STEP_coin = 0

--0 点击对战
function func_clickDuiZhan()
	util.hudToast("点击对战")
	util.click(661,568)
	STEP_coin = 1
end

--1 点击冒险模式
function func_clickMaoXian()
	util.hudToast("点击冒险")
	util.click(1400,800)
	STEP_coin = 2
end

--2 点击挑战
function func_clickTiaoZhan()
	util.hudToast("点击挑战")
	util.click(1000,625)
	STEP_coin = 3
end

--3 选择魔女回忆
function func_chooseMission()
	util.hudToast("选择关卡")
	moveDownTimes(1)
	mSleep(500)
	util.hudToast("点击陨落的废都")
	util.click(552,347)--点击陨落的废都
	mSleep(500)
	util.hudToast("点击大师")
	util.click(1845,791)--点击大师
	mSleep(500)
	util.hudToast("点击魔女的回忆")
	util.click(1220,528)--点击魔女的回忆
	mSleep(500)
	util.hudToast("点击下一步")
	util.click(1853,1117)--点击下一步
	STEP_coin = 4
end

--4 点击闯关
function func_clickChuangGuan()
	util.hudToast("点击闯关")
	util.click(1687,1051)
	mSleep(500)
	if public.closeBanAlertIfNecessary() == 1 then--检测到禁止闯关弹窗
		STEP_coin = util.ERROR_CODE--重新尝试
	else--无弹窗
		STEP_coin = 5
	end
	
end

--5 检测游戏中
function func_playingGame()
	util.hudToast("自动游戏中...")
	mSleep(1500)
	if public.playing_game() == 0 then
		util.hudToast("自动游戏结束:再次闯关")
		STEP_coin = 6 --再次
	elseif public.playing_game() == 1 then
		util.hudToast("自动游戏结束:重新开始")
		STEP_coin = util.ERROR_CODE--位置错误
	end
end

--6 再次闯关
function func_playAgain()
	
	--保护:检测是否出现了再次闯关按钮
	x , y = util.findColor(0xe6a127, 90, 1722, 1088, 1952, 1166)--再次闯关背景:蓝色
	x1 , y1 = util.findColor(0xffffff, 90, 1722, 1088, 1952, 1166)--再次闯关文案:白色
	x3 , y3 = util.findColor(0x34a0d5, 90, 1393, 1100, 1550, 1170)--返回背景:蓝色
	x4 , y4 = util.findColor(0xffffff, 90, 1393, 1100, 1550, 1170)--返回文案:白色
	if x > -1 and x1 > -1 and x3 > -1 and x4 > -1  then
		util.hudToast("点击再次闯关")
		util.click(1825,1130)
		mSleep(500)
		func_playAgain()--有再次闯关按钮，就一直点 ， 直到页面跳转为止
	else
		STEP_coin = 4
	end
	
	
end
--main
function coin.coinMain()
	mSleep(500)
	public.colseAllAlertIfNecessary()--检测组队弹窗和防沉迷弹窗
	if public.detectXiaXianTanChuang() == 1 then
		_G["coinFinished"] = true
		STEP_coin = util.ERROR_CODE
	end
	if STEP_coin == 0 then
		func_clickDuiZhan()
		coin.coinMain()
	elseif STEP_coin == 1 then
		public.waitUntilViewDidAppear()
		func_clickMaoXian()
		coin.coinMain()
	elseif STEP_coin == 2 then
		func_clickTiaoZhan()
		coin.coinMain()
	elseif STEP_coin == 3 then
		func_chooseMission()
		coin.coinMain()
	elseif STEP_coin == 4 then
		public.waitUntilViewDidAppear()
		func_clickChuangGuan()
		coin.coinMain()
	elseif STEP_coin == 5 then
		func_playingGame()
		coin.coinMain()
	elseif STEP_coin == 6 then
		func_playAgain()
		coin.coinMain()
	elseif STEP_coin == util.ERROR_CODE then
		STEP_coin = 0
	end
end

--private function
function moveDownTimes(times)
	util.hudToast("翻页中...")
	for i = 1 , times , 1 do
		util.move(560,400,560,800)
		mSleep(250)
	end
end

return coin