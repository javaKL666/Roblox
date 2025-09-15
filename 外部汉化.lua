--Kenny泛滥外部汉化脚本我的哔站UID:1531514159（删了这个死妈死爹死全家）
local Translations = {
   ["Toggle"] = "打开/隐藏",
    ["Lock"] = "锁定",
    ["Unlock"] = "解锁",
    ["Addons"] = "附加插件",
    ["Config"] = "配置",
    ["Player"] = "玩家",
    ["Main"] = "英文汉化",
    ["Floor"] = "英文汉化",
    ["Visuals"] = "英文汉化",
    ["Exploits"] = "英文汉化",
    ["Miscellaneous"] = "杂项",
    ["Notifying / ESP"] = "通知/实体ESP",
    ["Reach"] = "提升",
    ["Door Reach"] = "门范围提升",
    ["Prompt Reach"] = "显示门范围",
    ["Instant Interacts"] = "临时互动",
    ["Prompt Clip"] = "提示穿透",
    ["Disable AFK"] = "防挂机",
    ["Anti Lag"] = "防延迟",
    ["No Cutscenes"] = "去除无过场动画",
    ["Reset"] = "死亡",
    ["Play Again"] = "重新开始",
    ["Lobby"] = "返回大厅",
    ["Revive"] = "复活 (不免费)",
    ["Entities"] = "列表",
    ["Entity Notifys"] = "通知实体",
    ["Entities ESP"] = "实体ESP",
    ["Notify Library Code"] = "通知图书馆密码",
    ["Movement"] = "移动",
    ["Camera"] = "相机",
    ["Speed Boost Slider"] = "速度调节",
    ["Speed Boost"] = "启用速度",
    ["Noclip"] = "穿墙",
    ["Enable Jump"] = "启用跳跃",
    ["Infinite Jump"] = "启用无限跳",
    ["No Acceleration"] = "无滑动",
    ["No Closet Exit Delay"] = "快速出柜",
    ["Fly Speed"] = "飞行速度",
    ["Fly"] = "启用飞行",
    ["Infinite Items"] = "无限物品",
    ["Infinite Shears"] = "无限剪刀",
    ["Infinite LockPicks"] = "无限棍锁器",
    ["Fullbright"] = "全亮",
    ["No Camera Shake"] = "无相机抖动",
    ["Third Person"] = "第三人称相机",
    ["Spectate Entity"] = "观察实体",
    ["FOV Slider"] = "视野调节",
    ["FOV"] = "启用视野",
    ["Entitys"] = "实体",
    ["Bypass"] = "绕过",
    ["Speed Bypass"] = "速度绕过",
    ["God Mode"] = "上帝模式",
    ["Anti Cheat Manipulation"] = "无拉回穿墙",
    ["Anti-Dread"] = "防-Dread",
    ["Anti-Screech"] = "防-Screech",
    ["Anti-A90"] = "防-A90",
    ["Anti-Eyes"] = "防-眼睛",
    ["Anti-Snare"] = "防-Snare",
    ["Anti-Dupe"] = "防-Dupe",
    ["Anti-Figure-Hearing"] = "防-飞哥-听觉",
    ["Anti-Halt"] = "防-Halt",
    ["Automation"] = "自动",
    ["Auto Interact"] = "自动互动",
    ["Ignore List"] = "忽略列表",
    ["Gold"] = "金币",
    ["drops"] = "物品",
    ["Jeff Items"] = "英文汉化",
    ["Auto Heartbeat Minigame"] = "自动心跳小游戏",
    ["UoLock Padlock Distance"] = "解锁图书馆密码距离",
    ["Automation Library Code"] = "自动解锁图书馆密码"
    ["Auto Breaker Box"] = "自动断电器",
    ["Auto Closet"] = "自动躲柜子",
}

local function translateText(text)
    if not text or type(text) ~= "string" then return text end
    
    if Translations[text] then
        return Translations[text]
    end
    
    for en, cn in pairs(Translations) do
        if text:find(en) then
            return text:gsub(en, cn)
        end
    end
    
    return text
end

local function setupTranslationEngine()
    local success, err = pcall(function()
        local oldIndex = getrawmetatable(game).__newindex
        setreadonly(getrawmetatable(game), false)
        
        getrawmetatable(game).__newindex = newcclosure(function(t, k, v)
            if (t:IsA("TextLabel") or t:IsA("TextButton") or t:IsA("TextBox")) and k == "Text" then
                v = translateText(tostring(v))
            end
            return oldIndex(t, k, v)
        end)
        
        setreadonly(getrawmetatable(game), true)
    end)
    
    if not success then
        warn("元表劫持失败:", err)
       
        local translated = {}
        local function scanAndTranslate()
            for _, gui in ipairs(game:GetService("CoreGui"):GetDescendants()) do
                if (gui:IsA("TextLabel") or gui:IsA("TextButton") or gui:IsA("TextBox")) and not translated[gui] then
                    pcall(function()
                        local text = gui.Text
                        if text and text ~= "" then
                            local translatedText = translateText(text)
                            if translatedText ~= text then
                                gui.Text = translatedText
                                translated[gui] = true
                            end
                        end
                    end)
                end
            end
            
            local player = game:GetService("Players").LocalPlayer
            if player and player:FindFirstChild("PlayerGui") then
                for _, gui in ipairs(player.PlayerGui:GetDescendants()) do
                    if (gui:IsA("TextLabel") or gui:IsA("TextButton") or gui:IsA("TextBox")) and not translated[gui] then
                        pcall(function()
                            local text = gui.Text
                            if text and text ~= "" then
                                local translatedText = translateText(text)
                                if translatedText ~= text then
                                    gui.Text = translatedText
                                    translated[gui] = true
                                end
                            end
                        end)
                    end
                end
            end
        end
        
        local function setupDescendantListener(parent)
            parent.DescendantAdded:Connect(function(descendant)
                if descendant:IsA("TextLabel") or descendant:IsA("TextButton") or descendant:IsA("TextBox") then
                    task.wait(0.1)
                    pcall(function()
                        local text = descendant.Text
                        if text and text ~= "" then
                            local translatedText = translateText(text)
                            if translatedText ~= text then
                                descendant.Text = translatedText
                            end
                        end
                    end)
                end
            end)
        end
        
        pcall(setupDescendantListener, game:GetService("CoreGui"))
        local player = game:GetService("Players").LocalPlayer
        if player and player:FindFirstChild("PlayerGui") then
            pcall(setupDescendantListener, player.PlayerGui)
        end
        
        while true do
            scanAndTranslate()
            task.wait(3)
        end
    end
end

task.wait(2)

setupTranslationEngine()

local success, err = pcall(function()
--这下面填加载外部脚本
loadstring(game:HttpGet("https://rawscripts.net/raw/DOORS-Prohax-v3-47773"))()


end)

if not success then
    warn("加载失败:", err)
end