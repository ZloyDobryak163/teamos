local component = require("component")
local term = require("term")
local event = require("event")
local fs = require("filesystem")

local gpu = component.gpu

local LOG_PATH = "chat_log.txt"

-- Конвертирует строку в массив
function stringToArray(text)
t = {}
text:gsub(".",function© table.insert(t,c) end)
return t
end

--Получить текущее реальное время компьютера, хостящего сервер майна
function getHostTime(timezone)
    timezone = timezone or 2
local file = io.open("/HostTime.tmp", "w")
file:write("")
file:close()
local timeCorrection = timezone * 3600
local lastModified = tonumber(string.sub(fs.lastModified("/HostTime.tmp"), 1, -4)) + timeCorrection
fs.remove("/HostTime.tmp")
local year, month, day, hour, minute, second = os.date("%Y", lastModified), os.date("%m", lastModified), os.date("%d", lastModified), os.date("%H", lastModified), os.date("%M", lastModified), os.date("%S", lastModified)
return tonumber(day), tonumber(month), tonumber(year), tonumber(hour), tonumber(minute), tonumber(second)
end

-- Получет настоящее время, стоящее на Хост-машине
function real_time()
local time = {getHostTime(3)}
local text = string.format("%02d:%02d:%02d", time[4], time[5], time[6])
return text
end

-- Проверяет является ли текст окрашенным
function isColored(text)
for pos, i in pairs(stringToArray(text)) do
if (i ~= "&") then
if (i ~= " ") then
return false
end
else
return true
end
end

return true
end

-- Проверяет в глобальном ли чате написано сообщение
function isGlobal(text)
for pos, i in pairs(stringToArray(text)) do
if (i ~= "!") then
if (i ~= " ") then
return false
end
else
return true, pos
end
end
return false
end

-- Делит строку на части
function split(str, pat)
local t = {}
local fpat = "(.-)" .. pat
local last_end = 1
local s, e, cap = str:find(fpat, 1)
while s do
if s ~= 1 or cap ~= "" then
table.insert(t,cap)
end
last_end = e+1
s, e, cap = str:find(fpat, last_end)
end
if last_end cap = str:sub(last_end)
table.insert(t, cap)
end
return t
end

-- Устанавливает цвет шрифта в зависимости от патерна
function setColor(num)
if (num == "0") then
gpu.setForeground(0x333333)
end

if (num == "1") then
gpu.setForeground(0x000099)
end

if (num == "2") then
gpu.setForeground(0x006600)
end

if (num == "3") then
gpu.setForeground(0x006666)
end

if (num == "4") then
gpu.setForeground(0x660000)
end

if (num == "5") then
gpu.setForeground(0x660066)
end

if (num == "6") then
gpu.setForeground(0xFF8000)
end

if (num == "7") then
gpu.setForeground(0xA0A0A0)
end

if (num == "8") then
gpu.setForeground(0x404040)
end

if (num == "9") then
gpu.setForeground(0x3399FF)
end

if (num == "a") then
gpu.setForeground(0x99FF33)
end

if (num == "b") then
gpu.setForeground(0x00FFFF)
end

if (num == "c") then
gpu.setForeground(0xFF3333)
end

if (num == "d") then
gpu.setForeground(0xFF00FF)
end

if (num == "e") then
gpu.setForeground(0xFFFF00)
end

if (num == "f") then
gpu.setForeground(0xFFFFFF)
end
end

-- Выводит сообщение
function writeMessage(text)
local t = split(text, "&")
for pos, i in pairs(t) do
if (pos == 1 and not isColored(text)) then
io.write(i)
else
setColor(string.sub(i, 1, 1))
io.write(string.sub(i, 2))
end
end
end

-- Выводит остальную часть сообщения
function message(nick, msg, isGlobal, pos)
local type = ""
if (isGlobal) then msg = string.sub(msg, pos + 1) type = "G" else type = "L" end

local file = fs.open(LOG_PATH, "a")
file:write("[" .. real_time() .. "] [" .. type .. "] " .. nick .. ": " .. msg .. "\n")
file:close()

gpu.setForeground(0x00FFFF)
io.write("[" .. real_time() .. "] ")
gpu.setForeground(0xFFFFFF)
if (type == "G") then
gpu.setForeground(0xFF9933)
else
gpu.setForeground(0xFFFFFF)
end
io.write("[" .. type .. "] ")
gpu.setForeground(0x00FF00)
io.write(nick)
gpu.setForeground(0xFFFFFF)
io.write(": ")
writeMessage(msg, l)
io.write("\n")
end

print("Инициализация...")
os.sleep(1)
print("Ожидание первого сообщения...")

local _, add, nick, msg = event.pull("chat_message")
term.clear()
local type, pos = isGlobal(msg)
message(nick, msg, type, pos)


while true do

local _, add, nick, msg = event.pull("chat_message")
local type, pos = isGlobal(msg)
message(nick, msg, type, pos)

end
