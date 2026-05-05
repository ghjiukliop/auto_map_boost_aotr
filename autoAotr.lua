-- phan 3 - Chạy khi không ở trong 2 Place ID đặc biệt
if p ~= 13379208636 and p ~= 14916516914 then
    local VIM = game:GetService("VirtualInputManager")
    local pGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    
    -- Tăng độ lệch lên 65 (hoặc 70) nếu 58 vẫn bị lệch lên trên
    local Y_OFFSET = 65 

    local function isVisible(obj)
        local current = obj
        while current and current:IsA("GuiObject") do
            if not current.Visible then return false end
            current = current.Parent
        end
        local sg = obj:FindFirstAncestorOfClass("ScreenGui")
        return sg and sg.Enabled
    end

    local function checkBoostExpired()
        local success, content = pcall(function() return readfile("boost_timer.txt") end)
        if success and content then
            local endTime = tonumber(content)
            return endTime and os.time() >= endTime
        end
        return false 
    end

    task.spawn(function()
        -- Giai đoạn 1: Đợi hết Boost
        while not checkBoostExpired() do 
            task.wait(1) 
        end

        -- Giai đoạn 2: Quét và click nút Leave_2 mỗi giây
        while true do
            local success, btn = pcall(function()
                return pGui.Interface.Rewards.Main.Info.Main.Buttons.Leave_2
            end)

            if success and btn and isVisible(btn) then
                local pos = btn.AbsolutePosition
                local size = btn.AbsoluteSize
                
                -- Tính tọa độ tâm nút và cộng thêm độ lệch để dời điểm click xuống dưới[cite: 1]
                local clickX = pos.X + (size.X / 2)
                local clickY = pos.Y + (size.Y / 2) + Y_OFFSET

                VIM:SendMouseButtonEvent(clickX, clickY, 0, true, game, 0)
                task.wait(0.05)
                VIM:SendMouseButtonEvent(clickX, clickY, 0, false, game, 0)
                
                print("Clicked Leave_2 at Y: " .. clickY)
                break 
            end
            task.wait(1) 
        end
    end)
end
