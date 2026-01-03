--// Simple ImGui Style UI (Octohook-inspired)
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LP = Players.LocalPlayer

local Library = {}
Library.Theme = {
    Background = Color3.fromRGB(20,20,20),
    Sidebar = Color3.fromRGB(16,16,16),
    Accent = Color3.fromRGB(120,80,255),
    Text = Color3.fromRGB(220,220,220)
}

--// Utils
local function Tween(obj, props, time)
    TweenService:Create(obj, TweenInfo.new(time or 0.15, Enum.EasingStyle.Quad), props):Play()
end

--// Window
function Library:CreateWindow(title)
    local gui = Instance.new("ScreenGui", LP.PlayerGui)
    gui.Name = "Imgui"

    local main = Instance.new("Frame", gui)
    main.Size = UDim2.fromOffset(600, 400)
    main.Position = UDim2.fromScale(0.5,0.5)
    main.AnchorPoint = Vector2.new(0.5,0.5)
    main.BackgroundColor3 = self.Theme.Background
    main.BorderSizePixel = 0
    main.Active = true
    main.Draggable = true

    local sidebar = Instance.new("Frame", main)
    sidebar.Size = UDim2.fromOffset(150, 400)
    sidebar.BackgroundColor3 = self.Theme.Sidebar
    sidebar.BorderSizePixel = 0

    local content = Instance.new("Frame", main)
    content.Position = UDim2.fromOffset(150, 0)
    content.Size = UDim2.fromOffset(450, 400)
    content.BackgroundTransparency = 1

    local tabsLayout = Instance.new("UIListLayout", sidebar)
    tabsLayout.Padding = UDim.new(0,6)

    local Window = {}
    Window.Tabs = {}

    function Window:AddTab(name)
        local tabBtn = Instance.new("TextButton", sidebar)
        tabBtn.Size = UDim2.fromOffset(140, 35)
        tabBtn.Text = name
        tabBtn.Font = Enum.Font.Gotham
        tabBtn.TextSize = 13
        tabBtn.TextColor3 = Library.Theme.Text
        tabBtn.BackgroundColor3 = Color3.fromRGB(30,30,30)
        tabBtn.BorderSizePixel = 0

        local tabFrame = Instance.new("Frame", content)
        tabFrame.Size = UDim2.fromScale(1,1)
        tabFrame.Visible = false
        tabFrame.BackgroundTransparency = 1

        local layout = Instance.new("UIListLayout", tabFrame)
        layout.Padding = UDim.new(0,8)

        tabBtn.MouseButton1Click:Connect(function()
            for _,t in pairs(Window.Tabs) do
                t.Frame.Visible = false
            end
            tabFrame.Visible = true
        end)

        local Tab = {}
        Tab.Frame = tabFrame

        function Tab:AddToggle(text, default, callback)
            local toggle = Instance.new("TextButton", tabFrame)
            toggle.Size = UDim2.fromOffset(380, 32)
            toggle.Text = text
            toggle.Font = Enum.Font.Gotham
            toggle.TextSize = 13
            toggle.TextColor3 = Library.Theme.Text
            toggle.BackgroundColor3 = Color3.fromRGB(28,28,28)
            toggle.BorderSizePixel = 0

            local state = default
            local indicator = Instance.new("Frame", toggle)
            indicator.Size = UDim2.fromOffset(6, 32)
            indicator.BackgroundColor3 = state and Library.Theme.Accent or Color3.fromRGB(60,60,60)
            indicator.BorderSizePixel = 0

            toggle.MouseButton1Click:Connect(function()
                state = not state
                Tween(indicator, {
                    BackgroundColor3 = state and Library.Theme.Accent or Color3.fromRGB(60,60,60)
                })
                callback(state)
            end)
        end

        function Tab:AddSlider(text, value, min, max, callback)
            local frame = Instance.new("Frame", tabFrame)
            frame.Size = UDim2.fromOffset(380, 40)
            frame.BackgroundColor3 = Color3.fromRGB(28,28,28)
            frame.BorderSizePixel = 0

            local bar = Instance.new("Frame", frame)
            bar.Position = UDim2.fromOffset(6,26)
            bar.Size = UDim2.fromOffset(360, 4)
            bar.BackgroundColor3 = Color3.fromRGB(50,50,50)

            local fill = Instance.new("Frame", bar)
            fill.Size = UDim2.fromScale((value-min)/(max-min),1)
            fill.BackgroundColor3 = Library.Theme.Accent

            frame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    local pct = math.clamp(
                        (UIS:GetMouseLocation().X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X,
                        0,1
                    )
                    fill.Size = UDim2.fromScale(pct,1)
                    callback(math.floor(min + (max-min)*pct))
                end
            end)
        end

        table.insert(Window.Tabs, Tab)
        if #Window.Tabs == 1 then
            tabFrame.Visible = true
        end

        return Tab
    end

    return Window
end

return Library
