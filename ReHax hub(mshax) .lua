local Translations = {
    ["LocalPlayer"] = "玩家",
    ["Exploits"] = "漏洞与绕过",
    ["Visuals"] = "视觉"
    ["Floor"] = "地板",
    ["Configuratiin"] = "配置与调节",
    ["Addons"] = "附加插件",
    ["Toggle"] = "菜单",
    ["Loock"] = "锁定",
    ["Unlock"] = "解锁",
    ["Movement"] = "移动",
    ["Camera"] = "相机",
    ["Speed Boost Slider"] = "速度 值",
    ["Speed Boost"] = "速度",
    ["Noclip"] = "穿墙",
    ["Enable Jump"] = "启用跳跃",
    ["Infinite Jump"] = "无限跳",
    ["Loading mshax for DOORS"] = "正在启用 Rehax hub DOORS",
    ["isnetworkowner not supported somefeatures would be disabled"] = "瞅啥呢 伙计",
    ["Failea to load autoload confog: invalidfile"] = "未发现设为加载的配置",
    ["No Acceleration"] = "无滑动",
    ["Auto Breaker Box"] = "自动 断路器箱",
    ["Auto Closet"] = "自动 Closet",
    ["No Camera Shake"] = "无相机抖动",
    ["Third Person"] = "背视角",
    ["FOV Slider"] = "视野值",
    ["FOV"] = "视野",
    ["Infinite Item"] = "无限 物品",
    ["Infinite Cruifixs"] = "无限 十字架",
    ["lnfinite LockPicks"] = "无限 棍锁器",
    ["Infinite Shears"] = "无限 剪刀",
    ["Search"] = "搜索",
    ["No Closet Exit Delay"] = "无衣柜出去延迟",
    ["Fly"] = "飞",
    ["Fly Speed"] = "飞 速度",
    ["Auto Interact"] = "自动 互动",
    ["Entity Notifys"] = "实体通知",
    ["Entities"] = "实体",
    ["Notify Library Code"] = "通知图书馆密码",
    ["Anti Lag"] = "低画质",
    ["Prompt Reach"] = "提示剪辑",
    ["Instant Interacts"] = "临时互动",
    ["No Cutscenes"] = "无过场动画",
    ["Door Reach Range"] = "门接触范围",
    ["Disable AFK"] = "禁用挂机",
    ["Door Reach"] = "门范围",
    ["Lobby"] = "大厅",
    ["Reset"] = "重置",
    ["Play Again"] = "重新开始",
    ["Revive"] = "复活",
    ["Gold"] = "金币",
    ["Drops"] = "掉落物",
    ["Anti-Halt"] = "防-停滞",
    ["Anti-Figure-Hearing"] = "防-听觉",
    ["Anti-Dupe"] = "防-复制",
    ["Anti-A90"] = "防-A90",
    ["Anti-Screech"] = "防-尖叫",
    ["Anti-Dread"] = "防-噬梦者",
    ["Anti-Eyes"] = "防-眼睛",
    ["Anti-Snare"] = "防-地刺",
    
   
    
    
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
loadstring(game:HttpGet('https://raw.githubusercontent.com/TheHunterSolo1/Scripts/main/Script'))()



end)

if not success then
    warn("加载失败:", err)
end
