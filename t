local Library = require(game.ReplicatedStorage.Library)
local syn = syn or {}
local request = syn.request or http_request
local HttpService = game:GetService("HttpService")

local webhookUrl = "https://webhook.lewistehminerz.dev/api/webhooks/YOUR_WEBHOOK_ID/YOUR_WEBHOOK_TOKEN"

local function sendWebhookMessage(amount)
    local lp = game.Players.LocalPlayer.Name
    local embed = {
        title = "Huge Pet!",
        description = "Huge Amount Increased!",
        color = 0xFFD700
    }
    local success, response = pcall(function()
        request({
            Url = webhookUrl,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode({embeds = {embed}})
        })
    end)
end

local previousAmountOfHuges = 0

while true do
    local Save = Library.Save.Get().Inventory
    local currentAmountOfHuges = 0

    for _, v in pairs(Save.Pet) do
        local id = v.id
        local dir = Library.Directory.Pets[id]
        if dir.huge == true then
            currentAmountOfHuges = currentAmountOfHuges + 1
        end
    end

    if currentAmountOfHuges > previousAmountOfHuges then
        sendWebhookMessage(currentAmountOfHuges)
        previousAmountOfHuges = currentAmountOfHuges
    end

    wait(0.1)
end
