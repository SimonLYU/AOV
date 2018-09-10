util = {}
util.ERROR_CODE = 108

my_hud_id = 0--全局保存自定义hud id
second_hud_id = 0--全局保存自定义hud2 id
third_hud_id = 0--全局保存自定义hud3 id
luo_han_toast_times = 0--叠罗汉hud出现次数
hud_text_color = "0xff81afdc"--自定义hud文案颜色
hud_background_color = "0xc8030303"--自定义hud背景颜色
third_hud_text_color = "0xfffaa000"--自定义hud3内容发生变后的文案颜色
luo_han_hud_text_color = "0xff94b64d"--叠罗汉文案颜色
hud_text_font_size = 35--自定义hud文字尺寸

-- 点击手势
function util.click(x,y)
	touchDown(1, x, y);
	mSleep(150);
	touchUp(1, x, y);
end

-- 移动手势
function util.move(fromX,fromY,toX,toY)
	touchDown(1, fromX, fromY);
	mSleep(50)
	moveFromTo(fromX,fromY,toX,toY)
	mSleep(500)--防止惯性
	touchUp(1, toX, toY);
end

--私有方法
function moveFromTo(fromX,fromY,toX,toY)
	mSleep(3)
	--x
	if fromX ~= toX then
		if fromX > toX then
			fromX = fromX - 1
		else
			fromX = fromX + 1
		end
	end
	
	--y
	if fromY ~= toY then
		if fromY > toY then
			fromY = fromY - 1
		else
			fromY = fromY + 1
		end
	end
	
	touchMove(1, fromX, fromY)

	if fromX ~= toX or fromY ~= toY then
		moveFromTo(fromX , fromY , toX , toY)
	end
end
-- 快速移动手势
function util.smove(fromX,fromY,toX,toY)
	touchDown(1, fromX, fromY);
	mSleep(50)
	touchMove(1, toX, toY)
	mSleep(50)
	touchUp(1, toX, toY);
end

-- 找色
function util.findColor(color,degree,x1,y1,x2,y2)
	keepScreen(true)
--	resultX , resultY = findColorInRegionFuzzy(color,degree,x1,y1,x2,y2,0,0)--低效
	resultX , resultY = findColor({x1,y1,x2,y2},color,degree,0,0,0)	
	keepScreen(false)
	return resultX,resultY;
end

-- 找点弹窗(测试用)
function util.xylog(x,y)
	dialog("["..x..","..y.."]")
end

--初始化自定义hud
function util.initMyHud()
	screen_width,screen_height = getScreenSize()
	my_hud_id = createHUD()
	showHUD(my_hud_id,"听后主人差遣~",hud_text_font_size,hud_text_color,hud_background_color,3,0,screen_width  * (1 - 0.195),screen_width * 0.7,screen_height  * 0.055)
end
----初始化自定义hud2
--function util.initSecondHud()
--	screen_width,screen_height = getScreenSize()
--	second_hud_id = createHUD()
--	showHUD(second_hud_id,"暂时无敌军偷袭主人资源哦~",hud_text_font_size,hud_text_color,hud_background_color,0,0,screen_height  * (1 - 0.195) - screen_height  * 0.06 * 1,screen_width * 0.4,screen_height  * 0.055)
--end
----初始化自定义hud3
--function util.initThirdHud()
--	screen_width,screen_height = getScreenSize()
--	third_hud_id = createHUD()
--	showHUD(third_hud_id,"暂时无敌军攻打主人城堡哦~",hud_text_font_size,hud_text_color,hud_background_color,0,0,screen_height  * (1 - 0.195) - screen_height  * 0.06 * 2,screen_width * 0.4,screen_height  * 0.055)
--end
--自定义hud展示内容
function util.hudToast(toastInfo)
	screen_width,screen_height = getScreenSize()
	showHUD(my_hud_id,toastInfo,hud_text_font_size,hud_text_color,hud_background_color,3,0,screen_width  * (1 - 0.195),screen_width * 0.7,screen_height  * 0.055)
end

----自定义hud2展示内容
--function util.secondHudToast(toastInfo)
--	screen_width,screen_height = getScreenSize()
--	showHUD(second_hud_id,toastInfo,hud_text_font_size,third_hud_text_color,hud_background_color,0,0,screen_height  * (1 - 0.195) - screen_height  * 0.06 * 1,screen_width * 0.4,screen_height  * 0.055)
--end

----自定义hud3展示内容
--function util.thirdHudToast(toastInfo)
--	screen_width,screen_height = getScreenSize()
--	showHUD(third_hud_id,toastInfo,hud_text_font_size,third_hud_text_color,hud_background_color,0,0,screen_height  * (1 - 0.195) - screen_height  * 0.06 * 2,screen_width * 0.4,screen_height  * 0.055)
--end

--叠罗汉hud
function util.luohanHud(toastInfo)
	luo_han_toast_times = luo_han_toast_times + 1
	yPos = screen_height  * (1 - 0.195 -  0.06 * luo_han_toast_times)
	if yPos < 0 then
		return
	end
	current_time = os.date("%m-%d %H:%M:%S", os.time())
	screen_width,screen_height = getScreenSize()
	local luohanHudId = createHUD()
	showHUD(luohanHudId,current_time.." 有敌人攻打主人的"..toastInfo,hud_text_font_size,luo_han_hud_text_color,hud_background_color,0,screen_width * (1 - 0.4),yPos,screen_width * 0.4,screen_height  * 0.055)
end

return util