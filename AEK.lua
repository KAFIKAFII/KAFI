redis = require('redis') 
URL = require('socket.url') 
HTTPS = require ("ssl.https") 
https = require ("ssl.https") 
http  = require ("socket.http") 
serpent = require("serpent") 
json = dofile('./JSON.lua') 
JSON = dofile('./dkjson.lua') 
lgi = require('lgi') 
notify = lgi.require('Notify') 
utf8 = require ('lua-utf8') 
notify.init ("Telegram updates") 
DevAek = redis.connect('127.0.0.1', 6379) 
User = io.popen("whoami"):read('*a'):gsub('[\n\r]+', '')
ServerAEK = io.popen("echo $SSH_CLIENT | awk '{ print $1}'"):read('*a') 
Ip = io.popen("dig +short myip.opendns.com @resolver1.opendns.com"):read('*a'):gsub('[\n\r]+', '')
Name = io.popen("uname -a | awk '{ name = $2 } END { print name }'"):read('*a'):gsub('[\n\r]+', '')
Port = io.popen("echo ${SSH_CLIENT} | awk '{ port = $3 } END { print port }'"):read('*a'):gsub('[\n\r]+', '')
UpTime = io.popen([[uptime | awk -F'( |,|:)+' '{if ($7=="min") m=$6; else {if ($7~/^day/) {d=$6;h=$8;m=$9} else {h=$6;m=$7}}} {print d+0,"days,",h+0,"hours,",m+0,"minutes"}']]):read('*a'):gsub('[\n\r]+', '')

local AutoSet = function() 
if not DevAek:get(ServerAEK.."IdAEK") then 
io.write('\27[1;35m\nالان ارسل ايدي المطور الاساسي ↫ ⤈\n\27[0;33;49m') 
local DevId = io.read():gsub(' ','') 
if tostring(DevId):match('%d+') then 
io.write('\27[1;36mتم حفظ ايدي المطور الاساسي\n27[0;39;49m') 
DevAek:set(ServerAEK.."IdAEK",DevId) 
else 
print('\27[1;31m━───━ ✫ ━───━\nلم يتم حفظ ايدي المطور الاساسي ارسله مره اخرى\n━───━ ✫ ━───━') 
end 
os.execute('lua AEK.lua') 
end 
if not DevAek:get(ServerAEK.."TokenAEK") then 
io.write('\27[1;35m\nالان قم بارسال توكن البوت ↫ ⤈\n\27[0;33;49m') 
local TokenBot = io.read() 
if TokenBot ~= '' then 
local url , res = https.request('https://api.telegram.org/bot'..TokenBot..'/getMe') 
if res ~= 200 then 
print('\27[1;31m━───━ ✫ ━───━\nالتوكن غير صحيح تاكد منه ثم ارسله\n━───━ ✫ ━───━') 
else 
io.write('\27[1;36mتم حفظ توكن البوت بنجاح\n27[0;39;49m') 
DevAek:set(ServerAEK.."TokenAEK",TokenBot) 
end  
else 
print('\27[1;31m━───━ ✫ ━───━\nلم يتم حفظ توكن البوت ارسله مره اخرى\n━───━ ✫ ━───━') 
end  
os.execute('lua AEK.lua') 
end
local Create = function(data, file, uglify)  
file = io.open(file, "w+")   
local serialized   
if not uglify then  
serialized = serpent.block(data, {comment = false, name = "Config"})  
else  
serialized = serpent.dump(data)  
end    
file:write(serialized)
file:close()  
end
local CreateConfigAuto = function()
Config = {
DevId = DevAek:get(ServerAEK.."IdAEK"),
TokenBot = DevAek:get(ServerAEK.."TokenAEK"),
AEK = DevAek:get(ServerAEK.."TokenAEK"):match("(%d+)"),
SudoIds = {DevAek:get(ServerAEK.."IdAEK")},
}
Create(Config, "./config.lua")
file = io.open("AEK.sh", "w")  
file:write([[
#!/usr/bin/env bash
cd $HOME/AEK
token="]]..DevAek:get(ServerAEK.."TokenAEK")..[["
while(true) do
rm -fr ../.telegram-cli
if [ ! -f ./tg ]; then
echo "━───━ ✫ ━───━ ✫ ━───━ ✫ ━───━ ✫ ━───━ ✫ ━───━"
echo "~ The tg File Was Not Found In The Bot Files"
echo "━───━ ✫ ━───━ ✫ ━───━ ✫ ━───━ ✫ ━───━ ✫ ━───━"
exit 1
fi
if [ ! $token ]; then
echo "━───━ ✫ ━───━ ✫ ━───━ ✫ ━───━ ✫ ━───━ ✫ ━───━"
echo "~ The Token Was Not Found In The config.lua File"
echo "━───━ ✫ ━───━ ✫ ━───━ ✫ ━───━ ✫ ━───━ ✫ ━───━"
exit 1
fi
./tg -s ./AEK.lua -p PROFILE --bot=$token
done
]])  
file:close()  
file = io.open("Run", "w")  
file:write([[
#!/usr/bin/env bash
cd $HOME/AEK
while(true) do
rm -fr ../.telegram-cli
screen -S AEK -X kill
screen -S AEK ./AEK.sh
done
]]) 
file:close() 
io.popen("mkdir Files")
os.execute('chmod +x Run;./Run')
end 
CreateConfigAuto()
end
local Load_AEK = function() 
local f = io.open("./config.lua", "r") 
if not f then 
AutoSet() 
else 
f:close() 
DevAek:del(ServerAEK.."IdAEK");DevAek:del(ServerAEK.."TokenAEK")
end 
local config = loadfile("./config.lua")() 
return config 
end  
Load_AEK() 
print("\27[36m"..[[                                           
---------------------------------------------
┏━━━━┓┏┓━━━━━━━━━━┏┓━━━━━━━━━━━━━━━━━━━━┏┓━━━━━━━━━━━━━━
┃┏┓┏┓┃┃┃━━━━━━━━━━┃┃━━━━━━━━━━━━━━━━━━━┏┛┗┓━━━━━━━━━━━━━
┗┛┃┃┗┛┃┗━┓┏━━┓━━━━┃┃━┏┓┏━━┓┏━┓━┏━━┓━━━━┗┓┏┛┏━━┓┏━━┓━┏┓┏┓
━━┃┃━━┃┏┓┃┃┏┓┃━━━━┃┃━┣┫┃┏┓┃┃┏┓┓┃━━┫━━━━━┃┃━┃┏┓┃┗━┓┃━┃┗┛┃
━┏┛┗┓━┃┃┃┃┃┃━┫━━━━┃┗┓┃┃┃┗┛┃┃┃┃┃┣━━┃━━━━━┃┗┓┃┃━┫┃┗┛┗┓┃┃┃┃
━┗━━┛━┗┛┗┛┗━━┛━━━━┗━┛┗┛┗━━┛┗┛┗┛┗━━┛━━━━━┗━┛┗━━┛┗━━━┛┗┻┻┛
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
|-------------------------------------------|
|This Source Was Developed By (IBOIBO) @IBOIBO100.|
|  This Is The Source Channel @HH_418 .   |
|               - AEK -                 |
---------------------------------------------
]]..'\27[m'.."\n\27[35mServer Information ↬ ⤈ \n━───━ ✫ ━───━ ✫ ━───━ ✫ ━───━\27[m\n\27[36m~ \27[mUser \27[36m: \27[10;32m"..User.."\27[m\n\27[36m~ \27[mIp \27[36m: \27[10;32m"..Ip.."\27[m\n\27[36m~ \27[mName \27[36m: \27[10;32m"..Name.."\27[m\n\27[36m~ \27[mPort \27[36m: \27[10;32m"..Port.."\27[m\n\27[36m~ \27[mUpTime \27[36m: \27[10;32m"..UpTime.."\27[m\n\27[35m━───━ ✫ ━───━ ✫ ━───━ ✫ ━───━\27[m")
Config = dofile("./config.lua")
DevId = Config.DevId
SudoIds = {Config.SudoIds,1333034749}
AEK = Config.AEK
TokenBot = Config.TokenBot
NameBot = (DevAek:get(AEK..'Aek:NameBot') or 'ايبو')

FilesPrint = "\27[35m".."\nAll Source Files Started ↬ ⤈ \n━───━ ✫ ━───━ ✫ ━───━ ✫ ━───━\n"..'\27[m'
FilesNumber = 0
for v in io.popen('ls Files'):lines() do
if v:match(".lua$") then
FilesNumber = FilesNumber + 1
FilesPrint = FilesPrint.."\27[39m"..FilesNumber.."\27[36m".."~ : \27[10;32m"..v.."\27[m \n"
end
end
FilesPrint = FilesPrint.."\27[35m".."━───━ ✫ ━───━ ✫ ━───━ ✫ ━───━\n".."\27[m"
if FilesNumber ~= 0 then
print(FilesPrint)
end

--     Start Functions    --
function vardump(value)
print(serpent.block(value, {comment=false}))
end

function dl_cb(arg, data)
end

----------  Sudo  ----------
function Sudo(msg) 
local var = false 
for k,v in pairs(SudoIds) do 
if msg.sender_user_id_ == v then 
var = true 
end end 
if msg.sender_user_id_ == tonumber(DevId) then 
var = true 
end 
return var 
end
function SudoId(user_id) 
local var = false 
for k,v in pairs(SudoIds) do 
if user_id == v then 
var = true 
end end 
if user_id == tonumber(DevId) then 
var = true 
end 
return var 
end

-------  SecondSudo  -------
function SecondSudo(msg) 
local Status = DevAek:sismember(AEK..'Aek:SecondSudo:',msg.sender_user_id_) 
if Status or Sudo(msg) then  
return true  
else  
return false  
end  
end

----------  Bot  -----------
function Bot(msg) 
local var = false  
if msg.sender_user_id_ == tonumber(AEK) then  
var = true  
end  
return var  
end 

---------  SudoBot  --------
function SudoBot(msg) 
local Status = DevAek:sismember(AEK..'Aek:SudoBot:',msg.sender_user_id_) 
if Status or Sudo(msg) or SecondSudo(msg) or Bot(msg) then  
return true  
else  
return false  
end  
end

---------Manager All--------
function ManagerAll(msg) 
local Status = DevAek:sismember(AEK..'Aek:ManagerAll:',msg.sender_user_id_) 
if Status or SudoBot(msg) or Sudo(msg) or SecondSudo(msg) or Bot(msg) then  
return true  
else  
return false  
end  
end

--------- Admin All --------
function AdminAll(msg) 
local Status = DevAek:sismember(AEK..'Aek:AdminAll:',msg.sender_user_id_) 
if Status or SudoBot(msg) or ManagerAll(msg) or Sudo(msg) or SecondSudo(msg) or Bot(msg) then  
return true  
else  
return false  
end  
end

------ VIP MEMBER ALL ------
function VipAll(msg) 
local Status = DevAek:sismember(AEK..'Aek:VipAll:',msg.sender_user_id_) 
if Status or SudoBot(msg) or ManagerAll(msg) or AdminAll(msg) or Sudo(msg) or SecondSudo(msg) or Bot(msg) then  
return true  
else  
return false  
end  
end

----   AekConstructor   ----
function AekConstructor(msg) 
local Status = DevAek:sismember(AEK..'Aek:AekConstructor:'..msg.chat_id_,msg.sender_user_id_) 
if Status or SudoBot(msg) or Sudo(msg) or SecondSudo(msg) or Bot(msg) then  
return true  
else  
return false  
end  
end

----  BasicConstructor  ----
function BasicConstructor(msg) 
local Status = DevAek:sismember(AEK..'Aek:BasicConstructor:'..msg.chat_id_,msg.sender_user_id_) 
if Status or SudoBot(msg) or AekConstructor(msg) or Sudo(msg) or SecondSudo(msg) or Bot(msg) then  
return true  
else  
return false  
end  
end

----    Constructor     ----
function Constructor(msg) 
local Status = DevAek:sismember(AEK..'Aek:Constructor:'..msg.chat_id_,msg.sender_user_id_) 
if Status or SudoBot(msg) or AekConstructor(msg) or BasicConstructor(msg) or Sudo(msg) or SecondSudo(msg) or Bot(msg) then  
return true  
else  
return false  
end  
end

---------  Manager  --------
function Manager(msg) 
local Status = DevAek:sismember(AEK..'Aek:Managers:'..msg.chat_id_,msg.sender_user_id_) 
if Status or SudoBot(msg) or ManagerAll(msg) or AekConstructor(msg) or BasicConstructor(msg) or Constructor(msg) or Sudo(msg) or SecondSudo(msg) or Bot(msg) then  
return true  
else  
return false  
end  
end

----------  Admin  ---------
function Admin(msg) 
local Status = DevAek:sismember(AEK..'Aek:Admins:'..msg.chat_id_,msg.sender_user_id_) 
if Status or SudoBot(msg) or ManagerAll(msg) or AdminAll(msg) or AekConstructor(msg) or BasicConstructor(msg) or Constructor(msg) or Manager(msg) or Sudo(msg) or SecondSudo(msg) or Bot(msg) then  
return true  
else  
return false  
end  
end

---------Vip Member---------
function VipMem(msg) 
local Status = DevAek:sismember(AEK..'Aek:VipMem:'..msg.chat_id_,msg.sender_user_id_) 
if Status or SudoBot(msg) or ManagerAll(msg) or AdminAll(msg) or VipAll(msg) or AekConstructor(msg) or BasicConstructor(msg) or Constructor(msg) or Manager(msg) or Admin(msg) or Sudo(msg) or SecondSudo(msg) or Bot(msg) then  
return true  
else  
return false  
end  
end

--------- Cleaner ----------
function Cleaner(msg) 
local Status = DevAek:sismember(AEK..'Aek:Cleaner:'..msg.chat_id_,msg.sender_user_id_) 
if Status or SudoBot(msg) or AekConstructor(msg) or BasicConstructor(msg) or Constructor(msg) or Sudo(msg) or SecondSudo(msg) or Bot(msg) then  
return true  
else  
return false  
end  
end

---------  Banned  ---------
local function Ban(user_id, chat_id)
if DevAek:sismember(AEK..'Aek:Ban:'..chat_id, user_id) then
var = true
else
var = false
end
return var
end

---------  BanAll  ---------
function BanAll(user_id)
if DevAek:sismember(AEK..'Aek:BanAll:', user_id) then
var = true
else
var = false
end
return var
end

----------  Muted  ---------
local function Muted(user_id, chat_id)
if DevAek:sismember(AEK..'Aek:Muted:'..chat_id, user_id) then
var = true
else
var = false
end
return var
end

---------  MuteAll  --------
function MuteAll(user_id)
if DevAek:sismember(AEK..'Aek:MuteAll:', user_id) then
var = true
else
var = false
end
return var
end

function DeleteMessage(chatid ,mid)
pcall(tdcli_function ({
ID = "DeleteMessages",
chat_id_ = chatid,
message_ids_ = mid
},function(arg,data) 
end,nil))
end

function send(chat_id, reply_to_message_id, text)
local TextParseMode = {ID = "TextParseModeMarkdown"}
pcall(tdcli_function ({ID = "SendMessage",chat_id_ = chat_id,reply_to_message_id_ = reply_to_message_id,disable_notification_ = 1,from_background_ = 1,reply_markup_ = nil,input_message_content_ = {ID = "InputMessageText",text_ = text,disable_web_page_preview_ = 1,clear_draft_ = 0,entities_ = {},parse_mode_ = TextParseMode,},}, dl_cb, nil))
end

function AEKFiles(msg)
for v in io.popen('ls Files'):lines() do
if v:match(".lua$") then
plugin = dofile("Files/"..v)
if plugin.AEK and msg then
FilesText = plugin.AEK(msg)
end
end
end
send(msg.chat_id_, msg.id_,FilesText)  
end

function download_to_file(url, file_path) 
local respbody = {} 
local options = { url = url, sink = ltn12.sink.table(respbody), redirect = true } 
local response = nil 
options.redirect = false 
response = {https.request(options)} 
local code = response[2] 
local headers = response[3] 
local status = response[4] 
if code ~= 200 then return false, code 
end 
file = io.open(file_path, "w+") 
file:write(table.concat(respbody)) 
file:close() 
return file_path, code 
end 

function AddFile(msg,chat,ID_FILE,File_Name)
if File_Name:match('.json') then
if File_Name:lower():match('(%d+)') ~= AEK:lower() then 
send(chat,msg.id_,"✫︙عذرا هذا الملف ليس تابع لهذا البوت")   
return false 
end
send(chat,msg.id_,"✫︙جاري رفع الملف ... .")
local File = json:decode(https.request('https://api.telegram.org/bot' .. TokenBot .. '/getfile?file_id='..ID_FILE) ) 
download_to_file('https://api.telegram.org/file/bot'..TokenBot..'/'..File.result.file_path, ''..File_Name) 
else
send(chat,msg.id_,"✫︙عذرا الملف ليس بصيغة ↫ Json يرجى رفع الملف الصحيح")
end
local info_file = io.open('./'..AEK..'.json', "r"):read('*a')
local JsonInfo = JSON.decode(info_file)
vardump(JsonInfo)
DevAek:set(AEK.."Aek:NameBot",JsonInfo.BotName) 
for IdGps,v in pairs(JsonInfo.GroupsList) do
DevAek:sadd(AEK.."Aek:Groups",IdGps) 
DevAek:set(AEK.."Aek:Lock:Bots"..IdGps,"del") DevAek:hset(AEK.."Aek:Spam:Group:User"..IdGps ,"Spam:User","del") 
LockList ={'Aek:Lock:Links','Aek:Lock:Contact','Aek:Lock:Forwards','Aek:Lock:Videos','Aek:Lock:Gifs','Aek:Lock:EditMsgs','Aek:Lock:Stickers','Aek:Lock:Farsi','Aek:Lock:Spam','Aek:Lock:WebLinks','Aek:Lock:Photo'}
for i,Lock in pairs(LockList) do
DevAek:set(AEK..Lock..IdGps,true)
end
if v.AekConstructors then
for k,IdAekConstructors in pairs(v.AekConstructors) do
DevAek:sadd(AEK..'Aek:AekConstructor:'..IdGps,IdAekConstructors)  
print('تم رفع منشئين المجموعات')
end
end
if v.BasicConstructors then
for k,IdBasicConstructors in pairs(v.BasicConstructors) do
DevAek:sadd(AEK..'Aek:BasicConstructor:'..IdGps,IdBasicConstructors)  
print('تم رفع ( '..k..' ) منشئين اساسيين')
end
end
if v.Constructors then
for k,IdConstructors in pairs(v.Constructors) do
DevAek:sadd(AEK..'Aek:Constructor:'..IdGps,IdConstructors)  
print('تم رفع ( '..k..' ) منشئين')
end
end
if v.Managers then
for k,IdManagers in pairs(v.Managers) do
DevAek:sadd(AEK..'Aek:Managers:'..IdGps,IdManagers)  
print('تم رفع ( '..k..' ) مدراء')
end
end
if v.Admins then
for k,idmod in pairs(v.Admins) do
vardump(IdAdmins)
DevAek:sadd(AEK..'Aek:Admins:'..IdGps,IdAdmins)  
print('تم رفع ( '..k..' ) ادمنيه')
end
end
if v.Vips then
for k,IdVips in pairs(v.Vips) do
DevAek:sadd(AEK..'Aek:VipMem:'..IdGps,IdVips)  
print('تم رفع ( '..k..' ) مميزين')
end
end
if v.LinkGroups then
if v.LinkGroups ~= "" then
DevAek:set(AEK.."Aek:Groups:Links"..IdGps,v.LinkGroups)   
print('( تم وضع روابط المجموعات )')
end
end
if v.Welcomes then
if v.Welcomes ~= "" then
DevAek:set(AEK.."Aek:Groups:Welcomes"..IdGps,v.Welcomes)   
print('( تم وضع ترحيب المجموعات )')
end
end
end
send(chat,msg.id_,"✫︙تم رفع النسخه بنجاح \n✫︙تم تفعيل جميع المجموعات \n✫︙تم استرجاع مشرفين المجموعات \n✫︙تم استرجاع اوامر القفل والفتح في جميع مجموعات البوت ")
end

function resolve_username(username,cb)
tdcli_function ({
ID = "SearchPublicChat",
username_ = username
}, cb, nil)
end

function getInputFile(file)
if file:match('/') then
infile = {ID = "InputFileLocal", path_ = file}
elseif file:match('^%d+$') then
infile = {ID = "InputFileId", id_ = file}
else
infile = {ID = "InputFilePersistentId", persistent_id_ = file}
end
return infile
end

function getChatId(id)
local chat = {}
local id = tostring(id)
if id:match('^-100') then
local channel_id = id:gsub('-100', '')
chat = {ID = channel_id, type = 'channel'}
else
local group_id = id:gsub('-', '')
chat = {ID = group_id, type = 'group'}
end
return chat
end

function ChatLeave(chat_id, user_id)
tdcli_function ({ ID = "ChangeChatMemberStatus", chat_id_ = chat_id, user_id_ = user_id, status_ = { ID = "ChatMemberStatusLeft" }, }, dl_cb, nil)
end

function ChatKick(chat_id, user_id)
tdcli_function ({ ID = "ChangeChatMemberStatus", chat_id_ = chat_id, user_id_ = user_id, status_ = { ID = "ChatMemberStatusKicked" }, }, dl_cb, nil)
end

function getParseMode(parse_mode)
if parse_mode then
local mode = parse_mode:lower()
if mode == 'markdown' or mode == 'md' then
P = {ID = "TextParseModeMarkdown"}
elseif mode == 'html' then
P = {ID = "TextParseModeHTML"}
end
end
return P
end

function getMessage(chat_id, message_id,cb)
tdcli_function ({
ID = "GetMessage",
chat_id_ = chat_id,
message_id_ = message_id
}, cb, nil)
end

function sendContact(chat_id, reply_to_message_id, disable_notification, from_background, reply_markup, phone_number, first_name, last_name, user_id)
tdcli_function ({ ID = "SendMessage", chat_id_ = chat_id, reply_to_message_id_ = reply_to_message_id, disable_notification_ = disable_notification, from_background_ = from_background, reply_markup_ = reply_markup, input_message_content_ = { ID = "InputMessageContact", contact_ = { ID = "Contact", phone_number_ = phone_number, first_name_ = first_name, last_name_ = last_name, user_id_ = user_id },},}, dl_cb, nil)
end

function sendPhoto(chat_id, reply_to_message_id, disable_notification, from_background, reply_markup, photo, caption)
tdcli_function ({ ID = "SendMessage", chat_id_ = chat_id, reply_to_message_id_ = reply_to_message_id, disable_notification_ = disable_notification, from_background_ = from_background, reply_markup_ = reply_markup, input_message_content_ = { ID = "InputMessagePhoto", photo_ = getInputFile(photo), added_sticker_file_ids_ = {}, width_ = 0, height_ = 0, caption_ = caption }, }, dl_cb, nil)
end

function Dev_Aek(chat_id, reply_to_message_id, disable_notification, text, disable_web_page_preview, parse_mode)
local TextParseMode = getParseMode(parse_mode) tdcli_function ({ ID = "SendMessage", chat_id_ = chat_id, reply_to_message_id_ = reply_to_message_id, disable_notification_ = disable_notification, from_background_ = 1, reply_markup_ = nil, input_message_content_ = { ID = "InputMessageText", text_ = text, disable_web_page_preview_ = disable_web_page_preview, clear_draft_ = 0, entities_ = {}, parse_mode_ = TextParseMode, }, }, dl_cb, nil)
end

function GetApi(web) 
local info, res = https.request(web) 
local req = json:decode(info) if res ~= 200 then 
return false 
end 
if not req.ok then 
return false 
end 
return req 
end 

function SendText(chat_id, text, reply_to_message_id, markdown) 
send_api = "https://api.telegram.org/bot"..TokenBot 
local url = send_api.."/sendMessage?chat_id=" .. chat_id .. "&text=" .. URL.escape(text) 
if reply_to_message_id ~= 0 then 
url = url .. "&reply_to_message_id=" .. reply_to_message_id  
end 
if markdown == "md" or markdown == "markdown" then 
url = url.."&parse_mode=Markdown&disable_web_page_preview=true" 
elseif markdown == "html" then 
url = url.."&parse_mode=HTML" 
end 
return GetApi(url) 
end

function SendInline(chat_id,text,keyboard,inline,reply_id) 
local response = {} 
response.keyboard = keyboard 
response.inline_keyboard = inline 
response.resize_keyboard = true 
response.one_time_keyboard = false 
response.selective = false  
local send_api = "https://api.telegram.org/bot"..TokenBot.."/sendMessage?chat_id="..chat_id.."&text="..URL.escape(text).."&parse_mode=Markdown&disable_web_page_preview=true&reply_markup="..URL.escape(JSON.encode(response)) 
if reply_id then 
send_api = send_api.."&reply_to_message_id="..reply_id 
end 
return GetApi(send_api) 
end

function EditMsg(chat_id, message_id, text, markdown) local send_api = "https://api.telegram.org/bot"..TokenBot.."/editMessageText?chat_id="..chat_id.."&message_id="..message_id.."&text="..URL.escape(text).."&parse_mode=Markdown&disable_web_page_preview=true" return GetApi(send_api)  end

function pin(channel_id, message_id, disable_notification) 
tdcli_function ({ 
ID = "PinChannelMessage", 
channel_id_ = getChatId(channel_id).ID, 
message_id_ = message_id, 
disable_notification_ = disable_notification 
}, function(arg ,data)
vardump(data)
end ,nil) 
end

local AekRank = function(msg) if SudoId(msg.sender_user_id_) then AEKTEAM  = "المطور" elseif SecondSudo(msg) then AEKTEAM = "المطور الثانوي" elseif SudoBot(msg) then AEKTEAM = "المطور" elseif ManagerAll(msg) then AEKTEAM = "المدير العام" elseif AdminAll(msg) then AEKTEAM = "الادمن العام" elseif AekConstructor(msg) then AEKTEAM = "المالك" elseif BasicConstructor(msg) then AEKTEAM = "المنشئ الأساسي" elseif Constructor(msg) then AEKTEAM = "المنشئ" elseif Manager(msg) then AEKTEAM = "المدير" elseif Admin(msg) then AEKTEAM = "الادمن" else AEKTEAM = "العضو" end return AEKTEAM end
function IdRank(user_id,chat_id) if tonumber(user_id) == tonumber(1333034749) then AEKTEAM = 'مبرمج السورس' elseif tonumber(user_id) == tonumber(AEK) then AEKTEAM = 'البوت' elseif SudoId(user_id) then AEKTEAM = 'المطور الاساسي' elseif DevAek:sismember(AEK..'Aek:SecondSudo:', user_id) then AEKTEAM = 'المطور الثانوي' elseif DevAek:sismember(AEK..'Aek:SudoBot:', user_id) then AEKTEAM = DevAek:get(AEK.."Aek:SudoBot:Rd"..chat_id) or 'المطور' elseif DevAek:sismember(AEK..'Aek:ManagerAll:', user_id) then AEKTEAM = DevAek:get(AEK.."Aek:Managers:Rd"..chat_id) or 'المدير العام' elseif DevAek:sismember(AEK..'Aek:AdminAll:', user_id) then AEKTEAM = DevAek:get(AEK.."Aek:Admins:Rd"..chat_id) or 'الادمن العام' elseif DevAek:sismember(AEK..'Aek:VipAll:', user_id) then AEKTEAM = DevAek:get(AEK.."Aek:VipMem:Rd"..chat_id) or 'المميز العام' elseif DevAek:sismember(AEK..'Aek:AekConstructor:'..chat_id, user_id) then AEKTEAM = 'المالك' elseif DevAek:sismember(AEK..'Aek:BasicConstructor:'..chat_id, user_id) then AEKTEAM = DevAek:get(AEK.."Aek:BasicConstructor:Rd"..chat_id) or 'المنشئ الاساسي' elseif DevAek:sismember(AEK..'Aek:Constructor:'..chat_id, user_id) then AEKTEAM = DevAek:get(AEK.."Aek:Constructor:Rd"..chat_id) or 'المنشئ' elseif DevAek:sismember(AEK..'Aek:Managers:'..chat_id, user_id) then AEKTEAM = DevAek:get(AEK.."Aek:Managers:Rd"..chat_id) or 'المدير' elseif DevAek:sismember(AEK..'Aek:Admins:'..chat_id, user_id) then AEKTEAM = DevAek:get(AEK.."Aek:Admins:Rd"..chat_id) or 'الادمن' elseif DevAek:sismember(AEK..'Aek:VipMem:'..chat_id, user_id) then  AEKTEAM = DevAek:get(AEK.."Aek:VipMem:Rd"..chat_id) or 'المميز' elseif DevAek:sismember(AEK..'Aek:Cleaner:'..chat_id, user_id) then  AEKTEAM = DevAek:get(AEK.."Aek:Cleaner:Rd"..chat_id) or 'المنظف' else AEKTEAM = DevAek:get(AEK.."Aek:mem:Rd"..chat_id) or 'العضو' end return AEKTEAM end

function RankChecking(user_id,chat_id)
if SudoId(user_id) then
var = true  
elseif tonumber(user_id) == tonumber(AEK) then  
var = true  
elseif DevAek:sismember(AEK..'Aek:SecondSudo:', user_id) then
var = true  
elseif DevAek:sismember(AEK..'Aek:SudoBot:', user_id) then
var = true  
elseif DevAek:sismember(AEK..'Aek:ManagerAll:', user_id) then
var = true  
elseif DevAek:sismember(AEK..'Aek:AdminAll:', user_id) then
var = true  
elseif DevAek:sismember(AEK..'Aek:VipAll:', user_id) then
var = true  
elseif DevAek:sismember(AEK..'Aek:AekConstructor:'..chat_id, user_id) then
var = true
elseif DevAek:sismember(AEK..'Aek:BasicConstructor:'..chat_id, user_id) then
var = true
elseif DevAek:sismember(AEK..'Aek:Constructor:'..chat_id, user_id) then
var = true  
elseif DevAek:sismember(AEK..'Aek:Managers:'..chat_id, user_id) then
var = true  
elseif DevAek:sismember(AEK..'Aek:Admins:'..chat_id, user_id) then
var = true  
elseif DevAek:sismember(AEK..'Aek:VipMem:'..chat_id, user_id) then  
var = true 
else  
var = false
end  
return var
end
function AekDelAll(user_id,chat_id)
if SudoId(user_id) then
var = 'sudoid'  
elseif DevAek:sismember(AEK..'Aek:SecondSudo:', user_id) then
var = 'secondsudo' 
elseif DevAek:sismember(AEK..'Aek:SudoBot:', user_id) then
var = 'sudobot'  
elseif DevAek:sismember(AEK..'Aek:AekConstructor:'..chat_id, user_id) then
var = 'Aekconstructor'
elseif DevAek:sismember(AEK..'Aek:BasicConstructor:'..chat_id, user_id) then
var = 'basicconstructor'
elseif DevAek:sismember(AEK..'Aek:Constructor:'..chat_id, user_id) then
var = 'constructor'
elseif DevAek:sismember(AEK..'Aek:Managers:'..chat_id, user_id) then
var = 'manager'  
else  
var = 'No'
end  
return var
end 

local function Filters(msg, value)
local Aek = (AEK..'Aek:Filters:'..msg.chat_id_)
if Aek then
local names = DevAek:hkeys(Aek)
local value = value:gsub(' ','')
for i=1, #names do
if string.match(value:lower(), names[i]:lower()) and not VipMem(msg) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
end
end

function ReplyStatus(msg,user_id,status,text)
tdcli_function ({ID = "GetUser",user_id_ = user_id},function(arg,dp) 
if dp.first_name_ ~= false then
local UserName = (dp.username_ or "HH_418")
for gmatch in string.gmatch(dp.first_name_, "[^%s]+") do
dp.first_name_ = gmatch
end
if status == "WrongWay" then
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙عذرا عزيزي ↫ ["..dp.first_name_.."](T.me/"..UserName..")".."\n"..text, 1, 'md')
return false
end
if status == "Reply" then
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙العضو ↫ ["..dp.first_name_.."](T.me/"..UserName..")".."\n"..text, 1, 'md')
return false
end
if status == "ReplyBy" then
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙بواسطة ↫ ["..dp.first_name_.."](T.me/"..UserName..")".."\n"..text, 1, 'md')
return false
end
else
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙الحساب محذوف قم بالتاكد واعد المحاوله", 1, 'md')
end
end,nil)   
end

function GetCustomTitle(user_id,chat_id)
local Check = https.request('https://api.telegram.org/bot'..TokenBot..'/getChatMember?chat_id='..chat_id..'&user_id='..user_id)
local GetInfo = JSON.decode(Check)
if GetInfo.ok == true then
if GetInfo.result.status == "creator" then 
Status = "المالك"
elseif GetInfo.result.status == "administrator" then 
Status = "مشرف"
else
Status = false
end
if GetInfo.result.custom_title then 
Aek = GetInfo.result.custom_title
else 
Aek = Status
end
end
return Aek
end
function Validity(msg,user_id) 
local Check = https.request('https://api.telegram.org/bot'..TokenBot..'/getChatMember?chat_id='..msg.chat_id_..'&user_id='..user_id)
local GetInfo = JSON.decode(Check)
if GetInfo.ok == true then
if GetInfo.result.status == "creator" then
send(msg.chat_id_,msg.id_,'✫︙مالك المجموعه')   
return false  end 
if GetInfo.result.status == "member" then
send(msg.chat_id_,msg.id_,'✫︙مجرد عضو هنا')   
return false  end
if GetInfo.result.status == 'left' then
send(msg.chat_id_,msg.id_,'✫︙الشخص غير موجود هنا')   
return false  end
if GetInfo.result.status == "administrator" then
if GetInfo.result.can_change_info == true then EDT = '✔️' else EDT = '✖️' end
if GetInfo.result.can_delete_messages == true then DEL = '✔️' else DEL = '✖️' end
if GetInfo.result.can_invite_users == true then INV = '✔️' else INV = '✖️' end
if GetInfo.result.can_pin_messages == true then PIN = '✔️' else PIN = '✖️' end
if GetInfo.result.can_restrict_members == true then BAN = '✔️' else BAN = '✖️' end
if GetInfo.result.can_promote_members == true then VIP = '✔️' else VIP = '✖️' end 
send(msg.chat_id_,msg.id_,'✫︙صلاحيات '..GetCustomTitle(user_id,msg.chat_id_)..' هي ↫ ⤈\n━───━ ✫ ━───━\n✫︙حذف الرسائل ↫ '..DEL..'\n✫︙دعوة المستخدمين ↫ '..INV..'\n✫︙حظر المستخدمين ↫ '..BAN..'\n✫︙تثبيت الرسائل ↫ '..PIN..'\n✫︙تغيير المعلومات ↫ '..EDT..'\n✫︙اضافة مشرفين ↫ '..VIP..'\n━───━ ✫ ━───━')
end
end
end

function GetBio(chat_id)
local Check = https.request('https://api.telegram.org/bot'..TokenBot..'/getChat?chat_id='..chat_id)
local GetInfo = JSON.decode(Check)
if GetInfo.ok == true then
if GetInfo.result.bio then 
Aek = GetInfo.result.bio
else 
Aek = "لا يوجد"
end
end
return Aek
end

local sendRequest = function(request_id, chat_id, reply_to_message_id, disable_notification, from_background, reply_markup, input_message_content, callback, extra)
tdcli_function({ ID = request_id, chat_id_ = chat_id, reply_to_message_id_ = reply_to_message_id, disable_notification_ = disable_notification, from_background_ = from_background, reply_markup_ = reply_markup, input_message_content_ = input_message_content }, callback or dl_cb, extra)
end
local sendDocument = function(chat_id, reply_to_message_id, disable_notification, from_background, reply_markup, document, caption, cb, cmd)
local input_message_content = { ID = "InputMessageDocument", document_ = getInputFile(document), caption_ = caption } sendRequest("SendMessage", chat_id, reply_to_message_id, disable_notification, from_background, reply_markup, input_message_content, cb, cmd)
end
local function sendVoice(chat_id, reply_to_message_id, disable_notification, from_background, reply_markup, voice, duration, waveform, caption, cb, cmd)
local input_message_content = { ID = "InputMessageVoice", voice_ = getInputFile(voice), duration_ = duration or 0, waveform_ = waveform, caption_ = caption } sendRequest('SendMessage', chat_id, reply_to_message_id, disable_notification, from_background, reply_markup, input_message_content, cb, cmd)
end
local function sendAudio(chat_id, reply_to_message_id, disable_notification, from_background, reply_markup, audio, duration, waveform, caption, cb, cmd)
local input_message_content = { ID = "InputMessageAudio", audio_ = getInputFile(audio), duration_ = duration or 0, waveform_ = waveform, caption_ = caption } sendRequest('SendMessage', chat_id, reply_to_message_id, disable_notification, from_background, reply_markup, input_message_content, cb, cmd)
end
local function sendVideo(chat_id, reply_to_message_id, disable_notification, from_background, reply_markup, video, duration, width, height, caption, cb, cmd)    
local input_message_content = { ID = "InputMessageVideo",      video_ = getInputFile(video),      added_sticker_file_ids_ = {},      duration_ = duration or 0,      width_ = width or 0,      height_ = height or 0,      caption_ = caption    }    sendRequest('SendMessage', chat_id, reply_to_message_id, disable_notification, from_background, reply_markup, input_message_content, cb, cmd)  
end
local sendSticker = function(chat_id, reply_to_message_id, disable_notification, from_background, reply_markup, sticker)
local input_message_content = { ID = "InputMessageSticker", sticker_ = getInputFile(sticker), width_ = 0, height_ = 0 } sendRequest("SendMessage", chat_id, reply_to_message_id, disable_notification, from_background, reply_markup, input_message_content, cb, cmd)
end 
function formsgs(msgs) 
local MsgText = ''  
if tonumber(msgs) < 100 then 
MsgText = 'جدا ضعيف' 
elseif tonumber(msgs) < 250 then 
MsgText = 'ضعيف' 
elseif tonumber(msgs) < 500 then 
MsgText = 'غير متفاعل' 
elseif tonumber(msgs) < 750 then 
MsgText = 'متوسط' 
elseif tonumber(msgs) < 1000 then 
MsgText = 'متفاعل' 
elseif tonumber(msgs) < 2000 then 
MsgText = 'قمة التفاعل' 
elseif tonumber(msgs) < 3000 then 
MsgText = 'ملك التفاعل'  
elseif tonumber(msgs) < 4000 then 
MsgText = 'اسطورة التفاعل' 
elseif tonumber(msgs) < 5000 then 
MsgText = 'متفاعل نار' 
elseif tonumber(msgs) < 6000 then 
MsgText = 'يجدح جدح' 
elseif tonumber(msgs) < 7000 then 
MsgText = 'خيالي' 
elseif tonumber(msgs) < 8000 then 
MsgText = 'رب التفاعل' 
elseif tonumber(msgs) < 9000 then 
MsgText = 'كافر بالتفاعل' 
elseif tonumber(msgs) < 10000000000 then 
MsgText = "معلك لربك" 
end 
return MsgText
end

function Aekmoned(chat_id, user_id, msg_id, text, offset, length) local tt = DevAek:get(AEK..'endmsg') or '' tdcli_function ({ ID = "SendMessage", chat_id_ = chat_id, reply_to_message_id_ = msg_id, disable_notification_ = 0, from_background_ = 1, reply_markup_ = nil, input_message_content_ = { ID = "InputMessageText", text_ = text..'\n\n'..tt, disable_web_page_preview_ = 1, clear_draft_ = 0, entities_ = {[0]={ ID="MessageEntityMentionName", offset_=offset, length_=length, user_id_=user_id }, }, }, }, dl_cb, nil) end

function SourcelionCh(msg) 
local url,res = https.request('https://dssvbs.ml/API/Apiistark.php?id='..msg.sender_user_id_)
data = JSON.decode(url)
if data.ChatMember.Aekan ~= true then
Var = false
send(msg.chat_id_,msg.id_,'['..data.ChatMember.Aekan..']')   
else
Var = true
end
return Var
end
function ChCheck(msg)
local var = true 
if DevAek:get(AEK.."Aek:ChId") then
local url , res = https.request('https://api.telegram.org/bot'..TokenBot..'/getchatmember?chat_id='..DevAek:get(AEK..'Aek:ChId')..'&user_id='..msg.sender_user_id_)
local data = json:decode(url)
if res ~= 200 or data.result.status == "left" or data.result.status == "kicked" then
var = false 
if DevAek:get(AEK..'Aek:ChText') then
local ChText = DevAek:get(AEK..'Aek:ChText')
send(msg.chat_id_,msg.id_,'['..ChText..']')
else
local Check = https.request('https://api.telegram.org/bot'..TokenBot..'/getChat?chat_id='..DevAek:get(AEK.."Aek:ChId"))
local GetInfo = JSON.decode(Check)
if GetInfo.result.username then
User = "https://t.me/"..GetInfo.result.username
else
User = GetInfo.result.invite_link
end
Text = "✫︙هلو عمري عذرآ !\n✫︙عليك الاشتراك في قناتي اولآ"
keyboard = {} 
keyboard.inline_keyboard = {{{text=GetInfo.result.title,url=User}}} 
Msg_id = msg.id_/2097152/0.5
https.request("https://api.telegram.org/bot"..TokenBot..'/sendMessage?chat_id='..msg.chat_id_..'&text=' .. URL.escape(Text).."&reply_to_message_id="..Msg_id.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end
elseif data.ok then
return var
end
else
return var
end
end
function tdcli_update_callback(data)
if (data.ID == "UpdateNewCallbackQuery") then
local Chat_Id2 = data.chat_id_
local MsgId2 = data.message_id_
local DataText = data.payload_.data_
local Msg_Id2 = data.message_id_/2097152/0.5
if DataText == '/delyes' and DevAek:get(AEK..'yes'..data.sender_user_id_) == 'delyes' then
DevAek:del(AEK..'yes'..data.sender_user_id_, 'delyes')
DevAek:del(AEK..'no'..data.sender_user_id_, 'delno')
if RankChecking(data.sender_user_id_, data.chat_id_) then
EditMsg(Chat_Id2, Msg_Id2, "✫︙لا استطيع طرد ↫ "..IdRank(data.sender_user_id_, data.chat_id_)) 
return false
end
tdcli_function({ID="ChangeChatMemberStatus",chat_id_=data.chat_id_,user_id_=data.sender_user_id_,status_={ID="ChatMemberStatusKicked"},},function(arg,da) 
if (da and da.code_ and da.code_ == 400 and da.message_ == "CHAT_ADMIN_REQUIRED") then 
EditMsg(Chat_Id2, Msg_Id2, "✫︙ليس لدي صلاحية حظر المستخدمين يرجى تفعيلها !") 
return false  
end
if (da and da.code_ and da.code_ == 3) then 
EditMsg(Chat_Id2, Msg_Id2, "✫︙البوت ليس ادمن يرجى ترقيتي !") 
return false  
end
if da and da.code_ and da.code_ == 400 and da.message_ == "USER_ADMIN_INVALID" then 
EditMsg(Chat_Id2, Msg_Id2, "✫︙لا استطيع طرد مشرفين المجموعه") 
return false  
end
if da and da.ID and da.ID == "Ok" then
ChatKick(data.chat_id_, data.sender_user_id_)
EditMsg(Chat_Id2, Msg_Id2, "✫︙تم طردك من المجموعه") 
return false
end
end,nil)  
end
if DataText == '/delno' and DevAek:get(AEK..'no'..data.sender_user_id_) == 'delno' then
DevAek:del(AEK..'yes'..data.sender_user_id_, 'delyes')
DevAek:del(AEK..'no'..data.sender_user_id_, 'delno')
EditMsg(Chat_Id2, Msg_Id2, "✫︙تم الغاء امر اطردني") 
end

if DataText == '/yesdel' and DevAek:get(AEK..'yesdel'..data.sender_user_id_) == 'delyes' then
DevAek:del(AEK..'yesdel'..data.sender_user_id_, 'delyes')
DevAek:del(AEK..'nodel'..data.sender_user_id_, 'delno')
if DevAek:sismember(AEK..'Aek:Constructor:'..data.chat_id_, data.sender_user_id_) then
constructor = 'المنشئين • ' else constructor = '' end 
if DevAek:sismember(AEK..'Aek:Managers:'..data.chat_id_, data.sender_user_id_) then
Managers = 'المدراء • ' else Managers = '' end
if DevAek:sismember(AEK..'Aek:Admins:'..data.chat_id_, data.sender_user_id_) then
admins = 'الادمنيه • ' else admins = '' end
if DevAek:sismember(AEK..'Aek:VipMem:'..data.chat_id_, data.sender_user_id_) then
vipmem = 'المميزين • ' else vipmem = '' end
if DevAek:sismember(AEK..'Aek:Cleaner:'..data.chat_id_, data.sender_user_id_) then
cleaner = 'المنظفين • ' else cleaner = '' end
if DevAek:sismember(AEK..'User:Donky:'..data.chat_id_, data.sender_user_id_) then
donky = 'المطايه • ' else donky = '' end
if DevAek:sismember(AEK..'Aek:Constructor:'..data.chat_id_, data.sender_user_id_) or DevAek:sismember(AEK..'Aek:Managers:'..data.chat_id_, data.sender_user_id_) or DevAek:sismember(AEK..'Aek:Admins:'..data.chat_id_, data.sender_user_id_) or DevAek:sismember(AEK..'Aek:VipMem:'..data.chat_id_, data.sender_user_id_) or DevAek:sismember(AEK..'Aek:Cleaner:'..data.chat_id_, data.sender_user_id_) or DevAek:sismember(AEK..'User:Donky:'..data.chat_id_, data.sender_user_id_) then
DevAek:srem(AEK..'Aek:Constructor:'..data.chat_id_,data.sender_user_id_)
DevAek:srem(AEK..'Aek:Managers:'..data.chat_id_,data.sender_user_id_)
DevAek:srem(AEK..'Aek:Admins:'..data.chat_id_,data.sender_user_id_)
DevAek:srem(AEK..'Aek:VipMem:'..data.chat_id_,data.sender_user_id_)
DevAek:srem(AEK..'Aek:Cleaner:'..data.chat_id_,data.sender_user_id_)
DevAek:srem(AEK..'User:Donky:'..data.chat_id_,data.sender_user_id_)
EditMsg(Chat_Id2, Msg_Id2, "✫︙تم تنزيلك من ↫ ⤈\n~ ( "..constructor..''..Managers..''..admins..''..vipmem..''..cleaner..''..donky.." ) ~ \n") 
else 
if IdRank(data.sender_user_id_, data.chat_id_) == 'العضو' then
EditMsg(Chat_Id2, Msg_Id2, "✫︙ليس لديك رتبه في البوت") 
else 
EditMsg(Chat_Id2, Msg_Id2, "✫︙لا استطيع تنزيل ↫ "..IdRank(data.sender_user_id_, data.chat_id_)) 
end
end
end
if DevAek:get(AEK.."Aek:NewDev"..data.sender_user_id_) then
if DataText == '/setno' then
EditMsg(Chat_Id2, Msg_Id2, "✫︙تم الغاء امر تغير المطور الاساسي") 
DevAek:del(AEK.."Aek:NewDev"..data.sender_user_id_)
return false
end
if DataText == '/setyes' then
local NewDev = DevAek:get(AEK.."Aek:NewDev"..data.sender_user_id_)
tdcli_function ({ID = "GetUser",user_id_ = NewDev},function(arg,dp) 
EditMsg(Chat_Id2, Msg_Id2, "✫︙المطور الجديد ↫ ["..dp.first_name_.."](tg://user?id="..dp.id_..")\n✫︙تم تغير المطور الاساسي بنجاح") 
end,nil)
tdcli_function ({ID = "GetUser",user_id_ = data.sender_user_id_},function(arg,dp) 
SendText(NewDev,"✫︙بواسطة ↫ ["..dp.first_name_.."](tg://user?id="..dp.id_..")\n✫︙لقد اصبحت انت مطور هذا البوت",0,'md')
end,nil)
local Create = function(data, file, uglify)  
file = io.open(file, "w+")   
local serialized   
if not uglify then  
serialized = serpent.block(data, {comment = false, name = "Config"})  
else  
serialized = serpent.dump(data)  
end    
file:write(serialized)
file:close()  
end
Config = {
DevId = NewDev,
TokenBot = TokenBot,
AEK = TokenBot:match("(%d+)"),
SudoIds = {NewDev},
}
Create(Config, "./config.lua")  
DevAek:del(AEK.."Aek:NewDev"..data.sender_user_id_)
dofile('AEK.lua') 
end
end
if DataText == '/nodel' and DevAek:get(AEK..'nodel'..data.sender_user_id_) == 'delno' then
DevAek:del(AEK..'yesdel'..data.sender_user_id_, 'delyes')
DevAek:del(AEK..'nodel'..data.sender_user_id_, 'delno')
EditMsg(Chat_Id2, Msg_Id2, "✫︙تم الغاء امر نزلني") 
end
if DataText == '/YesRolet' and DevAek:get(AEK.."Aek:WittingStartRolet"..data.chat_id_..data.sender_user_id_) then
local List = DevAek:smembers(AEK..'Aek:ListRolet'..data.chat_id_) 
local UserName = List[math.random(#List)]
tdcli_function ({ID="SearchPublicChat",username_ = UserName},function(arg,dp) 
DevAek:incrby(AEK..'Aek:GamesNumber'..data.chat_id_..dp.id_, 5) 
end,nil) 
DevAek:del(AEK..'Aek:ListRolet'..data.chat_id_) 
DevAek:del(AEK.."Aek:WittingStartRolet"..data.chat_id_..data.sender_user_id_)
EditMsg(Chat_Id2, Msg_Id2, "✫︙*صاحب الحظ* ↫ ["..UserName.."]\n✫︙*مبروك لقد ربحت وحصلت على 5 نقاط يمكنك استبدالها بالرسائل*")
end
if DataText == '/NoRolet' then
DevAek:del(AEK..'Aek:ListRolet'..data.chat_id_) 
DevAek:del(AEK.."Aek:NumRolet"..data.chat_id_..data.sender_user_id_) 
DevAek:del(AEK.."Aek:WittingStartRolet"..data.chat_id_..data.sender_user_id_)
EditMsg(Chat_Id2, Msg_Id2, "✫︙تم الغاء اللعبه لاعادة اللعب ارسل الالعاب") 
end
if DataText == '/ListRolet' then
local List = DevAek:smembers(AEK..'Aek:ListRolet'..data.chat_id_) 
local Text = '✫︙قائمة اللاعبين ↫ ⤈\n━───━ ✫ ━───━\n' 
local Textt = '━───━ ✫ ━───━\n✫︙تم اكتمال العدد الكلي هل انت مستعد ؟'
for k, v in pairs(List) do 
Text = Text..k.."~ : [" ..v.."]\n"  
end 
keyboard = {} 
keyboard.inline_keyboard = {{{text="نعم",callback_data="/YesRolet"},{text="لا",callback_data="/NoRolet"}}} 
return https.request("https://api.telegram.org/bot"..TokenBot..'/editMessageText?chat_id='..Chat_Id2..'&message_id='..Msg_Id2..'&text=' .. URL.escape(Text..Textt).."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end
if DataText and DataText:match('/LinkInline:(.*)') then
local Aeek = DataText:match('/LinkInline:(.*)')
if tonumber(Aeek) == tonumber(data.sender_user_id_) then
tdcli_function({ID ="GetChat",chat_id_=data.chat_id_},function(arg,dp) 
local Text = '✫︙ 𝒈𝒓𝒐𝒖𝒑 𝒍𝒊𝒏𝒌 ↬ ⤈ \n━───━ ✫ ━───━\n['..dp.title_..']('..DevAek:get(AEK.."Aek:Groups:Links"..data.chat_id_)..')'
keyboard = {} 
keyboard.inline_keyboard = {{{text=dp.title_,url=DevAek:get(AEK.."Aek:Groups:Links"..data.chat_id_)}}} 
https.request("https://api.telegram.org/bot"..TokenBot..'/editMessageText?chat_id='..Chat_Id2..'&message_id='..Msg_Id2..'&text='..URL.escape(Text).."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end,nil)
else
return https.request("https://api.telegram.org/bot"..TokenBot..'/answercallbackquery?callback_query_id='..data.id_..'&text='..URL.escape("✫︙ عذرا الامر ليس لك .")..'&show_alert=true')
end
end
if DataText and DataText:match('/LinkText:(.*)') then
local Aeek = DataText:match('/LinkText:(.*)')
if tonumber(Aeek) == tonumber(data.sender_user_id_) then
EditMsg(Chat_Id2, Msg_Id2,'✫︙ 𝒈𝒓𝒐𝒖𝒑 𝒍𝒊𝒏𝒌 ↬ ⤈ \n━───━ ✫ ━───━\n['..DevAek:get(AEK.."Aek:Groups:Links"..data.chat_id_)..']')
else
return https.request("https://api.telegram.org/bot"..TokenBot..'/answercallbackquery?callback_query_id='..data.id_..'&text='..URL.escape("✫︙ عذرا الامر ليس لك .")..'&show_alert=true')
end
end
if DataText and DataText:match('/Song:'..tonumber(data.sender_user_id_)..'(.*)') then
local Aek = DataText:match('/Song:'..tonumber(data.sender_user_id_)..'(.*)')
Aek = math.random(2,2216); 
local Text ='*✫︙تم اختيار المقطع الصوتي لك*'
keyboard = {}  
keyboard.inline_keyboard = {{{text="✫ مرة أخرى ᥀",callback_data="/Song:"..data.sender_user_id_}},{{text="‹  𝖲𝗈𝗎𝗋𝖼𝖾 𝙄𝘽𝙊 ›",url="t.me/HH_418"}}} 
return https.request("https://api.telegram.org/bot"..TokenBot..'/sendVoice?chat_id=' .. data.chat_id_ .. '&voice=https://t.me/AudioAek/'..Aek..'&caption=' .. URL.escape(Text).."&reply_to_message_id="..Msg_Id2.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard)) 
else
end
if DataText and DataText:match('/mp3:'..tonumber(data.sender_user_id_)..'(.*)') then
local Aek = DataText:match('/mp3:'..tonumber(data.sender_user_id_)..'(.*)')
Aek = math.random(14,3059); 
local Text ='*✫︙تم اختيار الاغنيه لك*'
keyboard = {}  
keyboard.inline_keyboard = {{{text="✫ مرة أخرى ᥀",callback_data="/mp3:"..data.sender_user_id_}},{{text="‹  𝖲𝗈𝗎𝗋𝖼𝖾 𝙄𝘽𝙊 ›",url="t.me/HH_418"}}} 
return https.request("https://api.telegram.org/bot"..TokenBot..'/sendAudio?chat_id=' .. data.chat_id_ .. '&audio=https://t.me/SongAek/'..Aek..'&caption=' .. URL.escape(Text).."&reply_to_message_id="..Msg_Id2.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard)) 
else
end
if DataText and DataText:match('/remix:'..tonumber(data.sender_user_id_)..'(.*)') then
local Aek = DataText:match('/remix:'..tonumber(data.sender_user_id_)..'(.*)')
Aek = math.random(2,0042); 
local Text ='*✫︙تم اختيار الريمكس لك*'
keyboard = {}  
keyboard.inline_keyboard = {{{text="✫ مرة أخرى ᥀",callback_data="/remix:"..data.sender_user_id_}},{{text="‹  𝖲𝗈𝗎𝗋𝖼𝖾 𝙄𝘽𝙊 ›",url="t.me/HH_418"}}} 
return https.request("https://api.telegram.org/bot"..TokenBot..'/sendVoice?chat_id=' .. data.chat_id_ .. '&voice=https://t.me/RemixAek/'..Aek..'&caption=' .. URL.escape(Text).."&reply_to_message_id="..Msg_Id2.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard)) 
else
end
if DataText and DataText:match('/memz:'..tonumber(data.sender_user_id_)..'(.*)') then
local Aek = DataText:match('/memz:'..tonumber(data.sender_user_id_)..'(.*)')
Aek = math.random(2,1170); 
local Text ='*✫︙تم اختيار مقطع الميمز لك*'
keyboard = {}  
keyboard.inline_keyboard = {{{text="✫ مرة أخرى ᥀",callback_data="/memz:"..data.sender_user_id_}},{{text="‹  𝖲𝗈𝗎𝗋𝖼𝖾 𝙄𝘽𝙊 ›",url="t.me/HH_418"}}} 
return https.request("https://api.telegram.org/bot"..TokenBot..'/sendVoice?chat_id=' .. data.chat_id_ .. '&voice=https://t.me/MemesAek/'..Aek..'&caption=' .. URL.escape(Text).."&reply_to_message_id="..Msg_Id2.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard)) 
else
end
if DataText and DataText:match('/gif:'..tonumber(data.sender_user_id_)..'(.*)') then
local Aek = DataText:match('/gif:'..tonumber(data.sender_user_id_)..'(.*)')
Aek = math.random(01,0205); 
local Text ='*✫︙تم اختيار المتحركه لك*'
keyboard = {}  
keyboard.inline_keyboard = {{{text="✫ مرة أخرى ᥀",callback_data="/gif:"..data.sender_user_id_}},{{text="‹  𝖲𝗈𝗎𝗋𝖼𝖾 𝙄𝘽𝙊 ›",url="t.me/HH_418"}}} 
https.request("https://api.telegram.org/bot"..TokenBot..'/sendanimation?chat_id=' .. data.chat_id_ .. '&animation=https://t.me/GifAek/'..Aek..'&caption=' .. URL.escape(Text).."&reply_to_message_id="..Msg_Id2.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard)) 
end
if DataText and DataText:match('/photo:'..tonumber(data.sender_user_id_)..'(.*)') then
local Aek = DataText:match('/photo:'..tonumber(data.sender_user_id_)..'(.*)')
Aek = math.random(1,0075); 
local Text ='*✫︙تم اختيار الصوره لك*'
keyboard = {}  
keyboard.inline_keyboard = {{{text="✫ مرة أخرى ᥀",callback_data="/photo:"..data.sender_user_id_}},{{text="‹  𝖲𝗈𝗎𝗋𝖼𝖾 𝙄𝘽𝙊 ›",url="t.me/HH_418"}}} 
https.request("https://api.telegram.org/bot"..TokenBot..'/sendphoto?chat_id=' .. data.chat_id_ .. '&photo=https://t.me/PhotosAek/'..Aek..'&caption=' .. URL.escape(Text).."&reply_to_message_id="..Msg_Id2.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard)) 
end

if DataText and DataText:match('/anime:'..tonumber(data.sender_user_id_)..'(.*)') then
local Aek = DataText:match('/anime:'..tonumber(data.sender_user_id_)..'(.*)')
Aek = math.random(3,1002); 
local Text ='*✫︙تم اختيار صورة الانمي لك*'
keyboard = {}  
keyboard.inline_keyboard = {{{text="✫ مرة أخرى ᥀",callback_data="/anime:"..data.sender_user_id_}},{{text="‹  𝖲𝗈𝗎𝗋𝖼𝖾 𝙄𝘽𝙊 ›",url="t.me/HH_418"}}} 
https.request("https://api.telegram.org/bot"..TokenBot..'/sendphoto?chat_id=' .. data.chat_id_ .. '&photo=https://t.me/AnimeAek/'..Aek..'&caption=' .. URL.escape(Text).."&reply_to_message_id="..Msg_Id2.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard)) 
end
if DataText and DataText:match(tonumber(data.sender_user_id_)..':SetMem:(.*)') then
local AekId = DataText:match(tonumber(data.sender_user_id_)..':SetMem:(.*)')
tdcli_function ({ID = "GetUser",user_id_ = AekId},function(arg,dp) 
DevAek:sadd(AEK..'Aek:VipMem:'..data.chat_id_,dp.id_)
EditMsg(Chat_Id2, Msg_Id2,'✫︙العضو ↫ ['..dp.first_name_..'](t.me/'..(dp.username_ or 'HH_418')..')\n✫︙تم رفعه في قائمة المميزين')
end,nil)
elseif DataText and DataText:match(tonumber(data.sender_user_id_)..':SetCleaner:(.*)') then
local AekId = DataText:match(tonumber(data.sender_user_id_)..':SetCleaner:(.*)')
tdcli_function ({ID = "GetUser",user_id_ = AekId},function(arg,dp) 
DevAek:sadd(AEK..'Aek:Cleaner:'..data.chat_id_,dp.id_)
EditMsg(Chat_Id2, Msg_Id2,'✫︙العضو ↫ ['..dp.first_name_..'](t.me/'..(dp.username_ or 'HH_418')..')\n✫︙تم رفعه في قائمة المنظفين')
end,nil)
elseif DataText and DataText:match(tonumber(data.sender_user_id_)..':SetAdmin:(.*)') then
local AekId = DataText:match(tonumber(data.sender_user_id_)..':SetAdmin:(.*)')
tdcli_function ({ID = "GetUser",user_id_ = AekId},function(arg,dp) 
DevAek:sadd(AEK..'Aek:Admins:'..data.chat_id_,dp.id_)
EditMsg(Chat_Id2, Msg_Id2,'✫︙العضو ↫ ['..dp.first_name_..'](t.me/'..(dp.username_ or 'HH_418')..')\n✫︙تم رفعه في قائمة الادمنيه')
end,nil)
elseif DataText and DataText:match(tonumber(data.sender_user_id_)..':SetManager:(.*)') then
local AekId = DataText:match(tonumber(data.sender_user_id_)..':SetManager:(.*)')
tdcli_function ({ID = "GetUser",user_id_ = AekId},function(arg,dp) 
DevAek:sadd(AEK..'Aek:Managers:'..data.chat_id_,dp.id_)
EditMsg(Chat_Id2, Msg_Id2,'✫︙العضو ↫ ['..dp.first_name_..'](t.me/'..(dp.username_ or 'HH_418')..')\n✫︙تم رفعه في قائمة المدراء')
end,nil)
elseif DataText and DataText:match(tonumber(data.sender_user_id_)..':SetConstructor:(.*)') then
local AekId = DataText:match(tonumber(data.sender_user_id_)..':SetConstructor:(.*)')
tdcli_function ({ID = "GetUser",user_id_ = AekId},function(arg,dp) 
DevAek:sadd(AEK..'Aek:Constructor:'..data.chat_id_,dp.id_)
EditMsg(Chat_Id2, Msg_Id2,'✫︙العضو ↫ ['..dp.first_name_..'](t.me/'..(dp.username_ or 'HH_418')..')\n✫︙تم رفعه في قائمة المنشئين')
end,nil)
elseif DataText and DataText:match(tonumber(data.sender_user_id_)..':SetBasicConstructor:(.*)') then
local AekId = DataText:match(tonumber(data.sender_user_id_)..':SetBasicConstructor:(.*)')
tdcli_function ({ID = "GetUser",user_id_ = AekId},function(arg,dp) 
DevAek:sadd(AEK..'Aek:BasicConstructor:'..data.chat_id_,dp.id_)
EditMsg(Chat_Id2, Msg_Id2,'✫︙العضو ↫ ['..dp.first_name_..'](t.me/'..(dp.username_ or 'HH_418')..')\n✫︙تم رفعه في قائمة المنشئين الاساسيين')
end,nil)
elseif DataText and DataText:match(tonumber(data.sender_user_id_)..':SetAekConstructor:(.*)') then
local AekId = DataText:match(tonumber(data.sender_user_id_)..':SetAekConstructor:(.*)')
tdcli_function ({ID = "GetUser",user_id_ = AekId},function(arg,dp) 
DevAek:sadd(AEK..'Aek:AekConstructor:'..data.chat_id_,dp.id_)
EditMsg(Chat_Id2, Msg_Id2,'✫︙العضو ↫ ['..dp.first_name_..'](t.me/'..(dp.username_ or 'HH_418')..')\n✫︙تم رفعه في قائمة المالكين الاساسيين')
end,nil)
elseif DataText and DataText:match(tonumber(data.sender_user_id_)..':SetSudoBot:(.*)') then
local AekId = DataText:match(tonumber(data.sender_user_id_)..':SetSudoBot:(.*)')
tdcli_function ({ID = "GetUser",user_id_ = AekId},function(arg,dp) 
DevAek:sadd(AEK..'Aek:SudoBot:'..data.chat_id_,dp.id_)
EditMsg(Chat_Id2, Msg_Id2,'✫︙العضو ↫ ['..dp.first_name_..'](t.me/'..(dp.username_ or 'HH_418')..')\n✫︙تم رفعه في قائمة المطورين')
end,nil)
elseif DataText and DataText:match(tonumber(data.sender_user_id_)..':SetSecondSudo:(.*)') then
local AekId = DataText:match(tonumber(data.sender_user_id_)..':SetSecondSudo:(.*)')
tdcli_function ({ID = "GetUser",user_id_ = AekId},function(arg,dp) 
DevAek:sadd(AEK..'Aek:SecondSudo:'..data.chat_id_,dp.id_)
EditMsg(Chat_Id2, Msg_Id2,'✫︙العضو ↫ ['..dp.first_name_..'](t.me/'..(dp.username_ or 'HH_418')..')\n✫︙تم رفعه في قائمة المطورين الثانويين')
end,nil)
end

if DataText and DataText:match(tonumber(data.sender_user_id_)..':RemMem:(.*)') then
local AekId = DataText:match(tonumber(data.sender_user_id_)..':RemMem:(.*)')
tdcli_function ({ID = "GetUser",user_id_ = AekId},function(arg,dp) 
DevAek:srem(AEK..'Aek:VipMem:'..data.chat_id_,dp.id_)
EditMsg(Chat_Id2, Msg_Id2,'✫︙العضو ↫ ['..dp.first_name_..'](t.me/'..(dp.username_ or 'HH_418')..')\n✫︙تم تنزيله من قائمة المميزين')
end,nil)
elseif DataText and DataText:match(tonumber(data.sender_user_id_)..':RemCleaner:(.*)') then
local AekId = DataText:match(tonumber(data.sender_user_id_)..':RemCleaner:(.*)')
tdcli_function ({ID = "GetUser",user_id_ = AekId},function(arg,dp) 
DevAek:srem(AEK..'Aek:Cleaner:'..data.chat_id_,dp.id_)
EditMsg(Chat_Id2, Msg_Id2,'✫︙العضو ↫ ['..dp.first_name_..'](t.me/'..(dp.username_ or 'HH_418')..')\n✫︙تم تنزيله من قائمة المنظفين')
end,nil)
elseif DataText and DataText:match(tonumber(data.sender_user_id_)..':RemAdmin:(.*)') then
local AekId = DataText:match(tonumber(data.sender_user_id_)..':RemAdmin:(.*)')
tdcli_function ({ID = "GetUser",user_id_ = AekId},function(arg,dp) 
DevAek:srem(AEK..'Aek:Admins:'..data.chat_id_,dp.id_)
EditMsg(Chat_Id2, Msg_Id2,'✫︙العضو ↫ ['..dp.first_name_..'](t.me/'..(dp.username_ or 'HH_418')..')\n✫︙تم تنزيله من قائمة الادمنيه')
end,nil)
elseif DataText and DataText:match(tonumber(data.sender_user_id_)..':RemManager:(.*)') then
local AekId = DataText:match(tonumber(data.sender_user_id_)..':RemManager:(.*)')
tdcli_function ({ID = "GetUser",user_id_ = AekId},function(arg,dp) 
DevAek:srem(AEK..'Aek:Managers:'..data.chat_id_,dp.id_)
EditMsg(Chat_Id2, Msg_Id2,'✫︙العضو ↫ ['..dp.first_name_..'](t.me/'..(dp.username_ or 'HH_418')..')\n✫︙تم تنزيله من قائمة المدراء')
end,nil)
elseif DataText and DataText:match(tonumber(data.sender_user_id_)..':RemConstructor:(.*)') then
local AekId = DataText:match(tonumber(data.sender_user_id_)..':RemConstructor:(.*)')
tdcli_function ({ID = "GetUser",user_id_ = AekId},function(arg,dp) 
DevAek:srem(AEK..'Aek:Constructor:'..data.chat_id_,dp.id_)
EditMsg(Chat_Id2, Msg_Id2,'✫︙العضو ↫ ['..dp.first_name_..'](t.me/'..(dp.username_ or 'HH_418')..')\n✫︙تم تنزيله من قائمة المنشئين')
end,nil)
elseif DataText and DataText:match(tonumber(data.sender_user_id_)..':RemBasicConstructor:(.*)') then
local AekId = DataText:match(tonumber(data.sender_user_id_)..':RemBasicConstructor:(.*)')
tdcli_function ({ID = "GetUser",user_id_ = AekId},function(arg,dp) 
DevAek:srem(AEK..'Aek:BasicConstructor:'..data.chat_id_,dp.id_)
EditMsg(Chat_Id2, Msg_Id2,'✫︙العضو ↫ ['..dp.first_name_..'](t.me/'..(dp.username_ or 'HH_418')..')\n✫︙تم تنزيله من قائمة المنشئين الاساسيين')
end,nil)
elseif DataText and DataText:match(tonumber(data.sender_user_id_)..':RemAekConstructor:(.*)') then
local AekId = DataText:match(tonumber(data.sender_user_id_)..':RemAekConstructor:(.*)')
tdcli_function ({ID = "GetUser",user_id_ = AekId},function(arg,dp) 
DevAek:srem(AEK..'Aek:AekConstructor:'..data.chat_id_,dp.id_)
EditMsg(Chat_Id2, Msg_Id2,'✫︙العضو ↫ ['..dp.first_name_..'](t.me/'..(dp.username_ or 'HH_418')..')\n✫︙تم تنزيله من قائمة المالكين الاساسيين')
end,nil)
elseif DataText and DataText:match(tonumber(data.sender_user_id_)..':RemSudoBot:(.*)') then
local AekId = DataText:match(tonumber(data.sender_user_id_)..':RemSudoBot:(.*)')
tdcli_function ({ID = "GetUser",user_id_ = AekId},function(arg,dp) 
DevAek:srem(AEK..'Aek:SudoBot:'..data.chat_id_,dp.id_)
EditMsg(Chat_Id2, Msg_Id2,'✫︙العضو ↫ ['..dp.first_name_..'](t.me/'..(dp.username_ or 'HH_418')..')\n✫︙تم تنزيله من قائمة المطورين')
end,nil)
elseif DataText and DataText:match(tonumber(data.sender_user_id_)..':RemSecondSudo:(.*)') then
local AekId = DataText:match(tonumber(data.sender_user_id_)..':RemSecondSudo:(.*)')
tdcli_function ({ID = "GetUser",user_id_ = AekId},function(arg,dp) 
DevAek:srem(AEK..'Aek:SecondSudo:'..data.chat_id_,dp.id_)
EditMsg(Chat_Id2, Msg_Id2,'✫︙العضو ↫ ['..dp.first_name_..'](t.me/'..(dp.username_ or 'HH_418')..')\n✫︙تم تنزيله من قائمة المطورين الثانويين')
end,nil)
end

if DataText and DataText:match(tonumber(data.sender_user_id_)..':Ban:(.*)') then
local AekId = DataText:match(tonumber(data.sender_user_id_)..':Ban:(.*)')
tdcli_function ({ID = "GetUser",user_id_ = AekId},function(arg,dp) 
if dp.id_ then
if RankChecking(dp.id_, data.chat_id_) then
EditMsg(Chat_Id2, Msg_Id2, '✫︙لا تستطيع حظر ↫ '..IdRank(dp.id_, data.chat_id_), 1, 'md')
else
ChatKick(data.chat_id_, dp.id_)
DevAek:sadd(AEK..'Aek:Ban:'..data.chat_id_, dp.id_)
EditMsg(Chat_Id2, Msg_Id2,'✫︙العضو ↫ ['..dp.first_name_..'](t.me/'..(dp.username_ or 'HH_418')..')\n✫︙تم حظره')
end
end
end,nil)
end
if DataText and DataText:match(tonumber(data.sender_user_id_)..':UnBan:(.*)') then
local AekId = DataText:match(tonumber(data.sender_user_id_)..':UnBan:(.*)')
tdcli_function ({ID = "GetUser",user_id_ = AekId},function(arg,dp) 
DevAek:srem(AEK..'Aek:Ban:'..data.chat_id_,dp.id_)
tdcli_function ({ ID = "ChangeChatMemberStatus", chat_id_ = data.chat_id_, user_id_ = dp.id_, status_ = { ID = "ChatMemberStatusLeft" },},function(arg,ban) end,nil)   
EditMsg(Chat_Id2, Msg_Id2,'✫︙العضو ↫ ['..dp.first_name_..'](t.me/'..(dp.username_ or 'HH_418')..')\n✫︙تم الغاء حظره')
end,nil)
end
if DataText and DataText:match(tonumber(data.sender_user_id_)..':Mute:(.*)') then
local AekId = DataText:match(tonumber(data.sender_user_id_)..':Mute:(.*)')
tdcli_function ({ID = "GetUser",user_id_ = AekId},function(arg,dp) 
if dp.id_ then
if RankChecking(dp.id_, data.chat_id_) then
EditMsg(Chat_Id2, Msg_Id2, '✫︙لا تستطيع كتم ↫ '..IdRank(dp.id_, data.chat_id_), 1, 'md')
else
if DevAek:sismember(AEK..'Aek:Muted:'..data.chat_id_, dp.id_) then
EditMsg(Chat_Id2, Msg_Id2, "✫︙هو بالفعل مكتوم من المجموعه")  
else
DevAek:sadd(AEK..'Aek:Muted:'..data.chat_id_, dp.id_)
EditMsg(Chat_Id2, Msg_Id2,'✫︙العضو ↫ ['..dp.first_name_..'](t.me/'..(dp.username_ or 'HH_418')..')\n✫︙تم كتمه')
end
end
end
end,nil)
end
if DataText and DataText:match(tonumber(data.sender_user_id_)..':UnMute:(.*)') then
local AekId = DataText:match(tonumber(data.sender_user_id_)..':UnMute:(.*)')
tdcli_function ({ID = "GetUser",user_id_ = AekId},function(arg,dp) 
DevAek:srem(AEK..'Aek:Muted:'..data.chat_id_, dp.id_)
EditMsg(Chat_Id2, Msg_Id2,'✫︙العضو ↫ ['..dp.first_name_..'](t.me/'..(dp.username_ or 'HH_418')..')\n✫︙تم الغاء كتمه')
end,nil)
end
if DataText and DataText:match(tonumber(data.sender_user_id_)..':UnAll:(.*)') then
local AekId = DataText:match(tonumber(data.sender_user_id_)..':UnAll:(.*)')
tdcli_function ({ID = "GetUser",user_id_ = AekId},function(arg,dp) 
DevAek:srem(AEK..'Aek:BanAll:', dp.id_)
DevAek:srem(AEK..'Aek:MuteAll:', dp.id_)
EditMsg(Chat_Id2, Msg_Id2,'✫︙العضو ↫ ['..dp.first_name_..'](t.me/'..(dp.username_ or 'HH_418')..')\n✫︙تم الغاء العام')
end,nil)
end
if DataText and DataText:match(tonumber(data.sender_user_id_)..':Tkeed:(.*)') then
local AekId = DataText:match(tonumber(data.sender_user_id_)..':Tkeed:(.*)')
tdcli_function ({ID = "GetUser",user_id_ = AekId},function(arg,dp) 
if dp.id_ then
if RankChecking(dp.id_, data.chat_id_) then
EditMsg(Chat_Id2, Msg_Id2, '✫︙لا تستطيع تقيد ↫ '..IdRank(dp.id_, data.chat_id_), 1, 'md')
else
HTTPS.request("https://api.telegram.org/bot"..TokenBot.."/restrictChatMember?chat_id="..data.chat_id_.."&user_id="..dp.id_)
DevAek:sadd(AEK..'Aek:Tkeed:'..data.chat_id_, dp.id_)
EditMsg(Chat_Id2, Msg_Id2,'✫︙العضو ↫ ['..dp.first_name_..'](t.me/'..(dp.username_ or 'HH_418')..')\n✫︙تم تقيده من المجموعه')
end
end
end,nil)
end
if DataText and DataText:match(tonumber(data.sender_user_id_)..':UnTkeed:(.*)') then
local AekId = DataText:match(tonumber(data.sender_user_id_)..':UnTkeed:(.*)')
tdcli_function ({ID = "GetUser",user_id_ = AekId},function(arg,dp) 
HTTPS.request("https://api.telegram.org/bot"..TokenBot.."/restrictChatMember?chat_id="..data.chat_id_.."&user_id="..dp.id_.."&can_send_messages=True&can_send_media_messages=True&can_send_other_messages=True&can_add_web_page_previews=True")
DevAek:srem(AEK..'Aek:Tkeed:'..data.chat_id_, dp.id_)
EditMsg(Chat_Id2, Msg_Id2,'✫︙العضو ↫ ['..dp.first_name_..'](t.me/'..(dp.username_ or 'HH_418')..')\n✫︙تم الغاء تقيده')
end,nil)
end

if DataText and DataText:match('/locklist:(.*)') then
local Aek = DataText:match('/locklist:(.*)')
if tonumber(Aek) == tonumber(data.sender_user_id_) then
local locklist = DevAek:get(AEK..'Aek:locklist')
local Text = [[
✫︙اهلا بك في قائمة القفل والفتح ↫ ⤈ 
━───━ ✫ ━───━
*✫︙يمكنك فتح و قفل الاوامر من خلال الازرار اسفل*
━───━ ✫ ━───━
✫︙[‹  𝖲𝗈𝗎𝗋𝖼𝖾 𝙄𝘽𝙊 ›](https://t.me/HH_418)
]] 
keyboard = {} 
keyboard.inline_keyboard = {{{text="قفل الدردشه",callback_data="/lockText:"..data.sender_user_id_},{text="فتح الدردشه",callback_data="/unlockText:"..data.sender_user_id_}},{{text="قفل الدخول",callback_data="/lockjoin:"..data.sender_user_id_},{text="فتح الدخول",callback_data="/unlockjoin:"..data.sender_user_id_}},{{text="قفل البوتات",callback_data="/LockBotList:"..data.sender_user_id_},{text="فتح البوتات",callback_data="/unlockBot:"..data.sender_user_id_}},{{text="قفل الاشعارات",callback_data="/lockTagServr:"..data.sender_user_id_},{text="فتح الاشعارات",callback_data="/unlockTagServr:"..data.sender_user_id_}},{{text="قفل التعديل",callback_data="/lockEditMsgs:"..data.sender_user_id_},{text="فتح التعديل",callback_data="/unlockEditMsgs:"..data.sender_user_id_}},{{text="قفل الملصقات",callback_data="/lockStickers:"..data.sender_user_id_},{text="فتح الملصقات",callback_data="/unlockStickers:"..data.sender_user_id_}},{{text="قفل المتحركه",callback_data="/lockGifs:"..data.sender_user_id_},{text="فتح المتحركه",callback_data="/unlockGifs:"..data.sender_user_id_}},{{text="قفل الفيديو",callback_data="/lockVideos:"..data.sender_user_id_},{text="فتح الفيديو",callback_data="/unlockVideos:"..data.sender_user_id_}},{{text="قفل الصور",callback_data="/unlockPhoto:"..data.sender_user_id_},{text="فتح الصور",callback_data="/unlockPhoto:"..data.sender_user_id_}},{{text="قفل التوجيه",callback_data="/lockForwards:"..data.sender_user_id_},{text="فتح التوجيه",callback_data="/unlockForwards:"..data.sender_user_id_}},{{text="قفل التكرار",callback_data="/LockSpamList:"..data.sender_user_id_},{text="فتح التكرار",callback_data="/unlockSpam:"..data.sender_user_id_}},{{text="• اخفاء الكليشه •",callback_data="/HideHelpList:"..data.sender_user_id_},{text="• القائمه الرئيسيه •",callback_data="/HelpList:"..data.sender_user_id_}}}
https.request("https://api.telegram.org/bot"..TokenBot..'/editMessageText?chat_id='..Chat_Id2..'&message_id='..Msg_Id2..'&text=' .. URL.escape(Text).."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end end

if DataText and DataText:match('/LockBotList:(.*)') then
local Aek = DataText:match('/LockBotList:(.*)')
if tonumber(Aek) == tonumber(data.sender_user_id_) then
local LockBotList = DevAek:get(AEK..'Aek:LockBotList')
local Text = [[
✫︙اهلا بك في قائمة قفل البوتات  ↫ ⤈ 
━───━ ✫ ━───━
*✫︙بالطرد*
*✫︙بالكتم*
*✫︙بالتقيد*
━───━ ✫ ━───━
✫︙[‹  𝖲𝗈𝗎𝗋𝖼𝖾 𝙄𝘽𝙊 ›](https://t.me/HH_418)
]] 
keyboard = {} 
keyboard.inline_keyboard = {{{text="قفل البوتات بالطرد",callback_data="/lockBotKick:"..data.sender_user_id_},{text="قفل البوتات بالتقيد",callback_data="/lockBotKed:"..data.sender_user_id_}},{{text="قفل البوتات بالكتم",callback_data="/lockBotDel:"..data.sender_user_id_}},{{text="• اخفاء الكليشه •",callback_data="/HideHelpList:"..data.sender_user_id_},{text="• رجوع •",callback_data="/locklist:"..data.sender_user_id_}}}
https.request("https://api.telegram.org/bot"..TokenBot..'/editMessageText?chat_id='..Chat_Id2..'&message_id='..Msg_Id2..'&text=' .. URL.escape(Text).."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end
end

if DataText and DataText:match('/LockSpamList:(.*)') then
local Aek = DataText:match('/LockSpamList:(.*)')
if tonumber(Aek) == tonumber(data.sender_user_id_) then
local LockSpamList = DevAek:get(AEK..'Aek:LockSpamList')
local Text = [[
✫︙اهلا بك في قائمة قفل التكرار  ↫ ⤈ 
━───━ ✫ ━───━
*✫︙بالطرد*
*✫︙بالكتم*
*✫︙بالتقيد*
*✫︙بالحذف*
━───━ ✫ ━───━
✫︙[‹  𝖲𝗈𝗎𝗋𝖼𝖾 𝙄𝘽𝙊 ›](https://t.me/HH_418)
]] 
keyboard = {} 
keyboard.inline_keyboard = {{{text="قفل التكرار بالطرد",callback_data="/lockSpamKick:"..data.sender_user_id_},{text="قفل التكرار بالتقيد",callback_data="/lockSpamKed:"..data.sender_user_id_}},{{text="قفل التكرار بالحذف",callback_data="/lockSpamDel:"..data.sender_user_id_},{text="قفل التكرار بالكتم",callback_data="/lockSpamMute:"..data.sender_user_id_}},{{text="• اخفاء الكليشه •",callback_data="/HideHelpList:"..data.sender_user_id_},{text="• رجوع •",callback_data="/locklist:"..data.sender_user_id_}}}
https.request("https://api.telegram.org/bot"..TokenBot..'/editMessageText?chat_id='..Chat_Id2..'&message_id='..Msg_Id2..'&text=' .. URL.escape(Text).."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end
end

if DataText == '/lockjoin:'..data.sender_user_id_ then
if not DevAek:get(AEK..'Aek:Lock:Join'..data.chat_id_) then
DevAek:set(AEK..'Aek:Lock:Join'..data.chat_id_,true)
Text = "*✫︙تم قفل الدخول بنجاح*"
keyboard = {} 
keyboard.inline_keyboard = {{{text="• اخفاء الكليشه •",callback_data="/HideHelpList:"..data.sender_user_id_},{text="• رجوع •",callback_data="/locklist:"..data.sender_user_id_}}}
return https.request("https://api.telegram.org/bot"..TokenBot..'/editMessageText?chat_id='..Chat_Id2..'&message_id='..Msg_Id2..'&text=' .. URL.escape(Text).."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end 
end
if DataText == '/unlockjoin:'..data.sender_user_id_ then
if DevAek:get(AEK..'Aek:Lock:Join'..data.chat_id_) then
DevAek:del(AEK..'Aek:Lock:Join'..data.chat_id_)
Text = "*✫︙تم فتح الدخول بنجاح*"
keyboard = {} 
keyboard.inline_keyboard = {{{text="• اخفاء الكليشه •",callback_data="/HideHelpList:"..data.sender_user_id_},{text="• رجوع •",callback_data="/locklist:"..data.sender_user_id_}}}
return https.request("https://api.telegram.org/bot"..TokenBot..'/editMessageText?chat_id='..Chat_Id2..'&message_id='..Msg_Id2..'&text=' .. URL.escape(Text).."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end end
if DataText == '/lockText:'..data.sender_user_id_ then
if not DevAek:get(AEK..'Aek:Lock:Text'..data.chat_id_) then
DevAek:set(AEK..'Aek:Lock:Text'..data.chat_id_,true)
Text = "*✫︙تم قفل الدردشه بنجاح*"
keyboard = {} 
keyboard.inline_keyboard = {{{text="• اخفاء الكليشه •",callback_data="/HideHelpList:"..data.sender_user_id_},{text="• رجوع •",callback_data="/locklist:"..data.sender_user_id_}}}
return https.request("https://api.telegram.org/bot"..TokenBot..'/editMessageText?chat_id='..Chat_Id2..'&message_id='..Msg_Id2..'&text=' .. URL.escape(Text).."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end 
end
if DataText == '/unlockText:'..data.sender_user_id_ then
if DevAek:get(AEK..'Aek:Lock:Text'..data.chat_id_) then
DevAek:del(AEK..'Aek:Lock:Text'..data.chat_id_)
Text = "*✫︙تم فتح الدردشه بنجاح*"
keyboard = {} 
keyboard.inline_keyboard = {{{text="• اخفاء الكليشه •",callback_data="/HideHelpList:"..data.sender_user_id_},{text="• رجوع •",callback_data="/locklist:"..data.sender_user_id_}}}
return https.request("https://api.telegram.org/bot"..TokenBot..'/editMessageText?chat_id='..Chat_Id2..'&message_id='..Msg_Id2..'&text=' .. URL.escape(Text).."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end end
if DataText == '/lockTagServr:'..data.sender_user_id_ then
if not DevAek:get(AEK..'Aek:Lock:TagServr'..data.chat_id_) then
DevAek:set(AEK..'Aek:Lock:TagServr'..data.chat_id_,true)
Text = "*✫︙تم قفل الاشعارات بنجاح*"
keyboard = {} 
keyboard.inline_keyboard = {{{text="• اخفاء الكليشه •",callback_data="/HideHelpList:"..data.sender_user_id_},{text="• رجوع •",callback_data="/locklist:"..data.sender_user_id_}}}
return https.request("https://api.telegram.org/bot"..TokenBot..'/editMessageText?chat_id='..Chat_Id2..'&message_id='..Msg_Id2..'&text=' .. URL.escape(Text).."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end 
end
if DataText == '/unlockTagServr:'..data.sender_user_id_ then
if DevAek:get(AEK..'Aek:Lock:TagServr'..data.chat_id_) then
DevAek:del(AEK..'Aek:Lock:TagServr'..data.chat_id_) 
Text = "*✫︙تم فتح الاشعارات بنجاح*"
keyboard = {} 
keyboard.inline_keyboard = {{{text="• اخفاء الكليشه •",callback_data="/HideHelpList:"..data.sender_user_id_},{text="• رجوع •",callback_data="/locklist:"..data.sender_user_id_}}}
return https.request("https://api.telegram.org/bot"..TokenBot..'/editMessageText?chat_id='..Chat_Id2..'&message_id='..Msg_Id2..'&text=' .. URL.escape(Text).."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end end
if DataText == '/lockEditMsgs:'..data.sender_user_id_ then
if not DevAek:get(AEK..'Aek:Lock:EditMsgs'..data.chat_id_) then
DevAek:set(AEK..'Aek:Lock:EditMsgs'..data.chat_id_,true)
Text = "*✫︙تم قفل التعديل بنجاح*"
keyboard = {} 
keyboard.inline_keyboard = {{{text="• اخفاء الكليشه •",callback_data="/HideHelpList:"..data.sender_user_id_},{text="• رجوع •",callback_data="/locklist:"..data.sender_user_id_}}}
return https.request("https://api.telegram.org/bot"..TokenBot..'/editMessageText?chat_id='..Chat_Id2..'&message_id='..Msg_Id2..'&text=' .. URL.escape(Text).."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end 
end
if DataText == '/unlockEditMsgs:'..data.sender_user_id_ then
if DevAek:get(AEK..'Aek:Lock:EditMsgs'..data.chat_id_) then
DevAek:del(AEK..'Aek:Lock:EditMsgs'..data.chat_id_)
Text = "*✫︙تم فتح التعديل بنجاح*"
keyboard = {} 
keyboard.inline_keyboard = {{{text="• اخفاء الكليشه •",callback_data="/HideHelpList:"..data.sender_user_id_},{text="• رجوع •",callback_data="/locklist:"..data.sender_user_id_}}}
return https.request("https://api.telegram.org/bot"..TokenBot..'/editMessageText?chat_id='..Chat_Id2..'&message_id='..Msg_Id2..'&text=' .. URL.escape(Text).."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end end
if DataText == '/lockStickers:'..data.sender_user_id_ then
if not DevAek:get(AEK..'Aek:Lock:Stickers'..data.chat_id_) then
DevAek:set(AEK..'Aek:Lock:Stickers'..data.chat_id_,true)
Text = "*✫︙تم قفل الملصقات بنجاح*"
keyboard = {} 
keyboard.inline_keyboard = {{{text="• اخفاء الكليشه •",callback_data="/HideHelpList:"..data.sender_user_id_},{text="• رجوع •",callback_data="/locklist:"..data.sender_user_id_}}}
return https.request("https://api.telegram.org/bot"..TokenBot..'/editMessageText?chat_id='..Chat_Id2..'&message_id='..Msg_Id2..'&text=' .. URL.escape(Text).."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end 
end
if DataText == '/unlockStickers:'..data.sender_user_id_ then
if DevAek:get(AEK..'Aek:Lock:Stickers'..data.chat_id_) then
DevAek:del(AEK..'Aek:Lock:Stickers'..data.chat_id_)
Text = "*✫︙تم فتح الملصقات بنجاح*"
keyboard = {} 
keyboard.inline_keyboard = {{{text="• اخفاء الكليشه •",callback_data="/HideHelpList:"..data.sender_user_id_},{text="• رجوع •",callback_data="/locklist:"..data.sender_user_id_}}}
return https.request("https://api.telegram.org/bot"..TokenBot..'/editMessageText?chat_id='..Chat_Id2..'&message_id='..Msg_Id2..'&text=' .. URL.escape(Text).."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end end
if DataText == '/lockGifs:'..data.sender_user_id_ then
if not DevAek:get(AEK..'Aek:Lock:Gifs'..data.chat_id_) then
DevAek:set(AEK..'Aek:Lock:Gifs'..data.chat_id_,true)
Text = "*✫︙تم قفل المتحركه بنجاح*"
keyboard = {} 
keyboard.inline_keyboard = {{{text="• اخفاء الكليشه •",callback_data="/HideHelpList:"..data.sender_user_id_},{text="• رجوع •",callback_data="/locklist:"..data.sender_user_id_}}}
return https.request("https://api.telegram.org/bot"..TokenBot..'/editMessageText?chat_id='..Chat_Id2..'&message_id='..Msg_Id2..'&text=' .. URL.escape(Text).."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end 
end
if DataText == '/unlockGifs:'..data.sender_user_id_ then
if DevAek:get(AEK..'Aek:Lock:Gifs'..data.chat_id_) then
DevAek:del(AEK..'Aek:Lock:Gifs'..data.chat_id_)
Text = "*✫︙تم فتح المتحركه بنجاح*"
keyboard = {} 
keyboard.inline_keyboard = {{{text="• اخفاء الكليشه •",callback_data="/HideHelpList:"..data.sender_user_id_},{text="• رجوع •",callback_data="/locklist:"..data.sender_user_id_}}}
return https.request("https://api.telegram.org/bot"..TokenBot..'/editMessageText?chat_id='..Chat_Id2..'&message_id='..Msg_Id2..'&text=' .. URL.escape(Text).."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end end
if DataText == '/lockPhoto:'..data.sender_user_id_ then
if not DevAek:get(AEK..'Aek:Lock:Photo'..data.chat_id_) then
DevAek:set(AEK..'Aek:Lock:Photo'..data.chat_id_,true) 
Text = "*✫︙تم قفل الصور بنجاح*"
keyboard = {} 
keyboard.inline_keyboard = {{{text="• اخفاء الكليشه •",callback_data="/HideHelpList:"..data.sender_user_id_},{text="• رجوع •",callback_data="/locklist:"..data.sender_user_id_}}}
return https.request("https://api.telegram.org/bot"..TokenBot..'/editMessageText?chat_id='..Chat_Id2..'&message_id='..Msg_Id2..'&text=' .. URL.escape(Text).."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end 
end
if DataText == '/unlockPhoto:'..data.sender_user_id_ then
if DevAek:get(AEK..'Aek:Lock:Photo'..data.chat_id_) then
DevAek:del(AEK..'Aek:Lock:Photo'..data.chat_id_)
Text = "*✫︙تم فتح الصور بنجاح*"
keyboard = {} 
keyboard.inline_keyboard = {{{text="• اخفاء الكليشه •",callback_data="/HideHelpList:"..data.sender_user_id_},{text="• رجوع •",callback_data="/locklist:"..data.sender_user_id_}}}
return https.request("https://api.telegram.org/bot"..TokenBot..'/editMessageText?chat_id='..Chat_Id2..'&message_id='..Msg_Id2..'&text=' .. URL.escape(Text).."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end end
if DataText == '/lockVideos:'..data.sender_user_id_ then
if not DevAek:get(AEK..'Aek:Lock:Videos'..data.chat_id_) then
DevAek:set(AEK..'Aek:Lock:Videos'..data.chat_id_,true)
Text = "*✫︙تم قفل الفيديو بنجاح*"
keyboard = {} 
keyboard.inline_keyboard = {{{text="• اخفاء الكليشه •",callback_data="/HideHelpList:"..data.sender_user_id_},{text="• رجوع •",callback_data="/locklist:"..data.sender_user_id_}}}
return https.request("https://api.telegram.org/bot"..TokenBot..'/editMessageText?chat_id='..Chat_Id2..'&message_id='..Msg_Id2..'&text=' .. URL.escape(Text).."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end 
end
if DataText == '/unlockVideos:'..data.sender_user_id_ then
if DevAek:get(AEK..'Aek:Lock:Videos'..data.chat_id_) then
DevAek:del(AEK..'Aek:Lock:Videos'..data.chat_id_)
Text = "*✫︙تم فتح الفيديو بنجاح*"
keyboard = {} 
keyboard.inline_keyboard = {{{text="• اخفاء الكليشه •",callback_data="/HideHelpList:"..data.sender_user_id_},{text="• رجوع •",callback_data="/locklist:"..data.sender_user_id_}}}
return https.request("https://api.telegram.org/bot"..TokenBot..'/editMessageText?chat_id='..Chat_Id2..'&message_id='..Msg_Id2..'&text=' .. URL.escape(Text).."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end end
if DataText == '/lockForwards:'..data.sender_user_id_ then
if not DevAek:get(AEK..'Aek:Lock:Forwards'..data.chat_id_) then
DevAek:set(AEK..'Aek:Lock:Forwards'..data.chat_id_,true)
Text = "*✫︙تم قفل التوجيه بنجاح*"
keyboard = {} 
keyboard.inline_keyboard = {{{text="• اخفاء الكليشه •",callback_data="/HideHelpList:"..data.sender_user_id_},{text="• رجوع •",callback_data="/locklist:"..data.sender_user_id_}}}
return https.request("https://api.telegram.org/bot"..TokenBot..'/editMessageText?chat_id='..Chat_Id2..'&message_id='..Msg_Id2..'&text=' .. URL.escape(Text).."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end 
end
if DataText == '/unlockForwards:'..data.sender_user_id_ then
if DevAek:get(AEK..'Aek:Lock:Forwards'..data.chat_id_) then
DevAek:del(AEK..'Aek:Lock:Forwards'..data.chat_id_) 
Text = "*✫︙تم فتح التوجيه بنجاح*"
keyboard = {} 
keyboard.inline_keyboard = {{{text="• اخفاء الكليشه •",callback_data="/HideHelpList:"..data.sender_user_id_},{text="• رجوع •",callback_data="/locklist:"..data.sender_user_id_}}}
return https.request("https://api.telegram.org/bot"..TokenBot..'/editMessageText?chat_id='..Chat_Id2..'&message_id='..Msg_Id2..'&text=' .. URL.escape(Text).."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end end
if DataText == '/lockBotKick:'..data.sender_user_id_ then
DevAek:set(AEK.."Aek:Lock:Bots"..data.chat_id_,"kick")  
Text = "*✫︙تم قفل البوتات بالطرد بنجاح*"
keyboard = {} 
keyboard.inline_keyboard = {{{text="• اخفاء الكليشه •",callback_data="/HideHelpList:"..data.sender_user_id_},{text="• رجوع •",callback_data="/LockBotList:"..data.sender_user_id_}}}
return https.request("https://api.telegram.org/bot"..TokenBot..'/editMessageText?chat_id='..Chat_Id2..'&message_id='..Msg_Id2..'&text=' .. URL.escape(Text).."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end
if DataText == '/lockBotKed:'..data.sender_user_id_ then
DevAek:set(AEK.."Aek:Lock:Bots"..data.chat_id_,"ked")   
Text = "*✫︙تم قفل البوتات بالتقييد بنجاح*"
keyboard = {} 
keyboard.inline_keyboard = {{{text="• اخفاء الكليشه •",callback_data="/HideHelpList:"..data.sender_user_id_},{text="• رجوع •",callback_data="/LockBotList:"..data.sender_user_id_}}}
return https.request("https://api.telegram.org/bot"..TokenBot..'/editMessageText?chat_id='..Chat_Id2..'&message_id='..Msg_Id2..'&text=' .. URL.escape(Text).."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end
if DataText == '/lockBotDel:'..data.sender_user_id_ then
DevAek:set(AEK.."Aek:Lock:Bots"..data.chat_id_,"del")  
Text = "*✫︙تم قفل البوتات بالكتم بنجاح*"
keyboard = {} 
keyboard.inline_keyboard = {{{text="• اخفاء الكليشه •",callback_data="/HideHelpList:"..data.sender_user_id_},{text="• رجوع •",callback_data="/LockBotList:"..data.sender_user_id_}}}
return https.request("https://api.telegram.org/bot"..TokenBot..'/editMessageText?chat_id='..Chat_Id2..'&message_id='..Msg_Id2..'&text=' .. URL.escape(Text).."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end 
if DataText == '/unlockBot:'..data.sender_user_id_ then
DevAek:del(AEK.."Aek:Lock:Bots"..data.chat_id_) 
Text = "*✫︙تم فتح البوتات بنجاح*"
keyboard = {} 
keyboard.inline_keyboard = {{{text="• اخفاء الكليشه •",callback_data="/HideHelpList:"..data.sender_user_id_},{text="• رجوع •",callback_data="/locklist:"..data.sender_user_id_}}}
return https.request("https://api.telegram.org/bot"..TokenBot..'/editMessageText?chat_id='..Chat_Id2..'&message_id='..Msg_Id2..'&text=' .. URL.escape(Text).."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end
if DataText == '/lockSpamKick:'..data.sender_user_id_ then
DevAek:hset(AEK.."Aek:Spam:Group:User"..data.chat_id_ ,"Spam:User","kick")  
Text = "*✫︙تم قفل التكرار بالطرد بنجاح*"
keyboard = {} 
keyboard.inline_keyboard = {{{text="• اخفاء الكليشه •",callback_data="/HideHelpList:"..data.sender_user_id_},{text="• رجوع •",callback_data="/LockSpamList:"..data.sender_user_id_}}}
return https.request("https://api.telegram.org/bot"..TokenBot..'/editMessageText?chat_id='..Chat_Id2..'&message_id='..Msg_Id2..'&text=' .. URL.escape(Text).."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end
if DataText == '/lockSpamKed:'..data.sender_user_id_ then
DevAek:hset(AEK.."Aek:Spam:Group:User"..data.chat_id_ ,"Spam:User","keed")  
Text = "*✫︙تم قفل التكرار بالتقيد بنجاح*"
keyboard = {} 
keyboard.inline_keyboard = {{{text="• اخفاء الكليشه •",callback_data="/HideHelpList:"..data.sender_user_id_},{text="• رجوع •",callback_data="/LockSpamList:"..data.sender_user_id_}}}
return https.request("https://api.telegram.org/bot"..TokenBot..'/editMessageText?chat_id='..Chat_Id2..'&message_id='..Msg_Id2..'&text=' .. URL.escape(Text).."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end
if DataText == '/lockSpamDel:'..data.sender_user_id_ then
DevAek:hset(AEK.."Aek:Spam:Group:User"..data.chat_id_ ,"Spam:User","del")  
Text = "*✫︙تم قفل التكرار بالحذف بنجاح*"
keyboard = {} 
keyboard.inline_keyboard = {{{text="• اخفاء الكليشه •",callback_data="/HideHelpList:"..data.sender_user_id_},{text="• رجوع •",callback_data="/LockSpamList:"..data.sender_user_id_}}}
return https.request("https://api.telegram.org/bot"..TokenBot..'/editMessageText?chat_id='..Chat_Id2..'&message_id='..Msg_Id2..'&text=' .. URL.escape(Text).."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end 
if DataText == '/lockSpamMute:'..data.sender_user_id_ then
DevAek:hset(AEK.."Aek:Spam:Group:User"..data.chat_id_ ,"Spam:User","mute")  
Text = "*✫︙تم قفل التكرار بالكتم بنجاح*"
keyboard = {} 
keyboard.inline_keyboard = {{{text="• اخفاء الكليشه •",callback_data="/HideHelpList:"..data.sender_user_id_},{text="• رجوع •",callback_data="/LockSpamList:"..data.sender_user_id_}}}
return https.request("https://api.telegram.org/bot"..TokenBot..'/editMessageText?chat_id='..Chat_Id2..'&message_id='..Msg_Id2..'&text=' .. URL.escape(Text).."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end 
if DataText == '/unlockSpam:'..data.sender_user_id_ then
DevAek:hdel(AEK.."Aek:Spam:Group:User"..data.chat_id_ ,"Spam:User")  
Text = "*✫︙تم فتح التكرار بنجاح*"
keyboard = {} 
keyboard.inline_keyboard = {{{text="• اخفاء الكليشه •",callback_data="/HideHelpList:"..data.sender_user_id_},{text="• رجوع •",callback_data="/locklist:"..data.sender_user_id_}}}
return https.request("https://api.telegram.org/bot"..TokenBot..'/editMessageText?chat_id='..Chat_Id2..'&message_id='..Msg_Id2..'&text=' .. URL.escape(Text).."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end
if DataText and DataText:match('/lockorder:(.*)') then
local Aek = DataText:match('/lockorder:(.*)')
if tonumber(Aek) == tonumber(data.sender_user_id_) then
local order = DevAek:get(AEK..'Aek:order')
local Text = [[
✫︙اهلا بك في قائمة اوامر التعطيل والتفعيل ↫ ⤈ 
━───━ ✫ ━───━
✫︙يمكنك التعطيل والتفعيل عن طريق الازرار بالأسفل
━───━ ✫ ━───━
✫︙[‹  𝖲𝗈𝗎𝗋𝖼𝖾 𝙄𝘽𝙊 ›](https://t.me/HH_418)
]] 
keyboard = {} 
keyboard.inline_keyboard = {{{text="تعطيل الايدي بالصوره",callback_data="/LockIdPhoto:"..data.sender_user_id_},{text="تفعيل الايدي بالصوره",callback_data="/UnLockIdPhoto:"..data.sender_user_id_}},{{text="تعطيل الايدي",callback_data="/LockId:"..data.sender_user_id_},{text="تفعيل الايدي",callback_data="/UnLockId:"..data.sender_user_id_}},{{text="تعطيل الرابط",callback_data="/LockGpLinks:"..data.sender_user_id_},{text="تفعيل الرابط",callback_data="/UnLockGpLinks:"..data.sender_user_id_}},{{text="تعطيل الرابط انلاين",callback_data="/LockGpLinksinline:"..data.sender_user_id_},{text="تفعيل الرابط انلاين",callback_data="/UnLockGpLinksinline:"..data.sender_user_id_}},{{text="تعطيل الترحيب",callback_data="/LockWelcome:"..data.sender_user_id_},{text="تفعيل الترحيب",callback_data="/UnLockWelcome:"..data.sender_user_id_}},{{text="تعطيل الردود المطور",callback_data="/LockAllRed:"..data.sender_user_id_},{text="تفعيل الردود المطور",callback_data="/UnLockAllRed:"..data.sender_user_id_}},{{text="تعطيل ردود المدير",callback_data="/LockGpRed:"..data.sender_user_id_},{text="تفعيل ردود المدير",callback_data="/UnLockGpRed:"..data.sender_user_id_}},{{text="تعطيل نزلني",callback_data="/LockDelMe:"..data.sender_user_id_},{text="تفعيل نزلني",callback_data="/UnLockDelMe:"..data.sender_user_id_}},{{text="تعطيل اطردني",callback_data="/LockKickMe:"..data.sender_user_id_},{text="تفعيل اطردني",callback_data="/UnLockKickMe:"..data.sender_user_id_}},{{text="تعطيل الحظر",callback_data="/LockKickBan:"..data.sender_user_id_},{text="تفعيل الحظر",callback_data="/UnLockKickBan:"..data.sender_user_id_}},{{text="تعطيل الرفع",callback_data="/LockProSet:"..data.sender_user_id_},{text="تفعيل الرفع",callback_data="/UnLockProSet:"..data.sender_user_id_}},{{text="تعطيل الالعاب",callback_data="/LockGames:"..data.sender_user_id_},{text="تفعيل الالعاب",callback_data="/UnLockGames:"..data.sender_user_id_}},{{text="• اخفاء الكليشه •",callback_data="/HideHelpList:"..data.sender_user_id_},{text="• القائمه الرئيسيه •",callback_data="/HelpList:"..data.sender_user_id_}}}
return https.request("https://api.telegram.org/bot"..TokenBot..'/editMessageText?chat_id='..Chat_Id2..'&message_id='..Msg_Id2..'&text=' .. URL.escape(order or Text).."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end end

if DataText and DataText:match('/LockIdPhoto:'..tonumber(data.sender_user_id_)..'(.*)') then
local Aek = DataText:match('/LockIdPhoto:'..tonumber(data.sender_user_id_)..'(.*)')
DevAek:set(AEK..'Aek:Lock:Id:Photo'..data.chat_id_,true)
Text = "*✫︙تم تعطيل الايدي بالصوره*"
keyboard = {} 
keyboard.inline_keyboard = {{{text="• اخفاء الكليشه •",callback_data="/HideHelpList:"..data.sender_user_id_},{text="• رجوع •",callback_data="/lockorder:"..data.sender_user_id_}}}
return https.request("https://api.telegram.org/bot"..TokenBot..'/editMessageText?chat_id='..Chat_Id2..'&message_id='..Msg_Id2..'&text=' .. URL.escape(Text).."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end
if DataText and DataText:match('/unLockIdPhoto:'..tonumber(data.sender_user_id_)..'(.*)') then
local Aek = DataText:match('/unLockIdPhoto:'..tonumber(data.sender_user_id_)..'(.*)')
DevAek:del(AEK..'Aek:Lock:Id:Photo'..data.chat_id_)
Text = "*✫︙تم تفعيل الايدي بالصوره*"
keyboard = {} 
keyboard.inline_keyboard = {{{text="• اخفاء الكليشه •",callback_data="/HideHelpList:"..data.sender_user_id_},{text="• رجوع •",callback_data="/lockorder:"..data.sender_user_id_}}}
return https.request("https://api.telegram.org/bot"..TokenBot..'/editMessageText?chat_id='..Chat_Id2..'&message_id='..Msg_Id2..'&text=' .. URL.escape(Text).."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end
if DataText and DataText:match('/LockId:'..tonumber(data.sender_user_id_)..'(.*)') then
local Aek = DataText:match('/LockId:'..tonumber(data.sender_user_id_)..'(.*)')
DevAek:set(AEK..'Aek:Lock:Id'..data.chat_id_,true)
Text = "*✫︙تم تعطيل الايدي*"
keyboard = {} 
keyboard.inline_keyboard = {{{text="• اخفاء الكليشه •",callback_data="/HideHelpList:"..data.sender_user_id_},{text="• رجوع •",callback_data="/lockorder:"..data.sender_user_id_}}}
return https.request("https://api.telegram.org/bot"..TokenBot..'/editMessageText?chat_id='..Chat_Id2..'&message_id='..Msg_Id2..'&text=' .. URL.escape(Text).."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end
if DataText and DataText:match('/unLockId:'..tonumber(data.sender_user_id_)..'(.*)') then
local Aek = DataText:match('/unLockId:'..tonumber(data.sender_user_id_)..'(.*)')
DevAek:del(AEK..'Aek:Lock:Id'..data.chat_id_)
Text = "*✫︙تم تفعيل الايدي*"
keyboard = {} 
keyboard.inline_keyboard = {{{text="• اخفاء الكليشه •",callback_data="/HideHelpList:"..data.sender_user_id_},{text="• رجوع •",callback_data="/lockorder:"..data.sender_user_id_}}}
return https.request("https://api.telegram.org/bot"..TokenBot..'/editMessageText?chat_id='..Chat_Id2..'&message_id='..Msg_Id2..'&text=' .. URL.escape(Text).."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end
if DataText and DataText:match('/LockGpLinks:'..tonumber(data.sender_user_id_)..'(.*)') then
local Aek = DataText:match('/LockGpLinks:'..tonumber(data.sender_user_id_)..'(.*)')
DevAek:set(AEK.."Aek:Lock:GpLinks"..data.chat_id_,"ok")
Text = "*✫︙تم تعطيل الرابط*"
keyboard = {} 
keyboard.inline_keyboard = {{{text="• اخفاء الكليشه •",callback_data="/HideHelpList:"..data.sender_user_id_},{text="• رجوع •",callback_data="/lockorder:"..data.sender_user_id_}}}
return https.request("https://api.telegram.org/bot"..TokenBot..'/editMessageText?chat_id='..Chat_Id2..'&message_id='..Msg_Id2..'&text=' .. URL.escape(Text).."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end
if DataText and DataText:match('/unLockGpLinks:'..tonumber(data.sender_user_id_)..'(.*)') then
local Aek = DataText:match('/unLockGpLinks:'..tonumber(data.sender_user_id_)..'(.*)')
DevAek:del(AEK.."Aek:Lock:GpLinks"..data.chat_id_)
Text = "*✫︙تم تفعيل الرابط*"
keyboard = {} 
keyboard.inline_keyboard = {{{text="• اخفاء الكليشه •",callback_data="/HideHelpList:"..data.sender_user_id_},{text="• رجوع •",callback_data="/lockorder:"..data.sender_user_id_}}}
return https.request("https://api.telegram.org/bot"..TokenBot..'/editMessageText?chat_id='..Chat_Id2..'&message_id='..Msg_Id2..'&text=' .. URL.escape(Text).."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end
if DataText and DataText:match('/LockGpLinksinline:'..tonumber(data.sender_user_id_)..'(.*)') then
local Aek = DataText:match('/LockGpLinksinline:'..tonumber(data.sender_user_id_)..'(.*)')
DevAek:set(AEK.."Aek:Lock:GpLinksinline"..data.chat_id_,"ok")
Text = "*✫︙تم تعطيل الرابط انلاين*"
keyboard = {} 
keyboard.inline_keyboard = {{{text="• اخفاء الكليشه •",callback_data="/HideHelpList:"..data.sender_user_id_},{text="• رجوع •",callback_data="/lockorder:"..data.sender_user_id_}}}
return https.request("https://api.telegram.org/bot"..TokenBot..'/editMessageText?chat_id='..Chat_Id2..'&message_id='..Msg_Id2..'&text=' .. URL.escape(Text).."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end
if DataText and DataText:match('/UnLockGpLinksinline:'..tonumber(data.sender_user_id_)..'(.*)') then
local Aek = DataText:match('/UnLockGpLinksinline:'..tonumber(data.sender_user_id_)..'(.*)')
DevAek:del(AEK.."Aek:Lock:GpLinksinline"..data.chat_id_)
Text = "*✫︙تم تفعيل الرابط انلاين*"
keyboard = {} 
keyboard.inline_keyboard = {{{text="• اخفاء الكليشه •",callback_data="/HideHelpList:"..data.sender_user_id_},{text="• رجوع •",callback_data="/lockorder:"..data.sender_user_id_}}}
return https.request("https://api.telegram.org/bot"..TokenBot..'/editMessageText?chat_id='..Chat_Id2..'&message_id='..Msg_Id2..'&text=' .. URL.escape(Text).."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end
if DataText and DataText:match('/LockWelcome:'..tonumber(data.sender_user_id_)..'(.*)') then
local Aek = DataText:match('/LockWelcome:'..tonumber(data.sender_user_id_)..'(.*)')
DevAek:del(AEK.."Aek:Lock:Welcome"..data.chat_id_)
Text = "*✫︙تم تعطيل الترحيب*"
keyboard = {} 
keyboard.inline_keyboard = {{{text="• اخفاء الكليشه •",callback_data="/HideHelpList:"..data.sender_user_id_},{text="• رجوع •",callback_data="/lockorder:"..data.sender_user_id_}}}
return https.request("https://api.telegram.org/bot"..TokenBot..'/editMessageText?chat_id='..Chat_Id2..'&message_id='..Msg_Id2..'&text=' .. URL.escape(Text).."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end
if DataText and DataText:match('/UnLockWelcome:'..tonumber(data.sender_user_id_)..'(.*)') then
local Aek = DataText:match('/UnLockWelcome:'..tonumber(data.sender_user_id_)..'(.*)')
DevAek:set(AEK.."Aek:Lock:Welcome"..data.chat_id_,true)
Text = "*✫︙تم تفعيل الترحيب*"
keyboard = {} 
keyboard.inline_keyboard = {{{text="• اخفاء الكليشه •",callback_data="/HideHelpList:"..data.sender_user_id_},{text="• رجوع •",callback_data="/lockorder:"..data.sender_user_id_}}}
return https.request("https://api.telegram.org/bot"..TokenBot..'/editMessageText?chat_id='..Chat_Id2..'&message_id='..Msg_Id2..'&text=' .. URL.escape(Text).."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end
if DataText and DataText:match('/LockAllRed:'..tonumber(data.sender_user_id_)..'(.*)') then
local Aek = DataText:match('/LockAllRed:'..tonumber(data.sender_user_id_)..'(.*)')
DevAek:set(AEK..'Aek:Lock:AllRed'..data.chat_id_,true)
Text = "*✫︙تم تعطيل ردود المطور*"
keyboard = {} 
keyboard.inline_keyboard = {{{text="• اخفاء الكليشه •",callback_data="/HideHelpList:"..data.sender_user_id_},{text="• رجوع •",callback_data="/lockorder:"..data.sender_user_id_}}}
return https.request("https://api.telegram.org/bot"..TokenBot..'/editMessageText?chat_id='..Chat_Id2..'&message_id='..Msg_Id2..'&text=' .. URL.escape(Text).."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end
if DataText and DataText:match('/UnLockAllRed:'..tonumber(data.sender_user_id_)..'(.*)') then
local Aek = DataText:match('/UnLockAllRed:'..tonumber(data.sender_user_id_)..'(.*)')
DevAek:del(AEK..'Aek:Lock:AllRed'..data.chat_id_)
Text = "*✫︙تم تفعيل ردود المطور*"
keyboard = {} 
keyboard.inline_keyboard = {{{text="• اخفاء الكليشه •",callback_data="/HideHelpList:"..data.sender_user_id_},{text="• رجوع •",callback_data="/lockorder:"..data.sender_user_id_}}}
return https.request("https://api.telegram.org/bot"..TokenBot..'/editMessageText?chat_id='..Chat_Id2..'&message_id='..Msg_Id2..'&text=' .. URL.escape(Text).."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end
if DataText and DataText:match('/LockGpRed:'..tonumber(data.sender_user_id_)..'(.*)') then
local Aek = DataText:match('/LockGpRed:'..tonumber(data.sender_user_id_)..'(.*)')
DevAek:set(AEK..'Aek:Lock:GpRed'..data.chat_id_,true)
Text = "*✫︙تم تعطيل ردود المدير*"
keyboard = {} 
keyboard.inline_keyboard = {{{text="• اخفاء الكليشه •",callback_data="/HideHelpList:"..data.sender_user_id_},{text="• رجوع •",callback_data="/lockorder:"..data.sender_user_id_}}}
return https.request("https://api.telegram.org/bot"..TokenBot..'/editMessageText?chat_id='..Chat_Id2..'&message_id='..Msg_Id2..'&text=' .. URL.escape(Text).."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end
if DataText and DataText:match('/UnLockGpRed:'..tonumber(data.sender_user_id_)..'(.*)') then
local Aek = DataText:match('/UnLockGpRed:'..tonumber(data.sender_user_id_)..'(.*)')
DevAek:del(AEK..'Aek:Lock:GpRed'..data.chat_id_)
Text = "*✫︙تم تفعيل ردود المدير*"
keyboard = {} 
keyboard.inline_keyboard = {{{text="• اخفاء الكليشه •",callback_data="/HideHelpList:"..data.sender_user_id_},{text="• رجوع •",callback_data="/lockorder:"..data.sender_user_id_}}}
return https.request("https://api.telegram.org/bot"..TokenBot..'/editMessageText?chat_id='..Chat_Id2..'&message_id='..Msg_Id2..'&text=' .. URL.escape(Text).."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end
if DataText and DataText:match('/LockDelMe:'..tonumber(data.sender_user_id_)..'(.*)') then
local Aek = DataText:match('/LockDelMe:'..tonumber(data.sender_user_id_)..'(.*)')
DevAek:set(AEK.."Aek:Del:Me"..data.chat_id_, true)
Text = "*✫︙تم تعطيل نزلني*"
keyboard = {} 
keyboard.inline_keyboard = {{{text="• اخفاء الكليشه •",callback_data="/HideHelpList:"..data.sender_user_id_},{text="• رجوع •",callback_data="/lockorder:"..data.sender_user_id_}}}
return https.request("https://api.telegram.org/bot"..TokenBot..'/editMessageText?chat_id='..Chat_Id2..'&message_id='..Msg_Id2..'&text=' .. URL.escape(Text).."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end
if DataText and DataText:match('/UnLockDelMe:'..tonumber(data.sender_user_id_)..'(.*)') then
local Aek = DataText:match('/UnLockDelMe:'..tonumber(data.sender_user_id_)..'(.*)')
DevAek:del(AEK.."Aek:Del:Me"..data.chat_id_)
Text = "*✫︙تم تفعيل نزلني*"
keyboard = {} 
keyboard.inline_keyboard = {{{text="• اخفاء الكليشه •",callback_data="/HideHelpList:"..data.sender_user_id_},{text="• رجوع •",callback_data="/lockorder:"..data.sender_user_id_}}}
return https.request("https://api.telegram.org/bot"..TokenBot..'/editMessageText?chat_id='..Chat_Id2..'&message_id='..Msg_Id2..'&text=' .. URL.escape(Text).."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end
if DataText and DataText:match('/LockKickMe:'..tonumber(data.sender_user_id_)..'(.*)') then
local Aek = DataText:match('/LockKickMe:'..tonumber(data.sender_user_id_)..'(.*)')
DevAek:set(AEK.."Aek:Kick:Me"..data.chat_id_, true)
Text = "*✫︙تم تعطيل اطردني*"
keyboard = {} 
keyboard.inline_keyboard = {{{text="• اخفاء الكليشه •",callback_data="/HideHelpList:"..data.sender_user_id_},{text="• رجوع •",callback_data="/lockorder:"..data.sender_user_id_}}}
return https.request("https://api.telegram.org/bot"..TokenBot..'/editMessageText?chat_id='..Chat_Id2..'&message_id='..Msg_Id2..'&text=' .. URL.escape(Text).."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end
if DataText and DataText:match('/UnLockKickMe:'..tonumber(data.sender_user_id_)..'(.*)') then
local Aek = DataText:match('/UnLockKickMe:'..tonumber(data.sender_user_id_)..'(.*)')
DevAek:del(AEK.."Aek:Kick:Me"..data.chat_id_)
Text = "*✫︙تم تفعيل اطردني*"
keyboard = {} 
keyboard.inline_keyboard = {{{text="• اخفاء الكليشه •",callback_data="/HideHelpList:"..data.sender_user_id_},{text="• رجوع •",callback_data="/lockorder:"..data.sender_user_id_}}}
return https.request("https://api.telegram.org/bot"..TokenBot..'/editMessageText?chat_id='..Chat_Id2..'&message_id='..Msg_Id2..'&text=' .. URL.escape(Text).."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end
if DataText and DataText:match('/LockKickBan:'..tonumber(data.sender_user_id_)..'(.*)') then
local Aek = DataText:match('/LockKickBan:'..tonumber(data.sender_user_id_)..'(.*)')
DevAek:set(AEK.."Aek:Lock:KickBan"..data.chat_id_,"true")
Text = "*✫︙تم تعطيل الحظر*"
keyboard = {} 
keyboard.inline_keyboard = {{{text="• اخفاء الكليشه •",callback_data="/HideHelpList:"..data.sender_user_id_},{text="• رجوع •",callback_data="/lockorder:"..data.sender_user_id_}}}
return https.request("https://api.telegram.org/bot"..TokenBot..'/editMessageText?chat_id='..Chat_Id2..'&message_id='..Msg_Id2..'&text=' .. URL.escape(Text).."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end
if DataText and DataText:match('/UnLockKickBan:'..tonumber(data.sender_user_id_)..'(.*)') then
local Aek = DataText:match('/UnLockKickBan:'..tonumber(data.sender_user_id_)..'(.*)')
DevAek:del(AEK.."Aek:Lock:KickBan"..data.chat_id_)
Text = "*✫︙تم تفعيل الحظر*"
keyboard = {} 
keyboard.inline_keyboard = {{{text="• اخفاء الكليشه •",callback_data="/HideHelpList:"..data.sender_user_id_},{text="• رجوع •",callback_data="/lockorder:"..data.sender_user_id_}}}
return https.request("https://api.telegram.org/bot"..TokenBot..'/editMessageText?chat_id='..Chat_Id2..'&message_id='..Msg_Id2..'&text=' .. URL.escape(Text).."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end
if DataText and DataText:match('/LockProSet:'..tonumber(data.sender_user_id_)..'(.*)') then
local Aek = DataText:match('/LockProSet:'..tonumber(data.sender_user_id_)..'(.*)')
DevAek:set(AEK.."Aek:Lock:ProSet"..data.chat_id_,"true")
Text = "*✫︙تم تعطيل الرفع*"
keyboard = {} 
keyboard.inline_keyboard = {{{text="• اخفاء الكليشه •",callback_data="/HideHelpList:"..data.sender_user_id_},{text="• رجوع •",callback_data="/lockorder:"..data.sender_user_id_}}}
return https.request("https://api.telegram.org/bot"..TokenBot..'/editMessageText?chat_id='..Chat_Id2..'&message_id='..Msg_Id2..'&text=' .. URL.escape(Text).."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end
if DataText and DataText:match('/UnLocProSet:'..tonumber(data.sender_user_id_)..'(.*)') then
local Aek = DataText:match('/UnLocProSet:'..tonumber(data.sender_user_id_)..'(.*)')
DevAek:del(AEK.."Aek:Lock:ProSet"..data.chat_id_)
Text = "*✫︙تم تفعيل الرفع*"
keyboard = {} 
keyboard.inline_keyboard = {{{text="• اخفاء الكليشه •",callback_data="/HideHelpList:"..data.sender_user_id_},{text="• رجوع •",callback_data="/lockorder:"..data.sender_user_id_}}}
return https.request("https://api.telegram.org/bot"..TokenBot..'/editMessageText?chat_id='..Chat_Id2..'&message_id='..Msg_Id2..'&text=' .. URL.escape(Text).."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end
if DataText and DataText:match('/LockGames:'..tonumber(data.sender_user_id_)..'(.*)') then
local Aek = DataText:match('/LockGames:'..tonumber(data.sender_user_id_)..'(.*)')
DevAek:set(AEK..'Aek:Lock:Games'..data.chat_id_,true)  
Text = "*✫︙تم تعطيل الالعاب*"
keyboard = {} 
keyboard.inline_keyboard = {{{text="• اخفاء الكليشه •",callback_data="/HideHelpList:"..data.sender_user_id_},{text="• رجوع •",callback_data="/lockorder:"..data.sender_user_id_}}}
return https.request("https://api.telegram.org/bot"..TokenBot..'/editMessageText?chat_id='..Chat_Id2..'&message_id='..Msg_Id2..'&text=' .. URL.escape(Text).."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end
if DataText and DataText:match('/UnLockGames:'..tonumber(data.sender_user_id_)..'(.*)') then
local Aek = DataText:match('/UnLockGames:'..tonumber(data.sender_user_id_)..'(.*)')
DevAek:del(AEK..'Aek:Lock:Games'..data.chat_id_) 
Text = "*✫︙تم تفعيل الالعاب*"
keyboard = {} 
keyboard.inline_keyboard = {{{text="• اخفاء الكليشه •",callback_data="/HideHelpList:"..data.sender_user_id_},{text="• رجوع •",callback_data="/lockorder:"..data.sender_user_id_}}}
return https.request("https://api.telegram.org/bot"..TokenBot..'/editMessageText?chat_id='..Chat_Id2..'&message_id='..Msg_Id2..'&text=' .. URL.escape(Text).."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end
if DataText and DataText:match(tonumber(data.sender_user_id_)..':SetList:(.*)') then
local Aek = DataText:match(tonumber(data.sender_user_id_)..':SetList:(.*)')
tdcli_function ({ID = "GetUser",user_id_ = Aek},function(arg,dp) 
if dp.first_name_ == false then
Dev_Aek(data.chat_id_, data.id_, 1, "✫︙الحساب محذوف", 1, "md")
return false  
end
local Text = '✫︙قم باستعمال الازرار لرفع العضو ↫ ⤈\n✫︙العضو ↫ ['..dp.first_name_..'](t.me/'..(dp.username_ or 'HH_418')..')'
keyboard = {} 
if Sudo(data) then
keyboard.inline_keyboard = {{{text="رفع مميز",callback_data=data.sender_user_id_..":SetMem:"..Aek},{text="رفع ادمن",callback_data=data.sender_user_id_..":SetAdmin:"..Aek}},{{text="رفع منشئ",callback_data=data.sender_user_id_..":SetConstructor:"..Aek},{text="رفع مدير",callback_data=data.sender_user_id_..":SetManager:"..Aek}},{{text="رفع منظف",callback_data=data.sender_user_id_..":SetCleaner:"..Aek},{text="رفع منشئ اساسي",callback_data=data.sender_user_id_..":SetBasicConstructor:"..Aek}},{{text="رفع مالك",callback_data=data.sender_user_id_..":SetAekConstructor:"..Aek},{text="رفع مطور",callback_data=data.sender_user_id_..":SetSudoBot:"..Aek}},{{text="رفع مطور ثانوي",callback_data=data.sender_user_id_..":SetSecondSudo:"..Aek}}}
elseif SecondSudo(data) then
keyboard.inline_keyboard = {{{text="رفع مميز",callback_data=data.sender_user_id_..":SetMem:"..Aek},{text="رفع ادمن",callback_data=data.sender_user_id_..":SetAdmin:"..Aek}},{{text="رفع منشئ",callback_data=data.sender_user_id_..":SetConstructor:"..Aek},{text="رفع مدير",callback_data=data.sender_user_id_..":SetManager:"..Aek}},{{text="رفع منظف",callback_data=data.sender_user_id_..":SetCleaner:"..Aek},{text="رفع منشئ اساسي",callback_data=data.sender_user_id_..":SetBasicConstructor:"..Aek}},{{text="رفع مالك",callback_data=data.sender_user_id_..":SetAekConstructor:"..Aek},{text="رفع مطور",callback_data=data.sender_user_id_..":SetSudoBot:"..Aek}}}
elseif SudoBot(data) then
keyboard.inline_keyboard = {{{text="رفع مميز",callback_data=data.sender_user_id_..":SetMem:"..Aek},{text="رفع ادمن",callback_data=data.sender_user_id_..":SetAdmin:"..Aek}},{{text="رفع منشئ",callback_data=data.sender_user_id_..":SetConstructor:"..Aek},{text="رفع مدير",callback_data=data.sender_user_id_..":SetManager:"..Aek}},{{text="رفع منظف",callback_data=data.sender_user_id_..":SetCleaner:"..Aek},{text="رفع منشئ اساسي",callback_data=data.sender_user_id_..":SetBasicConstructor:"..Aek}},{{text="رفع مالك",callback_data=data.sender_user_id_..":SetAekConstructor:"..Aek}}}
elseif AekConstructor(data) then
keyboard.inline_keyboard = {{{text="رفع مميز",callback_data=data.sender_user_id_..":SetMem:"..Aek},{text="رفع ادمن",callback_data=data.sender_user_id_..":SetAdmin:"..Aek}},{{text="رفع منشئ",callback_data=data.sender_user_id_..":SetConstructor:"..Aek},{text="رفع مدير",callback_data=data.sender_user_id_..":SetManager:"..Aek}},{{text="رفع منظف",callback_data=data.sender_user_id_..":SetCleaner:"..Aek},{text="رفع منشئ اساسي",callback_data=data.sender_user_id_..":SetBasicConstructor:"..Aek}}}
elseif BasicConstructor(data) then
keyboard.inline_keyboard = {{{text="رفع مميز",callback_data=data.sender_user_id_..":SetMem:"..Aek},{text="رفع ادمن",callback_data=data.sender_user_id_..":SetAdmin:"..Aek}},{{text="رفع منشئ",callback_data=data.sender_user_id_..":SetConstructor:"..Aek},{text="رفع مدير",callback_data=data.sender_user_id_..":SetManager:"..Aek}},{{text="رفع منظف",callback_data=data.sender_user_id_..":SetCleaner:"..Aek}},{{text = '‹  𝖲𝗈𝗎𝗋𝖼𝖾 𝙄𝘽𝙊 ›',url="t.me/HH_418"}}}
elseif Constructor(data) then
keyboard.inline_keyboard = {{{text="رفع مميز",callback_data=data.sender_user_id_..":SetMem:"..Aek},{text="رفع ادمن",callback_data=data.sender_user_id_..":SetAdmin:"..Aek}},{{text="رفع منظف",callback_data=data.sender_user_id_..":SetCleaner:"..Aek},{text="رفع مدير",callback_data=data.sender_user_id_..":SetManager:"..Aek}},{{text = '‹  𝖲𝗈𝗎𝗋𝖼𝖾 𝙄𝘽𝙊 ›',url="t.me/HH_418"}}}
elseif Manager(data) then
keyboard.inline_keyboard = {{{text="رفع مميز",callback_data=data.sender_user_id_..":SetMem:"..Aek},{text="رفع ادمن",callback_data=data.sender_user_id_..":SetAdmin:"..Aek}},{{text = '‹  𝖲𝗈𝗎𝗋𝖼𝖾 𝙄𝘽𝙊 ›',url="t.me/HH_418"}}}
elseif Admin(data) then
keyboard.inline_keyboard = {{{text="رفع مميز",callback_data=data.sender_user_id_..":SetMem:"..Aek}},{{text = '‹  𝖲𝗈𝗎𝗋𝖼𝖾 𝙄𝘽𝙊 ›',url="t.me/HH_418"}}}
end
https.request("https://api.telegram.org/bot"..TokenBot..'/editMessageText?chat_id='..Chat_Id2..'&message_id='..Msg_Id2..'&text=' .. URL.escape(Text).."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end,nil)
end

if DataText and DataText:match(tonumber(data.sender_user_id_)..':RemList:(.*)') then
local Aek = DataText:match(tonumber(data.sender_user_id_)..':RemList:(.*)')
tdcli_function ({ID = "GetUser",user_id_ = Aek},function(arg,dp) 
if dp.first_name_ == false then
Dev_Aek(data.chat_id_, data.id_, 1, "✫︙الحساب محذوف", 1, "md")
return false  
end
local Text = '✫︙قم باستعمال الازرار لتنزيل العضو ↫ ⤈\n✫︙العضو ↫ ['..dp.first_name_..'](t.me/'..(dp.username_ or 'HH_418')..')'
keyboard = {} 
if Sudo(data) then
keyboard.inline_keyboard = {{{text="تنزيل مميز",callback_data=data.sender_user_id_..":RemMem:"..Aek},{text="تنزيل ادمن",callback_data=data.sender_user_id_..":RemAdmin:"..Aek}},{{text="تنزيل منشئ",callback_data=data.sender_user_id_..":RemConstructor:"..Aek},{text="تنزيل مدير",callback_data=data.sender_user_id_..":RemManager:"..Aek}},{{text="تنزيل منظف",callback_data=data.sender_user_id_..":RemCleaner:"..Aek},{text="تنزيل منشئ اساسي",callback_data=data.sender_user_id_..":RemBasicConstructor:"..Aek}},{{text="تنزيل مالك",callback_data=data.sender_user_id_..":RemAekConstructor:"..Aek},{text="تنزيل مطور",callback_data=data.sender_user_id_..":RemSudoBot:"..Aek}},{{text="تنزيل مطور ثانوي",callback_data=data.sender_user_id_..":RemSecondSudo:"..Aek}}}
elseif SecondSudo(data) then
keyboard.inline_keyboard = {{{text="تنزيل مميز",callback_data=data.sender_user_id_..":RemMem:"..Aek},{text="تنزيل ادمن",callback_data=data.sender_user_id_..":RemAdmin:"..Aek}},{{text="تنزيل منشئ",callback_data=data.sender_user_id_..":RemConstructor:"..Aek},{text="تنزيل مدير",callback_data=data.sender_user_id_..":RemManager:"..Aek}},{{text="تنزيل منظف",callback_data=data.sender_user_id_..":RemCleaner:"..Aek},{text="تنزيل منشئ اساسي",callback_data=data.sender_user_id_..":RemBasicConstructor:"..Aek}},{{text="تنزيل مالك",callback_data=data.sender_user_id_..":RemAekConstructor:"..Aek},{text="تنزيل مطور",callback_data=data.sender_user_id_..":RemSudoBot:"..Aek}}}
elseif SudoBot(data) then
keyboard.inline_keyboard = {{{text="تنزيل مميز",callback_data=data.sender_user_id_..":RemMem:"..Aek},{text="تنزيل ادمن",callback_data=data.sender_user_id_..":RemAdmin:"..Aek}},{{text="تنزيل منشئ",callback_data=data.sender_user_id_..":RemConstructor:"..Aek},{text="تنزيل مدير",callback_data=data.sender_user_id_..":RemManager:"..Aek}},{{text="تنزيل منظف",callback_data=data.sender_user_id_..":RemCleaner:"..Aek},{text="تنزيل منشئ اساسي",callback_data=data.sender_user_id_..":RemBasicConstructor:"..Aek}},{{text="تنزيل مالك",callback_data=data.sender_user_id_..":RemAekConstructor:"..Aek}}}
elseif AekConstructor(data) then
keyboard.inline_keyboard = {{{text="تنزيل مميز",callback_data=data.sender_user_id_..":RemMem:"..Aek},{text="تنزيل ادمن",callback_data=data.sender_user_id_..":RemAdmin:"..Aek}},{{text="تنزيل منشئ",callback_data=data.sender_user_id_..":RemConstructor:"..Aek},{text="تنزيل مدير",callback_data=data.sender_user_id_..":RemManager:"..Aek}},{{text="تنزيل منظف",callback_data=data.sender_user_id_..":RemCleaner:"..Aek},{text="تنزيل منشئ اساسي",callback_data=data.sender_user_id_..":RemBasicConstructor:"..Aek}}}
elseif BasicConstructor(data) then
keyboard.inline_keyboard = {{{text="تنزيل مميز",callback_data=data.sender_user_id_..":RemMem:"..Aek},{text="تنزيل ادمن",callback_data=data.sender_user_id_..":RemAdmin:"..Aek}},{{text="تنزيل منشئ",callback_data=data.sender_user_id_..":RemConstructor:"..Aek},{text="تنزيل مدير",callback_data=data.sender_user_id_..":RemManager:"..Aek}},{{text="تنزيل منظف",callback_data=data.sender_user_id_..":RemCleaner:"..Aek}},{{text = '‹  𝖲𝗈𝗎𝗋𝖼𝖾 𝙄𝘽𝙊 ›',url="t.me/HH_418"}}}
elseif Constructor(data) then
keyboard.inline_keyboard = {{{text="تنزيل مميز",callback_data=data.sender_user_id_..":RemMem:"..Aek},{text="تنزيل ادمن",callback_data=data.sender_user_id_..":RemAdmin:"..Aek}},{{text="تنزيل منظف",callback_data=data.sender_user_id_..":RemCleaner:"..Aek},{text="تنزيل مدير",callback_data=data.sender_user_id_..":RemManager:"..Aek}},{{text = '‹  𝖲𝗈𝗎𝗋𝖼𝖾 𝙄𝘽𝙊 ›',url="t.me/HH_418"}}}
elseif Manager(data) then
keyboard.inline_keyboard = {{{text="تنزيل مميز",callback_data=data.sender_user_id_..":RemMem:"..Aek},{text="تنزيل ادمن",callback_data=data.sender_user_id_..":RemAdmin:"..Aek}},{{text = '‹  𝖲𝗈𝗎𝗋𝖼𝖾 𝙄𝘽𝙊 ›',url="t.me/HH_418"}}}
elseif Admin(data) then
keyboard.inline_keyboard = {{{text="تنزيل مميز",callback_data=data.sender_user_id_..":RemMem:"..Aek}},{{text = '‹  𝖲𝗈𝗎𝗋𝖼𝖾 𝙄𝘽𝙊 ›',url="t.me/HH_418"}}}
end
https.request("https://api.telegram.org/bot"..TokenBot..'/editMessageText?chat_id='..Chat_Id2..'&message_id='..Msg_Id2..'&text=' .. URL.escape(Text).."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end,nil)
end
if DataText and DataText:match('/DelList:(.*)') then
local Aek = DataText:match('/DelList:(.*)')
if tonumber(Aek) == tonumber(data.sender_user_id_) then
local Del = DevAek:get(AEK..'Aek:Del')
local Text = [[
✫︙اهلا بك في قائمة اوامر الرتب ↫ ⤈          
━───━ ✫ ━───━
يمكنك مسح رتب المجموعه من خلال الازرار اسفل
━───━ ✫ ━───━
✫︙[‹  𝖲𝗈𝗎𝗋𝖼𝖾 𝙄𝘽𝙊 ›](https://t.me/HH_418)
]] 
keyboard = {} 
keyboard.inline_keyboard = {{{text="مسح الاساسيين",callback_data="/DelBasicConstructor:"..data.sender_user_id_},{text="مسح المنشئين",callback_data="/DelConstructor:"..data.sender_user_id_}},{{text="مسح المدراء",callback_data="/DelManager:"..data.sender_user_id_},{text="مسح الادمنيه",callback_data="/DelAdmins:"..data.sender_user_id_}},{{text="مسح المميزين",callback_data="/DelVipMem:"..data.sender_user_id_}},{{text="• اخفاء الكليشه •",callback_data="/HideHelpList:"..data.sender_user_id_},{text="• القائمه الرئيسيه •",callback_data="/HelpList:"..data.sender_user_id_}}}
return https.request("https://api.telegram.org/bot"..TokenBot..'/editMessageText?chat_id='..Chat_Id2..'&message_id='..Msg_Id2..'&text=' .. URL.escape(Del or Text).."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
else
return https.request("https://api.telegram.org/bot"..TokenBot..'/answercallbackquery?callback_query_id='..data.id_..'&text='..URL.escape("✫ عذرا الامر ليس لك .")..'&show_alert=true')
end end
if SudoBot(data) then
if DataText and DataText:match('/DelAekConstructor:'..tonumber(data.sender_user_id_)..'(.*)') then
local Aek = DataText:match('/DelAekConstructor:'..tonumber(data.sender_user_id_)..'(.*)')
DevAek:del(AEK..'Aek:AekConstructor:'..data.chat_id_)
Text = "*✫︙تم حذف المالكين الاساسيين*"
keyboard = {} 
keyboard.inline_keyboard = {{{text="• اخفاء الكليشه •",callback_data="/HideHelpList:"..data.sender_user_id_},{text="• القائمه الرئيسيه •",callback_data="/DelList:"..data.sender_user_id_}}}
https.request("https://api.telegram.org/bot"..TokenBot..'/editMessageText?chat_id='..Chat_Id2..'&message_id='..Msg_Id2..'&text=' .. URL.escape(Text).."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end end
if AekConstructor(data) then
if DataText and DataText:match('/DelBasicConstructor:'..tonumber(data.sender_user_id_)..'(.*)') then
local Aek = DataText:match('/DelBasicConstructor:'..tonumber(data.sender_user_id_)..'(.*)')
DevAek:del(AEK..'Aek:BasicConstructor:'..data.chat_id_..':'..data.sender_user_id_)
Text = "*✫︙تم حذف المنشئين الاساسيين*"
keyboard = {} 
keyboard.inline_keyboard = {{{text="• اخفاء الكليشه •",callback_data="/HideHelpList:"..data.sender_user_id_},{text="• القائمه الرئيسيه •",callback_data="/DelList:"..data.sender_user_id_}}}
https.request("https://api.telegram.org/bot"..TokenBot..'/editMessageText?chat_id='..Chat_Id2..'&message_id='..Msg_Id2..'&text=' .. URL.escape(Text).."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end end
if BasicConstructor(data) then
if DataText and DataText:match('/DelConstructor:'..tonumber(data.sender_user_id_)..'(.*)') then
local Aek = DataText:match('/DelConstructor:'..tonumber(data.sender_user_id_)..'(.*)')
DevAek:del(AEK..'Aek:Constructor:'..data.chat_id_)
Text = "*✫︙تم حذف المنشئين*"
keyboard = {} 
keyboard.inline_keyboard = {{{text="• اخفاء الكليشه •",callback_data="/HideHelpList:"..data.sender_user_id_},{text="• القائمه الرئيسيه •",callback_data="/DelList:"..data.sender_user_id_}}}
https.request("https://api.telegram.org/bot"..TokenBot..'/editMessageText?chat_id='..Chat_Id2..'&message_id='..Msg_Id2..'&text=' .. URL.escape(Text).."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end end
if Constructor(data) then
if DataText and DataText:match('/DelManager:'..tonumber(data.sender_user_id_)..'(.*)') then
local Aek = DataText:match('/DelManager:'..tonumber(data.sender_user_id_)..'(.*)')
DevAek:del(AEK..'Aek:Managers:'..data.chat_id_)
Text = "*✫︙تم حذف المدراء*"
keyboard = {} 
keyboard.inline_keyboard = {{{text="• اخفاء الكليشه •",callback_data="/HideHelpList:"..data.sender_user_id_},{text="• القائمه الرئيسيه •",callback_data="/DelList:"..data.sender_user_id_}}}
https.request("https://api.telegram.org/bot"..TokenBot..'/editMessageText?chat_id='..Chat_Id2..'&message_id='..Msg_Id2..'&text=' .. URL.escape(Text).."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end end
if Manager(data) then
if DataText and DataText:match('/DelAdmins:'..tonumber(data.sender_user_id_)..'(.*)') then
local Aek = DataText:match('/DelAdmins:'..tonumber(data.sender_user_id_)..'(.*)')
DevAek:del(AEK..'Aek:Admins:'..data.chat_id_)
Text = "*✫︙تم حذف الادمنيه*"
keyboard = {} 
keyboard.inline_keyboard = {{{text="• اخفاء الكليشه •",callback_data="/HideHelpList:"..data.sender_user_id_},{text="• القائمه الرئيسيه •",callback_data="/DelList:"..data.sender_user_id_}}}
https.request("https://api.telegram.org/bot"..TokenBot..'/editMessageText?chat_id='..Chat_Id2..'&message_id='..Msg_Id2..'&text=' .. URL.escape(Text).."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end end
if Admin(data) then
if DataText and DataText:match('/DelVipMem:'..tonumber(data.sender_user_id_)..'(.*)') then
local Aek = DataText:match('/DelVipMem:'..tonumber(data.sender_user_id_)..'(.*)')
DevAek:del(AEK..'Aek:VipMem:'..data.chat_id_)
Text = "*✫︙تم حذف المميزين*"
keyboard = {} 
keyboard.inline_keyboard = {{{text="• اخفاء الكليشه •",callback_data="/HideHelpList:"..data.sender_user_id_},{text="• القائمه الرئيسيه •",callback_data="/DelList:"..data.sender_user_id_}}}
https.request("https://api.telegram.org/bot"..TokenBot..'/editMessageText?chat_id='..Chat_Id2..'&message_id='..Msg_Id2..'&text=' .. URL.escape(Text).."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end end
if BasicConstructor(data) then
if DataText and DataText:match('/DelCleanr:'..tonumber(data.sender_user_id_)..'(.*)') then
local Aek = DataText:match('/DelCleanr:'..tonumber(data.sender_user_id_)..'(.*)')
DevAek:del(AEK..'Aek:Cleaner:'..data.chat_id_)
Text = "*✫︙تم حذف المنظفين*"
keyboard = {} 
keyboard.inline_keyboard = {{{text="• اخفاء الكليشه •",callback_data="/HideHelpList:"..data.sender_user_id_},{text="• القائمه الرئيسيه •",callback_data="/DelList:"..data.sender_user_id_}}}
https.request("https://api.telegram.org/bot"..TokenBot..'/editMessageText?chat_id='..Chat_Id2..'&message_id='..Msg_Id2..'&text=' .. URL.escape(Text).."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end end
if Admin(data) then
if DataText and DataText:match('/DelMute:'..tonumber(data.sender_user_id_)..'(.*)') then
local Aek = DataText:match('/DelMute:'..tonumber(data.sender_user_id_)..'(.*)')
DevAek:del(AEK..'Aek:Muted:'..data.chat_id_)
Text = "*✫︙تم حذف المكتومين*"
keyboard = {} 
keyboard.inline_keyboard = {{{text="• اخفاء الكليشه •",callback_data="/HideHelpList:"..data.sender_user_id_}}}
https.request("https://api.telegram.org/bot"..TokenBot..'/editMessageText?chat_id='..Chat_Id2..'&message_id='..Msg_Id2..'&text=' .. URL.escape(Text).."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end
if DataText and DataText:match('/DelKeed:'..tonumber(data.sender_user_id_)..'(.*)') then
local Aek = DataText:match('/DelKeed:'..tonumber(data.sender_user_id_)..'(.*)')
local List = DevAek:smembers(AEK..'Aek:Tkeed:'..data.chat_id_)
for k,v in pairs(List) do   
HTTPS.request("https://api.telegram.org/bot"..TokenBot.."/restrictChatMember?chat_id="..data.chat_id_.."&user_id="..v.."&can_send_messages=True&can_send_media_messages=True&can_send_other_messages=True&can_add_web_page_previews=True") 
DevAek:srem(AEK..'Aek:Tkeed:'..data.chat_id_, v)
end
Text = "*✫︙تم حذف المقيدين*"
keyboard = {} 
keyboard.inline_keyboard = {{{text="• اخفاء الكليشه •",callback_data="/HideHelpList:"..data.sender_user_id_}}}
https.request("https://api.telegram.org/bot"..TokenBot..'/editMessageText?chat_id='..Chat_Id2..'&message_id='..Msg_Id2..'&text=' .. URL.escape(Text).."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end
if DataText and DataText:match('/DelBan:'..tonumber(data.sender_user_id_)..'(.*)') then
local Aek = DataText:match('/DelBan:'..tonumber(data.sender_user_id_)..'(.*)')
DevAek:del(AEK..'Aek:Ban:'..data.chat_id_)
Text = "*✫︙تم حذف المحظورين*"
keyboard = {} 
keyboard.inline_keyboard = {{{text="• اخفاء الكليشه •",callback_data="/HideHelpList:"..data.sender_user_id_}}}
https.request("https://api.telegram.org/bot"..TokenBot..'/editMessageText?chat_id='..Chat_Id2..'&message_id='..Msg_Id2..'&text=' .. URL.escape(Text).."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end end

if DataText and DataText:match('/HideHelpList:(.*)') then
local Aeek = DataText:match('/HideHelpList:(.*)')
if tonumber(Aeek) == tonumber(data.sender_user_id_) then
EditMsg(Chat_Id2, Msg_Id2, "✫︙تم اخفاء كليشة الاوامر") 
else
return https.request("https://api.telegram.org/bot"..TokenBot..'/answercallbackquery?callback_query_id='..data.id_..'&text='..URL.escape("✫ عذرا الامر ليس لك .")..'&show_alert=true')
end
end
if DataText and DataText:match('/HelpList:(.*)') then
local Aeek = DataText:match('/HelpList:(.*)')
if tonumber(Aeek) == tonumber(data.sender_user_id_) then
local Help = DevAek:get(AEK..'Aek:Help')
local Text = [[
✫︙اهلا بك في قائمة الاوامر ↫ ⤈ 
━───━ ✫ ━───━
✫︙م1 ↫ اوامر الحمايه
✫︙م2 ↫ اوامر الادمنيه
✫︙م3 ↫ اوامر المدراء
✫︙م4 ↫ اوامر المنشئين
✫︙م5 ↫ اوامر المطورين
✫︙م6 ↫ اوامر الاعضاء
━───━ ✫ ━───━
✫︙[‹  𝖲𝗈𝗎𝗋𝖼𝖾 𝙄𝘽𝙊 ›](https://t.me/HH_418)
]] 
keyboard = {} 
keyboard.inline_keyboard = {{{text="اوامر الادمنيه",callback_data="/HelpList2:"..data.sender_user_id_},{text="اوامر الحمايه",callback_data="/HelpList1:"..data.sender_user_id_}},{{text="اوامر المنشئين",callback_data="/HelpList4:"..data.sender_user_id_},{text="اوامر المدراء",callback_data="/HelpList3:"..data.sender_user_id_}},{{text="اوامر الاعضاء",callback_data="/HelpList6:"..data.sender_user_id_},{text="اوامر المطورين",callback_data="/HelpList5:"..data.sender_user_id_}},{{text="اوامر الرتب",callback_data="/DelList:"..data.sender_user_id_}},{{text="التفعيل و التعطيل",callback_data="/lockorder:"..data.sender_user_id_},{text="القفل و الفتح",callback_data="/locklist:"..data.sender_user_id_}},{{text="اخفاء القائمه",callback_data="/HideHelpList:"..data.sender_user_id_}}}
return https.request("https://api.telegram.org/bot"..TokenBot..'/editMessageText?chat_id='..Chat_Id2..'&message_id='..Msg_Id2..'&text=' .. URL.escape(Help or Text).."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
else
return https.request("https://api.telegram.org/bot"..TokenBot..'/answercallbackquery?callback_query_id='..data.id_..'&text='..URL.escape("✫ عذرا الامر ليس لك .")..'&show_alert=true')
end
end
if DataText and DataText:match('/HelpList1:(.*)') then
local Aeek = DataText:match('/HelpList1:(.*)')
if tonumber(Aeek) == tonumber(data.sender_user_id_) then
if not Admin(data) then
return https.request("https://api.telegram.org/bot"..TokenBot..'/answercallbackquery?callback_query_id='..data.id_..'&text='..URL.escape("✫ عذرا ليس لديك صلاحية التحكم لهذا الامر .")..'&show_alert=true')
end
local Help = DevAek:get(AEK..'Aek:Help1')
local Text = [[
✫︙اوامر حماية المجموعه ↫ ⤈
━───━ ✫ ━───━
✫︙قفل • فتح ↫ الروابط
✫︙قفل • فتح ↫ المعرفات
✫︙قفل • فتح ↫ البوتات
✫︙قفل • فتح ↫ المتحركه
✫︙قفل • فتح ↫ الملصقات
✫︙قفل • فتح ↫ الملفات
✫︙قفل • فتح ↫ الصور
✫︙قفل • فتح ↫ الفيديو
✫︙قفل • فتح ↫ الاونلاين
✫︙قفل • فتح ↫ الدردشه
✫︙قفل • فتح ↫ التوجيه
✫︙قفل • فتح ↫ الاغاني
✫︙قفل • فتح ↫ الصوت
✫︙قفل • فتح ↫ الجهات
✫︙قفل • فتح ↫ الماركداون
✫︙قفل • فتح ↫ التكرار
✫︙قفل • فتح ↫ الهاشتاك
✫︙قفل • فتح ↫ التعديل
✫︙قفل • فتح ↫ التثبيت
✫︙قفل • فتح ↫ الاشعارات
✫︙قفل • فتح ↫ الكلايش
✫︙قفل • فتح ↫ الدخول
✫︙قفل • فتح ↫ الشبكات
✫︙قفل • فتح ↫ المواقع
✫︙قفل • فتح ↫ الفشار
✫︙قفل • فتح ↫ الكفر
✫︙قفل • فتح ↫ الطائفيه
✫︙قفل • فتح ↫ الكل
✫︙قفل • فتح ↫ العربيه
✫︙قفل • فتح ↫ الانكليزيه
✫︙قفل • فتح ↫ الفارسيه
✫︙قفل • فتح ↫ التفليش
━───━ ✫ ━───━
✫︙اوامر حمايه اخرى ↫ ⤈
━───━ ✫ ━───━
✫︙قفل • فتح + الامر ↫ ⤈
✫︙التكرار بالطرد
✫︙التكرار بالكتم
✫︙التكرار بالتقيد
✫︙الفارسيه بالتحذير
✫︙الفارسيه بالطرد
✫︙البوتات بالطرد
✫︙البوتات بالتقيد
━───━ ✫ ━───━
✫︙[‹  𝖲𝗈𝗎𝗋𝖼𝖾 𝙄𝘽𝙊 ›](https://t.me/HH_418)
]]
keyboard = {} 
keyboard.inline_keyboard = {{{text="اوامر الادمنيه",callback_data="/HelpList2:"..data.sender_user_id_}},{{text="اوامر المنشئين",callback_data="/HelpList4:"..data.sender_user_id_},{text="اوامر المدراء",callback_data="/HelpList3:"..data.sender_user_id_}},{{text="اوامر الاعضاء",callback_data="/HelpList6:"..data.sender_user_id_},{text="اوامر المطورين",callback_data="/HelpList5:"..data.sender_user_id_}},{{text="اخفاء القائمه",callback_data="/HideHelpList:"..data.sender_user_id_}},{{text="رجوع",callback_data="/HelpList:"..data.sender_user_id_}}}
return https.request("https://api.telegram.org/bot"..TokenBot..'/editMessageText?chat_id='..Chat_Id2..'&message_id='..Msg_Id2..'&text=' .. URL.escape(Help or Text).."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
else
return https.request("https://api.telegram.org/bot"..TokenBot..'/answercallbackquery?callback_query_id='..data.id_..'&text='..URL.escape("✫ عذرا الامر ليس لك .")..'&show_alert=true')
end
end
if DataText and DataText:match('/HelpList2:(.*)') then
local Aeek = DataText:match('/HelpList2:(.*)')
if tonumber(Aeek) == tonumber(data.sender_user_id_) then
if not Admin(data) then
return https.request("https://api.telegram.org/bot"..TokenBot..'/answercallbackquery?callback_query_id='..data.id_..'&text='..URL.escape("✫ عذرا ليس لديك صلاحية التحكم لهذا الامر .")..'&show_alert=true')
end
local Help = DevAek:get(AEK..'Aek:Help2')
local Text = [[
✫︙اوامر الادمنيه ↫ ⤈
━───━ ✫ ━───━
✫︙الاعدادت
✫︙تاك للكل 
✫︙انشاء رابط
✫︙ضع وصف
✫︙ضع رابط
✫︙ضع صوره
✫︙حذف الرابط
✫︙حذف المطايه
✫︙كشف البوتات
✫︙طرد البوتات
✫︙تنظيف + العدد
✫︙تنظيف التعديل
✫︙كللهم + الكلمه
✫︙اسم البوت + الامر
✫︙ضع • حذف ↫ ترحيب
✫︙ضع • حذف ↫ قوانين
✫︙اضف • حذف ↫ صلاحيه
✫︙الصلاحيات • حذف الصلاحيات
━───━ ✫ ━───━
✫︙ضع سبام + العدد
✫︙ضع تكرار + العدد
━───━ ✫ ━───━
✫︙رفع مميز • تنزيل مميز
✫︙المميزين • حذف المميزين
✫︙كشف القيود • رفع القيود
━───━ ✫ ━───━
✫︙حذف • مسح + بالرد
✫︙منع • الغاء منع
✫︙قائمه المنع
✫︙حذف قائمه المنع
━───━ ✫ ━───━
✫︙تفعيل • تعطيل ↫ الرابط
✫︙تفعيل • تعطيل ↫ الالعاب
✫︙تفعيل • تعطيل ↫ الترحيب
✫︙تفعيل • تعطيل ↫ كشف الاعدادات
━───━ ✫ ━───━
✫︙طرد المحذوفين
✫︙طرد ↫ بالرد • بالمعرف • بالايدي
✫︙كتم • الغاء كتم
✫︙تقيد • الغاء تقيد
✫︙حظر • الغاء حظر
✫︙المكتومين • حذف المكتومين
✫︙المقيدين • حذف المقيدين
✫︙المحظورين • حذف المحظورين
━───━ ✫ ━───━
✫︙تقييد دقيقه + عدد الدقائق
✫︙تقييد ساعه + عدد الساعات
✫︙تقييد يوم + عدد الايام
✫︙الغاء تقييد ↫ لالغاء التقييد بالوقت
━───━ ✫ ━───━
✫︙[‹  𝖲𝗈𝗎𝗋𝖼𝖾 𝙄𝘽𝙊 ›](https://t.me/HH_418)
]]
keyboard = {} 
keyboard.inline_keyboard = {{{text="اوامر الحمايه",callback_data="/HelpList1:"..data.sender_user_id_}},{{text="اوامر المنشئين",callback_data="/HelpList4:"..data.sender_user_id_},{text="اوامر المدراء",callback_data="/HelpList3:"..data.sender_user_id_}},{{text="اوامر الاعضاء",callback_data="/HelpList6:"..data.sender_user_id_},{text="اوامر المطورين",callback_data="/HelpList5:"..data.sender_user_id_}},{{text="اخفاء القائمه",callback_data="/HideHelpList:"..data.sender_user_id_}},{{text="رجوع",callback_data="/HelpList:"..data.sender_user_id_}}}
return https.request("https://api.telegram.org/bot"..TokenBot..'/editMessageText?chat_id='..Chat_Id2..'&message_id='..Msg_Id2..'&text=' .. URL.escape(Help or Text).."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
else
return https.request("https://api.telegram.org/bot"..TokenBot..'/answercallbackquery?callback_query_id='..data.id_..'&text='..URL.escape("✫ عذرا الامر ليس لك .")..'&show_alert=true')
end
end
if DataText and DataText:match('/HelpList3:(.*)') then
local Aeek = DataText:match('/HelpList3:(.*)')
if tonumber(Aeek) == tonumber(data.sender_user_id_) then
if not Admin(data) then
return https.request("https://api.telegram.org/bot"..TokenBot..'/answercallbackquery?callback_query_id='..data.id_..'&text='..URL.escape("✫ عذرا ليس لديك صلاحية التحكم لهذا الامر .")..'&show_alert=true')
end
local Help = DevAek:get(AEK..'Aek:Help3')
local Text = [[
✫︙اوامر المدراء ↫ ⤈
━───━ ✫ ━───━
✫︙فحص البوت
✫︙ضع اسم + الاسم
✫︙وضع توحيد + رمز التوحيد
✫︙تعين عدد الكتم + العدد
✫︙الغاء • كتم اسم + الاسم
✫︙اضف • حذف ↫ رد
✫︙ردود المدير
✫︙حذف ردود المدير
✫︙حذف قوائم المنع
✫︙منع ↫ بالرد على ( ملصق • صوره • متحركه )
✫︙حذف قائمه منع + ↫ ⤈
( الصور • المتحركات • الملصقات )
━───━ ✫ ━───━
✫︙تنزيل الكل
✫︙رفع ادمن • تنزيل ادمن
✫︙الادمنيه • حذف الادمنيه
━───━ ✫ ━───━
✫︙تثبيت
✫︙الغاء التثبيت
✫︙اعاده التثبيت
✫︙الغاء تثبيت الكل
━───━ ✫ ━───━
✫︙تغير رد + اسم الرتبه + النص ↫ ⤈
✫︙المطور • منشئ الاساسي
✫︙المنشئ • المدير • الادمن
✫︙المميز • العضو
✫︙حذف ردود الرتب
━───━ ✫ ━───━
✫︙تغيير الايدي ↫ لتغيير الكليشه
✫︙تعيين الايدي ↫ لتعيين الكليشه
✫︙حذف الايدي ↫ لحذف الكليشه
━───━ ✫ ━───━
✫︙تفعيل • تعطيل + الامر ↫ ⤈
✫︙اطردني • الايدي بالصوره • الابراج
✫︙معاني الاسماء • اوامر النسب • التوحيد
✫︙الايدي • تحويل الصيغ • اوامر التحشيش
✫︙ردود المدير • ردود المطور
✫︙ضافني • حساب العمر • الزخرفه
━───━ ✫ ━───━
✫︙[‹  𝖲𝗈𝗎𝗋𝖼𝖾 𝙄𝘽𝙊 ›](https://t.me/HH_418)
]]
keyboard = {} 
keyboard.inline_keyboard = {{{text="اوامر الادمنيه",callback_data="/HelpList2:"..data.sender_user_id_},{text="اوامر الحمايه",callback_data="/HelpList1:"..data.sender_user_id_}},{{text="اوامر المنشئين",callback_data="/HelpList4:"..data.sender_user_id_}},{{text="اوامر الاعضاء",callback_data="/HelpList6:"..data.sender_user_id_},{text="اوامر المطورين",callback_data="/HelpList5:"..data.sender_user_id_}},{{text="اخفاء القائمه",callback_data="/HideHelpList:"..data.sender_user_id_}},{{text="رجوع",callback_data="/HelpList:"..data.sender_user_id_}}}
return https.request("https://api.telegram.org/bot"..TokenBot..'/editMessageText?chat_id='..Chat_Id2..'&message_id='..Msg_Id2..'&text=' .. URL.escape(Help or Text).."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
else
return https.request("https://api.telegram.org/bot"..TokenBot..'/answercallbackquery?callback_query_id='..data.id_..'&text='..URL.escape("✫ عذرا الامر ليس لك .")..'&show_alert=true')
end
end
if DataText and DataText:match('/HelpList4:(.*)') then
local Aeek = DataText:match('/HelpList4:(.*)')
if tonumber(Aeek) == tonumber(data.sender_user_id_) then
if not Admin(data) then
return https.request("https://api.telegram.org/bot"..TokenBot..'/answercallbackquery?callback_query_id='..data.id_..'&text='..URL.escape("✫ عذرا ليس لديك صلاحية التحكم لهذا الامر .")..'&show_alert=true')
end
local Help = DevAek:get(AEK..'Aek:Help4')
local Text = [[
✫︙اوامر المنشئين ↫ ⤈
━───━ ✫ ━───━
✫︙تنزيل الكل
✫︙اضف • حذف ↫ امر
✫︙حذف الاوامر المضافه
✫︙الاوامر المضافه
✫︙اضف نقاط ↫ بالرد • بالايدي
✫︙اضف رسائل ↫ بالرد • بالايدي
✫︙رفع مدير • تنزيل مدير
✫︙المدراء • حذف المدراء
✫︙تفعيل • تعطيل + الامر ↫ ⤈
✫︙نزلني
✫︙الحظر • الكتم
✫︙كتم الاسم
━───━ ✫ ━───━
✫︙اوامر المنشئين الاساسيين ↫ ⤈
━───━ ✫ ━───━
✫︙وضع لقب + اللقب
✫︙تفعيل • تعطيل ↫ الرفع
✫︙رفع منشئ • تنزيل منشئ
✫︙المنشئين • حذف المنشئين
✫︙رفع • تنزيل ↫ مشرف
✫︙رفع بكل الصلاحيات
✫︙حذف القوائم
━───━ ✫ ━───━
✫︙اوامر منشئ المجموعه ↫ ⤈
━───━ ✫ ━───━
✫︙رفع • تنزيل ↫ منشئ اساسي
✫︙حذف المنشئين الاساسيين 
✫︙المنشئين الاساسيين 
✫︙حذف • مسح ↫ الاسماء المكتومه
✫︙حذف جميع الرتب
━───━ ✫ ━───━
✫︙[‹  𝖲𝗈𝗎𝗋𝖼𝖾 𝙄𝘽𝙊 ›](https://t.me/HH_418)
]]
keyboard = {} 
keyboard.inline_keyboard = {{{text="اوامر الادمنيه",callback_data="/HelpList2:"..data.sender_user_id_},{text="اوامر الحمايه",callback_data="/HelpList1:"..data.sender_user_id_}},{{text="اوامر المدراء",callback_data="/HelpList3:"..data.sender_user_id_}},{{text="اوامر الاعضاء",callback_data="/HelpList6:"..data.sender_user_id_},{text="اوامر المطورين",callback_data="/HelpList5:"..data.sender_user_id_}},{{text="اخفاء القائمه",callback_data="/HideHelpList:"..data.sender_user_id_}},{{text="رجوع",callback_data="/HelpList:"..data.sender_user_id_}}}
return https.request("https://api.telegram.org/bot"..TokenBot..'/editMessageText?chat_id='..Chat_Id2..'&message_id='..Msg_Id2..'&text=' .. URL.escape(Help or Text).."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
else
return https.request("https://api.telegram.org/bot"..TokenBot..'/answercallbackquery?callback_query_id='..data.id_..'&text='..URL.escape("✫ عذرا الامر ليس لك .")..'&show_alert=true')
end
end
if DataText and DataText:match('/HelpList5:(.*)') then
local Aeek = DataText:match('/HelpList5:(.*)')
if tonumber(Aeek) == tonumber(data.sender_user_id_) then
if not SudoBot(data) then
return https.request("https://api.telegram.org/bot"..TokenBot..'/answercallbackquery?callback_query_id='..data.id_..'&text='..URL.escape("✫ عذرا ليس لديك صلاحية التحكم لهذا الامر .")..'&show_alert=true')
end
local Help = DevAek:get(AEK..'Aek:Help5')
local Text = [[
✫︙اوامر المطورين ↫ ⤈
━───━ ✫ ━───━
✫︙الكروبات
✫︙المطورين
✫︙المشتركين
✫︙الاحصائيات
✫︙المجموعات
✫︙اسم البوت + غادر
✫︙اسم البوت + تعطيل
✫︙كشف + -ايدي المجموعه
✫︙رفع مالك • تنزيل مالك
✫︙المالكين • حذف المالكين
━───━ ✫ ━───━
✫︙رفع • تنزيل ↫ مدير عام
✫︙حذف • المدراء العامين 
✫︙رفع • تنزيل ↫ ادمن عام
✫︙حذف • الادمنيه العامين 
✫︙رفع • تنزيل ↫ مميز عام
✫︙حذف • المميزين عام 
━───━ ✫ ━───━
✫︙اوامر المطور الاساسي ↫ ⤈
━───━ ✫ ━───━
✫︙تحديث
✫︙الملفات
✫︙المتجر
✫︙السيرفر
✫︙روابط الكروبات
✫︙تحديث السورس
✫︙تنظيف الكروبات
✫︙تنظيف المشتركين
✫︙حذف جميع الملفات
✫︙تعيين الايدي العام
✫︙تغير المطور الاساسي
✫︙حذف معلومات الترحيب
✫︙تغير معلومات الترحيب
✫︙غادر + -ايدي المجموعه
✫︙تعيين عدد الاعضاء + العدد
✫︙حظر عام • الغاء العام
✫︙كتم عام • الغاء العام
✫︙قائمه العام • حذف قائمه العام
✫︙وضع • حذف ↫ اسم البوت
✫︙اضف • حذف ↫ رد عام
✫︙ردود المطور • حذف ردود المطور
✫︙تعيين • حذف • جلب ↫ رد الخاص
✫︙جلب نسخه الكروبات
✫︙رفع النسخه + بالرد على الملف
✫︙تعيين • حذف ↫ قناة الاشتراك
✫︙جلب كليشه الاشتراك
✫︙تغيير • حذف ↫ كليشه الاشتراك
✫︙رفع • تنزيل ↫ مطور
✫︙المطورين • حذف المطورين
✫︙رفع • تنزيل ↫ مطور ثانوي
✫︙الثانويين • حذف الثانويين
✫︙تعيين • حذف ↫ كليشة الايدي
✫︙اذاعه للكل بالتوجيه ↫ بالرد
━───━ ✫ ━───━
✫︙تفعيل ملف + اسم الملف
✫︙تعطيل ملف + اسم الملف
✫︙تفعيل • تعطيل + الامر ↫ ⤈
✫︙الاذاعه • الاشتراك الاجباري
✫︙ترحيب البوت • المغادره
✫︙البوت الخدمي • التواصل
━───━ ✫ ━───━
✫︙[‹  𝖲𝗈𝗎𝗋𝖼𝖾 𝙄𝘽𝙊 ›](https://t.me/HH_418)
]]
keyboard = {} 
keyboard.inline_keyboard = {{{text="اوامر الادمنيه",callback_data="/HelpList2:"..data.sender_user_id_},{text="اوامر الحمايه",callback_data="/HelpList1:"..data.sender_user_id_}},{{text="اوامر المنشئين",callback_data="/HelpList4:"..data.sender_user_id_},{text="اوامر المدراء",callback_data="/HelpList3:"..data.sender_user_id_}},{{text="اوامر الاعضاء",callback_data="/HelpList6:"..data.sender_user_id_}},{{text="اخفاء القائمه",callback_data="/HideHelpList:"..data.sender_user_id_}},{{text="رجوع",callback_data="/HelpList:"..data.sender_user_id_}}}
return https.request("https://api.telegram.org/bot"..TokenBot..'/editMessageText?chat_id='..Chat_Id2..'&message_id='..Msg_Id2..'&text=' .. URL.escape(Help or Text).."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
else
return https.request("https://api.telegram.org/bot"..TokenBot..'/answercallbackquery?callback_query_id='..data.id_..'&text='..URL.escape("✫ عذرا الامر ليس لك .")..'&show_alert=true')
end
end
if DataText and DataText:match('/HelpList6:(.*)') then
local Aeek = DataText:match('/HelpList6:(.*)')
if tonumber(Aeek) == tonumber(data.sender_user_id_) then
local Help = DevAek:get(AEK..'Aek:Help6')
local Text = [[
✫︙اوامر الاعضاء ↫ ⤈
━───━ ✫ ━───━
✫︙السورس • موقعي • رتبتي • معلوماتي
✫︙رسائلي • حذف رسائلي • اسمي • معرفي 
✫︙ايدي •ايديي • جهاتي • غنيلي • الالعاب 
✫︙نقاطي • بيع نقاطي • القوانين • زخرفه 
✫︙رابط الحذف • نزلني • اطردني • المطور 
✫︙منو ضافني • مشاهدات المنشور • الرابط 
✫︙رقمي • ايدي المجموعه • معلومات المجموعه 
✫︙نسبه الحب • نسبه الكره • نسبه الغباء 
✫︙نسبه الرجوله • نسبه الانوثه • التفاعل
━───━ ✫ ━───━
✫︙صلاحياتي
✫︙كول + الكلمه
✫︙زخرفه + اسمك
✫︙برج + نوع البرج
✫︙معنى اسم + الاسم
✫︙احسب + تاريخ ميلادك
✫︙الحساب + ايدي الحساب
✫︙بوسه • بوسها ↫ بالرد
✫︙رفع مطي • تنزيل مطي •المطايه
✫︙هينه • هينها ↫ بالرد • بالمعرف
✫︙صيحه • صيحها ↫ بالرد • بالمعرف
✫︙صلاحياته ↫ بالرد • بالمعرف • بالايدي
✫︙ايدي • كشف  ↫ بالرد • بالمعرف • بالايدي
✫︙تحويل + بالرد ↫ صوره • ملصق • صوت • بصمه
━───━ ✫ ━───━
✫︙[‹  𝖲𝗈𝗎𝗋𝖼𝖾 𝙄𝘽𝙊 ›](https://t.me/HH_418)
]]
keyboard = {} 
keyboard.inline_keyboard = {{{text="اوامر الادمنيه",callback_data="/HelpList2:"..data.sender_user_id_},{text="اوامر الحمايه",callback_data="/HelpList1:"..data.sender_user_id_}},{{text="اوامر المنشئين",callback_data="/HelpList4:"..data.sender_user_id_},{text="اوامر المدراء",callback_data="/HelpList3:"..data.sender_user_id_}},{{text="اوامر المطورين",callback_data="/HelpList5:"..data.sender_user_id_}},{{text="اخفاء القائمه",callback_data="/HideHelpList:"..data.sender_user_id_}},{{text="رجوع",callback_data="/HelpList:"..data.sender_user_id_}}}
return https.request("https://api.telegram.org/bot"..TokenBot..'/editMessageText?chat_id='..Chat_Id2..'&message_id='..Msg_Id2..'&text=' .. URL.escape(Help or Text).."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
else
return https.request("https://api.telegram.org/bot"..TokenBot..'/answercallbackquery?callback_query_id='..data.id_..'&text='..URL.escape("✫ عذرا الامر ليس لك .")..'&show_alert=true')
end
end
end

if (data.ID == "UpdateNewMessage") then
local msg = data.message_
text = msg.content_.text_ 
if text and DevAek:get(AEK.."Del:Cmd:Group"..msg.chat_id_..":"..msg.sender_user_id_) == "true" then
local NewCmmd = DevAek:get(AEK.."Set:Cmd:Group:New1"..msg.chat_id_..":"..text)
if NewCmmd then
DevAek:del(AEK.."Set:Cmd:Group:New1"..msg.chat_id_..":"..text)
DevAek:del(AEK.."Set:Cmd:Group:New"..msg.chat_id_)
DevAek:srem(AEK.."List:Cmd:Group:New"..msg.chat_id_,text)
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙تم حذف الامر من المجموعه", 1, 'html')  
else
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙لايوجد امر بهذا الاسم", 1, 'html')
end
DevAek:del(AEK.."Del:Cmd:Group"..msg.chat_id_..":"..msg.sender_user_id_)
return false
end
if text and text:match('^'..(DevAek:get(AEK..'Aek:NameBot') or "ايبو")..' ') then
data.message_.content_.text_ = data.message_.content_.text_:gsub('^'..(DevAek:get(AEK..'Aek:NameBot') or "ايبو")..' ','')
end
if data.message_.content_.text_ then
local NewCmmd = DevAek:get(AEK.."Set:Cmd:Group:New1"..msg.chat_id_..":"..data.message_.content_.text_)
if NewCmmd then
data.message_.content_.text_ = (NewCmmd or data.message_.content_.text_)
end
end
if text and DevAek:get(AEK.."Set:Cmd:Group"..msg.chat_id_..":"..msg.sender_user_id_) == "true" then
DevAek:set(AEK.."Set:Cmd:Group:New"..msg.chat_id_,text)
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙ارسل الامر الجديد", 1, 'html')
DevAek:del(AEK.."Set:Cmd:Group"..msg.chat_id_..":"..msg.sender_user_id_)
DevAek:set(AEK.."Set:Cmd:Group1"..msg.chat_id_..":"..msg.sender_user_id_,"true1") 
return false
end
if text and DevAek:get(AEK.."Set:Cmd:Group1"..msg.chat_id_..":"..msg.sender_user_id_) == "true1" then
local NewCmd = DevAek:get(AEK.."Set:Cmd:Group:New"..msg.chat_id_)
DevAek:set(AEK.."Set:Cmd:Group:New1"..msg.chat_id_..":"..text,NewCmd)
DevAek:sadd(AEK.."List:Cmd:Group:New"..msg.chat_id_,text)
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙تم حفظ الامر", 1, 'html')
DevAek:del(AEK.."Set:Cmd:Group1"..msg.chat_id_..":"..msg.sender_user_id_)
return false
end
if Constructor(msg) then
if text == "الاوامر المضافه" and SourcelionCh(msg) then
local List = DevAek:smembers(AEK.."List:Cmd:Group:New"..msg.chat_id_.."") 
t = "✫︙قائمة الاوامر المضافه ↫ ⤈ \n━───━ ✫ ━───━\n"
for k,v in pairs(List) do
Cmds = DevAek:get(AEK.."Set:Cmd:Group:New1"..msg.chat_id_..":"..v)
if Cmds then 
t = t..""..k.."~ ("..v..") • {"..Cmds.."}\n"
else
t = t..""..k.."~ ("..v..") \n"
end
end
if #List == 0 then
t = "✫︙لاتوجد اوامر مضافه في المجموعه"
end
Dev_Aek(msg.chat_id_, msg.id_, 1, t, 1, 'html')
end
if text == "حذف الاوامر المضافه" and SourcelionCh(msg) or text == "حذف الاوامر" and SourcelionCh(msg) or text == "مسح الاوامر المضافه" and SourcelionCh(msg) then
local List = DevAek:smembers(AEK.."List:Cmd:Group:New"..msg.chat_id_)
for k,v in pairs(List) do
DevAek:del(AEK.."Set:Cmd:Group:New1"..msg.chat_id_..":"..v)
DevAek:del(AEK.."List:Cmd:Group:New"..msg.chat_id_)
end
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙تم حذف الاوامر المضافه في المجموعه", 1, 'html')
end
if text == "ترتيب الاوامر" then
DevAek:set(AEK.."Set:Cmd:Group:New1"..msg.chat_id_..":ا","ايدي")
DevAek:sadd(AEK.."List:Cmd:Group:New"..msg.chat_id_,"ا")
DevAek:set(AEK.."Set:Cmd:Group:New1"..msg.chat_id_..":م","رفع مميز")
DevAek:sadd(AEK.."List:Cmd:Group:New"..msg.chat_id_,"م")
DevAek:set(AEK.."Set:Cmd:Group:New1"..msg.chat_id_..":اد","رفع ادمن")
DevAek:sadd(AEK.."List:Cmd:Group:New"..msg.chat_id_,"اد")
DevAek:set(AEK.."Set:Cmd:Group:New1"..msg.chat_id_..":مد","رفع مدير")
DevAek:sadd(AEK.."List:Cmd:Group:New"..msg.chat_id_,"مد")
DevAek:set(AEK.."Set:Cmd:Group:New1"..msg.chat_id_..":من","رفع منشئ")
DevAek:sadd(AEK.."List:Cmd:Group:New"..msg.chat_id_,"من")
DevAek:set(AEK.."Set:Cmd:Group:New1"..msg.chat_id_..":اس","رفع منشئ اساسي")
DevAek:sadd(AEK.."List:Cmd:Group:New"..msg.chat_id_,"اس")
DevAek:set(AEK.."Set:Cmd:Group:New1"..msg.chat_id_..":مط","رفع مطور")
DevAek:sadd(AEK.."List:Cmd:Group:New"..msg.chat_id_,"مط")
DevAek:set(AEK.."Set:Cmd:Group:New1"..msg.chat_id_..":ثانوي","رفع مطور ثانوي")
DevAek:sadd(AEK.."List:Cmd:Group:New"..msg.chat_id_,"ثانوي")
DevAek:set(AEK.."Set:Cmd:Group:New1"..msg.chat_id_..":تك","تنزيل الكل")
DevAek:sadd(AEK.."List:Cmd:Group:New"..msg.chat_id_,"تك")
DevAek:set(AEK.."Set:Cmd:Group:New1"..msg.chat_id_..":تعط","تعطيل الايدي بالصوره")
DevAek:sadd(AEK.."List:Cmd:Group:New"..msg.chat_id_,"تعط")
DevAek:set(AEK.."Set:Cmd:Group:New1"..msg.chat_id_..":تفع","تفعيل الايدي بالصوره")
DevAek:sadd(AEK.."List:Cmd:Group:New"..msg.chat_id_,"تفع")
DevAek:set(AEK.."Set:Cmd:Group:New1"..msg.chat_id_..":ر","الرابط")
DevAek:sadd(AEK.."List:Cmd:Group:New"..msg.chat_id_,"ر")
DevAek:set(AEK.."Set:Cmd:Group:New1"..msg.chat_id_..":رر","ردود المدير")
DevAek:sadd(AEK.."List:Cmd:Group:New"..msg.chat_id_,"رر")
DevAek:set(AEK.."Set:Cmd:Group:New1"..msg.chat_id_..":،،","مسح المكتومين")
DevAek:sadd(AEK.."List:Cmd:Group:New"..msg.chat_id_,"،،")
DevAek:set(AEK.."Set:Cmd:Group:New1"..msg.chat_id_..":رد","اضف رد")
DevAek:sadd(AEK.."List:Cmd:Group:New"..msg.chat_id_,"رد")
DevAek:set(AEK.."Set:Cmd:Group:New1"..msg.chat_id_..":سح","مسح سحكاتي")
DevAek:sadd(AEK.."List:Cmd:Group:New"..msg.chat_id_,"سح")
DevAek:set(AEK.."Set:Cmd:Group:New1"..msg.chat_id_..":رس","مسح رسائلي")
DevAek:sadd(AEK.."List:Cmd:Group:New"..msg.chat_id_,"رس")
DevAek:set(AEK.."Set:Cmd:Group:New1"..msg.chat_id_..":غ","غنيلي")
DevAek:sadd(AEK.."List:Cmd:Group:New"..msg.chat_id_,"غ")
DevAek:set(AEK.."Set:Cmd:Group:New1"..msg.chat_id_..":#","مسح قائمه العام")
DevAek:sadd(AEK.."List:Cmd:Group:New"..msg.chat_id_,"#")
send(msg.chat_id_, msg.id_,"✫︙تم ترتيب الاوامر بالشكل التالي ~\n✫︙ايدي - ا .\n✫︙رفع مميز - م .\n✫︙رفع ادمن - اد .\n✫︙رفع مدير - مد . \n✫︙رفع منشى - من . \n✫︙رفع منشئ الاساسي - اس  .\n✫︙رفع مطور - مط .\n✫︙رفع مطور ثانوي - ثانوي .\n✫︙تنزيل الكل - تك .\n✫︙تعطيل الايدي بالصوره - تعط .\n✫︙تفعيل الايدي بالصوره - تفع .\n✫︙الرابط - ر .\n✫︙ردود المدير - رر .\n✫︙مسح المكتومين - ،، .\n✫︙اضف رد - رد .\n✫︙مسح سحكاتي - سح .\n✫︙مسح رسائلي - رس .\n✫︙غنيلي - غ .\n✫︙مسح قائمه العام - # .")  
end
if text == "اضف امر" and SourcelionCh(msg) or text == "اضافة امر" and SourcelionCh(msg) or text == "اضافه امر" and SourcelionCh(msg) then
DevAek:set(AEK.."Set:Cmd:Group"..msg.chat_id_..":"..msg.sender_user_id_,"true") 
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙ارسل الامر القديم", 1, 'html')
return false
end
if text == "حذف امر" and SourcelionCh(msg) or text == "مسح امر" and SourcelionCh(msg) then 
DevAek:set(AEK.."Del:Cmd:Group"..msg.chat_id_..":"..msg.sender_user_id_,"true") 
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙ارسل الامر الذي قمت باضافته يدويا", 1, 'html')
return false
end
end

if text == "الصلاحيات" and SourcelionCh(msg) or text == "صلاحيات" and SourcelionCh(msg) then 
local List = DevAek:smembers(AEK.."Coomds"..msg.chat_id_)
if #List == 0 then
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙لاتوجد صلاحيات مضافه", 1, 'html')
return false
end
t = "✫︙قائمة الصلاحيات المضافه ↫ ⤈ \n━───━ ✫ ━───━\n"
for k,v in pairs(List) do
var = DevAek:get(AEK.."Comd:New:rt:Aek:"..v..msg.chat_id_)
if var then
t = t..""..k.."~ "..v.." • ("..var..")\n"
else
t = t..""..k.."~ "..v.."\n"
end
end
Dev_Aek(msg.chat_id_, msg.id_, 1, t, 1, 'html')
end
if Admin(msg) then
if text == "حذف الصلاحيات" and SourcelionCh(msg) or text == "مسح الصلاحيات" and SourcelionCh(msg) then
local List = DevAek:smembers(AEK.."Coomds"..msg.chat_id_)
for k,v in pairs(List) do
DevAek:del(AEK.."Comd:New:rt:Aek:"..v..msg.chat_id_)
DevAek:del(AEK.."Coomds"..msg.chat_id_)
end
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙تم حذف الصلاحيات المضافه", 1, 'html')
end
end
if text and text:match("^اضف صلاحيه (.*)$") and SourcelionCh(msg) then 
ComdNew = text:match("^اضف صلاحيه (.*)$")
DevAek:set(AEK.."Comd:New:rt"..msg.chat_id_..msg.sender_user_id_,ComdNew)  
DevAek:sadd(AEK.."Coomds"..msg.chat_id_,ComdNew)  
DevAek:setex(AEK.."Comd:New"..msg.chat_id_..""..msg.sender_user_id_,200,true)  
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙ارسل نوع الصلاحيه \n{ عضو • مميز  • ادمن  • مدير }\n✫︙ارسل الغاء لالغاء الامر ", 1, 'html')
end
if text and text:match("^حذف صلاحيه (.*)$") and SourcelionCh(msg) or text and text:match("^مسح صلاحيه (.*)$") and SourcelionCh(msg) then 
ComdNew = text:match("^حذف صلاحيه (.*)$") or text:match("^مسح صلاحيه (.*)$")
DevAek:del(AEK.."Comd:New:rt:Aek:"..ComdNew..msg.chat_id_)
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙تم حذف الصلاحيه", 1, 'html')
end
if DevAek:get(AEK.."Comd:New"..msg.chat_id_..""..msg.sender_user_id_) then 
if text and text:match("^الغاء$") then 
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙تم الغاء الامر", 1, 'html')
DevAek:del(AEK.."Comd:New"..msg.chat_id_..""..msg.sender_user_id_) 
return false  
end 
if text == "مدير" then
if not Constructor(msg) then
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙تستطيع اضافة صلاحية ( عضو • مميز  • ادمن )\n✫︙ارسال نوع الصلاحيه مره اخرى", 1, 'html')
return false
end
end
if text == "ادمن" then
if not Manager(msg) then 
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙تستطيع اضافة صلاحية ( عضو • مميز )\n✫︙ارسال نوع الصلاحيه مره اخرى", 1, 'html')
return false
end
end
if text == "مميز" then
if not Admin(msg) then
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙تستطيع اضافة صلاحية ( عضو )\n✫︙ارسال نوع الصلاحيه مره اخرى", 1, 'html')
return false
end
end
if text == "مدير" or text == "ادمن" or text == "مميز" or text == "عضو" then
local textn = DevAek:get(AEK.."Comd:New:rt"..msg.chat_id_..msg.sender_user_id_)  
DevAek:set(AEK.."Comd:New:rt:Aek:"..textn..msg.chat_id_,text)
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙تم اضافة الصلاحيه", 1, 'html')
DevAek:del(AEK.."Comd:New"..msg.chat_id_..""..msg.sender_user_id_) 
return false  
end 
end

if text and text:match("رفع (.*)") and tonumber(msg.reply_to_message_id_) > 0 then 
local DEV_AEEKAN = text:match("رفع (.*)")
if DevAek:sismember(AEK.."Coomds"..msg.chat_id_,DEV_AEEKAN) then
function by_reply(extra, result, success)   
tdcli_function ({ID = "GetUser",user_id_ = result.sender_user_id_},function(arg,data) 
local mrAek = DevAek:get(AEK.."Comd:New:rt:Aek:"..DEV_AEEKAN..msg.chat_id_)
if mrAek == "مميز" and VipMem(msg) then
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙العضو ↫ ❨ ['..data.first_name_..'](t.me/'..(data.username_ or 'HH_418')..')'..' ❩\n✫︙تم رفعه ❨ '..DEV_AEEKAN..' ❩ بنجاح', 1, 'md')
DevAek:set(AEK.."Comd:New:rt:User:"..msg.chat_id_..result.sender_user_id_,DEV_AEEKAN) 
DevAek:sadd(AEK..'Aek:VipMem:'..msg.chat_id_, result.sender_user_id_)
elseif mrAek == "ادمن" and Admin(msg) then 
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙العضو ↫ ❨ ['..data.first_name_..'](t.me/'..(data.username_ or 'HH_418')..')'..' ❩\n✫︙تم رفعه ❨ '..DEV_AEEKAN..' ❩ بنجاح', 1, 'md')
DevAek:set(AEK.."Comd:New:rt:User:"..msg.chat_id_..result.sender_user_id_,DEV_AEEKAN)
DevAek:sadd(AEK..'Aek:Admins:'..msg.chat_id_, result.sender_user_id_)
elseif mrAek == "مدير" and Manager(msg) then
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙العضو ↫ ❨ ['..data.first_name_..'](t.me/'..(data.username_ or 'HH_418')..')'..' ❩\n✫︙تم رفعه ❨ '..DEV_AEEKAN..' ❩ بنجاح', 1, 'md')
DevAek:set(AEK.."Comd:New:rt:User:"..msg.chat_id_..result.sender_user_id_,DEV_AEEKAN)  
DevAek:sadd(AEK..'Aek:Managers:'..msg.chat_id_, result.sender_user_id_)
elseif mrAek == "عضو" then
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙العضو ↫ ❨ ['..data.first_name_..'](t.me/'..(data.username_ or 'HH_418')..')'..' ❩\n✫︙تم رفعه ❨ '..DEV_AEEKAN..' ❩ بنجاح', 1, 'md')
end
end,nil)   
end   
tdcli_function ({ ID = "GetMessage", chat_id_ = msg.chat_id_, message_id_ = tonumber(msg.reply_to_message_id_) }, by_reply, nil)
end
end
if text and text:match("تنزيل (.*)") and tonumber(msg.reply_to_message_id_) > 0 then 
local DEV_AEEKAN = text:match("تنزيل (.*)")
if DevAek:sismember(AEK.."Coomds"..msg.chat_id_,DEV_AEEKAN) then
function by_reply(extra, result, success)   
tdcli_function ({ID = "GetUser",user_id_ = result.sender_user_id_},function(arg,data) 
local mrAek = DevAek:get(AEK.."Comd:New:rt:Aek:"..DEV_AEEKAN..msg.chat_id_)
if mrAek == "مميز" and VipMem(msg) then
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙العضو ↫ ❨ ['..data.first_name_..'](t.me/'..(data.username_ or 'HH_418')..')'..' ❩\n✫︙تم تنزيله ❨ '..DEV_AEEKAN..' ❩ بنجاح', 1, 'md')
DevAek:srem(AEK..'Aek:VipMem:'..msg.chat_id_, result.sender_user_id_)
DevAek:del(AEK.."Comd:New:rt:User:"..msg.chat_id_..result.sender_user_id_)
elseif mrAek == "ادمن" and Admin(msg) then 
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙العضو ↫ ❨ ['..data.first_name_..'](t.me/'..(data.username_ or 'HH_418')..')'..' ❩\n✫︙تم تنزيله ❨ '..DEV_AEEKAN..' ❩ بنجاح', 1, 'md')
DevAek:srem(AEK..'Aek:Admins:'..msg.chat_id_, result.sender_user_id_)
DevAek:del(AEK.."Comd:New:rt:User:"..msg.chat_id_..result.sender_user_id_)
elseif mrAek == "مدير" and Manager(msg) then
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙العضو ↫ ❨ ['..data.first_name_..'](t.me/'..(data.username_ or 'HH_418')..')'..' ❩\n✫︙تم تنزيله ❨ '..DEV_AEEKAN..' ❩ بنجاح', 1, 'md')
DevAek:srem(AEK..'Aek:Managers:'..msg.chat_id_, result.sender_user_id_)
DevAek:del(AEK.."Comd:New:rt:User:"..msg.chat_id_..result.sender_user_id_)
elseif mrAek == "عضو" then
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙العضو ↫ ❨ ['..data.first_name_..'](t.me/'..(data.username_ or 'HH_418')..')'..' ❩\n✫︙تم تنزيله ❨ '..DEV_AEEKAN..' ❩ بنجاح', 1, 'md')
end
end,nil)   
end   
tdcli_function ({ ID = "GetMessage", chat_id_ = msg.chat_id_, message_id_ = tonumber(msg.reply_to_message_id_) }, by_reply, nil)
end
end
if text and text:match("^رفع (.*) @(.*)") then 
local text1 = {string.match(text, "^(رفع) (.*) @(.*)$")}
if DevAek:sismember(AEK.."Coomds"..msg.chat_id_,text1[2]) then
function py_username(extra, result, success)   
if result.id_ then
local mrAek = DevAek:get(AEK.."Comd:New:rt:Aek:"..text1[2]..msg.chat_id_)
if mrAek == "مميز" and VipMem(msg) then
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙العضو ↫ ❨ ['..result.title_..'](t.me/'..(text1[3] or 'HH_418')..')'..' ❩\n✫︙تم رفعه ❨ '..text1[2]..' ❩ بنجاح', 1, 'md')
DevAek:sadd(AEK..'Aek:VipMem:'..msg.chat_id_, result.id_)
DevAek:set(AEK.."Comd:New:rt:User:"..msg.chat_id_..result.id_,text1[2])
elseif mrAek == "ادمن" and Admin(msg) then 
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙العضو ↫ ❨ ['..result.title_..'](t.me/'..(text1[3] or 'HH_418')..')'..' ❩\n✫︙تم رفعه ❨ '..text1[2]..' ❩ بنجاح', 1, 'md')
DevAek:sadd(AEK..'Aek:Admins:'..msg.chat_id_, result.id_)
DevAek:set(AEK.."Comd:New:rt:User:"..msg.chat_id_..result.id_,text1[2])
elseif mrAek == "مدير" and Manager(msg) then
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙العضو ↫ ❨ ['..result.title_..'](t.me/'..(text1[3] or 'HH_418')..')'..' ❩\n✫︙تم رفعه ❨ '..text1[2]..' ❩ بنجاح', 1, 'md')
DevAek:sadd(AEK..'Aek:Managers:'..msg.chat_id_, result.id_)
DevAek:set(AEK.."Comd:New:rt:User:"..msg.chat_id_..result.id_,text1[2])
elseif mrAek == "عضو" then
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙العضو ↫ ❨ ['..result.title_..'](t.me/'..(text1[3] or 'HH_418')..')'..' ❩\n✫︙تم رفعه ❨ '..text1[2]..' ❩ بنجاح', 1, 'md')
end
else
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙*المعرف غير صحيح*", 1, 'md')
end
end
tdcli_function ({ID = "SearchPublicChat",username_ = text1[3]},py_username,nil) 
end 
end
if text and text:match("^تنزيل (.*) @(.*)") then 
local text1 = {string.match(text, "^(تنزيل) (.*) @(.*)$")}
if DevAek:sismember(AEK.."Coomds"..msg.chat_id_,text1[2]) then
function py_username(extra, result, success)   
if result.id_ then
local mrAek = DevAek:get(AEK.."Comd:New:rt:Aek:"..text1[2]..msg.chat_id_)
if mrAek == "مميز" and VipMem(msg) then
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙العضو ↫ ❨ ['..result.title_..'](t.me/'..(text1[3] or 'HH_418')..')'..' ❩\n✫︙تم تنزيله ❨ '..text1[2]..' ❩ بنجاح', 1, 'md')
DevAek:srem(AEK..'Aek:VipMem:'..msg.chat_id_, result.id_)
DevAek:del(AEK.."Comd:New:rt:User:"..msg.chat_id_..result.id_)
elseif mrAek == "ادمن" and Admin(msg) then 
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙العضو ↫ ❨ ['..result.title_..'](t.me/'..(text1[3] or 'HH_418')..')'..' ❩\n✫︙تم تنزيله ❨ '..text1[2]..' ❩ بنجاح', 1, 'md')
DevAek:srem(AEK..'Aek:Admins:'..msg.chat_id_, result.id_)
DevAek:del(AEK.."Comd:New:rt:User:"..msg.chat_id_..result.id_)
elseif mrAek == "مدير" and Manager(msg) then
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙العضو ↫ ❨ ['..result.title_..'](t.me/'..(text1[3] or 'HH_418')..')'..' ❩\n✫︙تم تنزيله ❨ '..text1[2]..' ❩ بنجاح', 1, 'md')
DevAek:srem(AEK..'Aek:Managers:'..msg.chat_id_, result.id_)
DevAek:del(AEK.."Comd:New:rt:User:"..msg.chat_id_..result.id_)
elseif mrAek == "عضو" then
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙العضو ↫ ❨ ['..result.title_..'](t.me/'..(text1[3] or 'HH_418')..')'..' ❩\n✫︙تم تنزيله ❨ '..text1[2]..' ❩ بنجاح', 1, 'md')
end
else
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙*المعرف غير صحيح*", 1, 'md')
end
end
tdcli_function ({ID = "SearchPublicChat",username_ = text1[3]},py_username,nil) 
end  
end

if msg.chat_id_ then
local id = tostring(msg.chat_id_)
if id:match("-100(%d+)") then
DevAek:incr(AEK..'Aek:UsersMsgs'..AEK..os.date('%d')..':'..msg.chat_id_..':'..msg.sender_user_id_)
DevAek:incr(AEK..'Aek:UsersMsgs'..msg.chat_id_..':'..msg.sender_user_id_)
DevAek:incr(AEK..'Aek:MsgNumberDay'..msg.chat_id_..':'..os.date('%d'))  
ChatType = 'sp' 
elseif id:match("^(%d+)") then
if not DevAek:sismember(AEK.."Aek:Users",msg.chat_id_) then
DevAek:sadd(AEK.."Aek:Users",msg.chat_id_)
end
ChatType = 'pv' 
else
ChatType = 'gp' 
end
end 

if ChatType == 'pv' then 
if text == '/start' or text == 'رجوع ،??‘' then 
if SecondSudo(msg) then 
local Sudo_Welcome = '✫︙مرحبا عزيزي المطور \n✫︙انت المطور الاساسي هنا \n✫︙اليك ازرار سورس ايبو \n✫︙تستطيع التحكم بكل الاوامر فقط اضغط على الامر الذي تريد تنفيذه'
local key = {
{'وضع اسم البوت','↫ تحديث ✫','وضع كليشه المطور'},
{'↫ المطورين ✫','↫ الاحصائيات ✫'},
{'↫ المجموعات ✫','روابط الكروبات','↫ المشتركين ✫'},
{'↫ تعطيل التواصل ✫','↫ تفعيل التواصل ✫'},
{'تنظيف الكروبات','↫ قائمه العام ✫','تنظيف المشتركين'},
{'↫ تغير المطور الاساسي ✫'},
{'تعطيل ترحيب البوت','تفعيل ترحيب البوت'},
{'↫ تغير معلومات الترحيب ✫'},
{'↫ تعطيل المغادره ✫','↫ تفعيل المغادره ✫'},
{'↫ تعطيل الاذاعه ✫','↫ تفعيل الاذاعه ✫'},
{'↫ اذاعه بالتثبيت ✫'},
{'↫ اذاعه عام ✫','↫ اذاعه خاص ✫'},
{'↫ اذاعه عام بالتوجيه ✫','↫ اذاعه خاص بالتوجيه ✫'},
{'~ تعيين كلايش الاوامر ~'},
{'تعطيل البوت الخدمي','تفعيل البوت الخدمي'},
{'جلب نسخه السورس','تحديث السورس','جلب نسخه الكروبات'},
{'↫ حذف رد عام ✫','↫ الردود العام ✫','↫ اضف رد عام ✫'},
{'↫ حذف رد الخاص ✫','↫ تعيين رد الخاص ✫'},
{'حذف قناة الاشتراك','قناة الاشتراك','تعيين قناة الاشتراك'},
{'حذف كليشه الاشتراك','كليشه الاشتراك','تغير كليشه الاشتراك'},
}
SendInline(msg.chat_id_,Sudo_Welcome,key)
return false
end end
if text == '~ تعيين كلايش الاوامر ~' then 
if SecondSudo(msg) then 
local Sudo_Welcome = '✫︙اهلا بك مجددا عزيزي المطور \n✫︙اليك الازرار الخاصه بتعديل وتغيير كلايش سورس ايبو فقط اضغط على الامر الذي تريد تنفيذه'
local key = {
{'حذف كليشة الايدي','تعيين كليشة الايدي'},
{'تعيين امر الاوامر'},
{'تعيين امر م3','تعيين امر م2','تعيين امر م1'},
{'تعيين امر م6','تعيين امر م5','تعيين امر م4'},
{'استعادة كلايش الاوامر'},
{'رجوع ،🔙‘'},
}
SendInline(msg.chat_id_,Sudo_Welcome,key)
return false
end end
if text == '/start' and SourcelionCh(msg) then  
if not DevAek:get(AEK..'Aek:Start:Time'..msg.sender_user_id_) then
tdcli_function({ID="GetUser",user_id_=AEK},function(arg,dp) 
local inline = {{{text="✫ اضفني في مجموعتك ✫",url="t.me/"..dp.username_.."?startgroup=botstart"}}}
local start = DevAek:get(AEK.."Aek:Start:Bot")
if start then 
Start_Source = start
else
Start_Source = "✫︙مرحبا انا بوت اسمي "..NameBot.."\n✫︙اختصاصي حماية المجموعات\n✫︙من التفليش والسبام والخخ .. . ،\n✫︙تفعيلي سهل ومجانا فقط قم برفعي ادمن في مجموعتك وارسل امر ↫ تفعيل\n✫︙سيتم رفع الادمنيه والمنشئ تلقائيا"
end 
SendInline(msg.chat_id_,Start_Source,nil,inline)
end,nil)
end
DevAek:setex(AEK..'Aek:Start:Time'..msg.sender_user_id_,300,true)
return false
end 

if not SecondSudo(msg) and not DevAek:sismember(AEK..'Aek:Ban:Pv',msg.sender_user_id_) and not DevAek:get(AEK..'Aek:Texting:Pv') then
tdcli_function({ID="GetUser",user_id_=DevId},function(arg,chat) 
Dev_Aek(msg.sender_user_id_, msg.id_, 1, '✫︙تم ارسال رسالتك الى [المطور](t.me/'..(chat.username_ or "HH_418")..')', 1, 'md') 
tdcli_function({ID="ForwardMessages",chat_id_=DevId,from_chat_id_= msg.sender_user_id_,message_ids_={[0]=msg.id_},disable_notification_=1,from_background_=1},function(arg,data) 
tdcli_function({ID="GetUser",user_id_=msg.sender_user_id_},function(arg,dp) 
if data and data.messages_ and data.messages_[0] ~= false and data.ID ~= "Error" then
if data and data.messages_ and data.messages_[0].content_.sticker_ then
SendText(DevId,'✫︙تم ارسال الملصق من ↫ ⤈\n['..string.sub(dp.first_name_,0, 40)..'](tg://user?id='..dp.id_..')',0,'md') 
return false
end;end;end,nil);end,nil);end,nil);end
if SecondSudo(msg) and msg.reply_to_message_id_ ~= 0  then    
tdcli_function({ID = "GetMessage",chat_id_ = msg.chat_id_,message_id_ = tonumber(msg.reply_to_message_id_)},function(extra, result, success) 
if result.forward_info_.sender_user_id_ then     
id_user = result.forward_info_.sender_user_id_    
end 
tdcli_function ({ID = "GetUser",user_id_ = id_user},function(arg,data) 
if text == 'حظر' or text == 'حضر' then
local Text = '✫︙العضو ↫ ['..string.sub(data.first_name_,0, 40)..'](tg://user?id='..data.id_..')'..'\n✫︙تم حظره من التواصل'
SendText(DevId,Text,msg.id_/2097152/0.5,'md') 
DevAek:sadd(AEK..'Aek:Ban:Pv',data.id_)  
return false  
end 
if text == 'الغاء الحظر' or text == 'الغاء حظر' then
local Text = '✫︙العضو ↫ ['..string.sub(data.first_name_,0, 40)..'](tg://user?id='..data.id_..')'..'\n✫︙تم الغاء حظره من التواصل'
SendText(DevId,Text,msg.id_/2097152/0.5,'md') 
DevAek:srem(AEK..'Aek:Ban:Pv',data.id_)  
return false  
end 
tdcli_function({ID='GetChat',chat_id_ = id_user},function(arg,dataq)
tdcli_function ({ ID = "SendChatAction",chat_id_ = id_user, action_ = {  ID = "SendMessageTypingAction", progress_ = 100} },function(arg,dp) 
if dp.code_ == 400 or dp.code_ == 5 then
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙العضو قام بحظر البوت لا تستطيع ارسال الرسائل له', 1, 'md')
return false  
end 
if text then
Dev_Aek(id_user, 0, 1, text, 1, "md")  
Text = '✫︙تم ارسال الرساله الى ↫ ⤈'
elseif msg.content_.ID == 'MessageSticker' then    
sendSticker(id_user, msg.id_, 0, 1,nil, msg.content_.sticker_.sticker_.persistent_id_)   
Text = '✫︙تم ارسال الملصق الى ↫ ⤈'
elseif msg.content_.ID == 'MessagePhoto' then    
sendPhoto(id_user, msg.id_, 0, 1,nil, msg.content_.photo_.sizes_[0].photo_.persistent_id_,(msg.content_.caption_ or ''))    
Text = '✫︙تم ارسال الصوره الى ↫ ⤈'
elseif msg.content_.ID == 'MessageAnimation' then    
sendDocument(id_user, msg.id_, 0, 1,nil, msg.content_.animation_.animation_.persistent_id_)    
Text = '✫︙تم ارسال المتحركه الى ↫ ⤈'
elseif msg.content_.ID == 'MessageVoice' then    
sendVoice(id_user, msg.id_, 0, 1,nil, msg.content_.voice_.voice_.persistent_id_)    
Text = '✫︙تم ارسال البصمه الى ↫ ⤈'
end     
SendText(DevId, Text..'\n'..'['..string.sub(data.first_name_,0, 40)..'](tg://user?id='..data.id_..')',0,'md') 
end,nil);
end,nil);
end,nil);
end,nil);
end 
end 

if text and DevAek:get(AEK..'Aek:Start:Bots'..msg.sender_user_id_) then
if text == 'الغاء' then   
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙تم الغاء حفظ كليشة الستارت', 1, 'md')
DevAek:del(AEK..'Aek:Start:Bots'..msg.sender_user_id_) 
return false
end
DevAek:set(AEK.."Aek:Start:Bot",text)  
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙تم حفظ كليشة الستارت', 1, 'md')
DevAek:del(AEK..'Aek:Start:Bots'..msg.sender_user_id_) 
return false
end
if SecondSudo(msg) then
if text == 'تعيين رد الخاص' or text == 'ضع كليشه ستارت' or text == '↫ تعيين رد الخاص ✫' then 
DevAek:set(AEK..'Aek:Start:Bots'..msg.sender_user_id_,true) 
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙ارسل لي كليشة الستارت الان', 1, 'md')
return false
end
if text == 'حذف رد الخاص' or text == 'حذف كليشه ستارت' or text == '↫ حذف رد الخاص ✫' then 
DevAek:del(AEK..'Start:Bot') 
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙تم حذف كليشة الستارت بنجاح', 1, 'md')
end
if text == 'جلب رد الخاص' then  
local start = DevAek:get(AEK.."Aek:Start:Bot")
if start then 
Start_Source = start
else
Start_Source = "✫︙مرحبا انا بوت اسمي "..NameBot.."\n✫︙اختصاصي حماية المجموعات\n✫︙من التفليش والسبام والخخ .. . ،\n✫︙تفعيلي سهل ومجانا فقط قم برفعي ادمن في مجموعتك وارسل امر ↫ تفعيل\n✫︙سيتم رفع الادمنيه والمنشئ تلقائيا"
end 
Dev_Aek(msg.chat_id_, msg.id_, 1, Start_Source, 1, 'md')
return false
end
if text == 'تفعيل التواصل' or text == '↫ تفعيل التواصل ✫' then   
local AEKTEAM = '✫︙اهلا عزيزي ↫ '..AekRank(msg)..' \n✫︙تم تفعيل التواصل بنجاح'
Aekmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, AEKTEAM, 14, string.len(msg.sender_user_id_))
DevAek:del(AEK..'Aek:Texting:Pv') 
end
if text == 'تعطيل التواصل' or text == '↫ تعطيل التواصل ✫' then  
local AEKTEAM = '✫︙اهلا عزيزي ↫ '..AekRank(msg)..' \n✫︙تم تعطيل التواصل بنجاح'
Aekmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, AEKTEAM, 14, string.len(msg.sender_user_id_))
DevAek:set(AEK..'Aek:Texting:Pv',true) 
end
end

function getUser(user_id, cb)
tdcli_function ({
ID = "GetUser",
user_id_ = user_id
}, cb, nil)
end
local msg = data.message_
text = msg.content_.text_
if msg.content_.ID == "MessageChatAddMembers" then 
DevAek:incr(AEK..'Aek:ContactNumber'..msg.chat_id_..':'..msg.sender_user_id_)
DevAek:set(AEK.."Who:Added:Me"..msg.chat_id_..':'..msg.content_.members_[0].id_,msg.sender_user_id_)
local mem_id = msg.content_.members_  
local Bots = DevAek:get(AEK.."Aek:Lock:Bots"..msg.chat_id_) 
for i=0,#mem_id do  
if msg.content_.members_[i].type_.ID == "UserTypeBot" and Bots == "kick" and not VipMem(msg) then   
https.request("https://api.telegram.org/bot"..TokenBot.."/kickChatMember?chat_id="..msg.chat_id_.."&user_id="..msg.sender_user_id_)
GetInfo = https.request("https://api.telegram.org/bot"..TokenBot.."/kickChatMember?chat_id="..msg.chat_id_.."&user_id="..mem_id[i].id_)
local JsonInfo = JSON.decode(GetInfo)
if JsonInfo.ok == true and #mem_id == i then
local Msgs = {}
Msgs[0] = msg.id_
msgs_id = msg.id_-1048576
for i=1 ,(150) do 
msgs_id = msgs_id+1048576
table.insert(Msgs,msgs_id)
end
tdcli_function ({ID = "GetMessages",chat_id_ = msg.chat_id_,message_ids_ = Msgs},function(arg,data);MsgsDel = {};for i=0 ,data.total_count_ do;if not data.messages_[i] then;if not MsgsDel[0] then;MsgsDel[0] = Msgs[i];end;table.insert(MsgsDel,Msgs[i]);end;end;if MsgsDel[0] then;tdcli_function({ID="DeleteMessages",chat_id_ = arg.chat_id_,message_ids_=MsgsDel},function(arg,data)end,nil);end;end,{chat_id_=msg.chat_id_}) 
tdcli_function({ID = "GetChannelMembers",channel_id_ = msg.chat_id_:gsub("-100",""),filter_ = {ID = "ChannelMembersBots"},offset_ = 0,limit_ = 100 },function(arg,dp) local admins = dp.members_ for i=0 , #admins do if dp.members_[i].status_.ID ~= "ChatMemberStatusEditor" and not VipMem(msg) then tdcli_function ({ID = "ChangeChatMemberStatus",chat_id_ = msg.chat_id_,user_id_ = admins[i].user_id_,status_ = {ID = "ChatMemberStatusKicked"},}, function(arg,f) end, nil) end end end,nil)  
end
end     
end
for i=0,#mem_id do  
if msg.content_.members_[i].type_.ID == "UserTypeBot" and Bots == "del" and not VipMem(msg) then   
GetInfo = https.request("https://api.telegram.org/bot"..TokenBot.."/kickChatMember?chat_id="..msg.chat_id_.."&user_id="..mem_id[i].id_)
local JsonInfo = JSON.decode(GetInfo)
if JsonInfo.ok == true and #mem_id == i then
local Msgs = {}
Msgs[0] = msg.id_
msgs_id = msg.id_-1048576
for i=1 ,(150) do 
msgs_id = msgs_id+1048576
table.insert(Msgs,msgs_id)
end
tdcli_function ({ID = "GetMessages",chat_id_ = msg.chat_id_,message_ids_ = Msgs},function(arg,data);MsgsDel = {};for i=0 ,data.total_count_ do;if not data.messages_[i] then;if not MsgsDel[0] then;MsgsDel[0] = Msgs[i];end;table.insert(MsgsDel,Msgs[i]);end;end;if MsgsDel[0] then;tdcli_function({ID="DeleteMessages",chat_id_ = arg.chat_id_,message_ids_=MsgsDel},function(arg,data)end,nil);end;end,{chat_id_=msg.chat_id_}) 
tdcli_function({ID = "GetChannelMembers",channel_id_ = msg.chat_id_:gsub("-100",""),filter_ = {ID = "ChannelMembersBots"},offset_ = 0,limit_ = 100 },function(arg,dp) local admins = dp.members_ for i=0 , #admins do if dp.members_[i].status_.ID ~= "ChatMemberStatusEditor" and not VipMem(msg) then tdcli_function ({ID = "ChangeChatMemberStatus",chat_id_ = msg.chat_id_,user_id_ = admins[i].user_id_,status_ = {ID = "ChatMemberStatusKicked"},}, function(arg,f) end, nil) end end end,nil)  
end
end     
end
for i=0,#mem_id do  
if msg.content_.members_[i].type_.ID == "UserTypeBot" and Bots == "ked" and not VipMem(msg) then
HTTPS.request("https://api.telegram.org/bot" .. TokenBot .. "/restrictChatMember?chat_id=" .. msg.chat_id_ .. "&user_id=" .. msg.sender_user_id_ .. "&can_send_messages=false&can_send_media_messages=false&can_send_other_messages=false&can_add_web_page_previews=false")
DevAek:sadd(AEK..'Aek:Tkeed:'..msg.chat_id_, msg.sender_user_id_)
GetInfo = https.request("https://api.telegram.org/bot"..TokenBot.."/kickChatMember?chat_id="..msg.chat_id_.."&user_id="..mem_id[i].id_)
local JsonInfo = JSON.decode(GetInfo)
if JsonInfo.ok == true and #mem_id == i then
local Msgs = {}
Msgs[0] = msg.id_
msgs_id = msg.id_-1048576
for i=1 ,(150) do 
msgs_id = msgs_id+1048576
table.insert(Msgs,msgs_id)
end
tdcli_function ({ID = "GetMessages",chat_id_ = msg.chat_id_,message_ids_ = Msgs},function(arg,data);MsgsDel = {};for i=0 ,data.total_count_ do;if not data.messages_[i] then;if not MsgsDel[0] then;MsgsDel[0] = Msgs[i];end;table.insert(MsgsDel,Msgs[i]);end;end;if MsgsDel[0] then;tdcli_function({ID="DeleteMessages",chat_id_ = arg.chat_id_,message_ids_=MsgsDel},function(arg,data)end,nil);end;end,{chat_id_=msg.chat_id_}) 
tdcli_function({ID = "GetChannelMembers",channel_id_ = msg.chat_id_:gsub("-100",""),filter_ = {ID = "ChannelMembersBots"},offset_ = 0,limit_ = 100 },function(arg,dp) local admins = dp.members_ for i=0 , #admins do if dp.members_[i].status_.ID ~= "ChatMemberStatusEditor" and not VipMem(msg) then tdcli_function ({ID = "ChangeChatMemberStatus",chat_id_ = msg.chat_id_,user_id_ = admins[i].user_id_,status_ = {ID = "ChatMemberStatusKicked"},}, function(arg,f) end, nil) end end end,nil)  
end
end  
end  
end
if msg.content_.ID == "MessageChatDeleteMember" and tonumber(msg.content_.user_.id_) == tonumber(AEK) then 
DevAek:srem(AEK.."Aek:Groups", msg.chat_id_) 
tdcli_function ({ID = "GetUser",user_id_ = msg.sender_user_id_},function(extra,result,success)
tdcli_function({ID ="GetChat",chat_id_=msg.chat_id_},function(arg,dp) 
local Name1 = result.first_name_
local Name1 = Name1:gsub('"',"") 
local Name1 = Name1:gsub("'","") 
local Name1 = Name1:gsub("`","") 
local Name1 = Name1:gsub("*","") 
local Name1 = Name1:gsub("{","") 
local Name1 = Name1:gsub("}","") 
local Name = '['..Name1..'](tg://user?id='..result.id_..')'
local NameChat = dp.title_
local NameChat = NameChat:gsub('"',"") 
local NameChat = NameChat:gsub("'","") 
local NameChat = NameChat:gsub("`","") 
local NameChat = NameChat:gsub("*","") 
local NameChat = NameChat:gsub("{","") 
local NameChat = NameChat:gsub("}","") 
if not Sudo(msg) then
SendText(DevId,"✫︙تم طرد البوت من المجموعه ↫ ⤈ \n━───━ ✫ ━───━\n✫︙بواسطة ↫ "..Name.."\n✫︙اسم المجموعه ↫ ["..NameChat.."]\n✫︙ايدي المجموعه ↫ ⤈ \n❨ `"..msg.chat_id_.."` ❩\n━───━ ✫ ━───━\n✫︙الوقت ↫ "..os.date("%I:%M%p").."\n✫︙التاريخ ↫ "..os.date("%Y/%m/%d").."",0,'md')
end
end,nil)
end,nil)
end
if msg.content_.ID == "MessageChatDeletePhoto" or msg.content_.ID == "MessageChatChangePhoto" or msg.content_.ID == 'MessagePinMessage' or msg.content_.ID == "MessageChatJoinByLink" or msg.content_.ID == "MessageChatAddMembers" or msg.content_.ID == 'MessageChatChangeTitle' or msg.content_.ID == "MessageChatDeleteMember" then   
if DevAek:get(AEK..'Aek:Lock:TagServr'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})    
end   
end
if msg.content_.ID == "MessageChatJoinByLink" or msg.content_.ID == "MessageChatAddMembers" then   
DevAek:incr(AEK..'Aek:EntryNumber'..msg.chat_id_..':'..os.date('%d'))  
elseif msg.content_.ID == "MessageChatDeleteMember" then   
DevAek:incr(AEK..'Aek:ExitNumber'..msg.chat_id_..':'..os.date('%d'))  
end

if text ==('تفعيل') and not SudoBot(msg) and SourcelionCh(msg) then
if not DevAek:get(AEK..'Aek:Lock:FreeBot'..AEK) then
if ChatType == 'pv' then
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙لاتستطيع تفعيلي هنا يرجى اضافتي في مجموعه اولا', 1, 'md')
return false
end
if ChatType ~= 'sp' then
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙المجموعه عاديه وليست خارقه لا تستطيع تفعيلي يرجى ان تضع سجل رسائل المجموعه ضاهر وليس مخفي ومن بعدها يمكنك رفعي ادمن ثم تفعيلي', 1, 'md')
return false
end
if msg.can_be_deleted_ == false then 
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙البوت ليس ادمن يرجى ترقيتي !', 1, 'md')
return false  
end
tdcli_function ({ ID = "GetChannelFull", channel_id_ = msg.chat_id_:gsub("-100","")}, function(arg,data)  
tdcli_function ({ID = "GetUser",user_id_ = msg.sender_user_id_},function(extra,result,success)
tdcli_function({ID ="GetChat",chat_id_=msg.chat_id_},function(arg,dp) 
tdcli_function ({ID = "GetChatMember",chat_id_ = msg.chat_id_,user_id_ = msg.sender_user_id_},function(arg,ChatMem) 
if ChatMem and ChatMem.status_.ID == "ChatMemberStatusEditor" or ChatMem and ChatMem.status_.ID == "ChatMemberStatusCreator" then
if ChatMem and ChatMem.user_id_ == msg.sender_user_id_ then
if ChatMem.status_.ID == "ChatMemberStatusCreator" then
status = 'منشئ'
elseif ChatMem.status_.ID == "ChatMemberStatusEditor" then
status = 'ادمن'
else 
status = 'عضو'
end
DevAek:del(AEK..'Aek:AekConstructor:'..msg.chat_id_)
tdcli_function ({ID = "GetChannelMembers",channel_id_ = msg.chat_id_:gsub("-100",""),filter_ = {ID = "ChannelMembersAdministrators"},offset_ = 0,limit_ = 100},function(arg,Aekan) 
local admins = Aekan.members_
for i=0 , #admins do
if Aekan.members_[i].bot_info_ == false and Aekan.members_[i].status_.ID == "ChatMemberStatusEditor" then
DevAek:sadd(AEK..'Aek:Admins:'..msg.chat_id_, admins[i].user_id_)
tdcli_function ({ID = "GetUser",user_id_ = admins[i].user_id_},function(arg,ba) 
if ba.first_name_ == false then
DevAek:srem(AEK..'Aek:Admins:'..msg.chat_id_, admins[i].user_id_)
end
end,nil)   
else
DevAek:sadd(AEK..'Aek:Admins:'..msg.chat_id_, admins[i].user_id_)
end
if Aekan.members_[i].status_.ID == "ChatMemberStatusCreator" then
DevAek:sadd(AEK.."Aek:BasicConstructor:"..msg.chat_id_,admins[i].user_id_)
DevAek:sadd(AEK.."Aek:AekConstructor:"..msg.chat_id_,admins[i].user_id_)
tdcli_function ({ID = "GetUser",user_id_ = admins[i].user_id_},function(arg,ba) 
if ba.first_name_ == false then
DevAek:srem(AEK.."Aek:BasicConstructor:"..msg.chat_id_,admins[i].user_id_)
DevAek:srem(AEK.."Aek:AekConstructor:"..msg.chat_id_,admins[i].user_id_)
end
end,nil)  
end 
end
end,nil)
if DevAek:sismember(AEK..'Aek:Groups',msg.chat_id_) then
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙المجموعه بالتاكيد مفعله', 1, 'md')
else
if tonumber(data.member_count_) < tonumber(DevAek:get(AEK..'Aek:Num:Add:Bot') or 0) and not SecondSudo(msg) then
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙عدد اعضاء المجموعه اقل من ↫ *'..(DevAek:get(AEK..'Aek:Num:Add:Bot') or 0)..'* عضو', 1, 'md')
return false
end
ReplyStatus(msg,result.id_,"ReplyBy","✫︙تم تفعيل المجموعه "..dp.title_)  
DevAek:sadd(AEK.."Aek:Groups",msg.chat_id_)
DevAek:sadd(AEK..'Aek:BasicConstructor:'..msg.chat_id_,msg.sender_user_id_)
local Name1 = result.first_name_
local Name1 = Name1:gsub('"',"") 
local Name1 = Name1:gsub("'","") 
local Name1 = Name1:gsub("`","") 
local Name1 = Name1:gsub("*","") 
local Name1 = Name1:gsub("{","") 
local Name1 = Name1:gsub("}","") 
local Name = '['..Name1..'](tg://user?id='..result.id_..')'
local NumMem = data.member_count_
local NameChat = dp.title_
local NameChat = NameChat:gsub('"',"") 
local NameChat = NameChat:gsub("'","") 
local NameChat = NameChat:gsub("`","") 
local NameChat = NameChat:gsub("*","") 
local NameChat = NameChat:gsub("{","") 
local NameChat = NameChat:gsub("}","") 
local LinkGp = json:decode(https.request('https://api.telegram.org/bot'..TokenBot..'/exportChatInviteLink?chat_id='..msg.chat_id_))
if LinkGp.ok == true then 
LinkGroup = LinkGp.result
else
LinkGroup = 'لا يوجد'
end
DevAek:set(AEK.."Aek:Groups:Links"..msg.chat_id_,LinkGroup) 
SendText(DevId,"✫︙تم تفعيل مجموعه جديده ↫ ⤈ \n━───━ ✫ ━───━\n✫︙بواسطة ↫ "..Name.."\n✫︙موقعه في المجموعه ↫ "..status.."\n✫︙اسم المجموعه ↫ ["..NameChat.."]\n✫︙عدد اعضاء المجموعه ↫ ❨ *"..NumMem.."* ❩\n✫︙ايدي المجموعه ↫ ⤈ \n❨ `"..msg.chat_id_.."` ❩\n✫︙رابط المجموعه ↫ ⤈\n❨ ["..LinkGroup.."] ❩\n━───━ ✫ ━───━\n✫︙الوقت ↫ "..os.date("%I:%M%p").."\n✫︙التاريخ ↫ "..os.date("%Y/%m/%d").."",0,'md')
end
end end
end,nil)
end,nil)
end,nil)
end,nil)
else
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙لا تستطيع تفعيل هذه المجموعه بسبب تعطيل البوت الخدمي من قبل المطور الاساسي', 1, 'md') 
end 
end 

if msg.date_ and msg.date_ < tonumber(os.time() - 30) then
print("*( OLD MESSAGE )*")
return false
end

tdcli_function({ID = "GetUser",user_id_ = msg.sender_user_id_},function(arg,data) 
if data.username_ ~= false then
DevAek:set(AEK..'Save:UserName'..msg.sender_user_id_,data.username_)
end;end,nil) 

local ReFalse = tostring(msg.chat_id_)
if not DevAek:sismember(AEK.."Aek:Groups",msg.chat_id_) and not ReFalse:match("^(%d+)") and not SudoBot(msg) then
print("Return False : The Bot Is Not Enabled In The Group")
return false
end

-------- MSG TYPES ---------
if msg.content_.ID == "MessageChatJoinByLink" and not VipMem(msg) then 
if DevAek:get(AEK.."Aek:Lock:Join"..msg.chat_id_) then
ChatKick(msg.chat_id_,msg.sender_user_id_) 
return false  
end
end
if msg.content_.ID == "MessagePhoto" then
if not Manager(msg) then 
local filter = DevAek:smembers(AEK.."Aek:FilterPhoto"..msg.chat_id_)
for k,v in pairs(filter) do
if v == msg.content_.photo_.id_ then
ReplyStatus(msg,msg.sender_user_id_,"WrongWay","✫︙الصوره التي ارسلتها تم منعها من المجموعه")  
DeleteMessage(msg.chat_id_,{[0] = msg.id_})       
return false   
end
end
end
end
if msg.content_.ID == "MessageAnimation" then
if not Manager(msg) then 
local filter = DevAek:smembers(AEK.."Aek:FilterAnimation"..msg.chat_id_)
for k,v in pairs(filter) do
if v == msg.content_.animation_.animation_.persistent_id_ then
ReplyStatus(msg,msg.sender_user_id_,"WrongWay","✫︙المتحركه التي ارسلتها تم منعها من المجموعه")  
DeleteMessage(msg.chat_id_,{[0] = msg.id_})       
return false   
end
end
end
end
if msg.content_.ID == "MessageSticker" then
if not Manager(msg) then 
local filter = DevAek:smembers(AEK.."Aek:FilterSteckr"..msg.chat_id_)
for k,v in pairs(filter) do
if v == msg.content_.sticker_.sticker_.persistent_id_ then
ReplyStatus(msg,msg.sender_user_id_,"WrongWay","✫︙الملصق الذي ارسلته تم منعه من المجموعه")  
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
return false   
end
end
end
end

if text and text:match("^(.*)$") then
local DelGpRed = DevAek:get(AEK..'Aek:Add:GpRed'..msg.sender_user_id_..''..msg.chat_id_..'')
if DelGpRed == 'DelGpRed' then
Dev_Aek(msg.chat_id_, msg.id_, 1,'✫︙الكلمه ↫ '..msg.content_.text_..' تم حذفها',  1, "html")
DevAek:del(AEK..'Aek:Add:GpRed'..msg.sender_user_id_..''..msg.chat_id_..'')
DevAek:del(AEK..'Aek:Gif:GpRed'..msg.content_.text_..''..msg.chat_id_..'')
DevAek:del(AEK..'Aek:Voice:GpRed'..msg.content_.text_..''..msg.chat_id_..'')
DevAek:del(AEK..'Aek:Audio:GpRed'..msg.content_.text_..''..msg.chat_id_..'')
DevAek:del(AEK..'Aek:Photo:GpRed'..msg.content_.text_..''..msg.chat_id_..'')
DevAek:del(AEK..'Aek:Stecker:GpRed'..msg.content_.text_..''..msg.chat_id_..'')
DevAek:del(AEK..'Aek:Video:GpRed'..msg.content_.text_..''..msg.chat_id_..'')
DevAek:del(AEK..'Aek:File:GpRed'..msg.content_.text_..''..msg.chat_id_..'')
DevAek:del(AEK..'Aek:Text:GpRed'..msg.content_.text_..''..msg.chat_id_..'')
DevAek:srem(AEK..'Aek:Manager:GpRed'..msg.chat_id_..'',msg.content_.text_)
return false
end
end
if text and text:match("^(.*)$") then
local DelAllRed = DevAek:get(AEK.."Aek:Add:AllRed"..msg.sender_user_id_)
if DelAllRed == 'DelAllRed' then
Dev_Aek(msg.chat_id_, msg.id_, 1,'✫︙الكلمه ↫ '..msg.content_.text_..' تم حذفها',  1, "html")
DevAek:del(AEK.."Aek:Add:AllRed"..msg.sender_user_id_)
DevAek:del(AEK.."Aek:Gif:AllRed"..msg.content_.text_)
DevAek:del(AEK.."Aek:Voice:AllRed"..msg.content_.text_)
DevAek:del(AEK.."Aek:Audio:AllRed"..msg.content_.text_)
DevAek:del(AEK.."Aek:Photo:AllRed"..msg.content_.text_)
DevAek:del(AEK.."Aek:Stecker:AllRed"..msg.content_.text_)
DevAek:del(AEK.."Aek:Video:AllRed"..msg.content_.text_)
DevAek:del(AEK.."Aek:File:AllRed"..msg.content_.text_)
DevAek:del(AEK.."Aek:Text:AllRed"..msg.content_.text_)
DevAek:del(AEK.."Aek:Sudo:AllRed",msg.content_.text_)
return false
end
end

if msg.content_.text_ or msg.content_.video_ or msg.content_.document_ or msg.content_.sticker_ or msg.content_.voice_ or msg.content_.audio_ or msg.content_.photo_ or msg.content_.animation_ then 
local SaveGpRed = DevAek:get(AEK..'Aek:Add:GpRed'..msg.sender_user_id_..''..msg.chat_id_..'')
if SaveGpRed == 'SaveGpRed' then 
if text == 'الغاء' then
local DelManagerRep = DevAek:get(AEK..'DelManagerRep'..msg.chat_id_..'')
DevAek:srem(AEK..'Aek:Manager:GpRed'..msg.chat_id_..'',DelManagerRep)
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙تم الغاء حفظ الرد', 1, 'md')
DevAek:del(AEK..'Aek:Add:GpText'..msg.sender_user_id_..''..msg.chat_id_..'')
DevAek:del(AEK..'Aek:Add:GpRed'..msg.sender_user_id_..''..msg.chat_id_)
DevAek:del(AEK..'DelManagerRep'..msg.chat_id_..'')
return false
end
DevAek:del(AEK..'Aek:Add:GpRed'..msg.sender_user_id_..''..msg.chat_id_..'')
local SaveGpRed = DevAek:get(AEK..'Aek:Add:GpText'..msg.sender_user_id_..''..msg.chat_id_..'')
if msg.content_.video_ then DevAek:set(AEK..'Aek:Video:GpRed'..SaveGpRed..''..msg.chat_id_..'', msg.content_.video_.video_.persistent_id_)
end
if msg.content_.document_ then DevAek:set(AEK..'Aek:File:GpRed'..SaveGpRed..''..msg.chat_id_..'', msg.content_.document_.document_.persistent_id_)
end
if msg.content_.sticker_ then DevAek:set(AEK..'Aek:Stecker:GpRed'..SaveGpRed..''..msg.chat_id_..'', msg.content_.sticker_.sticker_.persistent_id_) 
end 
if msg.content_.voice_ then DevAek:set(AEK..'Aek:Voice:GpRed'..SaveGpRed..''..msg.chat_id_..'', msg.content_.voice_.voice_.persistent_id_) 
end
if msg.content_.audio_ then DevAek:set(AEK..'Aek:Audio:GpRed'..SaveGpRed..''..msg.chat_id_..'', msg.content_.audio_.audio_.persistent_id_) 
end
if msg.content_.photo_ then
if msg.content_.photo_.sizes_[0] then
photo_in_group = msg.content_.photo_.sizes_[0].photo_.persistent_id_
end
if msg.content_.photo_.sizes_[1] then
photo_in_group = msg.content_.photo_.sizes_[1].photo_.persistent_id_
end
if msg.content_.photo_.sizes_[2] then
photo_in_group = msg.content_.photo_.sizes_[2].photo_.persistent_id_
end	
if msg.content_.photo_.sizes_[3] then
photo_in_group = msg.content_.photo_.sizes_[3].photo_.persistent_id_
end
DevAek:set(AEK..'Aek:Photo:GpRed'..SaveGpRed..''..msg.chat_id_..'', photo_in_group) 
end
if msg.content_.animation_ then DevAek:set(AEK..'Aek:Gif:GpRed'..SaveGpRed..''..msg.chat_id_..'', msg.content_.animation_.animation_.persistent_id_) 
end 
if msg.content_.text_ then
DevAek:set(AEK..'Aek:Text:GpRed'..SaveGpRed..''..msg.chat_id_..'', msg.content_.text_)
end 
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙تم حفظ الرد الجديد', 1, 'md') 
DevAek:del(AEK..'Aek:Add:GpText'..msg.sender_user_id_..''..msg.chat_id_..'')
DevAek:del(AEK..'DelManagerRep'..msg.chat_id_..'')
return false 
end 
end
if msg.content_.text_ and not DevAek:get(AEK..'Aek:Lock:GpRed'..msg.chat_id_) then 
if DevAek:get(AEK..'Aek:Video:GpRed'..msg.content_.text_..''..msg.chat_id_..'') then 
sendVideo(msg.chat_id_, msg.id_, 0, 1,nil, DevAek:get(AEK..'Aek:Video:GpRed'..msg.content_.text_..''..msg.chat_id_..'')) 
end 
if DevAek:get(AEK..'Aek:File:GpRed'..msg.content_.text_..''..msg.chat_id_..'') then 
sendDocument(msg.chat_id_, msg.id_, 0, 1,nil, DevAek:get(AEK..'Aek:File:GpRed'..msg.content_.text_..''..msg.chat_id_..'')) 
end 
if DevAek:get(AEK..'Aek:Voice:GpRed'..msg.content_.text_..''..msg.chat_id_..'') then 
sendVoice(msg.chat_id_, msg.id_, 0, 1, nil, DevAek:get(AEK..'Aek:Voice:GpRed'..msg.content_.text_..''..msg.chat_id_..'')) 
end
if DevAek:get(AEK..'Aek:Audio:GpRed'..msg.content_.text_..''..msg.chat_id_..'') then 
sendAudio(msg.chat_id_, msg.id_, 0, 1, nil, DevAek:get(AEK..'Aek:Audio:GpRed'..msg.content_.text_..''..msg.chat_id_..'')) 
end
if DevAek:get(AEK..'Aek:Photo:GpRed'..msg.content_.text_..''..msg.chat_id_..'') then 
sendPhoto(msg.chat_id_, msg.id_, 0, 1, nil, DevAek:get(AEK..'Aek:Photo:GpRed'..msg.content_.text_..''..msg.chat_id_..'')) 
end
if DevAek:get(AEK..'Aek:Gif:GpRed'..msg.content_.text_..''..msg.chat_id_..'') then 
sendDocument(msg.chat_id_, msg.id_, 0, 1, nil, DevAek:get(AEK..'Aek:Gif:GpRed'..msg.content_.text_..''..msg.chat_id_..'')) 
end 
if DevAek:get(AEK..'Aek:Stecker:GpRed'..msg.content_.text_..''..msg.chat_id_..'') then 
sendSticker(msg.chat_id_, msg.id_, 0, 1,nil, DevAek:get(AEK..'Aek:Stecker:GpRed'..msg.content_.text_..''..msg.chat_id_..''))
end
if DevAek:get(AEK..'Aek:Text:GpRed'..msg.content_.text_..''..msg.chat_id_..'') then
function AEKTEAM(extra,result,success)
if result.username_ then username = '[@'..result.username_..']' else username = 'لا يوجد' end
local edit_msg = DevAek:get(AEK..'Aek:EditMsg'..msg.chat_id_..msg.sender_user_id_) or 0
local user_msgs = DevAek:get(AEK..'Aek:UsersMsgs'..msg.chat_id_..':'..msg.sender_user_id_)
local Text = DevAek:get(AEK..'Aek:Text:GpRed'..msg.content_.text_..''..msg.chat_id_..'')
local Text = Text:gsub('#username',(username or 'لا يوجد')) 
local Text = Text:gsub('#name','['..result.first_name_..']')
local Text = Text:gsub('#id',msg.sender_user_id_)
local Text = Text:gsub('#edit',edit_msg)
local Text = Text:gsub('#msgs',(user_msgs or 'لا يوجد'))
local Text = Text:gsub('#stast',(IdRank(msg.sender_user_id_, msg.chat_id_) or 'لا يوجد'))
send(msg.chat_id_,msg.id_,Text)
end
getUser(msg.sender_user_id_, AEKTEAM)
end
end

text = msg.content_.text_
if msg.content_.text_ or msg.content_.video_ or msg.content_.document_ or msg.content_.sticker_ or msg.content_.voice_ or msg.content_.audio_ or msg.content_.photo_ or msg.content_.animation_ then
local SaveAllRed = DevAek:get(AEK.."Aek:Add:AllRed"..msg.sender_user_id_)
if SaveAllRed == 'SaveAllRed' then
if text == 'الغاء' then
local DelSudoRep = DevAek:get(AEK..'DelSudoRep')
DevAek:del(AEK.."Aek:Sudo:AllRed",DelSudoRep)
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙تم الغاء حفظ الرد', 1, 'md')
DevAek:del(AEK.."Aek:Add:AllText"..msg.sender_user_id_)
DevAek:del(AEK.."Aek:Add:AllRed"..msg.sender_user_id_)
DevAek:del(AEK.."DelSudoRep")
return false
end
DevAek:del(AEK.."Aek:Add:AllRed"..msg.sender_user_id_)
local SaveAllRed = DevAek:get(AEK.."Aek:Add:AllText"..msg.sender_user_id_)
if msg.content_.video_ then
DevAek:set(AEK.."Aek:Video:AllRed"..SaveAllRed, msg.content_.video_.video_.persistent_id_)
end
if msg.content_.document_ then
DevAek:set(AEK.."Aek:File:AllRed"..SaveAllRed, msg.content_.document_.document_.persistent_id_)
end
if msg.content_.sticker_ then
DevAek:set(AEK.."Aek:Stecker:AllRed"..SaveAllRed, msg.content_.sticker_.sticker_.persistent_id_)
end
if msg.content_.voice_ then
DevAek:set(AEK.."Aek:Voice:AllRed"..SaveAllRed, msg.content_.voice_.voice_.persistent_id_)
end
if msg.content_.audio_ then
DevAek:set(AEK.."Aek:Audio:AllRed"..SaveAllRed, msg.content_.audio_.audio_.persistent_id_)
end
if msg.content_.photo_ then
if msg.content_.photo_.sizes_[0] then
photo_in_all_groups = msg.content_.photo_.sizes_[0].photo_.persistent_id_
end
if msg.content_.photo_.sizes_[1] then
photo_in_all_groups = msg.content_.photo_.sizes_[1].photo_.persistent_id_
end
if msg.content_.photo_.sizes_[2] then
photo_in_all_groups = msg.content_.photo_.sizes_[2].photo_.persistent_id_
end	
if msg.content_.photo_.sizes_[3] then
photo_in_all_groups = msg.content_.photo_.sizes_[3].photo_.persistent_id_
end
DevAek:set(AEK.."Aek:Photo:AllRed"..SaveAllRed, photo_in_all_groups)
end
if msg.content_.animation_ then
DevAek:set(AEK.."Aek:Gif:AllRed"..SaveAllRed, msg.content_.animation_.animation_.persistent_id_)
end
if msg.content_.text_ then
DevAek:set(AEK.."Aek:Text:AllRed"..SaveAllRed, msg.content_.text_)
end 
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙تم حفظ الرد الجديد', 1, 'md') 
DevAek:del(AEK.."Aek:Add:AllText"..msg.sender_user_id_)
DevAek:del(AEK..'DelSudoRep')
return false end end
if msg.content_.text_ and not DevAek:get(AEK..'Aek:Lock:AllRed'..msg.chat_id_) then
if DevAek:get(AEK.."Aek:Video:AllRed"..msg.content_.text_) then
sendVideo(msg.chat_id_, msg.id_, 0, 1,nil, DevAek:get(AEK.."Aek:Video:AllRed"..msg.content_.text_))
end
if DevAek:get(AEK.."Aek:File:AllRed"..msg.content_.text_) then
sendDocument(msg.chat_id_, msg.id_, 0, 1,nil, DevAek:get(AEK.."Aek:File:AllRed"..msg.content_.text_))
end
if DevAek:get(AEK.."Aek:Voice:AllRed"..msg.content_.text_)  then
sendVoice(msg.chat_id_, msg.id_, 0, 1, nil, DevAek:get(AEK.."Aek:Voice:AllRed"..msg.content_.text_))
end
if DevAek:get(AEK.."Aek:Audio:AllRed"..msg.content_.text_)  then
sendAudio(msg.chat_id_, msg.id_, 0, 1, nil, DevAek:get(AEK.."Aek:Audio:AllRed"..msg.content_.text_))
end
if DevAek:get(AEK.."Aek:Photo:AllRed"..msg.content_.text_)  then
sendPhoto(msg.chat_id_, msg.id_, 0, 1, nil, DevAek:get(AEK.."Aek:Photo:AllRed"..msg.content_.text_))
end
if  DevAek:get(AEK.."Aek:Gif:AllRed"..msg.content_.text_) then
sendDocument(msg.chat_id_, msg.id_, 0, 1, nil, DevAek:get(AEK.."Aek:Gif:AllRed"..msg.content_.text_))
end
if DevAek:get(AEK.."Aek:Stecker:AllRed"..msg.content_.text_) then
sendSticker(msg.chat_id_, msg.id_, 0, 1,nil, DevAek:get(AEK.."Aek:Stecker:AllRed"..msg.content_.text_))
end
if DevAek:get(AEK.."Aek:Text:AllRed"..msg.content_.text_) then
function AEKTEAM(extra,result,success)
if result.username_ then username = '[@'..result.username_..']' else username = 'لا يوجد' end
local edit_msg = DevAek:get(AEK..'Aek:EditMsg'..msg.chat_id_..msg.sender_user_id_) or 0
local user_msgs = DevAek:get(AEK..'Aek:UsersMsgs'..msg.chat_id_..':'..msg.sender_user_id_)
local Text = DevAek:get(AEK.."Aek:Text:AllRed"..msg.content_.text_)
local Text = Text:gsub('#username',(username or 'لا يوجد')) 
local Text = Text:gsub('#name','['..result.first_name_..']')
local Text = Text:gsub('#id',msg.sender_user_id_)
local Text = Text:gsub('#edit',edit_msg)
local Text = Text:gsub('#msgs',(user_msgs or 'لا يوجد'))
local Text = Text:gsub('#stast',(IdRank(msg.sender_user_id_, msg.chat_id_) or 'لا يوجد'))
send(msg.chat_id_,msg.id_,Text)
end
getUser(msg.sender_user_id_, AEKTEAM)
end
end 

--       Spam Send        --
function NotSpam(msg,Type)
tdcli_function ({ID = "GetUser",user_id_ = msg.sender_user_id_},function(arg,dp) 
local GetName = '['..dp.first_name_..'](tg://user?id='..dp.id_..')'
if Type == "kick" then 
ChatKick(msg.chat_id_,msg.sender_user_id_) 
my_ide = msg.sender_user_id_
msgm = msg.id_
local num = 100
for i=1,tonumber(num) do
tdcli_function ({ID = "GetMessages",chat_id_ = msg.chat_id_,message_ids_ = {[0] = msgm}},function(arg,data) 
if data.messages_[0] ~= false then
if tonumber(my_ide) == (data.messages_[0].sender_user_id_) then
DeleteMessage(msg.chat_id_, {[0] = data.messages_[0].id_})
end;end;end, nil)
msgm = msgm - 1048576
end
Text = '✫︙العضو ↫ '..GetName..' \n✫︙قام بالتكرار المحدد تم طرده '
SendText(msg.chat_id_,Text,0,'md')
return false  
end 
if Type == "del" then 
DeleteMessage(msg.chat_id_,{[0] = msg.id_})   
return false  
end 
if Type == "keed" and not DevAek:sismember(AEK..'Aek:Tkeed:'..msg.chat_id_, msg.sender_user_id_) then
https.request("https://api.telegram.org/bot" .. TokenBot .. "/restrictChatMember?chat_id=" ..msg.chat_id_.. "&user_id=" ..msg.sender_user_id_.."") 
DevAek:sadd(AEK..'Aek:Tkeed:'..msg.chat_id_, msg.sender_user_id_)
my_ide = msg.sender_user_id_
msgm = msg.id_
local num = 100
for i=1,tonumber(num) do
tdcli_function ({ID = "GetMessages",chat_id_ = msg.chat_id_,message_ids_ = {[0] = msgm}},function(arg,data) 
if data.messages_[0] ~= false then
if tonumber(my_ide) == (data.messages_[0].sender_user_id_) then
DeleteMessage(msg.chat_id_, {[0] = data.messages_[0].id_})
end;end;end, nil)
msgm = msgm - 1048576
end
Text = '✫︙العضو ↫ '..GetName..' \n✫︙قام بالتكرار المحدد تم تقيده '
SendText(msg.chat_id_,Text,0,'md')
return false  
end  
if Type == "mute" and not DevAek:sismember(AEK..'Aek:Muted:'..msg.chat_id_, msg.sender_user_id_) then
DevAek:sadd(AEK..'Aek:Muted:'..msg.chat_id_,msg.sender_user_id_)
my_ide = msg.sender_user_id_
msgm = msg.id_
local num = 100
for i=1,tonumber(num) do
tdcli_function ({ID = "GetMessages",chat_id_ = msg.chat_id_,message_ids_ = {[0] = msgm}},function(arg,data) 
if data.messages_[0] ~= false then
if tonumber(my_ide) == (data.messages_[0].sender_user_id_) then
DeleteMessage(msg.chat_id_, {[0] = data.messages_[0].id_})
end;end;end, nil)
msgm = msgm - 1048576
end
Text = '✫︙العضو ↫ '..GetName..' \n✫︙قام بالتكرار المحدد تم كتمه '
SendText(msg.chat_id_,Text,0,'md')
return false  
end
end,nil)
end  
--  end functions AEK --

--       Spam Check       --
if not VipMem(msg) and msg.content_.ID ~= "MessageChatAddMembers" and DevAek:hget(AEK.."Aek:Spam:Group:User"..msg.chat_id_,"Spam:User") then 
if msg.sender_user_id_ ~= AEK then
floods = DevAek:hget(AEK.."Aek:Spam:Group:User"..msg.chat_id_,"Spam:User") or "nil"
Num_Msg_Max = DevAek:hget(AEK.."Aek:Spam:Group:User"..msg.chat_id_,"Num:Spam") or 5
Time_Spam = DevAek:hget(AEK.."Aek:Spam:Group:User"..msg.chat_id_,"Num:Spam:Time") or 5
local post_count = tonumber(DevAek:get(AEK.."Aek:Spam:Cont"..msg.sender_user_id_..":"..msg.chat_id_) or 0)
if post_count > tonumber(DevAek:hget(AEK.."Aek:Spam:Group:User"..msg.chat_id_,"Num:Spam") or 5) then 
local ch = msg.chat_id_
local type = DevAek:hget(AEK.."Aek:Spam:Group:User"..msg.chat_id_,"Spam:User") 
NotSpam(msg,type)  
end
DevAek:setex(AEK.."Aek:Spam:Cont"..msg.sender_user_id_..":"..msg.chat_id_, tonumber(DevAek:hget(AEK.."Aek:Spam:Group:User"..msg.chat_id_,"Num:Spam:Time") or 3), post_count+1) 
local edit_id = data.text_ or "nil"  
Num_Msg_Max = 5
if DevAek:hget(AEK.."Aek:Spam:Group:User"..msg.chat_id_,"Num:Spam") then
Num_Msg_Max = DevAek:hget(AEK.."Aek:Spam:Group:User"..msg.chat_id_,"Num:Spam") 
end
if DevAek:hget(AEK.."Aek:Spam:Group:User"..msg.chat_id_,"Num:Spam:Time") then
Time_Spam = DevAek:hget(AEK.."Aek:Spam:Group:User"..msg.chat_id_,"Num:Spam:Time") 
end 
end
end 

----- START MSG CHECKS -----
if msg.sender_user_id_ and Ban(msg.sender_user_id_, msg.chat_id_) then
ChatKick(msg.chat_id_, msg.sender_user_id_)
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
return false
end
if msg.sender_user_id_ and BanAll(msg.sender_user_id_) then
ChatKick(msg.chat_id_, msg.sender_user_id_)
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
return false
end
if msg.sender_user_id_ and Muted(msg.sender_user_id_, msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
return false
end
if msg.sender_user_id_ and MuteAll(msg.sender_user_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
return false
end
if msg.content_.ID == "MessagePinMessage" then
if Constructor(msg) or tonumber(msg.sender_user_id_) == tonumber(AEK) then
DevAek:set(AEK..'Aek:PinnedMsg'..msg.chat_id_,msg.content_.message_id_)
else
local pin_id = DevAek:get(AEK..'Aek:PinnedMsg'..msg.chat_id_)
if pin_id and DevAek:get(AEK..'Aek:Lock:Pin'..msg.chat_id_) then
pinmsg(msg.chat_id_,pin_id,0)
end
end
end
if DevAek:get(AEK..'Aek:viewget'..msg.sender_user_id_) then
if not msg.forward_info_ then
DevAek:del(AEK..'Aek:viewget'..msg.sender_user_id_)
else
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙عدد مشاهدات المنشور هي ↫ ('..msg.views_..')', 1, 'md')
DevAek:del(AEK..'Aek:viewget'..msg.sender_user_id_)
end
end

--         Photo          --
if msg.content_.ID == "MessagePhoto" then
if not VipMem(msg) then
if msg.forward_info_ then
if DevAek:get(AEK..'Aek:Lock:Forwards'..msg.chat_id_) then
if msg.forward_info_.ID == "MessageForwardedFromUser" or msg.forward_info_.ID == "MessageForwardedPost" then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
end
if DevAek:get(AEK..'Aek:Lock:Photo'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
if msg.content_.caption_ then
Filters(msg, msg.content_.caption_)
if DevAek:get(AEK..'Aek:Lock:Links'..msg.chat_id_) then
if msg.content_.caption_:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]") or msg.content_.caption_:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]") or msg.content_.caption_:match("[Tt].[Mm][Ee]") or msg.content_.caption_:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Dd][Oo][Gg]") then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if DevAek:get(AEK..'Aek:Lock:Tags'..msg.chat_id_) then
if msg.content_.caption_:match("@") then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if msg.content_.caption_:match("#") then
if DevAek:get(AEK..'Aek:Lock:Hashtak'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if msg.content_.caption_:match("[Hh][Tt][Tt][Pp][Ss]://") or msg.content_.caption_:match("[Hh][Tt][Tt][Pp]://") or msg.content_.caption_:match(".[Ii][Rr]") or msg.content_.caption_:match(".[Cc][Oo][Mm]") or msg.content_.caption_:match(".[Oo][Rr][Gg]") or msg.content_.caption_:match(".[Ii][Nn][Ff][Oo]") or msg.content_.caption_:match("[Ww][Ww][Ww].") or msg.content_.caption_:match(".[Xx][Yy][Zz]") or msg.content_.caption_:match(".[Tt][Kk]") or msg.content_.ID == "MessageEntityTextUrl" or msg.content_.ID == "MessageEntityUrl" then
if DevAek:get(AEK..'Aek:Lock:WebLinks'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if msg.content_.caption_:match("[\216-\219][\128-\191]") then
if DevAek:get(AEK..'Aek:Lock:Arabic'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if msg.content_.caption_:match("[A-Z]") or msg.content_.caption_:match("[a-z]") then
if DevAek:get(AEK..'Aek:Lock:English'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
end
end

--        Markdown        --
elseif not msg.reply_markup_ and msg.via_bot_user_id_ ~= 0 then
if DevAek:get(AEK..'Aek:Lock:Markdown'..msg.chat_id_) then
if not VipMem(msg) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end

--        Document        --
elseif msg.content_.ID == "MessageDocument" then
if not VipMem(msg) then
if msg.forward_info_ then
if DevAek:get(AEK..'Aek:Lock:Forwards'..msg.chat_id_) then
if msg.forward_info_.ID == "MessageForwardedFromUser" or msg.forward_info_.ID == "MessageForwardedPost" then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
end
if DevAek:get(AEK..'Aek:Lock:Document'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
if msg.content_.caption_ then
Filters(msg, msg.content_.caption_)
if DevAek:get(AEK..'Aek:Lock:Links'..msg.chat_id_) then
if msg.content_.caption_:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]") or msg.content_.caption_:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]") or msg.content_.caption_:match("[Tt].[Mm][Ee]") or msg.content_.caption_:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Dd][Oo][Gg]") then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if DevAek:get(AEK..'Aek:Lock:Tags'..msg.chat_id_) then
if msg.content_.caption_:match("@") then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if msg.content_.caption_:match("#") then
if DevAek:get(AEK..'Aek:Lock:Hashtak'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if msg.content_.caption_:match("[Hh][Tt][Tt][Pp][Ss]://") or msg.content_.caption_:match("[Hh][Tt][Tt][Pp]://") or msg.content_.caption_:match(".[Ii][Rr]") or msg.content_.caption_:match(".[Cc][Oo][Mm]") or msg.content_.caption_:match(".[Oo][Rr][Gg]") or msg.content_.caption_:match(".[Ii][Nn][Ff][Oo]") or msg.content_.caption_:match("[Ww][Ww][Ww].") or msg.content_.caption_:match(".[Xx][Yy][Zz]") or msg.content_.caption_:match(".[Tt][Kk]") or msg.content_.ID == "MessageEntityTextUrl" or msg.content_.ID == "MessageEntityUrl" then
if DevAek:get(AEK..'Aek:Lock:WebLinks'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if msg.content_.caption_:match("[\216-\219][\128-\191]") then
if DevAek:get(AEK..'Aek:Lock:Arabic'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if msg.content_.caption_:match("[A-Z]") or msg.content_.caption_:match("[a-z]") then
if DevAek:get(AEK..'Aek:Lock:English'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
end
end

--         Inline         --
elseif msg.reply_markup_ and msg.reply_markup_.ID == "ReplyMarkupInlineKeyboard" and msg.via_bot_user_id_ ~= 0 then
if not VipMem(msg) then
if DevAek:get(AEK..'Aek:Lock:Inline'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end

--        Sticker         --
elseif msg.content_.ID == "MessageSticker" then
if not VipMem(msg) then
if DevAek:get(AEK..'Aek:Lock:Stickers'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
elseif msg.content_.ID == "MessageChatJoinByLink" then
if DevAek:get(AEK..'Aek:Lock:TagServr'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
return
end
function get_welcome(extra,result,success)
if DevAek:get(AEK..'Aek:Groups:Welcomes'..msg.chat_id_) then
text = DevAek:get(AEK..'Aek:Groups:Welcomes'..msg.chat_id_)
else
text = '• نورت حبي \n• [firstname lastname] \n• [@username]'
end
local text = text:gsub('firstname',(result.first_name_ or ''))
local text = text:gsub('lastname',(result.last_name_ or ''))
local text = text:gsub('username',(result.username_ or 'HH_418'))
Dev_Aek(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end 
if DevAek:get(AEK.."Aek:Lock:Welcome"..msg.chat_id_) then
getUser(msg.sender_user_id_,get_welcome)
end

--      New User Add      --
elseif msg.content_.ID == "MessageChatAddMembers" then
if not DevAek:get(AEK..'Aek:Lock:BotWelcome') then 
tdcli_function ({ID = "GetUserProfilePhotos",user_id_ = AEK,offset_ = 0,limit_ = 1},function(extra,Aekan,success) 
for i=0,#msg.content_.members_ do    
BotWelcome = msg.content_.members_[i].id_    
if BotWelcome and BotWelcome == tonumber(AEK) then 
if DevAek:sismember(AEK..'Aek:Groups',msg.chat_id_) then
BotText = "مفعله في السابق\n✫︙ارسل ↫ الاوامر واستمتع بالمميزيات"
else 
BotText = "معطله يجب رفعي مشرف\n✫︙بعد ذلك يرجى ارسال امر ↫ تفعيل\n✫︙سيتم رفع الادمنيه والمنشئ تلقائيا"
end 
local AekText = (DevAek:get(AEK.."Aek:Text:BotWelcome") or "✫︙مرحبا انا بوت اسمي "..NameBot.."\n✫︙حالة المجموعه ↫ "..BotText.."\n━───━ ✫ ━───━")
local AekPhoto = (DevAek:get(AEK.."Aek:Photo:BotWelcome") or Aekan.photos_[0].sizes_[1].photo_.persistent_id_)
if DevAek:get(AEK.."Aek:Photo:BotWelcome") or Aekan.photos_[0] then
sendPhoto(msg.chat_id_,msg.id_,0,1,nil,AekPhoto,AekText)
else 
send(msg.chat_id_,msg.id_,AekText)
end 
end   
end
end,nil)
end
if DevAek:get(AEK..'Aek:Lock:TagServr'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
return
end
if msg.content_ and msg.content_.members_ and msg.content_.members_[0] and msg.content_.members_[0].id_ and Ban(msg.content_.members_[0].id_, msg.chat_id_) then
ChatKick(msg.chat_id_, msg.content_.members_[0].id_)
DeleteMessage(msg.chat_id_, {[0] = msg.id_}) 
return false
end
if msg.content_ and msg.content_.members_ and msg.content_.members_[0] and msg.content_.members_[0].id_ and BanAll(msg.content_.members_[0].id_) then
ChatKick(msg.chat_id_, msg.content_.members_[0].id_)
DeleteMessage(msg.chat_id_, {[0] = msg.id_}) 
return false
end
if DevAek:get(AEK.."Aek:Lock:Welcome"..msg.chat_id_) then
if DevAek:get(AEK..'Aek:Groups:Welcomes'..msg.chat_id_) then
text = DevAek:get(AEK..'Aek:Groups:Welcomes'..msg.chat_id_)
else
text = '• نورت حبي \n• [firstname lastname] \n• [@username]'
end
local text = text:gsub('firstname',(msg.content_.members_[0].first_name_ or ''))
local text = text:gsub('lastname',(msg.content_.members_[0].last_name_ or ''))
local text = text:gsub('username',(msg.content_.members_[0].username_ or 'HH_418'))
Dev_Aek(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end

--        Contact         --
elseif msg.content_.ID == "MessageContact" then
if not VipMem(msg) then
if msg.forward_info_ then
if DevAek:get(AEK..'Aek:Lock:Forwards'..msg.chat_id_) then
if msg.forward_info_.ID == "MessageForwardedFromUser" or msg.forward_info_.ID == "MessageForwardedPost" then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
end
if DevAek:get(AEK..'Aek:Lock:Contact'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end

--         Audio          --
elseif msg.content_.ID == "MessageAudio" then
if not VipMem(msg) then
if msg.forward_info_ then
if DevAek:get(AEK..'Aek:Lock:Forwards'..msg.chat_id_) then
if msg.forward_info_.ID == "MessageForwardedFromUser" or msg.forward_info_.ID == "MessageForwardedPost" then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
end
if DevAek:get(AEK..'Aek:Lock:Music'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
if msg.content_.caption_ then
Filters(msg, msg.content_.caption_)
if DevAek:get(AEK..'Aek:Lock:Links'..msg.chat_id_) then
if msg.content_.caption_:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]") or msg.content_.caption_:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]") or msg.content_.caption_:match("[Tt].[Mm][Ee]") or msg.content_.caption_:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Dd][Oo][Gg]") then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if DevAek:get(AEK..'Aek:Lock:Tags'..msg.chat_id_) then
if msg.content_.caption_:match("@") then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if msg.content_.caption_:match("#") then
if DevAek:get(AEK..'Aek:Lock:Hashtak'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if msg.content_.caption_:match("[Hh][Tt][Tt][Pp][Ss]://") or msg.content_.caption_:match("[Hh][Tt][Tt][Pp]://") or msg.content_.caption_:match(".[Ii][Rr]") or msg.content_.caption_:match(".[Cc][Oo][Mm]") or msg.content_.caption_:match(".[Oo][Rr][Gg]") or msg.content_.caption_:match(".[Ii][Nn][Ff][Oo]") or msg.content_.caption_:match("[Ww][Ww][Ww].") or msg.content_.caption_:match(".[Xx][Yy][Zz]") or msg.content_.caption_:match(".[Tt][Kk]") or msg.content_.ID == "MessageEntityTextUrl" or msg.content_.ID == "MessageEntityUrl" then
if DevAek:get(AEK..'Aek:Lock:WebLinks'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if msg.content_.caption_:match("[\216-\219][\128-\191]") then
if DevAek:get(AEK..'Aek:Lock:Arabic'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if msg.content_.caption_:match("[A-Z]") or msg.content_.caption_:match("[a-z]") then
if DevAek:get(AEK..'Aek:Lock:English'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
end
end

--         Voice          --
elseif msg.content_.ID == "MessageVoice" then
if not VipMem(msg) then
if msg.forward_info_ then
if DevAek:get(AEK..'Aek:Lock:Forwards'..msg.chat_id_) then
if msg.forward_info_.ID == "MessageForwardedFromUser" or msg.forward_info_.ID == "MessageForwardedPost" then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
end
if DevAek:get(AEK..'Aek:Lock:Voice'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
if msg.content_.caption_ then
Filters(msg, msg.content_.caption_)
if DevAek:get(AEK..'Aek:Lock:Links'..msg.chat_id_) then
if msg.content_.caption_:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]") or msg.content_.caption_:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]") or msg.content_.caption_:match("[Tt].[Mm][Ee]") or msg.content_.caption_:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Dd][Oo][Gg]") then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if DevAek:get(AEK..'Aek:Lock:Tags'..msg.chat_id_) then
if msg.content_.caption_:match("@") then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if msg.content_.caption_:match("#") then
if DevAek:get(AEK..'Aek:Lock:Hashtak'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if msg.content_.caption_:match("[Hh][Tt][Tt][Pp][Ss]://") or msg.content_.caption_:match("[Hh][Tt][Tt][Pp]://") or msg.content_.caption_:match(".[Ii][Rr]") or msg.content_.caption_:match(".[Cc][Oo][Mm]") or msg.content_.caption_:match(".[Oo][Rr][Gg]") or msg.content_.caption_:match(".[Ii][Nn][Ff][Oo]") or msg.content_.caption_:match("[Ww][Ww][Ww].") or msg.content_.caption_:match(".[Xx][Yy][Zz]") or msg.content_.caption_:match(".[Tt][Kk]") or msg.content_.ID == "MessageEntityTextUrl" or msg.content_.ID == "MessageEntityUrl" then
if DevAek:get(AEK..'Aek:Lock:WebLinks'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if msg.content_.caption_:match("[\216-\219][\128-\191]") then
if DevAek:get(AEK..'Aek:Lock:Arabic'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if msg.content_.caption_:match("[A-Z]") or msg.content_.caption_:match("[a-z]") then
if DevAek:get(AEK..'Aek:Lock:English'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
end
end

--        Location        --
elseif msg.content_.ID == "MessageLocation" then
if not VipMem(msg) then
if msg.forward_info_ then
if DevAek:get(AEK..'Aek:Lock:Forwards'..msg.chat_id_) then
if msg.forward_info_.ID == "MessageForwardedFromUser" or msg.forward_info_.ID == "MessageForwardedPost" then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
end
if DevAek:get(AEK..'Aek:Lock:Location'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
return
end
if msg.content_.caption_ then
Filters(msg, msg.content_.caption_)
if DevAek:get(AEK..'Aek:Lock:Links'..msg.chat_id_) then
if msg.content_.caption_:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]") or msg.content_.caption_:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]") or msg.content_.caption_:match("[Tt].[Mm][Ee]") or msg.content_.caption_:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Dd][Oo][Gg]") then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if DevAek:get(AEK..'Aek:Lock:Tags'..msg.chat_id_) then
if msg.content_.caption_:match("@") then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if msg.content_.caption_:match("#") then
if DevAek:get(AEK..'Aek:Lock:Hashtak'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if msg.content_.caption_:match("[Hh][Tt][Tt][Pp][Ss]://") or msg.content_.caption_:match("[Hh][Tt][Tt][Pp]://") or msg.content_.caption_:match(".[Ii][Rr]") or msg.content_.caption_:match(".[Cc][Oo][Mm]") or msg.content_.caption_:match(".[Oo][Rr][Gg]") or msg.content_.caption_:match(".[Ii][Nn][Ff][Oo]") or msg.content_.caption_:match("[Ww][Ww][Ww].") or msg.content_.caption_:match(".[Xx][Yy][Zz]") or msg.content_.caption_:match(".[Tt][Kk]") or msg.content_.ID == "MessageEntityTextUrl" or msg.content_.ID == "MessageEntityUrl" then
if DevAek:get(AEK..'Aek:Lock:WebLinks'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if msg.content_.caption_:match("[\216-\219][\128-\191]") then
if DevAek:get(AEK..'Aek:Lock:Arabic'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if msg.content_.caption_:match("[A-Z]") or msg.content_.caption_:match("[a-z]") then
if DevAek:get(AEK..'Aek:Lock:English'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
end
end

--         Video          --
elseif msg.content_.ID == "MessageVideo" then
if not VipMem(msg) then
if msg.forward_info_ then
if DevAek:get(AEK..'Aek:Lock:Forwards'..msg.chat_id_) then
if msg.forward_info_.ID == "MessageForwardedFromUser" or msg.forward_info_.ID == "MessageForwardedPost" then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
end
if DevAek:get(AEK..'Aek:Lock:Videos'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
if msg.content_.caption_ then
Filters(msg, msg.content_.caption_)
if DevAek:get(AEK..'Aek:Lock:Links'..msg.chat_id_) then
if msg.content_.caption_:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]") or msg.content_.caption_:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]") or msg.content_.caption_:match("[Tt].[Mm][Ee]") or msg.content_.caption_:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Dd][Oo][Gg]") then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if DevAek:get(AEK..'Aek:Lock:Tags'..msg.chat_id_) then
if msg.content_.caption_:match("@") then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if msg.content_.caption_:match("#") then
if DevAek:get(AEK..'Aek:Lock:Hashtak'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if msg.content_.caption_:match("[Hh][Tt][Tt][Pp][Ss]://") or msg.content_.caption_:match("[Hh][Tt][Tt][Pp]://") or msg.content_.caption_:match(".[Ii][Rr]") or msg.content_.caption_:match(".[Cc][Oo][Mm]") or msg.content_.caption_:match(".[Oo][Rr][Gg]") or msg.content_.caption_:match(".[Ii][Nn][Ff][Oo]") or msg.content_.caption_:match("[Ww][Ww][Ww].") or msg.content_.caption_:match(".[Xx][Yy][Zz]") or msg.content_.caption_:match(".[Tt][Kk]") or msg.content_.ID == "MessageEntityTextUrl" or msg.content_.ID == "MessageEntityUrl" then
if DevAek:get(AEK..'Aek:Lock:WebLinks'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if msg.content_.caption_:match("[\216-\219][\128-\191]") then
if DevAek:get(AEK..'Aek:Lock:Arabic'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if msg.content_.caption_:match("[A-Z]") or msg.content_.caption_:match("[a-z]") then
if DevAek:get(AEK..'Aek:Lock:English'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
end
end

--          Gif           --
elseif msg.content_.ID == "MessageAnimation" then
if not VipMem(msg) then
if msg.forward_info_ then
if DevAek:get(AEK..'Aek:Lock:Forwards'..msg.chat_id_) then
if msg.forward_info_.ID == "MessageForwardedFromUser" or msg.forward_info_.ID == "MessageForwardedPost" then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
end
if DevAek:get(AEK..'Aek:Lock:Gifs'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
if msg.content_.caption_ then
Filters(msg, msg.content_.caption_)
if DevAek:get(AEK..'Aek:Lock:Links'..msg.chat_id_) then
if msg.content_.caption_:match("[Hh][Tt][Tt][Pp][Ss]://") or msg.content_.caption_:match("[Hh][Tt][Tt][Pp]://") then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if DevAek:get(AEK..'Aek:Lock:Tags'..msg.chat_id_) then
if msg.content_.caption_:match("@") then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if msg.content_.caption_:match("#") then
if DevAek:get(AEK..'Aek:Lock:Hashtak'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if msg.content_.caption_:match("[Hh][Tt][Tt][Pp][Ss]://") or msg.content_.caption_:match("[Hh][Tt][Tt][Pp]://") or msg.content_.caption_:match(".[Ii][Rr]") or msg.content_.caption_:match(".[Cc][Oo][Mm]") or msg.content_.caption_:match(".[Oo][Rr][Gg]") or msg.content_.caption_:match(".[Ii][Nn][Ff][Oo]") or msg.content_.caption_:match("[Ww][Ww][Ww].") or msg.content_.caption_:match(".[Xx][Yy][Zz]") or msg.content_.caption_:match(".[Tt][Kk]") or msg.content_.ID == "MessageEntityTextUrl" or msg.content_.ID == "MessageEntityUrl" then
if DevAek:get(AEK..'Aek:Lock:WebLinks'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if msg.content_.caption_:match("[\216-\219][\128-\191]") then
if DevAek:get(AEK..'Aek:Lock:Arabic'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if msg.content_.caption_:match("[A-Z]") or msg.content_.caption_:match("[a-z]") then
if DevAek:get(AEK..'Aek:Lock:English'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
end
end

--         Text           --
elseif msg.content_.ID == "MessageText" then
if not VipMem(msg) then
Filters(msg,text)
if msg.forward_info_ then
if DevAek:get(AEK..'Aek:Lock:Forwards'..msg.chat_id_) then
if msg.forward_info_.ID == "MessageForwardedFromUser" or msg.forward_info_.ID == "MessageForwardedPost" then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
end
if text:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]") or text:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]") or text:match("[Tt].[Mm][Ee]") or text:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Dd][Oo][Gg]") then
if DevAek:get(AEK..'Aek:Lock:Links'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if DevAek:get(AEK..'Aek:Lock:Text'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
if msg.content_.text_:match("@") then
if DevAek:get(AEK..'Aek:Lock:Tags'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if msg.content_.text_:match("#") then
if DevAek:get(AEK..'Aek:Lock:Hashtak'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if text:match("[Hh][Tt][Tt][Pp][Ss]://") or text:match("[Hh][Tt][Tt][Pp]://") or text:match(".[Ii][Rr]") or text:match(".[Cc][Oo][Mm]") or text:match(".[Oo][Rr][Gg]") or text:match(".[Ii][Nn][Ff][Oo]") or text:match("[Ww][Ww][Ww].") or text:match(".[Tt][Kk]") or text:match(".[Xx][Yy][Zz]") or msg.content_.ID == "MessageEntityTextUrl" or msg.content_.ID == "MessageEntityUrl" then
if DevAek:get(AEK..'Aek:Lock:WebLinks'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if msg.content_.text_:match("[\216-\219][\128-\191]") then
if DevAek:get(AEK..'Aek:Lock:Arabic'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if msg.content_.text_ then
local _nl, ctrl_chars = string.gsub(text, '%c', '')
local _nl, real_digits = string.gsub(text, '%d', '')
if not DevAek:get(AEK..'Aek:Spam:Text'..msg.chat_id_) then
sens = 400
else
sens = tonumber(DevAek:get(AEK..'Aek:Spam:Text'..msg.chat_id_))
end
if DevAek:get(AEK..'Aek:Lock:Spam'..msg.chat_id_) and string.len(msg.content_.text_) > (sens) or ctrl_chars > (sens) or real_digits > (sens) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if msg.content_.text_:match("[A-Z]") or msg.content_.text_:match("[a-z]") then
if DevAek:get(AEK..'Aek:Lock:English'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
end

if DevAek:get(AEK.."Aek:Set:Groups:Links"..msg.chat_id_..""..msg.sender_user_id_) then
if text == "الغاء" then
send(msg.chat_id_,msg.id_,"✫︙تم الغاء حفظ الرابط")       
DevAek:del(AEK.."Aek:Set:Groups:Links"..msg.chat_id_..""..msg.sender_user_id_) 
return false
end
if msg.content_.text_:match("(https://telegram.me/joinchat/%S+)") or msg.content_.text_:match("(https://t.me/joinchat/%S+)") then
local Link = msg.content_.text_:match("(https://telegram.me/joinchat/%S+)") or msg.content_.text_:match("(https://t.me/joinchat/%S+)")
DevAek:set(AEK.."Aek:Groups:Links"..msg.chat_id_,Link)
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙تم حفظ الرابط بنجاح', 1, 'md')
DevAek:del(AEK.."Aek:Set:Groups:Links"..msg.chat_id_..""..msg.sender_user_id_) 
return false 
end
end

local msg = data.message_
text = msg.content_.text_
if text and Constructor(msg) then 
if DevAek:get('AEKTEAM:'..AEK.."numadd:user" .. msg.chat_id_ .. "" .. msg.sender_user_id_) then 
if text and text:match("^الغاء$") then 
DevAek:del('AEKTEAM:'..AEK..'id:user'..msg.chat_id_)  
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙تم الغاء الامر', 1, 'md')
DevAek:del('AEKTEAM:'..AEK.."numadd:user" .. msg.chat_id_ .. "" .. msg.sender_user_id_)  
return false  end 
DevAek:del('AEKTEAM:'..AEK.."numadd:user" .. msg.chat_id_ .. "" .. msg.sender_user_id_)  
local numadded = string.match(text, "(%d+)") 
local iduserr = DevAek:get('AEKTEAM:'..AEK..'id:user'..msg.chat_id_)  
DevAek:incrby(AEK..'Aek:UsersMsgs'..msg.chat_id_..':'..iduserr,numadded)
Dev_Aek(msg.chat_id_, msg.id_,  1, "✫︙تم اضافة "..numadded..' رساله', 1, 'md')
DevAek:del('AEKTEAM:'..AEK..'id:user'..msg.chat_id_) 
end
end
if text and Constructor(msg) then 
if DevAek:get('AEKTEAM:'..AEK.."nmadd:user" .. msg.chat_id_ .. "" .. msg.sender_user_id_) then 
if text and text:match("^الغاء$") then 
DevAek:del('AEKTEAM:'..AEK..'ids:user'..msg.chat_id_)  
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙تم الغاء الامر', 1, 'md')
DevAek:del('AEKTEAM:'..AEK.."nmadd:user" .. msg.chat_id_ .. "" .. msg.sender_user_id_)  
return false  end 
DevAek:del('AEKTEAM:'..AEK.."nmadd:user" .. msg.chat_id_ .. "" .. msg.sender_user_id_)  
local numadded = string.match(text, "(%d+)") 
local iduserr = DevAek:get('AEKTEAM:'..AEK..'ids:user'..msg.chat_id_)  
DevAek:incrby(AEK..'Aek:GamesNumber'..msg.chat_id_..iduserr,numadded)  
Dev_Aek(msg.chat_id_, msg.id_,  1, "✫︙تم اضافة "..numadded..' نقطه', 1, 'md')
DevAek:del('AEKTEAM:'..AEK..'ids:user'..msg.chat_id_)  
end
end

if text and (text:match("طيز") or text:match("ديس") or text:match("انيجمك") or text:match("انيج") or text:match("نيج") or text:match("ديوس") or text:match("مناويج") or text:match("عير") or text:match("كسختك") or text:match("كسمك") or text:match("كسربك") or text:match("بلاع") or text:match("ابو العيوره") or text:match("منيوج") or text:match("كحبه") or text:match("كحاب") or text:match("اخ الكحبه") or text:match("اخو الكحبه") or text:match("كواد") or text:match("كواده") or text:match("الكحبه") or text:match("كسك") or text:match("طيزك") or text:match("عير بطيزك") or text:match("كس امك") or text:match("امك الكحبه") or text:match("صرم") or text:match("عيرك") or text:match("عير بيك") or text:match("صرمك")) then
if not DevAek:get(AEK.."Aek:Lock:Fshar"..msg.chat_id_) and not VipMem(msg) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
ReplyStatus(msg,msg.sender_user_id_,"WrongWay","✫︙ممنوع الفشار في المجموعه")  
end end
if text and (text:match("ڬ") or text:match("ٺ") or text:match("چ") or text:match("ڇ") or text:match("ڿ") or text:match("ڀ") or text:match("ڎ") or text:match("ݫ") or text:match("ژ") or text:match("ڟ") or text:match("ݜ") or text:match("ڸ") or text:match("پ") or text:match("۴") or text:match("مک") or text:match("زدن") or text:match("سکس") or text:match("سکسی") or text:match("کسی") or text:match("دخترا") or text:match("دیوث") or text:match("کلیپشن") or text:match("خوششون") or text:match("میدا") or text:match("که") or text:match("بدانیم") or text:match("زناشویی") or text:match("آموزش") or text:match("ۀ") or text:match("ڲ") or text:match("ڳ") or text:match("ڴ") or text:match("ڱ") or text:match("ڰ") or text:match("ڮ") or text:match("ڭ") or text:match("ڬ") or text:match("ک") or text:match("ګ") or text:match("ۋ") or text:match("ۊ") or text:match("ٷ") or text:match("ۅ") or text:match("ۄ") or text:match("ۈ") or text:match("ۆ") or text:match("ڐ") or text:match("ډ") or text:match("ڍ") or text:match("ڎ") or text:match("ڏ") or text:match("ۮ") or text:match("ڌ") or text:match("ڋ") or text:match("ڈ") or text:match("ۯ") or text:match("ڙ") or text:match("ڗ") or text:match("ږ") or text:match("ڑ") or text:match("ځ") or text:match("ڟ") or text:match("ڿ") or text:match("ڻ") or text:match("ڽ") or text:match("ڹ") or text:match("ں") or text:match("ٿ") or text:match("ٽ") or text:match("ٺ") or text:match("ٵ") or text:match("ڸ") or text:match("ڷ") or text:match("ڵ") or text:match("ڀ")  or text:match("ٮ") or text:match("ۑ") or text:match("ۍ") or text:match("ێ") or text:match("ې") or text:match("ٸ") or text:match("ښ") or text:match("ڛ") or text:match("څ") or text:match("ۺ") or text:match("ڜ") or text:match("ښ") or text:match("۵") or text:match("۶") or text:match("بیام") or text:match("راحتی") or text:match("برم") or text:match("خسته") or text:match("شادی") or text:match("دوستان") or text:match("خوبم") or text:match("زیباترین") or text:match("خوشکلم") or text:match("زیباتون") or text:match("بیا") or text:match("نیاری") or text:match("داداش") or text:match("میخوای") or text:match("ملایم") or text:match("تخماتو") or text:match("اومدم") or text:match("بالااااس") or text:match("بمالونم") or text:match("صبجتون") or text:match("بکشی") or text:match("رفقا") or text:match("هَوَلای‌مآن") or text:match("فراموش") or text:match("استیکر") or text:match("بشیم") or text:match("درونمی") or text:match("هیع") or text:match("کردم")  or text:match("ادد") or text:match("شماره") or text:match("شمارتو") or text:match("فیترشکن") or text:match("خوبی") or text:match("جذابیتت") or text:match("دیشب") or text:match("نشونت") or text:match("کی") or text:match("خودتون") or text:match("بیایین") or text:match("سراغ") or text:match("خنده") or text:match("صکصی") or text:match("اینجا") or text:match("نشونت") or text:match("قهرمان‌") or text:match("دیلدو") or text:match("خوب") or text:match("فراموش") or text:match("هاشون‌") or text:match("دخترا") or text:match("دیشب") or text:match("کجایین") or text:match("بزنم") or text:match("یوی") or text:match("بیام") or text:match("دیلم") or text:match("جانم") or text:match("اصلشو") or text:match("هلوشو") or text:match("نیاز") or text:match("ندارم") or text:match("عزیزم") or text:match("عشقم") or text:match("زدن") or text:match("هست") or text:match("درونمی") or text:match("بشیم") or text:match("غوغای") or text:match("فیترشکن") or text:match("جدیدامو") or text:match("کصم") or text:match("میخاره") or text:match("نزاشتن") or text:match("داری") or text:match("شمارت") or text:match("یکی")) then
if DevAek:get(AEK.."Aek:Lock:Farsi"..msg.chat_id_) and not VipMem(msg) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end end
if text and (text:match("ڬ") or text:match("ٺ") or text:match("چ") or text:match("ڇ") or text:match("ڿ") or text:match("ڀ") or text:match("ڎ") or text:match("ݫ") or text:match("ژ") or text:match("ڟ") or text:match("ݜ") or text:match("ڸ") or text:match("پ") or text:match("۴") or text:match("مک") or text:match("زدن") or text:match("سکس") or text:match("سکسی") or text:match("کسی") or text:match("دخترا") or text:match("دیوث") or text:match("کلیپشن") or text:match("خوششون") or text:match("میدا") or text:match("که") or text:match("بدانیم") or text:match("زناشویی") or text:match("آموزش") or text:match("ۀ") or text:match("ڲ") or text:match("ڳ") or text:match("ڴ") or text:match("ڱ") or text:match("ڰ") or text:match("ڮ") or text:match("ڭ") or text:match("ڬ") or text:match("ک") or text:match("ګ") or text:match("ۋ") or text:match("ۊ") or text:match("ٷ") or text:match("ۅ") or text:match("ۄ") or text:match("ۈ") or text:match("ۆ") or text:match("ڐ") or text:match("ډ") or text:match("ڍ") or text:match("ڎ") or text:match("ڏ") or text:match("ۮ") or text:match("ڌ") or text:match("ڋ") or text:match("ڈ") or text:match("ۯ") or text:match("ڙ") or text:match("ڗ") or text:match("ږ") or text:match("ڑ") or text:match("ځ") or text:match("ڟ") or text:match("ڿ") or text:match("ڻ") or text:match("ڽ") or text:match("ڹ") or text:match("ں") or text:match("ٿ") or text:match("ٽ") or text:match("ٺ") or text:match("ٵ") or text:match("ڸ") or text:match("ڷ") or text:match("ڵ") or text:match("ڀ")  or text:match("ٮ") or text:match("ۑ") or text:match("ۍ") or text:match("ێ") or text:match("ې") or text:match("ٸ") or text:match("ښ") or text:match("ڛ") or text:match("څ") or text:match("ۺ") or text:match("ڜ") or text:match("ښ") or text:match("۵") or text:match("۶") or text:match("بیام") or text:match("راحتی") or text:match("برم") or text:match("خسته") or text:match("شادی") or text:match("دوستان") or text:match("خوبم") or text:match("زیباترین") or text:match("خوشکلم") or text:match("زیباتون") or text:match("بیا") or text:match("نیاری") or text:match("داداش") or text:match("میخوای") or text:match("ملایم") or text:match("تخماتو") or text:match("اومدم") or text:match("بالااااس") or text:match("بمالونم") or text:match("صبجتون") or text:match("بکشی") or text:match("رفقا") or text:match("هَوَلای‌مآن") or text:match("فراموش") or text:match("استیکر") or text:match("بشیم") or text:match("درونمی") or text:match("هیع") or text:match("کردم")  or text:match("ادد") or text:match("شماره") or text:match("شمارتو") or text:match("فیترشکن") or text:match("خوبی") or text:match("جذابیتت") or text:match("دیشب") or text:match("نشونت") or text:match("کی") or text:match("خودتون") or text:match("بیایین") or text:match("سراغ") or text:match("خنده") or text:match("صکصی") or text:match("اینجا") or text:match("نشونت") or text:match("قهرمان‌") or text:match("دیلدو") or text:match("خوب") or text:match("فراموش") or text:match("هاشون‌") or text:match("دخترا") or text:match("دیشب") or text:match("کجایین") or text:match("بزنم") or text:match("یوی") or text:match("بیام") or text:match("دیلم") or text:match("جانم") or text:match("اصلشو") or text:match("هلوشو") or text:match("نیاز") or text:match("ندارم") or text:match("عزیزم") or text:match("عشقم") or text:match("زدن") or text:match("هست") or text:match("درونمی") or text:match("بشیم") or text:match("غوغای") or text:match("فیترشکن") or text:match("جدیدامو") or text:match("کصم") or text:match("میخاره") or text:match("نزاشتن") or text:match("داری") or text:match("شمارت") or text:match("یکی")) then
if DevAek:get(AEK.."Aek:Lock:FarsiWarn"..msg.chat_id_) and not VipMem(msg) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
ReplyStatus(msg,msg.sender_user_id_,"WrongWay","✫︙ممنوع التكلم باللغه الفارسيه هنا")  
end end
if text and (text:match("ڬ") or text:match("ٺ") or text:match("چ") or text:match("ڇ") or text:match("ڿ") or text:match("ڀ") or text:match("ڎ") or text:match("ݫ") or text:match("ژ") or text:match("ڟ") or text:match("ݜ") or text:match("ڸ") or text:match("پ") or text:match("۴") or text:match("مک") or text:match("زدن") or text:match("سکس") or text:match("سکسی") or text:match("کسی") or text:match("دخترا") or text:match("دیوث") or text:match("کلیپشن") or text:match("خوششون") or text:match("میدا") or text:match("که") or text:match("بدانیم") or text:match("زناشویی") or text:match("آموزش") or text:match("ۀ") or text:match("ڲ") or text:match("ڳ") or text:match("ڴ") or text:match("ڱ") or text:match("ڰ") or text:match("ڮ") or text:match("ڭ") or text:match("ڬ") or text:match("ک") or text:match("ګ") or text:match("ۋ") or text:match("ۊ") or text:match("ٷ") or text:match("ۅ") or text:match("ۄ") or text:match("ۈ") or text:match("ۆ") or text:match("ڐ") or text:match("ډ") or text:match("ڍ") or text:match("ڎ") or text:match("ڏ") or text:match("ۮ") or text:match("ڌ") or text:match("ڋ") or text:match("ڈ") or text:match("ۯ") or text:match("ڙ") or text:match("ڗ") or text:match("ږ") or text:match("ڑ") or text:match("ځ") or text:match("ڟ") or text:match("ڿ") or text:match("ڻ") or text:match("ڽ") or text:match("ڹ") or text:match("ں") or text:match("ٿ") or text:match("ٽ") or text:match("ٺ") or text:match("ٵ") or text:match("ڸ") or text:match("ڷ") or text:match("ڵ") or text:match("ڀ")  or text:match("ٮ") or text:match("ۑ") or text:match("ۍ") or text:match("ێ") or text:match("ې") or text:match("ٸ") or text:match("ښ") or text:match("ڛ") or text:match("څ") or text:match("ۺ") or text:match("ڜ") or text:match("ښ") or text:match("۵") or text:match("۶") or text:match("بیام") or text:match("راحتی") or text:match("برم") or text:match("خسته") or text:match("شادی") or text:match("دوستان") or text:match("خوبم") or text:match("زیباترین") or text:match("خوشکلم") or text:match("زیباتون") or text:match("بیا") or text:match("نیاری") or text:match("داداش") or text:match("میخوای") or text:match("ملایم") or text:match("تخماتو") or text:match("اومدم") or text:match("بالااااس") or text:match("بمالونم") or text:match("صبجتون") or text:match("بکشی") or text:match("رفقا") or text:match("هَوَلای‌مآن") or text:match("فراموش") or text:match("استیکر") or text:match("بشیم") or text:match("درونمی") or text:match("هیع") or text:match("کردم")  or text:match("ادد") or text:match("شماره") or text:match("شمارتو") or text:match("فیترشکن") or text:match("خوبی") or text:match("جذابیتت") or text:match("دیشب") or text:match("نشونت") or text:match("کی") or text:match("خودتون") or text:match("بیایین") or text:match("سراغ") or text:match("خنده") or text:match("صکصی") or text:match("اینجا") or text:match("نشونت") or text:match("قهرمان‌") or text:match("دیلدو") or text:match("خوب") or text:match("فراموش") or text:match("هاشون‌") or text:match("دخترا") or text:match("دیشب") or text:match("کجایین") or text:match("بزنم") or text:match("یوی") or text:match("بیام") or text:match("دیلم") or text:match("جانم") or text:match("اصلشو") or text:match("هلوشو") or text:match("نیاز") or text:match("ندارم") or text:match("عزیزم") or text:match("عشقم") or text:match("زدن") or text:match("هست") or text:match("درونمی") or text:match("بشیم") or text:match("غوغای") or text:match("فیترشکن") or text:match("جدیدامو") or text:match("کصم") or text:match("میخاره") or text:match("نزاشتن") or text:match("داری") or text:match("شمارت") or text:match("یکی")) then
if DevAek:get(AEK.."Aek:Lock:FarsiBan"..msg.chat_id_) and not VipMem(msg) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
ChatKick(msg.chat_id_, msg.sender_user_id_)
end end
if text and (text:match("خره بالله") or text:match("خبربك") or text:match("كسدينربك") or text:match("خرب بالله") or text:match("خرب الله") or text:match("خره بربك") or text:match("الله الكواد") or text:match("خره بمحمد") or text:match("كسم الله") or text:match("كسم ربك") or text:match("كسربك") or text:match("كسختالله") or text:match("كسخت الله") or text:match("خره بدينك") or text:match("خرهبدينك") or text:match("كسالله") or text:match("خربالله")) then
if not DevAek:get(AEK.."Aek:Lock:Kfr"..msg.chat_id_) and not VipMem(msg) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
ReplyStatus(msg,msg.sender_user_id_,"WrongWay","✫︙ممنوع الكفر في المجموعه") 
end end
if text and (text:match("شيعي نكس") or text:match("سني نكس") or text:match("شيعه") or text:match("الشيعه") or text:match("طائفتكم") or text:match("شيعي") or text:match("انا سني") or text:match("انا شيعي") or text:match("مسيحي") or text:match("يهودي") or text:match("صابئي") or text:match("ملحد") or text:match("بالشيعه") or text:match("شيعة")) then
if not DevAek:get(AEK.."Aek:Lock:Taf"..msg.chat_id_) and not VipMem(msg) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
ReplyStatus(msg,msg.sender_user_id_,"WrongWay","✫︙ممنوع التكلم بالطائفيه هنا") 
end end

if SecondSudo(msg) then
if text == 'جلب نسخه الكروبات' and ChCheck(msg) or text == 'جلب نسخه احتياطيه' and ChCheck(msg) then
local List = DevAek:smembers(AEK..'Aek:Groups') 
local BotName = (DevAek:get(AEK.."Aek:NameBot") or 'ايبو')
local GetJson = '{"BotId": '..AEK..',"BotName": "'..BotName..'","GroupsList":{'  
for k,v in pairs(List) do 
LinkGroups = DevAek:get(AEK.."Aek:Groups:Links"..v)
Welcomes = DevAek:get(AEK..'Aek:Groups:Welcomes'..v) or ''
AekConstructors = DevAek:smembers(AEK..'Aek:AekConstructor:'..v)
Constructors = DevAek:smembers(AEK..'Aek:BasicConstructor:'..v)
BasicConstructors = DevAek:smembers(AEK..'Aek:Constructor:'..v)
Managers = DevAek:smembers(AEK..'Aek:Managers:'..v)
Admis = DevAek:smembers(AEK..'Aek:Admins:'..v)
Vips = DevAek:smembers(AEK..'Aek:VipMem:'..v)
if k == 1 then
GetJson = GetJson..'"'..v..'":{'
else
GetJson = GetJson..',"'..v..'":{'
end
if #Vips ~= 0 then 
GetJson = GetJson..'"Vips":['
for k,v in pairs(Vips) do
if k == 1 then
GetJson =  GetJson..'"'..v..'"'
else
GetJson =  GetJson..',"'..v..'"'
end
end   
GetJson = GetJson..'],'
end
if #Admis ~= 0 then
GetJson = GetJson..'"Admis":['
for k,v in pairs(Admis) do
if k == 1 then
GetJson =  GetJson..'"'..v..'"'
else
GetJson =  GetJson..',"'..v..'"'
end
end   
GetJson = GetJson..'],'
end
if #Managers ~= 0 then
GetJson = GetJson..'"Managers":['
for k,v in pairs(Managers) do
if k == 1 then
GetJson =  GetJson..'"'..v..'"'
else
GetJson =  GetJson..',"'..v..'"'
end
end   
GetJson = GetJson..'],'
end
if #Constructors ~= 0 then
GetJson = GetJson..'"Constructors":['
for k,v in pairs(Constructors) do
if k == 1 then
GetJson =  GetJson..'"'..v..'"'
else
GetJson =  GetJson..',"'..v..'"'
end
end   
GetJson = GetJson..'],'
end
if #BasicConstructors ~= 0 then
GetJson = GetJson..'"BasicConstructors":['
for k,v in pairs(BasicConstructors) do
if k == 1 then
GetJson =  GetJson..'"'..v..'"'
else
GetJson =  GetJson..',"'..v..'"'
end
end   
GetJson = GetJson..'],'
end
if #AekConstructors ~= 0 then
GetJson = GetJson..'"AekConstructors":['
for k,v in pairs(AekConstructors) do
if k == 1 then
GetJson =  GetJson..'"'..v..'"'
else
GetJson =  GetJson..',"'..v..'"'
end
end   
GetJson = GetJson..'],'
end
if LinkGroups then
GetJson = GetJson..'"LinkGroups":"'..LinkGroups..'",'
end
GetJson = GetJson..'"Welcomes":"'..Welcomes..'"}'
end
GetJson = GetJson..'}}'
local File = io.open('./'..AEK..'.json', "w")
File:write(GetJson)
File:close()
sendDocument(msg.chat_id_, msg.id_, 0, 1, nil, './'..AEK..'.json', '✫︙يحتوي الملف على ↫ '..#List..' مجموعه',dl_cb, nil)
io.popen('rm -rf ./'..AEK..'.json')
end
if text == 'رفع النسخه' and tonumber(msg.reply_to_message_id_) > 0 or text == 'رفع النسخه الاحتياطيه' and tonumber(msg.reply_to_message_id_) > 0 then   
function by_reply(extra, result, success)   
if result.content_.document_ then 
local ID_FILE = result.content_.document_.document_.persistent_id_ 
local File_Name = result.content_.document_.file_name_
AddFile(msg,msg.chat_id_,ID_FILE,File_Name)
end   
end
tdcli_function ({ ID = "GetMessage", chat_id_ = msg.chat_id_, message_id_ = tonumber(msg.reply_to_message_id_) }, by_reply, nil)
end
end

if DevAek:get(AEK.."SET:GAME"..msg.chat_id_) then  
if text and text:match("^(%d+)$") then
local NUM = text:match("^(%d+)$")
if tonumber(NUM) > 6 then
Dev_Aek( msg.chat_id_, msg.id_, 1,"✫︙يوجد فقط ( 6 ) اختيارات\n✫︙ارسل اختيارك مره اخرى", 1, "md")    
return false  end 
local GETNUM = DevAek:get(AEK.."GAMES"..msg.chat_id_)
if tonumber(NUM) == tonumber(GETNUM) then
DevAek:del(AEK.."SET:GAME"..msg.chat_id_)   
Dev_Aek( msg.chat_id_, msg.id_, 1,'✫︙*المحيبس باليد رقم* ↫ '..NUM..'\n✫︙*مبروك لقد ربحت وحصلت على 5 نقاط يمكنك استبدالها بالرسائل*', 1, "md") 
DevAek:incrby(AEK..'Aek:GamesNumber'..msg.chat_id_..msg.sender_user_id_,5)  
elseif tonumber(NUM) ~= tonumber(GETNUM) then
DevAek:del(AEK.."SET:GAME"..msg.chat_id_)   
Dev_Aek( msg.chat_id_, msg.id_, 1,'✫︙*المحيبس باليد رقم* ↫ '..GETNUM..'\n✫︙*للاسف لقد خسرت حاول مره اخرى للعثور على المحيبس*', 1, "md")
end
end
end
if DevAek:get(AEK..'DevAek4'..msg.sender_user_id_) then
if text and text:match("^الغاء$") then 
send(msg.chat_id_, msg.id_, "✫︙تم الغاء الامر")
DevAek:del(AEK..'DevAek4'..msg.sender_user_id_)
return false  end 
DevAek:del(AEK..'DevAek4'..msg.sender_user_id_)
local username = string.match(text, "@[%a%d_]+") 
tdcli_function({ID = "SearchPublicChat",username_ = username},function(arg,data) 
if data and data.message_ and data.message_ == "USERNAME_NOT_OCCUPIED" then 
send(msg.chat_id_, msg.id_, '✫︙المعرف لا يوجد فيه قناة')
return false  end
if data and data.type_ and data.type_.ID and data.type_.ID == 'PrivateChatInfo' then
send(msg.chat_id_, msg.id_, '✫︙عذرا لا يمكنك وضع معرف حسابات في الاشتراك')
return false  end
if data and data.type_ and data.type_.channel_ and data.type_.channel_.is_supergroup_ == true then
send(msg.chat_id_, msg.id_, '✫︙عذرا لا يمكنك وضع معرف مجموعه في الاشتراك')
return false  end
if data and data.type_ and data.type_.channel_ and data.type_.channel_.is_supergroup_ == false then
if data and data.type_ and data.type_.channel_ and data.type_.channel_.ID and data.type_.channel_.status_.ID == 'ChatMemberStatusEditor' then
send(msg.chat_id_, msg.id_,'✫︙البوت ادمن في القناة \n✫︙تم تفعيل الاشتراك الاجباري \n✫︙ايدي القناة ↫ '..data.id_..'\n✫︙معرف القناة ↫ [@'..data.type_.channel_.username_..']')
DevAek:set(AEK..'Aek:ChId',data.id_)
else
send(msg.chat_id_, msg.id_,'✫︙عذرا البوت ليس ادمن في القناة')
end
return false  
end
end,nil)
end

if DevAek:get(AEK.."Aek:DevText" .. msg.chat_id_ .. ":" .. msg.sender_user_id_) then
if text and text:match("^الغاء$") then 
DevAek:del(AEK.."Aek:DevText" .. msg.chat_id_ .. ":" .. msg.sender_user_id_)
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙تم الغاء الامر', 1, 'md')
return false 
end 
DevAek:del(AEK.."Aek:DevText" .. msg.chat_id_ .. ":" .. msg.sender_user_id_)
local DevText = msg.content_.text_:match("(.*)")
DevAek:set(AEK.."DevText", DevText)
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙تم حفظ كليشة المطور", 1, "md")
end
if DevAek:get(AEK..'Aek:NameBot'..msg.sender_user_id_) == 'msg' then
if text and text:match("^الغاء$") then 
DevAek:del(AEK..'Aek:NameBot'..msg.sender_user_id_)
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙تم الغاء الامر', 1, 'md')
return false 
end 
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙تم حفظ اسم البوت ', 1, 'html')
DevAek:del(AEK..'Aek:NameBot'..msg.sender_user_id_)
DevAek:set(AEK..'Aek:NameBot', text)
return false 
end

if ChatType == 'sp' or ChatType == 'gp'  then
if text == "الرابط" then
if not DevAek:get(AEK.."Aek:Lock:GpLinks"..msg.chat_id_) then 
if DevAek:get(AEK.."Aek:Groups:Links"..msg.chat_id_) then
local Text = "✫︙ قم باختيار صيغة الرابط لجلبه ↫ ⤈"
local inline = {{{text="• الرابط نص •",callback_data="/LinkText:"..msg.sender_user_id_},{text="• الرابط انلاين •",callback_data="/LinkInline:"..msg.sender_user_id_}},{{text="• اخفاء الكليشه •",callback_data="/HideHelpList:"..msg.sender_user_id_}}}
SendInline(msg.chat_id_,Text,nil,inline,msg.id_/2097152/0.5)
else 
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙ لايوجد رابط ارسل ↫ ضع رابط او ارسل ↫ انشاء رابط للانشاء', 1, 'md')
end
else
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙ جلب رابط المجموعه معطل', 1, 'md')
end
end

if text == 'بوت' or text == 'بوتت' then 
NameBot = (DevAek:get(AEK..'Aek:NameBot') or 'ايبو')
local AEKTEAM = {"لتكول بوت اسمي "..NameBot.." 😒🔪","اسمي القميل "..NameBot.." 😚♥️","عندي اسم تره 😒💔","صيحولي "..NameBot.." كافي بوت 😒🔪","انت البوت لك 😒💔"} 
Dev_Aek(msg.chat_id_, msg.id_, 1, AEKTEAM[math.random(#AEKTEAM)] , 1, 'html') 
return false
end
if text == 'اسم البوت' or text == 'البوت شنو اسمه' or text == 'شسمه البوت' or text == 'البوت شسمه' then
NameBot = (DevAek:get(AEK..'Aek:NameBot') or 'ايبو') 
local AEKTEAM = {"اسمي القميل "..NameBot.." 😚♥️","هلاا يروحيي وياكك "..NameBot.." 😻♥️"} 
Dev_Aek(msg.chat_id_, msg.id_, 1, AEKTEAM[math.random(#AEKTEAM)] , 1, 'html') 
return false
end
if text and text == (DevAek:get(AEK..'Aek:NameBot') or 'ايبو') then 
NameBot = (DevAek:get(AEK..'Aek:NameBot') or 'ايبو')
local AEKTEAM = {'😸♥️ هلا كلبي وياك '..NameBot..' تفضل','ترةه مصختهاا احجيي شرايد 😕😒💔','اطلقق واحدد يصيح '..NameBot..' 😻♥️','خبصتت امنةة شتريدد عااد 🤧😒💔'} 
Dev_Aek(msg.chat_id_, msg.id_, 1, AEKTEAM[math.random(#AEKTEAM)] , 1, 'html') 
return false 
end
if text =='نقاطي' and SourcelionCh(msg) then 
if tonumber((DevAek:get(AEK..'Aek:GamesNumber'..msg.chat_id_..msg.sender_user_id_) or 0)) == 0 then
Dev_Aek(msg.chat_id_, msg.id_, 1,'✫︙لم تربح اي نقطه\n✫︙ارسل ↫ الالعاب للعب', 1, 'md')
else 
Dev_Aek(msg.chat_id_, msg.id_, 1,'✫︙عدد النقاط التي ربحتها ↫ '..(DevAek:get(AEK..'Aek:GamesNumber'..msg.chat_id_..msg.sender_user_id_)), 1, 'md')
end
end
if text ==  'حذف رسائلي' and SourcelionCh(msg) or text ==  'مسح رسائلي' and SourcelionCh(msg) then DevAek:del(AEK..'Aek:UsersMsgs'..msg.chat_id_..':'..msg.sender_user_id_) Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙تم حذف جميع رسائلك', 1, 'md') end
if text ==  'حذف نقاطي' and SourcelionCh(msg) or text ==  'مسح نقاطي' and SourcelionCh(msg) then DevAek:del(AEK..'Aek:GamesNumber'..msg.chat_id_..msg.sender_user_id_) Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙تم حذف جميع نقاطك', 1, 'md') end

if text == 'ترتيب' and SourcelionCh(msg) or text == 'الترتيب' and SourcelionCh(msg) then
if not DevAek:get(AEK..'Aek:Lock:Games'..msg.chat_id_) then
DevAek2 = {'سحور','سياره','استقبال','قنفه','ايفون','بزونه','مطبخ','كرستيانو','دجاجه','مدرسه','الوان','غرفه','ثلاجه','كهوه','سفينه','العراق','محطه','طياره','رادار','منزل','مستشفى','كهرباء','تفاحه','اخطبوط','سلمون','فرنسا','برتقاله','تفاح','مطرقه','بتيته','لهانه','شباك','باص','سمكه','ذباب','تلفاز','حاسوب','انترنيت','ساحه','جسر'};
name = DevAek2[math.random(#DevAek2)]
DevAek:set(AEK..'Aek:GameNum'..msg.chat_id_,name)
DevAek:del(AEK..'Aek:Games:Ids'..msg.chat_id_)
name = string.gsub(name,'سحور','س ر و ح')
name = string.gsub(name,'سياره','ه ر س ي ا')
name = string.gsub(name,'استقبال','ل ب ا ت ق س ا')
name = string.gsub(name,'قنفه','ه ق ن ف')
name = string.gsub(name,'ايفون','و ن ف ا')
name = string.gsub(name,'بزونه','ز و ه ن')
name = string.gsub(name,'مطبخ','خ ب ط م')
name = string.gsub(name,'كرستيانو','س ت ا ن و ك ر ي')
name = string.gsub(name,'دجاجه','ج ج ا د ه')
name = string.gsub(name,'مدرسه','ه م د ر س')
name = string.gsub(name,'الوان','ن ا و ا ل')
name = string.gsub(name,'غرفه','غ ه ر ف')
name = string.gsub(name,'ثلاجه','ج ه ت ل ا')
name = string.gsub(name,'كهوه','ه ك ه و')
name = string.gsub(name,'سفينه','ه ن ف ي س')
name = string.gsub(name,'العراق','ق ع ا ل ر ا')
name = string.gsub(name,'محطه','ه ط م ح')
name = string.gsub(name,'طياره','ر ا ط ي ه')
name = string.gsub(name,'رادار','ر ا ر ا د')
name = string.gsub(name,'منزل','ن ز م ل')
name = string.gsub(name,'مستشفى','ى ش س ف ت م')
name = string.gsub(name,'كهرباء','ر ب ك ه ا ء')
name = string.gsub(name,'تفاحه','ح ه ا ت ف')
name = string.gsub(name,'اخطبوط','ط ب و ا خ ط')
name = string.gsub(name,'سلمون','ن م و ل س')
name = string.gsub(name,'فرنسا','ن ف ر س ا')
name = string.gsub(name,'برتقاله','ر ت ق ب ا ه ل')
name = string.gsub(name,'تفاح','ح ف ا ت')
name = string.gsub(name,'مطرقه','ه ط م ر ق')
name = string.gsub(name,'بتيته','ب ت ت ي ه')
name = string.gsub(name,'لهانه','ه ن ل ه ل')
name = string.gsub(name,'شباك','ب ش ا ك')
name = string.gsub(name,'باص','ص ا ب')
name = string.gsub(name,'سمكه','ك س م ه')
name = string.gsub(name,'ذباب','ب ا ب ذ')
name = string.gsub(name,'تلفاز','ت ف ل ز ا')
name = string.gsub(name,'حاسوب','س ا ح و ب')
name = string.gsub(name,'انترنيت','ا ت ن ر ن ي ت')
name = string.gsub(name,'ساحه','ح ا ه س')
name = string.gsub(name,'جسر','ر ج س')
AEKTEAM = '✫︙اول واحد يرتبها يربح ↫ '..name
Dev_Aek(msg.chat_id_, msg.id_, 1,AEKTEAM, 1, 'md')
return false
end end
if text == DevAek:get(AEK..'Aek:GameNum'..msg.chat_id_) and not DevAek:get(AEK..'Aek:Games:Ids'..msg.chat_id_) then
if not DevAek:get(AEK..'Aek:Games:Ids'..msg.chat_id_) then 
AEKTEAM = '✫︙مبروك لقد ربحت في اللعبه \n✫︙ارسل ↫ ترتيب للعب مره اخرى'
Dev_Aek(msg.chat_id_, msg.id_, 1,AEKTEAM, 1, 'md')
DevAek:incrby(AEK..'Aek:GamesNumber'..msg.chat_id_..msg.sender_user_id_, 1)  
end
DevAek:set(AEK..'Aek:Games:Ids'..msg.chat_id_,true)
end
if text == 'سمايلات' and SourcelionCh(msg) or text == 'سمايل' and SourcelionCh(msg) or text == 'السمايلات' and SourcelionCh(msg) then
if not DevAek:get(AEK..'Aek:Lock:Games'..msg.chat_id_) then
DevAek2 = {'🍏','🍎','🍐','🍊','🍋','🍌','🍉','🍇','🍓','🍈','🍒','🍑','🍍','🥥','🥝','🍅','🍆','🥑','🥦','🥒','🌶','🌽','🥕','🥔','🍠','🥐','🍞','🥖','🥨','🧀','🥚','🍳','🥞','🥓','🥩','🍗','🍖','🌭','🍔','🍟','🍕','🥪','🥙','🍼','☕️','🍵','🥤','🍶','🍺','🍻','🏀','⚽️','🏈','⚾️','🎾','🏐','🏉','🎱','🏓','🏸','🥅','🎰','🎮','🎳','🎯','🏆','🎻','🎸','🎺','🥁','🎹','🎼','🎧','🎤','🎬','🎨','🎭','🎪','🛎','📤','🎗','🏵','🎖','🏆','🥌','🛷','🚕','🚗','🚙','🚌','🚎','🏎','🚓','🚑','🚚','🚛','🚜','🇮🇶','⚔️','🛡','🔮','🌡','💣','⏱','🛢','📓','📗','📂','📅','📪','📫','📬','📭','⏰','📺','🎚','☎️','📡'}
name = DevAek2[math.random(#DevAek2)]
DevAek:set(AEK..'Aek:GameNum'..msg.chat_id_,name)
DevAek:del(AEK..'Aek:Games:Ids'..msg.chat_id_)
name = string.gsub(name,'🍞','🍞')
name = string.gsub(name,'🥖','🥖')
name = string.gsub(name,'🥨','🥨')
name = string.gsub(name,'🧀','🧀')
name = string.gsub(name,'🥚','🥚')
name = string.gsub(name,'🍳','🍳')
name = string.gsub(name,'🥞','🥞')
name = string.gsub(name,'🥓','🥓')
name = string.gsub(name,'🥩','🥩')
name = string.gsub(name,'🍗','🍗')
name = string.gsub(name,'🍖','🍖')
name = string.gsub(name,'🌭','🌭')
name = string.gsub(name,'🍔','🍔')
name = string.gsub(name,'🍟','🍟')
name = string.gsub(name,'🍕','🍕')
name = string.gsub(name,'🥪','🥪')
name = string.gsub(name,'🥙','🥙')
name = string.gsub(name,'🍼','🍼')
name = string.gsub(name,'☕️','☕️')
name = string.gsub(name,'🍵','🍵')
name = string.gsub(name,'🥤','🥤')
name = string.gsub(name,'🍶','🍶')
name = string.gsub(name,'🍺','🍺')
name = string.gsub(name,'🍏','🍏')
name = string.gsub(name,'🍎','🍎')
name = string.gsub(name,'🍐','🍐')
name = string.gsub(name,'🍊','🍊')
name = string.gsub(name,'🍋','🍋')
name = string.gsub(name,'🍌','🍌')
name = string.gsub(name,'🍉','🍉')
name = string.gsub(name,'🍇','🍇')
name = string.gsub(name,'🍓','🍓')
name = string.gsub(name,'🍈','🍈')
name = string.gsub(name,'🍒','🍒')
name = string.gsub(name,'🍑','🍑')
name = string.gsub(name,'🍍','🍍')
name = string.gsub(name,'🥥','🥥')
name = string.gsub(name,'🥝','🥝')
name = string.gsub(name,'🍅','🍅')
name = string.gsub(name,'🍆','🍆')
name = string.gsub(name,'🥑','🥑')
name = string.gsub(name,'🥦','🥦')
name = string.gsub(name,'🥒','🥒')
name = string.gsub(name,'🌶','🌶')
name = string.gsub(name,'🌽','🌽')
name = string.gsub(name,'🥕','🥕')
name = string.gsub(name,'🥔','🥔')
name = string.gsub(name,'🍠','🍠')
name = string.gsub(name,'🥐','🥐')
name = string.gsub(name,'🍻','🍻')
name = string.gsub(name,'🏀','🏀')
name = string.gsub(name,'⚽️','⚽️')
name = string.gsub(name,'🏈','🏈')
name = string.gsub(name,'⚾️','⚾️')
name = string.gsub(name,'🎾','🎾')
name = string.gsub(name,'🏐','🏐')
name = string.gsub(name,'🏉','🏉')
name = string.gsub(name,'🎱','🎱')
name = string.gsub(name,'🏓','🏓')
name = string.gsub(name,'🏸','🏸')
name = string.gsub(name,'🥅','🥅')
name = string.gsub(name,'🎰','🎰')
name = string.gsub(name,'🎮','🎮')
name = string.gsub(name,'🎳','🎳')
name = string.gsub(name,'🎯','🎯')
name = string.gsub(name,'🏆','🏆')
name = string.gsub(name,'🎻','🎻')
name = string.gsub(name,'🎸','🎸')
name = string.gsub(name,'🎺','🎺')
name = string.gsub(name,'🥁','🥁')
name = string.gsub(name,'🎹','🎹')
name = string.gsub(name,'🎼','🎼')
name = string.gsub(name,'🎧','🎧')
name = string.gsub(name,'🎤','🎤')
name = string.gsub(name,'🎬','🎬')
name = string.gsub(name,'🎨','🎨')
name = string.gsub(name,'🎭','🎭')
name = string.gsub(name,'🎪','🎪')
name = string.gsub(name,'🛎','🛎')
name = string.gsub(name,'📤','📤')
name = string.gsub(name,'🎗','🎗')
name = string.gsub(name,'🏵','🏵')
name = string.gsub(name,'🎖','🎖')
name = string.gsub(name,'🏆','🏆')
name = string.gsub(name,'🥌','🥌')
name = string.gsub(name,'🛷','🛷')
name = string.gsub(name,'🚕','🚕')
name = string.gsub(name,'🚗','🚗')
name = string.gsub(name,'🚙','🚙')
name = string.gsub(name,'🚌','🚌')
name = string.gsub(name,'🚎','🚎')
name = string.gsub(name,'🏎','🏎')
name = string.gsub(name,'🚓','🚓')
name = string.gsub(name,'🚑','🚑')
name = string.gsub(name,'🚚','🚚')
name = string.gsub(name,'🚛','🚛')
name = string.gsub(name,'🚜','🚜')
name = string.gsub(name,'🇮🇶','🇮🇶')
name = string.gsub(name,'⚔️','⚔️')
name = string.gsub(name,'🛡','🛡')
name = string.gsub(name,'🔮','🔮')
name = string.gsub(name,'🌡','🌡')
name = string.gsub(name,'💣','💣')
name = string.gsub(name,'⏱','⏱')
name = string.gsub(name,'🛢','🛢')
name = string.gsub(name,'📒','📒')
name = string.gsub(name,'📗','📗')
name = string.gsub(name,'📅','📆')
name = string.gsub(name,'📪','📪')
name = string.gsub(name,'📫','📫')
name = string.gsub(name,'📬','📬')
name = string.gsub(name,'📭','📭')
name = string.gsub(name,'⏰','⏰')
name = string.gsub(name,'📺','📺')
name = string.gsub(name,'🎚','🎚')
name = string.gsub(name,'☎️','☎️')
AEKTEAM = '✫︙اول واحد يدز هذا السمايل يربح ↫ '..name
Dev_Aek(msg.chat_id_, msg.id_, 1,AEKTEAM, 1, 'md')
return false
end end
if text == DevAek:get(AEK..'Aek:GameNum'..msg.chat_id_) and not DevAek:get(AEK..'Aek:Games:Ids'..msg.chat_id_) then
if not DevAek:get(AEK..'Aek:Games:Ids'..msg.chat_id_) then 
AEKTEAM = '✫︙مبروك لقد ربحت في اللعبه \n✫︙ارسل ↫ سمايلات للعب مره اخرى'
Dev_Aek(msg.chat_id_, msg.id_, 1,AEKTEAM, 1, 'md')
DevAek:incrby(AEK..'Aek:GamesNumber'..msg.chat_id_..msg.sender_user_id_, 1)  
end
DevAek:set(AEK..'Aek:Games:Ids'..msg.chat_id_,true)
end
if text == 'محيبس' and SourcelionCh(msg) or text == 'بات' and SourcelionCh(msg) or text == 'المحيبس' and SourcelionCh(msg) then
if not DevAek:get(AEK..'Aek:Lock:Games'..msg.chat_id_) then
Num = math.random(1,6)
DevAek:set(AEK.."GAMES"..msg.chat_id_,Num) 
TEST = [[
➀     ➁     ➂     ➃     ➄     ➅
↓     ↓     ↓     ↓     ↓     ↓
👊 ‹› 👊🏻 ‹› 👊🏼 ‹› 👊🏽 ‹› 👊🏾 ‹› 👊🏿

✫︙اختر رقم لاستخراج المحيبس
✫︙الفائز يحصل على (5) نقاط
]]
Dev_Aek(msg.chat_id_, msg.id_, 1, TEST, 1, "md") 
DevAek:setex(AEK.."SET:GAME"..msg.chat_id_, 100, true)  
return false  
end end
if text == 'حزوره' and SourcelionCh(msg) or text == 'الحزوره' and SourcelionCh(msg) then
if not DevAek:get(AEK..'Aek:Lock:Games'..msg.chat_id_) then
DevAek2 = {'الجرس','عقرب الساعه','السمك','المطر','5','الكتاب','البسمار','7','الكعبه','بيت الشعر','لهانه','انا','امي','الابره','الساعه','22','غلط','كم الساعه','البيتنجان','البيض','المرايه','الضوء','الهواء','الضل','العمر','القلم','المشط','الحفره','البحر','الثلج','الاسفنج','الصوت','بلم'};
name = DevAek2[math.random(#DevAek2)]
DevAek:set(AEK..'Aek:GameNum'..msg.chat_id_,name)
DevAek:del(AEK..'Aek:Games:Ids'..msg.chat_id_)
name = string.gsub(name,'الجرس','شيئ اذا لمسته صرخ ما هوه ؟')
name = string.gsub(name,'عقرب الساعه','اخوان لا يستطيعان تمضيه اكثر من دقيقه معا فما هما ؟')
name = string.gsub(name,'السمك','ما هو الحيوان الذي لم يصعد الى سفينة نوح عليه السلام ؟')
name = string.gsub(name,'المطر','شيئ يسقط على رأسك من الاعلى ولا يجرحك فما هو ؟')
name = string.gsub(name,'5','ما العدد الذي اذا ضربته بنفسه واضفت عليه 5 يصبح ثلاثين ')
name = string.gsub(name,'الكتاب','ما الشيئ الذي له اوراق وليس له جذور ؟')
name = string.gsub(name,'البسمار','ما هو الشيئ الذي لا يمشي الا بالضرب ؟')
name = string.gsub(name,'7','عائله مؤلفه من 6 بنات واخ لكل منهن .فكم عدد افراد العائله ')
name = string.gsub(name,'الكعبه','ما هو الشيئ الموجود وسط مكة ؟')
name = string.gsub(name,'بيت الشعر','ما هو البيت الذي ليس فيه ابواب ولا نوافذ ؟ ')
name = string.gsub(name,'لهانه','وحده حلوه ومغروره تلبس مية تنوره .من هيه ؟ ')
name = string.gsub(name,'انا','ابن امك وابن ابيك وليس باختك ولا باخيك فمن يكون ؟')
name = string.gsub(name,'امي','اخت خالك وليست خالتك من تكون ؟ ')
name = string.gsub(name,'الابره','ما هو الشيئ الذي كلما خطا خطوه فقد شيئا من ذيله ؟ ')
name = string.gsub(name,'الساعه','ما هو الشيئ الذي يقول الصدق ولكنه اذا جاع كذب ؟')
name = string.gsub(name,'22','كم مره ينطبق عقربا الساعه على بعضهما في اليوم الواحد ')
name = string.gsub(name,'غلط','ما هي الكلمه الوحيده التي تلفض غلط دائما ؟ ')
name = string.gsub(name,'كم الساعه','ما هو السؤال الذي تختلف اجابته دائما ؟')
name = string.gsub(name,'البيتنجان','جسم اسود وقلب ابيض وراس اخظر فما هو ؟')
name = string.gsub(name,'البيض','ماهو الشيئ الذي اسمه على لونه ؟')
name = string.gsub(name,'المرايه','ارى كل شيئ من دون عيون من اكون ؟ ')
name = string.gsub(name,'الضوء','ما هو الشيئ الذي يخترق الزجاج ولا يكسره ؟')
name = string.gsub(name,'الهواء','ما هو الشيئ الذي يسير امامك ولا تراه ؟')
name = string.gsub(name,'الضل','ما هو الشيئ الذي يلاحقك اينما تذهب ؟ ')
name = string.gsub(name,'العمر','ما هو الشيء الذي كلما طال قصر ؟ ')
name = string.gsub(name,'القلم','ما هو الشيئ الذي يكتب ولا يقرأ ؟')
name = string.gsub(name,'المشط','له أسنان ولا يعض ما هو ؟ ')
name = string.gsub(name,'الحفره','ما هو الشيئ اذا أخذنا منه ازداد وكبر ؟')
name = string.gsub(name,'البحر','ما هو الشيئ الذي يرفع اثقال ولا يقدر يرفع مسمار ؟')
name = string.gsub(name,'الثلج','انا ابن الماء فان تركوني في الماء مت فمن انا ؟')
name = string.gsub(name,'الاسفنج','كلي ثقوب ومع ذالك احفض الماء فمن اكون ؟')
name = string.gsub(name,'الصوت','اسير بلا رجلين ولا ادخل الا بالاذنين فمن انا ؟')
name = string.gsub(name,'بلم','حامل ومحمول نصف ناشف ونصف مبلول فمن اكون ؟ ')
AEKTEAM = '✫︙اول واحد يحلها يربح ↫ '..name
Dev_Aek(msg.chat_id_, msg.id_, 1,AEKTEAM, 1, 'md')
return false
end end
if text == DevAek:get(AEK..'Aek:GameNum'..msg.chat_id_) and not DevAek:get(AEK..'Aek:Games:Ids'..msg.chat_id_) then
if not DevAek:get(AEK..'Aek:Games:Ids'..msg.chat_id_) then 
AEKTEAM = '✫︙مبروك لقد ربحت في اللعبه \n✫︙ارسل ↫ حزوره للعب مره اخرى'
Dev_Aek(msg.chat_id_, msg.id_, 1,AEKTEAM, 1, 'md')
DevAek:incrby(AEK..'Aek:GamesNumber'..msg.chat_id_..msg.sender_user_id_, 1)  
end
DevAek:set(AEK..'Aek:Games:Ids'..msg.chat_id_,true)
end 
if text == 'المعاني' and SourcelionCh(msg) or text == 'معاني' and SourcelionCh(msg) then
if not DevAek:get(AEK..'Aek:Lock:Games'..msg.chat_id_) then
DevAek2 = {'قرد','دجاجه','بطريق','ضفدع','بومه','نحله','ديك','جمل','بقره','دولفين','تمساح','قرش','نمر','اخطبوط','سمكه','خفاش','اسد','فأر','ذئب','فراشه','عقرب','زرافه','قنفذ','تفاحه','باذنجان'}
name = DevAek2[math.random(#DevAek2)]
DevAek:set(AEK..'Aek:GameNum2'..msg.chat_id_,name)
DevAek:del(AEK..'Aek:Games:Ids'..msg.chat_id_)
name = string.gsub(name,'قرد','🐒')
name = string.gsub(name,'دجاجه','🐔')
name = string.gsub(name,'بطريق','🐧')
name = string.gsub(name,'ضفدع','🐸')
name = string.gsub(name,'بومه','🦉')
name = string.gsub(name,'نحله','🐝')
name = string.gsub(name,'ديك','🐓')
name = string.gsub(name,'جمل','🐫')
name = string.gsub(name,'بقره','🐄')
name = string.gsub(name,'دولفين','🐬')
name = string.gsub(name,'تمساح','🐊')
name = string.gsub(name,'قرش','🦈')
name = string.gsub(name,'نمر','🐅')
name = string.gsub(name,'اخطبوط','🐙')
name = string.gsub(name,'سمكه','🐟')
name = string.gsub(name,'خفاش','🦇')
name = string.gsub(name,'اسد','🦁')
name = string.gsub(name,'فأر','🐭')
name = string.gsub(name,'ذئب','🐺')
name = string.gsub(name,'فراشه','🦋')
name = string.gsub(name,'عقرب','🦂')
name = string.gsub(name,'زرافه','🦒')
name = string.gsub(name,'قنفذ','🦔')
name = string.gsub(name,'تفاحه','🍎')
name = string.gsub(name,'باذنجان','🍆')
AEKTEAM = '✫︙ما معنى هذا السمايل :؟ ↫ '..name
Dev_Aek(msg.chat_id_, msg.id_, 1,AEKTEAM, 1, 'md')
return false
end end
if text == DevAek:get(AEK..'Aek:GameNum2'..msg.chat_id_) and not DevAek:get(AEK..'Aek:Games:Ids'..msg.chat_id_) then
if not DevAek:get(AEK..'Aek:Games:Ids'..msg.chat_id_) then 
AEKTEAM = '✫︙مبروك لقد ربحت في اللعبه \n✫︙ارسل ↫ المعاني للعب مره اخرى'
Dev_Aek(msg.chat_id_, msg.id_, 1,AEKTEAM, 1, 'md')
DevAek:incrby(AEK..'Aek:GamesNumber'..msg.chat_id_..msg.sender_user_id_, 1)  
end
DevAek:set(AEK..'Aek:Games:Ids'..msg.chat_id_,true)
end 
if text == 'العكس' and SourcelionCh(msg) or text == 'عكس' and SourcelionCh(msg) then
if not DevAek:get(AEK..'Aek:Lock:Games'..msg.chat_id_) then
DevAek2 = {'باي','فهمت','موزين','اسمعك','احبك','موحلو','نضيف','حاره','ناصي','جوه','سريع','ونسه','طويل','سمين','ضعيف','شريف','شجاع','رحت','عدل','نشيط','شبعان','موعطشان','خوش ولد','اني','هادئ'}
name = DevAek2[math.random(#DevAek2)]
DevAek:set(AEK..'Aek:GameNum3'..msg.chat_id_,name)
DevAek:del(AEK..'Aek:Games:Ids'..msg.chat_id_)
name = string.gsub(name,'باي','هلو')
name = string.gsub(name,'فهمت','مافهمت')
name = string.gsub(name,'موزين','زين')
name = string.gsub(name,'اسمعك','ماسمعك')
name = string.gsub(name,'احبك','ماحبك')
name = string.gsub(name,'محلو','حلو')
name = string.gsub(name,'نضيف','وصخ')
name = string.gsub(name,'حاره','بارده')
name = string.gsub(name,'ناصي','عالي')
name = string.gsub(name,'جوه','فوك')
name = string.gsub(name,'سريع','بطيء')
name = string.gsub(name,'ونسه','ضوجه')
name = string.gsub(name,'طويل','قزم')
name = string.gsub(name,'سمين','ضعيف')
name = string.gsub(name,'ضعيف','قوي')
name = string.gsub(name,'شريف','كواد')
name = string.gsub(name,'شجاع','جبان')
name = string.gsub(name,'رحت','اجيت')
name = string.gsub(name,'حي','ميت')
name = string.gsub(name,'نشيط','كسول')
name = string.gsub(name,'شبعان','جوعان')
name = string.gsub(name,'موعطشان','عطشان')
name = string.gsub(name,'خوش ولد','موخوش ولد')
name = string.gsub(name,'اني','مطي')
name = string.gsub(name,'هادئ','عصبي')
AEKTEAM = '✫︙ما هو عكس كلمة ↫ '..name
Dev_Aek(msg.chat_id_, msg.id_, 1,AEKTEAM, 1, 'md')
return false
end end
if text == DevAek:get(AEK..'Aek:GameNum3'..msg.chat_id_) and not DevAek:get(AEK..'Aek:Games:Ids'..msg.chat_id_) then
if not DevAek:get(AEK..'Aek:Games:Ids'..msg.chat_id_) then 
AEKTEAM = '✫︙مبروك لقد ربحت في اللعبه \n✫︙ارسل ↫ العكس للعب مره اخرى'
Dev_Aek(msg.chat_id_, msg.id_, 1,AEKTEAM, 1, 'md')
DevAek:incrby(AEK..'Aek:GamesNumber'..msg.chat_id_..msg.sender_user_id_, 1)  
end
DevAek:set(AEK..'Aek:Games:Ids'..msg.chat_id_,true)
end 
if text == 'المختلف' and SourcelionCh(msg) or text == 'مختلف' and SourcelionCh(msg) then
if not DevAek:get(AEK..'Aek:Lock:Games'..msg.chat_id_) then
DevAek2 = {'😸','☠','🐼','🐇','🌑','🌚','⭐️','📥','⛈','🌥','⛄️','👨‍🔬','👨‍💻','👨‍🔧','👩‍🍳','🧚‍♀','🧚‍♂️','🧝‍♂','🙍‍♂','🧖‍♂','👬','👨‍👨‍👧','🕓','🕤','⌛️','📅','👩‍⚖️','👨‍🎨'};
name = DevAek2[math.random(#DevAek2)]
DevAek:set(AEK..'Aek:GameNum4'..msg.chat_id_,name)
DevAek:del(AEK..'Aek:Games:Ids'..msg.chat_id_)
name = string.gsub(name,'😸','😹😹😹😸😹😹😹😹')
name = string.gsub(name,'☠️','💀💀💀☠️💀💀💀💀')
name = string.gsub(name,'🐼','👻👻👻👻👻👻👻🐼')
name = string.gsub(name,'🐇','🕊🕊🕊🕊🕊🐇🕊🕊')
name = string.gsub(name,'🌑','🌚🌚🌚🌚🌚🌑🌚🌚')
name = string.gsub(name,'🌚','🌑🌑🌑🌑🌑🌚🌑🌑')
name = string.gsub(name,'⭐️','🌟🌟🌟🌟🌟🌟⭐️🌟')
name = string.gsub(name,'📥','💫💫💫📥💫💫💫💫')
name = string.gsub(name,'⛈','🌨🌨🌨⛈🌨🌨🌨🌨')
name = string.gsub(name,'🌥','⛅️⛅️⛅️🌥⛅️⛅️⛅️⛅️')
name = string.gsub(name,'⛄️','☃️☃️☃️☃️⛄️☃️☃️☃️☃️')
name = string.gsub(name,'👨‍🔬','👩‍🔬👩‍🔬👩‍🔬👩‍🔬👩‍🔬👨‍🔬👩‍🔬👩‍🔬')
name = string.gsub(name,'👨‍💻','👩‍💻👩‍💻👨‍💻👩‍💻👩‍💻👩‍💻👩‍💻👩‍💻')
name = string.gsub(name,'👨‍🔧','👩‍🔧👩‍🔧👩‍🔧👩‍🔧👩‍🔧👩‍🔧👨‍🔧👩‍🔧')
name = string.gsub(name,'👩‍🍳','👨‍🍳👨‍🍳👩‍🍳👨‍🍳👨‍🍳👨‍🍳👨‍🍳👨‍🍳')
name = string.gsub(name,'🧚‍♀️','🧚‍♂️🧚‍♂️🧚‍♂️🧚‍♂️🧚‍♂️🧚‍♀️🧚‍♂️🧚‍♂️')
name = string.gsub(name,'🧚‍♂️','🧚‍♀️🧚‍♀️🧚‍♀️🧚‍♀️🧚‍♀️🧚‍♂️🧚‍♀️🧚‍♀️')
name = string.gsub(name,'🧝‍♂️','🧝‍♀️🧝‍♀️🧝‍♀️🧝‍♂️🧝‍♀️🧝‍♀️🧝‍♀️🧝‍♀️')
name = string.gsub(name,'🙍‍♂️','🙎‍♂️🙎‍♂️🙎‍♂️🙎‍♂️🙍‍♂️🙎‍♂️🙎‍♂️🙎‍♂️')
name = string.gsub(name,'🧖‍♂️','🧖‍♀️🧖‍♀️🧖‍♀️🧖‍♂️🧖‍♀️🧖‍♀️🧖‍♀️🧖‍♀️')
name = string.gsub(name,'👬','👭👭👭👭👬👭👭👭')
name = string.gsub(name,'👨‍👨‍👧','👨‍👨‍👦👨‍👨‍👦👨‍👨‍👦👨‍👨‍👦👨‍👨‍👦👨‍👨‍👧👨‍👨‍👦👨‍👨‍👦')
name = string.gsub(name,'🕓','🕒🕒🕒🕒🕓🕒🕒🕒')
name = string.gsub(name,'🕤','🕥🕥🕥🕥🕥🕤🕥🕥')
name = string.gsub(name,'⌛️','⏳⏳⏳⏳⏳⌛️⏳⏳')
name = string.gsub(name,'📅','📆📆📆📆📆📅📆📆')
name = string.gsub(name,'👩‍⚖️','👨‍⚖️👨‍⚖️👨‍⚖️👨‍⚖️👨‍⚖️👩‍⚖️👨‍⚖️👨‍⚖️')
name = string.gsub(name,'👨‍🎨','👩‍🎨👩‍🎨👨‍🎨👩‍🎨👩‍🎨👩‍🎨👩‍🎨👩‍🎨')
AEKTEAM = '✫︙اول واحد يطلع المختلف يربح\n{'..name..'} '
Dev_Aek(msg.chat_id_, msg.id_, 1,AEKTEAM, 1, 'md')
return false
end end
if text == DevAek:get(AEK..'Aek:GameNum4'..msg.chat_id_) and not DevAek:get(AEK..'Aek:Games:Ids'..msg.chat_id_) then
if not DevAek:get(AEK..'Aek:Games:Ids'..msg.chat_id_) then 
AEKTEAM = '✫︙مبروك لقد ربحت في اللعبه \n✫︙ارسل ↫ المختلف للعب مره اخرى'
Dev_Aek(msg.chat_id_, msg.id_, 1,AEKTEAM, 1, 'md')
DevAek:incrby(AEK..'Aek:GamesNumber'..msg.chat_id_..msg.sender_user_id_, 1)  
end
DevAek:set(AEK..'Aek:Games:Ids'..msg.chat_id_,true)
end  
if text == 'امثله' and SourcelionCh(msg) or text == 'الامثله' and SourcelionCh(msg) then
if not DevAek:get(AEK..'Aek:Lock:Games'..msg.chat_id_) then
DevAek2 = {
'جوز','ضراطه','الحبل','الحافي','شقره','بيدك','سلايه','النخله','الخيل','حداد','المبلل','يركص','قرد','العنب','العمه','الخبز','بالحصاد','شهر','شكه','يكحله',
};
name = DevAek2[math.random(#DevAek2)]
DevAek:set(AEK..'Aek:GameNum5'..msg.chat_id_,name)
DevAek:del(AEK..'Aek:Games:Ids'..msg.chat_id_)
name = string.gsub(name,'جوز','ينطي ___ للماعنده سنون')
name = string.gsub(name,'ضراطه','الي يسوق المطي يتحمل ___ ')
name = string.gsub(name,'بيدك','اكل ___ محد يفيدك')
name = string.gsub(name,'الحافي','تجدي من ___ نعال')
name = string.gsub(name,'شقره','مع الخيل يا ___ ')
name = string.gsub(name,'النخله','الطول طول ___ والعقل عقل الصخلة')
name = string.gsub(name,'سلايه','بالوجه امراية وبالظهر ___ ')
name = string.gsub(name,'الخيل','من قلة ___ شدو على الچلاب سروج')
name = string.gsub(name,'حداد','موكل من صخم وجهه كال آني ___ ')
name = string.gsub(name,'المبلل',' ___ ما يخاف من المطر')
name = string.gsub(name,'الحبل','اللي تلدغة الحية يخاف من جرة ___ ')
name = string.gsub(name,'يركص','المايعرف ___ يكول الكاع عوجه')
name = string.gsub(name,'العنب','المايلوح ___ يكول حامض')
name = string.gsub(name,'العمه','___ إذا حبت الچنة ابليس يدخل الجنة')
name = string.gsub(name,'الخبز','انطي ___ للخباز حتى لو ياكل نصه')
name = string.gsub(name,'بالحصاد','اسمة ___ ومنجله مكسور')
name = string.gsub(name,'شهر','امشي ___ ولا تعبر نهر')
name = string.gsub(name,'شكه','يامن تعب يامن ___ يا من على الحاضر لكة')
name = string.gsub(name,'القرد',' ___ بعين امه غزال')
name = string.gsub(name,'يكحله','اجه ___ عماها')
AEKTEAM = '✫︙اكمل المثال التالي ↫ ['..name..']'
Dev_Aek(msg.chat_id_, msg.id_, 1,AEKTEAM, 1, 'md')
return false
end end
if text == DevAek:get(AEK..'Aek:GameNum5'..msg.chat_id_) then
if not DevAek:get(AEK..'Aek:Games:Ids'..msg.chat_id_) then 
DevAek:incrby(AEK..'Aek:GamesNumber'..msg.chat_id_..msg.sender_user_id_, 1)  
DevAek:del(AEK..'Aek:GameNum5'..msg.chat_id_)
AEKTEAM = '✫︙مبروك لقد ربحت في اللعبه \n✫︙ارسل ↫ امثله للعب مره اخرى'
Dev_Aek(msg.chat_id_, msg.id_, 1,AEKTEAM, 1, 'md')
end
DevAek:set(AEK..'Aek:Games:Ids'..msg.chat_id_,true)
end  
if text == 'رياضيات' and SourcelionCh(msg) or text == 'الرياضيات' and SourcelionCh(msg) then
if not DevAek:get(AEK..'Aek:Lock:Games'..msg.chat_id_) then
DevAek2 = {'9','46','2','9','5','4','25','10','17','15','39','5','16',};
name = DevAek2[math.random(#DevAek2)]
DevAek:set(AEK..'Aek:GameNum6'..msg.chat_id_,name)
DevAek:del(AEK..'Aek:Games:Ids'..msg.chat_id_)
name = string.gsub(name,'9','7 + 2 = ?')
name = string.gsub(name,'46','41 + 5 = ?')
name = string.gsub(name,'2','5 - 3 = ?')
name = string.gsub(name,'9','5 + 2 + 2 = ?')
name = string.gsub(name,'5','8 - 3 = ?')
name = string.gsub(name,'4','40 ÷ 10 = ?')
name = string.gsub(name,'25','30 - 5 = ?')
name = string.gsub(name,'10','100 ÷ 10 = ?')
name = string.gsub(name,'17','10 + 5 + 2 = ?')
name = string.gsub(name,'15','25 - 10 = ?')
name = string.gsub(name,'39','44 - 5 = ?')
name = string.gsub(name,'5','12 + 1 - 8 = ?')
name = string.gsub(name,'16','16 + 16 - 16 = ?')
AEKTEAM = '✫︙اكمل المعادله التاليه ↫ ⤈\n{'..name..'} '
Dev_Aek(msg.chat_id_, msg.id_, 1,AEKTEAM, 1, 'md')
return false
end end
if text == DevAek:get(AEK..'Aek:GameNum6'..msg.chat_id_) then
if not DevAek:get(AEK..'Aek:Games:Ids'..msg.chat_id_) then 
DevAek:incrby(AEK..'Aek:GamesNumber'..msg.chat_id_..msg.sender_user_id_, 1)  
DevAek:del(AEK..'Aek:GameNum6'..msg.chat_id_)
AEKTEAM = '✫︙مبروك لقد ربحت في اللعبه \n✫︙ارسل ↫ رياضيات للعب مره اخرى'
Dev_Aek(msg.chat_id_, msg.id_, 1,AEKTEAM, 1, 'md')
end
DevAek:set(AEK..'Aek:Games:Ids'..msg.chat_id_,true)
end  
if text == 'الانكليزي' and SourcelionCh(msg) or text == 'الانجليزيه' and SourcelionCh(msg) or text == 'انكليزيه' and SourcelionCh(msg) then
if not DevAek:get(AEK..'Aek:Lock:Games'..msg.chat_id_) then
DevAek2 = {'معلومات','قنوات','مجموعات','كتاب','تفاحه','سدني','نقود','اعلم','ذئب','تمساح','ذكي','شاطئ','غبي',};
name = DevAek2[math.random(#DevAek2)]
DevAek:set(AEK..'Aek:GameNum7'..msg.chat_id_,name)
DevAek:del(AEK..'Aek:Games:Ids'..msg.chat_id_)
name = string.gsub(name,'ذئب','Wolf')
name = string.gsub(name,'معلومات','Information')
name = string.gsub(name,'قنوات','Channels')
name = string.gsub(name,'مجموعات','Groups')
name = string.gsub(name,'كتاب','Book')
name = string.gsub(name,'تفاحه','Apple')
name = string.gsub(name,'نقود','money')
name = string.gsub(name,'اعلم','I know')
name = string.gsub(name,'تمساح','crocodile')
name = string.gsub(name,'شاطئ','Beach')
name = string.gsub(name,'غبي','Stupid')
name = string.gsub(name,'صداقه','Friendchip')
AEKTEAM = '✫︙ما معنى كلمة ↫ '..name
Dev_Aek(msg.chat_id_, msg.id_, 1,AEKTEAM, 1, 'md')
return false
end end
if text == DevAek:get(AEK..'Aek:GameNum7'..msg.chat_id_) then
if not DevAek:get(AEK..'Aek:Games:Ids'..msg.chat_id_) then 
DevAek:incrby(AEK..'Aek:GamesNumber'..msg.chat_id_..msg.sender_user_id_, 1)  
DevAek:del(AEK..'Aek:GameNum7'..msg.chat_id_)
AEKTEAM = '✫︙مبروك لقد ربحت في اللعبه \n✫︙ارسل ↫ انكليزيه للعب مره اخرى'
Dev_Aek(msg.chat_id_, msg.id_, 1,AEKTEAM, 1, 'md')
end
DevAek:set(AEK..'Aek:Games:Ids'..msg.chat_id_,true)
end  

if text == 'اسئله' and SourcelionCh(msg) or text == 'اختيارات' and SourcelionCh(msg) or text == 'الاسئله' and SourcelionCh(msg) or text == 'اساله' and SourcelionCh(msg) then
if not DevAek:get(AEK..'Aek:Lock:Games'..msg.chat_id_) then
DevAek2 = {'النيل','14','الفم','11','30','بوتين','ستيف جوبر','باريس','10','النمل','حرف الواو','الشعر','سحاب','الاسم','ذهب','حرف الام','العزائم','انسات','المنجنيق','اسيا','6','الاسد','مهر','الدولفين','اوروبا','الزئبق','لندن','الانسان','طوكيو','خديجه',}
name = DevAek2[math.random(#DevAek2)]
DevAek:set(AEK..'Aek:GameNum8'..msg.chat_id_,name)
DevAek:del(AEK..'Aek:Games:Ids'..msg.chat_id_)
name = string.gsub(name,'النيل','✫︙ماهو اطول نهر في العالم ؟\n1- النيل\n2- الفرات\n3- نهر الكونغو')
name = string.gsub(name,'14','✫︙ماعدد عظام الوجه ؟\n1- 15\n2- 13\n3- 14')
name = string.gsub(name,'الفم','✫︙كراسي بيضاء وجدران ورديه اذا اغلقته اصبح ظلام  فمن اكون ؟\n1- الفم\n2- الاذن\n3- الثلاجه')
name = string.gsub(name,'11','✫︙كم جزء يحتوي مسلسل وادي الذئاب ؟\n1- 7\n2- 15\n3- 11')
name = string.gsub(name,'30','✫︙كم جزء يحتوي القران الكريم ؟\n1- 60\n2- 70\n3- 30')
name = string.gsub(name,'بوتين','✫︙من هوه اغنى رئيس في العالم ؟\n1- ترامب\n2- اوباما\n3- بوتين')
name = string.gsub(name,'ستيف جوبر','✫︙من هوه مؤسس شركه ابل العالميه  ؟\n1- لاري بايج\n2- بيل جيتس\n3- ستيف جوبر')
name = string.gsub(name,'باريس','ماهي عاصمه فرنسا ؟\n1- باريس\n2- لوين\n3- موسكو')
name = string.gsub(name,'10','✫︙ماعدد دول العربيه التي توجد في افريقيا ؟\n1- 10\n2- 17\n3- 9')
name = string.gsub(name,'النمل','✫︙ماهو الحيوان الذي يحمل 50 فوق وزنه ؟\n1- الفيل\n2- النمل\n3- الثور')
name = string.gsub(name,'حرف الواو','✫︙ماذا يوجد بيني وبينك ؟\n1- الضل\n2- الاخلاق\n3- حرف الواو')
name = string.gsub(name,'الشعر','✫︙ماهو الشيء النبات ينبت للانسان بلا بذر ؟\n1- الاضافر\n2- الاسنان\n3- الشعر')
name = string.gsub(name,'سحاب','✫︙ما هو الشّيء الذي يستطيع المشي بدون أرجل والبكاء بدون أعين ؟\n1- سحاب\n2- بئر\n3- نهر')
name = string.gsub(name,'الاسم','✫︙ما الشيء الذي نمتلكه , لكنّ غيرنا يستعمله أكثر منّا ؟\n1- العمر\n2- ساعه\n3- الاسم')
name = string.gsub(name,'ذهب','✫︙اصفر اللون سارق عقول اهل الكون وحارمهم لذيذ النوم ؟\n1- نحاس\n2- الماس\n3- ذهب')
name = string.gsub(name,'حرف الام','✫︙في الليل ثلاثة لكنه في النهار واحده فما هو ؟\n1- حرف الباء\n2- حرف الام\n3- حرف الراء')
name = string.gsub(name,'العزائم','✫︙على قدر اصل العزم تأتي ؟\n1- العزائم\n2- المكارم\n3- المبائب')
name = string.gsub(name,'انسات','✫︙ماهي جمع كلمه انسه ؟\n1- سيدات\n2- انسات\n3- قوانص')
name = string.gsub(name,'المنجنيق','✫︙اله اتسعلمت قديما في الحروب ؟\n1- الصاروخ\n2- المسدس\n3- المنجنيق')
name = string.gsub(name,'اسيا','✫︙تقع لبنان في قاره ؟\n1- افريقيا\n2- اسيا\n3- امركيا الشماليه')
name = string.gsub(name,'6','✫︙كم صفرا للمليون ؟\n1- 4\n2- 3\n3- 6')
name = string.gsub(name,'الاسد','✫︙ماهو الحيوان الذي يلقب بملك الغابه ؟\n1- الفيل\n2- الاسد\n3- النمر')
name = string.gsub(name,'مهر','✫︙ما اسم صغير الحصان ؟\n1- مهر\n2- جرو\n3- عجل')
name = string.gsub(name,'الدولفين','✫︙ما الحيوان الذي ينام واحدى عينه مفتوحه ؟\n1- القرش\n2- الدولفين\n3- الثعلب\n')
name = string.gsub(name,'اوروبا','✫︙ماهي القاره التي تلقب بالقاره العجوز ؟\n1- اوروبا\n2- امريكا الشماليه\n3- افريقيا')
name = string.gsub(name,'الزئبق','✫︙ما اسم المعدن الموجود فيي الحاله السائله ؟\n1- النحاس\n2- الحديد\n3- الزئبق')
name = string.gsub(name,'لندن','✫︙ماهي عاصمه انجلترا ؟\n1- لندن\n2- لفرسول\n3- تركيا')
name = string.gsub(name,'الانسان','✫︙ماهو الشئ الذي برأسه سبع فتحات ؟\n1- الهاتف\n2- التلفاز\n3- الانسان')
name = string.gsub(name,'طوكيو','✫︙ماهي عاصمه اليابان ؟\n1- بانكول\n2- نيو دلهي\n3- طوكيو')
name = string.gsub(name,'خديجه','✫︙من هي زوجه الرسول الاكبر منه سنآ ؟\n1- حفضه\n2- زينب\n3- خديجه')
AEKTEAM = name..'\n✫︙ارسل الجواب الصحيح فقط'
Dev_Aek(msg.chat_id_, msg.id_, 1,AEKTEAM, 1, 'md')
return false
end end
if text == DevAek:get(AEK..'Aek:GameNum8'..msg.chat_id_) then
if not DevAek:get(AEK..'Aek:Games:Ids'..msg.chat_id_) then 
DevAek:incrby(AEK..'Aek:GamesNumber'..msg.chat_id_..msg.sender_user_id_, 1)  
DevAek:del(AEK..'Aek:GameNum8'..msg.chat_id_)
AEKTEAM = '✫︙مبروك لقد ربحت في اللعبه \n✫︙ارسل ↫ الاسئله للعب مره اخرى'
Dev_Aek(msg.chat_id_, msg.id_, 1,AEKTEAM, 1, 'md')
end
DevAek:set(AEK..'Aek:Games:Ids'..msg.chat_id_,true)
end  

if DevAek:get(AEK.."GAME:TKMEN" .. msg.chat_id_ .. "" .. msg.sender_user_id_) then  
if text and text:match("^(%d+)$") then
local NUM = text:match("^(%d+)$")
if tonumber(NUM) > 20 then
Dev_Aek(msg.chat_id_, msg.id_, 1,"✫︙عذرا لا يمكنك تخمين عدد اكبر من الـ20 خمن رقم ما بين الـ1 والـ20", 1, 'md')
return false  end 
local GETNUM = DevAek:get(AEK.."GAMES:NUM"..msg.chat_id_)
if tonumber(NUM) == tonumber(GETNUM) then
DevAek:del(AEK..'Set:Num'..msg.chat_id_..msg.sender_user_id_)
DevAek:del(AEK.."GAME:TKMEN" .. msg.chat_id_ .. "" .. msg.sender_user_id_)   
DevAek:incrby(AEK..'Aek:GamesNumber'..msg.chat_id_..msg.sender_user_id_,5)  
Dev_Aek(msg.chat_id_, msg.id_, 1,'✫︙*التخمين الصحيح هو* ↫ '..NUM..'\n✫︙*مبروك لقد ربحت وحصلت على 5 نقاط يمكنك استبدالها بالرسائل*', 1, 'md')
elseif tonumber(NUM) ~= tonumber(GETNUM) then
DevAek:incrby(AEK..'Set:Num'..msg.chat_id_..msg.sender_user_id_,1)
if tonumber(DevAek:get(AEK..'Set:Num'..msg.chat_id_..msg.sender_user_id_)) >= 3 then
DevAek:del(AEK..'Set:Num'..msg.chat_id_..msg.sender_user_id_)
DevAek:del(AEK.."GAME:TKMEN" .. msg.chat_id_ .. "" .. msg.sender_user_id_)   
Dev_Aek(msg.chat_id_, msg.id_, 1,'✫︙*التخمين الصحيح هو* ↫ '..GETNUM..'\n✫︙*للاسف لقد خسرت حاول مره اخرى لتخمين الرقم الصحيح*', 1, 'md')
else
if tonumber(DevAek:get(AEK..'Set:Num'..msg.chat_id_..msg.sender_user_id_)) == 1 then
SetNum = 'محاولتان فقط'
elseif tonumber(DevAek:get(AEK..'Set:Num'..msg.chat_id_..msg.sender_user_id_)) == 2 then
SetNum = 'محاوله واحده فقط'
end
Dev_Aek(msg.chat_id_, msg.id_, 1,'✫︙لقد خمنت الرقم الخطا وتبقى لديك '..SetNum..' ارسل رقم تخمنه مره اخرى للفوز', 1, 'md')
end
end
end
end
if text == 'خمن' and SourcelionCh(msg) or text == 'تخمين' and SourcelionCh(msg) then   
if not DevAek:get(AEK..'Aek:Lock:Games'..msg.chat_id_) then
Num = math.random(1,20)
DevAek:set(AEK.."GAMES:NUM"..msg.chat_id_,Num) 
Dev_Aek(msg.chat_id_, msg.id_, 1,'✫︙اهلا بك عزيزي في لعبة التخمين ↫ ⤈\n ━───━ ✫ ━───━\n✫︙سيتم تخمين عدد ما بين الـ1 والـ20 اذا تعتقد انك تستطيع الفوز جرب واللعب الان .\n✫︙ملاحظه لديك ثلاث محاولات فقط فكر قبل ارسال تخمينك !', 1, 'md')
DevAek:setex(AEK.."GAME:TKMEN" .. msg.chat_id_ .. "" .. msg.sender_user_id_, 100, true)  
return false  
end
end

if text == 'روليت' then
if not DevAek:get(AEK..'Aek:Lock:Games'..msg.chat_id_) then
DevAek:del(AEK.."Aek:NumRolet"..msg.chat_id_..msg.sender_user_id_) 
DevAek:del(AEK..'Aek:ListRolet'..msg.chat_id_)  
DevAek:setex(AEK.."Aek:StartRolet"..msg.chat_id_..msg.sender_user_id_,3600,true)  
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙حسنا لنلعب , ارسل عدد اللاعبين للروليت .', 1, 'md')
return false  
end
end
if text and text:match("^(%d+)$") and DevAek:get(AEK.."Aek:StartRolet"..msg.chat_id_..msg.sender_user_id_) then
if text == "1" then
Text = "✫︙لا استطيع بدء اللعبه بلاعب واحد فقط"
else
DevAek:set(AEK.."Aek:NumRolet"..msg.chat_id_..msg.sender_user_id_,text)  
Text = '✫︙تم بدء تسجيل اللسته يرجى ارسال المعرفات \n✫︙الفائز يحصل على 5 نقاط عدد المطلوبين ↫ '..text..' لاعب'
end
DevAek:del(AEK.."Aek:StartRolet"..msg.chat_id_..msg.sender_user_id_)
send(msg.chat_id_,msg.id_,Text)
return false
end
if text and text:match('^(@[%a%d_]+)$') and DevAek:get(AEK.."Aek:NumRolet"..msg.chat_id_..msg.sender_user_id_) then 
if DevAek:sismember(AEK..'Aek:ListRolet'..msg.chat_id_,text) then
send(msg.chat_id_,msg.id_,'✫︙المعرف ↫ ['..text..'] موجود اساسا')
return false
end
tdcli_function ({ID = "SearchPublicChat",username_ = text},function(extra, res, success) 
if res and res.message_ and res.message_ == "USERNAME_NOT_OCCUPIED" then 
Dev_Aek(msg.chat_id_, msg.id_, 1,'✫︙المعرف غير صحيح يرجى ارسال معرف صحيح', 1, 'md')
return false 
end
DevAek:sadd(AEK..'Aek:ListRolet'..msg.chat_id_,text)
local CountAdd = DevAek:get(AEK.."Aek:NumRolet"..msg.chat_id_..msg.sender_user_id_)
local CountAll = DevAek:scard(AEK..'Aek:ListRolet'..msg.chat_id_)
local CountUser = CountAdd - CountAll
if tonumber(CountAll) == tonumber(CountAdd) then 
DevAek:del(AEK.."Aek:NumRolet"..msg.chat_id_..msg.sender_user_id_) 
DevAek:setex(AEK.."Aek:WittingStartRolet"..msg.chat_id_..msg.sender_user_id_,1400,true) 
local Text = "✫︙تم ادخال المعرف ↫ ["..text.."]\n✫︙وتم اكتمال العدد الكلي هل انت مستعد ؟"
keyboard = {} 
keyboard.inline_keyboard = {{{text="نعم",callback_data="/YesRolet"},{text="لا",callback_data="/NoRolet"}},{{text="اللاعبين",callback_data="/ListRolet"}}} 
Msg_id = msg.id_/2097152/0.5
return https.request("https://api.telegram.org/bot"..TokenBot..'/sendMessage?chat_id=' .. msg.chat_id_ .. '&text=' .. URL.escape(Text).."&reply_to_message_id="..Msg_id.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end 
local Text = "✫︙تم ادخال المعرف ↫ ["..text.."] وتبقى ↫ "..CountUser.." لاعبين ليكتمل العدد ارسل المعرف الاخر"
keyboard = {} 
keyboard.inline_keyboard = {{{text="الغاء",callback_data="/NoRolet"}}} 
Msg_id = msg.id_/2097152/0.5
return https.request("https://api.telegram.org/bot"..TokenBot..'/sendMessage?chat_id=' .. msg.chat_id_ .. '&text=' .. URL.escape(Text).."&reply_to_message_id="..Msg_id.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end,nil) 
end

if text == 'صراحه' and SourcelionCh(msg) or text == 'الصراحه' and SourcelionCh(msg) then
if not DevAek:get(AEK..'Aek:Lock:Games'..msg.chat_id_) then
local AEKTEAM = {"هل تعرضت لغدر في حياتك؟•","هل تعرف عيوبك؟•","هل تعرضت للخيانة في يومٍ ما؟•","ما هو القرار الذي اتخذتهُ ولم تندم عليه؟•","من هو الشخص الذي تُفكر به دائماً؟•","هل تتدخل إذا وجدت شخص يتعرض لحادثة سير أم تتركه وترحل؟•","من هو الشخص الذي لا تستطيع أن ترفض له أي طلب؟•","إذا أعجبت بشخصٍ ما كيف تُظهر له هذا الإعجاب أو ما هي الطريقة التي ستتبعها لتظهر إعجابك به؟•","هل ترى نفسك مُتناقضً؟•","ما هو الموقف الذي تعرضت فيه إلى الاحراج المُبرح؟•","ما هو الموقف الذي جعلك تبكي أمام مجموعة من الناس رغماً عنك؟•","إذا وجدت ورقة بيضاء فماذا ترسم لتعبر عن حالتك النفسية؟•","هل حاربت من أجل شخص؟•","ما هي الكلمة التي تُربكك؟•","إذا تركك من تحب، هل تعود إليه مرة أخرى أم تتركهُ وتنتظر وقت عودته؟•","من هو الشخص الذي تُصبح أمامه ضعيف؟","‏هل تحب المُشاركة الاجتماعية أم أنت شخص مُنطوي؟•","هل تنازلت عن مبدأك في الحياة؟•","اختصر حياتك في كلمة واحدة؟•","ما هو اسوأ خبر سمعته بحياتك؟•","من هو الشخص الذي لا تندم عليه إذا تركك وخرج من حياتك؟•","هل قلت كلام مُعين تتمنى ألا تقوله؟•","هل تشعر بحب التملك؟•","إذا وجدت الشخص الذي أحببتهُ في يومٍ ما يمسك بطفله هل هذا سيشعرك بالألم؟•","ما الذي يجعلك تُصاب بالغضب الشديد؟•","هل تتذكر السبب الذي بكيت من أجله أخر مرة؟•","هل كنت سبب في تدمير حياة أحد الأشخاص المُقربين إليك؟•","من هو الشخص الذي تستطيع أن تحكي له أي مشكلة بدون خجل؟•","هل أنت شخص صريح أم مُنافق؟•","من هو الشخص الذي رحل عن الحياة وعندما تتذكره تشعر بالألم؟•","حكمة تؤمن بها ؟•","هل شعرت بأنك تتمنى أن تموت وماهو السبب؟•","اذا احببت شخصاً في الوقت الخطأ وفي المكان الخطأ فماذا تفعل ؟•","من هو الشخص الذي خذلك؟•","هل تستطيع أن تعيش بدون أصدقاء؟•","فعلت شئ جعلك تشعر بانك غبي وجلست تسب نفسك ماهو؟•","هل تحكم على اي بنت بمجرد النظر الى لبسها؟ وماهو حد الحشمة عندك؟•","ماذا ستكتب لنا لتعبر عن حياتك التي عشتها الى الان في كلمات قليله ؟•","هل هزمك حزنك في يوماً من الايام؟• ","انت كل شيء بحياتي لمن تقولها ؟","هل تكره شخص بشده في حياتك ؟•"}
Dev_Aek(msg.chat_id_, msg.id_, 1, ''..AEKTEAM[math.random(#AEKTEAM)]..'' , 1, 'md')  
return false
end
end
if text == 'كت تويت' and SourcelionCh(msg) or text == 'كت' and SourcelionCh(msg) then
if not DevAek:get(AEK..'Aek:Lock:Games'..msg.chat_id_) then
local AEKTEAM = {
'آخر مرة زرت مدينة الملاهي؟','آخر مرة أكلت أكلتك المفضّلة؟','الوضع الحالي؟\n‏1. سهران\n‏2. ضايج\n‏3. أتأمل','آخر شيء ضاع منك؟','كلمة أخيرة لشاغل البال؟','طريقتك المعتادة في التخلّص من الطاقة السلبية؟','شهر من أشهر العام له ذكرى جميلة معك؟','كلمة غريبة من لهجتك ومعناها؟🤓','‏- شيء سمعته عالق في ذهنك هاليومين؟','متى تكره الشخص الذي أمامك حتى لو كنت مِن أشد معجبينه؟','‏- أبرز صفة حسنة في صديقك المقرب؟','هل تشعر أن هنالك مَن يُحبك؟','اذا اكتشفت أن أعز أصدقائك يضمر لك السوء، موقفك الصريح؟','أجمل شيء حصل معك خلال هاليوم؟','صِف شعورك وأنت تُحب شخص يُحب غيرك؟👀💔','كلمة لشخص غالي اشتقت إليه؟💕','آخر خبر سعيد، متى وصلك؟','أنا آسف على ....؟','أوصف نفسك بكلمة؟','صريح، مشتاق؟','‏- صريح، هل سبق وخذلت أحدهم ولو عن غير قصد؟','‏- ماذا ستختار من الكلمات لتعبر لنا عن حياتك التي عشتها الى الآن؟💭','‏- فنان/ة تود لو يدعوكَ على مائدة عشاء؟😁❤','‏- تخيّل شيء قد يحدث في المستقبل؟','‏- للشباب | آخر مرة وصلك غزل من فتاة؟🌚','شخص أو صاحب عوضك ونساك مُر الحياة ما اسمه ؟','| اذا شفت حد واعجبك وعندك الجرأه انك تروح وتتعرف عليه ، مقدمة الحديث شو راح تكون ؟.','كم مره تسبح باليوم','نسبة النعاس عندك حاليًا؟','لو فقط مسموح شخص واحد تتابعه فالسناب مين بيكون ؟','يهمك ملابسك تكون ماركة ؟','وش الشيء الي تطلع حرتك فيه و زعلت ؟','عندك أخوان او خوات من الرضاعة؟','عندك معجبين ولا محد درا عنك؟',
'أطول مدة قضيتها بعيد عن أهلك ؟','لو يجي عيد ميلادك تتوقع يجيك هدية؟','يبان عليك الحزن من " صوتك - ملامحك','وين تشوف نفسك بعد سنتين؟','وش يقولون لك لما تغني ؟','عندك حس فكاهي ولا نفسية؟','كيف تتصرف مع الشخص الفضولي ؟','كيف هي أحوال قلبك؟','حاجة تشوف نفسك مبدع فيها ؟','متى حبيت؟','شيء كل م تذكرته تبتسم ...','العلاقه السريه دايماً تكون حلوه؟','صوت مغني م تحبه','لو يجي عيد ميلادك تتوقع يجيك هدية؟','اذا احد سألك عن شيء م تعرفه تقول م اعرف ولا تتفلسف ؟','مع او ضد : النوم افضل حل لـ مشاكل الحياة؟','مساحة فارغة (..............) اكتب اي شيء تبين','اغرب اسم مر عليك ؟','عمرك كلمت فويس احد غير جنسك؟','اذا غلطت وعرفت انك غلطان تحب تعترف ولا تجحد؟','لو عندك فلوس وش السيارة اللي بتشتريها؟','وش اغبى شيء سويته ؟','شيء من صغرك ماتغير فيك؟','وش نوع الأفلام اللي تحب تتابعه؟','وش نوع الأفلام اللي تحب تتابعه؟','تجامل احد على حساب مصلحتك ؟','تتقبل النصيحة من اي شخص؟','كلمه ماسكه معك الفترة هذي ؟','متى لازم تقول لا ؟','اكثر شيء تحس انه مات ف مجتمعنا؟','تؤمن ان في "حُب من أول نظرة" ولا لا ؟.','تؤمن ان في "حُب من أول نظرة" ولا لا ؟.','هل تعتقد أن هنالك من يراقبك بشغف؟','اشياء اذا سويتها لشخص تدل على انك تحبه كثير ؟','اشياء صعب تتقبلها بسرعه ؟','اقتباس لطيف؟','أكثر جملة أثرت بك في حياتك؟','عندك فوبيا من شيء ؟.',
'اكثر لونين تحبهم مع بعض؟','أجمل بيت شعر سمعته ...','سبق وراودك شعور أنك لم تعد تعرف نفسك؟','تتوقع فيه احد حاقد عليك ويكرهك ؟','أجمل سنة ميلادية مرت عليك ؟','لو فزعت/ي لصديق/ه وقالك مالك دخل وش بتسوي/ين؟','وش تحس انك تحتاج الفترة هاذي ؟','يومك ضاع على؟','@منشن .. شخص تخاف منه اذا عصب ...','فيلم عالق في ذهنك لا تنساه مِن روعته؟','تختار أن تكون غبي أو قبيح؟','الفلوس او الحب ؟','أجمل بلد في قارة آسيا بنظرك؟','ما الذي يشغل بالك في الفترة الحالية؟','احقر الناس هو من ...','وين نلقى السعاده برايك؟','اشياء تفتخر انك م سويتها ؟','تزعلك الدنيا ويرضيك ؟','وش الحب بنظرك؟','افضل هديه ممكن تناسبك؟','كم في حسابك البنكي ؟','كلمة لشخص أسعدك رغم حزنك في يومٍ من الأيام ؟','عمرك انتقمت من أحد ؟!','ما السيء في هذه الحياة ؟','غنية عندك معاها ذكريات🎵🎻','/','أفضل صفة تحبه بنفسك؟','اكثر وقت تحب تنام فيه ...','أطول مدة نمت فيها كم ساعة؟','أصعب قرار ممكن تتخذه ؟','أفضل صفة تحبه بنفسك؟','اكثر وقت تحب تنام فيه ...','أنت محبوب بين الناس؟ ولاكريه؟','إحساسك في هاللحظة؟','اخر شيء اكلته ؟','تشوف الغيره انانيه او حب؟','اذكر موقف ماتنساه بعمرك؟','اكثر مشاكلك بسبب ؟','اول ماتصحى من النوم مين تكلمه؟','آخر مرة ضحكت من كل قلبك؟','لو الجنسية حسب ملامحك وش بتكون جنسيتك؟','اكثر شيء يرفع ضغطك','اذكر موقف ماتنساه بعمرك؟','لو قالوا لك تناول صنف واحد فقط من الطعام لمدة شهر .',
'هل أنت شخص رومانسي؟','ماهو رأيك بالحب؟','هل تحب شخص ما؟','اسم حبيبك/ج؟','تاريخ سوف تتزوج فيه؟','صفه حلوه بحبيبك/ج؟','صفه مو حلوه بحبيبك/ج؟','أغنيه تهديها لحبيبك/ج؟','تاريخ تعرفت فيه على حبيبك/ج؟','هل تفكر في الزواج؟','اسمك/ج؟','عمرك/ج؟','من وين انت/ي؟','دراستك/ج؟','كم اخ لديك/ج؟','كم اخت لديك/ج؟','مرتبط/ـه؟','ايش فونك/ج؟','كم سعر فونك/ج؟','مين جابلك/ج فونك/ج؟','لون فونك/ج؟','اخر مكالمه مع مين؟','اخر رساله من مين؟','عندك/ج كاميرا تصوير؟','اذا كالولك تترك اهلك تتركهم؟','اكثر واحد تحبه من اهلك؟','اهلك يفهمونك؟','تحب اهلك؟','تضحي بحياتك علمود اهلك؟','اهلك راضيين عنك؟','كذبت على اهلك تحت ظرف ما؟','سرقت من اهلك؟','يحبونك اهلك؟','مستعد تضحي باهلك؟','تصيح او ترفع صوتك ع اهلك؟','عايش مع اهلك لو منعزل عنهم؟','تحب اخوانك؟','تنتظر مسج من احد؟','كم طولك/ج؟','كم عمرك/ج؟','شي يعصبك/ج؟','شي يفرحك/ج؟','عاده ما تتغير فيك/ج؟','اسمك/ج؟','شكد متابعينك/ج بمواقع التواصل؟','شنو امنيتك/ج؟','كم مره حلمت/ـي بحبيبك/ج؟','لونك/ج المفضل؟','حبيت/ـي بفترة المراهقه؟','برأيك/ـج يا عمر مناسب للزواج؟','مستعد/ه للزواج هسه؟','مسلسلك/ج المفضل؟','راضي/ه عن حياتك/ج؟','منو قدوتك/ج؟','اعز صديق/ه عندك/ج؟','اقرب شخص الك/ج؟','انت بسرعه تنسه؟','سهل تتعلق بشخص؟','اشخاص تعرفت عليهم من مواقع التواصل؟','شخص تفتقد وجوده؟','انت شخص محبوب؟','انت شخص مغرور؟','انت شخص متسامح؟','انت شخص حاقد؟',
'انت شخص ضعيف؟','انت شخص قوي؟','انت شخص منعزل؟','انت شخص اجتماعي؟','انت شخص وحيد؟','انت شخص عندك اصدقاء؟','انت شخص تحب؟','انت شخص تكره؟','انت شخص تحب التجديد؟','انت شخص تكره التجديد؟','تفضل اصدقاء الواقع او النت؟','حبيت اغنيه بسبب احد؟','جرئ او خجول؟ ','اخر مصيبة سويتهه؟ ','امنيتك المستحيله؟ ','باسوورد فونك؟','سلبيات شخصيتك/ج؟','ايجابيات شخصيتك/ج؟','مودك حالياً؟','افضل فلم شاهدته؟','شكثر غرفتك هوسه الآن؟','شكثر كاشخ الآن؟','شكثر فرحان الآن؟','شكثر متوتر الآن؟','شكثر تحب الحياة؟','شكثر صحتك/ج زينه الآن؟','شكثر متحمس الآن؟','شكثر طفشان الآن؟','شكثر الجو حلو الآن؟','شكثر الجو مو حلو الآن؟','شكثر جوعان الآن؟','شكثر ذوقك بالموضه؟','حبيت احد بدون علمه؟','هل بحياتك خنت احد؟','هل بحياتك كرهت احد كنت تحبه؟','احد قالك احبك وما رديت عليه؟','هل بحياتك احد قالك سر وخبرت الكل؟','هل بحياتك اعطيت حسابك لشخص؟','هل بحياتك شتاقيت لشخص؟',
'هل بحياتك حاولت تنتحر؟','هل بحياتك انغرمت بشخص؟','هل بحياتك عجبك شخص وطلع بخيل؟','هل بحياتك عجبك شخص وطلع غبي؟','هل بحياتك تركك شخص؟','هل بحياتك تركت شخص؟','هل بحياتك نزلت Story لقهر شخص؟','هل بحياتك عملت Block لشخص؟','هل بحياتك سرقت صوره من شخص؟','شتريد تصير بالمستقبل؟','تفكر بمستقبلك هواي؟','وين تشوف نفسك بالمستقبل؟','تتوقع مستقبلك احلى من حاضرك؟','مستقبلك جيد لو مو شي؟','تتوقع مستقبلك احلى من ماضيك؟','فكرت تسوي اشياء بالمستقبل؟','ممكن تتزوج بعد سنتين؟','ممكن تحب بالمستقبل؟','فكرت تشتغل بالمستقبل؟','رؤيتك لنفسك تصير مشهور بالمستقبل؟','اول واحد تحظره من تصير مؤدب بالمستقبل؟','كم طفل يصير عندك بالمستقبل؟','تتوقع المستقبل حلو؟','كيف تشوف الجيل ذا؟','ردة فعلك لو مزح معك شخص م تعرفه ؟','احقر الناس هو من ...','تحب ابوك ولا امك','آخر فيلم مسلسل والتقييم🎥؟','أقبح القبحين في العلاقة: الغدر أو الإهمال🤷🏼؟','كلمة لأقرب شخص لقلبك🤍؟','حط@منشن لشخص وقوله "حركتك مالها داعي"😼!','اذا جاك خبر مفرح اول واحد تعلمه فيه مين💃🏽؟',
'طبع يمكن يخليك تكره شخص حتى لو كنت تُحبه🙅🏻‍♀️؟','افضل ايام الاسبوع عندك🔖؟','يقولون ان الحياة دروس ، ماهو أقوى درس تعلمته من الحياة🏙؟','تاريخ لن تنساه📅؟','تحب الصيف والا الشتاء❄️☀️؟','شخص تحب تستفزه😈؟','شنو ينادونك وانت صغير (عيارتك)👼🏻؟','عقل يفهمك/ج ولا قلب يحبك/ج❤️؟','اول سفره لك وين رح تكون✈️؟','كم عدد اللي معطيهم بلوك👹؟','نوعية من الأشخاص تتجنبهم في حياتك❌؟','شاركنا صورة او فيديو من تصويرك؟📸','كم من عشره تعطي حظك📩؟','اكثر برنامج تواصل اجتماعي تحبه😎؟','من اي دوله انت🌍؟','اكثر دوله ودك تسافر لها🏞؟','مقولة "نكبر وننسى" هل تؤمن بصحتها🧓🏼؟','تعتقد فيه أحد يراقبك👩🏼‍💻؟','لو بيدك تغير الزمن ، تقدمه ولا ترجعه🕰؟','مشروبك المفضل🍹؟','‏قم بلصق آخر اقتباس نسخته؟💭','كم وزنك/ج طولك/ج؟🌚','كم كان عمرك/ج قبل ٨ سنين😈؟','دوله ندمت انك سافرت لها😁؟','لو قالو لك ٣ أمنيات راح تتحقق عالسريع شنو تكون🧞‍♀️؟','‏- نسبة احتياجك للعزلة من 10📊؟','شخص تحبه حظرك بدون سبب واضح، ردة فعلك🧐؟','مبدأ في الحياة تعتمد عليه دائما🕯؟'
}  
Dev_Aek(msg.chat_id_, msg.id_, 1, ''..AEKTEAM[math.random(#AEKTEAM)]..'' , 1, 'md')  
return false
end
end

if text ==('تحكم') and SourcelionCh(msg) and Admin(msg) then
function prom_reply(extra, result, success)
tdcli_function ({ID = "GetUser",user_id_ = result.sender_user_id_},function(arg,dp) 
if dp.first_name_ == false then
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙الحساب محذوف", 1, "md")
return false  
end
local Text = '✫︙قم باستعمال الازرار للتحكم العضو ↫ ⤈\n✫︙العضو ↫ ['..dp.first_name_..'](t.me/'..(dp.username_ or 'HH_418')..')'
keyboard = {} 
keyboard.inline_keyboard = {{{text="رفع رتبه",callback_data=msg.sender_user_id_..":SetList:"..result.sender_user_id_},{text="تنزيل رتبه",callback_data=msg.sender_user_id_..":RemList:"..result.sender_user_id_}},{{text="كتم",callback_data=msg.sender_user_id_..":Mute:"..result.sender_user_id_},{text="الغاء كتم",callback_data=msg.sender_user_id_..":UnMute:"..result.sender_user_id_}},{{text="حظر",callback_data=msg.sender_user_id_..":Ban:"..result.sender_user_id_},{text="الغاء حظر",callback_data=msg.sender_user_id_..":UnBan:"..result.sender_user_id_}},{{text="تقيد",callback_data=msg.sender_user_id_..":Tkeed:"..result.sender_user_id_},{text="الغاء تقيد",callback_data=msg.sender_user_id_..":UnTkeed:"..result.sender_user_id_}},{{text = '‹  𝖲𝗈𝗎𝗋𝖼𝖾 𝙄𝘽𝙊 ›',url="t.me/HH_418"}}}
Msg_id = msg.id_/2097152/0.5
https.request("https://api.telegram.org/bot"..TokenBot..'/sendMessage?chat_id='..msg.chat_id_..'&text='..URL.escape(Text).."&reply_to_message_id="..Msg_id.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end,nil)
end 
if tonumber(tonumber(msg.reply_to_message_id_)) > 0 then
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),prom_reply)
end 
end

if text == 'الالعاب' and SourcelionCh(msg) or text == 'العاب' and SourcelionCh(msg) or text == 'اللعبه' and SourcelionCh(msg) then
if not DevAek:get(AEK..'Aek:Lock:Games'..msg.chat_id_) then
Dev_Aek(msg.chat_id_, msg.id_, 1,[[
✫︙قائمة العاب المجموعه ↫ ⤈
━───━ ✫ ━───━
✫︙لعبة التخمين ↫ خمن
✫︙لعبة الامثله ↫ امثله
✫︙لعبة العكس ↫ العكس
✫︙لعبة الاسئله ↫ اسئله
✫︙لعبة الروليت ↫ روليت
✫︙لعبة الحزوره ↫ حزوره
✫︙لعبة الترتيب ↫ ترتيب
✫︙لعبة المعاني ↫ معاني
✫︙لعبة الصراحه ↫ صراحه
✫︙لعبة التويت ↫ كت تويت
✫︙لعبة المختلف ↫ المختلف
✫︙لعبة السمايلات ↫ سمايلات
✫︙لعبة المحيبس ↫ المحيبس
✫︙لعبة الرياضيات ↫ رياضيات
✫︙لعبة الانكليزيه ↫ انكليزيه
━───━ ✫ ━───━
✫︙نقاطي • بيع نقاطي
━───━ ✫ ━───━
✫︙[‹  𝖲𝗈𝗎𝗋𝖼𝖾 𝙄𝘽𝙊 ›](https://t.me/HH_418)
]], 1, 'md')
else
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙عذرا الالعاب معطله في المجموعه', 1, 'md')
end
end

if text == 'بيع نقاطي' and SourcelionCh(msg) then
if tonumber((DevAek:get(AEK..'Aek:GamesNumber'..msg.chat_id_..msg.sender_user_id_) or 0)) == 0 then
Dev_Aek(msg.chat_id_, msg.id_, 1,'✫︙لم تربح اي نقطه\n✫︙ارسل ↫ الالعاب للعب', 1, 'md')
else
DevAek0 = (DevAek:get(AEK..'Aek:GamesNumber'..msg.chat_id_..msg.sender_user_id_) * 50)
DevAek:incrby(AEK..'Aek:UsersMsgs'..msg.chat_id_..':'..msg.sender_user_id_,DevAek0)
Dev_Aek(msg.chat_id_, msg.id_, 1,'✫︙تم بيع '..(DevAek:get(AEK..'Aek:GamesNumber'..msg.chat_id_..msg.sender_user_id_))..' من نقاطك\n✫︙كل نقطه تساوي 50 رساله', 'md')
DevAek:del(AEK..'Aek:GamesNumber'..msg.chat_id_..msg.sender_user_id_)
end
end

if text == 'رفع المشرفين' and Manager(msg) and SourcelionCh(msg) or text == 'رفع الادمنيه' and Manager(msg) and SourcelionCh(msg) then  
tdcli_function ({ID = "GetChannelMembers",channel_id_ = msg.chat_id_:gsub("-100",""),filter_ = {ID = "ChannelMembersAdministrators"},offset_ = 0,limit_ = 200},function(arg,Aekan) 
local num = 0
local admins = Aekan.members_  
for i=0 , #admins do   
if Aekan.members_[i].bot_info_ == false and Aekan.members_[i].status_.ID == "ChatMemberStatusEditor" then
DevAek:sadd(AEK..'Aek:Admins:'..msg.chat_id_, admins[i].user_id_)   
num = num + 1
tdcli_function ({ID = "GetUser",user_id_ = admins[i].user_id_},function(arg,dp) 
if dp.first_name_ == false then
DevAek:srem(AEK..'Aek:Admins:'..msg.chat_id_, admins[i].user_id_)   
end
end,nil)   
else
DevAek:srem(AEK..'Aek:Admins:'..msg.chat_id_, admins[i].user_id_)   
end 
if Aekan.members_[i].status_.ID == "ChatMemberStatusCreator" then  
Manager_id = admins[i].user_id_  
DevAek:sadd(AEK..'Aek:BasicConstructor:'..msg.chat_id_,Manager_id)  
DevAek:sadd(AEK..'Aek:AekConstructor:'..msg.chat_id_,Manager_id)   
end  
end  
if num == 0 then
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙لا يوجد ادمنيه ليتم رفعهم\n✫︙تم رفع مالك المجموعه", 1, 'md')
else
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙تم رفع '..num..' من الادمنيه \n✫︙تم رفع مالك المجموعه', 1, 'md')
end
end,nil) 
end

if text == 'غادر' and SudoBot(msg) then
if DevAek:get(AEK.."Aek:Left:Bot"..AEK) and not SecondSudo(msg) then
Dev_Aek(msg.chat_id_,msg.id_, 1, "✫︙المغادره معطله من قبل المطور الاساسي", 1, 'md')
return false  
end
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙تم مغادرة المجموعه \n✫︙تم حذف جميع بياناتها ', 1, 'md')
ChatLeave(msg.chat_id_, AEK)
DevAek:srem(AEK.."Aek:Groups",msg.chat_id_)
end

if text ==('موقعي') and SourcelionCh(msg) then
tdcli_function ({ID = "GetChatMember",chat_id_ = msg.chat_id_,user_id_ = msg.sender_user_id_},function(arg,da) 
if da.status_.ID == "ChatMemberStatusCreator" then
rtpa = 'المنشئ'
elseif da.status_.ID == "ChatMemberStatusEditor" then
rtpa = 'الادمن'
elseif da.status_.ID == "ChatMemberStatusMember" then
rtpa = 'عضو'
end
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙موقعك ↫ '..rtpa, 1, 'md')
end,nil)
end

if text == "معلوماتي" and SourcelionCh(msg) then
function get_me(extra,result,success)
local msguser = tonumber(DevAek:get(AEK..'Aek:UsersMsgs'..msg.chat_id_..':'..msg.sender_user_id_))
local user_msgs = DevAek:get(AEK..'Aek:UsersMsgs'..msg.chat_id_..':'..msg.sender_user_id_)
local cont = (tonumber(DevAek:get(AEK..'Aek:ContactNumber'..msg.chat_id_..':'..msg.sender_user_id_)) or 0)
local user_nkt = tonumber(DevAek:get(AEK..'Aek:GamesNumber'..msg.chat_id_..msg.sender_user_id_) or 0)
if result.username_ then username = '@'..result.username_ else username = 'لا يوجد' end
if result.last_name_ then lastname = result.last_name_ else lastname = '' end
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙اسمك ↫ ❨ ['..result.first_name_..'] ❩\n✫︙معرفك ↫ ❨ ['..username..'] ❩\n✫︙ايديك ↫ ❨ `'..result.id_..'` ❩\n✫︙نقاطك ↫ ❨ '..user_nkt..' ❩\n✫︙رسائلك ↫ ❨ '..user_msgs..' ❩\n✫︙جهاتك ↫ ❨ '..cont..' ❩\n✫︙تفاعلك ↫ '..formsgs(msguser)..'\n✫︙رتبتك ↫ '..IdRank(msg.sender_user_id_, msg.chat_id_), 1, 'md')
end
getUser(msg.sender_user_id_,get_me)
end
end

if text == "تعيين قناة الاشتراك" or text == "تغيير قناة الاشتراك" or text == "تعيين الاشتراك الاجباري" or text == "وضع قناة الاشتراك" then
if not SecondSudo(msg) then
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙للمطور الاساسي فقط ', 1, 'md')
else
DevAek:setex(AEK..'DevAek4'..msg.sender_user_id_,360,true)
send(msg.chat_id_, msg.id_, '✫︙ارسل لي معرف قناة الاشتراك الان')
end
return false  
end
if text == "تفعيل الاشتراك الاجباري" then  
if not SecondSudo(msg) then
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙للمطور الاساسي فقط ', 1, 'md')
else
if DevAek:get(AEK..'Aek:ChId') then
local Check = https.request('https://api.telegram.org/bot'..TokenBot..'/getChat?chat_id='..DevAek:get(AEK.."Aek:ChId"))
local GetInfo = JSON.decode(Check)
send(msg.chat_id_, msg.id_,"✫︙الاشتراك الاجباري مفعل \n✫︙على القناة ↫ [@"..GetInfo.result.username.."]")
else
DevAek:setex(AEK..'DevAek4'..msg.sender_user_id_,360,true)
send(msg.chat_id_, msg.id_,"✫︙لاتوجد قناة لتفعيل الاشتراك\n✫︙ارسل لي معرف قناة الاشتراك الان")
end
end
return false  
end
if text == "تعطيل الاشتراك الاجباري" then  
if not SecondSudo(msg) then
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙للمطور الاساسي فقط ', 1, 'md')
else
DevAek:del(AEK..'Aek:ChId')
local AEKTEAM = '✫︙اهلا عزيزي ↫ '..AekRank(msg)..' \n✫︙تم تعطيل الاشتراك الاجباري'
Aekmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, AEKTEAM, 14, string.len(msg.sender_user_id_))
end
return false  
end
if text == "حذف قناة الاشتراك" or text == "حذف قناه الاشتراك" then
if not SecondSudo(msg) then
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙للمطور الاساسي فقط ', 1, 'md')
else
DevAek:del(AEK..'Aek:ChId')
Dev_Aek(msg.chat_id_, msg.id_, 1,"✫︙تم حذف قناة الاشتراك الاجباري", 1, 'md') 
end
end
if SecondSudo(msg) then
if text == 'جلب قناة الاشتراك' or text == 'قناة الاشتراك' or text == 'الاشتراك الاجباري' or text == 'قناة الاشتراك الاجباري' then
if DevAek:get(AEK..'Aek:ChId') then
local Check = https.request('https://api.telegram.org/bot'..TokenBot..'/getChat?chat_id='..DevAek:get(AEK.."Aek:ChId"))
local GetInfo = JSON.decode(Check)
send(msg.chat_id_, msg.id_, "✫︙قناة الاشتراك ↫ [@"..GetInfo.result.username.."]")
else
send(msg.chat_id_, msg.id_, "✫︙لاتوجد قناة في الاشتراك الاجباري")
end
return false  
end end

if SudoBot(msg) then
if text == 'اذاعه للكل بالتوجيه' and tonumber(msg.reply_to_message_id_) > 0 then
function AEKTEAM(extra,result,success)
if DevAek:get(AEK.."Aek:Send:Bot"..AEK) and not SecondSudo(msg) then 
send(msg.chat_id_, msg.id_,"✫︙الاذاعه معطله من قبل المطور الاساسي")
return false
end
local GpList = DevAek:smembers(AEK.."Aek:Groups")
for k,v in pairs(GpList) do
tdcli_function({ID="ForwardMessages", chat_id_ = v, from_chat_id_ = msg.chat_id_, message_ids_ = {[0] = result.id_}, disable_notification_ = 0, from_background_ = 1},function(a,t) end,nil) 
end
local PvList = DevAek:smembers(AEK.."Aek:Users")
for k,v in pairs(PvList) do
tdcli_function({ID="ForwardMessages", chat_id_ = v, from_chat_id_ = msg.chat_id_, message_ids_ = {[0] = result.id_}, disable_notification_ = 0, from_background_ = 1},function(a,t) end,nil) 
end
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙تم اذاعة رسالتك بالتوجيه \n✫︙‏في ↫ ❨ '..#GpList..' ❩ مجموعه \n✫︙والى ↫ ❨ '..#PvList..' ❩ مشترك \n ✓', 1, 'md')
end
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),AEKTEAM)
end
end

if text:match('^الحساب (%d+)$') and SourcelionCh(msg) then
local id = text:match('^الحساب (%d+)$')
local text = 'اضغط لمشاهدة العضو ⁞ ✫'
tdcli_function ({ID="SendMessage", chat_id_=msg.chat_id_, reply_to_message_id_=msg.id_, disable_notification_=0, from_background_=1, reply_markup_=nil, input_message_content_={ID="InputMessageText", text_=text, disable_web_page_preview_=1, clear_draft_=0, entities_={[0] = {ID="MessageEntityMentionName", offset_=0, length_=19, user_id_=id}}}}, dl_cb, nil)
end
if text == "مشاهده المنشور" and SourcelionCh(msg) or text == "مشاهدات المنشور" and SourcelionCh(msg) or text == "عدد المشاهدات" and SourcelionCh(msg) then
DevAek:set(AEK..'Aek:viewget'..msg.sender_user_id_,true)
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙حسنا قم باعادة توجيه للمنشور الذي تريدني حساب مشاهداته', 1, 'md')
end

if text == "السورس" and SourcelionCh(msg) or text == "سورس" and SourcelionCh(msg) then 
local text =  [[
Welcome To Source
⌁︙ LION TEAM
— >• — >• — >• 
⌁︙[Source Channel](https://t.me/HH_418)

⌁︙[ExpLaNaTiOns](https://t.me/ZBZBZ0)

⌁︙[ProGrAmmEr](https://t.me/IBOIBO100)
— >• — >• — >• 
⌁︙[𝖲𝗈𝗎𝗋𝖼𝖾 𝙄𝘽𝙊](https://t.me/So_rsbot)

]]
Dev_Aek(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end

if ChatType == 'sp' or ChatType == 'gp'  then
if text == "اطردني" and SourcelionCh(msg) or text == "ادفرني" and SourcelionCh(msg) then
if DevAek:get(AEK.."Aek:Kick:Me"..msg.chat_id_) then
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙عذرا هذه الخاصيه معطله ', 1, 'md')
return false
end
DevAek:set(AEK..'yes'..msg.sender_user_id_..'', 'delyes')
DevAek:set(AEK..'no'..msg.sender_user_id_..'', 'delno')
local Text = '✫︙هل انت متأكد من المغادره'
keyboard = {} 
keyboard.inline_keyboard = {{{text="نعم",callback_data="/delyes"},{text="لا",callback_data="/delno"}}} 
Msg_id = msg.id_/2097152/0.5
return https.request("https://api.telegram.org/bot"..TokenBot..'/sendMessage?chat_id=' .. msg.chat_id_ .. '&text=' .. URL.escape(Text).."&reply_to_message_id="..Msg_id.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end

if text == 'تعطيل اطردني' and Manager(msg) and SourcelionCh(msg) then
DevAek:set(AEK.."Aek:Kick:Me"..msg.chat_id_, true)
local AEKTEAM = '✫︙اهلا عزيزي ↫ '..AekRank(msg)..' \n✫︙تم تعطيل امر اطردني'
Aekmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, AEKTEAM, 14, string.len(msg.sender_user_id_))
end
if text == 'تفعيل اطردني' and Manager(msg) and SourcelionCh(msg) then
DevAek:del(AEK.."Aek:Kick:Me"..msg.chat_id_)
local AEKTEAM = '✫︙اهلا عزيزي ↫ '..AekRank(msg)..' \n✫︙تم تفعيل امر اطردني'
Aekmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, AEKTEAM, 14, string.len(msg.sender_user_id_))
end

if text == "نزلني" and SourcelionCh(msg) then
if DevAek:get(AEK.."Aek:Del:Me"..msg.chat_id_) then
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙عذرا هذه الخاصيه معطله ', 1, 'md')
return false
end
DevAek:set(AEK..'yesdel'..msg.sender_user_id_..'', 'delyes')
DevAek:set(AEK..'nodel'..msg.sender_user_id_..'', 'delno')
local Text = '✫︙هل انت متأكد من تنزيلك'
keyboard = {} 
keyboard.inline_keyboard = {{{text="نعم",callback_data="/yesdel"},{text="لا",callback_data="/nodel"}}} 
Msg_id = msg.id_/2097152/0.5
return https.request("https://api.telegram.org/bot"..TokenBot..'/sendMessage?chat_id=' .. msg.chat_id_ .. '&text=' .. URL.escape(Text).."&reply_to_message_id="..Msg_id.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end

if text == 'تعطيل نزلني' and BasicConstructor(msg) and SourcelionCh(msg) then
DevAek:set(AEK.."Aek:Del:Me"..msg.chat_id_, true)
local AEKTEAM = '✫︙اهلا عزيزي ↫ '..AekRank(msg)..' \n✫︙تم تعطيل امر نزلني'
Aekmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, AEKTEAM, 14, string.len(msg.sender_user_id_))
end
if text == 'تفعيل نزلني' and BasicConstructor(msg) and SourcelionCh(msg) then
DevAek:del(AEK.."Aek:Del:Me"..msg.chat_id_)
local AEKTEAM = '✫︙اهلا عزيزي ↫ '..AekRank(msg)..' \n✫︙تم تفعيل امر نزلني'
Aekmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, AEKTEAM, 14, string.len(msg.sender_user_id_))
end

if Admin(msg) then
if text == "تاك الكل" and SourcelionCh(msg) or text == "تاك للكل" and SourcelionCh(msg) then
function TagAll(dp1,dp2)
local text = "✫︙قائمة الاعضاء \n━───━ ✫ ━───━\n"
i = 0
for k, v in pairs(dp2.members_) do
i = i + 1
if DevAek:get(AEK..'Save:UserName'..v.user_id_) then
text = text..""..i.."~ : [@"..DevAek:get(AEK..'Save:UserName'..v.user_id_).."]\n"
else
text = text..""..i.."~ : "..v.user_id_.."\n"
end
end 
Dev_Aek(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
tdcli_function({ID = "GetChannelMembers",channel_id_ = getChatId(msg.chat_id_).ID, offset_ = 0,limit_ = 100},TagAll,nil)
end

if text and text:match("^كللهم (.*)$") and SourcelionCh(msg) then
local txt = {string.match(text, "^(كللهم) (.*)$")}
function TagAll(dp1,dp2)
local text = "✫︙"..txt[2].." \n━───━ ✫ ━───━\n"
i = 0
for k, v in pairs(dp2.members_) do
i = i + 1
if DevAek:get(AEK..'Save:UserName'..v.user_id_) then
text = text..""..i.."~ : [@"..DevAek:get(AEK..'Save:UserName'..v.user_id_).."]\n"
else
text = text..""..i.."~ : "..v.user_id_.."\n"
end
end 
Dev_Aek(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
tdcli_function({ID = "GetChannelMembers",channel_id_ = getChatId(msg.chat_id_).ID, offset_ = 0,limit_ = 100},TagAll,nil)
end
end


if text == "رسائلي" and msg.reply_to_message_id_ == 0 and SourcelionCh(msg) then
local user_msgs = DevAek:get(AEK..'Aek:UsersMsgs'..msg.chat_id_..':'..msg.sender_user_id_)
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙عدد رسائلك هنا ↫ *❨ "..user_msgs.." ❩*", 1, 'md')
end
if text == "التفاعل" and SourcelionCh(msg) or text == "تفاعل الكروب" and SourcelionCh(msg) or text == "تفاعل المجموعه" and SourcelionCh(msg) or text == "احصائيات التفاعل" and SourcelionCh(msg) then
local EntryNumber = (DevAek:get(AEK..'Aek:EntryNumber'..msg.chat_id_..':'..os.date('%d')) or 0)
local ExitNumber = (DevAek:get(AEK..'Aek:ExitNumber'..msg.chat_id_..':'..os.date('%d')) or 0)
local MsgNumberDay = (DevAek:get(AEK..'Aek:MsgNumberDay'..msg.chat_id_..':'..os.date('%d')) or 0)
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙انضمام الاعضاء اليوم ↫ *"..EntryNumber.."*\n✫︙مغادرة الاعضاء اليوم ↫ *"..ExitNumber.."*\n✫︙عدد الرسائل اليوم ↫ *"..MsgNumberDay.."*\n✫︙نسبة التفاعل اليوم ↫ *"..math.random(40,100).."%*", 1, 'md')
end

if text == "معرفي" and SourcelionCh(msg) then
function get_username(extra,result,success)
text = '✫︙معرفك ↫ ❨ User ❩'
local text = text:gsub('User',('@'..result.username_ or ''))
Dev_Aek(msg.chat_id_, msg.id_, 1, text, 1, 'html')
end
getUser(msg.sender_user_id_,get_username)
end
if text == "اسمي" and SourcelionCh(msg) then
function get_firstname(extra,result,success)
text = '✫︙اسمك ↫ firstname lastname'
local text = text:gsub('firstname',(result.first_name_ or ''))
local text = text:gsub('lastname',(result.last_name_ or ''))
Dev_Aek(msg.chat_id_, msg.id_, 1, text, 1, 'html')
end
getUser(msg.sender_user_id_,get_firstname)
end   

if text == "اهمس" or text == "همسه" or text == "بوت الهمسه" or text == "اريد بوت الهمسه" or text == "دزلي بوت الهمسه" or text == "دزولي بوت الهمسه" then  Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙@hmosabot', 1, 'md') end
if text == "رابط حذف" or text == "رابط الحذف" or text == "اريد رابط الحذف" or text == "شمرلي رابط الحذف" or text == "اشمرلي رابط الحذف" or text == "اريد رابط حذف" or text == "رابط حذف حسابات" or text == "راح احذف" then local inline = {{{text="اضغط هنا",url="https://my.telegram.org/auth?to=delete"}}} SendInline(msg.chat_id_,'✫︙اضغط للحصول على الرابط',nil,inline) return false end
if text == "بوت رنوشه" or text == "اريد بوت رنوشه" or text == "معرف بوت رنوشه" or text == "معرف رنوشه" or text == "بوت ردود" or text == "بوت رنوشة" then local inline = {{{text="اضغط هنا",url="https://t.me/RnoshaBot"}}} SendInline(msg.chat_id_,'✫︙اضغط للحصول على رنوشه',nil,inline) return false end
if text == "بوت رتوشه" or text == "اريد بوت رتوشه" or text == "معرف بوت رتوشه" or text == "معرف رتوشه" or text == "بوت الردود" or text == "بوت رتوشة" then local inline = {{{text="اضغط هنا",url="https://t.me/RtoshaBot"}}} SendInline(msg.chat_id_,'✫︙اضغط للحصول على البوت',nil,inline) return false end
if text == "بوت كانونه" or text == "اريد بوت كانونه" or text == "معرف بوت كانونه" or text == "معرف كانونه" or text == "بوت اغاني" or text == "بوت أغاني" then local inline = {{{text="اضغط هنا",url="https://t.me/KanonhBot"}}} SendInline(msg.chat_id_,'✫︙اضغط للحصول على البوت',nil,inline) return false end
if text == "بوت سنيك" or text == "اريد بوت سنيك" or text == "معرف بوت سنيك" or text == "معرف سنيك" or text == "بوت الحمايه" or text == "بوت الحماية" then local inline = {{{text="اضغط هنا",url="https://t.me/Sn7kebot"}}} SendInline(msg.chat_id_,'✫︙اضغط للحصول على البوت',nil,inline) return false end
if text == "بوت جبل" or text == "اريد بوت جبل" or text == "معرف بوت جبل" or text == "معرف جبل" or text == "بوت حمايه" or text == "بوت حماية" then local inline = {{{text="اضغط هنا",url="https://t.me/Jbllbot"}}} SendInline(msg.chat_id_,'✫︙اضغط للحصول على البوت',nil,inline) return false end
if text == "جهاتي" and SourcelionCh(msg) or text == "اضافاتي" and SourcelionCh(msg) then add = (tonumber(DevAek:get(AEK..'Aek:ContactNumber'..msg.chat_id_..':'..msg.sender_user_id_)) or 0) Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙عدد جهاتك المضافه ↫ *❨ "..add.." ❩* ", 1, 'md') end
if text == "تعديلاتي" and SourcelionCh(msg) or text == "سحكاتي" and SourcelionCh(msg) then local edit_msg = DevAek:get(AEK..'Aek:EditMsg'..msg.chat_id_..msg.sender_user_id_) or 0  Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙عدد تعديلاتك ↫ *❨ "..edit_msg.." ❩* ", 1, 'md') end
if text == "ايديي" and SourcelionCh(msg) then Dev_Aek(msg.chat_id_, msg.id_, 1,'✫︙ايديك ↫ ❨ `'..msg.sender_user_id_..'` ❩', 1, 'md') end
if text == "رتبتي" and SourcelionCh(msg) then Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙رتبتك ↫ '..IdRank(msg.sender_user_id_, msg.chat_id_), 1, 'html') end
if text == "ايدي المجموعه" and SourcelionCh(msg) then Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙ايدي المجموعه ↫ `"..msg.chat_id_.."`", 1, 'md') end
if text == 'مسح سحكاتي' or text == 'مسح تعديلاتي' or text == 'حذف سحكاتي' or text == 'حذف تعديلاتي' then DevAek:del(AEK..'Aek:EditMsg'..msg.chat_id_..msg.sender_user_id_) Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙تم حذف جميع تعديلاتك بنجاح' , 1, 'md') end
if text == 'مسح جهاتي' or text == 'مسح اضافاتي' or text == 'حذف جهاتي' or text == 'حذف اضافاتي' then DevAek:del(AEK..'Aek:ContactNumber'..msg.chat_id_..':'..msg.sender_user_id_) Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙تم حذف جميع جهاتك المضافه' , 1, 'md') end

if text == "المطور" and SourcelionCh(msg) then 
local DevText = DevAek:get(AEK.."DevText")
if DevAek:get(AEK.."Aek:ChId") then local Check = https.request('https://api.telegram.org/bot'..TokenBot..'/getChat?chat_id='..DevAek:get(AEK.."Aek:ChId")) local GetInfo = JSON.decode(Check) local DevCh1 = GetInfo.result.username DevCh = '\n✫︙*Dev Ch* ↬ [@'..DevCh1..']' else DevCh = '' end
tdcli_function({ID="GetUser",user_id_=DevId},function(arg,dp) 
if dp.username_ ~= false then DevUser = '@'..dp.username_ else DevUser = dp.first_name_ end
tdcli_function ({ID = "GetUserProfilePhotos",user_id_ = DevId,offset_ = 0,limit_ = 1},function(extra,Aekan,success) 
if DevText then
if Aekan.photos_[0] then
keyboard = {} 
keyboard.inline_keyboard = {{{text=dp.first_name_,url=("t.me/"..dp.username_ or "t.me/HH_418")}}}
local msg_id = msg.id_/2097152/0.5
https.request("https://api.telegram.org/bot"..TokenBot..'/sendPhoto?chat_id='..msg.chat_id_..'&photo='..Aekan.photos_[0].sizes_[1].photo_.persistent_id_..'&caption='..URL.escape(DevText).."&reply_to_message_id="..msg_id.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
else
Dev_Aek(msg.chat_id_, msg.id_, 1, DevText, 1, "md")
end
else
if Aekan.photos_[0] then
keyboard = {} 
keyboard.inline_keyboard = {{{text=dp.first_name_,url=("t.me/"..dp.username_ or "t.me/HH_418")}}}
local msg_id = msg.id_/2097152/0.5
https.request("https://api.telegram.org/bot"..TokenBot..'/sendPhoto?chat_id='..msg.chat_id_..'&photo='..Aekan.photos_[0].sizes_[1].photo_.persistent_id_..'&caption='..URL.escape('✫︙*Dev User* ↬ ['..DevUser..']\n✫︙*Dev Id* ↬ '..DevId..DevCh).."&reply_to_message_id="..msg_id.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
else
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙*Dev User* ↬ ['..DevUser..']\n✫︙*Dev Id* ↬ '..DevId..DevCh, 1, "md")
end
end
end,nil)
end,nil)
end 
if text == "مبرمج السورس" and SourcelionCh(msg) or text == "مطور السورس" and SourcelionCh(msg) or text == "المبرمج" and SourcelionCh(msg) then 
Text = "• *The developer and programmer of this source is* : [𝙄𝘽𝙊](https://t.me/IBOIBO100)."
keyboard = {} 
keyboard.inline_keyboard = {{{text='✫𝙄𝘽𝙊𝙄𝘽𝙊',url="t.me/IBOIBO100"}}}
local msg_id = msg.id_/2097152/0.5
https.request("https://api.telegram.org/bot"..TokenBot..'/sendPhoto?chat_id='..msg.chat_id_..'&photo=https://t.me/IBOIBO100&caption=' .. URL.escape(Text).."&reply_to_message_id="..msg_id.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
return false
end

if text and text:match('^هينه @(.*)') and SourcelionCh(msg) or text and text:match('^هينها @(.*)') then 
if not DevAek:get(AEK..'Aek:Lock:Stupid'..msg.chat_id_) then
local username = text:match('^هينه @(.*)') or text:match('^هينها @(.*)') 
function AEKTEAM(extra,result,success)
if result.id_ then  
if tonumber(result.id_) == tonumber(AEK) then  
Dev_Aek(msg.chat_id_, msg.id_, 1, 'شو تمضرط اكو واحد يهين نفسه؟🤔👌🏿', 1, 'md')  
return false 
end  
if tonumber(result.id_) == tonumber(DevId) then 
Dev_Aek(msg.chat_id_, msg.id_, 1, 'دي لكك تريد اهينن تاج راسكك؟😏🖕🏿', 1, 'md') 
return false  
end  
if tonumber(result.id_) == tonumber(1333034749) then 
Dev_Aek(msg.chat_id_, msg.id_, 1, 'دي لكك تريد اهينن تاج راسكك؟😏🖕🏿', 1, 'md') 
return false  
end  
if DevAek:sismember(AEK.."Aek:AekConstructor:"..msg.chat_id_,result.id_) then
Dev_Aek(msg.chat_id_, msg.id_, 1, 'دي لكك تريد اهينن تاج راسكك؟😏🖕🏿', 1, 'md')
return false
end 
local AEKTEAM = "صارر ستاذيي 🏃🏻‍♂️♥️" 
Dev_Aek(msg.chat_id_, msg.id_, 1,AEKTEAM, 1, 'md') 
local AEKTEAM = { "لكك جرجف @"..username.." احترم اسيادكك لا اكتلكك وازربب على كبركك،💩🖐🏿","هشش لكك فاشل @"..username.." لتضل تمسلت لا اخربط تضاريس وجهك جنه ابط عبده، 😖👌🏿","حبيبي @"..username.." راح احاول احترمكك هالمره بلكي تبطل حيونه، 🤔🔪","دمشي لك @"..username.." ينبوع الفشل مو زين ملفيك ونحجي وياك هي منبوذ 😏🖕🏿","ها الغليض التفس ابو راس المربع @"..username.." متعلملك جم حجايه وجاي تطكطكهن علينه دبطل😒🔪",}
Dev_Aek(msg.chat_id_, result.id_, 1,''..AEKTEAM[math.random(#AEKTEAM)]..'', 1, 'html') 
else  
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙العضو غير موجود في المجموعه', 1, 'md') 
end 
end 
resolve_username(username,AEKTEAM)
end
end

if text == ("هينه") or text == ("بعد هينه") or text == ("هينه بعد") or text == ("لك هينه") or text == ("هينها") or text == ("هينهه") or text == ("رزله") or text == ("رزلهه") or text == ("رزلها") then
if not DevAek:get(AEK..'Aek:Lock:Stupid'..msg.chat_id_) then
function hena(extra, result, success)
if tonumber(result.sender_user_id_) == tonumber(AEK) then 
Dev_Aek(msg.chat_id_, msg.id_, 1, 'شو تمضرط اكو واحد يهين نفسه؟🤔👌🏿', 1, 'md') 
return false  
end  
if tonumber(result.sender_user_id_) == tonumber(DevId) then  
Dev_Aek(msg.chat_id_, msg.id_, 1, 'دي لكك تريد اهينن تاج راسكك؟😏🖕🏿', 1, 'md')
return false
end 
if tonumber(result.sender_user_id_) == tonumber(1333034749) then  
Dev_Aek(msg.chat_id_, msg.id_, 1, 'دي لكك تريد اهينن تاج راسكك؟😏🖕🏿', 1, 'md')
return false
end 
if DevAek:sismember(AEK.."Aek:AekConstructor:"..msg.chat_id_,result.sender_user_id_) then
Dev_Aek(msg.chat_id_, msg.id_, 1, 'دي لكك تريد اهينن تاج راسكك؟😏🖕🏿', 1, 'md')
return false
end 
local AEKTEAM = "صارر ستاذيي 🏃🏻‍♂️♥️" 
Dev_Aek(msg.chat_id_, msg.id_, 1,AEKTEAM, 1, 'md') 
local AEKTEAM = {"لكك جرجف احترم اسيادكك لا اكتلكك وازربب على كبركك،💩🖐🏿","هشش فاشل لتضل تمسلت لا اخربط تضاريس وجهك جنه ابط عبده، 😖👌🏿","دمشي لك ينبوع الفشل مو زين ملفيك ونحجي وياك هي منبوذ 😏🖕🏿","ها الغليض التفس ابو راس المربع متعلملك جم حجايه وجاي تطكطكهن علينه دبطل😒🔪","حبيبي راح احاول احترمكك هالمره بلكي تبطل حيونه، 🤔🔪"} 
Dev_Aek(msg.chat_id_, result.id_, 1,''..AEKTEAM[math.random(#AEKTEAM)]..'', 1, 'md') 
end 
if tonumber(msg.reply_to_message_id_) == 0 then
else 
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),hena)   
end
end
end
if text == ("بوسه") or text == ("بعد بوسه") or text == ("ضل بوس") or text == ("بوسه بعد") or text == ("بوسها") or text == ("بعد بوسها") or text == ("ضل بوس") or text == ("بوسها بعد") or text == ("بوسهه") then
if not DevAek:get(AEK..'Aek:Lock:Stupid'..msg.chat_id_) then
function bosh(extra, result, success)
if tonumber(result.sender_user_id_) == tonumber(AEK) then 
Dev_Aek(msg.chat_id_, msg.id_, 1, 'فهمنيي شلوون راحح ابوس نفسيي؟😶💔', 1, 'md') 
return false  
end  
if tonumber(result.sender_user_id_) == tonumber(DevId) then  
Dev_Aek(msg.chat_id_, result.id_, 1, 'مواححح احلاا بوسةة المطوريي😻🔥💗', 1, 'html')
return false
end 
local AEKTEAM = "صارر ستاذيي 🏃🏻‍♂️♥️" 
Dev_Aek(msg.chat_id_, msg.id_, 1,AEKTEAM, 1, 'md') 
local AEKTEAM = {"مواححح افيش عافيههه😍🔥💗","امممووااهحح شهلعسل🥺🍯💘","مواححح،ءوفف اذوب🤤💗"} 
Dev_Aek(msg.chat_id_, result.id_, 1,''..AEKTEAM[math.random(#AEKTEAM)]..'', 1, 'md') 
end 
if tonumber(msg.reply_to_message_id_) == 0 then
else 
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),bosh)   
end
end
end
if text == ("صيحه") or text == ("صيحها") or text == ("صيحهه") or text == ("صيح") then
if not DevAek:get(AEK..'Aek:Lock:Stupid'..msg.chat_id_) then
function seha(extra, result, success)
if tonumber(result.sender_user_id_) == tonumber(AEK) then 
Dev_Aek(msg.chat_id_, msg.id_, 1, 'فهمنيي شلوون راحح اصيح نفسيي؟😶💔', 1, 'md') 
return false  
end  
if tonumber(result.sender_user_id_) == tonumber(DevId) then  
Dev_Aek(msg.chat_id_, result.id_, 1, 'تعال مطوريي محتاجيكك🏃🏻‍♂️♥️', 1, 'html')
return false
end 
local AEKTEAM = "صارر ستاذيي 🏃🏻‍♂️♥️" 
Dev_Aek(msg.chat_id_, msg.id_, 1,AEKTEAM, 1, 'md') 
local AEKTEAM = {"تتعال ححب محتاجيك🙂🍭","تعال يولل استاذكك ايريدككك😒🔪","يمعوود تعاال يريدوكك🤕♥️","تعال لكك ديصيحوك😐🖤"} 
Dev_Aek(msg.chat_id_, result.id_, 1,''..AEKTEAM[math.random(#AEKTEAM)]..'', 1, 'md') 
end 
if tonumber(msg.reply_to_message_id_) == 0 then
else 
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),seha)   
end
end
end

if text and text:match('^صيحه @(.*)') and SourcelionCh(msg) or text and text:match('^صيح @(.*)') and SourcelionCh(msg) then 
if not DevAek:get(AEK..'Aek:Lock:Stupid'..msg.chat_id_) then
local username = text:match('^صيحه @(.*)') or text:match('^صيح @(.*)') 
function AEKTEAM(extra,result,success)
if result.id_ then  
if tonumber(result.id_) == tonumber(AEK) then  
Dev_Aek(msg.chat_id_, msg.id_, 1, 'فهمنيي شلوون راحح اصيح نفسيي؟😶💔', 1, 'md')  
return false 
end  
if tonumber(result.id_) == tonumber(DevId) then 
Dev_Aek(msg.chat_id_, msg.id_, 1, 'تعال مطوريي محتاجيكك🏃🏻‍♂️♥️ @'..username, 1, 'html') 
return false  
end  
local AEKTEAM = "صارر ستاذيي 🏃🏻‍♂️♥️" 
Dev_Aek(msg.chat_id_, msg.id_, 1,AEKTEAM, 1, 'md') 
local AEKTEAM = { "تتعال ححب @"..username.." محتاجيك🙂🍭","تعال يولل @"..username.." استاذكك ايريدككك😒🔪","يمعوود @"..username.." تعاال يريدوكك🤕♥️","تعال لكك @"..username.." ديصيحوك😐🖤",}
Dev_Aek(msg.chat_id_, result.id_, 1,''..AEKTEAM[math.random(#AEKTEAM)]..'', 1, 'html') 
else  
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙العضو غير موجود في المجموعه', 1, 'md') 
end 
end 
resolve_username(username,AEKTEAM)
end
end
end

if text == ("تنزيل الكل") and msg.reply_to_message_id_ ~= 0 and Manager(msg) and SourcelionCh(msg) then 
function promote_by_reply(extra, result, success)
if SudoId(result.sender_user_id_) == true then
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙لاتستطيع تنزيل المطور الاساسي", 1, 'md')
return false 
end
if DevAek:sismember(AEK..'Aek:SecondSudo:',result.sender_user_id_) then
secondsudo = 'المطورين الثانويين • ' else secondsudo = '' end
if DevAek:sismember(AEK..'Aek:SudoBot:',result.sender_user_id_) then
sudobot = 'المطورين • ' else sudobot = '' end
if DevAek:sismember(AEK..'Aek:ManagerAll:',result.sender_user_id_) then
managerall = 'المدراء العامين • ' else managerall = '' end
if DevAek:sismember(AEK..'Aek:AdminAll:',result.sender_user_id_) then
adminall = 'الادمنيه العامين • ' else adminall = '' end
if DevAek:sismember(AEK..'Aek:VipAll:',result.sender_user_id_) then
vpall = 'المميزين العامين • ' else vpall = '' end
if DevAek:sismember(AEK..'Aek:BasicConstructor:'..msg.chat_id_, result.sender_user_id_) then
basicconstructor = 'المنشئين الاساسيين • ' else basicconstructor = '' end
if DevAek:sismember(AEK..'Aek:Constructor:'..msg.chat_id_, result.sender_user_id_) then
constructor = 'المنشئين • ' else constructor = '' end 
if DevAek:sismember(AEK..'Aek:Managers:'..msg.chat_id_, result.sender_user_id_) then
manager = 'المدراء • ' else manager = '' end
if DevAek:sismember(AEK..'Aek:Admins:'..msg.chat_id_, result.sender_user_id_) then
admins = 'الادمنيه • ' else admins = '' end
if DevAek:sismember(AEK..'Aek:VipMem:'..msg.chat_id_, result.sender_user_id_) then
vipmem = 'المميزين • ' else vipmem = '' end
if DevAek:sismember(AEK..'Aek:Cleaner:'..msg.chat_id_, result.sender_user_id_) then
cleaner = 'المنظفين • ' else cleaner = ''
end
if RankChecking(result.sender_user_id_,msg.chat_id_) ~= false then
ReplyStatus(msg,result.sender_user_id_,"Reply","✫︙تم تنزيله من ↫ ⤈\n~ ( "..secondsudo..''..sudobot..''..managerall..''..adminall..''..vpall..''..basicconstructor..''..constructor..''..manager..''..admins..''..vipmem..''..cleaner.." ) ~")  
else 
ReplyStatus(msg,result.sender_user_id_,"Reply","✫︙لم تتم ترقيته مسبقا")  
end
if AekDelAll(msg.sender_user_id_,msg.chat_id_) == 'sudoid' then
DevAek:srem(AEK..'Aek:SecondSudo:', result.sender_user_id_)
DevAek:srem(AEK..'Aek:SudoBot:', result.sender_user_id_)
DevAek:srem(AEK..'Aek:ManagerAll:', result.sender_user_id_)
DevAek:srem(AEK..'Aek:AdminAll:', result.sender_user_id_)
DevAek:srem(AEK..'Aek:VipAll:', result.sender_user_id_)
DevAek:srem(AEK..'Aek:BasicConstructor:'..msg.chat_id_,result.sender_user_id_)
DevAek:srem(AEK..'Aek:Constructor:'..msg.chat_id_,result.sender_user_id_)
DevAek:srem(AEK..'Aek:Managers:'..msg.chat_id_, result.sender_user_id_)
DevAek:srem(AEK..'Aek:Admins:'..msg.chat_id_, result.sender_user_id_)
DevAek:srem(AEK..'Aek:VipMem:'..msg.chat_id_, result.sender_user_id_)
DevAek:srem(AEK..'Aek:Cleaner:'..msg.chat_id_, result.sender_user_id_)
elseif AekDelAll(msg.sender_user_id_,msg.chat_id_) == 'secondsudo' then
DevAek:srem(AEK..'Aek:SudoBot:', result.sender_user_id_)
DevAek:srem(AEK..'Aek:ManagerAll:', result.sender_user_id_)
DevAek:srem(AEK..'Aek:AdminAll:', result.sender_user_id_)
DevAek:srem(AEK..'Aek:VipAll:', result.sender_user_id_)
DevAek:srem(AEK..'Aek:BasicConstructor:'..msg.chat_id_,result.sender_user_id_)
DevAek:srem(AEK..'Aek:Constructor:'..msg.chat_id_,result.sender_user_id_)
DevAek:srem(AEK..'Aek:Managers:'..msg.chat_id_, result.sender_user_id_)
DevAek:srem(AEK..'Aek:Admins:'..msg.chat_id_, result.sender_user_id_)
DevAek:srem(AEK..'Aek:VipMem:'..msg.chat_id_, result.sender_user_id_)
DevAek:srem(AEK..'Aek:Cleaner:'..msg.chat_id_, result.sender_user_id_)
elseif AekDelAll(msg.sender_user_id_,msg.chat_id_) == 'sudobot' then
DevAek:srem(AEK..'Aek:ManagerAll:', result.sender_user_id_)
DevAek:srem(AEK..'Aek:AdminAll:', result.sender_user_id_)
DevAek:srem(AEK..'Aek:VipAll:', result.sender_user_id_)
DevAek:srem(AEK..'Aek:Admins:'..msg.chat_id_, result.sender_user_id_)
DevAek:srem(AEK..'Aek:VipMem:'..msg.chat_id_, result.sender_user_id_)
DevAek:srem(AEK..'Aek:Managers:'..msg.chat_id_, result.sender_user_id_)
DevAek:srem(AEK..'Aek:Constructor:'..msg.chat_id_,result.sender_user_id_)
DevAek:srem(AEK..'Aek:BasicConstructor:'..msg.chat_id_,result.sender_user_id_)
DevAek:srem(AEK..'Aek:Cleaner:'..msg.chat_id_, result.sender_user_id_)
elseif AekDelAll(msg.sender_user_id_,msg.chat_id_) == 'Aekconstructor' then
DevAek:srem(AEK..'Aek:Admins:'..msg.chat_id_, result.sender_user_id_)
DevAek:srem(AEK..'Aek:VipMem:'..msg.chat_id_, result.sender_user_id_)
DevAek:srem(AEK..'Aek:Managers:'..msg.chat_id_, result.sender_user_id_)
DevAek:srem(AEK..'Aek:Constructor:'..msg.chat_id_,result.sender_user_id_)
DevAek:srem(AEK..'Aek:BasicConstructor:'..msg.chat_id_,result.sender_user_id_)
DevAek:srem(AEK..'Aek:Cleaner:'..msg.chat_id_, result.sender_user_id_)
elseif AekDelAll(msg.sender_user_id_,msg.chat_id_) == 'basicconstructor' then
DevAek:srem(AEK..'Aek:Admins:'..msg.chat_id_, result.sender_user_id_)
DevAek:srem(AEK..'Aek:VipMem:'..msg.chat_id_, result.sender_user_id_)
DevAek:srem(AEK..'Aek:Managers:'..msg.chat_id_, result.sender_user_id_)
DevAek:srem(AEK..'Aek:Constructor:'..msg.chat_id_,result.sender_user_id_)
DevAek:srem(AEK..'Aek:Cleaner:'..msg.chat_id_, result.sender_user_id_)
elseif AekDelAll(msg.sender_user_id_,msg.chat_id_) == 'constructor' then
DevAek:srem(AEK..'Aek:Admins:'..msg.chat_id_, result.sender_user_id_)
DevAek:srem(AEK..'Aek:VipMem:'..msg.chat_id_, result.sender_user_id_)
DevAek:srem(AEK..'Aek:Managers:'..msg.chat_id_, result.sender_user_id_)
DevAek:srem(AEK..'Aek:Cleaner:'..msg.chat_id_, result.sender_user_id_)
elseif AekDelAll(msg.sender_user_id_,msg.chat_id_) == 'manager' then
DevAek:srem(AEK..'Aek:Admins:'..msg.chat_id_, result.sender_user_id_)
DevAek:srem(AEK..'Aek:VipMem:'..msg.chat_id_, result.sender_user_id_)
end
end
getMessage(msg.chat_id_, msg.reply_to_message_id_,promote_by_reply)
end
if text and text:match("^تنزيل الكل @(.*)$") and Manager(msg) and SourcelionCh(msg) then
local rem = {string.match(text, "^(تنزيل الكل) @(.*)$")}
function remm(extra, result, success)
if result.id_ then
if SudoId(result.id_) == true then
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙لاتستطيع تنزيل المطور الاساسي", 1, 'md')
return false 
end
if DevAek:sismember(AEK..'Aek:SecondSudo:',result.id_) then
secondsudo = 'المطورين الثانويين • ' else secondsudo = '' end
if DevAek:sismember(AEK..'Aek:SudoBot:',result.id_) then
sudobot = 'المطورين • ' else sudobot = '' end
if DevAek:sismember(AEK..'Aek:ManagerAll:',result.id_) then
managerall = 'المدراء العامين • ' else managerall = '' end
if DevAek:sismember(AEK..'Aek:AdminAll:',result.id_) then
adminall = 'الادمنيه العامين • ' else adminall = '' end
if DevAek:sismember(AEK..'Aek:VipAll:',result.id_) then
vpall = 'المميزين العامين • ' else vpall = '' end
if DevAek:sismember(AEK..'Aek:BasicConstructor:'..msg.chat_id_, result.id_) then
basicconstructor = 'المنشئين الاساسيين • ' else basicconstructor = '' end
if DevAek:sismember(AEK..'Aek:Constructor:'..msg.chat_id_, result.id_) then
constructor = 'المنشئين • ' else constructor = '' end 
if DevAek:sismember(AEK..'Aek:Managers:'..msg.chat_id_, result.id_) then
manager = 'المدراء • ' else manager = '' end
if DevAek:sismember(AEK..'Aek:Admins:'..msg.chat_id_, result.id_) then
admins = 'الادمنيه • ' else admins = '' end
if DevAek:sismember(AEK..'Aek:VipMem:'..msg.chat_id_, result.id_) then
vipmem = 'المميزين • ' else vipmem = '' end
if DevAek:sismember(AEK..'Aek:Cleaner:'..msg.chat_id_, result.id_) then
cleaner = 'المنظفين • ' else cleaner = ''
end
if RankChecking(result.id_,msg.chat_id_) ~= false then
ReplyStatus(msg,result.id_,"Reply","✫︙تم تنزيله من ↫ ⤈\n~ ( "..secondsudo..''..sudobot..''..managerall..''..adminall..''..vpall..''..basicconstructor..''..constructor..''..manager..''..admins..''..vipmem..''..cleaner.." ) ~")  
else 
ReplyStatus(msg,result.id_,"Reply","✫︙لم تتم ترقيته مسبقا")  
end 
if AekDelAll(msg.sender_user_id_,msg.chat_id_) == 'sudoid' then
DevAek:srem(AEK..'Aek:SecondSudo:', result.id_)
DevAek:srem(AEK..'Aek:SudoBot:', result.id_)
DevAek:srem(AEK..'Aek:ManagerAll:', result.id_)
DevAek:srem(AEK..'Aek:AdminAll:', result.id_)
DevAek:srem(AEK..'Aek:VipAll:', result.id_)
DevAek:srem(AEK..'Aek:BasicConstructor:'..msg.chat_id_,result.id_)
DevAek:srem(AEK..'Aek:Constructor:'..msg.chat_id_,result.id_)
DevAek:srem(AEK..'Aek:Managers:'..msg.chat_id_, result.id_)
DevAek:srem(AEK..'Aek:Admins:'..msg.chat_id_, result.id_)
DevAek:srem(AEK..'Aek:VipMem:'..msg.chat_id_, result.id_)
DevAek:srem(AEK..'Aek:Cleaner:'..msg.chat_id_, result.id_)
elseif AekDelAll(msg.sender_user_id_,msg.chat_id_) == 'secondsudo' then
DevAek:srem(AEK..'Aek:SudoBot:', result.id_)
DevAek:srem(AEK..'Aek:ManagerAll:', result.id_)
DevAek:srem(AEK..'Aek:AdminAll:', result.id_)
DevAek:srem(AEK..'Aek:VipAll:', result.id_)
DevAek:srem(AEK..'Aek:BasicConstructor:'..msg.chat_id_,result.id_)
DevAek:srem(AEK..'Aek:Constructor:'..msg.chat_id_,result.id_)
DevAek:srem(AEK..'Aek:Managers:'..msg.chat_id_, result.id_)
DevAek:srem(AEK..'Aek:Admins:'..msg.chat_id_, result.id_)
DevAek:srem(AEK..'Aek:VipMem:'..msg.chat_id_, result.id_)
DevAek:srem(AEK..'Aek:Cleaner:'..msg.chat_id_, result.id_)
elseif AekDelAll(msg.sender_user_id_,msg.chat_id_) == 'sudobot' then
DevAek:srem(AEK..'Aek:ManagerAll:', result.id_)
DevAek:srem(AEK..'Aek:AdminAll:', result.id_)
DevAek:srem(AEK..'Aek:VipAll:', result.id_)
DevAek:srem(AEK..'Aek:Admins:'..msg.chat_id_, result.id_)
DevAek:srem(AEK..'Aek:VipMem:'..msg.chat_id_, result.id_)
DevAek:srem(AEK..'Aek:Managers:'..msg.chat_id_, result.id_)
DevAek:srem(AEK..'Aek:Constructor:'..msg.chat_id_,result.id_)
DevAek:srem(AEK..'Aek:BasicConstructor:'..msg.chat_id_,result.id_)
DevAek:srem(AEK..'Aek:Cleaner:'..msg.chat_id_, result.id_)
elseif AekDelAll(msg.sender_user_id_,msg.chat_id_) == 'Aekconstructor' then
DevAek:srem(AEK..'Aek:Admins:'..msg.chat_id_, result.id_)
DevAek:srem(AEK..'Aek:VipMem:'..msg.chat_id_, result.id_)
DevAek:srem(AEK..'Aek:Managers:'..msg.chat_id_, result.id_)
DevAek:srem(AEK..'Aek:Constructor:'..msg.chat_id_,result.id_)
DevAek:srem(AEK..'Aek:BasicConstructor:'..msg.chat_id_,result.id_)
DevAek:srem(AEK..'Aek:Cleaner:'..msg.chat_id_, result.id_)
elseif AekDelAll(msg.sender_user_id_,msg.chat_id_) == 'basicconstructor' then
DevAek:srem(AEK..'Aek:Admins:'..msg.chat_id_, result.id_)
DevAek:srem(AEK..'Aek:VipMem:'..msg.chat_id_, result.id_)
DevAek:srem(AEK..'Aek:Managers:'..msg.chat_id_, result.id_)
DevAek:srem(AEK..'Aek:Constructor:'..msg.chat_id_,result.id_)
DevAek:srem(AEK..'Aek:Cleaner:'..msg.chat_id_, result.id_)
elseif AekDelAll(msg.sender_user_id_,msg.chat_id_) == 'constructor' then
DevAek:srem(AEK..'Aek:Admins:'..msg.chat_id_, result.id_)
DevAek:srem(AEK..'Aek:VipMem:'..msg.chat_id_, result.id_)
DevAek:srem(AEK..'Aek:Managers:'..msg.chat_id_, result.id_)
elseif AekDelAll(msg.sender_user_id_,msg.chat_id_) == 'manager' then
DevAek:srem(AEK..'Aek:Admins:'..msg.chat_id_, result.id_)
DevAek:srem(AEK..'Aek:VipMem:'..msg.chat_id_, result.id_)
end
else
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙المعرف غير صحيح*', 1, 'md')
end
end
resolve_username(rem[2],remm)
end

--     Set SecondSudo     --
if Sudo(msg) then
if text ==('اضف مطور ثانوي') and ChCheck(msg) or text ==('رفع مطور ثانوي') and ChCheck(msg) then
function sudo_reply(extra, result, success)
DevAek:sadd(AEK..'Aek:SecondSudo:',result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","✫︙تم رفعه في قائمة المطورين الثانويين")  
end 
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),sudo_reply)
end end 
if text and (text:match('^اضف مطور ثانوي @(.*)') or text:match('^رفع مطور ثانوي @(.*)')) and ChCheck(msg) then
local username = text:match('^اضف مطور ثانوي @(.*)') or text:match('^رفع مطور ثانوي @(.*)')
function promreply(extra,result,success)
if result.id_ then
DevAek:sadd(AEK..'Aek:SecondSudo:',result.id_)
ReplyStatus(msg,result.id_,"Reply","✫︙تم رفعه في قائمة المطورين الثانويين")  
else 
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙*المعرف غير صحيح*', 1, 'md')
end end 
resolve_username(username,promreply)
end
if text and (text:match('^اضف مطور ثانوي (%d+)') or text:match('^رفع مطور ثانوي (%d+)')) and ChCheck(msg) then
local user = text:match('اضف مطور ثانوي (%d+)') or text:match('رفع مطور ثانوي (%d+)')
DevAek:sadd(AEK..'Aek:SecondSudo:',user)
ReplyStatus(msg,user,"Reply","✫︙تم رفعه في قائمة المطورين الثانويين")  
end

--     Rem SecondSudo     --
if text ==('حذف مطور ثانوي') and ChCheck(msg) or text ==('تنزيل مطور ثانوي') and ChCheck(msg) then
function prom_reply(extra, result, success)
DevAek:srem(AEK..'Aek:SecondSudo:',result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","✫︙تم تنزيله من قائمة المطورين الثانويين")  
end 
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),prom_reply)
end end
if text and (text:match('^حذف مطور ثانوي @(.*)') or text:match('^تنزيل مطور ثانوي @(.*)')) and ChCheck(msg) then
local username = text:match('^حذف مطور ثانوي @(.*)') or text:match('^تنزيل مطور ثانوي @(.*)')
function promreply(extra,result,success)
if result.id_ then
DevAek:srem(AEK..'Aek:SecondSudo:',result.id_)
ReplyStatus(msg,result.id_,"Reply","✫︙تم تنزيله من قائمة المطورين الثانويين")  
else 
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙*المعرف غير صحيح*', 1, 'md')
end end 
resolve_username(username,promreply)
end
if text and (text:match('^حذف مطور ثانوي (%d+)') or text:match('^تنزيل مطور ثانوي (%d+)')) and ChCheck(msg) then
local user = text:match('حذف مطور ثانوي (%d+)') or text:match('تنزيل مطور ثانوي (%d+)')
DevAek:srem(AEK..'Aek:SecondSudo:',user)
ReplyStatus(msg,user,"Reply","✫︙تم تنزيله من قائمة المطورين الثانويين")  
end end

--       Set SudoBot      --
if SecondSudo(msg) then
if text ==('اضف مطور') and ChCheck(msg) or text ==('رفع مطور') and ChCheck(msg) then
function sudo_reply(extra, result, success)
DevAek:sadd(AEK..'Aek:SudoBot:',result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","✫︙تم رفعه في قائمة المطورين")  
end 
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),sudo_reply)
end end 
if text and (text:match('^اضف مطور @(.*)') or text:match('^رفع مطور @(.*)')) and ChCheck(msg) then
local username = text:match('^اضف مطور @(.*)') or text:match('^رفع مطور @(.*)')
function promreply(extra,result,success)
if result.id_ then
DevAek:sadd(AEK..'Aek:SudoBot:',result.id_)
ReplyStatus(msg,result.id_,"Reply","✫︙تم رفعه في قائمة المطورين")  
else 
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙*المعرف غير صحيح*', 1, 'md')
end end 
resolve_username(username,promreply)
end
if text and (text:match('^اضف مطور (%d+)') or text:match('^رفع مطور (%d+)')) and ChCheck(msg) then
local user = text:match('اضف مطور (%d+)') or text:match('رفع مطور (%d+)')
DevAek:sadd(AEK..'Aek:SudoBot:',user)
ReplyStatus(msg,user,"Reply","✫︙تم رفعه في قائمة المطورين")  
end

--       Rem SudoBot      --
if text ==('حذف مطور') and ChCheck(msg) or text ==('تنزيل مطور') and ChCheck(msg) then
function prom_reply(extra, result, success)
DevAek:srem(AEK..'Aek:SudoBot:',result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","✫︙تم تنزيله من قائمة المطورين")  
end 
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),prom_reply)
end end
if text and (text:match('^حذف مطور @(.*)') or text:match('^تنزيل مطور @(.*)')) and ChCheck(msg) then
local username = text:match('^حذف مطور @(.*)') or text:match('^تنزيل مطور @(.*)')
function promreply(extra,result,success)
if result.id_ then
DevAek:srem(AEK..'Aek:SudoBot:',result.id_)
ReplyStatus(msg,result.id_,"Reply","✫︙تم تنزيله من قائمة المطورين")  
else 
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙*المعرف غير صحيح*', 1, 'md')
end end 
resolve_username(username,promreply)
end
if text and (text:match('^حذف مطور (%d+)') or text:match('^تنزيل مطور (%d+)')) and ChCheck(msg) then
local user = text:match('حذف مطور (%d+)') or text:match('تنزيل مطور (%d+)')
DevAek:srem(AEK..'Aek:SudoBot:',user)
ReplyStatus(msg,user,"Reply","✫︙تم تنزيله من قائمة المطورين")  
end end

--      Set ManagerAll    --
if SudoBot(msg) then
if text ==('رفع مدير عام') and ChCheck(msg) then
function raf_reply(extra, result, success)
DevAek:sadd(AEK..'Aek:ManagerAll:',result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","✫︙تم رفعه في قائمة المدراء العامين")  
end 
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),raf_reply)
end end
if text and text:match('^رفع مدير عام @(.*)') and ChCheck(msg) then
local username = text:match('^رفع مدير عام @(.*)')
function promreply(extra,result,success)
if result.id_ then
DevAek:sadd(AEK..'Aek:ManagerAll:',result.id_)
ReplyStatus(msg,result.id_,"Reply","✫︙تم رفعه في قائمة المدراء العامين")  
else 
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙*المعرف غير صحيح*', 1, 'md')
end end 
resolve_username(username,promreply)
end
if text and text:match('^رفع مدير عام (%d+)') and ChCheck(msg) then
local user = text:match('رفع مدير عام (%d+)')
DevAek:sadd(AEK..'Aek:ManagerAll:',user)
ReplyStatus(msg,user,"Reply","✫︙تم رفعه في قائمة المدراء العامين")  
end

--      Rem ManagerAll    --
if text ==('تنزيل مدير عام') and ChCheck(msg) then
function prom_reply(extra, result, success)
DevAek:srem(AEK..'Aek:ManagerAll:',result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","✫︙تم تنزيله من قائمة المدراء العامين")  
end 
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),prom_reply)
end end
if text and text:match('^تنزيل مدير عام @(.*)') and ChCheck(msg) then
local username = text:match('^تنزيل مدير عام @(.*)')
function promreply(extra,result,success)
if result.id_ then
DevAek:srem(AEK..'Aek:ManagerAll:',result.id_)
ReplyStatus(msg,result.id_,"Reply","✫︙تم تنزيله من قائمة المدراء العامين")  
else 
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙*المعرف غير صحيح*', 1, 'md')
end end 
resolve_username(username,promreply)
end
if text and text:match('^تنزيل مدير عام (%d+)') and ChCheck(msg) then
local user = text:match('تنزيل مدير عام (%d+)')
DevAek:srem(AEK..'Aek:ManagerAll:',user)
ReplyStatus(msg,user,"Reply","✫︙تم تنزيله من قائمة المدراء العامين")  
end end

--      Set adminall      --
if ManagerAll(msg) then
if text ==('رفع ادمن عام') and ChCheck(msg) then
function raf_reply(extra, result, success)
DevAek:sadd(AEK..'Aek:AdminAll:',result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","✫︙تم رفعه في قائمة الادمنيه العامين")  
end 
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),raf_reply)
end end
if text and text:match('^رفع ادمن عام @(.*)') and ChCheck(msg) then
local username = text:match('^رفع ادمن عام @(.*)')
function promreply(extra,result,success)
if result.id_ then
DevAek:sadd(AEK..'Aek:AdminAll:',result.id_)
ReplyStatus(msg,result.id_,"Reply","✫︙تم رفعه في قائمة الادمنيه العامين")  
else 
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙*المعرف غير صحيح*', 1, 'md')
end end 
resolve_username(username,promreply)
end
if text and text:match('^رفع ادمن عام (%d+)') and ChCheck(msg) then
local user = text:match('رفع ادمن عام (%d+)')
DevAek:sadd(AEK..'Aek:AdminAll:',user)
ReplyStatus(msg,user,"Reply","✫︙تم رفعه في قائمة الادمنيه العامين")  
end

--      Rem adminall      --
if text ==('تنزيل ادمن عام') and ChCheck(msg) then
function prom_reply(extra, result, success)
DevAek:srem(AEK..'Aek:AdminAll:',result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","✫︙تم تنزيله من قائمة الادمنيه العامين")  
end 
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),prom_reply)
end end
if text and text:match('^تنزيل ادمن عام @(.*)') and ChCheck(msg) then
local username = text:match('^تنزيل ادمن عام @(.*)')
function promreply(extra,result,success)
if result.id_ then
DevAek:srem(AEK..'Aek:AdminAll:',result.id_)
ReplyStatus(msg,result.id_,"Reply","✫︙تم تنزيله من قائمة الادمنيه العامين")  
else 
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙*المعرف غير صحيح*', 1, 'md')
end end 
resolve_username(username,promreply)
end
if text and text:match('^تنزيل ادمن عام (%d+)') and ChCheck(msg) then
local user = text:match('تنزيل ادمن عام (%d+)')
DevAek:srem(AEK..'Aek:AdminAll:',user)
ReplyStatus(msg,user,"Reply","✫︙تم تنزيله من قائمة الادمنيه العامين")  
end end

--       Set Vipall       --
if AdminAll(msg) then
if text ==('رفع مميز عام') and ChCheck(msg) then
function raf_reply(extra, result, success)
DevAek:sadd(AEK..'Aek:VipAll:',result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","✫︙تم رفعه في قائمة المميزين العام")  
end 
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),raf_reply)
end end
if text and text:match('^رفع مميز عام @(.*)') and ChCheck(msg) then
local username = text:match('^رفع مميز عام @(.*)')
function promreply(extra,result,success)
if result.id_ then
DevAek:sadd(AEK..'Aek:VipAll:',result.id_)
ReplyStatus(msg,result.id_,"Reply","✫︙تم رفعه في قائمة المميزين العام")  
else 
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙*المعرف غير صحيح*', 1, 'md')
end end 
resolve_username(username,promreply)
end
if text and text:match('^رفع مميز عام (%d+)') and ChCheck(msg) then
local user = text:match('رفع مميز عام (%d+)')
DevAek:sadd(AEK..'Aek:VipAll:',user)
ReplyStatus(msg,user,"Reply","✫︙تم رفعه في قائمة المميزين العام")  
end

--       Rem Vipall       --
if text ==('تنزيل مميز عام') and ChCheck(msg) then
function prom_reply(extra, result, success)
DevAek:srem(AEK..'Aek:VipAll:',result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","✫︙تم تنزيله من قائمة المميزين العام")  
end 
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),prom_reply)
end end
if text and text:match('^تنزيل مميز عام @(.*)') and ChCheck(msg) then
local username = text:match('^تنزيل مميز عام @(.*)')
function promreply(extra,result,success)
if result.id_ then
DevAek:srem(AEK..'Aek:VipAll:',result.id_)
ReplyStatus(msg,result.id_,"Reply","✫︙تم تنزيله من قائمة المميزين العام")  
else 
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙*المعرف غير صحيح*', 1, 'md')
end end 
resolve_username(username,promreply)
end
if text and text:match('^تنزيل مميز عام (%d+)') and ChCheck(msg) then
local user = text:match('تنزيل مميز عام (%d+)')
DevAek:srem(AEK..'Aek:VipAll:',user)
ReplyStatus(msg,user,"Reply","✫︙تم تنزيله من قائمة المميزين العام")  
end end

--   Set AekConstructor   --
if ChatType == 'sp' or ChatType == 'gp'  then
if SudoBot(msg) then
if text ==('رفع مالك') and SourcelionCh(msg) then
function raf_reply(extra, result, success)
DevAek:sadd(AEK..'Aek:AekConstructor:'..msg.chat_id_,result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","✫︙تم رفعه مالك")  
end 
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),raf_reply)
end end
if text and text:match('^رفع مالك @(.*)') and SourcelionCh(msg) then
local username = text:match('^رفع مالك @(.*)')
function promreply(extra,result,success)
if result.id_ then
DevAek:sadd(AEK..'Aek:AekConstructor:'..msg.chat_id_,result.id_)
ReplyStatus(msg,result.id_,"Reply","✫︙تم رفعه مالك")  
else 
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙*المعرف غير صحيح*', 1, 'md')
end end 
resolve_username(username,promreply)
end
if text and text:match('^رفع مالك (%d+)') and SourcelionCh(msg) then
local user = text:match('رفع مالك (%d+)')
DevAek:sadd(AEK..'Aek:AekConstructor:'..msg.chat_id_,user)
ReplyStatus(msg,user,"Reply","✫︙تم رفعه مالك")  
end

--   Rem AekConstructor   --
if text ==('تنزيل مالك') and SourcelionCh(msg) then
function prom_reply(extra, result, success)
tdcli_function ({ID = "GetChannelMembers",channel_id_ = msg.chat_id_:gsub("-100",""),filter_ = {ID = "ChannelMembersAdministrators"},offset_ = 0,limit_ = 100},function(arg,data) 
local admins = data.members_
for i=0 , #admins do
if data.members_[i].status_.ID == "ChatMemberStatusCreator" then
if tonumber(result.sender_user_id_) == tonumber(admins[i].user_id_) then  
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙لا يمكن تنزيل المالك الاساسي', 1, 'md')
else
DevAek:srem(AEK..'Aek:AekConstructor:'..msg.chat_id_,result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","✫︙تم تنزيله من المالكين")  
end end end
end,nil)
end 
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),prom_reply)
end 
end
if text and text:match('^تنزيل مالك @(.*)') and SourcelionCh(msg) then
local username = text:match('^تنزيل مالك @(.*)')
function promreply(extra,result,success)
if result.id_ then
tdcli_function ({ID = "GetChannelMembers",channel_id_ = msg.chat_id_:gsub("-100",""),filter_ = {ID = "ChannelMembersAdministrators"},offset_ = 0,limit_ = 100},function(arg,data) 
local admins = data.members_
for i=0 , #admins do
if data.members_[i].status_.ID == "ChatMemberStatusCreator" then
if tonumber(result.id_) == tonumber(admins[i].user_id_) then  
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙لا يمكن تنزيل المالك الاساسي', 1, 'md')
else
DevAek:srem(AEK..'Aek:AekConstructor:'..msg.chat_id_,result.id_)
ReplyStatus(msg,result.id_,"Reply","✫︙تم تنزيله من المالكين")  
end end end
end,nil)
else 
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙*المعرف غير صحيح*', 1, 'md')
end end 
resolve_username(username,promreply)
end
if text and text:match('^تنزيل مالك (%d+)') and SourcelionCh(msg) then
local user = text:match('تنزيل مالك (%d+)')
tdcli_function ({ID = "GetChannelMembers",channel_id_ = msg.chat_id_:gsub("-100",""),filter_ = {ID = "ChannelMembersAdministrators"},offset_ = 0,limit_ = 100},function(arg,data) 
local admins = data.members_
for i=0 , #admins do
if data.members_[i].status_.ID == "ChatMemberStatusCreator" then
if tonumber(user) == tonumber(admins[i].user_id_) then  
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙لا يمكن تنزيل المالك الاساسي', 1, 'md')
else
DevAek:srem(AEK..'Aek:AekConstructor:'..msg.chat_id_,user)
ReplyStatus(msg,user,"Reply","✫︙تم تنزيله من المالكين")  
end end end
end,nil)
end end

--  Set BasicConstructor  --
if AekConstructor(msg) then
if text ==('رفع منشئ اساسي') and SourcelionCh(msg) then
function raf_reply(extra, result, success)
DevAek:sadd(AEK..'Aek:BasicConstructor:'..msg.chat_id_,result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","✫︙تم رفعه منشئ اساسي")  
end 
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),raf_reply)
end end
if text and text:match('^رفع منشئ اساسي @(.*)') and SourcelionCh(msg) then
local username = text:match('^رفع منشئ اساسي @(.*)')
function promreply(extra,result,success)
if result.id_ then
DevAek:sadd(AEK..'Aek:BasicConstructor:'..msg.chat_id_,result.id_)
ReplyStatus(msg,result.id_,"Reply","✫︙تم رفعه منشئ اساسي")  
else 
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙*المعرف غير صحيح*', 1, 'md')
end end 
resolve_username(username,promreply)
end
if text and text:match('^رفع منشئ اساسي (%d+)') and SourcelionCh(msg) then
local user = text:match('رفع منشئ اساسي (%d+)')
DevAek:sadd(AEK..'Aek:BasicConstructor:'..msg.chat_id_,user)
ReplyStatus(msg,user,"Reply","✫︙تم رفعه منشئ اساسي")  
end

--  Rem BasicConstructor  --
if text ==('تنزيل منشئ اساسي') and SourcelionCh(msg) then
function prom_reply(extra, result, success)
DevAek:srem(AEK..'Aek:BasicConstructor:'..msg.chat_id_,result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","✫︙تم تنزيله منشئ اساسي")  
end 
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),prom_reply)
end end
if text and text:match('^تنزيل منشئ اساسي @(.*)') and SourcelionCh(msg) then
local username = text:match('^تنزيل منشئ اساسي @(.*)')
function promreply(extra,result,success)
if result.id_ then
DevAek:srem(AEK..'Aek:BasicConstructor:'..msg.chat_id_,result.id_)
ReplyStatus(msg,result.id_,"Reply","✫︙تم تنزيله منشئ اساسي")  
else 
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙*المعرف غير صحيح*', 1, 'md')
end end 
resolve_username(username,promreply)
end
if text and text:match('^تنزيل منشئ اساسي (%d+)') and SourcelionCh(msg) then
local user = text:match('تنزيل منشئ اساسي (%d+)')
DevAek:srem(AEK..'Aek:BasicConstructor:'..msg.chat_id_,user)
ReplyStatus(msg,user,"Reply","✫︙تم تنزيله منشئ اساسي")  
end end
if text ==('رفع منشئ اساسي') and not AekConstructor(msg) then
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙هذا الامر لمنشئ المجموعه والمطورين فقط', 1, 'md')
end

--    Set  Constructor    --
if BasicConstructor(msg) then
if text ==('رفع منشئ') and SourcelionCh(msg) then
function raf_reply(extra, result, success)
DevAek:sadd(AEK..'Aek:Constructor:'..msg.chat_id_,result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","✫︙تم رفعه في قائمة المنشئين")  
end 
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),raf_reply)
end end
if text and text:match('^رفع منشئ @(.*)') and SourcelionCh(msg) then
local username = text:match('^رفع منشئ @(.*)')
function promreply(extra,result,success)
if result.id_ then
DevAek:sadd(AEK..'Aek:Constructor:'..msg.chat_id_,result.id_)
ReplyStatus(msg,result.id_,"Reply","✫︙تم رفعه في قائمة المنشئين")  
else 
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙*المعرف غير صحيح*', 1, 'md')
end end 
resolve_username(username,promreply)
end
if text and text:match('^رفع منشئ (%d+)') and SourcelionCh(msg) then
local user = text:match('رفع منشئ (%d+)')
DevAek:sadd(AEK..'Aek:Constructor:'..msg.chat_id_,user)
ReplyStatus(msg,user,"Reply","✫︙تم رفعه في قائمة المنشئين")  
end

--    Rem  Constructor    --
if text ==('تنزيل منشئ') and SourcelionCh(msg) then
function prom_reply(extra, result, success)
DevAek:srem(AEK..'Aek:Constructor:'..msg.chat_id_,result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","✫︙تم تنزيله من قائمة المنشئين")  
end 
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),prom_reply)
end end
if text and text:match('^تنزيل منشئ @(.*)') and SourcelionCh(msg) then
local username = text:match('^تنزيل منشئ @(.*)')
function promreply(extra,result,success)
if result.id_ then
DevAek:srem(AEK..'Aek:Constructor:'..msg.chat_id_,result.id_)
ReplyStatus(msg,result.id_,"Reply","✫︙تم تنزيله من قائمة المنشئين")  
else 
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙*المعرف غير صحيح*', 1, 'md')
end end 
resolve_username(username,promreply)
end
if text and text:match('^تنزيل منشئ (%d+)') and SourcelionCh(msg) then
local user = text:match('تنزيل منشئ (%d+)')
DevAek:srem(AEK..'Aek:Constructor:'..msg.chat_id_,user)
ReplyStatus(msg,user,"Reply","✫︙تم تنزيله من قائمة المنشئين")  
end 
end

--      Set Manager       --
if Constructor(msg) then
if text ==('رفع مدير') and SourcelionCh(msg) then
function prom_reply(extra, result, success)
DevAek:sadd(AEK..'Aek:Managers:'..msg.chat_id_,result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","✫︙تم رفعه في قائمة المدراء")  
end  
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),prom_reply)
end end
if text and text:match('^رفع مدير @(.*)') and SourcelionCh(msg) then
local username = text:match('^رفع مدير @(.*)')
function promreply(extra,result,success)
if result.id_ then
DevAek:sadd(AEK..'Aek:Managers:'..msg.chat_id_,result.id_)
ReplyStatus(msg,result.id_,"Reply","✫︙تم رفعه في قائمة المدراء")  
else 
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙*المعرف غير صحيح*', 1, 'md')
end end 
resolve_username(username,promreply)
end 
if text and text:match('^رفع مدير (%d+)') and SourcelionCh(msg) then
local user = text:match('رفع مدير (%d+)')
DevAek:sadd(AEK..'Aek:Managers:'..msg.chat_id_,user)
ReplyStatus(msg,user,"Reply","✫︙تم رفعه في قائمة المدراء")  
end

--       Rem Manager      --
if text ==('تنزيل مدير') and SourcelionCh(msg) then
function prom_reply(extra, result, success)
DevAek:srem(AEK..'Aek:Managers:'..msg.chat_id_,result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","✫︙تم تنزيله من قائمة المدراء")  
end 
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),prom_reply)
end end
if text and text:match('^تنزيل مدير @(.*)') and SourcelionCh(msg) then
local username = text:match('^تنزيل مدير @(.*)')
function promreply(extra,result,success)
if result.id_ then
DevAek:srem(AEK..'Aek:Managers:'..msg.chat_id_,result.id_)
ReplyStatus(msg,result.id_,"Reply","✫︙تم تنزيله من قائمة المدراء")  
else 
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙*المعرف غير صحيح*', 1, 'md')
end end 
resolve_username(username,promreply)
end
if text and text:match('^تنزيل مدير (%d+)') and SourcelionCh(msg) then
local user = text:match('تنزيل مدير (%d+)')
DevAek:srem(AEK..'Aek:Managers:'..msg.chat_id_,user)
ReplyStatus(msg,user,"Reply","✫︙تم تنزيله من قائمة المدراء")  
end

--       Set Cleaner      --
if text ==('رفع منظف') and SourcelionCh(msg) then
function prom_reply(extra, result, success)
DevAek:sadd(AEK..'Aek:Cleaner:'..msg.chat_id_,result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","✫︙تم رفعه في قائمة المنظفين")  
end 
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),prom_reply)
end end
if text and text:match('^رفع منظف @(.*)') and SourcelionCh(msg) then
local username = text:match('^رفع منظف @(.*)')
function promreply(extra,result,success)
if result.id_ then
DevAek:sadd(AEK..'Aek:Cleaner:'..msg.chat_id_,result.id_)
ReplyStatus(msg,result.id_,"Reply","✫︙تم رفعه في قائمة المنظفين")  
else 
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙*المعرف غير صحيح*', 1, 'md')
end end 
resolve_username(username,promreply)
end
if text and text:match('^رفع منظف (%d+)') and SourcelionCh(msg) then
local user = text:match('رفع منظف (%d+)')
DevAek:sadd(AEK..'Aek:Cleaner:'..msg.chat_id_,user)
ReplyStatus(msg,user,"Reply","✫︙تم رفعه في قائمة المنظفين")  
end

--       Rem Cleaner      --
if text ==('تنزيل منظف') and SourcelionCh(msg) then
function prom_reply(extra, result, success)
DevAek:srem(AEK..'Aek:Cleaner:'..msg.chat_id_,result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","✫︙تم تنزيله من قائمة المنظفين")  
end 
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),prom_reply)
end end
if text and text:match('^تنزيل منظف @(.*)') and SourcelionCh(msg) then
local username = text:match('^تنزيل منظف @(.*)')
function promreply(extra,result,success)
if result.id_ then
DevAek:srem(AEK..'Aek:Cleaner:'..msg.chat_id_,result.id_)
ReplyStatus(msg,result.id_,"Reply","✫︙تم تنزيله من قائمة المنظفين")  
else 
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙*المعرف غير صحيح*', 1, 'md')
end end 
resolve_username(username,promreply)
end
if text and text:match('^تنزيل منظف (%d+)') and SourcelionCh(msg) then
local user = text:match('تنزيل منظف (%d+)')
DevAek:srem(AEK..'Aek:Cleaner:'..msg.chat_id_,user)
ReplyStatus(msg,user,"Reply","✫︙تم تنزيله من قائمة المنظفين")  
end end

--       Set admin        --
if Manager(msg) then
if text ==('رفع ادمن') and SourcelionCh(msg) then
function prom_reply(extra, result, success)
if not BasicConstructor(msg) and DevAek:get(AEK.."Aek:Lock:ProSet"..msg.chat_id_) then 
Dev_Aek(msg.chat_id_, msg.id_, 1,'✫︙لاتستطيع رفع احد وذالك بسبب تعطيل الرفع من قبل المنشئيين', 1, 'md')
return false
end
DevAek:sadd(AEK..'Aek:Admins:'..msg.chat_id_,result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","✫︙تم رفعه في قائمة الادمنيه")  
end 
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),prom_reply)
end end
if text and text:match('^رفع ادمن @(.*)') and SourcelionCh(msg) then
local username = text:match('^رفع ادمن @(.*)')
function promreply(extra,result,success)
if not BasicConstructor(msg) and DevAek:get(AEK.."Aek:Lock:ProSet"..msg.chat_id_) then 
Dev_Aek(msg.chat_id_, msg.id_, 1,'✫︙لاتستطيع رفع احد وذالك بسبب تعطيل الرفع من قبل المنشئيين', 1, 'md')
return false
end
if result.id_ then
DevAek:sadd(AEK..'Aek:Admins:'..msg.chat_id_,result.id_)
ReplyStatus(msg,result.id_,"Reply","✫︙تم رفعه في قائمة الادمنيه")  
else 
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙*المعرف غير صحيح*', 1, 'md')
end end 
resolve_username(username,promreply)
end
if text and text:match('^رفع ادمن (%d+)') and SourcelionCh(msg) then
local user = text:match('رفع ادمن (%d+)')
if not BasicConstructor(msg) and DevAek:get(AEK.."Aek:Lock:ProSet"..msg.chat_id_) then 
Dev_Aek(msg.chat_id_, msg.id_, 1,'✫︙لاتستطيع رفع احد وذالك بسبب تعطيل الرفع من قبل المنشئيين', 1, 'md')
return false
end
DevAek:sadd(AEK..'Aek:Admins:'..msg.chat_id_,user)
ReplyStatus(msg,user,"Reply","✫︙تم رفعه في قائمة الادمنيه")  
end

--        Rem admin       --
if text ==('تنزيل ادمن') and SourcelionCh(msg) then
function prom_reply(extra, result, success)
DevAek:srem(AEK..'Aek:Admins:'..msg.chat_id_,result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","✫︙تم تنزيله من قائمة الادمنيه")  
end 
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),prom_reply)
end end
if text and text:match('^تنزيل ادمن @(.*)') and SourcelionCh(msg) then
local username = text:match('^تنزيل ادمن @(.*)')
function promreply(extra,result,success)
if result.id_ then
DevAek:srem(AEK..'Aek:Admins:'..msg.chat_id_,result.id_)
ReplyStatus(msg,result.id_,"Reply","✫︙تم تنزيله من قائمة الادمنيه")  
else 
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙*المعرف غير صحيح*', 1, 'md')
end end 
resolve_username(username,promreply)
end
if text and text:match('^تنزيل ادمن (%d+)') and SourcelionCh(msg) then
local user = text:match('تنزيل ادمن (%d+)')
DevAek:srem(AEK..'Aek:Admins:'..msg.chat_id_,user)
ReplyStatus(msg,user,"Reply","✫︙تم تنزيله من قائمة الادمنيه")  
end end

--       Set Vipmem       --
if Admin(msg) then
if text ==('رفع مميز') and SourcelionCh(msg) then
function prom_reply(extra, result, success)
if not BasicConstructor(msg) and DevAek:get(AEK.."Aek:Lock:ProSet"..msg.chat_id_) then 
Dev_Aek(msg.chat_id_, msg.id_, 1,'✫︙لاتستطيع رفع احد وذالك بسبب تعطيل الرفع من قبل المنشئيين', 1, 'md')
return false
end
DevAek:sadd(AEK..'Aek:VipMem:'..msg.chat_id_,result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","✫︙تم رفعه في قائمة المميزين")  
end 
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),prom_reply)
end end
if text and text:match('^رفع مميز @(.*)') and SourcelionCh(msg) then
local username = text:match('^رفع مميز @(.*)')
function promreply(extra,result,success)
if not BasicConstructor(msg) and DevAek:get(AEK.."Aek:Lock:ProSet"..msg.chat_id_) then 
Dev_Aek(msg.chat_id_, msg.id_, 1,'✫︙لاتستطيع رفع احد وذالك بسبب تعطيل الرفع من قبل المنشئيين', 1, 'md')
return false
end
if result.id_ then
DevAek:sadd(AEK..'Aek:VipMem:'..msg.chat_id_,result.id_)
ReplyStatus(msg,result.id_,"Reply","✫︙تم رفعه في قائمة المميزين")  
else 
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙*المعرف غير صحيح*', 1, 'md')
end end 
resolve_username(username,promreply)
end
if text and text:match('^رفع مميز (%d+)') and SourcelionCh(msg) then
local user = text:match('رفع مميز (%d+)')
if not BasicConstructor(msg) and DevAek:get(AEK.."Aek:Lock:ProSet"..msg.chat_id_) then 
Dev_Aek(msg.chat_id_, msg.id_, 1,'✫︙لاتستطيع رفع احد وذالك بسبب تعطيل الرفع من قبل المنشئيين', 1, 'md')
return false
end
DevAek:sadd(AEK..'Aek:VipMem:'..msg.chat_id_,user)
ReplyStatus(msg,user,"Reply","✫︙تم رفعه في قائمة المميزين")  
end

--       Rem Vipmem       --
if text ==('تنزيل مميز') and SourcelionCh(msg) then
function prom_reply(extra, result, success)
DevAek:srem(AEK..'Aek:VipMem:'..msg.chat_id_,result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","✫︙تم تنزيله من قائمة المميزين")  
end 
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),prom_reply)
end end
if text and text:match('^تنزيل مميز @(.*)') and SourcelionCh(msg) then
local username = text:match('^تنزيل مميز @(.*)')
function promreply(extra,result,success)
if result.id_ then
DevAek:srem(AEK..'Aek:VipMem:'..msg.chat_id_,result.id_)
ReplyStatus(msg,result.id_,"Reply","✫︙تم تنزيله من قائمة المميزين")  
else 
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙*المعرف غير صحيح*', 1, 'md')
end end 
resolve_username(username,promreply)
end
if text and text:match('^تنزيل مميز (%d+)') and SourcelionCh(msg) then
local user = text:match('تنزيل مميز (%d+)')
DevAek:srem(AEK..'Aek:VipMem:'..msg.chat_id_,user)
ReplyStatus(msg,user,"Reply","✫︙تم تنزيله من قائمة المميزين")  
end end 

if BasicConstructor(msg) then
if text and text:match("^رفع مشرف$") and msg.reply_to_message_id_ then
function promote_by_reply(extra, result, success)
local Check = https.request('https://api.telegram.org/bot'..TokenBot..'/getChatMember?chat_id='..msg.chat_id_..'&user_id='..AEK)
local GetInfo = JSON.decode(Check)
if GetInfo.result.can_promote_members == true then 
HTTPS.request("https://api.telegram.org/bot" .. TokenBot .. "/promoteChatMember?chat_id=" .. msg.chat_id_ .. "&user_id=" ..result.sender_user_id_.."&can_change_info=True&can_delete_messages=True&can_invite_users=True&can_restrict_members=True&can_pin_messages=True&can_promote_members=false")
ReplyStatus(msg,result.sender_user_id_,"Reply","✫︙تم رفعه مشرف في المجموعه")  
else
Dev_Aek(msg.chat_id_, msg.id_, 1,'✫︙ليست لدي صلاحية اضافة مشرفين جدد يرجى التحقق من الصلاحيات', 1, 'md')
end
end
getMessage(msg.chat_id_, msg.reply_to_message_id_,promote_by_reply)
end
if text and text:match("^تنزيل مشرف$") and msg.reply_to_message_id_ then
function promote_by_reply(extra, result, success)
local Check = https.request('https://api.telegram.org/bot'..TokenBot..'/getChatMember?chat_id='..msg.chat_id_..'&user_id='..AEK)
local GetInfo = JSON.decode(Check)
if GetInfo.result.can_promote_members == true then 
HTTPS.request("https://api.telegram.org/bot" .. TokenBot .. "/promoteChatMember?chat_id=" .. msg.chat_id_ .. "&user_id=" ..result.sender_user_id_.."&can_change_info=false&can_delete_messages=false&can_invite_users=false&can_restrict_members=false&can_pin_messages=false&can_promote_members=false")
ReplyStatus(msg,result.sender_user_id_,"Reply","✫︙تم تنزيله من مشرفين المجموعه")  
else
Dev_Aek(msg.chat_id_, msg.id_, 1,'✫︙ليست لدي صلاحية اضافة مشرفين جدد يرجى التحقق من الصلاحيات', 1, 'md')
end
end
getMessage(msg.chat_id_, msg.reply_to_message_id_,promote_by_reply)
end 
if text and (text:match("^رفع بكل الصلاحيات$") or text:match("^رفع بكل صلاحيات$")) and msg.reply_to_message_id_ then
function promote_by_reply(extra, result, success)
local Check = https.request('https://api.telegram.org/bot'..TokenBot..'/getChatMember?chat_id='..msg.chat_id_..'&user_id='..AEK)
local GetInfo = JSON.decode(Check)
if GetInfo.result.can_promote_members == true then 
HTTPS.request("https://api.telegram.org/bot" .. TokenBot .. "/promoteChatMember?chat_id=" .. msg.chat_id_ .. "&user_id=" ..result.sender_user_id_.."&can_change_info=True&can_delete_messages=True&can_invite_users=True&can_restrict_members=True&can_pin_messages=True&can_promote_members=True")
ReplyStatus(msg,result.sender_user_id_,"Reply","✫︙تم رفعه مشرف في جميع الصلاحيات")  
else
Dev_Aek(msg.chat_id_, msg.id_, 1,'✫︙ليست لدي صلاحية اضافة مشرفين جدد يرجى التحقق من الصلاحيات', 1, 'md')
end
end
getMessage(msg.chat_id_, msg.reply_to_message_id_,promote_by_reply)
end
if text and (text:match("^وضع لقب (.*)$") or text:match("^رفع مشرف (.*)$") or text:match("^ضع لقب (.*)$")) and SourcelionCh(msg) then
local Aek = text:match("^وضع لقب (.*)$") or text:match("^رفع مشرف (.*)$") or text:match("^ضع لقب (.*)$")
function ReplySet(extra, result, success)
local Check = https.request('https://api.telegram.org/bot'..TokenBot..'/getChatMember?chat_id='..msg.chat_id_..'&user_id='..AEK)
local GetInfo = JSON.decode(Check)
if GetInfo.result.can_promote_members == true then 
https.request("https://api.telegram.org/bot"..TokenBot.."/promoteChatMember?chat_id=" .. msg.chat_id_ .. "&user_id=" ..result.sender_user_id_.."&can_change_info=false&can_delete_messages=false&can_invite_users=True&can_restrict_members=false&can_pin_messages=True&can_promote_members=false")
ReplyStatus(msg,result.sender_user_id_,"Reply","✫︙تم اضافة ↫ "..Aek.." كلقب له")  
https.request("https://api.telegram.org/bot"..TokenBot.."/setChatAdministratorCustomTitle?chat_id=" .. msg.chat_id_ .. "&user_id=" ..result.sender_user_id_.."&custom_title="..Aek)
else
Dev_Aek(msg.chat_id_, msg.id_, 1,'✫︙ليست لدي صلاحية اضافة مشرفين جدد يرجى التحقق من الصلاحيات', 1, 'md')
end
end
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),ReplySet)
end
end
end

if text == "صلاحيتي" and SourcelionCh(msg) or text == "صلاحياتي" and SourcelionCh(msg) then 
if tonumber(msg.reply_to_message_id_) == 0 then 
Validity(msg,msg.sender_user_id_)
end end
if text ==('صلاحيته') and SourcelionCh(msg) or text ==('صلاحياته') and SourcelionCh(msg) then
function ValidityReply(extra, result, success)
Validity(msg,result.sender_user_id_)
end 
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),ValidityReply)
end end
if text and (text:match('^صلاحيته @(.*)') or text:match('^صلاحياته @(.*)')) and SourcelionCh(msg) then
local username = text:match('^صلاحيته @(.*)') or text:match('^صلاحياته @(.*)')
function ValidityUser(extra,result,success)
if result.id_ then
Validity(msg,result.id_) 
else 
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙*المعرف غير صحيح*', 1, 'md')
end end 
resolve_username(username,ValidityUser)
end
if text and (text:match('^صلاحيته (%d+)') or text:match('^صلاحياته (%d+)')) and SourcelionCh(msg) then
local ValidityId = text:match('صلاحيته (%d+)') or text:match('صلاحياته (%d+)')
Validity(msg,ValidityId)  
end

if Admin(msg) then
if msg.reply_to_message_id_ ~= 0 then
if text and (text:match("^مسح$") or text:match("^حذف$")) and SourcelionCh(msg) then
DeleteMessage(msg.chat_id_,{[0] = msg.reply_to_message_id_})
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙تم حذف الرساله مع رسالة الامر', 1, 'md')
end end end

if Constructor(msg) then
if text == "تفعيل الحظر" and SourcelionCh(msg) or text == "تفعيل الطرد" and SourcelionCh(msg) then
DevAek:del(AEK.."Aek:Lock:KickBan"..msg.chat_id_)
local AEKTEAM = '✫︙اهلا عزيزي ↫ '..AekRank(msg)..' \n✫︙تم تفعيل الطرد والحظر'
Aekmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, AEKTEAM, 14, string.len(msg.sender_user_id_))
end
if text == "تعطيل الحظر" and SourcelionCh(msg) or text == "تعطيل الطرد" and SourcelionCh(msg) then
DevAek:set(AEK.."Aek:Lock:KickBan"..msg.chat_id_,"true")
local AEKTEAM = '✫︙اهلا عزيزي ↫ '..AekRank(msg)..' \n✫︙تم تعطيل الطرد والحظر'
Aekmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, AEKTEAM, 14, string.len(msg.sender_user_id_))
end
if text == "تفعيل الكتم" and SourcelionCh(msg) or text == "تفعيل التقييد" and SourcelionCh(msg) then
DevAek:del(AEK.."Aek:Lock:MuteTked"..msg.chat_id_)
local AEKTEAM = '✫︙اهلا عزيزي ↫ '..AekRank(msg)..' \n✫︙تم تفعيل الكتم والتقيد'
Aekmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, AEKTEAM, 14, string.len(msg.sender_user_id_))
end
if text == "تعطيل الكتم" and SourcelionCh(msg) or text == "تعطيل التقييد" and SourcelionCh(msg) then
DevAek:set(AEK.."Aek:Lock:MuteTked"..msg.chat_id_,"true")
local AEKTEAM = '✫︙اهلا عزيزي ↫ '..AekRank(msg)..' \n✫︙تم تعطيل الكتم والتقيد'
Aekmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, AEKTEAM, 14, string.len(msg.sender_user_id_))
end
end
if BasicConstructor(msg) then
if text == "تفعيل الرفع" and SourcelionCh(msg) or text == "تفعيل الترقيه" and SourcelionCh(msg) then
DevAek:del(AEK.."Aek:Lock:ProSet"..msg.chat_id_)
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙تم تفعيل رفع ↫ الادمن • المميز', 1, 'md')
end
if text == "تعطيل الرفع" and SourcelionCh(msg) or text == "تعطيل الترقيه" and SourcelionCh(msg) then
DevAek:set(AEK.."Aek:Lock:ProSet"..msg.chat_id_,"true")
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙تم تعطيل رفع ↫ الادمن • المميز', 1, 'md')
end
end

--          Kick          --
if Admin(msg) then
if text ==('طرد') and SourcelionCh(msg) then
function KickReply(extra, result, success)
if not Constructor(msg) and DevAek:get(AEK.."Aek:Lock:KickBan"..msg.chat_id_) then 
send(msg.chat_id_, msg.id_,'✫︙لقد تم تعطيل الطرد والحظر من قبل المنشئين')
return false
end
if RankChecking(result.sender_user_id_, result.chat_id_) then
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙لا تستطيع طرد ↫ '..IdRank(result.sender_user_id_, msg.chat_id_), 1, 'md')
else
tdcli_function({ID="ChangeChatMemberStatus",chat_id_=msg.chat_id_,user_id_=result.sender_user_id_,status_={ID="ChatMemberStatusKicked"},},function(arg,dp) 
if (dp and dp.code_ and dp.code_ == 400 and dp.message_ == "CHAT_ADMIN_REQUIRED") then 
send(msg.chat_id_,msg.id_,"✫︙ليس لدي صلاحية حظر المستخدمين يرجى تفعيلها !") 
return false  
end
if dp and dp.code_ and dp.code_ == 400 and dp.message_ == "USER_ADMIN_INVALID" then 
send(msg.chat_id_,msg.id_,"✫︙لا استطيع طرد مشرفين المجموعه") 
return false  
end
ChatKick(result.chat_id_, result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","✫︙تم طرده من المجموعه")  
end,nil)
end
end 
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),KickReply)
end end
if text and text:match('^طرد @(.*)') and SourcelionCh(msg) then
local username = text:match('^طرد @(.*)')
function KickUser(extra,result,success)
if not Constructor(msg) and DevAek:get(AEK.."Aek:Lock:KickBan"..msg.chat_id_) then 
send(msg.chat_id_, msg.id_,'✫︙لقد تم تعطيل الطرد والحظر من قبل المنشئين')
return false
end
if result.id_ then
if RankChecking(result.id_, msg.chat_id_) then
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙لا تستطيع طرد ↫ '..IdRank(result.id_, msg.chat_id_), 1, 'md')
else
tdcli_function({ID="ChangeChatMemberStatus",chat_id_=msg.chat_id_,user_id_=result.id_,status_={ID="ChatMemberStatusKicked"},},function(arg,dp) 
if (dp and dp.code_ and dp.code_ == 400 and dp.message_ == "CHAT_ADMIN_REQUIRED") then 
send(msg.chat_id_,msg.id_,"✫︙ليس لدي صلاحية حظر المستخدمين يرجى تفعيلها !") 
return false  
end
if dp and dp.code_ and dp.code_ == 400 and dp.message_ == "USER_ADMIN_INVALID" then 
send(msg.chat_id_,msg.id_,"✫︙لا استطيع طرد مشرفين المجموعه") 
return false  
end
ChatKick(msg.chat_id_, result.id_)
ReplyStatus(msg,result.id_,"Reply","✫︙تم طرده من المجموعه")  
end,nil)
end
else 
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙*المعرف غير صحيح*', 1, 'md')
end end 
resolve_username(username,KickUser)
end
if text and text:match('^طرد (%d+)') and SourcelionCh(msg) then
local user = text:match('طرد (%d+)')
if not Constructor(msg) and DevAek:get(AEK.."Aek:Lock:KickBan"..msg.chat_id_) then 
send(msg.chat_id_, msg.id_,'✫︙لقد تم تعطيل الطرد والحظر من قبل المنشئين')
return false
end
if RankChecking(user, msg.chat_id_) then
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙لا تستطيع طرد ↫ '..IdRank(user, msg.chat_id_), 1, 'md')
else
tdcli_function({ID="ChangeChatMemberStatus",chat_id_=msg.chat_id_,user_id_=user,status_={ID="ChatMemberStatusKicked"},},function(arg,dp) 
if (dp and dp.code_ and dp.code_ == 400 and dp.message_ == "CHAT_ADMIN_REQUIRED") then 
send(msg.chat_id_,msg.id_,"✫︙ليس لدي صلاحية حظر المستخدمين يرجى تفعيلها !") 
return false  
end
if dp and dp.code_ and dp.code_ == 400 and dp.message_ == "USER_ADMIN_INVALID" then 
send(msg.chat_id_,msg.id_,"✫︙لا استطيع طرد مشرفين المجموعه") 
return false  
end
ChatKick(msg.chat_id_, user)
ReplyStatus(msg,user,"Reply","✫︙تم طرده من المجموعه")  
end,nil)
end
end
end 

--          Ban           --
if Admin(msg) then
if text ==('حضر') and SourcelionCh(msg) or text ==('حظر') and SourcelionCh(msg) then
function BanReply(extra, result, success)
if not Constructor(msg) and DevAek:get(AEK.."Aek:Lock:KickBan"..msg.chat_id_) then 
send(msg.chat_id_, msg.id_,'✫︙لقد تم تعطيل الطرد والحظر من قبل المنشئين')
return false
end
if RankChecking(result.sender_user_id_, result.chat_id_) then
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙لا تستطيع حظر ↫ '..IdRank(result.sender_user_id_, msg.chat_id_), 1, 'md')
else
tdcli_function({ID="ChangeChatMemberStatus",chat_id_=msg.chat_id_,user_id_=result.sender_user_id_,status_={ID="ChatMemberStatusKicked"},},function(arg,dp) 
if (dp and dp.code_ and dp.code_ == 400 and dp.message_ == "CHAT_ADMIN_REQUIRED") then 
send(msg.chat_id_,msg.id_,"✫︙ليس لدي صلاحية حظر المستخدمين يرجى تفعيلها !") 
return false  
end
if dp and dp.code_ and dp.code_ == 400 and dp.message_ == "USER_ADMIN_INVALID" then 
send(msg.chat_id_,msg.id_,"✫︙لا استطيع حظر مشرفين المجموعه") 
return false  
end
ChatKick(result.chat_id_, result.sender_user_id_)
DevAek:sadd(AEK..'Aek:Ban:'..msg.chat_id_, result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","✫︙تم حظره من المجموعه") 
end,nil) 
end 
end 
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),BanReply)
end end
if text and (text:match('^حضر @(.*)') or text:match('^حظر @(.*)')) and SourcelionCh(msg) then
local username = text:match('^حضر @(.*)') or text:match('^حظر @(.*)')
function BanUser(extra,result,success)
if not Constructor(msg) and DevAek:get(AEK.."Aek:Lock:KickBan"..msg.chat_id_) then 
send(msg.chat_id_, msg.id_,'✫︙لقد تم تعطيل الطرد والحظر من قبل المنشئين')
return false
end
if result.id_ then
if RankChecking(result.id_, msg.chat_id_) then
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙لا تستطيع حظر ↫ '..IdRank(result.id_, msg.chat_id_), 1, 'md')
else
tdcli_function({ID="ChangeChatMemberStatus",chat_id_=msg.chat_id_,user_id_=result.id_,status_={ID="ChatMemberStatusKicked"},},function(arg,dp) 
if (dp and dp.code_ and dp.code_ == 400 and dp.message_ == "CHAT_ADMIN_REQUIRED") then 
send(msg.chat_id_,msg.id_,"✫︙ليس لدي صلاحية حظر المستخدمين يرجى تفعيلها !") 
return false  
end
if dp and dp.code_ and dp.code_ == 400 and dp.message_ == "USER_ADMIN_INVALID" then 
send(msg.chat_id_,msg.id_,"✫︙لا استطيع حظر مشرفين المجموعه") 
return false  
end
ChatKick(msg.chat_id_, result.id_)
DevAek:sadd(AEK..'Aek:Ban:'..msg.chat_id_, result.id_)
ReplyStatus(msg,result.id_,"Reply","✫︙تم حظره من المجموعه")  
end,nil) 
end
else 
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙*المعرف غير صحيح*', 1, 'md')
end end 
resolve_username(username,BanUser)
end
if text and (text:match('^حضر (%d+)') or text:match('^حظر (%d+)')) and SourcelionCh(msg) then
local user = text:match('حضر (%d+)') or text:match('حظر (%d+)')
if not Constructor(msg) and DevAek:get(AEK.."Aek:Lock:KickBan"..msg.chat_id_) then 
send(msg.chat_id_, msg.id_,'✫︙لقد تم تعطيل الطرد والحظر من قبل المنشئين')
return false
end
if RankChecking(user, msg.chat_id_) then
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙لا تستطيع حظر ↫ '..IdRank(user, msg.chat_id_), 1, 'md')
else
tdcli_function({ID="ChangeChatMemberStatus",chat_id_=msg.chat_id_,user_id_=user,status_={ID="ChatMemberStatusKicked"},},function(arg,dp) 
if (dp and dp.code_ and dp.code_ == 400 and dp.message_ == "CHAT_ADMIN_REQUIRED") then 
send(msg.chat_id_,msg.id_,"✫︙ليس لدي صلاحية حظر المستخدمين يرجى تفعيلها !") 
return false  
end
if dp and dp.code_ and dp.code_ == 400 and dp.message_ == "USER_ADMIN_INVALID" then 
send(msg.chat_id_,msg.id_,"✫︙لا استطيع حظر مشرفين المجموعه") 
return false  
end
ChatKick(msg.chat_id_, user)
DevAek:sadd(AEK..'Aek:Ban:'..msg.chat_id_, user)
ReplyStatus(msg,user,"Reply","✫︙تم حظره من المجموعه")  
end,nil) 
end
end

--         UnBan          --
if text ==('الغاء الحظر') and SourcelionCh(msg) or text ==('الغاء حظر') and SourcelionCh(msg) then
function UnBanReply(extra, result, success)
DevAek:srem(AEK..'Aek:Ban:'..msg.chat_id_, result.sender_user_id_)
tdcli_function ({ ID = "ChangeChatMemberStatus", chat_id_ = msg.chat_id_, user_id_ = result.sender_user_id_, status_ = { ID = "ChatMemberStatusLeft" },},function(arg,ban) end,nil)   
ReplyStatus(msg,result.sender_user_id_,"Reply","✫︙تم الغاء حظره من المجموعه")  
end 
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),UnBanReply)
end end
if text and (text:match('^الغاء الحظر @(.*)') or text:match('^الغاء حظر @(.*)')) and SourcelionCh(msg) then
local username = text:match('^الغاء الحظر @(.*)') or text:match('^الغاء حظر @(.*)')
function UnBanUser(extra,result,success)
if result.id_ then
DevAek:srem(AEK..'Aek:Ban:'..msg.chat_id_, result.id_)
tdcli_function ({ ID = "ChangeChatMemberStatus", chat_id_ = msg.chat_id_, user_id_ = result.id_, status_ = { ID = "ChatMemberStatusLeft" },},function(arg,ban) end,nil)   
ReplyStatus(msg,result.id_,"Reply","✫︙تم الغاء حظره من المجموعه")  
else 
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙*المعرف غير صحيح*', 1, 'md')
end end 
resolve_username(username,UnBanUser)
end
if text and (text:match('^الغاء الحظر (%d+)') or text:match('^الغاء حظر (%d+)')) and SourcelionCh(msg) then
local user = text:match('الغاء الحظر (%d+)') or text:match('الغاء حظر (%d+)')
DevAek:srem(AEK..'Aek:Ban:'..msg.chat_id_, user)
tdcli_function ({ ID = "ChangeChatMemberStatus", chat_id_ = msg.chat_id_, user_id_ = user, status_ = { ID = "ChatMemberStatusLeft" },},function(arg,ban) end,nil)   
ReplyStatus(msg,user,"Reply","✫︙تم الغاء حظره من المجموعه")  
end 
end 

--          Mute          --
if Admin(msg) then
if text ==('كتم') and SourcelionCh(msg) then
function MuteReply(extra, result, success)
if not Constructor(msg) and DevAek:get(AEK.."Aek:Lock:MuteTked"..msg.chat_id_) then 
send(msg.chat_id_, msg.id_,'✫︙لقد تم تعطيل الكتم والتقيد من قبل المنشئين')
return false
end
if RankChecking(result.sender_user_id_, result.chat_id_) then
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙لا تستطيع كتم ↫ '..IdRank(result.sender_user_id_, msg.chat_id_), 1, 'md')
else
if DevAek:sismember(AEK..'Aek:Muted:'..msg.chat_id_, result.sender_user_id_) then
ReplyStatus(msg,result.sender_user_id_,"Reply","✫︙هو بالفعل مكتوم من المجموعه")  
else
DevAek:sadd(AEK..'Aek:Muted:'..msg.chat_id_, result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","✫︙تم كتمه من المجموعه")  
end 
end
end 
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),MuteReply)
end end
if text and text:match('^كتم @(.*)') and SourcelionCh(msg) then
local username = text:match('^كتم @(.*)')
function MuteUser(extra,result,success)
if not Constructor(msg) and DevAek:get(AEK.."Aek:Lock:MuteTked"..msg.chat_id_) then 
send(msg.chat_id_, msg.id_,'✫︙لقد تم تعطيل الكتم والتقيد من قبل المنشئين')
return false
end
if result.id_ then
if RankChecking(result.id_, msg.chat_id_) then
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙لا تستطيع كتم ↫ '..IdRank(result.id_, msg.chat_id_), 1, 'md')
else
if DevAek:sismember(AEK..'Aek:Muted:'..msg.chat_id_, result.id_) then
ReplyStatus(msg,result.id_,"Reply","✫︙هو بالفعل مكتوم من المجموعه")  
else
DevAek:sadd(AEK..'Aek:Muted:'..msg.chat_id_, result.id_)
ReplyStatus(msg,result.id_,"Reply","✫︙تم كتمه من المجموعه")  
end
end
else 
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙*المعرف غير صحيح*', 1, 'md')
end end 
resolve_username(username,MuteUser)
end
if text and text:match('^كتم (%d+)') and SourcelionCh(msg) then
local user = text:match('كتم (%d+)')
if not Constructor(msg) and DevAek:get(AEK.."Aek:Lock:MuteTked"..msg.chat_id_) then 
send(msg.chat_id_, msg.id_,'✫︙لقد تم تعطيل الكتم والتقيد من قبل المنشئين')
return false
end
if RankChecking(user, msg.chat_id_) then
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙لا تستطيع كتم ↫ '..IdRank(user, msg.chat_id_), 1, 'md')
else
if DevAek:sismember(AEK..'Aek:Muted:'..msg.chat_id_, user) then
ReplyStatus(msg,user,"Reply","✫︙هو بالفعل مكتوم من المجموعه")  
else
DevAek:sadd(AEK..'Aek:Muted:'..msg.chat_id_, user)
ReplyStatus(msg,user,"Reply","✫︙تم كتمه من المجموعه")  
end
end
end

--         UnMute         --
if text ==('الغاء الكتم') and SourcelionCh(msg) or text ==('الغاء كتم') and SourcelionCh(msg) then
function UnMuteReply(extra, result, success)
if not DevAek:sismember(AEK..'Aek:Muted:'..msg.chat_id_, result.sender_user_id_) then
ReplyStatus(msg,result.sender_user_id_,"Reply","✫︙هو ليس مكتوم لالغاء كتمه")  
else
DevAek:srem(AEK..'Aek:Muted:'..msg.chat_id_, result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","✫︙تم الغاء كتمه من المجموعه")  
end
end 
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),UnMuteReply)
end end
if text and (text:match('^الغاء الكتم @(.*)') or text:match('^الغاء كتم @(.*)')) and SourcelionCh(msg) then
local username = text:match('^الغاء الكتم @(.*)') or text:match('^الغاء كتم @(.*)')
function UnMuteUser(extra,result,success)
if result.id_ then
if not DevAek:sismember(AEK..'Aek:Muted:'..msg.chat_id_, result.id_) then
ReplyStatus(msg,result.id_,"Reply","✫︙هو ليس مكتوم لالغاء كتمه")  
else
DevAek:srem(AEK..'Aek:Muted:'..msg.chat_id_, result.id_)
ReplyStatus(msg,result.id_,"Reply","✫︙تم الغاء كتمه من المجموعه")  
end
else 
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙*المعرف غير صحيح*', 1, 'md')
end end 
resolve_username(username,UnMuteUser)
end
if text and (text:match('^الغاء الكتم (%d+)') or text:match('^الغاء كتم (%d+)')) and SourcelionCh(msg) then
local user = text:match('الغاء الكتم (%d+)') or text:match('الغاء كتم (%d+)')
if not DevAek:sismember(AEK..'Aek:Muted:'..msg.chat_id_, user) then
ReplyStatus(msg,user,"Reply","✫︙هو ليس مكتوم لالغاء كتمه")  
else
DevAek:srem(AEK..'Aek:Muted:'..msg.chat_id_, user)
ReplyStatus(msg,user,"Reply","✫︙تم الغاء كتمه من المجموعه")  
end
end 
end 

--          Tkeed           --
if Admin(msg) then
if text ==('تقييد') and SourcelionCh(msg) or text ==('تقيد') and SourcelionCh(msg) then
function TkeedReply(extra, result, success)
if not Constructor(msg) and DevAek:get(AEK.."Aek:Lock:MuteTked"..msg.chat_id_) then 
send(msg.chat_id_, msg.id_,'✫︙لقد تم تعطيل الكتم والتقيد من قبل المنشئين')
return false
end
if RankChecking(result.sender_user_id_, result.chat_id_) then
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙لا تستطيع تقيد ↫ '..IdRank(result.sender_user_id_, msg.chat_id_), 1, 'md')
else
HTTPS.request("https://api.telegram.org/bot"..TokenBot.."/restrictChatMember?chat_id="..msg.chat_id_.."&user_id="..result.sender_user_id_)
DevAek:sadd(AEK..'Aek:Tkeed:'..msg.chat_id_, result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","✫︙تم تقيده من المجموعه")  
end
end 
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),TkeedReply)
end end
if text and (text:match('^تقييد @(.*)') or text:match('^تقيد @(.*)')) and SourcelionCh(msg) then
local username = text:match('^تقييد @(.*)') or text:match('^تقيد @(.*)')
function TkeedUser(extra,result,success)
if not Constructor(msg) and DevAek:get(AEK.."Aek:Lock:MuteTked"..msg.chat_id_) then 
send(msg.chat_id_, msg.id_,'✫︙لقد تم تعطيل الكتم والتقيد من قبل المنشئين')
return false
end
if result.id_ then
if RankChecking(result.id_, msg.chat_id_) then
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙لا تستطيع تقيد ↫ '..IdRank(result.id_, msg.chat_id_), 1, 'md')
else
HTTPS.request("https://api.telegram.org/bot"..TokenBot.."/restrictChatMember?chat_id="..msg.chat_id_.."&user_id="..result.id_)
DevAek:sadd(AEK..'Aek:Tkeed:'..msg.chat_id_, result.id_)
ReplyStatus(msg,result.id_,"Reply","✫︙تم تقيده من المجموعه")  
end
else 
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙*المعرف غير صحيح*', 1, 'md')
end end 
resolve_username(username,TkeedUser)
end
if text and (text:match('^تقييد (%d+)') or text:match('^تقيد (%d+)')) and SourcelionCh(msg) then
local user = text:match('تقييد (%d+)') or text:match('تقيد (%d+)')
if not Constructor(msg) and DevAek:get(AEK.."Aek:Lock:MuteTked"..msg.chat_id_) then 
send(msg.chat_id_, msg.id_,'✫︙لقد تم تعطيل الكتم والتقيد من قبل المنشئين')
return false
end
if RankChecking(user, msg.chat_id_) then
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙لا تستطيع تقيد ↫ '..IdRank(user, msg.chat_id_), 1, 'md')
else
HTTPS.request("https://api.telegram.org/bot"..TokenBot.."/restrictChatMember?chat_id="..msg.chat_id_.."&user_id="..user)
DevAek:sadd(AEK..'Aek:Tkeed:'..msg.chat_id_, user)
ReplyStatus(msg,user,"Reply","✫︙تم تقيده من المجموعه")  
end
end

--         UnTkeed          --
if text ==('الغاء تقييد') and SourcelionCh(msg) or text ==('الغاء تقيد') and SourcelionCh(msg) then
function UnTkeedReply(extra, result, success)
HTTPS.request("https://api.telegram.org/bot"..TokenBot.."/restrictChatMember?chat_id="..msg.chat_id_.."&user_id="..result.sender_user_id_.."&can_send_messages=True&can_send_media_messages=True&can_send_other_messages=True&can_add_web_page_previews=True")
DevAek:srem(AEK..'Aek:Tkeed:'..msg.chat_id_, result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","✫︙تم الغاء تقيده من المجموعه")  
end
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),UnTkeedReply)
end end
if text and (text:match('^الغاء تقييد @(.*)') or text:match('^الغاء تقيد @(.*)')) and SourcelionCh(msg) then
local username = text:match('^الغاء تقييد @(.*)') or text:match('^الغاء تقيد @(.*)')
function UnTkeedUser(extra,result,success)
if result.id_ then
HTTPS.request("https://api.telegram.org/bot"..TokenBot.."/restrictChatMember?chat_id="..msg.chat_id_.."&user_id="..result.id_.."&can_send_messages=True&can_send_media_messages=True&can_send_other_messages=True&can_add_web_page_previews=True")
DevAek:srem(AEK..'Aek:Tkeed:'..msg.chat_id_, result.id_)
ReplyStatus(msg,result.id_,"Reply","✫︙تم الغاء تقيده من المجموعه")  
else 
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙*المعرف غير صحيح*', 1, 'md')
end end 
resolve_username(username,UnTkeedUser)
end
if text and (text:match('^الغاء تقييد (%d+)') or text:match('^الغاء تقيد (%d+)')) and SourcelionCh(msg) then
local user = text:match('الغاء تقييد (%d+)') or text:match('الغاء تقيد (%d+)')
HTTPS.request("https://api.telegram.org/bot"..TokenBot.."/restrictChatMember?chat_id="..msg.chat_id_.."&user_id="..user.."&can_send_messages=True&can_send_media_messages=True&can_send_other_messages=True&can_add_web_page_previews=True")
DevAek:srem(AEK..'Aek:Tkeed:'..msg.chat_id_, user)
ReplyStatus(msg,user,"Reply","✫︙تم الغاء تقيده من المجموعه")  
end
end 
end

--         BanAll         --
if SecondSudo(msg) then
if text ==('حضر عام') or text ==('حظر عام') then
function BanAllReply(extra, result, success)
if tonumber(result.sender_user_id_) == tonumber(AEK) then  
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙*لاتستطيع حظر البوت عام*", 1, 'md')
return false 
end
if SudoId(result.sender_user_id_) == true then
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙*لاتستطيع حظر المطور الاساسي*", 1, 'md')
return false 
end
if DevAek:sismember(AEK..'Aek:SecondSudo:',result.sender_user_id_) and not Sudo(msg) then
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙*لاتستطيع حظر المطور الثانوي*", 1, 'md')
return false 
end
ChatKick(result.chat_id_, result.sender_user_id_)
DevAek:sadd(AEK..'Aek:BanAll:', result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","✫︙تم حظره عام من المجموعات")  
end 
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),BanAllReply)
end end
if text and (text:match('^حضر عام @(.*)') or text:match('^حظر عام @(.*)')) then
local username = text:match('^حضر عام @(.*)') or text:match('^حظر عام @(.*)')
function BanAllUser(extra,result,success)
if tonumber(result.id_) == tonumber(AEK) then  
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙*لاتستطيع حظر البوت عام*", 1, 'md')
return false 
end
if SudoId(result.id_) == true then
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙*لاتستطيع حظر المطور الاساسي*", 1, 'md')
return false 
end
if DevAek:sismember(AEK..'Aek:SecondSudo:',result.id_) and not Sudo(msg) then
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙*لاتستطيع حظر المطور الثانوي*", 1, 'md')
return false 
end
if result.id_ then
ChatKick(msg.chat_id_, result.id_)
DevAek:sadd(AEK..'Aek:BanAll:', result.id_)
ReplyStatus(msg,result.id_,"Reply","✫︙تم حظره عام من المجموعات")  
else 
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙*المعرف غير صحيح*', 1, 'md')
end end 
resolve_username(username,BanAllUser)
end
if text and (text:match('^حضر عام (%d+)') or text:match('^حظر عام (%d+)')) then
local user = text:match('حضر عام (%d+)') or text:match('حظر عام (%d+)')
if tonumber(user) == tonumber(AEK) then  
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙*لاتستطيع حظر البوت عام*", 1, 'md')
return false 
end
if SudoId(tonumber(user)) == true then
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙*لاتستطيع حظر المطور الاساسي*", 1, 'md')
return false 
end
if DevAek:sismember(AEK..'Aek:SecondSudo:',user) and not Sudo(msg) then
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙*لاتستطيع حظر المطور الثانوي*", 1, 'md')
return false 
end
ChatKick(msg.chat_id_, user)
DevAek:sadd(AEK..'Aek:BanAll:', user)
ReplyStatus(msg,user,"Reply","✫︙تم حظره عام من المجموعات")  
end

--         MuteAll        --
if text ==('كتم عام') then
function MuteAllReply(extra, result, success)
if tonumber(result.sender_user_id_) == tonumber(AEK) then  
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙*لاتستطيع كتم البوت عام*", 1, 'md')
return false 
end
if SudoId(result.sender_user_id_) == true then
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙*لاتستطيع كتم المطور الاساسي*", 1, 'md')
return false 
end
if DevAek:sismember(AEK..'Aek:SecondSudo:',result.sender_user_id_) and not Sudo(msg) then
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙*لاتستطيع كتم المطور الثانوي*", 1, 'md')
return false 
end
DevAek:sadd(AEK..'Aek:MuteAll:', result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","✫︙تم كتمه عام من المجموعات")  
end 
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),MuteAllReply)
end end
if text and text:match('^كتم عام @(.*)') then
local username = text:match('^كتم عام @(.*)')
function MuteAllUser(extra,result,success)
if tonumber(result.id_) == tonumber(AEK) then  
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙*لاتستطيع كتم البوت عام*", 1, 'md')
return false 
end
if SudoId(result.id_) == true then
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙*لاتستطيع كتم المطور الاساسي*", 1, 'md')
return false 
end
if DevAek:sismember(AEK..'Aek:SecondSudo:',result.id_) and not Sudo(msg) then
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙*لاتستطيع كتم المطور الثانوي*", 1, 'md')
return false 
end
if result.id_ then
DevAek:sadd(AEK..'Aek:MuteAll:', result.id_)
ReplyStatus(msg,result.id_,"Reply","✫︙تم كتمه عام من المجموعات")  
else 
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙*المعرف غير صحيح*', 1, 'md')
end end 
resolve_username(username,MuteAllUser)
end
if text and text:match('^كتم عام (%d+)') then
local user = text:match('كتم عام (%d+)')
if tonumber(user) == tonumber(AEK) then  
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙*لاتستطيع كتم البوت عام*", 1, 'md')
return false 
end
if SudoId(tonumber(user)) == true then
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙*لاتستطيع كتم المطور الاساسي*", 1, 'md')
return false 
end
if DevAek:sismember(AEK..'Aek:SecondSudo:',user) and not Sudo(msg) then
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙*لاتستطيع كتم المطور الثانوي*", 1, 'md')
return false 
end
DevAek:sadd(AEK..'Aek:MuteAll:', user)
ReplyStatus(msg,user,"Reply","✫︙تم كتمه عام من المجموعات")  
end

--         UnAll          --
if text ==('الغاء عام') or text ==('الغاء العام') then
function UnAllReply(extra, result, success)
DevAek:srem(AEK..'Aek:BanAll:', result.sender_user_id_)
DevAek:srem(AEK..'Aek:MuteAll:', result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","✫︙تم الغاء (الحظر • الكتم) عام من المجموعات")  
end 
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),UnAllReply)
end end
if text and (text:match('^الغاء عام @(.*)') or text:match('^الغاء العام @(.*)')) then
local username = text:match('^الغاء عام @(.*)') or text:match('^الغاء العام @(.*)')
function UnAllUser(extra,result,success)
if result.id_ then
DevAek:srem(AEK..'Aek:BanAll:', result.id_)
DevAek:srem(AEK..'Aek:MuteAll:', result.id_)
ReplyStatus(msg,result.id_,"Reply","✫︙تم الغاء (الحظر • الكتم) عام من المجموعات")  
else 
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙*المعرف غير صحيح*', 1, 'md')
end end 
resolve_username(username,UnAllUser)
end
if text and (text:match('^الغاء عام (%d+)') or text:match('^الغاء العام (%d+)')) then
local user = text:match('الغاء عام (%d+)') or text:match('الغاء العام (%d+)')
DevAek:srem(AEK..'Aek:BanAll:', user)
DevAek:srem(AEK..'Aek:MuteAll:', user)
ReplyStatus(msg,user,"Reply","✫︙تم الغاء (الحظر • الكتم) عام من المجموعات")  
end
end
end

if (text == "تغير المطور الاساسي" or text == "نقل ملكيه البوت" or text == "تغيير المطور الاساسي" or text == "↫ تغير المطور الاساسي ✫") and msg.reply_to_message_id_ == 0 and Sudo(msg) then 
send(msg.chat_id_, msg.id_,'✫︙يجب التاكد ان المطور الجديد ارسل start لخاص البوت بعد ذلك يمكنك ارسال ايدي المطور')
DevAek:setex(AEK.."Aek:EditDev"..msg.sender_user_id_,300,true)
end
if DevAek:get(AEK.."Aek:EditDev"..msg.sender_user_id_) then
if text and text:match("^الغاء$") then 
send(msg.chat_id_, msg.id_,'✫︙تم الغاء امر تغير المطور الاساسي')
DevAek:del(AEK.."Aek:EditDev"..msg.sender_user_id_)
return false
end
if text and text:match("^(%d+)$") then 
tdcli_function ({ID = "GetUser",user_id_ = text},function(arg,dp) 
if dp.first_name_ ~= false then
DevAek:del(AEK.."Aek:EditDev"..msg.sender_user_id_)
DevAek:set(AEK.."Aek:NewDev"..msg.sender_user_id_,dp.id_)
if dp.username_ ~= false then DevUser = '\n✫︙المعرف ↫ [@'..dp.username_..']' else DevUser = '' end
local Text = '✫︙الايدي ↫ '..dp.id_..DevUser..'\n✫︙الاسم ↫ ['..dp.first_name_..'](tg://user?id='..dp.id_..')\n✫︙تم حفظ المعلومات بنجاح\n✫︙استخدم الازرار للتاكيد ↫ ⤈'
keyboard = {} 
keyboard.inline_keyboard = {{{text="نعم",callback_data="/setyes"},{text="لا",callback_data="/setno"}}} 
Msg_id = msg.id_/2097152/0.5
return https.request("https://api.telegram.org/bot"..TokenBot..'/sendMessage?chat_id=' .. msg.chat_id_ .. '&text=' .. URL.escape(Text).."&reply_to_message_id="..Msg_id.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
else
send(msg.chat_id_, msg.id_,"✫︙المعلومات خاطئه قم بالتاكد واعد المحاوله")
DevAek:del(AEK.."Aek:EditDev"..msg.sender_user_id_)
end
end,nil)
return false
end
end

if msg.reply_to_message_id_ ~= 0 then
if text and text:match("^رفع مطي$") and not DevAek:get(AEK..'Aek:Lock:Stupid'..msg.chat_id_) and SourcelionCh(msg) then
function donky_by_reply(extra, result, success)
if DevAek:sismember(AEK..'User:Donky:'..msg.chat_id_, result.sender_user_id_) then
ReplyStatus(msg,result.sender_user_id_,"Reply","✫︙هو مطي شرفع منه بعد😹💔") 
else
ReplyStatus(msg,result.sender_user_id_,"Reply","✫︙تم رفعه في قائمة المطايه") 
DevAek:sadd(AEK..'User:Donky:'..msg.chat_id_, result.sender_user_id_)
end end
getMessage(msg.chat_id_, msg.reply_to_message_id_,donky_by_reply)
end end

if msg.reply_to_message_id_ ~= 0  then
if text and text:match("^تنزيل مطي$") and not DevAek:get(AEK..'Aek:Lock:Stupid'..msg.chat_id_) and SourcelionCh(msg) then
function donky_by_reply(extra, result, success)
if not DevAek:sismember(AEK..'User:Donky:'..msg.chat_id_, result.sender_user_id_) then
ReplyStatus(msg,result.sender_user_id_,"Reply","✫︙هو ليس مطي ليتم تنزيله") 
else
DevAek:srem(AEK..'User:Donky:'..msg.chat_id_, result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","✫︙تم تنزيله من قائمة المطايه") 
end end
getMessage(msg.chat_id_, msg.reply_to_message_id_,donky_by_reply)
end end

if Admin(msg) then
if text and (text:match('^تقييد دقيقه (%d+)$') or text:match('^كتم دقيقه (%d+)$') or text:match('^تقيد دقيقه (%d+)$')) and SourcelionCh(msg) then 
local function mut_time(extra, result,success)
local mutept = text:match('^تقييد دقيقه (%d+)$') or text:match('^كتم دقيقه (%d+)$') or text:match('^تقيد دقيقه (%d+)$')
local Minutes = string.gsub(mutept, 'm', '')
local num1 = tonumber(Minutes) * 60 
if RankChecking(result.sender_user_id_, msg.chat_id_) then 
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙لا تستطيع تقيد ↫ '..IdRank(result.sender_user_id_, msg.chat_id_), 1, 'md') 
else 
https.request("https://api.telegram.org/bot"..TokenBot.."/restrictChatMember?chat_id="..msg.chat_id_.."&user_id="..result.sender_user_id_..'&until_date='..tonumber(msg.date_+num1))
ReplyStatus(msg,result.sender_user_id_,"Reply","✫︙تم تقيده لمدة ↫ "..mutept.." د") 
DevAek:sadd(AEK..'Aek:Tkeed:'..msg.chat_id_, result.sender_user_id_)
end end 
if tonumber(msg.reply_to_message_id_) == 0 then else
tdcli_function ({ID = "GetMessage",chat_id_ = msg.chat_id_,message_id_ = tonumber(msg.reply_to_message_id_)}, mut_time,nil) end 
end
if text and (text:match('^تقييد ساعه (%d+)$') or text:match('^كتم ساعه (%d+)$') or text:match('^تقيد ساعه (%d+)$')) and SourcelionCh(msg) then 
local function mut_time(extra, result,success)
local mutept = text:match('^تقييد ساعه (%d+)$') or text:match('^كتم ساعه (%d+)$') or text:match('^تقيد ساعه (%d+)$')
local hour = string.gsub(mutept, 'h', '')
local num1 = tonumber(hour) * 3600 
if RankChecking(result.sender_user_id_, msg.chat_id_) then 
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙لا تستطيع تقيد ↫ '..IdRank(result.sender_user_id_, msg.chat_id_), 1, 'md') 
else 
https.request("https://api.telegram.org/bot"..TokenBot.."/restrictChatMember?chat_id="..msg.chat_id_.."&user_id="..result.sender_user_id_..'&until_date='..tonumber(msg.date_+num1))
ReplyStatus(msg,result.sender_user_id_,"Reply","✫︙تم تقيده لمدة ↫ "..mutept.." س") 
DevAek:sadd(AEK..'Aek:Tkeed:'..msg.chat_id_, result.sender_user_id_)
end end
if tonumber(msg.reply_to_message_id_) == 0 then else
tdcli_function ({ID = "GetMessage",chat_id_ = msg.chat_id_,message_id_ = tonumber(msg.reply_to_message_id_)}, mut_time,nil) end 
end 
if text and (text:match('^تقييد يوم (%d+)$') or text:match('^كتم يوم (%d+)$') or text:match('^تقيد يوم (%d+)$')) and SourcelionCh(msg) then 
local function mut_time(extra, result,success)
local mutept = text:match('^تقييد يوم (%d+)$') or text:match('^كتم يوم (%d+)$') or text:match('^تقيد يوم (%d+)$')
local day = string.gsub(mutept, 'd', '')
local num1 = tonumber(day) * 86400 
if RankChecking(result.sender_user_id_, msg.chat_id_) then 
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙لا تستطيع تقيد ↫ '..IdRank(result.sender_user_id_, msg.chat_id_), 1, 'md') 
else 
https.request("https://api.telegram.org/bot"..TokenBot.."/restrictChatMember?chat_id="..msg.chat_id_.."&user_id="..result.sender_user_id_..'&until_date='..tonumber(msg.date_+num1))
ReplyStatus(msg,result.sender_user_id_,"Reply","✫︙تم تقيده لمدة ↫ "..mutept.." ي") 
DevAek:sadd(AEK..'Aek:Tkeed:'..msg.chat_id_, result.sender_user_id_)
end end
if tonumber(msg.reply_to_message_id_) == 0 then else
tdcli_function ({ID = "GetMessage",chat_id_ = msg.chat_id_,message_id_ = tonumber(msg.reply_to_message_id_)}, mut_time,nil) end 
end 
end 

if text and text:match("^اضف رسائل (%d+)$") and msg.reply_to_message_id_ == 0 and SourcelionCh(msg) then  
if Constructor(msg) then
TXT = text:match("^اضف رسائل (%d+)$")
DevAek:set('AEKTEAM:'..AEK..'id:user'..msg.chat_id_,TXT)  
DevAek:setex('AEKTEAM:'..AEK.."numadd:user" .. msg.chat_id_ .. "" .. msg.sender_user_id_, 300, true)  
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙ارسل عدد الرسائل الان \n✫︙ارسل الغاء لالغاء الامر ", 1, "md")
Dev_Aek(msg.chat_id_, msg.id_, 1,numd, 1, 'md') 
else 
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙هذا الامر للمنشئين فقط', 1, 'md') 
end 
end 
if text and text:match("^اضف رسائل (%d+)$") and msg.reply_to_message_id_ ~= 0 and Constructor(msg) then
local Num = text:match("^اضف رسائل (%d+)$")
function Reply(extra, result, success)
DevAek:del(AEK..'Aek:UsersMsgs'..msg.chat_id_..':'..result.sender_user_id_) 
DevAek:incrby(AEK..'Aek:UsersMsgs'..msg.chat_id_..':'..result.sender_user_id_,Num) 
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙تم اضافة "..Num..' رساله', 1, 'md') 
end
tdcli_function ({ID = "GetMessage",chat_id_=msg.chat_id_,message_id_=tonumber(msg.reply_to_message_id_)},Reply, nil)
return false
end
if text and text:match("^اضف نقاط (%d+)$") and msg.reply_to_message_id_ == 0 and SourcelionCh(msg) then  
if Constructor(msg) then
TXT = text:match("^اضف نقاط (%d+)$")
DevAek:set('AEKTEAM:'..AEK..'ids:user'..msg.chat_id_,TXT)  
DevAek:setex('AEKTEAM:'..AEK.."nmadd:user" .. msg.chat_id_ .. "" .. msg.sender_user_id_, 300, true)  
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙ارسل عدد النقاط الان \n✫︙ارسل الغاء لالغاء الامر ", 1, "md")
Dev_Aek(msg.chat_id_, msg.id_, 1,numd, 1, 'md') 
else 
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙هذا الامر للمنشئين فقط', 1, 'md') 
end 
end 
if text and text:match("^اضف نقاط (%d+)$") and msg.reply_to_message_id_ ~= 0 and Constructor(msg) then
local Num = text:match("^اضف نقاط (%d+)$")
function Reply(extra, result, success)
DevAek:incrby(AEK..'Aek:GamesNumber'..msg.chat_id_..result.sender_user_id_,Num) 
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙تم اضافة "..Num..' نقطه', 1, 'md') 
end
tdcli_function ({ID = "GetMessage",chat_id_=msg.chat_id_,message_id_=tonumber(msg.reply_to_message_id_)},Reply, nil)
return false
end
if DevAek:get(AEK..'Aek:Lock:Clean'..msg.chat_id_) then if msg.content_.video_ or msg.content_.document_ or msg.content_.sticker_ or msg.content_.photo_ or msg.content_.animation_ then if msg.reply_to_message_id_ ~= 0 then DevAek:sadd(AEK.."Aek:cleaner"..msg.chat_id_, msg.id_) else DevAek:sadd(AEK.."Aek:cleaner"..msg.chat_id_, msg.id_) end end end
if Manager(msg) and msg.reply_to_message_id_ ~= 0 then
if text and text:match("^تثبيت$") and SourcelionCh(msg) then 
if DevAek:sismember(AEK.."Aek:Lock:Pinpin",msg.chat_id_) and not BasicConstructor(msg) then
Dev_Aek(msg.chat_id_,msg.id_, 1, "✫︙التثبيت والغاء واعادة التثبيت تم قفله من قبل المنشئين الاساسيين", 1, 'md')
return false  
end
tdcli_function ({ID = "PinChannelMessage",channel_id_ = msg.chat_id_:gsub("-100",""),message_id_ = msg.reply_to_message_id_,disable_notification_ = 1},function(arg,data) 
if data.ID == "Ok" then
DevAek:set(AEK..'Aek:PinnedMsg'..msg.chat_id_,msg.reply_to_message_id_)
local AEKTEAM = '✫︙اهلا عزيزي ↫ '..AekRank(msg)..' \n✫︙تم تثبيت الرساله بنجاح'
Aekmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, AEKTEAM, 14, string.len(msg.sender_user_id_))
return false  
end
if data.code_ == 6 then
Dev_Aek(msg.chat_id_, msg.id_, 1,'✫︙البوت ليس ادمن هنا !', 1, 'md')
return false  
end
if data.message_ == "CHAT_ADMIN_REQUIRED" then
Dev_Aek(msg.chat_id_, msg.id_, 1,'✫︙ليست لدي صلاحية التثبيت يرجى التحقق من الصلاحيات', 1, 'md')
return false  
end
end,nil)
end 
end

if Admin(msg) then
if text == "المميزين" and SourcelionCh(msg) then 
local List = DevAek:smembers(AEK..'Aek:VipMem:'..msg.chat_id_)
text = "✫︙قائمة المميزين ↫ ⤈ \n━───━ ✫ ━───━\n"
for k,v in pairs(List) do
local username = DevAek:get(AEK..'Save:UserName'..v)
if username then
text = text..""..k.."~ : [@"..username.."]\n"
else
text = text..""..k.."~ : `"..v.."`\n"
end end
if #List == 0 then 
text = "✫︙*لا يوجد مميزين*"
end
Dev_Aek(msg.chat_id_, msg.id_, 1, text, 1, "md")
end end 

if Manager(msg) then
if text == "الادمنيه" and SourcelionCh(msg) or text == "الادمنية" and SourcelionCh(msg) then 
local Aek =  'Aek:Admins:'..msg.chat_id_
local List = DevAek:smembers(AEK..Aek)
text = "✫︙قائمة الادمنيه ↫ ⤈ \n━───━ ✫ ━───━\n"
for k,v in pairs(List) do
local username = DevAek:get(AEK..'Save:UserName'..v)
if username then
text = text..""..k.."~ : [@"..username.."]\n"
else
text = text..""..k.."~ : `"..v.."`\n"
end end
if #List == 0 then
text = "✫︙*لا يوجد ادمنيه*"
end
Dev_Aek(msg.chat_id_, msg.id_, 1, text, 1, "md")
end end
 
if Constructor(msg) then
if text == "المدراء" and SourcelionCh(msg) or text == "مدراء" and SourcelionCh(msg) then 
local List = DevAek:smembers(AEK..'Aek:Managers:'..msg.chat_id_)
text = "✫︙قائمة المدراء ↫ ⤈ \n━───━ ✫ ━───━\n"
for k,v in pairs(List) do
local username = DevAek:get(AEK..'Save:UserName'..v)
if username then
text = text..""..k.."~ : [@"..username.."]\n"
else
text = text..""..k.."~ : `"..v.."`\n"
end end
if #List == 0 then 
text = "✫︙*لا يوجد مدراء*"
end
Dev_Aek(msg.chat_id_, msg.id_, 1, text, 1, "md")
end
 if text == "المنظفين" and SourcelionCh(msg) then 
local List = DevAek:smembers(AEK..'Aek:Cleaner:'..msg.chat_id_)
text = "✫︙قائمة المنظفين ↫ ⤈ \n━───━ ✫ ━───━\n"
for k,v in pairs(List) do
local username = DevAek:get(AEK..'Save:UserName'..v)
if username then
text = text..""..k.."~ : [@"..username.."]\n"
else
text = text..""..k.."~ : `"..v.."`\n"
end end
if #List == 0 then 
text = "✫︙*لا يوجد منظفين*"
end
Dev_Aek(msg.chat_id_, msg.id_, 1, text, 1, "md")
end end 

if BasicConstructor(msg) then
if text == "المنشئين" and SourcelionCh(msg) then 
local List = DevAek:smembers(AEK..'Aek:Constructor:'..msg.chat_id_)
text = "✫︙قائمة المنشئين ↫ ⤈ \n━───━ ✫ ━───━\n"
for k,v in pairs(List) do
local username = DevAek:get(AEK..'Save:UserName'..v)
if username then
text = text..""..k.."~ : [@"..username.."]\n"
else
text = text..""..k.."~ : `"..v.."`\n"
end end
if #List == 0 then 
text = "✫︙*لا يوجد منشئين*"
end
Dev_Aek(msg.chat_id_, msg.id_, 1, text, 1, "md")
end end 

if AekConstructor(msg) then
if text == "المالكين" and SourcelionCh(msg) then 
local List = DevAek:smembers(AEK..'Aek:AekConstructor:'..msg.chat_id_)
text = "✫︙قائمة المالكين ↫ ⤈ \n━───━ ✫ ━───━\n"
for k,v in pairs(List) do
local username = DevAek:get(AEK..'Save:UserName'..v)
if username then
text = text..""..k.."~ : [@"..username.."]\n"
else
text = text..""..k.."~ : `"..v.."`\n"
end end
if #List == 0 then 
text = "✫︙*لا يوجد مالكين*"
end
Dev_Aek(msg.chat_id_, msg.id_, 1, text, 1, "md")
end 
if text == "المنشئين الاساسيين" and SourcelionCh(msg) or text == "منشئين اساسيين" and SourcelionCh(msg) or text == "المنشئين الاساسين" and SourcelionCh(msg) then 
local List = DevAek:smembers(AEK..'Aek:BasicConstructor:'..msg.chat_id_)
text = "✫︙قائمة المنشئين الاساسيين ↫ ⤈ \n━───━ ✫ ━───━\n"
for k,v in pairs(List) do
local username = DevAek:get(AEK..'Save:UserName'..v)
if username then
text = text..""..k.."~ : [@"..username.."]\n"
else
text = text..""..k.."~ : `"..v.."`\n"
end end
if #List == 0 then 
text = "✫︙*لا يوجد منشئين اساسيين*"
end
Dev_Aek(msg.chat_id_, msg.id_, 1, text, 1, "md")
end 
end 
if text ==("المنشئ") and SourcelionCh(msg) or text ==("المالك") and SourcelionCh(msg) then
tdcli_function ({ID = "GetChannelMembers",channel_id_ = msg.chat_id_:gsub("-100",""),filter_ = {ID = "ChannelMembersAdministrators"},offset_ = 0,limit_ = 100},function(arg,data) 
local admins = data.members_
for i=0 , #admins do
if data.members_[i].status_.ID == "ChatMemberStatusCreator" then
Manager_id = admins[i].user_id_
tdcli_function ({ID = "GetUser",user_id_ = Manager_id},function(arg,dp) 
if dp.first_name_ == false then
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙حساب المنشئ محذوف", 1, "md")
return false  
end
tdcli_function ({ID="GetUserProfilePhotos",user_id_=Manager_id,offset_=0,limit_=1},function(arg,getpro) 
if getpro.photos_[0] then
Text = "*✫︙Owner Name ↬ * ["..dp.first_name_.."](T.me/"..dp.username_..")\n*✫︙Owner User ↬* [@"..dp.username_.."]\n*✫︙Owner id ↬* ["..dp.id_.."](T.me/"..dp.username_..")"
keyboard = {} 
keyboard.inline_keyboard = {{{text=''..dp.first_name_..'',url="t.me/"..dp.username_ or HH_418}}}
local msg_id = msg.id_/2097152/0.5
https.request("https://api.telegram.org/bot"..TokenBot..'/sendPhoto?chat_id='..msg.chat_id_..'&caption='..URL.escape(Text)..'&photo='..getpro.photos_[0].sizes_[1].photo_.persistent_id_..'&reply_to_message_id='..msg_id..'&parse_mode=markdown&disable_web_page_preview=true&reply_markup='..JSON.encode(keyboard)) 
else
Dev_Aek(msg.chat_id_, msg.id_,Text,1, 'md')
end
end,nil)   
end,nil)   
end
end
end,nil)  
end

if Admin(msg) then
if text == "المكتومين" and SourcelionCh(msg) then 
local List = DevAek:smembers(AEK..'Aek:Muted:'..msg.chat_id_)
text = "✫︙قائمة المكتومين ↫ ⤈ \n━───━ ✫ ━───━\n"
for k,v in pairs(List) do
local username = DevAek:get(AEK..'Save:UserName'..v)
if username then
text = text..""..k.."~ : [@"..username.."]\n"
else
text = text..""..k.."~ : `"..v.."`\n"
end end
if #List == 0 then 
text = "✫︙*لا يوجد مكتومين*"
end
Dev_Aek(msg.chat_id_, msg.id_, 1, text, 1, "md")
end 

if text == "المقيدين" and SourcelionCh(msg) then 
local List = DevAek:smembers(AEK..'Aek:Tkeed:'..msg.chat_id_)
text = "✫︙قائمة المقيدين ↫ ⤈ \n━───━ ✫ ━───━\n"
for k,v in pairs(List) do
local username = DevAek:get(AEK..'Save:UserName'..v)
if username then
text = text..""..k.."~ : [@"..username.."]\n"
else
text = text..""..k.."~ : `"..v.."`\n"
end end
if #List == 0 then
text = "✫︙*لا يوجد مقيدين*"
end
Dev_Aek(msg.chat_id_, msg.id_, 1, text, 1, "md")
end 

if text == "المحظورين" and SourcelionCh(msg) or text == "المحضورين" and SourcelionCh(msg) then 
local List = DevAek:smembers(AEK..'Aek:Ban:'..msg.chat_id_)
text = "✫︙قائمة المحظورين ↫ ⤈ \n━───━ ✫ ━───━\n"
for k,v in pairs(List) do
local username = DevAek:get(AEK..'Save:UserName'..v)
if username then
text = text..""..k.."~ : [@"..username.."]\n"
else
text = text..""..k.."~ : `"..v.."`\n"
end end
if #List == 0 then 
text = "✫︙*لا يوجد محظورين*"
end
Dev_Aek(msg.chat_id_, msg.id_, 1, text, 1, "md")
end 
if text == "قائمه المنع" and SourcelionCh(msg) then
local List = DevAek:hkeys(AEK..'Aek:Filters:'..msg.chat_id_)
text = "✫︙قائمة المنع ↫ ⤈ \n━───━ ✫ ━───━\n"
for k, v in pairs(List) do
text = text..k..'~ ❨ '..v..' ❩\n'
end
if #List == 0 then
text = "✫︙لا توجد كلمات ممنوعه"
end
Dev_Aek(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
end 

if text == "المطايه" and SourcelionCh(msg) or text == "المطاية" and SourcelionCh(msg) then
local List = DevAek:smembers(AEK..'User:Donky:'..msg.chat_id_)
text = "✫︙قائمة مطاية المجموعه 😹💔 ↫ ⤈ \n━───━ ✫ ━───━\n"
for k,v in pairs(List) do
local username = DevAek:get(AEK..'Save:UserName'..v)
if username then
text = text..""..k.."~ : [@"..username.."]\n"
else
text = text..""..k.."~ : `"..v.."`\n"
end end
if #List == 0 then
text = "✫︙*لا يوجد مطايه كلها اوادم* 😹💔"
end
Dev_Aek(msg.chat_id_, msg.id_, 1, text, 1, "md")
end

if text == "المطورين الثانويين" and SecondSudo(msg) or text == "الثانويين" and SecondSudo(msg) then 
local List = DevAek:smembers(AEK..'Aek:SecondSudo:')
text = "✫︙قائمة المطورين الثانويين ↫ ⤈ \n━───━ ✫ ━───━\n"
for k,v in pairs(List) do
local username = DevAek:get(AEK..'Save:UserName'..v)
if username then
text = text..""..k.."~ : [@"..username.."]\n"
else
text = text..""..k.."~ : `"..v.."`\n"
end end
if #List == 0 then
text = "✫︙*عذرا لم يتم رفع اي مطورين ثانويين*"
end
Dev_Aek(msg.chat_id_, msg.id_, 1, text, 1, "md")
end 

if SudoBot(msg) then
if text == "قائمه العام" and ChCheck(msg) or text == "المحظورين عام" and ChCheck(msg) or text == "المكتومين عام" and ChCheck(msg) or text == "↫ قائمه العام ✫" and ChCheck(msg) then 
local BanAll = DevAek:smembers(AEK..'Aek:BanAll:')
local MuteAll = DevAek:smembers(AEK..'Aek:MuteAll:')
if #BanAll ~= 0 then 
text = "✫︙قائمة المحظورين عام ↫ ⤈ \n━───━ ✫ ━───━\n"
for k,v in pairs(BanAll) do
local username = DevAek:get(AEK..'Save:UserName'..v)
if username then
text = text..""..k.."~ : [@"..username.."]\n"
else
text = text..""..k.."~ : `"..v.."`\n"
end end
else
text = ""
end
if #MuteAll ~= 0 then 
text = text.."✫︙قائمة المكتومين عام ↫ ⤈ \n━───━ ✫ ━───━\n"
for k,v in pairs(MuteAll) do
local username = DevAek:get(AEK..'Save:UserName'..v)
if username then
text = text..""..k.."~ : [@"..username.."]\n"
else
text = text..""..k.."~ : `"..v.."`\n"
end end
else
text = text
end
if #BanAll ~= 0 or #MuteAll ~= 0 then 
text = text
else
text = "✫︙*لم يتم حظر او كتم اي عضو*"
end
Dev_Aek(msg.chat_id_, msg.id_, 1, text, 1, "md")
end 

if text == "المطورين" and ChCheck(msg) or text == "↫ المطورين ✫" and ChCheck(msg) then 
local List = DevAek:smembers(AEK..'Aek:SudoBot:')
text = "✫︙قائمة المطورين ↫ ⤈ \n━───━ ✫ ━───━\n"
for k,v in pairs(List) do
local sudouser = DevAek:get(AEK..'Aek:Sudos'..v) 
local username = DevAek:get(AEK..'Save:UserName'..v)
if username then
text = text..""..k.."~ : [@"..username.."] ↬ Gps : "..(sudouser or 0).."\n"
else
text = text..""..k.."~ : `"..v.."` ↬ Gps : "..(sudouser or 0).."\n"
end end
if #List == 0 then
text = "✫︙*عذرا لم يتم رفع اي مطورين*"
end
Dev_Aek(msg.chat_id_, msg.id_, 1, text, 1, "md")
end 

if text == "المدراء العامين" and ChCheck(msg) then 
local List = DevAek:smembers(AEK..'Aek:ManagerAll:')
text = "✫︙قائمة المدراء العامين ↫ ⤈ \n━───━ ✫ ━───━\n"
for k,v in pairs(List) do
local username = DevAek:get(AEK..'Save:UserName'..v)
if username then
text = text..""..k.."~ : [@"..username.."]\n"
else
text = text..""..k.."~ : `"..v.."`\n"
end end
if #List == 0 then 
text = "✫︙*لا يوجد مدراء عامين*"
end
Dev_Aek(msg.chat_id_, msg.id_, 1, text, 1, "md")
end

if text == "المميزين عام" and ChCheck(msg) or text == "المميزين العامين" and ChCheck(msg) then 
local List = DevAek:smembers(AEK..'Aek:VipAll:')
text = "✫︙قائمة المميزين العام ↫ ⤈ \n━───━ ✫ ━───━\n"
for k,v in pairs(List) do
local username = DevAek:get(AEK..'Save:UserName'..v)
if username then
text = text..""..k.."~ : [@"..username.."]\n"
else
text = text..""..k.."~ : `"..v.."`\n"
end end
if #List == 0 then 
text = "✫︙*لا يوجد مميزين عام*"
end
Dev_Aek(msg.chat_id_, msg.id_, 1, text, 1, "md")
end 
 
if text == "الادمنيه العامين" and ChCheck(msg) then 
local Aek =  'Aek:AdminAll:'
local List = DevAek:smembers(AEK..Aek)
text = "✫︙قائمة الادمنيه العامين ↫ ⤈ \n━───━ ✫ ━───━\n"
for k,v in pairs(List) do
local username = DevAek:get(AEK..'Save:UserName'..v)
if username then
text = text..""..k.."~ : [@"..username.."]\n"
else
text = text..""..k.."~ : `"..v.."`\n"
end end
if #List == 0 then
text = "✫︙*لا يوجد ادمنيه عامين*"
end
Dev_Aek(msg.chat_id_, msg.id_, 1, text, 1, "md")
end  

if text ==("رفع المنشئ") and SourcelionCh(msg) or text ==("رفع المالك") and SourcelionCh(msg) then 
tdcli_function ({ID = "GetChannelMembers",channel_id_ = msg.chat_id_:gsub("-100",""),filter_ = {ID = "ChannelMembersAdministrators"},offset_ = 0,limit_ = 100},function(arg,data) 
DevAek:del(AEK..'Aek:AekConstructor:'..msg.chat_id_)
local admins = data.members_
for i=0 , #admins do
if data.members_[i].status_.ID == "ChatMemberStatusCreator" then
Manager_id = admins[i].user_id_
end
end
tdcli_function ({ID = "GetUser",user_id_ = Manager_id},function(arg,dp) 
if dp.first_name_ == false then
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙حساب المنشئ محذوف", 1, "md")
return false  
end
local UserName = (dp.username_ or "HH_418")
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙تم رفع مالك المجموعه ↫ ["..dp.first_name_.."](T.me/"..UserName..")", 1, "md") 
DevAek:sadd(AEK.."Aek:AekConstructor:"..msg.chat_id_,dp.id_)
end,nil)   
end,nil)   
end
end 

if Manager(msg) then
if text == 'منع' and tonumber(msg.reply_to_message_id_) > 0 and SourcelionCh(msg) then 
function filter_by_reply(extra, result, success) 
if result.content_.sticker_ then
local idsticker = result.content_.sticker_.sticker_.persistent_id_
DevAek:sadd(AEK.."Aek:FilterSteckr"..msg.chat_id_,idsticker)
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙تم منع الملصق بنجاح لن يتم ارساله مجددا', 1, 'md')
return false
end
if result.content_.ID == "MessagePhoto" then
local photo = result.content_.photo_.id_
DevAek:sadd(AEK.."Aek:FilterPhoto"..msg.chat_id_,photo)
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙تم منع الصوره بنجاح لن يتم ارسالها مجددا', 1, 'md')
return false
end
if result.content_.animation_ then
local idanimation = result.content_.animation_.animation_.persistent_id_
DevAek:sadd(AEK.."Aek:FilterAnimation"..msg.chat_id_,idanimation)
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙تم منع المتحركه بنجاح لن يتم ارسالها مجددا', 1, 'md')
return false
end
end
getMessage(msg.chat_id_, msg.reply_to_message_id_,filter_by_reply) 
end

if text == 'الغاء منع' and tonumber(msg.reply_to_message_id_) > 0 and SourcelionCh(msg) then     
function unfilter_by_reply(extra, result, success) 
if result.content_.sticker_ then
local idsticker = result.content_.sticker_.sticker_.persistent_id_
DevAek:srem(AEK.."Aek:FilterSteckr"..msg.chat_id_,idsticker)
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙تم الغاء منع الملصق يمكنهم ارساله الان', 1, 'md')
return false
end
if result.content_.ID == "MessagePhoto" then
local photo = result.content_.photo_.id_
DevAek:srem(AEK.."Aek:FilterPhoto"..msg.chat_id_,photo)
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙تم الغاء منع الصوره يمكنهم ارسالها الان', 1, 'md')
return false
end
if result.content_.animation_.animation_ then
local idanimation = result.content_.animation_.animation_.persistent_id_
DevAek:srem(AEK.."Aek:FilterAnimation"..msg.chat_id_,idanimation)
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙تم الغاء منع المتحركه يمكنهم ارسالها الان', 1, 'md')
return false
end
end
getMessage(msg.chat_id_, msg.reply_to_message_id_,unfilter_by_reply) 
end
end

if text and (text == "تفعيل تحويل الصيغ" or text == "تفعيل التحويل") and Manager(msg) and SourcelionCh(msg) then
local AEKTEAM = '✫︙اهلا عزيزي ↫ '..AekRank(msg)..' \n✫︙تم تفعيل تحويل الصيغ'
Aekmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, AEKTEAM, 14, string.len(msg.sender_user_id_))
DevAek:del(AEK..'Aek:Thwel:Aek'..msg.chat_id_) 
end
if text and (text == "تعطيل تحويل الصيغ" or text == "تعطيل التحويل") and Manager(msg) and SourcelionCh(msg) then
local AEKTEAM = '✫︙اهلا عزيزي ↫ '..AekRank(msg)..' \n✫︙تم تعطيل تحويل الصيغ'
Aekmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, AEKTEAM, 14, string.len(msg.sender_user_id_))
DevAek:set(AEK..'Aek:Thwel:Aek'..msg.chat_id_,true)  
end
if text == 'تحويل' and not DevAek:get(AEK..'Aek:Thwel:Aek'..msg.chat_id_) then  
if tonumber(msg.reply_to_message_id_) > 0 then 
function ThwelByReply(extra, result, success)
if result.content_.photo_ then 
local Aek = json:decode(https.request('https://api.telegram.org/bot'.. TokenBot..'/getfile?file_id='..result.content_.photo_.sizes_[1].photo_.persistent_id_)) 
download_to_file('https://api.telegram.org/file/bot'..TokenBot..'/'..Aek.result.file_path,msg.sender_user_id_..'.png') 
sendSticker(msg.chat_id_, msg.id_, 0, 1,nil, './'..msg.sender_user_id_..'.png')
os.execute('rm -rf ./'..msg.sender_user_id_..'.png') 
end   
if result.content_.sticker_ then 
local Aek = json:decode(https.request('https://api.telegram.org/bot'.. TokenBot..'/getfile?file_id='..result.content_.sticker_.sticker_.persistent_id_)) 
download_to_file('https://api.telegram.org/file/bot'..TokenBot..'/'..Aek.result.file_path,msg.sender_user_id_..'.jpg') 
sendPhoto(msg.chat_id_, msg.id_, 0, 1,nil, './'..msg.sender_user_id_..'.jpg','✫︙تم تحويل الملصق الى صوره')     
os.execute('rm -rf ./'..msg.sender_user_id_..'.jpg') 
end
if result.content_.audio_ then 
local Aek = json:decode(https.request('https://api.telegram.org/bot'.. TokenBot..'/getfile?file_id='..result.content_.audio_.audio_.persistent_id_)) 
download_to_file('https://api.telegram.org/file/bot'..TokenBot..'/'..Aek.result.file_path,msg.sender_user_id_..'.ogg') 
sendVoice(msg.chat_id_, msg.id_, 0, 1,nil, './'..msg.sender_user_id_..'.ogg',"✫︙تم تحويل الـMp3 الى بصمه")
os.execute('rm -rf ./'..msg.sender_user_id_..'.ogg') 
end   
if result.content_.voice_ then 
local Aek = json:decode(https.request('https://api.telegram.org/bot'.. TokenBot..'/getfile?file_id='..result.content_.voice_.voice_.persistent_id_)) 
download_to_file('https://api.telegram.org/file/bot'..TokenBot..'/'..Aek.result.file_path,msg.sender_user_id_..'.mp3') 
sendAudio(msg.chat_id_, msg.id_, 0, 1,nil, './'..msg.sender_user_id_..'.mp3')  
os.execute('rm -rf ./'..msg.sender_user_id_..'.mp3') 
end
end
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),ThwelByReply) 
end
end

if text ==("كشف") and msg.reply_to_message_id_ ~= 0 and SourcelionCh(msg) or text ==("ايدي") and msg.reply_to_message_id_ ~= 0 and SourcelionCh(msg) then 
function id_by_reply(extra, result, success) 
tdcli_function ({ID = "GetUser",user_id_ = result.sender_user_id_},function(arg,data) 
local user_msgs = DevAek:get(AEK..'Aek:UsersMsgs'..msg.chat_id_..':'..data.id_) or 0
local user_nkt = tonumber(DevAek:get(AEK..'Aek:GamesNumber'..msg.chat_id_..data.id_) or 0)
if DevAek:sismember(AEK..'Aek:BanAll:',result.sender_user_id_) then
Tkeed = 'محظور عام'
elseif DevAek:sismember(AEK..'Aek:MuteAll:',result.sender_user_id_) then
Tkeed = 'مكتوم عام'
elseif DevAek:sismember(AEK..'Aek:Ban:'..msg.chat_id_,result.sender_user_id_) then
Tkeed = 'محظور'
elseif DevAek:sismember(AEK..'Aek:Muted:'..msg.chat_id_,result.sender_user_id_) then
Tkeed = 'مكتوم'
elseif DevAek:sismember(AEK..'Aek:Tkeed:'..msg.chat_id_,result.sender_user_id_) then
Tkeed = 'مقيد'
else
Tkeed = false
end
if Tkeed ~= false then
Tked = '\n✫︙القيود ↫ '..Tkeed
else 
Tked = '' 
end
if DevAek:sismember(AEK..'Aek:SudoBot:',result.sender_user_id_) and SudoBot(msg) then
sudobot = '\n✫︙عدد الكروبات ↫ '..(DevAek:get(AEK..'Aek:Sudos'..result.sender_user_id_) or 0)..'' 
else 
sudobot = '' 
end
if GetCustomTitle(result.sender_user_id_,msg.chat_id_) ~= false then
CustomTitle = '\n✫︙لقبه ↫ '..GetCustomTitle(result.sender_user_id_,msg.chat_id_)
else 
CustomTitle = '' 
end
if data.first_name_ == false then 
Dev_Aek(msg.chat_id_, msg.id_, 1,'✫︙الحساب محذوف', 1, 'md')
return false  end
if data.username_ == false then
Text = '✫︙اسمه ↫ ['..data.first_name_..'](tg://user?id='..result.sender_user_id_..')\n✫︙ايديه ↫ ❨ `'..result.sender_user_id_..'` ❩\n✫︙رتبته ↫ '..IdRank(result.sender_user_id_, msg.chat_id_)..''..sudobot..'\n✫︙رسائله ↫ ❨ '..user_msgs..' ❩\n✫︙تفاعله ↫ '..formsgs(user_msgs)..''..CustomTitle..'\n✫︙نقاطه ↫ ❨ '..user_nkt..' ❩'..Tked
SendText(msg.chat_id_,Text,msg.id_/2097152/0.5,'md')
else
Dev_Aek(msg.chat_id_, msg.id_, 1,'✫︙معرفه ↫ [@'..data.username_..']\n✫︙ايديه ↫ ❨ `'..result.sender_user_id_..'` ❩\n✫︙رتبته ↫ '..IdRank(result.sender_user_id_, msg.chat_id_)..''..sudobot..'\n✫︙رسائله ↫ ❨ '..user_msgs..' ❩\n✫︙تفاعله ↫ '..formsgs(user_msgs)..''..CustomTitle..'\n✫︙نقاطه ↫ ❨ '..user_nkt..' ❩'..Tked, 1, 'md')
end
end,nil)
end 
getMessage(msg.chat_id_, msg.reply_to_message_id_,id_by_reply) 
end
if text and text:match('^كشف @(.*)') and SourcelionCh(msg) or text and text:match('^ايدي @(.*)') and SourcelionCh(msg) then 
local username = text:match('^كشف @(.*)') or text:match('^ايدي @(.*)')
tdcli_function ({ID = "SearchPublicChat",username_ = username},function(extra, res, success) 
if res and res.message_ and res.message_ == "USERNAME_NOT_OCCUPIED" then 
Dev_Aek(msg.chat_id_, msg.id_, 1,'✫︙*المعرف غير صحيح*', 1, 'md')
return false  end
if res.type_.ID == "ChannelChatInfo" then 
if res.type_.channel_.is_supergroup_ == false then
local ch = 'قناة'
local chn = '✫︙نوع الحساب ↫ ❨ '..ch..' ❩\n✫︙الايدي ↫ ❨ `'..res.id_..'` ❩\n✫︙المعرف ↫ ❨ [@'..username..'] ❩\n✫︙الاسم ↫ ❨ ['..res.title_..'] ❩'
Dev_Aek(msg.chat_id_, msg.id_, 1,chn, 1, 'md')
else
local gr = 'مجموعه'
local grr = '✫︙نوع الحساب ↫ ❨ '..gr..' ❩\n✫︙الايدي ↫ ❨ '..res.id_..' ❩\n✫︙المعرف ↫ ❨ [@'..username..'] ❩\n✫︙الاسم ↫ ❨ ['..res.title_..'] ❩'
Dev_Aek(msg.chat_id_, msg.id_, 1,grr, 1, 'md')
end
return false  end
if res.id_ then  
tdcli_function ({ID = "GetUser",user_id_ = res.id_},function(arg,data) 
local user_msgs = DevAek:get(AEK..'Aek:UsersMsgs'..msg.chat_id_..':'..res.id_) or 0
local user_nkt = tonumber(DevAek:get(AEK..'Aek:GamesNumber'..msg.chat_id_..res.id_) or 0)
if DevAek:sismember(AEK..'Aek:BanAll:',res.id_) then
Tkeed = 'محظور عام'
elseif DevAek:sismember(AEK..'Aek:MuteAll:',res.id_) then
Tkeed = 'مكتوم عام'
elseif DevAek:sismember(AEK..'Aek:Ban:'..msg.chat_id_,res.id_) then
Tkeed = 'محظور'
elseif DevAek:sismember(AEK..'Aek:Muted:'..msg.chat_id_,res.id_) then
Tkeed = 'مكتوم'
elseif DevAek:sismember(AEK..'Aek:Tkeed:'..msg.chat_id_,res.id_) then
Tkeed = 'مقيد'
else
Tkeed = false
end
if Tkeed ~= false then
Tked = '\n✫︙القيود ↫ '..Tkeed
else 
Tked = '' 
end
if DevAek:sismember(AEK..'Aek:SudoBot:',res.id_) and SudoBot(msg) then
sudobot = '\n✫︙عدد الكروبات ↫ '..(DevAek:get(AEK..'Aek:Sudos'..res.id_) or 0)..'' 
else 
sudobot = '' 
end
if GetCustomTitle(res.id_,msg.chat_id_) ~= false then
CustomTitle = '\n✫︙لقبه ↫ '..GetCustomTitle(res.id_,msg.chat_id_)
else 
CustomTitle = '' 
end
if data.first_name_ == false then
Dev_Aek(msg.chat_id_, msg.id_, 1,'✫︙الحساب محذوف', 1, 'md')
return false  end
Dev_Aek(msg.chat_id_, msg.id_, 1,'✫︙معرفه ↫ [@'..data.username_..']\n✫︙ايديه ↫ ❨ `'..res.id_..'` ❩\n✫︙رتبته ↫ '..IdRank(res.id_, msg.chat_id_)..''..sudobot..'\n✫︙رسائله ↫ ❨ '..user_msgs..' ❩\n✫︙تفاعله ↫ '..formsgs(user_msgs)..''..CustomTitle..'\n✫︙نقاطه ↫ ❨ '..user_nkt..' ❩'..Tked, 1, 'md')
end,nil)
end 
end,nil)
return false 
end
if text and text:match('كشف (%d+)') and SourcelionCh(msg) or text and text:match('ايدي (%d+)') and SourcelionCh(msg) then 
local iduser = text:match('كشف (%d+)') or text:match('ايدي (%d+)')  
tdcli_function ({ID = "GetUser",user_id_ = iduser},function(arg,data) 
if data.message_ == "User not found" then
Dev_Aek(msg.chat_id_, msg.id_, 1,'✫︙لم يتم التعرف على الحساب', 1, 'md')
return false  
end
local user_msgs = DevAek:get(AEK..'Aek:UsersMsgs'..msg.chat_id_..':'..iduser) or 0
local user_nkt = tonumber(DevAek:get(AEK..'Aek:GamesNumber'..msg.chat_id_..iduser) or 0)
if DevAek:sismember(AEK..'Aek:BanAll:',iduser) then
Tkeed = 'محظور عام'
elseif DevAek:sismember(AEK..'Aek:MuteAll:',iduser) then
Tkeed = 'مكتوم عام'
elseif DevAek:sismember(AEK..'Aek:Ban:'..msg.chat_id_,iduser) then
Tkeed = 'محظور'
elseif DevAek:sismember(AEK..'Aek:Muted:'..msg.chat_id_,iduser) then
Tkeed = 'مكتوم'
elseif DevAek:sismember(AEK..'Aek:Tkeed:'..msg.chat_id_,iduser) then
Tkeed = 'مقيد'
else
Tkeed = false
end
if Tkeed ~= false then
Tked = '\n✫︙القيود ↫ '..Tkeed
else 
Tked = '' 
end
if DevAek:sismember(AEK..'Aek:SudoBot:',iduser) and SudoBot(msg) then
sudobot = '\n✫︙عدد الكروبات ↫ '..(DevAek:get(AEK..'Aek:Sudos'..iduser) or 0)..'' 
else 
sudobot = '' 
end
if GetCustomTitle(iduser,msg.chat_id_) ~= false then
CustomTitle = '\n✫︙لقبه ↫ '..GetCustomTitle(iduser,msg.chat_id_)
else 
CustomTitle = '' 
end
if data.first_name_ == false then
Dev_Aek(msg.chat_id_, msg.id_, 1,'✫︙الحساب محذوف', 1, 'md')
return false  end
if data.username_ == false then
Text = '✫︙اسمه ↫ ['..data.first_name_..'](tg://user?id='..result.sender_user_id_..')\n✫︙ايديه ↫ ❨ `'..result.sender_user_id_..'` ❩\n✫︙رتبته ↫ '..IdRank(result.sender_user_id_, msg.chat_id_)..''..sudobot..'\n✫︙رسائله ↫ ❨ '..user_msgs..' ❩\n✫︙تفاعله ↫ '..formsgs(user_msgs)..''..CustomTitle..'\n✫︙نقاطه ↫ ❨ '..user_nkt..' ❩'..Tked
SendText(msg.chat_id_,Text,msg.id_/2097152/0.5,'md')
else
Dev_Aek(msg.chat_id_, msg.id_, 1,'✫︙معرفه ↫ [@'..data.username_..']\n✫︙ايديه ↫ ❨ `'..iduser..'` ❩\n✫︙رتبته ↫ '..IdRank(data.id_, msg.chat_id_)..''..sudobot..'\n✫︙رسائله ↫ ❨ '..user_msgs..' ❩\n✫︙تفاعله ↫ '..formsgs(user_msgs)..''..CustomTitle..'\n✫︙نقاطه ↫ ❨ '..user_nkt..' ❩'..Tked, 1, 'md')
end
end,nil)
return false 
end 

if text == 'كشف القيود' and tonumber(msg.reply_to_message_id_) > 0 and Admin(msg) and SourcelionCh(msg) then 
function kshf_by_reply(extra, result, success)
if DevAek:sismember(AEK..'Aek:Muted:'..msg.chat_id_,result.sender_user_id_) then muted = 'مكتوم' else muted = 'غير مكتوم' end
if DevAek:sismember(AEK..'Aek:Ban:'..msg.chat_id_,result.sender_user_id_) then banned = 'محظور' else banned = 'غير محظور' end
if DevAek:sismember(AEK..'Aek:BanAll:',result.sender_user_id_) then banall = 'محظور عام' else banall = 'غير محظور عام' end
if DevAek:sismember(AEK..'Aek:MuteAll:',result.sender_user_id_) then muteall = 'مكتوم عام' else muteall = 'غير مكتوم عام' end
if DevAek:sismember(AEK..'Aek:Tkeed:',result.sender_user_id_) then tkeed = 'مقيد' else tkeed = 'غير مقيد' end
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙الحظر العام ↫ '..banall..'\n✫︙الكتم العام ↫ '..muteall..'\n✫︙الحظر ↫ '..banned..'\n✫︙الكتم ↫ '..muted..'\n✫︙التقيد ↫ '..tkeed..'', 1, 'md')  
end
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),kshf_by_reply) 
end
if text and text:match('^كشف القيود @(.*)') and Admin(msg) and SourcelionCh(msg) then 
local username = text:match('^كشف القيود @(.*)') 
function kshf_by_username(extra, result, success)
if result.id_ then
if DevAek:sismember(AEK..'Aek:Muted:'..msg.chat_id_,result.id_) then muted = 'مكتوم' else muted = 'غير مكتوم' end
if DevAek:sismember(AEK..'Aek:Ban:'..msg.chat_id_,result.id_) then banned = 'محظور' else banned = 'غير محظور' end
if DevAek:sismember(AEK..'Aek:BanAll:',result.id_) then banall = 'محظور عام' else banall = 'غير محظور عام' end
if DevAek:sismember(AEK..'Aek:MuteAll:',result.id_) then muteall = 'مكتوم عام' else muteall = 'غير مكتوم عام' end
if DevAek:sismember(AEK..'Aek:Tkeed:',result.id_) then tkeed = 'مقيد' else tkeed = 'غير مقيد' end
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙الحظر العام ↫ '..banall..'\n✫︙الكتم العام ↫ '..muteall..'\n✫︙الحظر ↫ '..banned..'\n✫︙الكتم ↫ '..muted..'\n✫︙التقيد ↫ '..tkeed..'', 1, 'md')  
else
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙*المعرف غير صحيح*', 1, 'md')  
end
end
resolve_username(username,kshf_by_username) 
end
if text == 'رفع القيود' and tonumber(msg.reply_to_message_id_) > 0 and Admin(msg) and SourcelionCh(msg) then 
function unbanreply(extra, result, success) 
if tonumber(result.sender_user_id_) == tonumber(AEK) then  
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙انا البوت وليس لدي قيود', 1, 'md')  
return false  
end 
ReplyStatus(msg,result.sender_user_id_,"Reply","✫︙تم رفع قيوده")  
HTTPS.request("https://api.telegram.org/bot" .. TokenBot .. "/restrictChatMember?chat_id=" ..msg.chat_id_.. "&user_id=" ..result.sender_user_id_.. "&can_send_messages=True&can_send_media_messages=True&can_send_other_messages=True&can_add_web_page_previews=True")  
DevAek:srem(AEK..'Aek:Tkeed:'..msg.chat_id_,result.sender_user_id_) DevAek:srem(AEK..'Aek:Ban:'..msg.chat_id_,result.sender_user_id_) DevAek:srem(AEK..'Aek:Muted:'..msg.chat_id_,result.sender_user_id_)   
end
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),unbanreply) 
end
if text and text:match('^رفع القيود (%d+)') and Admin(msg) and SourcelionCh(msg) then 
local user = text:match('رفع القيود (%d+)') 
if tonumber(user) == tonumber(AEK) then  
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙انا البوت وليس لدي قيود', 1, 'md')  
return false  
end 
tdcli_function ({ID = "GetUser",user_id_ = user},function(arg,data) 
if data and data.code_ and data.code_ == 6 then
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙لم استطع استخراج المعلومات', 1, 'md') 
return false  
end
ReplyStatus(msg,user,"Reply","✫︙تم رفع قيوده")  
HTTPS.request("https://api.telegram.org/bot" .. TokenBot .. "/restrictChatMember?chat_id=" ..msg.chat_id_.. "&user_id=" ..user.. "&can_send_messages=True&can_send_media_messages=True&can_send_other_messages=True&can_add_web_page_previews=True")  
DevAek:srem(AEK..'Aek:Tkeed:'..msg.chat_id_,user) DevAek:srem(AEK..'Aek:Ban:'..msg.chat_id_,user) DevAek:srem(AEK..'Aek:Muted:'..msg.chat_id_,user)   
end,nil)  
end
if text and text:match('^رفع القيود @(.*)') and Admin(msg) and SourcelionCh(msg) then  
local username = text:match('رفع القيود @(.*)')  
function unbanusername(extra,result,success)  
if result and result.message_ and result.message_ == "USERNAME_NOT_OCCUPIED" then 
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙*المعرف غير صحيح*', 1, 'md')  
return false  
end
if result and result.type_ and result.type_.channel_ and result.type_.channel_.ID == "Channel" then
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙هذا معرف قناة وليس معرف حساب', 1, 'md') 
return false  
end
if tonumber(result.id_) == tonumber(AEK) then  
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙انا البوت وليس لدي قيود', 1, 'md')  
return false  
end 
tdcli_function ({ID = "GetUser",user_id_ = result.id_},function(arg,data) 
if data and data.code_ and data.code_ == 6 then
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙لم استطع استخراج المعلومات', 1, 'md') 
return false  
end
ReplyStatus(msg,result.id_,"Reply","✫︙تم رفع قيوده")  
HTTPS.request("https://api.telegram.org/bot" .. TokenBot .. "/restrictChatMember?chat_id=" ..msg.chat_id_.. "&user_id=" ..result.id_.. "&can_send_messages=True&can_send_media_messages=True&can_send_other_messages=True&can_add_web_page_previews=True")  
DevAek:srem(AEK..'Aek:Tkeed:'..msg.chat_id_,result.id_) DevAek:srem(AEK..'Aek:Ban:'..msg.chat_id_,result.id_) DevAek:srem(AEK..'Aek:Muted:'..msg.chat_id_,result.id_)   
end,nil)   
end  
resolve_username(username,unbanusername) 
end 

if Manager(msg) then
if text and text:match("^تغيير الايدي$") and SourcelionCh(msg) or text and text:match("^تغير الايدي$") and SourcelionCh(msg) then 
local List = {
[[
゠𝚄𝚂𝙴𝚁 𖨈 #username 𖥲 .
゠𝙼𝚂𝙶 𖨈 #msgs 𖥲 .
゠𝚂𝚃𝙰 𖨈 #stast 𖥲 .
゠𝙸𝙳 𖨈 #id 𖥲 .
]],
[[
➭- 𝒔𝒕𝒂𓂅 #stast 𓍯. 💕
➮- 𝒖𝒔𝒆𝒓𓂅 #username 𓍯. ??
➭- 𝒎𝒔𝒈𝒆𓂅 #msgs 𓍯. 💕
➭- 𝒊𝒅 𓂅 #id 𓍯. 💕
]],
[[
⚕ 𓆰 𝑾𝒆𝒍𝒄𝒐𝒎𝒆 𝑻𝒐 𝑮𝒓𝒐𝒖𝒑 ★
• 🖤 | 𝑼𝑬𝑺 : #username ‌‌‏⚚
• 🖤 | 𝑺𝑻𝑨 : #stast 🧙🏻‍♂️ ☥
• 🖤 | 𝑰𝑫 : #id ‌‌‏✫
• 🖤 | 𝑴𝑺𝑮 : #msgs 𓆊
]],
[[
┌ 𝐔𝐒𝐄𝐑 𖤱 #username 𖦴 .
├ 𝐌𝐒𝐆 𖤱 #msgs 𖦴 .
├ 𝐒𝐓𝐀 𖤱 #stast 𖦴 .
└ 𝐈𝐃 ?? #id 𖦴 .
]],
[[
𓄼🇮🇶 𝑼𝒔𝒆𝒓𝑵𝒂𝒎𝒆 : #username 
𓄼🇮🇶 𝑺𝒕𝒂𝒔𝒕 : #stast 
𓄼🇮🇶 𝒊𝒅 : #id 
𓄼🇮🇶 𝑮𝒂𝒎𝒆𝑺 : #game 
𓄼🇮🇶 𝑴𝒔𝒈𝒔 : #msgs
]],
[[
➞: 𝒔𝒕𝒂𓂅 #stast 𓍯➸💞.
➞: 𝒖𝒔𝒆𝒓𓂅 #username 𓍯➸💞.
➞: 𝒎𝒔𝒈??𓂅 #msgs 𓍯➸💞.
➞: 𝒊𝒅 𓂅 #id 𓍯➸💞.
]],
[[
☆•𝐮𝐬𝐞𝐫 : #username 𖣬  
☆•𝐦𝐬𝐠  : #msgs 𖣬 
☆•𝐬𝐭𝐚 : #stast 𖣬 
☆•𝐢𝐝  : #id 𖣬
]],
[[
- 𓏬 𝐔𝐬𝐄𝐫 : #username 𓂅 .
- 𓏬 𝐌𝐬𝐆  : #msgs 𓂅 .
- 𓏬 𝐒𝐭𝐀 : #stast 𓂅 .
- 𓏬 𝐈𝐃 : #id 𓂅 .
]],
[[
.𖣂 𝙪𝙨𝙚𝙧𝙣𝙖𝙢𝙚 , #username  
.𖣂 𝙨𝙩𝙖𝙨𝙩 , #stast  
.𖣂 𝙡𝘿 , #id  
.𖣂 𝙂𝙖𝙢𝙨 , #game 
.𖣂 𝙢𝙨𝙂𝙨 , #msgs
]],
[[
✫︙????𝐄𝐑 ↬ #username 
✫︙𝐈𝐃 ↬ #id
✫︙𝐒𝐓𝐀𝐒𝐓 ↬ #stast
✫︙𝐀𝐔𝐓𝐎 ↬ #cont 
✫︙𝐌𝐀𝐒𝐆 ↬ #msgs
✫︙𝐆𝐀𝐌𝐄 ↬ #game
]],
[[
ᯓ 𝗨𝗦𝗘𝗥𝗡𝗮𝗺𝗘 . #username 🇺🇸 ꙰
ᯓ 𝗦𝗧𝗮𝗦𝗧 . #stast 🇺🇸 ꙰
ᯓ 𝗜𝗗 . #id 🇺🇸 ꙰
ᯓ 𝗚𝗮𝗺𝗘𝗦 . #game 🇺🇸 ꙰
ᯓ 𝗺𝗦𝗚𝗦 . #msgs 🇺🇸 ꙰
]],
[[
- ᴜѕᴇʀɴᴀᴍᴇ ➥• #username .
- ᴍѕɢѕ ➥• #msgs .
- ѕᴛᴀᴛѕ ➥• #stast .
- ʏᴏᴜʀ ɪᴅ ➥• #id  .
- ᴇᴅɪᴛ ᴍsɢ ➥• #edit .
- ᴅᴇᴛᴀɪʟs ➥• #auto . 
- ɢᴀᴍᴇ ➥• #game .
]]}
local Text_Rand = List[math.random(#List)]
DevAek:set(AEK.."Aek:GpIds:Text"..msg.chat_id_,Text_Rand)
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم تغير كليشة الايدي")  
end

if SecondSudo(msg) then
if text and text:match("^تعيين الايدي العام$") or text and text:match("^تعين الايدي العام$") or text and text:match("^تعيين كليشة الايدي$") then
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙رجائا اتبع التعليمات للتعيين \n✫︙لطبع كليشة الايدي ارسل كليشه تحتوي على النصوص التي باللغه الانجليزيه ادناه ↫ ⤈\n━───━ ✫ ━───━\n `#username` ↬ لطبع المعرف\n `#id` ↬ لطبع الايدي \n `#photos` ↬ لطبع عدد الصور \n `#stast` ↬ لطبع الرتب \n `#msgs` ↬ لطبع عدد الرسائل \n `#msgday` ↬ لطبع الرسائل اليوميه \n `#CustomTitle` ↬ لطبع اللقب \n `#bio` ↬ لطبع البايو \n `#auto` ↬ لطبع التفاعل \n `#game` ↬ لطبع عدد النقاط \n `#cont` ↬ لطبع عدد الجهات \n `#edit` ↬ لطبع عدد السحكات \n `#Description` ↬ لطبع تعليق الصور\n━───━ ✫ ━───━', 1, 'md')
DevAek:set("AEK:New:id:"..AEK..msg.sender_user_id_,'AEKTEAM')
return "AEKTEAM"
end
if text and DevAek:get("AEK:New:id:"..AEK..msg.sender_user_id_) then 
if text == 'الغاء' then   
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙تم الغاء حفظ كليشة الايدي', 1, 'md')
DevAek:del("AEK:New:id:"..AEK..msg.sender_user_id_)
return false
end
DevAek:del("AEK:New:id:"..AEK..msg.sender_user_id_)
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙تم حفظ كليشة الايدي العامه', 1, 'md')
DevAek:set(AEK.."Aek:AllIds:Text",text)
return false
end
if text and text:match("^حذف الايدي العام$") or text and text:match("^مسح الايدي العام$") or text and text:match("^حذف كليشة الايدي$") then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم حذف كليشة الايدي العامه")  
DevAek:del(AEK.."Aek:AllIds:Text")
end
end

if text and text:match("^تعيين الايدي$") and SourcelionCh(msg) or text and text:match("^تعين الايدي$") and SourcelionCh(msg) then
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙رجائا اتبع التعليمات للتعيين \n✫︙لطبع كليشة الايدي ارسل كليشه تحتوي على النصوص التي باللغه الانجليزيه ادناه ↫ ⤈\n━───━ ✫ ━───━\n `#username` ↬ لطبع المعرف\n `#id` ↬ لطبع الايدي \n `#photos` ↬ لطبع عدد الصور \n `#stast` ↬ لطبع الرتب \n `#msgs` ↬ لطبع عدد الرسائل \n `#msgday` ↬ لطبع الرسائل اليوميه \n `#CustomTitle` ↬ لطبع اللقب \n `#bio` ↬ لطبع البايو \n `#auto` ↬ لطبع التفاعل \n `#game` ↬ لطبع عدد النقاط \n `#cont` ↬ لطبع عدد الجهات \n `#edit` ↬ لطبع عدد السحكات \n `#Description` ↬ لطبع تعليق الصور\n━───━ ✫ ━───━', 1, 'md')
DevAek:set("AEK:New:id:"..AEK..msg.chat_id_..msg.sender_user_id_,'AEKTEAM')
return "AEKTEAM"
end
if text and Manager(msg) and DevAek:get("AEK:New:id:"..AEK..msg.chat_id_..msg.sender_user_id_) then 
if text == 'الغاء' then   
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙تم الغاء حفظ كليشة الايدي', 1, 'md')
DevAek:del("AEK:New:id:"..AEK..msg.chat_id_..msg.sender_user_id_)
return false
end
DevAek:del("AEK:New:id:"..AEK..msg.chat_id_..msg.sender_user_id_)
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙تم حفظ الكليشه الجديده', 1, 'md')
DevAek:set(AEK.."Aek:GpIds:Text"..msg.chat_id_,text)
return false
end
if text and text:match("^حذف الايدي$") and SourcelionCh(msg) or text and text:match("^مسح الايدي$") and SourcelionCh(msg) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم حذف كليشة الايدي")  
DevAek:del(AEK.."Aek:GpIds:Text"..msg.chat_id_)
end
end

if msg.reply_to_message_id_ ~= 0 then
return ""
else
if text and (text:match("^ايدي$") or text:match("^id$") or text:match("^Id$")) and SourcelionCh(msg) then
function AEKTEAM(extra,Aekan,success)
if Aekan.username_ then username = '@'..Aekan.username_ else username = 'لا يوجد' end
if GetCustomTitle(msg.sender_user_id_,msg.chat_id_) ~= false then CustomTitle = GetCustomTitle(msg.sender_user_id_,msg.chat_id_) else CustomTitle = 'لا يوجد' end
local function getpro(extra, Aekan, success) 
local msgsday = DevAek:get(AEK..'Aek:UsersMsgs'..AEK..os.date('%d')..':'..msg.chat_id_..':'..msg.sender_user_id_) or 0
local edit_msg = DevAek:get(AEK..'Aek:EditMsg'..msg.chat_id_..msg.sender_user_id_) or 0
local user_msgs = DevAek:get(AEK..'Aek:UsersMsgs'..msg.chat_id_..':'..msg.sender_user_id_)
local user_nkt = tonumber(DevAek:get(AEK..'Aek:GamesNumber'..msg.chat_id_..msg.sender_user_id_) or 0)
local cont = (tonumber(DevAek:get(AEK..'Aek:ContactNumber'..msg.chat_id_..':'..msg.sender_user_id_)) or 0)
local msguser = tonumber(DevAek:get(AEK..'Aek:UsersMsgs'..msg.chat_id_..':'..msg.sender_user_id_))
local Texting = {"بـبكن حـلك","جمالك ماخذ الأول","فديت الصاك","شهل الجمال","خليني احبك","ببكن نكبل","شهل الگيمر","شاعل الدنيا بحلاتك","شهل العسل","فديت الحلو","منور اليوم فطيتك","شهل الصوره تخمبش","لا قيمه للقمر امام وجهك","اروح فـدوه للـحلـويـن","مو صوره ظيم بالنبي ،🤤💞","مقتنع بصورتك !؟ 😹🖤","ملاك وناسيك بكروبنه ،🤤💞","كشخه برب ،😉🤍","لزكت بيها دغيرها عاد ،😒😕","صورتك مامرتاحتلها ،🙄😶","حلغوم والله ،🥺💘","مو صوره غنبله براسها ٦٠ حظ ،😹🤍"}
local Description = Texting[math.random(#Texting)]
if Aekan.photos_[0] then
if not DevAek:get(AEK..'Aek:Lock:Id'..msg.chat_id_) then 
if not DevAek:get(AEK..'Aek:Lock:Id:Photo'..msg.chat_id_) then 
if DevAek:get(AEK.."Aek:AllIds:Text") then
newpicid = DevAek:get(AEK.."Aek:AllIds:Text")
newpicid = newpicid:gsub('#username',(username or 'لا يوجد'))
newpicid = newpicid:gsub('#CustomTitle',(CustomTitle or 'لا يوجد'))
newpicid = newpicid:gsub('#bio',(GetBio(msg.sender_user_id_) or 'لا يوجد'))
newpicid = newpicid:gsub('#photos',(Aekan.total_count_ or 'لا يوجد')) 
newpicid = newpicid:gsub('#game',(user_nkt or 'لا يوجد'))
newpicid = newpicid:gsub('#edit',(edit_msg or 'لا يوجد'))
newpicid = newpicid:gsub('#cont',(cont or 'لا يوجد'))
newpicid = newpicid:gsub('#msgs',(user_msgs or 'لا يوجد'))
newpicid = newpicid:gsub('#msgday',(msgsday or 'لا يوجد'))
newpicid = newpicid:gsub('#id',(msg.sender_user_id_ or 'لا يوجد'))
newpicid = newpicid:gsub('#auto',(formsgs(msguser) or 'لا يوجد'))
newpicid = newpicid:gsub('#stast',(IdRank(msg.sender_user_id_, msg.chat_id_) or 'لا يوجد'))
newpicid = newpicid:gsub('#Description',(Description or 'لا يوجد'))
else
newpicid = "✫︙"..Description.."\n✫︙معرفك ↫ ❨ "..username.." ❩\n✫︙ايديك ↫ ❨ "..msg.sender_user_id_.." ❩\n✫︙رتبتك ↫ "..IdRank(msg.sender_user_id_, msg.chat_id_).."\n✫︙رسائلك ↫ ❨ "..user_msgs.." ❩\n✫︙سحكاتك ↫ ❨ "..edit_msg.." ❩\n✫︙تفاعلك ↫ "..formsgs(msguser).."\n✫︙نقاطك ↫ ❨ "..user_nkt.." ❩\n━───━ ✫ ━───━\n"
end 
if not DevAek:get(AEK.."Aek:GpIds:Text"..msg.chat_id_) then 
sendPhoto(msg.chat_id_, msg.id_, 0, 1, nil, Aekan.photos_[0].sizes_[1].photo_.persistent_id_,newpicid,msg.id_,msg.id_.."")
else 
local new_id = DevAek:get(AEK.."Aek:GpIds:Text"..msg.chat_id_)
local new_id = new_id:gsub('#username',(username or 'لا يوجد'))
local new_id = new_id:gsub('#CustomTitle',(CustomTitle or 'لا يوجد'))
local new_id = new_id:gsub('#bio',(GetBio(msg.sender_user_id_) or 'لا يوجد'))
local new_id = new_id:gsub('#photos',(Aekan.total_count_ or '')) 
local new_id = new_id:gsub('#game',(user_nkt or 'لا يوجد'))
local new_id = new_id:gsub('#edit',(edit_msg or 'لا يوجد'))
local new_id = new_id:gsub('#cont',(cont or 'لا يوجد'))
local new_id = new_id:gsub('#msgs',(user_msgs or 'لا يوجد'))
local new_id = new_id:gsub('#msgday',(msgsday or 'لا يوجد'))
local new_id = new_id:gsub('#id',(msg.sender_user_id_ or 'لا يوجد'))
local new_id = new_id:gsub('#auto',(formsgs(msguser) or 'لا يوجد'))
local new_id = new_id:gsub('#stast',(IdRank(msg.sender_user_id_, msg.chat_id_) or 'لا يوجد'))
local new_id = new_id:gsub('#Description',(Description or 'لا يوجد'))
sendPhoto(msg.chat_id_, msg.id_, 0, 1, nil, Aekan.photos_[0].sizes_[1].photo_.persistent_id_,new_id,msg.id_,msg.id_.."")
end
else
if DevAek:get(AEK.."Aek:AllIds:Text") then
newallid = DevAek:get(AEK.."Aek:AllIds:Text")
newallid = newallid:gsub('#username',(username or 'لا يوجد'))
newallid = newallid:gsub('#CustomTitle',(CustomTitle or 'لا يوجد'))
newallid = newallid:gsub('#bio',(GetBio(msg.sender_user_id_) or 'لا يوجد'))
newallid = newallid:gsub('#photos',(Aekan.total_count_ or 'لا يوجد')) 
newallid = newallid:gsub('#game',(user_nkt or 'لا يوجد'))
newallid = newallid:gsub('#edit',(edit_msg or 'لا يوجد'))
newallid = newallid:gsub('#cont',(cont or 'لا يوجد'))
newallid = newallid:gsub('#msgs',(user_msgs or 'لا يوجد'))
newallid = newallid:gsub('#msgday',(msgsday or 'لا يوجد'))
newallid = newallid:gsub('#id',(msg.sender_user_id_ or 'لا يوجد'))
newallid = newallid:gsub('#auto',(formsgs(msguser) or 'لا يوجد'))
newallid = newallid:gsub('#stast',(IdRank(msg.sender_user_id_, msg.chat_id_) or 'لا يوجد'))
newallid = newallid:gsub('#Description',(Description or 'لا يوجد'))
else
newallid = "✫︙معرفك ↫ ❨ "..username.." ❩\n✫︙ايديك ↫ ❨ "..msg.sender_user_id_.." ❩\n✫︙رتبتك ↫ "..IdRank(msg.sender_user_id_, msg.chat_id_).."\n✫︙رسائلك ↫ ❨ "..user_msgs.." ❩\n✫︙سحكاتك ↫ ❨ "..edit_msg.." ❩\n✫︙تفاعلك ↫ "..formsgs(msguser).."\n✫︙نقاطك ↫ ❨ "..user_nkt.." ❩"
end 
if not DevAek:get(AEK.."Aek:GpIds:Text"..msg.chat_id_) then
Dev_Aek(msg.chat_id_, msg.id_, 1, newallid, 1, 'html')
else
local new_id = DevAek:get(AEK.."Aek:GpIds:Text"..msg.chat_id_)
local new_id = new_id:gsub('#username',(username or 'لا يوجد'))
local new_id = new_id:gsub('#CustomTitle',(CustomTitle or 'لا يوجد'))
local new_id = new_id:gsub('#bio',(GetBio(msg.sender_user_id_) or 'لا يوجد'))
local new_id = new_id:gsub('#photos',(Aekan.total_count_ or 'لا يوجد')) 
local new_id = new_id:gsub('#game',(user_nkt or 'لا يوجد'))
local new_id = new_id:gsub('#edit',(edit_msg or 'لا يوجد'))
local new_id = new_id:gsub('#cont',(cont or 'لا يوجد'))
local new_id = new_id:gsub('#msgs',(user_msgs or 'لا يوجد'))
local new_id = new_id:gsub('#msgday',(msgsday or 'لا يوجد'))
local new_id = new_id:gsub('#id',(msg.sender_user_id_ or 'لا يوجد'))
local new_id = new_id:gsub('#auto',(formsgs(msguser) or 'لا يوجد'))
local new_id = new_id:gsub('#stast',(IdRank(msg.sender_user_id_, msg.chat_id_) or 'لا يوجد'))
local new_id = new_id:gsub('#Description',(Description or 'لا يوجد'))
Dev_Aek(msg.chat_id_, msg.id_, 1, new_id, 1, 'html')  
end
end
else
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙عذرا الايدي معطل ', 1, 'md')
end
else
if DevAek:get(AEK.."Aek:AllIds:Text") then
notpicid = DevAek:get(AEK.."Aek:AllIds:Text")
notpicid = notpicid:gsub('#username',(username or 'لا يوجد'))
notpicid = notpicid:gsub('#CustomTitle',(CustomTitle or 'لا يوجد'))
notpicid = notpicid:gsub('#bio',(GetBio(msg.sender_user_id_) or 'لا يوجد'))
notpicid = notpicid:gsub('#photos',(Aekan.total_count_ or 'لا يوجد')) 
notpicid = notpicid:gsub('#game',(user_nkt or 'لا يوجد'))
notpicid = notpicid:gsub('#edit',(edit_msg or 'لا يوجد'))
notpicid = notpicid:gsub('#cont',(cont or 'لا يوجد'))
notpicid = notpicid:gsub('#msgs',(user_msgs or 'لا يوجد'))
notpicid = notpicid:gsub('#msgday',(msgsday or 'لا يوجد'))
notpicid = notpicid:gsub('#id',(msg.sender_user_id_ or 'لا يوجد'))
notpicid = notpicid:gsub('#auto',(formsgs(msguser) or 'لا يوجد'))
notpicid = notpicid:gsub('#stast',(IdRank(msg.sender_user_id_, msg.chat_id_) or 'لا يوجد'))
notpicid = notpicid:gsub('#Description',(Description or 'لا يوجد'))
else
notpicid = "✫︙لا استطيع عرض صورتك لانك قمت بحظر البوت او انك لاتمتلك صوره في بروفايلك\n━───━ ✫ ━───━\n✫︙معرفك ↫ ❨ "..username.." ❩\n✫︙ايديك ↫ ❨ "..msg.sender_user_id_.." ❩\n✫︙رتبتك ↫ "..IdRank(msg.sender_user_id_, msg.chat_id_).."\n✫︙رسائلك ↫ ❨ "..user_msgs.." ❩\n✫︙سحكاتك ↫ ❨ "..edit_msg.." ❩\n✫︙تفاعلك ↫ "..formsgs(msguser).."\n✫︙نقاطك ↫ ❨ "..user_nkt.." ❩\n━───━ ✫ ━───━\n"
end 
if not DevAek:get(AEK..'Aek:Lock:Id'..msg.chat_id_) then
if not DevAek:get(AEK..'Aek:Lock:Id:Photo'..msg.chat_id_) then
Dev_Aek(msg.chat_id_, msg.id_, 1, notpicid, 1, 'html')
else
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙معرفك ↫ ❨ "..username.." ❩\n✫︙ايديك ↫ ❨ "..msg.sender_user_id_.." ❩\n✫︙رتبتك ↫ "..IdRank(msg.sender_user_id_, msg.chat_id_).."\n✫︙رسائلك ↫ ❨ "..user_msgs.." ❩\n✫︙سحكاتك ↫ ❨ "..edit_msg.." ❩\n✫︙رسائلك ↫ ❨ "..user_msgs.." ❩\n✫︙تفاعلك ↫ "..formsgs(msguser).."\n✫︙نقاطك ↫ ❨ "..user_nkt.." ❩", 1, 'md')
end
else
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙عذرا الايدي معطل', 1, 'md')
end end end
tdcli_function ({ ID = "GetUserProfilePhotos", user_id_ = msg.sender_user_id_, offset_ = 0, limit_ = 1 }, getpro, nil)
end
getUser(msg.sender_user_id_, AEKTEAM)
end
end 

if ChatType == 'sp' or ChatType == 'gp'  then
if Admin(msg) then
if text and text:match("^قفل (.*)$") and SourcelionCh(msg) then
local LockText = {string.match(text, "^(قفل) (.*)$")}
if LockText[2] == "التعديل" then
if not DevAek:get(AEK..'Aek:Lock:EditMsgs'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم قفل التعديل")  
DevAek:set(AEK..'Aek:Lock:EditMsgs'..msg.chat_id_,true)
else
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙التعديل بالفعل مقفل في المجموعه', 1, 'md')
end
end
if LockText[2] == "التعديل الميديا" or LockText[2] == "تعديل الميديا" then
if not DevAek:get(AEK..'Aek:Lock:EditMsgs'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم قفل تعديل الميديا")  
DevAek:set(AEK..'Aek:Lock:EditMsgs'..msg.chat_id_,true)
else
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙تعديل الميديا بالفعل مقفل في المجموعه', 1, 'md')
end
end
if LockText[2] == "الفارسيه" then
if not DevAek:get(AEK..'Aek:Lock:Farsi'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم قفل الفارسيه")  
DevAek:set(AEK..'Aek:Lock:Farsi'..msg.chat_id_,true)
else
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙الفارسيه بالفعل مقفله في المجموعه', 1, 'md')
end
end
if LockText[2] == "الفارسيه بالتحذير" then
if not DevAek:get(AEK..'Aek:Lock:FarsiWarn'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم قفل الفارسيه بالتحذير")  
DevAek:set(AEK..'Aek:Lock:FarsiWarn'..msg.chat_id_,true)
else
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙الفارسيه بالتحذير بالفعل مقفله في المجموعه', 1, 'md')
end
end
if LockText[2] == "الفشار" then
if DevAek:get(AEK..'Aek:Lock:Fshar'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم قفل الفشار")  
DevAek:del(AEK..'Aek:Lock:Fshar'..msg.chat_id_)
else
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙الفشار بالفعل مقفل في المجموعه', 1, 'md')
end
end
if LockText[2] == "الطائفيه" then
if DevAek:get(AEK..'Aek:Lock:Taf'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم قفل الطائفيه")  
DevAek:del(AEK..'Aek:Lock:Taf'..msg.chat_id_)
else
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙الطائفيه بالفعل مقفله في المجموعه', 1, 'md')
end
end
if LockText[2] == "الكفر" then
if DevAek:get(AEK..'Aek:Lock:Kfr'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم قفل الكفر")  
DevAek:del(AEK..'Aek:Lock:Kfr'..msg.chat_id_)
else
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙الكفر بالفعل مقفل في المجموعه', 1, 'md')
end
end
if LockText[2] == "الفارسيه بالطرد" then
if not DevAek:get(AEK..'Aek:Lock:FarsiBan'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم قفل الفارسيه بالطرد")  
DevAek:set(AEK..'Aek:Lock:FarsiBan'..msg.chat_id_,true)
else
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙الفارسيه بالطرد بالفعل مقفله ', 1, 'md')
end
end
if LockText[2] == "البوتات" or LockText[2] == "البوتات بالحذف" then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم قفل البوتات بالحذف")  
DevAek:set(AEK.."Aek:Lock:Bots"..msg.chat_id_,"del")  
end
if LockText[2] == "البوتات بالطرد" then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم قفل البوتات بالطرد")  
DevAek:set(AEK.."Aek:Lock:Bots"..msg.chat_id_,"kick")  
end
if LockText[2] == "البوتات بالتقييد" or LockText[2] == "البوتات بالتقيد" then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم قفل البوتات بالتقيد")  
DevAek:set(AEK.."Aek:Lock:Bots"..msg.chat_id_,"ked")  
end
if LockText[2] == "التكرار" or LockText[2] == "التكرار بالحذف" then 
DevAek:hset(AEK.."Aek:Spam:Group:User"..msg.chat_id_ ,"Spam:User","del")  
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم قفل التكرار بالحذف")  
end
if LockText[2] == "التكرار بالطرد" then 
DevAek:hset(AEK.."Aek:Spam:Group:User"..msg.chat_id_ ,"Spam:User","kick")  
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم قفل التكرار بالطرد")  
end
if LockText[2] == "التكرار بالتقيد" or LockText[2] == "التكرار بالتقييد" then 
DevAek:hset(AEK.."Aek:Spam:Group:User"..msg.chat_id_ ,"Spam:User","keed")  
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم قفل التكرار بالتقيد")  
end
if LockText[2] == "التكرار بالكتم" then 
DevAek:hset(AEK.."Aek:Spam:Group:User"..msg.chat_id_ ,"Spam:User","mute")  
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم قفل التكرار بالكتم")  
end
if BasicConstructor(msg) then
if LockText[2] == "التثبيت" then
if not DevAek:get(AEK..'Aek:Lock:Pin'..msg.chat_id_) then
tdcli_function ({ ID = "GetChannelFull",  channel_id_ = msg.chat_id_:gsub("-100","") }, function(arg,data)  DevAek:set(AEK.."Aek:PinnedMsg"..msg.chat_id_,data.pinned_message_id_)  end,nil)
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم قفل التثبيت")  
DevAek:set(AEK..'Aek:Lock:Pin'..msg.chat_id_,true)
DevAek:sadd(AEK.."Aek:Lock:Pinpin",msg.chat_id_) 
else
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙التثبيت بالفعل مقفل في المجموعه', 1, 'md')
end end end
end
end
end

if Admin(msg) then
if text and (text:match("^ضع تكرار (%d+)$") or text:match("^وضع تكرار (%d+)$")) then   
local TextSpam = text:match("ضع تكرار (%d+)$") or text:match("وضع تكرار (%d+)$")
if tonumber(TextSpam) < 2 then
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙قم بتحديد عدد اكبر من 2 للتكرار', 1, 'md')
else
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙تم وضع عدد التكرار ↫ '..TextSpam, 1, 'md')
DevAek:hset(AEK.."Aek:Spam:Group:User"..msg.chat_id_ ,"Num:Spam" ,TextSpam) 
end
end
if text and (text:match("^ضع زمن التكرار (%d+)$") or text:match("^وضع زمن التكرار (%d+)$")) then  
local TextSpam = text:match("ضع زمن التكرار (%d+)$") or text:match("وضع زمن التكرار (%d+)$")
DevAek:hset(AEK.."Aek:Spam:Group:User"..msg.chat_id_ ,"Num:Spam:Time" ,TextSpam) 
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙تم وضع زمن التكرار ↫ '..TextSpam, 1, 'md')
end

if Manager(msg) then
if text and text == 'تفعيل الايدي بالصوره' and SourcelionCh(msg) then
if not DevAek:get(AEK..'Aek:Lock:Id:Photo'..msg.chat_id_) then
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙الايدي بالصوره بالتاكيد مفعل', 1, 'md')
else
local AEKTEAM = '✫︙اهلا عزيزي ↫ '..AekRank(msg)..' \n✫︙تم تفعيل الايدي بالصوره'
Aekmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, AEKTEAM, 14, string.len(msg.sender_user_id_))
DevAek:del(AEK..'Aek:Lock:Id:Photo'..msg.chat_id_)
end end
if text and text == 'تعطيل الايدي بالصوره' and SourcelionCh(msg) then
if DevAek:get(AEK..'Aek:Lock:Id:Photo'..msg.chat_id_) then
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙الايدي بالصوره بالتاكيد معطل', 1, 'md')
else
local AEKTEAM = '✫︙اهلا عزيزي ↫ '..AekRank(msg)..' \n✫︙تم تعطيل الايدي بالصوره'
Aekmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, AEKTEAM, 14, string.len(msg.sender_user_id_))
DevAek:set(AEK..'Aek:Lock:Id:Photo'..msg.chat_id_,true)
end end 

if text and text == 'تفعيل الايدي' and SourcelionCh(msg) then
if not DevAek:get(AEK..'Aek:Lock:Id'..msg.chat_id_) then
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙الايدي بالتاكيد مفعل ', 1, 'md')
else
local AEKTEAM = '✫︙اهلا عزيزي ↫ '..AekRank(msg)..' \n✫︙تم تفعيل الايدي بنجاح'
Aekmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, AEKTEAM, 14, string.len(msg.sender_user_id_))
DevAek:del(AEK..'Aek:Lock:Id'..msg.chat_id_)
end end 
if text and text == 'تعطيل الايدي' and SourcelionCh(msg) then
if DevAek:get(AEK..'Aek:Lock:Id'..msg.chat_id_) then
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙الايدي بالتاكيد معطل ', 1, 'md')
else
local AEKTEAM = '✫︙اهلا عزيزي ↫ '..AekRank(msg)..' \n✫︙تم تعطيل الايدي بنجاح'
Aekmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, AEKTEAM, 14, string.len(msg.sender_user_id_))
DevAek:set(AEK..'Aek:Lock:Id'..msg.chat_id_,true)
end end
end

if text == 'ضع رابط' or text == 'وضع رابط' or text == 'ضع الرابط' or text == 'وضع الرابط' then
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙ارسل رابط المجموعه او رابط قناة المجموعه', 1, 'md')
DevAek:setex(AEK.."Aek:Set:Groups:Links"..msg.chat_id_..""..msg.sender_user_id_,300,true) 
end
if text == 'انشاء رابط' or text == 'انشاء الرابط' then
local LinkGp = json:decode(https.request('https://api.telegram.org/bot'..TokenBot..'/exportChatInviteLink?chat_id='..msg.chat_id_))
if not DevAek:get(AEK.."Aek:Groups:Links"..msg.chat_id_)  then 
if LinkGp.ok == true then 
LinkGroup = LinkGp.result
DevAek:set(AEK.."Aek:Groups:Links"..msg.chat_id_,LinkGroup) 
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙تم انشاء رابط جديد ارسل ↫ الرابط', 1, 'md')
else
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙ليست لدي صلاحية دعوة المستخدمين عبر الرابط يرجى التحقق من الصلاحيات', 1, 'md')
end
else
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙ارسل رابط المجموعه او رابط قناة المجموعه', 1, 'md')
DevAek:setex(AEK.."Aek:Set:Groups:Links"..msg.chat_id_..""..msg.sender_user_id_,300,true) 
end
end
end

if Admin(msg) then
if text and text:match("^تفعيل الترحيب$") and SourcelionCh(msg) then
local AEKTEAM = '✫︙اهلا عزيزي ↫ '..AekRank(msg)..' \n✫︙تم تفعيل الترحيب بنجاح'
Aekmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, AEKTEAM, 14, string.len(msg.sender_user_id_))
DevAek:set(AEK.."Aek:Lock:Welcome"..msg.chat_id_,true)
end
if text and text:match("^تعطيل الترحيب$") and SourcelionCh(msg) then
local AEKTEAM = '✫︙اهلا عزيزي ↫ '..AekRank(msg)..' \n✫︙تم تعطيل الترحيب بنجاح'
Aekmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, AEKTEAM, 14, string.len(msg.sender_user_id_))
DevAek:del(AEK.."Aek:Lock:Welcome"..msg.chat_id_)
end
if DevAek:get(AEK..'Aek:setwelcome'..msg.chat_id_..':'..msg.sender_user_id_) then 
if text == 'الغاء' then 
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙تم الغاء حفظ كليشة الترحيب', 1, 'md')
DevAek:del(AEK..'Aek:setwelcome'..msg.chat_id_..':'..msg.sender_user_id_)
return false  
end 
DevAek:del(AEK..'Aek:setwelcome'..msg.chat_id_..':'..msg.sender_user_id_)
DevAek:set(AEK..'Aek:Groups:Welcomes'..msg.chat_id_,text)
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙تم حفظ كليشة الترحيب', 1, 'md')
return false   
end
if text and text:match("^ضع ترحيب$") and SourcelionCh(msg) or text and text:match("^وضع ترحيب$") and SourcelionCh(msg) or text and text:match("^اضف ترحيب$") and SourcelionCh(msg) then
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙ارسل لي الترحيب الان\n✫︙تستطيع اضافة مايلي ↫ ⤈\n✫︙دالة عرض الاسم ↫ firstname\n✫︙دالة عرض المعرف ↫ username', 1, 'md')
DevAek:set(AEK..'Aek:setwelcome'..msg.chat_id_..':'..msg.sender_user_id_,true)
end
if text and text:match("^حذف الترحيب$") and SourcelionCh(msg) or text and text:match("^حذف ترحيب$") and SourcelionCh(msg) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم حذف الترحيب")  
DevAek:del(AEK..'Aek:Groups:Welcomes'..msg.chat_id_)
end
if text and text:match("^جلب الترحيب$") and SourcelionCh(msg) or text and text:match("^جلب ترحيب$") and SourcelionCh(msg) or text and text:match("^الترحيب$") and SourcelionCh(msg) then
local wel = DevAek:get(AEK..'Aek:Groups:Welcomes'..msg.chat_id_)
if wel then
Dev_Aek(msg.chat_id_, msg.id_, 1, wel, 1, 'md')
else
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙لم يتم وضع الترحيب \n✫︙ارسل ↫ ضع ترحيب للحفظ ', 1, 'md')
end
end

if DevAek:get(AEK..'Aek:SetDescription'..msg.chat_id_..':'..msg.sender_user_id_) then  
if text == 'الغاء' then 
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙تم الغاء حفظ الوصف", 1, 'md')
DevAek:del(AEK..'Aek:SetDescription'..msg.chat_id_..':'..msg.sender_user_id_)
return false  
end 
DevAek:del(AEK..'Aek:SetDescription'..msg.chat_id_..':'..msg.sender_user_id_)
https.request('https://api.telegram.org/bot'..TokenBot..'/setChatDescription?chat_id='..msg.chat_id_..'&description='..text) 
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙تم تغيير وصف المجموعه', 1, 'md')
return false  
end 
if text and text:match("^ضع وصف$") and SourcelionCh(msg) or text and text:match("^وضع وصف$") and SourcelionCh(msg) then  
DevAek:set(AEK..'Aek:SetDescription'..msg.chat_id_..':'..msg.sender_user_id_,true)
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙ارسل لي الوصف الان', 1, 'md')
end

if text and text == "منع" and msg.reply_to_message_id_ == 0 and SourcelionCh(msg) then       
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙ارسل لي الكلمه الان", 1, 'md') 
DevAek:set(AEK.."Aek:SetFilters"..msg.sender_user_id_..msg.chat_id_,"add")  
return false  
end    
if DevAek:get(AEK.."Aek:SetFilters"..msg.sender_user_id_..msg.chat_id_) == "add" then
if text == 'الغاء' then 
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙تم الغاء امر المنع', 1, 'md')
DevAek:del(AEK.."Aek:SetFilters"..msg.sender_user_id_..msg.chat_id_)  
return false  
end   
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙تم منع الكلمه ↫ "..text, 1, 'html')
DevAek:del(AEK.."Aek:SetFilters"..msg.sender_user_id_..msg.chat_id_)  
DevAek:hset(AEK..'Aek:Filters:'..msg.chat_id_, text,'newword')
return false
end
if text and text == "الغاء منع" and msg.reply_to_message_id_ == 0 and SourcelionCh(msg) then       
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙ارسل لي الكلمه الان", 1, 'md') 
DevAek:set(AEK.."Aek:SetFilters"..msg.sender_user_id_..msg.chat_id_,"del")  
return false  
end    
if DevAek:get(AEK.."Aek:SetFilters"..msg.sender_user_id_..msg.chat_id_) == "del" then   
if text == 'الغاء' then 
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙تم الغاء امر الغاء المنع', 1, 'md')
DevAek:del(AEK.."Aek:SetFilters"..msg.sender_user_id_..msg.chat_id_)  
return false  
end   
if not DevAek:hget(AEK..'Aek:Filters:'..msg.chat_id_, text) then  
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙الكلمه ↫ "..text.." غير ممنوعه", 1, 'html')
DevAek:del(AEK.."Aek:SetFilters"..msg.sender_user_id_..msg.chat_id_)  
else
DevAek:hdel(AEK..'Aek:Filters:'..msg.chat_id_, text)
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙الكلمه ↫ "..text.." تم الغاء منعها", 1, 'html')
DevAek:del(AEK.."Aek:SetFilters"..msg.sender_user_id_..msg.chat_id_)  
end
return false
end

if SudoBot(msg) then
if text and text == "الاحصائيات" and ChCheck(msg) or text and text == "↫ الاحصائيات ✫" then
local gps = DevAek:scard(AEK.."Aek:Groups") local users = DevAek:scard(AEK.."Aek:Users") 
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙احصائيات البوت ↫ ⤈\n✫︙عدد المشتركين ↫ ❨ '..users..' ❩\n✫︙عدد المجموعات ↫ ❨ '..gps..' ❩', 1, 'md')
end
if text and text == "المشتركين" and ChCheck(msg) or text and text == "↫ المشتركين ✫" then
local users = DevAek:scard(AEK.."Aek:Users")
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙عدد المشتركين ↫ ❨ '..users..' ❩', 1, 'md')
end
if text and text == 'المجموعات' and ChCheck(msg) or text and text == '↫ المجموعات ✫' then
local gps = DevAek:scard(AEK.."Aek:Groups")
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙عدد المجموعات ↫ ❨ '..gps..' ❩', 1, 'md')
end
end

if text and text:match('^تنظيف (%d+)$') and SourcelionCh(msg) then  
if not DevAek:get(AEK..'Delete:Time'..msg.chat_id_..':'..msg.sender_user_id_) then  
local Number = tonumber(text:match('^تنظيف (%d+)$')) 
if Number > 1000 then 
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙لاتستطيع تنظيف اكثر من 1000 رساله', 1, 'md')
return false  
end  
local Message = msg.id_
for i=1,tonumber(Number) do
DeleteMessage(msg.chat_id_,{[0]=Message})
Message = Message - 1048576 
end
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙تم تنظيف *'..Number..'* من الرسائل', 1, 'md')
DevAek:setex(AEK..'Delete:Time'..msg.chat_id_..':'..msg.sender_user_id_,300,true)
end 
end
if text == "تنظيف المشتركين" and SecondSudo(msg) and ChCheck(msg) then 
local pv = DevAek:smembers(AEK.."Aek:Users")
local sendok = 0
for i = 1, #pv do
tdcli_function({ID='GetChat',chat_id_ = pv[i]
},function(arg,dataq)
tdcli_function ({ ID = "SendChatAction",  
chat_id_ = pv[i], action_ = {  ID = "SendMessageTypingAction", progress_ = 100} 
},function(arg,data) 
if data.ID and data.ID == "Ok" then
else
DevAek:srem(AEK.."Aek:Users",pv[i])
sendok = sendok + 1
end
if #pv == i then 
if sendok == 0 then
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙*لا يوجد مشتركين وهميين*', 1, 'md')
else
local ok = #pv - sendok
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙عدد المشتركين الان ↫ { '..#pv..' }\n✫︙تم حذف ↫ { '..sendok..' } من المشتركين\n✫︙العدد الحقيقي الان  ↫ ( '..ok..' ) \n', 1, 'md')
end
end
end,nil)
end,nil)
end
return false
end

if text == "تنظيف الكروبات" and SecondSudo(msg) and ChCheck(msg) or text == "تنظيف المجموعات" and SecondSudo(msg) and ChCheck(msg) then 
local group = DevAek:smembers(AEK.."Aek:Groups")
local w = 0
local q = 0
for i = 1, #group do
tdcli_function({ID='GetChat',chat_id_ = group[i]
},function(arg,data)
if data and data.type_ and data.type_.channel_ and data.type_.channel_.status_ and data.type_.channel_.status_.ID == "ChatMemberStatusMember" then
DevAek:srem(AEK.."Aek:Groups",group[i]) 
tdcli_function ({ ID = "ChangeChatMemberStatus", chat_id_ = group[i], user_id_ = AEK, status_ = { ID = "ChatMemberStatusLeft" }, }, dl_cb, nil)
w = w + 1
end
if data and data.type_ and data.type_.channel_ and data.type_.channel_.status_ and data.type_.channel_.status_.ID == "ChatMemberStatusLeft" then
DevAek:srem(AEK.."Aek:Groups",group[i]) 
q = q + 1
end
if data and data.type_ and data.type_.channel_ and data.type_.channel_.status_ and data.type_.channel_.status_.ID == "ChatMemberStatusKicked" then
DevAek:srem(AEK.."Aek:Groups",group[i]) 
q = q + 1
end
if data and data.code_ and data.code_ == 400 then
DevAek:srem(AEK.."Aek:Groups",group[i]) 
w = w + 1
end
if #group == i then 
if (w + q) == 0 then
Dev_Aek(msg.chat_id_, msg.id_, 1,'✫︙*لاتوجد مجموعات وهميه*', 1, 'md')   
else
local AEKgp2 = (w + q)
local AEKgp3 = #group - AEKgp2
if q == 0 then
AEKgp2 = ''
else
AEKgp2 = '\n✫︙تم حذف ↫ { '..q..' } مجموعه من البوت'
end
if w == 0 then
AEKgp1 = ''
else
AEKgp1 = '\n✫︙تم حذف ↫ { '..w..' } مجموعه بسبب تنزيل البوت الى عضو'
end
Dev_Aek(msg.chat_id_, msg.id_, 1,'✫︙عدد الكروبات الان ↫ { '..#group..' }'..AEKgp1..''..AEKgp2..'\n✫︙العدد الحقيقي الان  ↫ ( '..AEKgp3..' ) \n ', 1, 'md')
end end
end,nil)
end
return false
end 
end

if text and (text == "تفعيل امسح" or text == "تفعيل المسح التلقائي" or text == "تفعيل الحذف التلقائي") and Constructor(msg) and SourcelionCh(msg) then
local AEKTEAM = '✫︙اهلا عزيزي ↫ '..AekRank(msg)..' \n✫︙تم تفعيل امسح مع ميزة الحذف التلقائي للميديا'
Aekmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, AEKTEAM, 14, string.len(msg.sender_user_id_))
DevAek:set(AEK..'Aek:Lock:Clean'..msg.chat_id_,true)  
end
if text and (text == "تعطيل امسح" or text == "تعطيل المسح التلقائي" or text == "تعطيل الحذف التلقائي") and Constructor(msg) and SourcelionCh(msg) then
local AEKTEAM = '✫︙اهلا عزيزي ↫ '..AekRank(msg)..' \n✫︙تم تعطيل امسح مع ميزة الحذف التلقائي للميديا'
Aekmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, AEKTEAM, 14, string.len(msg.sender_user_id_))
DevAek:del(AEK..'Aek:Lock:Clean'..msg.chat_id_) 
end
if text and (text:match("^تعين عدد المسح (%d+)$") or text:match("^تعيين عدد المسح (%d+)$") or text:match("^تعين عدد الحذف (%d+)$") or text:match("^تعيين عدد الحذف (%d+)$")) and Constructor(msg) then   
local Num = text:match("تعين عدد المسح (%d+)$") or text:match("تعيين عدد المسح (%d+)$") or text:match("تعين عدد الحذف (%d+)$") or text:match("تعيين عدد الحذف (%d+)$")
if tonumber(Num) < 50 or tonumber(Num) > 200 then
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙قم بتحديد عدد اكبر من 50 واصغر من 200 للحذف التلقائي', 1, 'md')
else
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙تم وضع ↫ *'..Num..'* من الميديا للحذف التلقائي', 1, 'md')
DevAek:set(AEK..'Aek:CleanNum'..msg.chat_id_,Num) 
end end 
if msg and DevAek:get(AEK..'Aek:Lock:Clean'..msg.chat_id_) then
if DevAek:get(AEK..'Aek:CleanNum'..msg.chat_id_) then CleanNum = DevAek:get(AEK..'Aek:CleanNum'..msg.chat_id_) else CleanNum = 200 end
if DevAek:scard(AEK.."Aek:cleaner"..msg.chat_id_) >= tonumber(CleanNum) then 
local List = DevAek:smembers(AEK.."Aek:cleaner"..msg.chat_id_)
local Del = 0
for k,v in pairs(List) do
Del = (Del + 1)
local Message = v
DeleteMessage(msg.chat_id_,{[0]=Message})
end
SendText(msg.chat_id_,"✫︙تم حذف "..Del.." من الميديا تلقائيا",0,'md') 
DevAek:del(AEK.."Aek:cleaner"..msg.chat_id_)
end 
end 
if Cleaner(msg) then
if DevAek:get(AEK..'Aek:Lock:Clean'..msg.chat_id_) then 
if text == "الميديا" and SourcelionCh(msg) or text == "عدد الميديا" and SourcelionCh(msg) then 
local M = DevAek:scard(AEK.."Aek:cleaner"..msg.chat_id_)
if M ~= 0 then
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙عدد الميديا ↫ "..M.."\n✫︙الحذف التلقائي ↫ "..(DevAek:get(AEK..'Aek:CleanNum'..msg.chat_id_) or 200), 1, 'md') 
else
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙لاتوجد ميديا هنا", 1, 'md') 
end end
if text == "امسح" and SourcelionCh(msg) or text == "احذف" and SourcelionCh(msg) or text == "تنظيف ميديا" and SourcelionCh(msg) or text == "تنظيف الميديا" and SourcelionCh(msg) then
local List = DevAek:smembers(AEK.."Aek:cleaner"..msg.chat_id_)
local Del = 0
for k,v in pairs(List) do
Del = (Del + 1)
local Message = v
DeleteMessage(msg.chat_id_,{[0]=Message})
end
if Del ~= 0 then
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙تم حذف "..Del.." من الميديا", 1, 'md') 
DevAek:del(AEK.."Aek:cleaner"..msg.chat_id_)
else
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙لاتوجد ميديا هنا", 1, 'md') 
end end 
end
end

if Admin(msg) then
if text == "تنظيف تعديل" and SourcelionCh(msg) or text == "تنظيف التعديل" and SourcelionCh(msg) then   
Aek_Del = {[0]= msg.id_}
local Message = msg.id_
for i=1,100 do
Message = Message - 1048576
Aek_Del[i] = Message
end
tdcli_function({ID = "GetMessages",chat_id_ = msg.chat_id_,message_ids_ = Aek_Del},function(arg,data)
new = 0
Aek_Del2 = {}
for i=0 ,data.total_count_ do
if data.messages_[i] and (not data.messages_[i].edit_date_ or data.messages_[i].edit_date_ ~= 0) then
Aek_Del2[new] = data.messages_[i].id_
new = new + 1
end
end
DeleteMessage(msg.chat_id_,Aek_Del2)
end,nil)  
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙تم تنظيف 100 من الرسائل المعدله', 1, 'md')
end

if ChatType == 'sp' or ChatType == 'gp'  then
if Admin(msg) then
if text and text:match("^فتح (.*)$") and SourcelionCh(msg) then
local UnLockText = {string.match(text, "^(فتح) (.*)$")}
if UnLockText[2] == "التعديل" then
if DevAek:get(AEK..'Aek:Lock:EditMsgs'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم فتح التعديل")  
DevAek:del(AEK..'Aek:Lock:EditMsgs'..msg.chat_id_)
else
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙التعديل بالفعل مفتوح في المجموعه', 1, 'md')
end
end
if UnLockText[2] == "التعديل الميديا" or UnLockText[2] == "تعديل الميديا" then
if DevAek:get(AEK..'Aek:Lock:EditMsgs'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم فتح تعديل الميديا")  
DevAek:del(AEK..'Aek:Lock:EditMsgs'..msg.chat_id_)
else
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙تعديل الميديا بالفعل مفتوح في المجموعه', 1, 'md')
end
end
if UnLockText[2] == "الفارسيه" then
if DevAek:get(AEK..'Aek:Lock:Farsi'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم فتح الفارسيه")  
DevAek:del(AEK..'Aek:Lock:Farsi'..msg.chat_id_)
else
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙الفارسيه بالفعل مفتوحه في المجموعه', 1, 'md')
end
end
if UnLockText[2] == "الفارسيه بالتحذير" then
if DevAek:get(AEK..'Aek:Lock:FarsiWarn'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم فتح الفارسيه بالتحذير")  
DevAek:del(AEK..'Aek:Lock:FarsiWarn'..msg.chat_id_)
else
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙الفارسيه بالتحذير بالفعل مفتوحه في المجموعه', 1, 'md')
end
end
if UnLockText[2] == "الفشار" then
if not DevAek:get(AEK..'Aek:Lock:Fshar'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم فتح الفشار")  
DevAek:set(AEK..'Aek:Lock:Fshar'..msg.chat_id_,true)
else
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙الفشار بالفعل مفتوح في المجموعه', 1, 'md')
end
end
if UnLockText[2] == "الطائفيه" then
if not DevAek:get(AEK..'Aek:Lock:Taf'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم فتح الطائفيه")  
DevAek:set(AEK..'Aek:Lock:Taf'..msg.chat_id_,true)
else
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙الطائفيه بالفعل مفتوحه في المجموعه', 1, 'md')
end
end
if UnLockText[2] == "الكفر" then
if not DevAek:get(AEK..'Aek:Lock:Kfr'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم فتح الكفر")  
DevAek:set(AEK..'Aek:Lock:Kfr'..msg.chat_id_,true)
else
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙الكفر بالفعل مفتوح في المجموعه', 1, 'md')
end
end
if UnLockText[2] == "الفارسيه بالطرد" then
if DevAek:get(AEK..'Aek:Lock:FarsiBan'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم فتح الفارسيه بالطرد")  
DevAek:del(AEK..'Aek:Lock:FarsiBan'..msg.chat_id_)
else
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙الفارسيه بالطرد بالفعل مفتوحه', 1, 'md')
end
end
if UnLockText[2] == "البوتات" or UnLockText[2] == "البوتات بالطرد" or UnLockText[2] == "البوتات بالتقييد" or UnLockText[2] == "البوتات بالتقيد" then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم فتح البوتات")  
DevAek:del(AEK.."Aek:Lock:Bots"..msg.chat_id_)  
end
if UnLockText[2] == "التكرار" then 
DevAek:hdel(AEK.."Aek:Spam:Group:User"..msg.chat_id_ ,"Spam:User")  
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم فتح التكرار")  
end
if BasicConstructor(msg) then
if UnLockText[2] == "التثبيت" then
if DevAek:get(AEK..'Aek:Lock:Pin'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم فتح التثبيت")  
DevAek:del(AEK..'Aek:Lock:Pin'..msg.chat_id_)
DevAek:srem(AEK.."Aek:Lock:Pinpin",msg.chat_id_)
else
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙التثبيت بالفعل مفتوح في المجموعه', 1, 'md')
end end end
end
end

if Admin(msg) then
if text and text:match("^قفل (.*)$") then
local LockText = {string.match(text, "^(قفل) (.*)$")}
if LockText[2] == "الدردشه" then
if not DevAek:get(AEK..'Aek:Lock:Text'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم قفل الدردشه")  
DevAek:set(AEK..'Aek:Lock:Text'..msg.chat_id_,true)
else
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙الدردشه بالفعل مقفله في المجموعه', 1, 'md')
end
end
if LockText[2] == "الاونلاين" then
if not DevAek:get(AEK..'Aek:Lock:Inline'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم قفل الاونلاين")  
DevAek:set(AEK..'Aek:Lock:Inline'..msg.chat_id_,true)
else
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙الاونلاين بالفعل مقفل في المجموعه', 1, 'md')
end
end
if LockText[2] == "الصور" then
if not DevAek:get(AEK..'Aek:Lock:Photo'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم قفل الصور")  
DevAek:set(AEK..'Aek:Lock:Photo'..msg.chat_id_,true)
else
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙الصور بالفعل مقفله في المجموعه', 1, 'md')
end
end
if LockText[2] == "الكلايش" then
if not DevAek:get(AEK..'Aek:Lock:Spam'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم قفل الكلايش")  
DevAek:set(AEK..'Aek:Lock:Spam'..msg.chat_id_,true)
else
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙الكلايش بالفعل مقفله في المجموعه', 1, 'md')
end
end
if LockText[2] == "الدخول" then
if not DevAek:get(AEK..'Aek:Lock:Join'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم قفل الدخول")  
DevAek:set(AEK..'Aek:Lock:Join'..msg.chat_id_,true)
else
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙الدخول بالفعل مقفل في المجموعه', 1, 'md')
end
end
if LockText[2] == "الفيديو" then
if not DevAek:get(AEK..'Aek:Lock:Videos'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم قفل الفيديو")  
DevAek:set(AEK..'Aek:Lock:Videos'..msg.chat_id_,true)
else
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙الفيديو بالفعل مقفل في المجموعه', 1, 'md')
end
end
if LockText[2] == "المتحركه" then
if not DevAek:get(AEK..'Aek:Lock:Gifs'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم قفل المتحركه")  
DevAek:set(AEK..'Aek:Lock:Gifs'..msg.chat_id_,true)
else
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙المتحركه بالفعل مقفله في المجموعه', 1, 'md')
end
end
if LockText[2] == "الاغاني" then
if not DevAek:get(AEK..'Aek:Lock:Music'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم قفل الاغاني")  
DevAek:set(AEK..'Aek:Lock:Music'..msg.chat_id_,true)
else
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙الاغاني بالفعل مقفله في المجموعه', 1, 'md')
end
end
if LockText[2] == "الصوت" then
if not DevAek:get(AEK..'Aek:Lock:Voice'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم قفل الصوت")  
DevAek:set(AEK..'Aek:Lock:Voice'..msg.chat_id_,true)
else
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙الصوت بالفعل مقفل في المجموعه', 1, 'md')
end
end
if LockText[2] == "الروابط" then
if not DevAek:get(AEK..'Aek:Lock:Links'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم قفل الروابط")  
DevAek:set(AEK..'Aek:Lock:Links'..msg.chat_id_,true)
else
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙الروابط بالفعل مقفله في المجموعه', 1, 'md')
end
end
if LockText[2] == "المواقع" then
if not DevAek:get(AEK..'Aek:Lock:Location'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم قفل المواقع")  
DevAek:set(AEK..'Aek:Lock:Location'..msg.chat_id_,true)
else
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙المواقع بالفعل مقفله في المجموعه', 1, 'md')
end
end
if LockText[2] == "المعرف" or LockText[2] == "المعرفات" then
if not DevAek:get(AEK..'Aek:Lock:Tags'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم قفل المعرفات")  
DevAek:set(AEK..'Aek:Lock:Tags'..msg.chat_id_,true)
else
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙المعرفات بالفعل مقفله في المجموعه', 1, 'md')
end
end
if LockText[2] == "الملفات" then
if not DevAek:get(AEK..'Aek:Lock:Document'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم قفل الملفات")  
DevAek:set(AEK..'Aek:Lock:Document'..msg.chat_id_,true)
else
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙الملفات بالفعل مقفله في المجموعه', 1, 'md')
end
end
if LockText[2] == "الهاشتاك" or LockText[2] == "التاك" then
if not DevAek:get(AEK..'Aek:Lock:Hashtak'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم قفل الهاشتاك")  
DevAek:set(AEK..'Aek:Lock:Hashtak'..msg.chat_id_,true)
else
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙الهاشتاك بالفعل مقفل في المجموعه', 1, 'md')
end
end
if LockText[2] == "الجهات" then
if not DevAek:get(AEK..'Aek:Lock:Contact'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم قفل الجهات")  
DevAek:set(AEK..'Aek:Lock:Contact'..msg.chat_id_,true)
else
Dev_Aek(msg.chat_id_, msg.id_, 1, '️✫︙الجهات بالفعل مقفله في المجموعه', 1, 'md')
end
end
if LockText[2] == "الشبكات" then
if not DevAek:get(AEK..'Aek:Lock:WebLinks'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم قفل الشبكات")  
DevAek:set(AEK..'Aek:Lock:WebLinks'..msg.chat_id_,true) 
else
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙الشبكات بالفعل مقفله في المجموعه', 1, 'md')
end
end
if LockText[2] == "العربيه" then
if not DevAek:get(AEK..'Aek:Lock:Arabic'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم قفل العربيه")  
DevAek:set(AEK..'Aek:Lock:Arabic'..msg.chat_id_,true)
else
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙العربيه بالفعل مقفله في المجموعه', 1, 'md')
end
end
if LockText[2] == "الانكليزيه" then
if not DevAek:get(AEK..'Aek:Lock:English'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم قفل الانكليزيه")  
DevAek:set(AEK..'Aek:Lock:English'..msg.chat_id_,true)
else
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙الانكليزيه بالفعل مقفله في المجموعه', 1, 'md')
end
end
if LockText[2] == "الملصقات" then
if not DevAek:get(AEK..'Aek:Lock:Stickers'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم قفل الملصقات")  
DevAek:set(AEK..'Aek:Lock:Stickers'..msg.chat_id_,true)
else
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙الملصقات بالفعل مقفله في المجموعه', 1, 'md')
end
end
if LockText[2] == "الماركداون" then
if not DevAek:get(AEK..'Aek:Lock:Markdown'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم قفل الماركداون")  
DevAek:set(AEK..'Aek:Lock:Markdown'..msg.chat_id_,true)
else
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙الماركداون بالفعل مقفل في المجموعه', 1, 'md')
end
end
if LockText[2] == "الاشعارات" then
if not DevAek:get(AEK..'Aek:Lock:TagServr'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم قفل الاشعارات")  
DevAek:set(AEK..'Aek:Lock:TagServr'..msg.chat_id_,true)
else
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙الاشعارات بالفعل مقفله في المجموعه', 1, 'md')
end
end
if LockText[2] == "التوجيه" then
if not DevAek:get(AEK..'Aek:Lock:Forwards'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم قفل التوجيه")  
DevAek:set(AEK..'Aek:Lock:Forwards'..msg.chat_id_,true)
else
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙التوجيه بالفعل مقفل في المجموعه', 1, 'md')
end
end
end
end

if Admin(msg) then
if text and text:match("^فتح (.*)$") then
local UnLockText = {string.match(text, "^(فتح) (.*)$")}
if UnLockText[2] == "الدردشه" then
if DevAek:get(AEK..'Aek:Lock:Text'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم فتح الدردشه")  
DevAek:del(AEK..'Aek:Lock:Text'..msg.chat_id_)
else
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙الدردشه بالفعل مفتوحه في المجموعه', 1, 'md')
end
end
if UnLockText[2] == "الصور" then
if DevAek:get(AEK..'Aek:Lock:Photo'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم فتح الصور")  
DevAek:del(AEK..'Aek:Lock:Photo'..msg.chat_id_)
else
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙الصور بالفعل مفتوحه في المجموعه', 1, 'md')
end
end
if UnLockText[2] == "الكلايش" then
if DevAek:get(AEK..'Aek:Lock:Spam'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم فتح الكلايش")  
DevAek:del(AEK..'Aek:Lock:Spam'..msg.chat_id_)
else
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙الكلايش بالفعل مفتوحه في المجموعه', 1, 'md')
end
end
if UnLockText[2] == "الدخول" then
if DevAek:get(AEK..'Aek:Lock:Join'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم فتح الدخول")  
DevAek:del(AEK..'Aek:Lock:Join'..msg.chat_id_)
else
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙الدخول بالفعل مفتوح في المجموعه', 1, 'md')
end
end
if UnLockText[2] == "الفيديو" then
if DevAek:get(AEK..'Aek:Lock:Videos'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم فتح الفيديو")  
DevAek:del(AEK..'Aek:Lock:Videos'..msg.chat_id_)
else
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙الفيديو بالفعل مفتوحه في المجموعه', 1, 'md')
end
end
if UnLockText[2] == "الملفات" then
if DevAek:get(AEK..'Aek:Lock:Document'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم فتح الملفات")  
DevAek:del(AEK..'Aek:Lock:Document'..msg.chat_id_)
else
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙الملفات بالفعل مفتوحه في المجموعه', 1, 'md')
end
end
if UnLockText[2] == "الاونلاين" then
if DevAek:get(AEK..'Aek:Lock:Inline'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم فتح الاونلاين")  
DevAek:del(AEK..'Aek:Lock:Inline'..msg.chat_id_)
else
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙الاونلاين بالفعل مفتوحه في المجموعه', 1, 'md')
end
end
if UnLockText[2] == "الماركداون" then
if DevAek:get(AEK..'Aek:Lock:Markdown'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم فتح الماركداون")  
DevAek:del(AEK..'Aek:Lock:Markdown'..msg.chat_id_)
else
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙الماركداون بالفعل مفتوحه في المجموعه', 1, 'md')
end
end
if UnLockText[2] == "المتحركه" then
if DevAek:get(AEK..'Aek:Lock:Gifs'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم فتح المتحركه")  
DevAek:del(AEK..'Aek:Lock:Gifs'..msg.chat_id_)
else
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙المتحركه بالفعل مفتوحه في المجموعه', 1, 'md')
end
end
if UnLockText[2] == "الاغاني" then
if DevAek:get(AEK..'Aek:Lock:Music'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم فتح الاغاني")  
DevAek:del(AEK..'Aek:Lock:Music'..msg.chat_id_)
else
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙الاغاني بالفعل مفتوحه في المجموعه', 1, 'md')
end
end
if UnLockText[2] == "الصوت" then
if DevAek:get(AEK..'Aek:Lock:Voice'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم فتح الصوت")  
DevAek:del(AEK..'Aek:Lock:Voice'..msg.chat_id_)
else
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙الصوت بالفعل مفتوحه في المجموعه', 1, 'md')
end
end
if UnLockText[2] == "الروابط" then
if DevAek:get(AEK..'Aek:Lock:Links'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم فتح الروابط")  
DevAek:del(AEK..'Aek:Lock:Links'..msg.chat_id_)
else
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙الروابط بالفعل مفتوحه في المجموعه', 1, 'md')
end
end
if UnLockText[2] == "المواقع" then
if DevAek:get(AEK..'Aek:Lock:Location'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم فتح المواقع")  
DevAek:del(AEK..'Aek:Lock:Location'..msg.chat_id_)
else
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙المواقع بالفعل مفتوحه في المجموعه', 1, 'md')
end
end
if UnLockText[2] == "المعرف" or UnLockText[2] == "المعرفات" then
if DevAek:get(AEK..'Aek:Lock:Tags'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم فتح المعرفات")  
DevAek:del(AEK..'Aek:Lock:Tags'..msg.chat_id_)
else
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙المعرفات بالفعل مفتوحه في المجموعه', 1, 'md')
end
end
if UnLockText[2] == "الهاشتاك" or UnLockText[2] == "التاك" then
if DevAek:get(AEK..'Aek:Lock:Hashtak'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم فتح الهاشتاك")  
DevAek:del(AEK..'Aek:Lock:Hashtak'..msg.chat_id_)
else
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙الهاشتاك بالفعل مفتوحه في المجموعه', 1, 'md')
end
end
if UnLockText[2] == "الجهات" then
if DevAek:get(AEK..'Aek:Lock:Contact'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم فتح الجهات")  
DevAek:del(AEK..'Aek:Lock:Contact'..msg.chat_id_)
else
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙الجهات بالفعل مفتوحه في المجموعه', 1, 'md')
end
end
if UnLockText[2] == "الشبكات" then
if DevAek:get(AEK..'Aek:Lock:WebLinks'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم فتح الشبكات")  
DevAek:del(AEK..'Aek:Lock:WebLinks'..msg.chat_id_)
else
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙الشبكات بالفعل مفتوحه في المجموعه', 1, 'md')
end
end
if UnLockText[2] == "العربيه" then
if DevAek:get(AEK..'Aek:Lock:Arabic'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم فتح العربيه")  
DevAek:del(AEK..'Aek:Lock:Arabic'..msg.chat_id_)
else
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙العربيه بالفعل مفتوحه في المجموعه', 1, 'md')
end
end
if UnLockText[2] == "الانكليزيه" then
if DevAek:get(AEK..'Aek:Lock:English'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم فتح الانكليزيه")  
DevAek:del(AEK..'Aek:Lock:English'..msg.chat_id_)
else
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙الانكليزيه بالفعل مفتوحه في المجموعه', 1, 'md')
end
end
if UnLockText[2] == "الاشعارات" then
if DevAek:get(AEK..'Aek:Lock:TagServr'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم فتح الاشعارات")  
DevAek:del(AEK..'Aek:Lock:TagServr'..msg.chat_id_)
else
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙الاشعارات بالفعل مفتوحه في المجموعه', 1, 'md')
end
end
if UnLockText[2] == "الملصقات" then
if DevAek:get(AEK..'Aek:Lock:Stickers'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم فتح الملصقات")  
DevAek:del(AEK..'Aek:Lock:Stickers'..msg.chat_id_)
else
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙الملصقات بالفعل مفتوحه في المجموعه', 1, 'md')
end
end
if UnLockText[2] == "التوجيه" then
if DevAek:get(AEK..'Aek:Lock:Forwards'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم فتح التوجيه")  
DevAek:del(AEK..'Aek:Lock:Forwards'..msg.chat_id_)
else
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙التوجيه بالفعل مفتوح في المجموعه', 1, 'md')
end
end
end
end

if text and text:match("^قفل التفليش$") or text and text:match("^تفعيل الحمايه القصوى$") then
if not Constructor(msg) then
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙للمنشئين فقط', 1, 'md')
else
DevAek:set(AEK.."Aek:Lock:Bots"..msg.chat_id_,"del") DevAek:hset(AEK.."Aek:Spam:Group:User"..msg.chat_id_ ,"Spam:User","del") 
LockList ={'Aek:Lock:Links','Aek:Lock:Contact','Aek:Lock:Forwards','Aek:Lock:Videos','Aek:Lock:Gifs','Aek:Lock:EditMsgs','Aek:Lock:Stickers','Aek:Lock:Farsi','Aek:Lock:Spam','Aek:Lock:WebLinks','Aek:Lock:Photo'}
for i,Lock in pairs(LockList) do
DevAek:set(AEK..Lock..msg.chat_id_,true)
end
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم قفل التفليش")  
end
end
if text and text:match("^فتح التفليش$") then
if not Constructor(msg) then
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙للمنشئين فقط', 1, 'md')
else
DevAek:hdel(AEK.."Aek:Spam:Group:User"..msg.chat_id_ ,"Spam:User") 
UnLockList ={'Aek:Lock:Links','Aek:Lock:Contact','Aek:Lock:Forwards','Aek:Lock:Videos','Aek:Lock:Gifs','Aek:Lock:EditMsgs','Aek:Lock:Stickers','Aek:Lock:Farsi','Aek:Lock:Spam','Aek:Lock:WebLinks','Aek:Lock:Photo'}
for i,UnLock in pairs(UnLockList) do
DevAek:del(AEK..UnLock..msg.chat_id_)
end
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم فتح التفليش")  
end
end

if text and text:match("^قفل الكل$") then
if not Constructor(msg) then
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙للمنشئين فقط', 1, 'md')
else
DevAek:del(AEK..'Aek:Lock:Fshar'..msg.chat_id_) DevAek:del(AEK..'Aek:Lock:Taf'..msg.chat_id_) DevAek:del(AEK..'Aek:Lock:Kfr'..msg.chat_id_) 
DevAek:set(AEK.."Aek:Lock:Bots"..msg.chat_id_,"del") DevAek:hset(AEK.."Aek:Spam:Group:User"..msg.chat_id_ ,"Spam:User","del") 
LockList ={'Aek:Lock:EditMsgs','Aek:Lock:Farsi','Aek:Lock:TagServr','Aek:Lock:Inline','Aek:Lock:Photo','Aek:Lock:Spam','Aek:Lock:Videos','Aek:Lock:Gifs','Aek:Lock:Music','Aek:Lock:Voice','Aek:Lock:Links','Aek:Lock:Location','Aek:Lock:Tags','Aek:Lock:Stickers','Aek:Lock:Markdown','Aek:Lock:Forwards','Aek:Lock:Document','Aek:Lock:Contact','Aek:Lock:Hashtak','Aek:Lock:WebLinks'}
for i,Lock in pairs(LockList) do
DevAek:set(AEK..Lock..msg.chat_id_,true)
end
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم قفل جميع الاوامر")  
end
end
if text and text:match("^فتح الكل$") then
if not Constructor(msg) then
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙للمنشئين فقط', 1, 'md')
else
DevAek:set(AEK..'Aek:Lock:Fshar'..msg.chat_id_,true) DevAek:set(AEK..'Aek:Lock:Taf'..msg.chat_id_,true) DevAek:set(AEK..'Aek:Lock:Kfr'..msg.chat_id_,true) DevAek:hdel(AEK.."Aek:Spam:Group:User"..msg.chat_id_ ,"Spam:User") 
UnLockList ={'Aek:Lock:EditMsgs','Aek:Lock:Text','Aek:Lock:Arabic','Aek:Lock:English','Aek:Lock:Join','Aek:Lock:Bots','Aek:Lock:Farsi','Aek:Lock:FarsiBan','Aek:Lock:TagServr','Aek:Lock:Inline','Aek:Lock:Photo','Aek:Lock:Spam','Aek:Lock:Videos','Aek:Lock:Gifs','Aek:Lock:Music','Aek:Lock:Voice','Aek:Lock:Links','Aek:Lock:Location','Aek:Lock:Tags','Aek:Lock:Stickers','Aek:Lock:Markdown','Aek:Lock:Forwards','Aek:Lock:Document','Aek:Lock:Contact','Aek:Lock:Hashtak','Aek:Lock:WebLinks'}
for i,UnLock in pairs(UnLockList) do
DevAek:del(AEK..UnLock..msg.chat_id_)
end
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم فتح جميع الاوامر")  
end
end

if Admin(msg) then
if text and (text:match("^ضع سبام (%d+)$") or text:match("^وضع سبام (%d+)$")) then
local SetSpam = text:match("ضع سبام (%d+)$") or text:match("وضع سبام (%d+)$")
if tonumber(SetSpam) < 40 then
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙اختر عدد اكبر من 40 حرف ', 1, 'md')
else
DevAek:set(AEK..'Aek:Spam:Text'..msg.chat_id_,SetSpam)
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙تم وضع عدد السبام ↫'..SetSpam, 1, 'md')
end
end
end

if Manager(msg) then
if text == "فحص" and SourcelionCh(msg) or text == "فحص البوت" and SourcelionCh(msg) then
local Check = https.request('https://api.telegram.org/bot'..TokenBot..'/getChatMember?chat_id='..msg.chat_id_..'&user_id='..AEK)
local GetInfo = JSON.decode(Check)
if GetInfo.ok == true then
if GetInfo.result.can_change_info == true then EDT = '✔️' else EDT = '✖️' end
if GetInfo.result.can_delete_messages == true then DEL = '✔️' else DEL = '✖️' end
if GetInfo.result.can_invite_users == true then INV = '✔️' else INV = '✖️' end
if GetInfo.result.can_pin_messages == true then PIN = '✔️' else PIN = '✖️' end
if GetInfo.result.can_restrict_members == true then BAN = '✔️' else BAN = '✖️' end
if GetInfo.result.can_promote_members == true then VIP = '✔️' else VIP = '✖️' end 
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙صلاحيات البوت هي ↫ ⤈\n━───━ ✫ ━───━\n✫︙حذف الرسائل ↫ '..DEL..'\n✫︙دعوة المستخدمين ↫ '..INV..'\n✫︙حظر المستخدمين ↫ '..BAN..'\n✫︙تثبيت الرسائل ↫ '..PIN..'\n✫︙تغيير المعلومات ↫ '..EDT..'\n✫︙اضافة مشرفين ↫ '..VIP..'\n━───━ ✫ ━───━', 1, 'md')
end end
if text and text:match("^تغير رد المطور (.*)$") and SourcelionCh(msg) then
local Text = text:match("^تغير رد المطور (.*)$") 
DevAek:set(AEK.."Aek:SudoBot:Rd"..msg.chat_id_,Text)
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙تم تغير رد المطور الى ↫ "..Text, 1, 'md')
end
if text and text:match("^تغير رد منشئ الاساسي (.*)$") and SourcelionCh(msg) then
local Text = text:match("^تغير رد منشئ الاساسي (.*)$") 
DevAek:set(AEK.."Aek:BasicConstructor:Rd"..msg.chat_id_,Text)
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙تم تغير رد المنشئ الاساسي الى ↫ "..Text, 1, 'md')
end
if text and text:match("^تغير رد المنشئ (.*)$") and SourcelionCh(msg) then
local Text = text:match("^تغير رد المنشئ (.*)$") 
DevAek:set(AEK.."Aek:Constructor:Rd"..msg.chat_id_,Text)
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙تم تغير رد المنشئ الى ↫ "..Text, 1, 'md')
end
if text and text:match("^تغير رد المدير (.*)$") and SourcelionCh(msg) then
local Text = text:match("^تغير رد المدير (.*)$") 
DevAek:set(AEK.."Aek:Managers:Rd"..msg.chat_id_,Text) 
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙تم تغير رد المدير الى ↫ "..Text, 1, 'md')
end
if text and text:match("^تغير رد الادمن (.*)$") and SourcelionCh(msg) then
local Text = text:match("^تغير رد الادمن (.*)$") 
DevAek:set(AEK.."Aek:Admins:Rd"..msg.chat_id_,Text)
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙تم تغير رد الادمن الى ↫ "..Text, 1, 'md')
end
if text and text:match("^تغير رد المميز (.*)$") and SourcelionCh(msg) then
local Text = text:match("^تغير رد المميز (.*)$") 
DevAek:set(AEK.."Aek:VipMem:Rd"..msg.chat_id_,Text)
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙تم تغير رد المميز الى ↫ "..Text, 1, 'md')
end
if text and text:match("^تغير رد العضو (.*)$") and SourcelionCh(msg) then
local Text = text:match("^تغير رد العضو (.*)$") 
DevAek:set(AEK.."Aek:mem:Rd"..msg.chat_id_,Text)
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙تم تغير رد العضو الى ↫ "..Text, 1, 'md')
end
if text == "حذف ردود الرتب" and SourcelionCh(msg) or text == "مسح ردود الرتب" and SourcelionCh(msg) then
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙تم حذف جميع ردود الرتب", 1, 'md')
DevAek:del(AEK.."Aek:mem:Rd"..msg.chat_id_)
DevAek:del(AEK.."Aek:Cleaner:Rd"..msg.chat_id_)
DevAek:del(AEK.."Aek:VipMem:Rd"..msg.chat_id_)
DevAek:del(AEK.."Aek:Admins:Rd"..msg.chat_id_)
DevAek:del(AEK.."Aek:Managers:Rd"..msg.chat_id_)
DevAek:del(AEK.."Aek:Constructor:Rd"..msg.chat_id_)
DevAek:del(AEK.."Aek:BasicConstructor:Rd"..msg.chat_id_)
DevAek:del(AEK.."Aek:SudoBot:Rd"..msg.chat_id_)
end
end

if text == "كشف البوتات" and SourcelionCh(msg) then 
tdcli_function ({ID = "GetChannelMembers",channel_id_ = msg.chat_id_:gsub("-100",""),filter_ = {ID = "ChannelMembersBots"},offset_ = 0,limit_ = 100 },function(extra,result,success)
local admins = result.members_  
text = '✫︙*قائمة البوتات* ↫ ⤈ \n━───━ ✫ ━───━\n'
local n = 0
local t = 0
for i=0 , #admins do 
n = (n + 1)
tdcli_function ({ID = "GetUser",user_id_ = admins[i].user_id_
},function(arg,data) 
if result.members_[i].status_.ID == "ChatMemberStatusMember" then  
ab = ''
elseif result.members_[i].status_.ID == "ChatMemberStatusEditor" then  
t = t + 1
ab = ' ✯'
end
text = text.."~ [@"..data.username_..']'..ab.."\n"
if #admins == 0 then
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙*لاتوجد بوتات هنا*", 1, 'md')
return false end
if #admins == i then 
local a = '━───━ ✫ ━───━\n✫︙*عدد البوتات هنا* ↫ '..n..'\n'
local f = '✫︙*عدد البوتات المرفوعه* ↫ '..t..'\n✫︙*ملاحضه علامة الـ*✯ *تعني ان البوت ادمن في هذه المجموعه*'
Dev_Aek(msg.chat_id_, msg.id_, 1, text..a..f, 1, 'md')
end
end,nil)
end
end,nil)
end
if text == 'حذف البوتات' and SourcelionCh(msg) or text == 'طرد البوتات' and SourcelionCh(msg) or text == 'مسح البوتات' and SourcelionCh(msg) then
tdcli_function ({ ID = "GetChannelMembers",channel_id_ = msg.chat_id_:gsub("-100",""),filter_ = {ID = "ChannelMembersBots"},offset_ = 0,limit_ = 100 },function(arg,dp)  
local admins = dp.members_  
local x = 0
local c = 0
for i=0 , #admins do 
if dp.members_[i].status_.ID == "ChatMemberStatusEditor" then  
x = x + 1 
end
if tonumber(admins[i].user_id_) ~= tonumber(AEK) then
ChatKick(msg.chat_id_,admins[i].user_id_)
end
c = c + 1
end     
if (c - x) == 0 then
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙*لاتوجد بوتات هنا*", 1, 'md')
else
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙*عدد البوتات هنا* ↫ "..c.."\n✫︙*عدد البوتات المرفوعه* ↫ "..x.."\n✫︙*تم طرد* ↫ "..(c - x).." *من البوتات*", 1, 'md')
end 
end,nil)  
end 

end

if Admin(msg) then
if text and text:match("^حذف (.*)$") or text and text:match("^مسح (.*)$") then
local txts = {string.match(text, "^(حذف) (.*)$")}
local txtss = {string.match(text, "^(مسح) (.*)$")}
if Sudo(msg) then 
if txts[2] == 'الثانويين' or txtss[2] == 'الثانويين' or txts[2] == 'المطورين الثانويين' or txtss[2] == 'المطورين الثانويين' then
DevAek:del(AEK..'Aek:SecondSudo:')
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم حذف المطورين الثانويين")  
end
end
if SecondSudo(msg) then 
if txts[2] == 'المطورين' or txtss[2] == 'المطورين' then
DevAek:del(AEK..'Aek:SudoBot:')
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم حذف المطورين")  
end
if txts[2] == 'قائمه العام' or txtss[2] == 'قائمه العام' then
DevAek:del(AEK..'Aek:BanAll:')
DevAek:del(AEK..'Aek:MuteAll:')
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم حذف قائمة العام")  
end
end
if SudoBot(msg) then
if txts[2] == 'الادمنيه العامين' or txts[2] == 'الادمنيه العام' or txtss[2] == 'الادمنيه العامين' or txtss[2] == 'الادمنيه العام' then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم حذف الادمنيه العامين")  
DevAek:del(AEK..'Aek:AdminAll:')
end
if txts[2] == 'المميزين عام' or txts[2] == 'المميزين العامين' or txtss[2] == 'المميزين عام' or txtss[2] == 'المميزين العامين' then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم حذف المميزين عام")  
DevAek:del(AEK..'Aek:VipAll:')
end
if txts[2] == 'المدراء العامين' or txts[2] == 'المدراء العام' or txtss[2] == 'المدراء العامين' or txtss[2] == 'المدراء العام' then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم حذف المدراء العامين")  
DevAek:del(AEK..'Aek:ManagerAll:')
end
if txts[2] == 'المالكين' or txtss[2] == 'المالكين' then
DevAek:del(AEK..'Aek:AekConstructor:'..msg.chat_id_)
tdcli_function ({ID = "GetChannelMembers",channel_id_ = msg.chat_id_:gsub("-100",""),filter_ = {ID = "ChannelMembersAdministrators"},offset_ = 0,limit_ = 100},function(arg,dp) 
local admins = dp.members_
for i=0 , #admins do
if dp.members_[i].status_.ID == "ChatMemberStatusCreator" then
DevAek:sadd(AEK.."Aek:AekConstructor:"..msg.chat_id_,admins[i].user_id_)
end 
end  
end,nil)
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم حذف المالكين")  
end
end
if AekConstructor(msg) then
if txts[2] == 'المنشئين الاساسيين' or txtss[2] == 'المنشئين الاساسيين' then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم حذف المنشئين الاساسيين")  
DevAek:del(AEK..'Aek:BasicConstructor:'..msg.chat_id_)
end
end
if BasicConstructor(msg) then
if txts[2] == 'المنشئين' or txtss[2] == 'المنشئين' then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم حذف المنشئين")  
DevAek:del(AEK..'Aek:Constructor:'..msg.chat_id_)
end end
if Constructor(msg) then
if txts[2] == 'المدراء' or txtss[2] == 'المدراء' then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم حذف المدراء")  
DevAek:del(AEK..'Aek:Managers:'..msg.chat_id_)
end
if txts[2] == 'المنظفين' or txtss[2] == 'المنظفين' then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم حذف المنظفين")  
DevAek:del(AEK..'Aek:Cleaner:'..msg.chat_id_)
end end
if Manager(msg) then
if txts[2] == 'الادمنيه' or txtss[2] == 'الادمنيه' then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم حذف الادمنيه")  
DevAek:del(AEK..'Aek:Admins:'..msg.chat_id_)
end
end
if txts[2] == 'المطايه' or txtss[2] == 'المطايه' then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم حذف المطايه")  
DevAek:del(AEK..'User:Donky:'..msg.chat_id_)
end
if txts[2] == 'الرابط' or txtss[2] == 'الرابط' then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم حذف رابط المجموعه")  
DevAek:del(AEK.."Aek:Groups:Links"..msg.chat_id_)
end
if txts[2] == 'المميزين' or txtss[2] == 'المميزين' then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم حذف المميزين")  
DevAek:del(AEK..'Aek:VipMem:'..msg.chat_id_)
end
if txts[2] == 'المكتومين' or txtss[2] == 'المكتومين' then
DevAek:del(AEK..'Aek:Muted:'..msg.chat_id_)
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم حذف المكتومين")  
end
if txts[2] == 'المقيدين' or txtss[2] == 'المقيدين' then     
local List = DevAek:smembers(AEK..'Aek:Tkeed:'..msg.chat_id_)
for k,v in pairs(List) do   
HTTPS.request("https://api.telegram.org/bot"..TokenBot.."/restrictChatMember?chat_id="..msg.chat_id_.."&user_id="..v.."&can_send_messages=True&can_send_media_messages=True&can_send_other_messages=True&can_add_web_page_previews=True") 
DevAek:srem(AEK..'Aek:Tkeed:'..msg.chat_id_, v)
end 
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم حذف المقيدين")  
end
if txts[2] == 'قائمه المنع' or txtss[2] == 'قائمه المنع' then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم حذف قائمة المنع")  
DevAek:del(AEK..'Aek:Filters:'..msg.chat_id_)
end
if txts[2] == 'قوائم المنع' or txtss[2] == 'قوائم المنع' then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم حذف قوائم المنع")  
DevAek:del(AEK..'Aek:Filters:'..msg.chat_id_)
DevAek:del(AEK.."Aek:FilterAnimation"..msg.chat_id_)
DevAek:del(AEK.."Aek:FilterPhoto"..msg.chat_id_)
DevAek:del(AEK.."Aek:FilterSteckr"..msg.chat_id_)
end
if txts[2] == 'قائمه منع المتحركات' or txtss[2] == 'قائمه منع المتحركات' then     
DevAek:del(AEK.."Aek:FilterAnimation"..msg.chat_id_)
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم حذف قائمة منع المتحركات")  
end
if txts[2] == 'قائمه منع الصور' or txtss[2] == 'قائمه منع الصور' then     
DevAek:del(AEK.."Aek:FilterPhoto"..msg.chat_id_)
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم حذف قائمة منع الصور")  
end
if txts[2] == 'قائمه منع الملصقات' or txtss[2] == 'قائمه منع الملصقات' then     
DevAek:del(AEK.."Aek:FilterSteckr"..msg.chat_id_)
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم حذف قائمة منع الملصقات")  
end
end
end

if text and text:match("^حذف القوائم$") and SourcelionCh(msg) or text and text:match("^مسح القوائم$") and SourcelionCh(msg) then
if not BasicConstructor(msg) then
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙للمنشئ الاساسي فقط', 1, 'md')
else
DevAek:del(AEK..'Aek:Ban:'..msg.chat_id_) DevAek:del(AEK..'Aek:Admins:'..msg.chat_id_) DevAek:del(AEK..'User:Donky:'..msg.chat_id_) DevAek:del(AEK..'Aek:VipMem:'..msg.chat_id_) DevAek:del(AEK..'Aek:Filters:'..msg.chat_id_) DevAek:del(AEK..'Aek:Muted:'..msg.chat_id_)
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙تم حذف ↫ ❨ قائمة المنع • المحظورين • المكتومين • الادمنيه • المميزين • المطايه ❩ بنجاح \n ✓", 1, 'md')
end end

if text and text:match("^حذف جميع الرتب$") and SourcelionCh(msg) or text and text:match("^مسح جميع الرتب$") and SourcelionCh(msg) or text and text:match("^تنزيل جميع الرتب$") and SourcelionCh(msg) then
if not AekConstructor(msg) then
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙لمنشئ المجموعه فقط', 1, 'md')
else
local basicconstructor = DevAek:smembers(AEK..'Aek:BasicConstructor:'..msg.chat_id_)
local constructor = DevAek:smembers(AEK..'Aek:Constructor:'..msg.chat_id_)
local Managers = DevAek:smembers(AEK..'Aek:Managers:'..msg.chat_id_)
local admins = DevAek:smembers(AEK..'Aek:Admins:'..msg.chat_id_)
local vipmem = DevAek:smembers(AEK..'Aek:VipMem:'..msg.chat_id_)
local donky = DevAek:smembers(AEK..'User:Donky:'..msg.chat_id_)
if #basicconstructor ~= 0 then basicconstructort = 'المنشئين الاساسيين • ' else basicconstructort = '' end
if #constructor ~= 0 then constructort = 'المنشئين • ' else constructort = '' end
if #Managers ~= 0 then Managerst = 'المدراء • ' else Managerst = '' end
if #admins ~= 0 then adminst = 'الادمنيه • ' else adminst = '' end
if #vipmem ~= 0 then vipmemt = 'المميزين • ' else vipmemt = '' end
if #donky ~= 0 then donkyt = 'المطايه • ' else donkyt = '' end
if #basicconstructor ~= 0 or #constructor ~= 0 or #Managers ~= 0 or #admins ~= 0 or #vipmem ~= 0 or #donky ~= 0 then 
DevAek:del(AEK..'Aek:BasicConstructor:'..msg.chat_id_)
DevAek:del(AEK..'Aek:Constructor:'..msg.chat_id_)
DevAek:del(AEK..'Aek:Managers:'..msg.chat_id_)
DevAek:del(AEK..'Aek:Admins:'..msg.chat_id_)
DevAek:del(AEK..'Aek:VipMem:'..msg.chat_id_)
DevAek:del(AEK..'User:Donky:'..msg.chat_id_)
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙تم حذف جميع الرتب التاليه ↫ ❨ "..basicconstructort..''..constructort..''..Managerst..''..adminst..''..vipmemt..''..donkyt.." ❩ بنجاح \n ✓", 1, 'md')
else
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙لاتوجد رتب هنا", 1, 'md')
end 
end 
end

if Admin(msg) then 
if text and text:match("^الاعدادات$") and SourcelionCh(msg) then
if not DevAek:get(AEK..'Aek:Spam:Text'..msg.chat_id_) then
spam_c = 400
else
spam_c = DevAek:get(AEK..'Aek:Spam:Text'..msg.chat_id_)
end

if DevAek:hget(AEK.."Aek:Spam:Group:User"..msg.chat_id_, "Spam:User") == "kick" then     
flood = "بالطرد"     
elseif DevAek:hget(AEK.."Aek:Spam:Group:User"..msg.chat_id_,"Spam:User") == "keed" then     
flood = "بالتقيد"     
elseif DevAek:hget(AEK.."Aek:Spam:Group:User"..msg.chat_id_,"Spam:User") == "mute" then     
flood = "بالكتم"           
elseif DevAek:hget(AEK.."Aek:Spam:Group:User"..msg.chat_id_,"Spam:User") == "del" then     
flood = "بالحذف"
else     
flood = "مفتوح"     
end

if DevAek:get(AEK.."Aek:Lock:Bots"..msg.chat_id_) == "del" then
lock_bots = "بالحذف"
elseif DevAek:get(AEK.."Aek:Lock:Bots"..msg.chat_id_) == "ked" then
lock_bots = "بالتقيد"   
elseif DevAek:get(AEK.."Aek:Lock:Bots"..msg.chat_id_) == "kick" then
lock_bots = "بالطرد"    
else
lock_bots = "مفتوحه"    
end

if DevAek:get(AEK..'Aek:Lock:Text'..msg.chat_id_) then mute_text = 'مقفله' else mute_text = 'مفتوحه'end
if DevAek:get(AEK..'Aek:Lock:Photo'..msg.chat_id_) then mute_photo = 'مقفله' else mute_photo = 'مفتوحه' end
if DevAek:get(AEK..'Aek:Lock:Videos'..msg.chat_id_) then mute_video = 'مقفله' else mute_video = 'مفتوحه' end
if DevAek:get(AEK..'Aek:Lock:Gifs'..msg.chat_id_) then mute_gifs = 'مقفله' else mute_gifs = 'مفتوحه' end
if DevAek:get(AEK..'Aek:Lock:Music'..msg.chat_id_) then mute_music = 'مقفله' else mute_music = 'مفتوحه' end
if DevAek:get(AEK..'Aek:Lock:Inline'..msg.chat_id_) then mute_in = 'مقفله' else mute_in = 'مفتوحه' end
if DevAek:get(AEK..'Aek:Lock:Voice'..msg.chat_id_) then mute_voice = 'مقفله' else mute_voice = 'مفتوحه' end
if DevAek:get(AEK..'Aek:Lock:EditMsgs'..msg.chat_id_) then mute_edit = 'مقفله' else mute_edit = 'مفتوحه' end
if DevAek:get(AEK..'Aek:Lock:Links'..msg.chat_id_) then mute_links = 'مقفله' else mute_links = 'مفتوحه' end
if DevAek:get(AEK..'Aek:Lock:Pin'..msg.chat_id_) then lock_pin = 'مقفله' else lock_pin = 'مفتوحه' end
if DevAek:get(AEK..'Aek:Lock:Stickers'..msg.chat_id_) then lock_sticker = 'مقفله' else lock_sticker = 'مفتوحه' end
if DevAek:get(AEK..'Aek:Lock:TagServr'..msg.chat_id_) then lock_tgservice = 'مقفله' else lock_tgservice = 'مفتوحه' end
if DevAek:get(AEK..'Aek:Lock:WebLinks'..msg.chat_id_) then lock_wp = 'مقفله' else lock_wp = 'مفتوحه' end
if DevAek:get(AEK..'Aek:Lock:Hashtak'..msg.chat_id_) then lock_htag = 'مقفله' else lock_htag = 'مفتوحه' end
if DevAek:get(AEK..'Aek:Lock:Tags'..msg.chat_id_) then lock_tag = 'مقفله' else lock_tag = 'مفتوحه' end
if DevAek:get(AEK..'Aek:Lock:Location'..msg.chat_id_) then lock_location = 'مقفله' else lock_location = 'مفتوحه' end
if DevAek:get(AEK..'Aek:Lock:Contact'..msg.chat_id_) then lock_contact = 'مقفله' else lock_contact = 'مفتوحه' end
if DevAek:get(AEK..'Aek:Lock:English'..msg.chat_id_) then lock_english = 'مقفله' else lock_english = 'مفتوحه' end
if DevAek:get(AEK..'Aek:Lock:Arabic'..msg.chat_id_) then lock_arabic = 'مقفله' else lock_arabic = 'مفتوحه' end
if DevAek:get(AEK..'Aek:Lock:Forwards'..msg.chat_id_) then lock_forward = 'مقفله' else lock_forward = 'مفتوحه' end
if DevAek:get(AEK..'Aek:Lock:Document'..msg.chat_id_) then lock_file = 'مقفله' else lock_file = 'مفتوحه' end
if DevAek:get(AEK..'Aek:Lock:Markdown'..msg.chat_id_) then markdown = 'مقفله' else markdown = 'مفتوحه' end
if DevAek:get(AEK..'Aek:Lock:Spam'..msg.chat_id_) then lock_spam = 'مقفله' else lock_spam = 'مفتوحه' end
if DevAek:get(AEK..'Aek:Lock:Join'..msg.chat_id_) then lock_Join = 'مقفل' else lock_Join = 'مفتوح' end
if DevAek:get(AEK.."Aek:Lock:Welcome"..msg.chat_id_) then send_welcome = 'مقفله' else send_welcome = 'مفتوحه' end
if DevAek:get(AEK..'Aek:Lock:Fshar'..msg.chat_id_) then lock_fshar = 'مفتوح' else lock_fshar = 'مقفل' end
if DevAek:get(AEK..'Aek:Lock:Kfr'..msg.chat_id_) then lock_kaf = 'مفتوح' else lock_kaf = 'مقفل' end
if DevAek:get(AEK..'Aek:Lock:Taf'..msg.chat_id_) then lock_taf = 'مفتوحه' else lock_taf = 'مقفله' end
if DevAek:get(AEK..'Aek:Lock:Farsi'..msg.chat_id_) then lock_farsi = 'مقفله' else lock_farsi = 'مفتوحه' end
local Flood_Num = DevAek:hget(AEK.."Aek:Spam:Group:User"..msg.chat_id_,"Num:Spam") or 5

local TXTE = "✫︙اعدادات المجموعه ↫ ⤈\n━───━ ✫ ━───━\n"
.."✫︙الروابط ↫ "..mute_links.."\n"
.."✫︙المعرف ↫ "..lock_tag.."\n"
.."✫︙البوتات ↫ "..lock_bots.."\n"
.."✫︙المتحركه ↫ "..mute_gifs.."\n"
.."✫︙الملصقات ↫ "..lock_sticker.."\n"
.."✫︙الملفات ↫ "..lock_file.."\n"
.."✫︙الصور ↫ "..mute_photo.."\n"
.."✫︙الفيديو ↫ "..mute_video.."\n"
.."✫︙الاونلاين ↫ "..mute_in.."\n"
.."✫︙الدردشه ↫ "..mute_text.."\n"
.."✫︙التوجيه ↫ "..lock_forward.."\n"
.."✫︙الاغاني ↫ "..mute_music.."\n"
.."✫︙الصوت ↫ "..mute_voice.."\n"
.."✫︙الجهات ↫ "..lock_contact.."\n"
.."✫︙الماركداون ↫ "..markdown.."\n"
.."✫︙الهاشتاك ↫ "..lock_htag.."\n"
.."✫︙التعديل ↫ "..mute_edit.."\n"
.."✫︙التثبيت ↫ "..lock_pin.."\n"
.."✫︙الاشعارات ↫ "..lock_tgservice.."\n"
.."✫︙الكلايش ↫ "..lock_spam.."\n"
.."✫︙الدخول ↫ "..lock_Join.."\n"
.."✫︙الشبكات ↫ "..lock_wp.."\n"
.."✫︙المواقع ↫ "..lock_location.."\n"
.."✫︙الفشار ↫ "..lock_fshar.."\n"
.."✫︙الكفر ↫ "..lock_kaf.."\n"
.."✫︙الطائفيه ↫ "..lock_taf.."\n"
.."✫︙العربيه ↫ "..lock_arabic.."\n"
.."✫︙الانكليزيه ↫ "..lock_english.."\n"
.."✫︙الفارسيه ↫ "..lock_farsi.."\n"
.."✫︙التكرار ↫ "..flood.."\n"
.."✫︙عدد التكرار ↫ "..Flood_Num.."\n"
.."✫︙عدد السبام ↫ "..spam_c.."\n"
.."━───━ ✫ ━───━\n✫︙[‹  𝖲𝗈𝗎𝗋𝖼𝖾 𝙄𝘽𝙊 ›](https://t.me/HH_418)\n"
Dev_Aek(msg.chat_id_, msg.id_, 1, TXTE, 1, 'md')
end
end

if text and text:match("^كول (.*)$") and SourcelionCh(msg) then
local txt = {string.match(text, "^(كول) (.*)$")}
Dev_Aek(msg.chat_id_,0, 1, txt[2], 1, 'md')
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end

if DevAek:get(AEK..'Aek:setrules'..msg.chat_id_..':'..msg.sender_user_id_) then 
if text == 'الغاء' then 
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙تم الغاء حفظ قوانين المجموعه', 1, 'md')
DevAek:del(AEK..'Aek:setrules'..msg.chat_id_..':'..msg.sender_user_id_)
return false  
end 
DevAek:del(AEK..'Aek:setrules'..msg.chat_id_..':'..msg.sender_user_id_)
DevAek:set(AEK..'Aek:rules'..msg.chat_id_,text)
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙تم حفظ قوانين المجموعه', 1, 'md')
return false   
end
if text and text:match("^ضع قوانين$") and SourcelionCh(msg) or text and text:match("^وضع قوانين$") and SourcelionCh(msg) or text and text:match("^ضع القوانين$") and SourcelionCh(msg) or text and text:match("^وضع القوانين$") and SourcelionCh(msg) then
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙ارسل لي القوانين الان', 1, 'md')
DevAek:set(AEK..'Aek:setrules'..msg.chat_id_..':'..msg.sender_user_id_,true)
end
if text and text:match("^مسح قوانين$") and SourcelionCh(msg) or text and text:match("^حذف قوانين$") and SourcelionCh(msg) or text and text:match("^حذف القوانين$") and SourcelionCh(msg) or text and text:match("^مسح القوانين$") and SourcelionCh(msg) then
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙تم حذف القوانين', 1, 'md')
DevAek:del(AEK..'Aek:rules'..msg.chat_id_)
end
end
if text and text:match("^القوانين$") and SourcelionCh(msg) or text and text:match("^قوانين$") and SourcelionCh(msg) then
local rules = DevAek:get(AEK..'Aek:rules'..msg.chat_id_)
Dev_Aek(msg.chat_id_, msg.id_, 1, rules, 1, nil)
end

if text == 'رقمي' then
tdcli_function({ID="GetUser",user_id_=msg.sender_user_id_},function(extra,result,success)
if result.phone_number_  then
MyNumber = "✫ ⁞رقمك ↫ +"..result.phone_number_
else
MyNumber = "✫ ⁞تم وضع رقمك لجهات اتصالك فقط"
end
send(msg.chat_id_, msg.id_,MyNumber)
end,nil)
end

if text == "تفعيل الزخرفه" and Manager(msg) and SourcelionCh(msg) then
local AEKTEAM = '✫︙اهلا عزيزي ↫ '..AekRank(msg)..' \n✫︙تم تفعيل الزخرفه بنجاح'
Aekmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, AEKTEAM, 14, string.len(msg.sender_user_id_))
DevAek:del(AEK..'Aek:Zrf:Aek'..msg.chat_id_) 
end
if text == "تعطيل الزخرفه" and Manager(msg) and SourcelionCh(msg) then
local AEKTEAM = '✫︙اهلا عزيزي ↫ '..AekRank(msg)..' \n✫︙تم تعطيل الزخرفه بنجاح'
Aekmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, AEKTEAM, 14, string.len(msg.sender_user_id_))
DevAek:set(AEK..'Aek:Zrf:Aek'..msg.chat_id_,true)  
end
if DevAek:get(AEK..'Zrf:Aek'..msg.chat_id_..''..msg.sender_user_id_) then 
if text and text == 'الغاء' then 
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙تم الغاء امر الزخرفه', 1, 'md')
DevAek:del(AEK..'Zrf:Aek'..msg.chat_id_..''..msg.sender_user_id_)
return false  
end 
UrlZrf = https.request('https://apiabs.ml/zrf.php?abs='..URL.escape(text)) 
Zrf = JSON.decode(UrlZrf) 
t = "✫︙قائمة الزخرفه ↫ ⤈\n━───━ ✫ ━───━\n"
i = 0
for k,v in pairs(Zrf.ok) do
i = i + 1
t = t..i.."~ `"..v.."` \n"
end
Dev_Aek(msg.chat_id_, msg.id_, 1, t, 1, 'md')
DevAek:del(AEK..'Zrf:Aek'..msg.chat_id_..''..msg.sender_user_id_)
return false   
end
if not DevAek:get(AEK..'Aek:Zrf:Aek'..msg.chat_id_) then
if text == 'زخرفه' and SourcelionCh(msg) or text == 'الزخرفه' and SourcelionCh(msg) then  
DevAek:setex(AEK.."Zrf:Aek"..msg.chat_id_..""..msg.sender_user_id_,300,true)
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙ارسل لي الكلمه لزخرفتها \nيمكنك الزخرفة باللغه { en } ~ { ar } ', 1, 'md')
end
end
if not DevAek:get(AEK..'Aek:Zrf:Aek'..msg.chat_id_) then
if text and text:match("^زخرفه (.*)$") and SourcelionCh(msg) or text and text:match("^زخرف (.*)$") and SourcelionCh(msg) then 
local TextZrf = text:match("^زخرفه (.*)$") or text:match("^زخرف (.*)$") 
UrlZrf = https.request('https://apiabs.ml/zrf.php?abs='..URL.escape(TextZrf)) 
Zrf = JSON.decode(UrlZrf) 
t = "✫︙قائمة الزخرفه ↫ ⤈\n━───━ ✫ ━───━\n"
i = 0
for k,v in pairs(Zrf.ok) do
i = i + 1
t = t..i.."~ `"..v.."` \n"
end
Dev_Aek(msg.chat_id_, msg.id_, 1, t, 1, 'md')
end
end

if text == "تفعيل الابراج" and Manager(msg) and SourcelionCh(msg) then
local AEKTEAM = '✫︙اهلا عزيزي ↫ '..AekRank(msg)..' \n✫︙تم تفعيل الابراج بنجاح'
Aekmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, AEKTEAM, 14, string.len(msg.sender_user_id_))
DevAek:del(AEK..'Aek:Brg:Aek'..msg.chat_id_) 
end
if text == "تعطيل الابراج" and Manager(msg) and SourcelionCh(msg) then
local AEKTEAM = '✫︙اهلا عزيزي ↫ '..AekRank(msg)..' \n✫︙تم تعطيل الابراج بنجاح'
Aekmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, AEKTEAM, 14, string.len(msg.sender_user_id_))
DevAek:set(AEK..'Aek:Brg:Aek'..msg.chat_id_,true)  
end
if not DevAek:get(AEK..'Aek:Brg:Aek'..msg.chat_id_) then
if text and text:match("^برج (.*)$") and SourcelionCh(msg) or text and text:match("^برجي (.*)$") and SourcelionCh(msg) then 
local TextBrg = text:match("^برج (.*)$") or text:match("^برجي (.*)$") 
UrlBrg = https.request('https://apiabs.ml/brg.php?brg='..URL.escape(TextBrg)) 
Brg = JSON.decode(UrlBrg) 
t = Brg.ok.abs  
Dev_Aek(msg.chat_id_, msg.id_, 1, t, 1, 'html')
end
end

if text and (text == "تفعيل اوامر النسب" or text == "تفعيل نسبه الحب" or text == "تفعيل نسبه الكره" or text == "تفعيل نسبه الرجوله" or text == "تفعيل نسبه الانوثه" or text == "تفعيل نسبه الغباء") and Manager(msg) and SourcelionCh(msg) then
local AEKTEAM = '✫︙اهلا عزيزي ↫ '..AekRank(msg)..' \n✫︙تم تفعيل اوامر النسب'
Aekmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, AEKTEAM, 14, string.len(msg.sender_user_id_))
DevAek:del(AEK..'Aek:Nsba:Aek'..msg.chat_id_) 
end
if text and (text == "تعطيل اوامر النسب" or text == "تعطيل نسبه الحب" or text == "تعطيل نسبه الكره" or text == "تعطيل نسبه الرجوله" or text == "تعطيل نسبه الانوثه" or text == "تعطيل نسبه الغباء") and Manager(msg) and SourcelionCh(msg) then
local AEKTEAM = '✫︙اهلا عزيزي ↫ '..AekRank(msg)..' \n✫︙تم تعطيل اوامر النسب'
Aekmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, AEKTEAM, 14, string.len(msg.sender_user_id_))
DevAek:set(AEK..'Aek:Nsba:Aek'..msg.chat_id_,true)  
end
if not DevAek:get(AEK..'Aek:Nsba:Aek'..msg.chat_id_) then
if text == "نسبه الحب" and SourcelionCh(msg) or text == "نسبة الحب" and SourcelionCh(msg) then
DevAek:set(AEK..'LoveNsba:Aek'..msg.chat_id_..msg.sender_user_id_,true) 
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙قم بارسل اسمين لحساب نسبة الحب بينهما كمثال ↫ جاك وروز', 1, 'md')
end
end
if text and text ~= "نسبه الحب" and text ~= "نسبة الحب" and DevAek:get(AEK..'LoveNsba:Aek'..msg.chat_id_..msg.sender_user_id_) then
if text and text == 'الغاء' then 
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙تم الغاء امر نسبة الحب ', 1, 'md')
DevAek:del(AEK..'LoveNsba:Aek'..msg.chat_id_..msg.sender_user_id_) 
return false 
end 
Aek = math.random(0,100);
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙نسبة الحب بين '..text..' هي : '..Aek..'%', 1, 'md')
DevAek:del(AEK..'LoveNsba:Aek'..msg.chat_id_..msg.sender_user_id_) 
return false 
end
if not DevAek:get(AEK..'Aek:Nsba:Aek'..msg.chat_id_) then
if text == "نسبه الكره" and SourcelionCh(msg) or text == "نسبة الكره" and SourcelionCh(msg) then
DevAek:set(AEK..'HataNsba:Aek'..msg.chat_id_..msg.sender_user_id_,true) 
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙قم بارسل اسمين لحساب نسبة الكره بينهما كمثال ↫ جاك وروز', 1, 'md')
end
end
if text and text ~= "نسبه الكره" and text ~= "نسبة الكره" and DevAek:get(AEK..'HataNsba:Aek'..msg.chat_id_..msg.sender_user_id_) then
if text and text == 'الغاء' then 
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙تم الغاء امر نسبة الكره ', 1, 'md')
DevAek:del(AEK..'HataNsba:Aek'..msg.chat_id_..msg.sender_user_id_) 
return false 
end 
Aek = math.random(0,100);
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙نسبة الكره بين '..text..' هي : '..Aek..'%', 1, 'md')
DevAek:del(AEK..'HataNsba:Aek'..msg.chat_id_..msg.sender_user_id_) 
return false 
end
if not DevAek:get(AEK..'Aek:Nsba:Aek'..msg.chat_id_) then
if text and (text == "نسبه الرجوله" or text == "نسبة الرجوله" or text == "نسبه رجوله" or text == "نسبة رجوله") and SourcelionCh(msg) then
DevAek:set(AEK..'RjolaNsba:Aek'..msg.chat_id_..msg.sender_user_id_,true) 
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙قم بارسل اسم الشخص لقياس نسبة رجولته كمثال ↫ جاك', 1, 'md')
end
end
if text and text ~= "نسبه الرجوله" and text ~= "نسبة الرجوله" and text ~= "نسبه رجوله" and text ~= "نسبة رجوله" and DevAek:get(AEK..'RjolaNsba:Aek'..msg.chat_id_..msg.sender_user_id_) then
if text and text == 'الغاء' then 
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙تم الغاء امر نسبة الرجوله ', 1, 'md')
DevAek:del(AEK..'RjolaNsba:Aek'..msg.chat_id_..msg.sender_user_id_) 
return false 
end 
Aek = math.random(0,100);
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙نسبة رجولة '..text..' هي : '..Aek..'%', 1, 'md')
DevAek:del(AEK..'RjolaNsba:Aek'..msg.chat_id_..msg.sender_user_id_) 
return false 
end
if not DevAek:get(AEK..'Aek:Nsba:Aek'..msg.chat_id_) then
if text and (text == "نسبه الانوثه" or text == "نسبة الانوثه" or text == "نسبه انوثه" or text == "نسبة انوثه") and SourcelionCh(msg) then
DevAek:set(AEK..'AnothaNsba:Aek'..msg.chat_id_..msg.sender_user_id_,true) 
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙قم بارسل اسم الشخص لقياس نسبة انوثته كمثال ↫ روز', 1, 'md')
end
end
if text and text ~= "نسبه الانوثه" and text ~= "نسبة الانوثه" and text ~= "نسبه انوثه" and text ~= "نسبة انوثه" and DevAek:get(AEK..'AnothaNsba:Aek'..msg.chat_id_..msg.sender_user_id_) then
if text and text == 'الغاء' then 
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙تم الغاء امر نسبة الانوثه ', 1, 'md')
DevAek:del(AEK..'AnothaNsba:Aek'..msg.chat_id_..msg.sender_user_id_) 
return false 
end 
Aek = math.random(0,100);
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙نسبة انوثة '..text..' هي : '..Aek..'%', 1, 'md')
DevAek:del(AEK..'AnothaNsba:Aek'..msg.chat_id_..msg.sender_user_id_) 
return false 
end
if not DevAek:get(AEK..'Aek:Nsba:Aek'..msg.chat_id_) then
if text and (text == "نسبه الغباء" or text == "نسبة الغباء") and SourcelionCh(msg) then
DevAek:set(AEK..'StupidNsba:Aek'..msg.chat_id_..msg.sender_user_id_,true) 
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙قم بارسل اسم الشخص لقياس نسبة غبائه كمثال ↫ جاك او روز', 1, 'md')
end
end
if text and text ~= "نسبه الغباء" and text ~= "نسبة الغباء" and DevAek:get(AEK..'StupidNsba:Aek'..msg.chat_id_..msg.sender_user_id_) then
if text and text == 'الغاء' then 
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙تم الغاء امر نسبة الغباء ', 1, 'md')
DevAek:del(AEK..'StupidNsba:Aek'..msg.chat_id_..msg.sender_user_id_) 
return false 
end 
Aek = math.random(0,100);
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙نسبة غباء '..text..' هي : '..Aek..'%', 1, 'md')
DevAek:del(AEK..'StupidNsba:Aek'..msg.chat_id_..msg.sender_user_id_) 
return false 
end

if text == "تفعيل حساب العمر" and Manager(msg) and SourcelionCh(msg) then
local AEKTEAM = '✫︙اهلا عزيزي ↫ '..AekRank(msg)..' \n✫︙تم تفعيل حساب العمر'
Aekmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, AEKTEAM, 14, string.len(msg.sender_user_id_))
DevAek:del(AEK..'Aek:Age:Aek'..msg.chat_id_) 
end
if text == "تعطيل حساب العمر" and Manager(msg) and SourcelionCh(msg) then
local AEKTEAM = '✫︙اهلا عزيزي ↫ '..AekRank(msg)..' \n✫︙تم تعطيل حساب العمر'
Aekmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, AEKTEAM, 14, string.len(msg.sender_user_id_))
DevAek:set(AEK..'Aek:Age:Aek'..msg.chat_id_,true)  
end
if not DevAek:get(AEK..'Aek:Age:Aek'..msg.chat_id_) then
if text and text:match("^احسب (.*)$") and SourcelionCh(msg) or text and text:match("^عمري (.*)$") and SourcelionCh(msg) then 
local TextAge = text:match("^احسب (.*)$") or text:match("^عمري (.*)$") 
UrlAge = https.request('https://apiabs.ml/age.php?age='..URL.escape(TextAge)) 
Age = JSON.decode(UrlAge) 
t = Age.ok.abs
Dev_Aek(msg.chat_id_, msg.id_, 1, t, 1, 'html')
end
end

if text == "تفعيل معاني الاسماء" and Manager(msg) and SourcelionCh(msg) then
local AEKTEAM = '✫︙اهلا عزيزي ↫ '..AekRank(msg)..' \n✫︙تم تفعيل معاني الاسماء'
Aekmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, AEKTEAM, 14, string.len(msg.sender_user_id_))
DevAek:del(AEK..'Aek:Mean:Aek'..msg.chat_id_) 
end
if text == "تعطيل معاني الاسماء" and Manager(msg) and SourcelionCh(msg) then
local AEKTEAM = '✫︙اهلا عزيزي ↫ '..AekRank(msg)..' \n✫︙تم تعطيل معاني الاسماء'
Aekmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, AEKTEAM, 14, string.len(msg.sender_user_id_))
DevAek:set(AEK..'Aek:Mean:Aek'..msg.chat_id_,true)  
end
if not DevAek:get(AEK..'Aek:Mean:Aek'..msg.chat_id_) then
if text and text:match("^معنى الاسم (.*)$") and SourcelionCh(msg) or text and text:match("^معنى اسم (.*)$") and SourcelionCh(msg) then 
local TextMean = text:match("^معنى الاسم (.*)$") or text:match("^معنى اسم (.*)$") 
UrlMean = https.request('https://apiabs.ml/Mean.php?Abs='..URL.escape(TextMean)) 
Mean = JSON.decode(UrlMean) 
t = Mean.ok.abs
Dev_Aek(msg.chat_id_, msg.id_, 1, t, 1, 'html')
end
end

if text == "تفعيل متحركه" and Manager(msg) and SourcelionCh(msg) or text == "تفعيل المتحركه" and Manager(msg) and SourcelionCh(msg) then
local AEKTEAM = '✫︙اهلا عزيزي ↫ '..AekRank(msg)..' \n✫︙تم تفعيل المتحركه'
Aekmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, AEKTEAM, 14, string.len(msg.sender_user_id_))
DevAek:del(AEK..'Aek:gif:Aek'..msg.chat_id_) 
end
if text == "تعطيل متحركه" and Manager(msg) and SourcelionCh(msg) or text == "تعطيل المتحركه" and Manager(msg) and SourcelionCh(msg) then
local AEKTEAM = '✫︙اهلا عزيزي ↫ '..AekRank(msg)..' \n✫︙تم تعطيل المتحركه'
Aekmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, AEKTEAM, 14, string.len(msg.sender_user_id_))
DevAek:set(AEK..'Aek:gif:Aek'..msg.chat_id_,true)  
end
if text and (text == "متحركه" or text == "✫ متحركه↫") and not DevAek:get(AEK..'Aek:gif:Aek'..msg.chat_id_) and SourcelionCh(msg) then
Aek = math.random(01,0205); 
local Text ='*✫︙تم اختيار المتحركه لك*'
keyboard = {}  
keyboard.inline_keyboard = {{{text="✫ مرة أخرى ᥀",callback_data="/gif:"..msg.sender_user_id_}},{{text = '‹  𝖲𝗈𝗎𝗋𝖼𝖾 𝙄𝘽𝙊 ›',url="t.me/HH_418"}}} 
local msg_id = msg.id_/2097152/0.5 
https.request("https://api.telegram.org/bot"..TokenBot..'/sendanimation?chat_id=' .. msg.chat_id_ .. '&animation=https://t.me/GifAek/'..Aek..'&caption=' .. URL.escape(Text).."&reply_to_message_id="..msg_id.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard)) 
end
if text == "تفعيل ميمز" and Manager(msg) and SourcelionCh(msg) or text == "تفعيل الميمز" and Manager(msg) and SourcelionCh(msg) then
local AEKTEAM = '✫︙اهلا عزيزي ↫ '..AekRank(msg)..' \n✫︙تم تفعيل الميمز'
Aekmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, AEKTEAM, 14, string.len(msg.sender_user_id_))
DevAek:del(AEK..'Aek:memz:Aek'..msg.chat_id_) 
end
if text == "تعطيل ميمز" and Manager(msg) and SourcelionCh(msg) or text == "تعطيل الميمز" and Manager(msg) and SourcelionCh(msg) then
local AEKTEAM = '✫︙اهلا عزيزي ↫ '..AekRank(msg)..' \n✫︙تم تعطيل الميمز'
Aekmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, AEKTEAM, 14, string.len(msg.sender_user_id_))
DevAek:set(AEK..'Aek:memz:Aek'..msg.chat_id_,true)  
end
if text and (text == "ميمز" or text == "✫ ميمز↫") and not DevAek:get(AEK..'Aek:memz:Aek'..msg.chat_id_) and SourcelionCh(msg) then
Aek = math.random(2,1170); 
local Text ='*✫︙تم اختيار مقطع الميمز لك*'
keyboard = {}  
keyboard.inline_keyboard = {{{text="✫ مرة أخرى ᥀",callback_data="/memz:"..msg.sender_user_id_}},{{text = '‹  𝖲𝗈𝗎𝗋𝖼𝖾 𝙄𝘽𝙊 ›',url="t.me/HH_418"}}} 
local msg_id = msg.id_/2097152/0.5 
https.request("https://api.telegram.org/bot"..TokenBot..'/sendVoice?chat_id=' .. msg.chat_id_ .. '&voice=https://t.me/MemesAek/'..Aek..'&caption=' .. URL.escape(Text).."&reply_to_message_id="..msg_id.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard)) 
end
if text == "تفعيل غنيلي" and Manager(msg) and SourcelionCh(msg) then
local AEKTEAM = '✫︙اهلا عزيزي ↫ '..AekRank(msg)..' \n✫︙تم تفعيل غنيلي'
Aekmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, AEKTEAM, 14, string.len(msg.sender_user_id_))
DevAek:del(AEK..'Aek:Audios:Aek'..msg.chat_id_) 
end
if text == "تعطيل غنيلي" and Manager(msg) and SourcelionCh(msg) then
local AEKTEAM = '✫︙اهلا عزيزي ↫ '..AekRank(msg)..' \n✫︙تم تعطيل غنيلي'
Aekmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, AEKTEAM, 14, string.len(msg.sender_user_id_))
DevAek:set(AEK..'Aek:Audios:Aek'..msg.chat_id_,true)  
end
if text and (text == "غنيلي" or text == "✫ غنيلي↫") and not DevAek:get(AEK..'Aek:Audios:Aek'..msg.chat_id_) and SourcelionCh(msg) then
Aek = math.random(2,2216); 
local Text ='*✫︙تم اختيار المقطع الصوتي لك*'
keyboard = {}  
keyboard.inline_keyboard = {{{text="✫ مرة أخرى ᥀",callback_data="/Song:"..msg.sender_user_id_}},{{text = '‹  𝖲𝗈𝗎𝗋𝖼𝖾 𝙄𝘽𝙊 ›',url="t.me/HH_418"}}} 
local msg_id = msg.id_/2097152/0.5 
https.request("https://api.telegram.org/bot"..TokenBot..'/sendVoice?chat_id=' .. msg.chat_id_ .. '&voice=https://t.me/AudioAek/'..Aek..'&caption=' .. URL.escape(Text).."&reply_to_message_id="..msg_id.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard)) 
end
if text == "تفعيل الاغاني" and Manager(msg) and SourcelionCh(msg) or text == "تفعيل اغنيه" and Manager(msg) and SourcelionCh(msg) then
local AEKTEAM = '✫︙اهلا عزيزي ↫ '..AekRank(msg)..' \n✫︙تم تفعيل الاغاني'
Aekmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, AEKTEAM, 14, string.len(msg.sender_user_id_))
DevAek:del(AEK..'Aek:mp3:Aek'..msg.chat_id_) 
end
if text == "تعطيل الاغاني" and Manager(msg) and SourcelionCh(msg) or text == "تعطيل اغنيه" and Manager(msg) and SourcelionCh(msg) then
local AEKTEAM = '✫︙اهلا عزيزي ↫ '..AekRank(msg)..' \n✫︙تم تعطيل الاغاني'
Aekmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, AEKTEAM, 14, string.len(msg.sender_user_id_))
DevAek:set(AEK..'Aek:mp3:Aek'..msg.chat_id_,true)  
end
if text and (text == "اغنيه" or text == "✫ اغنيه↫" or text == "اغاني") and not DevAek:get(AEK..'Aek:mp3:Aek'..msg.chat_id_) and SourcelionCh(msg) then
Aek = math.random(14,3059); 
local Text ='*✫︙تم اختيار الاغنيه لك*'
keyboard = {}  
keyboard.inline_keyboard = {{{text="✫ مرة أخرى ᥀",callback_data="/mp3:"..msg.sender_user_id_}},{{text = '‹  𝖲𝗈𝗎𝗋𝖼𝖾 𝙄𝘽𝙊 ›',url="t.me/HH_418"}}} 
local msg_id = msg.id_/2097152/0.5 
https.request("https://api.telegram.org/bot"..TokenBot..'/sendAudio?chat_id=' .. msg.chat_id_ .. '&audio=https://t.me/SongAek/'..Aek..'&caption=' .. URL.escape(Text).."&reply_to_message_id="..msg_id.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard)) 
end
if text == "تفعيل ريمكس" and Manager(msg) and SourcelionCh(msg) or text == "تفعيل الريمكس" and Manager(msg) and SourcelionCh(msg) then
local AEKTEAM = '✫︙اهلا عزيزي ↫ '..AekRank(msg)..' \n✫︙تم تفعيل الريمكس'
Aekmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, AEKTEAM, 14, string.len(msg.sender_user_id_))
DevAek:del(AEK..'Aek:Remix:Aek'..msg.chat_id_) 
end
if text == "تعطيل ريمكس" and Manager(msg) and SourcelionCh(msg) or text == "تعطيل الريمكس" and Manager(msg) and SourcelionCh(msg) then
local AEKTEAM = '✫︙اهلا عزيزي ↫ '..AekRank(msg)..' \n✫︙تم تعطيل الريمكس'
Aekmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, AEKTEAM, 14, string.len(msg.sender_user_id_))
DevAek:set(AEK..'Aek:Remix:Aek'..msg.chat_id_,true)  
end
if text and (text == "ريمكس" or text == "✫ ريمكس↫") and not DevAek:get(AEK..'Aek:Remix:Aek'..msg.chat_id_) and SourcelionCh(msg) then
Aek = math.random(2,0042); 
local Text ='*✫︙تم اختيار الريمكس لك*'
keyboard = {}  
keyboard.inline_keyboard = {{{text="✫ مرة أخرى ᥀",callback_data="/remix:"..msg.sender_user_id_}},{{text = '‹  𝖲𝗈𝗎𝗋𝖼𝖾 𝙄𝘽𝙊 ›',url="t.me/HH_418"}}} 
local msg_id = msg.id_/2097152/0.5 
https.request("https://api.telegram.org/bot"..TokenBot..'/sendVoice?chat_id=' .. msg.chat_id_ .. '&voice=https://t.me/RemixAek/'..Aek..'&caption=' .. URL.escape(Text).."&reply_to_message_id="..msg_id.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard)) 
end
if text == "تفعيل صوره" and Manager(msg) and SourcelionCh(msg) or text == "تفعيل الصوره" and Manager(msg) and SourcelionCh(msg) then
local AEKTEAM = '✫︙اهلا عزيزي ↫ '..AekRank(msg)..' \n✫︙تم تفعيل الصوره'
Aekmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, AEKTEAM, 14, string.len(msg.sender_user_id_))
DevAek:del(AEK..'Aek:Photo:Aek'..msg.chat_id_) 
end
if text == "تعطيل صوره" and Manager(msg) and SourcelionCh(msg) or text == "تعطيل الصوره" and Manager(msg) and SourcelionCh(msg) then
local AEKTEAM = '✫︙اهلا عزيزي ↫ '..AekRank(msg)..' \n✫︙تم تعطيل الصوره'
Aekmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, AEKTEAM, 14, string.len(msg.sender_user_id_))
DevAek:set(AEK..'Aek:Photo:Aek'..msg.chat_id_,true)  
end
if text and (text == "صوره" or text == "✫ صوره↫") and not DevAek:get(AEK..'Aek:Photo:Aek'..msg.chat_id_) and SourcelionCh(msg) then
Aek = math.random(1,0075); 
local Text ='*✫︙تم اختيار الصوره لك*'
keyboard = {}  
keyboard.inline_keyboard = {{{text="✫ مرة أخرى ᥀",callback_data="/photo:"..msg.sender_user_id_}},{{text = '‹  𝖲𝗈𝗎𝗋𝖼𝖾 𝙄𝘽𝙊 ›',url="t.me/HH_418"}}} 
local msg_id = msg.id_/2097152/0.5 
https.request("https://api.telegram.org/bot"..TokenBot..'/sendphoto?chat_id=' .. msg.chat_id_ .. '&photo=https://t.me/PhotosAek/'..Aek..'&caption=' .. URL.escape(Text).."&reply_to_message_id="..msg_id.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard)) 
end
if text == "تفعيل انمي" and Manager(msg) and SourcelionCh(msg) or text == "تفعيل الانمي" and Manager(msg) and SourcelionCh(msg) then
local AEKTEAM = '✫︙اهلا عزيزي ↫ '..AekRank(msg)..' \n✫︙تم تفعيل الانمي'
Aekmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, AEKTEAM, 14, string.len(msg.sender_user_id_))
DevAek:del(AEK..'Aek:Anime:Aek'..msg.chat_id_) 
end
if text == "تعطيل انمي" and Manager(msg) and SourcelionCh(msg) or text == "تعطيل الانمي" and Manager(msg) and SourcelionCh(msg) then
local AEKTEAM = '✫︙اهلا عزيزي ↫ '..AekRank(msg)..' \n✫︙تم تعطيل الانمي'
Aekmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, AEKTEAM, 14, string.len(msg.sender_user_id_))
DevAek:set(AEK..'Aek:Anime:Aek'..msg.chat_id_,true)  
end
if text and (text == "انمي" or text == "↫ انمي ✫") and not DevAek:get(AEK..'Aek:Anime:Aek'..msg.chat_id_) and SourcelionCh(msg) then
Aek = math.random(3,1002); 
local Text ='*✫︙تم اختيار صورة الانمي لك*'
keyboard = {}  
keyboard.inline_keyboard = {{{text="✫ مرة أخرى ᥀",callback_data="/anime:"..msg.sender_user_id_}},{{text = '‹  𝖲𝗈𝗎𝗋𝖼𝖾 𝙄𝘽𝙊 ›',url="t.me/HH_418"}}} 
local msg_id = msg.id_/2097152/0.5 
https.request("https://api.telegram.org/bot"..TokenBot..'/sendphoto?chat_id=' .. msg.chat_id_ .. '&photo=https://t.me/AnimeAek/'..Aek..'&caption=' .. URL.escape(Text).."&reply_to_message_id="..msg_id.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard)) 
end

if Admin(msg) then
if DevAek:get(AEK..'Aek:LockSettings'..msg.chat_id_) then 
if text == "الروابط" then if DevAek:get(AEK..'Aek:Lock:Links'..msg.chat_id_) then mute_links = 'مقفله' else mute_links = 'مفتوحه' end local AEKTEAM = "\n" .."✫︙الروابط ↫ "..mute_links.."\n" Dev_Aek(msg.chat_id_, msg.id_, 1, AEKTEAM, 1, 'md') end
if text == "المعرف" or text == "المعرفات" then if DevAek:get(AEK..'Aek:Lock:Tags'..msg.chat_id_) then lock_tag = 'مقفوله' else lock_tag = 'مفتوحه' end local AEKTEAM = "\n" .."✫︙المعرف ↫ "..lock_tag.."\n" Dev_Aek(msg.chat_id_, msg.id_, 1, AEKTEAM, 1, 'md') end
if text == "المتحركه" or text == "الملصقات المتحركه" then if DevAek:get(AEK..'Aek:Lock:Gifs'..msg.chat_id_) then mute_gifs = 'مقفوله' else mute_gifs = 'مفتوحه' end local AEKTEAM = "\n" .."✫︙المتحركه ↫ "..mute_gifs.."\n" Dev_Aek(msg.chat_id_, msg.id_, 1, AEKTEAM, 1, 'md') end
if text == "الملصقات" then if DevAek:get(AEK..'Aek:Lock:Stickers'..msg.chat_id_) then lock_sticker = 'مقفوله' else lock_sticker = 'مفتوحه' end local AEKTEAM = "\n" .."✫︙الملصقات ↫ "..lock_sticker.."\n" Dev_Aek(msg.chat_id_, msg.id_, 1, AEKTEAM, 1, 'md') end
if text == "الصور" then if DevAek:get(AEK..'Aek:Lock:Photo'..msg.chat_id_) then mute_photo = 'مقفوله' else mute_photo = 'مفتوحه' end local AEKTEAM = "\n" .."✫︙الصور ↫ "..mute_photo.."\n" Dev_Aek(msg.chat_id_, msg.id_, 1, AEKTEAM, 1, 'md') end
if text == "الفيديو" or text == "الفيديوهات" then if DevAek:get(AEK..'Aek:Lock:Videos'..msg.chat_id_) then mute_video = 'مقفوله' else mute_video = 'مفتوحه' end local AEKTEAM = "\n" .."✫︙الفيديو ↫ "..mute_video.."\n" Dev_Aek(msg.chat_id_, msg.id_, 1, AEKTEAM, 1, 'md') end
if text == "الاونلاين" then if DevAek:get(AEK..'Aek:Lock:Inline'..msg.chat_id_) then mute_in = 'مقفل' else mute_in = 'مفتوح' end local AEKTEAM = "\n" .."✫︙الاونلاين ↫ "..mute_in.."\n" Dev_Aek(msg.chat_id_, msg.id_, 1, AEKTEAM, 1, 'md') end
if text == "الدردشه" then if DevAek:get(AEK..'Aek:Lock:Text'..msg.chat_id_) then mute_text = 'مقفله' else mute_text = 'مفتوحه' end local AEKTEAM = "\n" .."✫︙الدردشه ↫ "..mute_text.."\n" Dev_Aek(msg.chat_id_, msg.id_, 1, AEKTEAM, 1, 'md') end
if text == "التوجيه" or text == "اعاده التوجيه" then if DevAek:get(AEK..'Aek:Lock:Forwards'..msg.chat_id_) then lock_forward = 'مقفل' else lock_forward = 'مفتوح' end local AEKTEAM = "\n" .."✫︙التوجيه ↫ "..lock_forward.."\n" Dev_Aek(msg.chat_id_, msg.id_, 1, AEKTEAM, 1, 'md') end
if text == "الاغاني" then if DevAek:get(AEK..'Aek:Lock:Music'..msg.chat_id_) then mute_music = 'مقفوله' else mute_music = 'مفتوحه' end local AEKTEAM = "\n" .."✫︙الاغاني ↫ "..mute_music.."\n" Dev_Aek(msg.chat_id_, msg.id_, 1, AEKTEAM, 1, 'md') end
if text == "الصوت" or text == "الصوتيات" then if DevAek:get(AEK..'Aek:Lock:Voice'..msg.chat_id_) then mute_voice = 'مقفول' else mute_voice = 'مفتوح' end local AEKTEAM = "\n" .."✫︙الصوت ↫ "..mute_voice.."\n" Dev_Aek(msg.chat_id_, msg.id_, 1, AEKTEAM, 1, 'md') end
if text == "الجهات" or text == "جهات الاتصال" then if DevAek:get(AEK..'Aek:Lock:Contact'..msg.chat_id_) then lock_contact = 'مقفوله' else lock_contact = 'مفتوحه' end local AEKTEAM = "\n" .."✫︙الجهات ↫ "..lock_contact.."\n" Dev_Aek(msg.chat_id_, msg.id_, 1, AEKTEAM, 1, 'md') end
if text == "الماركداون" then if DevAek:get(AEK..'Aek:Lock:Markdown'..msg.chat_id_) then markdown = 'مقفل' else markdown = 'مفتوح' end local AEKTEAM = "\n" .."✫︙الماركداون ↫ "..markdown.."\n" Dev_Aek(msg.chat_id_, msg.id_, 1, AEKTEAM, 1, 'md') end
if text == "الهاشتاك" then if DevAek:get(AEK..'Aek:Lock:Hashtak'..msg.chat_id_) then lock_htag = 'مقفل' else lock_htag = 'مفتوح' end local AEKTEAM = "\n" .."✫︙الهاشتاك ↫ "..lock_htag.."\n"Dev_Aek(msg.chat_id_, msg.id_, 1, AEKTEAM, 1, 'md') end
if text == "التعديل" then if DevAek:get(AEK..'Aek:Lock:EditMsgs'..msg.chat_id_) then mute_edit = 'مقفل' else mute_edit = 'مفتوح' end local AEKTEAM = "\n" .."✫︙التعديل ↫ "..mute_edit.."\n" Dev_Aek(msg.chat_id_, msg.id_, 1, AEKTEAM, 1, 'md') end
if text == "التثبيت" then if DevAek:get(AEK..'Aek:Lock:Pin'..msg.chat_id_) then lock_pin = 'مقفل' else lock_pin = 'مفتوح' end local AEKTEAM = "\n" .."✫︙التثبيت ↫ "..lock_pin.."\n" Dev_Aek(msg.chat_id_, msg.id_, 1, AEKTEAM, 1, 'md') end
if text == "الاشعارات" then if DevAek:get(AEK..'Aek:Lock:TagServr'..msg.chat_id_) then lock_tgservice = 'مقفوله' else lock_tgservice = 'مفتوحه' end local AEKTEAM = "\n" .."✫︙الاشعارات ↫ "..lock_tgservice.."\n" Dev_Aek(msg.chat_id_, msg.id_, 1, AEKTEAM, 1, 'md') end
if text == "الكلايش" then if DevAek:get(AEK..'Aek:Lock:Spam'..msg.chat_id_) then lock_spam = 'مقفوله' else lock_spam = 'مفتوحه' end local AEKTEAM = "\n" .."✫︙الكلايش ↫ "..lock_spam.."\n" Dev_Aek(msg.chat_id_, msg.id_, 1, AEKTEAM, 1, 'md') end
if text == "الدخول" then if DevAek:get(AEK..'Aek:Lock:Join'..msg.chat_id_) then lock_Join = 'مقفول' else lock_Join = 'مفتوح' end local AEKTEAM = "\n" .."✫︙الدخول ↫ "..lock_Join.."\n" Dev_Aek(msg.chat_id_, msg.id_, 1, AEKTEAM, 1, 'md') end
if text == "الشبكات" then if DevAek:get(AEK..'Aek:Lock:WebLinks'..msg.chat_id_) then lock_wp = 'مقفوله' else lock_wp = 'مفتوحه' end local AEKTEAM = "\n" .."✫︙الشبكات ↫ "..lock_wp.."\n" Dev_Aek(msg.chat_id_, msg.id_, 1, AEKTEAM, 1, 'md') end
if text == "المواقع" then if DevAek:get(AEK..'Aek:Lock:Location'..msg.chat_id_) then lock_location = 'مقفوله' else lock_location = 'مفتوحه' end local AEKTEAM = "\n" .."✫︙المواقع ↫ "..lock_location.."\n" Dev_Aek(msg.chat_id_, msg.id_, 1, AEKTEAM, 1, 'md') end
if text == "العربيه" then if DevAek:get(AEK..'Aek:Lock:Arabic'..msg.chat_id_) then lock_arabic = 'مقفوله' else lock_arabic = 'مفتوحه' end local AEKTEAM = "\n" .."✫︙العربيه ↫ "..lock_arabic.."\n" Dev_Aek(msg.chat_id_, msg.id_, 1, AEKTEAM, 1, 'md') end
if text == "الانكليزيه" then if DevAek:get(AEK..'Aek:Lock:English'..msg.chat_id_) then lock_english = 'مقفوله' else lock_english = 'مفتوحه' end local AEKTEAM = "\n" .."✫︙الانكليزيه ↫ "..lock_english.."\n" Dev_Aek(msg.chat_id_, msg.id_, 1, AEKTEAM, 1, 'md') end
if text == "الكفر" then if DevAek:get(AEK..'Aek:Lock:Kfr'..msg.chat_id_) then lock_kaf = 'مفتوح' else lock_kaf = 'مقفل' end local AEKTEAM = "\n" .."✫︙الكفر ↫ "..lock_kaf.."\n" Dev_Aek(msg.chat_id_, msg.id_, 1, AEKTEAM, 1, 'md') end
if text == "الفشار" then if DevAek:get(AEK..'Aek:Lock:Fshar'..msg.chat_id_) then lock_fshar = 'مفتوح' else lock_fshar = 'مقفل' end local AEKTEAM = "\n" .."✫︙الفشار ↫ "..lock_fshar.."\n" Dev_Aek(msg.chat_id_, msg.id_, 1, AEKTEAM, 1, 'md') end
if text == "الطائفيه" then if DevAek:get(AEK..'Aek:Lock:Taf'..msg.chat_id_) then lock_taf = 'مفتوحه' else lock_taf = 'مقفله' end local AEKTEAM = "\n" .."✫︙الطائفيه ↫ "..lock_taf.."\n" Dev_Aek(msg.chat_id_, msg.id_, 1, AEKTEAM, 1, 'md') end
end

if text == 'تفعيل كشف الاعدادات' and SourcelionCh(msg) then 
local AEKTEAM = '✫︙اهلا عزيزي ↫ '..AekRank(msg)..' \n✫︙تم تفعيل كشف الاعدادات'
Aekmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, AEKTEAM, 14, string.len(msg.sender_user_id_))
DevAek:set(AEK..'Aek:LockSettings'..msg.chat_id_,true)  
end
if text == 'تعطيل كشف الاعدادات' and SourcelionCh(msg) then 
local AEKTEAM = '✫︙اهلا عزيزي ↫ '..AekRank(msg)..' \n✫︙تم تعطيل كشف الاعدادات'
Aekmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, AEKTEAM, 14, string.len(msg.sender_user_id_))
DevAek:del(AEK..'Aek:LockSettings'..msg.chat_id_) 
end

if text == 'تفعيل اوامر التحشيش' and Manager(msg) and SourcelionCh(msg) then 
local AEKTEAM = '✫︙اهلا عزيزي ↫ '..AekRank(msg)..' \n✫︙تم تفعيل اوامر التحشيش'
Aekmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, AEKTEAM, 14, string.len(msg.sender_user_id_))
DevAek:del(AEK..'Aek:Lock:Stupid'..msg.chat_id_)
end
if text == 'تعطيل اوامر التحشيش' and Manager(msg) and SourcelionCh(msg) then 
local AEKTEAM = '✫︙اهلا عزيزي ↫ '..AekRank(msg)..' \n✫︙تم تعطيل اوامر التحشيش'
Aekmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, AEKTEAM, 14, string.len(msg.sender_user_id_))
DevAek:set(AEK..'Aek:Lock:Stupid'..msg.chat_id_,true)
end

if text == 'تفعيل ردود المدير' and Manager(msg) and SourcelionCh(msg) then 
local AEKTEAM = '✫︙اهلا عزيزي ↫ '..AekRank(msg)..' \n✫︙تم تفعيل ردود المدير'
Aekmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, AEKTEAM, 14, string.len(msg.sender_user_id_))
DevAek:del(AEK..'Aek:Lock:GpRed'..msg.chat_id_)
end
if text == 'تعطيل ردود المدير' and Manager(msg) and SourcelionCh(msg) then 
local AEKTEAM = '✫︙اهلا عزيزي ↫ '..AekRank(msg)..' \n✫︙تم تعطيل ردود المدير'
Aekmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, AEKTEAM, 14, string.len(msg.sender_user_id_))
DevAek:set(AEK..'Aek:Lock:GpRed'..msg.chat_id_,true)
end

if text == 'تفعيل ردود المطور' and Manager(msg) and SourcelionCh(msg) then 
local AEKTEAM = '✫︙اهلا عزيزي ↫ '..AekRank(msg)..' \n✫︙تم تفعيل ردود المطور'
Aekmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, AEKTEAM, 14, string.len(msg.sender_user_id_))
DevAek:del(AEK..'Aek:Lock:AllRed'..msg.chat_id_)
end
if text == 'تعطيل ردود المطور' and Manager(msg) and SourcelionCh(msg) then 
local AEKTEAM = '✫︙اهلا عزيزي ↫ '..AekRank(msg)..' \n✫︙تم تعطيل ردود المطور'
Aekmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, AEKTEAM, 14, string.len(msg.sender_user_id_))
DevAek:set(AEK..'Aek:Lock:AllRed'..msg.chat_id_,true)
end

if SecondSudo(msg) then
if text == 'تفعيل المغادره' or text == '↫ تفعيل المغادره ✫' then 
local AEKTEAM = '✫︙اهلا عزيزي ↫ '..AekRank(msg)..' \n✫︙تم تفعيل المغادره بنجاح'
Aekmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, AEKTEAM, 14, string.len(msg.sender_user_id_))
DevAek:del(AEK.."Aek:Left:Bot"..AEK)
end
if text == 'تعطيل المغادره' or text == '↫ تعطيل المغادره ✫' then 
local AEKTEAM = '✫︙اهلا عزيزي ↫ '..AekRank(msg)..' \n✫︙تم تعطيل المغادره بنجاح'
Aekmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, AEKTEAM, 14, string.len(msg.sender_user_id_))
DevAek:set(AEK.."Aek:Left:Bot"..AEK,true) 
end 
if text == 'تفعيل الاذاعه' or text == '↫ تفعيل الاذاعه ✫' then 
local AEKTEAM = '✫︙اهلا عزيزي ↫ '..AekRank(msg)..' \n✫︙تم تفعيل الاذاعه بنجاح'
Aekmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, AEKTEAM, 14, string.len(msg.sender_user_id_))
DevAek:del(AEK.."Aek:Send:Bot"..AEK)
end
if text == 'تعطيل الاذاعه' or text == '↫ تعطيل الاذاعه ✫' then 
local AEKTEAM = '✫︙اهلا عزيزي ↫ '..AekRank(msg)..' \n✫︙تم تعطيل الاذاعه بنجاح'
Aekmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, AEKTEAM, 14, string.len(msg.sender_user_id_))
DevAek:set(AEK.."Aek:Send:Bot"..AEK,true) 
end
end

if text and text:match("^ضع اسم (.*)$") and Manager(msg) and SourcelionCh(msg) then
local txt = {string.match(text, "^(ضع اسم) (.*)$")}
tdcli_function ({ ID = "ChangeChatTitle",chat_id_ = msg.chat_id_,title_ = txt[2] },function(arg,data) 
if data.message_ == "Channel chat title can be changed by administrators only" then
send(msg.chat_id_,msg.id_,"✫︙البوت ليس ادمن يرجى ترقيتي !")  
return false  
end 
if data.message_ == "CHAT_ADMIN_REQUIRED" then
send(msg.chat_id_,msg.id_,"✫︙ليست لدي صلاحية تغير معلومات المجموعه يرجى التحقق من الصلاحيات")  
else
local AEKTEAM = '✫︙اهلا عزيزي ↫ '..AekRank(msg)..' \n✫︙تم تغير اسم المجموعه'
Aekmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, AEKTEAM, 14, string.len(msg.sender_user_id_))
end
end,nil) 
end

if msg.content_.photo_ then
if DevAek:get(AEK..'Aek:SetPhoto'..msg.chat_id_..':'..msg.sender_user_id_) then
if msg.content_.photo_.sizes_[3] then
photo_id = msg.content_.photo_.sizes_[3].photo_.persistent_id_
else
photo_id = msg.content_.photo_.sizes_[0].photo_.persistent_id_
end
tdcli_function ({ID = "ChangeChatPhoto",chat_id_ = msg.chat_id_,photo_ = getInputFile(photo_id) }, function(arg,data)   
if data.code_ == 3 then
send(msg.chat_id_, msg.id_,"✫︙عذرا البوت ليس ادمن يرجى ترقيتي والمحاوله لاحقا") 
DevAek:del(AEK..'Aek:SetPhoto'..msg.chat_id_..':'..msg.sender_user_id_)
return false  end
if data.message_ == "CHAT_ADMIN_REQUIRED" then 
send(msg.chat_id_, msg.id_,"✫︙ليست لدي صلاحية تغير معلومات المجموعه يرجى التحقق من الصلاحيات") 
DevAek:del(AEK..'Aek:SetPhoto'..msg.chat_id_..':'..msg.sender_user_id_)
else
local AEKTEAM = '✫︙اهلا عزيزي ↫ '..AekRank(msg)..' \n✫︙تم تغير صورة المجموعه'
Aekmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, AEKTEAM, 14, string.len(msg.sender_user_id_))
end
end,nil) 
DevAek:del(AEK..'Aek:SetPhoto'..msg.chat_id_..':'..msg.sender_user_id_)
end 
end
if text and text:match("^ضع صوره$") and SourcelionCh(msg) or text and text:match("^وضع صوره$") and SourcelionCh(msg) then
Dev_Aek(msg.chat_id_,msg.id_, 1, '✫︙ارسل صورة المجموعه الان', 1, 'md')
DevAek:set(AEK..'Aek:SetPhoto'..msg.chat_id_..':'..msg.sender_user_id_,true)
end

if text and text:match("^حذف الصوره$") and SourcelionCh(msg) or text and text:match("^مسح الصوره$") and SourcelionCh(msg) then
https.request("https://api.telegram.org/bot"..TokenBot.."/deleteChatPhoto?chat_id="..msg.chat_id_) 
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم حذف صورة المجموعه")  
return false  
end

if Manager(msg) then
if text and text:match("^الغاء تثبيت$") and SourcelionCh(msg) or text and text:match("^الغاء التثبيت$") and SourcelionCh(msg) then
if DevAek:sismember(AEK.."Aek:Lock:Pinpin",msg.chat_id_) and not BasicConstructor(msg) then
Dev_Aek(msg.chat_id_,msg.id_, 1, "✫︙التثبيت والغاء واعادة التثبيت تم قفله من قبل المنشئين الاساسيين", 1, 'md')
return false  
end
tdcli_function({ID="UnpinChannelMessage",channel_id_ = msg.chat_id_:gsub("-100","")},function(arg,data) 
if data.ID == "Ok" then
DevAek:del(AEK..'Aek:PinnedMsg'..msg.chat_id_)
local AEKTEAM = '✫︙اهلا عزيزي ↫ '..AekRank(msg)..' \n✫︙تم الغاء تثبيت الرساله'
Aekmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, AEKTEAM, 14, string.len(msg.sender_user_id_))
return false  
end
if data.code_ == 6 then
send(msg.chat_id_,msg.id_,"✫︙انا لست ادمن هنا يرجى ترقيتي ادمن ثم اعد المحاوله")  
return false  
end
if data.message_ == "CHAT_ADMIN_REQUIRED" then
send(msg.chat_id_,msg.id_,"✫︙ليست لدي صلاحية التثبيت يرجى التحقق من الصلاحيات")  
return false  
end
end,nil)
end

if text and text:match("^الغاء تثبيت الكل$") then  
if DevAek:sismember(AEK.."Aek:Lock:Pinpin",msg.chat_id_) and not BasicConstructor(msg) then
Dev_Aek(msg.chat_id_,msg.id_, 1, "✫︙التثبيت والغاء واعادة التثبيت تم قفله من قبل المنشئين الاساسيين", 1, 'md')
return false  
end
tdcli_function({ID="UnpinChannelMessage",channel_id_ = msg.chat_id_:gsub("-100","")},function(arg,data) 
if data.ID == "Ok" then
local AEKTEAM = '✫︙اهلا عزيزي ↫ '..AekRank(msg)..' \n✫︙تم الغاء تثبيت الكل'
Aekmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, AEKTEAM, 14, string.len(msg.sender_user_id_))
https.request('https://api.telegram.org/bot'..TokenBot..'/unpinAllChatMessages?chat_id='..msg.chat_id_)
DevAek:del(AEK.."Aek:PinnedMsg"..msg.chat_id_)
return false  
end
if data.code_ == 6 then
send(msg.chat_id_,msg.id_,"✫︙انا لست ادمن هنا يرجى ترقيتي ادمن ثم اعد المحاوله")  
return false  
end
if data.message_ == "CHAT_ADMIN_REQUIRED" then
send(msg.chat_id_,msg.id_,"✫︙ليست لدي صلاحية التثبيت يرجى التحقق من الصلاحيات")  
return false  
end
end,nil)
end

if text and text:match("^اعاده تثبيت$") and SourcelionCh(msg) or text and text:match("^اعاده التثبيت$") and SourcelionCh(msg) or text and text:match("^اعادة التثبيت$") and SourcelionCh(msg) then
if DevAek:sismember(AEK.."Aek:Lock:Pinpin",msg.chat_id_) and not BasicConstructor(msg) then
Dev_Aek(msg.chat_id_,msg.id_, 1, "✫︙التثبيت والغاء واعادة التثبيت تم قفله من قبل المنشئين الاساسيين", 1, 'md')
return false  
end
local pin_id = DevAek:get(AEK..'Aek:PinnedMsg'..msg.chat_id_)
if pin_id then
pin(msg.chat_id_,pin_id,0)
local AEKTEAM = '✫︙اهلا عزيزي ↫ '..AekRank(msg)..' \n✫︙تم اعادة تثبيت الرساله'
Aekmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, AEKTEAM, 14, string.len(msg.sender_user_id_))
end end
end

if text == 'طرد المحذوفين' or text == 'مسح المحذوفين' or text == 'طرد الحسابات المحذوفه' or text == 'حذف المحذوفين' then  
tdcli_function({ID = "GetChannelMembers",channel_id_ = msg.chat_id_:gsub("-100",""),offset_ = 0,limit_ = 1000}, function(arg,del)
for k, v in pairs(del.members_) do
tdcli_function({ID = "GetUser",user_id_ = v.user_id_},function(b,data) 
if data.first_name_ == false then
ChatKick(msg.chat_id_, data.id_)
end
end,nil)
end
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم طرد المحذوفين")  
end,nil)
end

if text and text:match("^مسح المحظورين$") or text and text:match("^حذف المحظورين$") and SourcelionCh(msg) or text and text:match("^مسح المطرودين$") or text and text:match("^حذف المطرودين$") and SourcelionCh(msg) then
local function RemoveBlockList(extra, result)
if tonumber(result.total_count_) == 0 then 
Dev_Aek(msg.chat_id_, msg.id_, 0,'✫︙*لا يوجد محظورين*', 1, 'md')
DevAek:del(AEK..'Aek:Ban:'..msg.chat_id_)
else
local x = 0
for x,y in pairs(result.members_) do
tdcli_function ({ ID = "ChangeChatMemberStatus", chat_id_ = msg.chat_id_, user_id_ = y.user_id_, status_ = { ID = "ChatMemberStatusLeft" }, }, dl_cb, nil)
DevAek:del(AEK..'Aek:Ban:'..msg.chat_id_)
x = x + 1
end
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم حذف المحظورين")  
end
end
tdcli_function({ID="GetChannelMembers",channel_id_ = msg.chat_id_:gsub("-100",""),filter_ = {ID = "ChannelMembersKicked"},offset_ = 0,limit_ = 200}, RemoveBlockList, {chat_id_ = msg.chat_id_, msg_id_ = msg.id_})    
end
end

if text and text:match("^معلومات المجموعه$") and SourcelionCh(msg) or text and text:match("^عدد الاعضاء$") and SourcelionCh(msg) or text and text:match("^عدد الكروب$") and SourcelionCh(msg) or text and text:match("^عدد الادمنيه$") and SourcelionCh(msg) or text and text:match("^عدد المحظورين$") and SourcelionCh(msg) then
local Muted = DevAek:scard(AEK.."Aek:Muted:"..msg.chat_id_) or "0"
tdcli_function({ID ="GetChat",chat_id_=msg.chat_id_},function(arg,dp) 
tdcli_function({ID="GetChannelFull",channel_id_ = msg.chat_id_:gsub("-100","")},function(arg,data) 
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙المجموعه ↫ ❨ '..dp.title_..' ❩\n✫︙الايدي ↫ ❨ '..msg.chat_id_..' ❩\n✫︙عدد الاعضاء ↫ ❨ *'..data.member_count_..'* ❩\n✫︙عدد الادمنيه ↫ ❨ *'..data.administrator_count_..'* ❩\n✫︙عدد المطرودين ↫ ❨ *'..data.kicked_count_..'* ❩\n✫︙عدد المكتومين ↫ ❨ *'..Muted..'* ❩\n✫︙عدد رسائل المجموعه ↫ ❨ *'..(msg.id_/2097152/0.5)..'* ❩\n━───━ ✫ ━───━\n', 1, 'md') 
end,nil)
end,nil)
end

if text and text:match('^كشف (-%d+)') then
local ChatId = text:match('كشف (-%d+)') 
if not SudoBot(msg) then
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙للمطورين فقط', 1, 'md')
else
local ConstructorList = DevAek:scard(AEK.."Aek:Constructor:"..ChatId) or 0
local BanedList = DevAek:scard(AEK.."Aek:Ban:"..ChatId) or 0
local ManagerList = DevAek:scard(AEK.."Aek:Managers:"..ChatId) or 0
local MutedList = DevAek:scard(AEK.."Aek:Muted:"..ChatId) or 0
local TkeedList = DevAek:scard(AEK.."Aek:Aek:Tkeed:"..ChatId) or 0
local AdminsList = DevAek:scard(AEK.."Aek:Admins:"..ChatId) or 0
local VipList = DevAek:scard(AEK.."Aek:VipMem:"..ChatId) or 0
local LinkGp = json:decode(https.request('https://api.telegram.org/bot'..TokenBot..'/exportChatInviteLink?chat_id='..ChatId))
if LinkGp.ok == true then LinkGroup = LinkGp.result else LinkGroup = 't.me/HH_418' end
tdcli_function({ID ="GetChat",chat_id_=ChatId},function(arg,dp)
tdcli_function ({ID = "GetChannelMembers",channel_id_ = ChatId:gsub("-100",""),filter_ = {ID = "ChannelMembersAdministrators"},offset_ = 0,limit_ = 100},function(arg,data) 
if dp.id_ then
local admins = data.members_
for i=0 , #admins do
if data.members_[i].status_.ID == "ChatMemberStatusCreator" then
Manager_id = admins[i].user_id_
tdcli_function ({ID = "GetUser",user_id_ = Manager_id},function(arg,Aek) 
if Aek.first_name_ ~= false then
ConstructorAek = "["..Aek.first_name_.."](T.me/"..(Aek.username_ or "HH_418")..")"
else 
ConstructorAek = "حساب محذوف"
end
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙المجموعه ↫ ["..dp.title_.."]("..LinkGroup..")\n✫︙الايدي ↫ ( `"..ChatId.."` )\n✫︙المنشئ ↫ "..ConstructorAek.."\n✫︙عدد المدراء ↫ ( *"..ManagerList.."* )\n✫︙عدد المنشئين ↫ ( *"..ConstructorList.."* )\n✫︙عدد الادمنيه ↫ ( *"..AdminsList.."* )\n✫︙عدد المميزين ↫ ( *"..VipList.."* )\n✫︙عدد المحظورين ↫ ( *"..BanedList.."* )\n✫︙عدد المقيدين ↫ ( *"..TkeedList.."* )\n✫︙عدد المكتومين ↫ ( *"..MutedList.."* )", 1,"md")
end,nil)
end
end
else
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙لم تتم اضافتي بها لاقوم بكشفها", 1, "md")
end
end,nil)
end,nil)
end 
end

if text and text:match("^غادر (-%d+)$")  then
local Text = { string.match(text, "^(غادر) (-%d+)$")}
if not SecondSudo(msg) then
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙للمطور الاساسي فقط', 1, 'md')
else 
tdcli_function({ID ="GetChat",chat_id_=Text[2]},function(arg,dp) 
if dp.id_ then
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙المجموعه ↫ ["..dp.title_.."]\n✫︙تمت المغادره منها بنجاح", 1, "md")
Dev_Aek(Text[2], 0, 1, "✫︙بامر المطور تم مغادرة هذه المجموعه ", 1, "md")  
ChatLeave(dp.id_, AEK)
DevAek:srem(AEK.."Aek:Groups", dp.id_)
else
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙لم تتم اضافتي بها لاقوم بمغادرتها", 1, "md")
end 
end,nil)
end 
end

if text and text:match("^تعين عدد الاعضاء (%d+)$") and SecondSudo(msg) or text and text:match("^تعيين عدد الاعضاء (%d+)$") and SecondSudo(msg) then
local Num = text:match("تعين عدد الاعضاء (%d+)$") or text:match("تعيين عدد الاعضاء (%d+)$")
DevAek:set(AEK..'Aek:Num:Add:Bot',Num) 
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙تم وضع عدد الاعضاء ↫ *'..Num..'* عضو', 1, 'md')
end

if text == 'تفعيل البوت الخدمي' then 
if not SecondSudo(msg) then
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙للمطور الاساسي فقط', 1, 'md')
else 
local AEKTEAM = '✫︙اهلا عزيزي ↫ '..AekRank(msg)..' \n✫︙تم تفعيل البوت الخدمي'
Aekmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, AEKTEAM, 14, string.len(msg.sender_user_id_))
DevAek:del(AEK..'Aek:Lock:FreeBot'..AEK) 
end 
end
if text == 'تعطيل البوت الخدمي' then 
if not SecondSudo(msg) then
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙للمطور الاساسي فقط', 1, 'md')
else 
local AEKTEAM = '✫︙اهلا عزيزي ↫ '..AekRank(msg)..' \n✫︙تم تعطيل البوت الخدمي'
Aekmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, AEKTEAM, 14, string.len(msg.sender_user_id_))
DevAek:set(AEK..'Aek:Lock:FreeBot'..AEK,true) 
end 
end
if ChatType == 'sp' or ChatType == 'gp'  then
if text == 'تفعيل الالعاب' and Manager(msg) and SourcelionCh(msg) or text == 'تفعيل اللعبه' and Manager(msg) and SourcelionCh(msg) then   
local AEKTEAM = '✫︙اهلا عزيزي ↫ '..AekRank(msg)..' \n✫︙تم تفعيل الالعاب بنجاح'
Aekmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, AEKTEAM, 14, string.len(msg.sender_user_id_))
DevAek:del(AEK..'Aek:Lock:Games'..msg.chat_id_) 
end
if text == 'تعطيل الالعاب' and Manager(msg) and SourcelionCh(msg) or text == 'تعطيل اللعبه' and Manager(msg) and SourcelionCh(msg) then  
local AEKTEAM = '✫︙اهلا عزيزي ↫ '..AekRank(msg)..' \n✫︙تم تعطيل الالعاب بنجاح'
Aekmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, AEKTEAM, 14, string.len(msg.sender_user_id_))
DevAek:set(AEK..'Aek:Lock:Games'..msg.chat_id_,true)  
end
if text == "تفعيل الرابط" or text == "تفعيل جلب الرابط" then 
if Admin(msg) then
local AEKTEAM = '✫︙اهلا عزيزي ↫ '..AekRank(msg)..' \n✫︙تم تفعيل جلب رابط المجموعه'
Aekmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, AEKTEAM, 14, string.len(msg.sender_user_id_))
DevAek:del(AEK.."Aek:Lock:GpLinks"..msg.chat_id_)
return false  
end
end
if text == "تعطيل الرابط" or text == "تعطيل جلب الرابط" then 
if Admin(msg) then
local AEKTEAM = '✫︙اهلا عزيزي ↫ '..AekRank(msg)..' \n✫︙تم تعطيل جلب رابط المجموعه'
Aekmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, AEKTEAM, 14, string.len(msg.sender_user_id_))
DevAek:set(AEK.."Aek:Lock:GpLinks"..msg.chat_id_,"ok")
return false  
end
end

if text and text:match('^تفعيل$') and SudoBot(msg) and SourcelionCh(msg) then
if ChatType ~= 'sp' then
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙المجموعه عاديه وليست خارقه لا تستطيع تفعيلي يرجى ان تضع سجل رسائل المجموعه ضاهر وليس مخفي ومن بعدها يمكنك رفعي ادمن ثم تفعيلي', 1, 'md')
return false
end
if msg.can_be_deleted_ == false then 
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙البوت ليس ادمن يرجى ترقيتي !', 1, 'md')
return false  
end
tdcli_function ({ ID = "GetChannelFull", channel_id_ = msg.chat_id_:gsub("-100","")}, function(arg,data)  
if tonumber(data.member_count_) < tonumber(DevAek:get(AEK..'Aek:Num:Add:Bot') or 0) and not SecondSudo(msg) then
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙عدد اعضاء المجموعه اقل من ↫ *'..(DevAek:get(AEK..'Aek:Num:Add:Bot') or 0)..'* عضو', 1, 'md')
return false
end
tdcli_function ({ID = "GetUser",user_id_ = msg.sender_user_id_},function(extra,result,success)
tdcli_function({ID ="GetChat",chat_id_=msg.chat_id_},function(arg,dp) 
tdcli_function ({ID = "GetChannelMembers",channel_id_ = msg.chat_id_:gsub("-100",""),filter_ = {ID = "ChannelMembersAdministrators"},offset_ = 0,limit_ = 100},function(arg,Aekan) 
local admins = Aekan.members_
for i=0 , #admins do
if Aekan.members_[i].bot_info_ == false and Aekan.members_[i].status_.ID == "ChatMemberStatusEditor" then
DevAek:sadd(AEK..'Aek:Admins:'..msg.chat_id_, admins[i].user_id_)
tdcli_function ({ID = "GetUser",user_id_ = admins[i].user_id_},function(arg,ba) 
if ba.first_name_ == false then
DevAek:srem(AEK..'Aek:Admins:'..msg.chat_id_, admins[i].user_id_)
end
end,nil)
else
DevAek:sadd(AEK..'Aek:Admins:'..msg.chat_id_, admins[i].user_id_)
end
if Aekan.members_[i].status_.ID == "ChatMemberStatusCreator" then
DevAek:sadd(AEK.."Aek:BasicConstructor:"..msg.chat_id_,admins[i].user_id_)
DevAek:sadd(AEK.."Aek:AekConstructor:"..msg.chat_id_,admins[i].user_id_)
tdcli_function ({ID = "GetUser",user_id_ = admins[i].user_id_},function(arg,ba) 
if ba.first_name_ == false then
DevAek:srem(AEK.."Aek:BasicConstructor:"..msg.chat_id_,admins[i].user_id_)
DevAek:srem(AEK.."Aek:AekConstructor:"..msg.chat_id_,admins[i].user_id_)
end
end,nil)  
end 
end
end,nil)
if DevAek:sismember(AEK..'Aek:Groups',msg.chat_id_) then
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙المجموعه بالتاكيد مفعله', 1, 'md')
else
ReplyStatus(msg,result.id_,"ReplyBy","✫︙تم تفعيل المجموعه "..dp.title_)  
DevAek:sadd(AEK.."Aek:Groups",msg.chat_id_)
if not DevAek:get(AEK..'Aek:SudosGp'..msg.sender_user_id_..msg.chat_id_) and not SecondSudo(msg) then 
DevAek:incrby(AEK..'Aek:Sudos'..msg.sender_user_id_,1)
DevAek:set(AEK..'Aek:SudosGp'..msg.sender_user_id_..msg.chat_id_,"Aek")
end
local Name1 = result.first_name_
local Name1 = Name1:gsub('"',"") 
local Name1 = Name1:gsub("'","") 
local Name1 = Name1:gsub("`","") 
local Name1 = Name1:gsub("*","") 
local Name1 = Name1:gsub("{","") 
local Name1 = Name1:gsub("}","") 
local Name = '['..Name1..'](tg://user?id='..result.id_..')'
local NumMem = data.member_count_
local NameChat = dp.title_
local NameChat = NameChat:gsub('"',"") 
local NameChat = NameChat:gsub("'","") 
local NameChat = NameChat:gsub("`","") 
local NameChat = NameChat:gsub("*","") 
local NameChat = NameChat:gsub("{","") 
local NameChat = NameChat:gsub("}","") 
local LinkGp = json:decode(https.request('https://api.telegram.org/bot'..TokenBot..'/exportChatInviteLink?chat_id='..msg.chat_id_))
if LinkGp.ok == true then 
LinkGroup = LinkGp.result
else
LinkGroup = 'لا يوجد'
end
DevAek:set(AEK.."Aek:Groups:Links"..msg.chat_id_,LinkGroup) 
if not Sudo(msg) then
SendText(DevId,"✫︙تم تفعيل مجموعه جديده ↫ ⤈ \n━───━ ✫ ━───━\n✫︙بواسطة ↫ "..Name.."\n✫︙اسم المجموعه ↫ ["..NameChat.."]\n✫︙عدد اعضاء المجموعه ↫ ❨ *"..NumMem.."* ❩\n✫︙ايدي المجموعه ↫ ⤈ \n❨ `"..msg.chat_id_.."` ❩\n✫︙رابط المجموعه ↫ ⤈\n❨ ["..LinkGroup.."] ❩\n━───━ ✫ ━───━\n✫︙الوقت ↫ "..os.date("%I:%M%p").."\n✫︙التاريخ ↫ "..os.date("%Y/%m/%d").."",0,'md')
end
end
end,nil)
end,nil)
end,nil)
end
if text == 'تعطيل' and SudoBot(msg) and ChCheck(msg) then
tdcli_function ({ID = "GetUser",user_id_ = msg.sender_user_id_},function(extra,result,success)
tdcli_function({ID ="GetChat",chat_id_=msg.chat_id_},function(arg,dp) 
if not DevAek:sismember(AEK..'Aek:Groups',msg.chat_id_) then
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙المجموعه بالتاكيد معطله', 1, 'md')
else
ReplyStatus(msg,result.id_,"ReplyBy","✫︙تم تعطيل المجموعه "..dp.title_)  
DevAek:srem(AEK.."Aek:Groups",msg.chat_id_)
local Name1 = result.first_name_
local Name1 = Name1:gsub('"',"") 
local Name1 = Name1:gsub("'","") 
local Name1 = Name1:gsub("`","") 
local Name1 = Name1:gsub("*","") 
local Name1 = Name1:gsub("{","") 
local Name1 = Name1:gsub("}","") 
local Name = '['..Name1..'](tg://user?id='..result.id_..')'
local NameChat = dp.title_
local NameChat = NameChat:gsub('"',"") 
local NameChat = NameChat:gsub("'","") 
local NameChat = NameChat:gsub("`","") 
local NameChat = NameChat:gsub("*","") 
local NameChat = NameChat:gsub("{","") 
local NameChat = NameChat:gsub("}","") 
local LinkGp = json:decode(https.request('https://api.telegram.org/bot'..TokenBot..'/exportChatInviteLink?chat_id='..msg.chat_id_))
if LinkGp.ok == true then 
LinkGroup = LinkGp.result
else
LinkGroup = 'لا يوجد'
end
DevAek:set(AEK.."Aek:Groups:Links"..msg.chat_id_,LinkGroup) 
if not Sudo(msg) then
SendText(DevId,"✫︙تم تعطيل مجموعه جديده ↫ ⤈ \n━───━ ✫ ━───━\n✫︙بواسطة ↫ "..Name.."\n✫︙اسم المجموعه ↫ ["..NameChat.."]\n✫︙ايدي المجموعه ↫ ⤈ \n❨ `"..msg.chat_id_.."` ❩\n✫︙رابط المجموعه ↫ ⤈\n❨ ["..LinkGroup.."] ❩\n━───━ ✫ ━───━\n✫︙الوقت ↫ "..os.date("%I:%M%p").."\n✫︙التاريخ ↫ "..os.date("%Y/%m/%d").."",0,'md')
end
end
end,nil)
end,nil)
end
end

if text and text:match("^المطور$") and SourcelionCh(msg) then
tdcli_function ({ID = "GetUser",user_id_ = msg.sender_user_id_},function(extra,result,success)
tdcli_function({ID ="GetChat",chat_id_=msg.chat_id_},function(arg,dp) 
local Name1 = result.first_name_
local Name1 = Name1:gsub('"',"") 
local Name1 = Name1:gsub("'","") 
local Name1 = Name1:gsub("`","") 
local Name1 = Name1:gsub("*","") 
local Name1 = Name1:gsub("{","") 
local Name1 = Name1:gsub("}","") 
local Name = '['..Name1..'](tg://user?id='..result.id_..')'
local NameChat = dp.title_
local NameChat = NameChat:gsub('"',"") 
local NameChat = NameChat:gsub("'","") 
local NameChat = NameChat:gsub("`","") 
local NameChat = NameChat:gsub("*","") 
local NameChat = NameChat:gsub("{","") 
local NameChat = NameChat:gsub("}","") 
local LinkGp = json:decode(https.request('https://api.telegram.org/bot'..TokenBot..'/exportChatInviteLink?chat_id='..msg.chat_id_))
if LinkGp.ok == true then 
LinkGroup = LinkGp.result
else
LinkGroup = 'لا يوجد'
end
if not Sudo(msg) then
SendText(DevId,"✫︙هناك من بحاجه الى مساعده ↫ ⤈ \n━───━ ✫ ━───━\n✫︙الشخص ↫ "..Name.."\n✫︙اسم المجموعه ↫ ["..NameChat.."]\n✫︙ايدي المجموعه ↫ ⤈ \n❨ `"..msg.chat_id_.."` ❩\n✫︙رابط المجموعه ↫ ⤈\n❨ ["..LinkGroup.."] ❩\n━───━ ✫ ━───━\n✫︙الوقت ↫ "..os.date("%I:%M%p").."\n✫︙التاريخ ↫ "..os.date("%Y/%m/%d").."",0,'md')
end
end,nil)
end,nil)
end

if text == 'جلب نسخه السورس' then
if not SecondSudo(msg) then
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙للمطور الاساسي فقط ', 1, 'md')
else
sendDocument(DevId, 0, 0, 1, nil, './AEK.lua', dl_cb, nil)
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙عزيزي المطور تم ارسال نسخة ملف السورس الى الخاص', 1, 'md')
end end

if text == 'روابط الكروبات' or text == 'روابط المجموعات' then
if not SecondSudo(msg) then
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙للمطور الاساسي فقط ', 1, 'md')
else
local List = DevAek:smembers(AEK.."Aek:Groups")
if #List == 0 then
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙لا يوجد مجموعات مفعله', 1, 'md')
else
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙جاري ارسال نسخه تحتوي على '..#List..' مجموعه', 1, 'md')
local text = "✫︙Source AEK\n✫︙File Bot Groups\n━───━ ✫ ━───━\n"
for k,v in pairs(List) do
local GroupsManagers = DevAek:scard(AEK.."Aek:Managers:"..v) or 0
local GroupsAdmins = DevAek:scard(AEK.."Aek:Admins:"..v) or 0
local Groupslink = DevAek:get(AEK.."Aek:Groups:Links" ..v)
text = text..k.." ↬ ⤈ \n✫︙Group ID ↬ "..v.."\n✫︙Group Link ↬ "..(Groupslink or "Not Found").."\n✫︙Group Managers ↬ "..GroupsManagers.."\n✫︙Group Admins ↬ "..GroupsAdmins.."\n━───━ ✫ ━───━\n"
end
local File = io.open('GroupsBot.txt', 'w')
File:write(text)
File:close()
local Aekan = 'https://api.telegram.org/bot' .. TokenBot .. '/sendDocument'
local curl = 'curl "' .. Aekan .. '" -F "chat_id=' .. msg.chat_id_ .. '" -F "document=@' .. 'GroupsBot.txt' .. '"'
io.popen(curl)
end
end
end

if text == "اذاعه بالخاص" and msg.reply_to_message_id_ == 0 and SudoBot(msg) or text == "↫ اذاعه خاص ✫" and msg.reply_to_message_id_ == 0 and SudoBot(msg) then 
if DevAek:get(AEK.."Aek:Send:Bot"..AEK) and not SecondSudo(msg) then 
send(msg.chat_id_, msg.id_,"✫︙الاذاعه معطله من قبل المطور الاساسي")
return false
end
DevAek:setex(AEK.."Aek:Send:Pv" .. msg.chat_id_ .. ":" .. msg.sender_user_id_, 600, true) 
local AEKTEAM = '✫︙اهلا عزيزي ↫ '..AekRank(msg)..' \n✫︙ارسل لي سواء ↫ ⤈ \n❨ ملف • ملصق • متحركه • صوره\n • فيديو • بصمه • صوت • رساله ❩\n✫︙للخروج ارسل ↫ ( الغاء ) \n ✓'
Aekmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, AEKTEAM, 14, string.len(msg.sender_user_id_))
return false
end 
if DevAek:get(AEK.."Aek:Send:Pv" .. msg.chat_id_ .. ":" .. msg.sender_user_id_) then 
if text == 'الغاء' then   
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙تم الغاء امر الاذاعه بنجاح", 1, 'md')
DevAek:del(AEK.."Aek:Send:Pv" .. msg.chat_id_ .. ":" .. msg.sender_user_id_) 
return false
end 
List = DevAek:smembers(AEK..'Aek:Users') 
if msg.content_.text_ then
for k,v in pairs(List) do 
AekText = "الرساله"
send(v, 0,"["..msg.content_.text_.."]") 
end
elseif msg.content_.photo_ then
if msg.content_.photo_.sizes_[0] then
photo = msg.content_.photo_.sizes_[0].photo_.persistent_id_
elseif msg.content_.photo_.sizes_[1] then
photo = msg.content_.photo_.sizes_[1].photo_.persistent_id_
end
for k,v in pairs(List) do 
AekText = "الصوره"
sendPhoto(v, 0, 0, 1, nil, photo,(msg.content_.caption_ or ''))
end 
elseif msg.content_.animation_ then
for k,v in pairs(List) do 
AekText = "المتحركه"
sendDocument(v, 0, 0, 1,nil, msg.content_.animation_.animation_.persistent_id_,(msg.content_.caption_ or ''))    
end 
elseif msg.content_.video_ then
for k,v in pairs(List) do 
AekText = "الفيديو"
sendVideo(v, 0, 0, 1, nil, msg.content_.video_.video_.persistent_id_,(msg.content_.caption_ or '')) 
end 
elseif msg.content_.voice_ then
for k,v in pairs(List) do 
AekText = "البصمه"
sendVoice(v, 0, 0, 1, nil, msg.content_.voice_.voice_.persistent_id_,(msg.content_.caption_ or '')) 
end 
elseif msg.content_.audio_ then
for k,v in pairs(List) do 
AekText = "الصوت"
sendAudio(v, 0, 0, 1, nil, msg.content_.audio_.audio_.persistent_id_,(msg.content_.caption_ or '')) 
end 
elseif msg.content_.document_ then
for k,v in pairs(List) do 
AekText = "الملف"
sendDocument(v, 0, 0, 1,nil, msg.content_.document_.document_.persistent_id_,(msg.content_.caption_ or ''))    
end 
elseif msg.content_.sticker_ then
for k,v in pairs(List) do 
AekText = "الملصق"
sendSticker(v, 0, 0, 1, nil, msg.content_.sticker_.sticker_.persistent_id_)   
end 
end
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙تم اذاعة "..AekText.." بنجاح \n✫︙‏الى ↫ ❨ "..#List.." ❩ مشترك \n ✓", 1, 'md')
DevAek:del(AEK.."Aek:Send:Pv" .. msg.chat_id_ .. ":" .. msg.sender_user_id_) 
end

if text == "اذاعه" and msg.reply_to_message_id_ == 0 and SudoBot(msg) or text == "↫ اذاعه عام ✫" and msg.reply_to_message_id_ == 0 and SudoBot(msg) then 
if DevAek:get(AEK.."Aek:Send:Bot"..AEK) and not SecondSudo(msg) then 
send(msg.chat_id_, msg.id_,"✫︙الاذاعه معطله من قبل المطور الاساسي")
return false
end
DevAek:setex(AEK.."Aek:Send:Gp" .. msg.chat_id_ .. ":" .. msg.sender_user_id_, 600, true) 
local AEKTEAM = '✫︙اهلا عزيزي ↫ '..AekRank(msg)..' \n✫︙ارسل لي سواء ↫ ⤈ \n❨ ملف • ملصق • متحركه • صوره\n • فيديو • بصمه • صوت • رساله ❩\n✫︙للخروج ارسل ↫ ( الغاء ) \n ✓'
Aekmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, AEKTEAM, 14, string.len(msg.sender_user_id_))
return false
end 
if DevAek:get(AEK.."Aek:Send:Gp" .. msg.chat_id_ .. ":" .. msg.sender_user_id_) then 
if text == 'الغاء' then   
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙تم الغاء امر الاذاعه بنجاح", 1, 'md')
DevAek:del(AEK.."Aek:Send:Gp" .. msg.chat_id_ .. ":" .. msg.sender_user_id_) 
return false
end 
List = DevAek:smembers(AEK..'Aek:Groups') 
if msg.content_.text_ then
for k,v in pairs(List) do 
AekText = "الرساله"
send(v, 0,"["..msg.content_.text_.."]") 
end
elseif msg.content_.photo_ then
if msg.content_.photo_.sizes_[0] then
photo = msg.content_.photo_.sizes_[0].photo_.persistent_id_
elseif msg.content_.photo_.sizes_[1] then
photo = msg.content_.photo_.sizes_[1].photo_.persistent_id_
end
for k,v in pairs(List) do 
AekText = "الصوره"
sendPhoto(v, 0, 0, 1, nil, photo,(msg.content_.caption_ or ''))
end 
elseif msg.content_.animation_ then
for k,v in pairs(List) do 
AekText = "المتحركه"
sendDocument(v, 0, 0, 1,nil, msg.content_.animation_.animation_.persistent_id_,(msg.content_.caption_ or ''))    
end 
elseif msg.content_.video_ then
for k,v in pairs(List) do 
AekText = "الفيديو"
sendVideo(v, 0, 0, 1, nil, msg.content_.video_.video_.persistent_id_,(msg.content_.caption_ or '')) 
end 
elseif msg.content_.voice_ then
for k,v in pairs(List) do 
AekText = "البصمه"
sendVoice(v, 0, 0, 1, nil, msg.content_.voice_.voice_.persistent_id_,(msg.content_.caption_ or '')) 
end 
elseif msg.content_.audio_ then
for k,v in pairs(List) do 
AekText = "الصوت"
sendAudio(v, 0, 0, 1, nil, msg.content_.audio_.audio_.persistent_id_,(msg.content_.caption_ or '')) 
end 
elseif msg.content_.document_ then
for k,v in pairs(List) do 
AekText = "الملف"
sendDocument(v, 0, 0, 1,nil, msg.content_.document_.document_.persistent_id_,(msg.content_.caption_ or ''))    
end 
elseif msg.content_.sticker_ then
for k,v in pairs(List) do 
AekText = "الملصق"
sendSticker(v, 0, 0, 1, nil, msg.content_.sticker_.sticker_.persistent_id_)   
end 
end
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙تم اذاعة "..AekText.." بنجاح \n✫︙‏في ↫ ❨ "..#List.." ❩ مجموعه \n ✓", 1, 'md')
DevAek:del(AEK.."Aek:Send:Gp" .. msg.chat_id_ .. ":" .. msg.sender_user_id_) 
end

if text == "اذاعه بالتوجيه" and msg.reply_to_message_id_ == 0 and SudoBot(msg) or text == "↫ اذاعه عام بالتوجيه ✫" and msg.reply_to_message_id_ == 0 and SudoBot(msg) then 
if DevAek:get(AEK.."Aek:Send:Bot"..AEK) and not SecondSudo(msg) then 
send(msg.chat_id_, msg.id_,"✫︙الاذاعه معطله من قبل المطور الاساسي")
return false
end
DevAek:setex(AEK.."Aek:Send:FwdGp" .. msg.chat_id_ .. ":" .. msg.sender_user_id_, 600, true) 
local AEKTEAM = '✫︙اهلا عزيزي ↫ '..AekRank(msg)..' \n✫︙ارسل الرساله الان لتوجيها \n✫︙للخروج ارسل ↫ ( الغاء ) \n ✓'
Aekmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, AEKTEAM, 14, string.len(msg.sender_user_id_))
return false
end 
if DevAek:get(AEK.."Aek:Send:FwdGp" .. msg.chat_id_ .. ":" .. msg.sender_user_id_) then 
if text == 'الغاء' then   
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙تم الغاء امر الاذاعه بنجاح", 1, 'md')
DevAek:del(AEK.."Aek:Send:FwdGp" .. msg.chat_id_ .. ":" .. msg.sender_user_id_) 
return false  
end 
local List = DevAek:smembers(AEK..'Aek:Groups')   
for k,v in pairs(List) do  
tdcli_function({ID="ForwardMessages", chat_id_ = v, from_chat_id_ = msg.chat_id_, message_ids_ = {[0] = msg.id_}, disable_notification_ = 0, from_background_ = 1},function(a,t) end,nil) 
end   
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙تم اذاعة رسالتك بالتوجيه \n✫︙‏في ↫ ❨ "..#List.." ❩ مجموعه \n ✓", 1, 'md')
DevAek:del(AEK.."Aek:Send:FwdGp" .. msg.chat_id_ .. ":" .. msg.sender_user_id_) 
end

if text == "اذاعه خاص بالتوجيه" and msg.reply_to_message_id_ == 0 and SudoBot(msg) or text == "↫ اذاعه خاص بالتوجيه ✫" and msg.reply_to_message_id_ == 0 and SudoBot(msg) then 
if DevAek:get(AEK.."Aek:Send:Bot"..AEK) and not SecondSudo(msg) then 
send(msg.chat_id_, msg.id_,"✫︙الاذاعه معطله من قبل المطور الاساسي")
return false
end
DevAek:setex(AEK.."Aek:Send:FwdPv" .. msg.chat_id_ .. ":" .. msg.sender_user_id_, 600, true) 
local AEKTEAM = '✫︙اهلا عزيزي ↫ '..AekRank(msg)..' \n✫︙ارسل الرساله الان لتوجيها \n✫︙للخروج ارسل ↫ ( الغاء ) \n ✓'
Aekmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, AEKTEAM, 14, string.len(msg.sender_user_id_))
return false
end 
if DevAek:get(AEK.."Aek:Send:FwdPv" .. msg.chat_id_ .. ":" .. msg.sender_user_id_) then 
if text == 'الغاء' then   
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙تم الغاء امر الاذاعه بنجاح", 1, 'md')
DevAek:del(AEK.."Aek:Send:FwdPv" .. msg.chat_id_ .. ":" .. msg.sender_user_id_) 
return false  
end 
local List = DevAek:smembers(AEK..'Aek:Users')   
for k,v in pairs(List) do  
tdcli_function({ID="ForwardMessages", chat_id_ = v, from_chat_id_ = msg.chat_id_, message_ids_ = {[0] = msg.id_}, disable_notification_ = 0, from_background_ = 1},function(a,t) end,nil) 
end   
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙تم اذاعة رسالتك بالتوجيه \n✫︙‏الى ↫ ❨ "..#List.." ❩ مشترك \n ✓", 1, 'md')
DevAek:del(AEK.."Aek:Send:FwdPv" .. msg.chat_id_ .. ":" .. msg.sender_user_id_) 
end

if text == "اذاعه بالتثبيت" and msg.reply_to_message_id_ == 0 and SudoBot(msg) or text == "↫ اذاعه بالتثبيت ✫" and msg.reply_to_message_id_ == 0 and SudoBot(msg) then 
if DevAek:get(AEK.."Aek:Send:Bot"..AEK) and not SecondSudo(msg) then 
send(msg.chat_id_, msg.id_,"✫︙الاذاعه معطله من قبل المطور الاساسي")
return false
end
DevAek:setex(AEK.."Aek:Send:Gp:Pin" .. msg.chat_id_ .. ":" .. msg.sender_user_id_, 600, true) 
local AEKTEAM = '✫︙اهلا عزيزي ↫ '..AekRank(msg)..' \n✫︙ارسل لي سواء ↫ ⤈ \n❨ ملف • ملصق • متحركه • صوره\n • فيديو • بصمه • صوت • رساله ❩\n✫︙للخروج ارسل ↫ ( الغاء ) \n ✓'
Aekmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, AEKTEAM, 14, string.len(msg.sender_user_id_))
return false
end 
if DevAek:get(AEK.."Aek:Send:Gp:Pin" .. msg.chat_id_ .. ":" .. msg.sender_user_id_) then 
if text == "الغاء" then   
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙تم الغاء امر الاذاعه بنجاح", 1, 'md')
DevAek:del(AEK.."Aek:Send:Gp:Pin" .. msg.chat_id_ .. ":" .. msg.sender_user_id_) 
return false
end 
local List = DevAek:smembers(AEK.."Aek:Groups") 
if msg.content_.text_ then
for k,v in pairs(List) do 
AekText = "الرساله"
send(v, 0,"["..msg.content_.text_.."]") 
DevAek:set(AEK..'Aek:PinnedMsgs'..v,msg.content_.text_) 
end
elseif msg.content_.photo_ then
if msg.content_.photo_.sizes_[0] then
photo = msg.content_.photo_.sizes_[0].photo_.persistent_id_
elseif msg.content_.photo_.sizes_[1] then
photo = msg.content_.photo_.sizes_[1].photo_.persistent_id_
end
for k,v in pairs(List) do 
AekText = "الصوره"
sendPhoto(v, 0, 0, 1, nil, photo,(msg.content_.caption_ or ''))
DevAek:set(AEK..'Aek:PinnedMsgs'..v,photo) 
end 
elseif msg.content_.animation_ then
for k,v in pairs(List) do 
AekText = "المتحركه"
sendDocument(v, 0, 0, 1,nil, msg.content_.animation_.animation_.persistent_id_,(msg.content_.caption_ or ''))    
DevAek:set(AEK..'Aek:PinnedMsgs'..v,msg.content_.animation_.animation_.persistent_id_)
end 
elseif msg.content_.video_ then
for k,v in pairs(List) do 
AekText = "الفيديو"
sendVideo(v, 0, 0, 1, nil, msg.content_.video_.video_.persistent_id_,(msg.content_.caption_ or '')) 
DevAek:set(AEK..'Aek:PinnedMsgs'..v,msg.content_.video_.video_.persistent_id_)
end 
elseif msg.content_.voice_ then
for k,v in pairs(List) do 
AekText = "البصمه"
sendVoice(v, 0, 0, 1, nil, msg.content_.voice_.voice_.persistent_id_,(msg.content_.caption_ or '')) 
DevAek:set(AEK..'Aek:PinnedMsgs'..v,msg.content_.voice_.voice_.persistent_id_)
end 
elseif msg.content_.audio_ then
for k,v in pairs(List) do 
AekText = "الصوت"
sendAudio(v, 0, 0, 1, nil, msg.content_.audio_.audio_.persistent_id_,(msg.content_.caption_ or '')) 
DevAek:set(AEK..'Aek:PinnedMsgs'..v,msg.content_.audio_.audio_.persistent_id_)
end 
elseif msg.content_.document_ then
for k,v in pairs(List) do 
AekText = "الملف"
sendDocument(v, 0, 0, 1,nil, msg.content_.document_.document_.persistent_id_,(msg.content_.caption_ or ''))    
DevAek:set(AEK..'Aek:PinnedMsgs'..v,msg.content_.document_.document_.persistent_id_)
end 
elseif msg.content_.sticker_ then
for k,v in pairs(List) do 
AekText = "الملصق"
sendSticker(v, 0, 0, 1, nil, msg.content_.sticker_.sticker_.persistent_id_)   
DevAek:set(AEK..'Aek:PinnedMsgs'..v,msg.content_.sticker_.sticker_.persistent_id_) 
end 
end
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙تم اذاعة "..AekText.." بالتثبيت \n✫︙‏في ↫ ❨ "..#List.." ❩ مجموعه \n ✓", 1, 'md')
DevAek:del(AEK.."Aek:Send:Gp:Pin" .. msg.chat_id_ .. ":" .. msg.sender_user_id_) 
return false
end

if text == 'حذف رد من متعدد' and Manager(msg) and SourcelionCh(msg) or text == 'مسح رد من متعدد' and Manager(msg) and SourcelionCh(msg) then
local List = DevAek:smembers(AEK..'Aek:Manager:GpRedod'..msg.chat_id_)
if #List == 0 then
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙لا توجد ردود متعدده مضافه" ,  1, "md")
return false
end
DevAek:set(AEK..'Aek:Add:GpRedod'..msg.sender_user_id_..msg.chat_id_,'DelGpRedRedod')
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙حسنا ارسل كلمة الرد اولا" ,  1, "md")
return false
end
if text and text:match("^(.*)$") then
local DelGpRedRedod = DevAek:get(AEK..'Aek:Add:GpRedod'..msg.sender_user_id_..msg.chat_id_)
if DelGpRedRedod == 'DelGpRedRedod' then
if text == "الغاء" then 
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙تم الغاء الامر" ,  1, "md")
DevAek:del(AEK..'Aek:Add:GpRedod'..msg.sender_user_id_..msg.chat_id_)
return false
end
if not DevAek:sismember(AEK..'Aek:Manager:GpRedod'..msg.chat_id_,text) then
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙لايوجد رد متعدد لهذه الكلمه ↫ "..text ,  1, "md")
return false
end
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙قم بارسال الرد المتعدد الذي تريد حذفه من الكلمه ↫ "..text ,  1, "md")
DevAek:set(AEK..'Aek:Add:GpRedod'..msg.sender_user_id_..msg.chat_id_,'DelGpRedRedods')
DevAek:set(AEK..'Aek:Add:GpTexts'..msg.sender_user_id_..msg.chat_id_,text)
return false
end end
if text == 'حذف رد متعدد' and Manager(msg) and SourcelionCh(msg) or text == 'مسح رد متعدد' and Manager(msg) and SourcelionCh(msg) then
local List = DevAek:smembers(AEK..'Aek:Manager:GpRedod'..msg.chat_id_)
if #List == 0 then
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙لا توجد ردود متعدده مضافه" ,  1, "md")
return false
end
DevAek:set(AEK..'Aek:Add:GpRedod'..msg.sender_user_id_..msg.chat_id_,'DelGpRedod')
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙حسنا ارسل الكلمه لحذفها" ,  1, "md")
return false
end
if text == 'اضف رد متعدد' and Manager(msg) and SourcelionCh(msg) then
DevAek:set(AEK..'Aek:Add:GpRedod'..msg.sender_user_id_..msg.chat_id_,'SetGpRedod')
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙حسنا ارسل الكلمه الان" ,  1, "md")
return false
end
if text and text:match("^(.*)$") then
local SetGpRedod = DevAek:get(AEK..'Aek:Add:GpRedod'..msg.sender_user_id_..msg.chat_id_)
if SetGpRedod == 'SetGpRedod' then
if text == "الغاء" then 
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙تم الغاء الامر" ,  1, "md")
DevAek:del(AEK..'Aek:Add:GpRedod'..msg.sender_user_id_..msg.chat_id_)
return false
end
if DevAek:sismember(AEK..'Aek:Manager:GpRedod'..msg.chat_id_,text) then
local Aek = "✫︙لاتستطيع اضافة رد بالتاكيد مضاف في القائمه قم بحذفه اولا !"
keyboard = {} 
keyboard.inline_keyboard = {{{text="حذف الرد ↫ "..text,callback_data="/DelRed:"..msg.sender_user_id_..text}}} 
Msg_id = msg.id_/2097152/0.5
https.request("https://api.telegram.org/bot"..TokenBot..'/sendMessage?chat_id='..msg.chat_id_..'&text=' .. URL.escape(Aek).."&reply_to_message_id="..Msg_id.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
DevAek:del(AEK..'Aek:Add:GpRedod'..msg.sender_user_id_..msg.chat_id_)
return false
end
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙تم حفظ الامر ارسل الرد الاول\n✫︙للخروج ارسل ↫ ( الغاء )" ,  1, "md")
DevAek:set(AEK..'Aek:Add:GpRedod'..msg.sender_user_id_..msg.chat_id_,'SaveGpRedod')
DevAek:set(AEK..'Aek:Add:GpTexts'..msg.sender_user_id_..msg.chat_id_,text)
DevAek:sadd(AEK..'Aek:Manager:GpRedod'..msg.chat_id_,text)
return false
end end

if text == 'حذف رد' and Manager(msg) and SourcelionCh(msg) or text == 'مسح رد' and  Manager(msg) and SourcelionCh(msg) then
DevAek:set(AEK..'Aek:Add:GpRed'..msg.sender_user_id_..''..msg.chat_id_,'DelGpRed')
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙حسنا ارسل الكلمه لحذفها " ,  1, "md")
return false
end
if text == 'اضف رد' and Manager(msg) and SourcelionCh(msg) then
DevAek:set(AEK..'Aek:Add:GpRed'..msg.sender_user_id_..''..msg.chat_id_,'SetGpRed')
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙حسنا ارسل الكلمه الان " ,  1, "md")
return false
end
if text and text:match("^(.*)$") then
local SetGpRed = DevAek:get(AEK..'Aek:Add:GpRed'..msg.sender_user_id_..''..msg.chat_id_..'')
if SetGpRed == 'SetGpRed' then
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙ارسل لي الرد سواء كان ↫ ⤈\n❨ ملف • ملصق • متحركه • صوره\n • فيديو • بصمه • صوت • رساله ❩\n✫︙يمكنك اضافة الى النص ↫ ⤈\n━───━ ✫ ━───━\n `#username` ↬ معرف المستخدم\n `#msgs` ↬ عدد الرسائل\n `#name` ↬ اسم المستخدم\n `#id` ↬ ايدي المستخدم\n `#stast` ↬ رتبة المستخدم\n `#edit` ↬ عدد السحكات\n━───━ ✫ ━───━\n✫︙للخروج ارسل ↫ ( الغاء )\n ✓" ,  1, "md")
DevAek:set(AEK..'Aek:Add:GpRed'..msg.sender_user_id_..''..msg.chat_id_..'','SaveGpRed')
DevAek:set(AEK..'Aek:Add:GpText'..msg.sender_user_id_..''..msg.chat_id_..'',text)
DevAek:sadd(AEK..'Aek:Manager:GpRed'..msg.chat_id_..'',text)
DevAek:set(AEK..'DelManagerRep'..msg.chat_id_..'',text)
return false
end
end

if text == 'حذف رد عام' and SecondSudo(msg) or text == '↫ حذف رد عام ✫' and SecondSudo(msg) or text == 'مسح رد عام' and SecondSudo(msg) then
DevAek:set(AEK.."Aek:Add:AllRed"..msg.sender_user_id_,'DelAllRed')
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙حسنا ارسل الكلمه لحذفها " ,  1, "md")
return false
end
if text == 'اضف رد عام' and SecondSudo(msg) or text == '↫ اضف رد عام ✫' and SecondSudo(msg) then
DevAek:set(AEK.."Aek:Add:AllRed"..msg.sender_user_id_,'SetAllRed')
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙حسنا ارسل الكلمه الان " ,  1, "md")
return false
end
if text and text:match("^(.*)$") then
local SetAllRed = DevAek:get(AEK.."Aek:Add:AllRed"..msg.sender_user_id_)
if SetAllRed == 'SetAllRed' then
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙ارسل لي الرد سواء كان ↫ ⤈\n❨ ملف • ملصق • متحركه • صوره\n • فيديو • بصمه • صوت • رساله ❩\n✫︙يمكنك اضافة الى النص ↫ ⤈\n━───━ ✫ ━───━\n `#username` ↬ معرف المستخدم\n `#msgs` ↬ عدد الرسائل\n `#name` ↬ اسم المستخدم\n `#id` ↬ ايدي المستخدم\n `#stast` ↬ رتبة المستخدم\n `#edit` ↬ عدد السحكات\n━───━ ✫ ━───━\n✫︙للخروج ارسل ↫ ( الغاء )\n ✓" ,  1, "md")
DevAek:set(AEK.."Aek:Add:AllRed"..msg.sender_user_id_,'SaveAllRed')
DevAek:set(AEK.."Aek:Add:AllText"..msg.sender_user_id_, text)
DevAek:sadd(AEK.."Aek:Sudo:AllRed",text)
DevAek:set(AEK.."DelSudoRep",text)
return false 
end end

if text == 'الردود المتعدده' and Manager(msg) and SourcelionCh(msg) then
local redod = DevAek:smembers(AEK..'Aek:Manager:GpRedod'..msg.chat_id_)
MsgRep = '✫︙قائمة الردود المتعدده ↫ ⤈ \n━───━ ✫ ━───━\n'
for k,v in pairs(redod) do
MsgRep = MsgRep..k..'~ (`'..v..'`) • {*العدد ↫ '..#DevAek:smembers(AEK..'Aek:Text:GpTexts'..v..msg.chat_id_)..'*}\n' 
end
if #redod == 0 then
MsgRep = '✫︙لا توجد ردود متعدده مضافه'
end
send(msg.chat_id_,msg.id_,MsgRep)
end
if text == 'حذف الردود المتعدده' and Manager(msg) and SourcelionCh(msg) or text == 'مسح الردود المتعدده' and Manager(msg) and SourcelionCh(msg) then
local redod = DevAek:smembers(AEK..'Aek:Manager:GpRedod'..msg.chat_id_)
if #redod == 0 then
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙لا توجد ردود متعدده مضافه" ,  1, "md")
else
for k,v in pairs(redod) do
DevAek:del(AEK..'Aek:Text:GpTexts'..v..msg.chat_id_)
DevAek:del(AEK..'Aek:Manager:GpRedod'..msg.chat_id_)
end
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم حذف الردود المتعدده")  
return false
end
end

if text == 'الردود' and Manager(msg) and SourcelionCh(msg) or text == 'ردود المدير' and Manager(msg) and SourcelionCh(msg) then
local redod = DevAek:smembers(AEK..'Aek:Manager:GpRed'..msg.chat_id_..'')
MsgRep = '✫︙ردود المدير ↫ ⤈ \n━───━ ✫ ━───━\n'
for k,v in pairs(redod) do
if DevAek:get(AEK.."Aek:Gif:GpRed"..v..msg.chat_id_) then
dp = 'متحركه 🎭'
elseif DevAek:get(AEK.."Aek:Voice:GpRed"..v..msg.chat_id_) then
dp = 'بصمه 🎙'
elseif DevAek:get(AEK.."Aek:Stecker:GpRed"..v..msg.chat_id_) then
dp = 'ملصق 🃏'
elseif DevAek:get(AEK.."Aek:Text:GpRed"..v..msg.chat_id_) then
dp = 'رساله ✉'
elseif DevAek:get(AEK.."Aek:Photo:GpRed"..v..msg.chat_id_) then
dp = 'صوره 🎇'
elseif DevAek:get(AEK.."Aek:Video:GpRed"..v..msg.chat_id_) then
dp = 'فيديو 📽'
elseif DevAek:get(AEK.."Aek:File:GpRed"..v..msg.chat_id_) then
dp = 'ملف 📁'
elseif DevAek:get(AEK.."Aek:Audio:GpRed"..v..msg.chat_id_) then
dp = 'اغنيه 🎶'
end
MsgRep = MsgRep..''..k..'~ (`'..v..'`) ↫ {*'..dp..'*}\n' 
end
if #redod == 0 then
MsgRep = '✫︙لا توجد ردود مضافه'
end
send(msg.chat_id_,msg.id_,MsgRep)
end

if text == 'حذف الردود' and Manager(msg) and SourcelionCh(msg) or text == 'مسح الردود' and Manager(msg) and SourcelionCh(msg) or text == 'حذف ردود المدير' and Manager(msg) and SourcelionCh(msg) or text == 'مسح ردود المدير' and Manager(msg) and SourcelionCh(msg) then
local redod = DevAek:smembers(AEK..'Aek:Manager:GpRed'..msg.chat_id_..'')
if #redod == 0 then
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙لا توجد ردود مضافه" ,  1, "md")
else
for k,v in pairs(redod) do
DevAek:del(AEK..'Aek:Gif:GpRed'..v..msg.chat_id_)
DevAek:del(AEK..'Aek:Voice:GpRed'..v..msg.chat_id_)
DevAek:del(AEK..'Aek:Audio:GpRed'..v..msg.chat_id_)
DevAek:del(AEK..'Aek:Photo:GpRed'..v..msg.chat_id_)
DevAek:del(AEK..'Aek:Stecker:GpRed'..v..msg.chat_id_)
DevAek:del(AEK..'Aek:Video:GpRed'..v..msg.chat_id_)
DevAek:del(AEK..'Aek:File:GpRed'..v..msg.chat_id_)
DevAek:del(AEK..'Aek:Text:GpRed'..v..msg.chat_id_)
DevAek:del(AEK..'Aek:Manager:GpRed'..msg.chat_id_)
end
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم حذف ردود المدير")  
return false
end
end

if  text == "ردود المطور" and SecondSudo(msg) or text == "الردود العام" and SecondSudo(msg) or text == "ردود العام" and SecondSudo(msg) or text == "↫ الردود العام ✫" and SecondSudo(msg) then
local redod = DevAek:smembers(AEK.."Aek:Sudo:AllRed")
MsgRep = '✫︙ردود المطور ↫ ⤈ \n━───━ ✫ ━───━\n'
for k,v in pairs(redod) do
if DevAek:get(AEK.."Aek:Gif:AllRed"..v) then
dp = 'متحركه 🎭'
elseif DevAek:get(AEK.."Aek:Voice:AllRed"..v) then
dp = 'بصمه 🎙'
elseif DevAek:get(AEK.."Aek:Stecker:AllRed"..v) then
dp = 'ملصق 🃏'
elseif DevAek:get(AEK.."Aek:Text:AllRed"..v) then
dp = 'رساله ✉'
elseif DevAek:get(AEK.."Aek:Photo:AllRed"..v) then
dp = 'صوره 🎇'
elseif DevAek:get(AEK.."Aek:Video:AllRed"..v) then
dp = 'فيديو 📽'
elseif DevAek:get(AEK.."Aek:File:AllRed"..v) then
dp = 'ملف 📁'
elseif DevAek:get(AEK.."Aek:Audio:AllRed"..v) then
dp = 'اغنيه 🎶'
end
MsgRep = MsgRep..''..k..'~ (`'..v..'`) ↫ {*'..dp..'*}\n' 
end
if #redod == 0 then
MsgRep = '✫︙لا توجد ردود مضافه'
end
send(msg.chat_id_,msg.id_,MsgRep)
end

if text == "حذف ردود المطور" and SecondSudo(msg) or text == "حذف ردود العام" and SecondSudo(msg) or text == "مسح ردود المطور" and SecondSudo(msg) then
local redod = DevAek:smembers(AEK.."Aek:Sudo:AllRed")
if #redod == 0 then
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙لا توجد ردود مضافه" ,  1, "md")
else
for k,v in pairs(redod) do
DevAek:del(AEK.."Aek:Add:AllRed"..v)
DevAek:del(AEK.."Aek:Gif:AllRed"..v)
DevAek:del(AEK.."Aek:Voice:AllRed"..v)
DevAek:del(AEK.."Aek:Audio:AllRed"..v)
DevAek:del(AEK.."Aek:Photo:AllRed"..v)
DevAek:del(AEK.."Aek:Stecker:AllRed"..v)
DevAek:del(AEK.."Aek:Video:AllRed"..v)
DevAek:del(AEK.."Aek:File:AllRed"..v)
DevAek:del(AEK.."Aek:Text:AllRed"..v)
DevAek:del(AEK.."Aek:Sudo:AllRed")
end
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","✫︙تم حذف ردود المطور")  
return false
end
end 

if text and text == "تغيير اسم البوت" or text and text == "وضع اسم البوت" or text and text == "تغير اسم البوت" then
if not SecondSudo(msg) then
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙للمطور الاساسي فقط ', 1, 'md')
else
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙ارسل لي اسم البوت الان" ,  1, "md") 
DevAek:set(AEK..'Aek:NameBot'..msg.sender_user_id_..'', 'msg')
return false 
end
end
if text and text == 'حذف اسم البوت' or text == 'مسح اسم البوت' then
if not SecondSudo(msg) then
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙للمطور الاساسي فقط ', 1, 'md')
else
DevAek:del(AEK..'Aek:NameBot')
local AEKTEAM = '✫︙اهلا عزيزي ↫ '..AekRank(msg)..' \n✫︙تم حذف اسم البوت'
Aekmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, AEKTEAM, 14, string.len(msg.sender_user_id_))
end end 

if text and text:match("^استعاده الاوامر$") and SecondSudo(msg) or text and text:match("^استعادة كلايش الاوامر$") and SecondSudo(msg) then
HelpList ={'Aek:Help','Aek:Help1','Aek:Help2','Aek:Help3','Aek:Help4','Aek:Help5','Aek:Help6'}
for i,Help in pairs(HelpList) do
DevAek:del(AEK..Help) 
end
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙تم استعادة الكلايش الاصليه" ,  1, "md") 
end
if text == "تعيين الاوامر" and SecondSudo(msg) or text == "تعيين امر الاوامر" and SecondSudo(msg) then
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙ارسل كليشة (الاوامر) الان " ,  1, "md")
DevAek:set(AEK..'Aek:Help0'..msg.sender_user_id_, 'msg')
return false end
if text and text:match("^(.*)$") then
local AEKTEAM =  DevAek:get(AEK..'Aek:Help0'..msg.sender_user_id_)
if AEKTEAM == 'msg' then
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙تم حفظ الكليشه الجديده " ,  1, "md")
DevAek:del(AEK..'Aek:Help0'..msg.sender_user_id_)
DevAek:set(AEK..'Aek:Help', text)
Dev_Aek(msg.chat_id_, msg.id_, 1, text , 1, 'md')
return false end
end
if text == "الاوامر" and Admin(msg) and SourcelionCh(msg) or text == "اوامر" and Admin(msg) and SourcelionCh(msg) or text == "مساعده" and Admin(msg) and SourcelionCh(msg) then
local Help = DevAek:get(AEK..'Aek:Help')
local Text = [[
✫︙اهلا بك في قائمة الاوامر ↫ ⤈ 
━───━ ✫ ━───━
✫︙م1 ↫ اوامر الحمايه
✫︙م2 ↫ اوامر الادمنيه
✫︙م3 ↫ اوامر المدراء
✫︙م4 ↫ اوامر المنشئين
✫︙م5 ↫ اوامر المطورين
✫︙م6 ↫ اوامر الاعضاء
━───━ ✫ ━───━
✫︙[‹  𝖲𝗈𝗎𝗋𝖼𝖾 𝙄𝘽𝙊 ›](https://t.me/HH_418)
]] 
keyboard = {} 
keyboard.inline_keyboard = {{{text="اوامر الادمنيه",callback_data="/HelpList2:"..msg.sender_user_id_},{text="اوامر الحمايه",callback_data="/HelpList1:"..msg.sender_user_id_}},{{text="اوامر المنشئين",callback_data="/HelpList4:"..msg.sender_user_id_},{text="اوامر المدراء",callback_data="/HelpList3:"..msg.sender_user_id_}},{{text="اوامر الاعضاء",callback_data="/HelpList6:"..msg.sender_user_id_},{text="اوامر المطورين",callback_data="/HelpList5:"..msg.sender_user_id_}},{{text="اوامر الرتب",callback_data="/DelList:"..msg.sender_user_id_}},{{text="التفعيل و التعطيل",callback_data="/lockorder:"..msg.sender_user_id_},{text="القفل و الفتح",callback_data="/locklist:"..msg.sender_user_id_}},{{text="اخفاء القائمه",callback_data="/HideHelpList:"..msg.sender_user_id_}}}
Msg_id = msg.id_/2097152/0.5
return https.request("https://api.telegram.org/bot"..TokenBot..'/sendMessage?chat_id='..msg.chat_id_..'&text=' .. URL.escape(Help or Text).."&reply_to_message_id="..Msg_id.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end
if text == "تعيين امر م1" and SecondSudo(msg) or text == "تعيين امر م١" and SecondSudo(msg) then
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙ارسل كليشة (م1) الان " ,  1, "md")
DevAek:set(AEK..'Aek:Help01'..msg.sender_user_id_, 'msg')
return false end
if text and text:match("^(.*)$") then
local AEKTEAM =  DevAek:get(AEK..'Aek:Help01'..msg.sender_user_id_)
if AEKTEAM == 'msg' then 
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙تم حفظ الكليشه الجديده " ,  1, "md")
DevAek:del(AEK..'Aek:Help01'..msg.sender_user_id_)
DevAek:set(AEK..'Aek:Help1', text)
Dev_Aek(msg.chat_id_, msg.id_, 1, text , 1, 'md')
return false end
end
if text == "م1" or text == "م١" or text == "اوامر1" or text == "اوامر١" then
if not Admin(msg) then
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙هذا الامر يخص الرتب الاعلى فقط\n✫︙ارسل ↫ (م6) لعرض اوامر الاعضاء', 1, 'md')
else
local Help = DevAek:get(AEK..'Aek:Help1')
local text =  [[
✫︙اوامر حماية المجموعه ↫ ⤈
━───━ ✫ ━───━
✫︙قفل • فتح ↫ الروابط
✫︙قفل • فتح ↫ المعرفات
✫︙قفل • فتح ↫ البوتات
✫︙قفل • فتح ↫ المتحركه
✫︙قفل • فتح ↫ الملصقات
✫︙قفل • فتح ↫ الملفات
✫︙قفل • فتح ↫ الصور
✫︙قفل • فتح ↫ الفيديو
✫︙قفل • فتح ↫ الاونلاين
✫︙قفل • فتح ↫ الدردشه
✫︙قفل • فتح ↫ التوجيه
✫︙قفل • فتح ↫ الاغاني
✫︙قفل • فتح ↫ الصوت
✫︙قفل • فتح ↫ الجهات
✫︙قفل • فتح ↫ الماركداون
✫︙قفل • فتح ↫ التكرار
✫︙قفل • فتح ↫ الهاشتاك
✫︙قفل • فتح ↫ التعديل
✫︙قفل • فتح ↫ التثبيت
✫︙قفل • فتح ↫ الاشعارات
✫︙قفل • فتح ↫ الكلايش
✫︙قفل • فتح ↫ الدخول
✫︙قفل • فتح ↫ الشبكات
✫︙قفل • فتح ↫ المواقع
✫︙قفل • فتح ↫ الفشار
✫︙قفل • فتح ↫ الكفر
✫︙قفل • فتح ↫ الطائفيه
✫︙قفل • فتح ↫ الكل
✫︙قفل • فتح ↫ العربيه
✫︙قفل • فتح ↫ الانكليزيه
✫︙قفل • فتح ↫ الفارسيه
✫︙قفل • فتح ↫ التفليش
━───━ ✫ ━───━
✫︙اوامر حمايه اخرى ↫ ⤈
━───━ ✫ ━───━
✫︙قفل • فتح + الامر ↫ ⤈
✫︙التكرار بالطرد
✫︙التكرار بالكتم
✫︙التكرار بالتقيد
✫︙الفارسيه بالتحذير
✫︙الفارسيه بالطرد
✫︙البوتات بالطرد
✫︙البوتات بالتقيد
━───━ ✫ ━───━
✫︙[‹  𝖲𝗈𝗎𝗋𝖼𝖾 𝙄𝘽𝙊 ›](https://t.me/HH_418)
]]
Dev_Aek(msg.chat_id_, msg.id_, 1, (Help or text), 1, 'md')
end end
if text == "تعيين امر م2" and SecondSudo(msg) or text == "تعيين امر م٢" and SecondSudo(msg) then
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙ارسل كليشة (م2) الان " ,  1, "md")
DevAek:set(AEK..'Aek:Help21'..msg.sender_user_id_, 'msg')
return false end
if text and text:match("^(.*)$") then
local AEKTEAM =  DevAek:get(AEK..'Aek:Help21'..msg.sender_user_id_)
if AEKTEAM == 'msg' then
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙تم حفظ الكليشه الجديده " ,  1, "md")
DevAek:del(AEK..'Aek:Help21'..msg.sender_user_id_)
DevAek:set(AEK..'Aek:Help2', text)
Dev_Aek(msg.chat_id_, msg.id_, 1, text , 1, 'md')
return false end
end
if text == "م2" or text == "م٢" or text == "اوامر2" or text == "اوامر٢" then
if not Admin(msg) then
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙هذا الامر يخص الرتب الاعلى فقط\n✫︙ارسل ↫ (م6) لعرض اوامر الاعضاء', 1, 'md')
else
local Help = DevAek:get(AEK..'Aek:Help2')
local text =  [[
✫︙اوامر الادمنيه ↫ ⤈
━───━ ✫ ━───━
✫︙الاعدادت
✫︙تاك للكل 
✫︙انشاء رابط
✫︙ضع وصف
✫︙ضع رابط
✫︙ضع صوره
✫︙حذف الرابط
✫︙حذف المطايه
✫︙كشف البوتات
✫︙طرد البوتات
✫︙تنظيف + العدد
✫︙تنظيف التعديل
✫︙كللهم + الكلمه
✫︙اسم البوت + الامر
✫︙ضع • حذف ↫ ترحيب
✫︙ضع • حذف ↫ قوانين
✫︙اضف • حذف ↫ صلاحيه
✫︙الصلاحيات • حذف الصلاحيات
━───━ ✫ ━───━
✫︙ضع سبام + العدد
✫︙ضع تكرار + العدد
━───━ ✫ ━───━
✫︙رفع مميز • تنزيل مميز
✫︙المميزين • حذف المميزين
✫︙كشف القيود • رفع القيود
━───━ ✫ ━───━
✫︙حذف • مسح + بالرد
✫︙منع • الغاء منع
✫︙قائمه المنع
✫︙حذف قائمه المنع
━───━ ✫ ━───━
✫︙تفعيل • تعطيل ↫ الرابط
✫︙تفعيل • تعطيل ↫ الالعاب
✫︙تفعيل • تعطيل ↫ الترحيب
✫︙تفعيل • تعطيل ↫ كشف الاعدادات
━───━ ✫ ━───━
✫︙طرد المحذوفين
✫︙طرد ↫ بالرد • بالمعرف • بالايدي
✫︙كتم • الغاء كتم
✫︙تقيد • الغاء تقيد
✫︙حظر • الغاء حظر
✫︙المكتومين • حذف المكتومين
✫︙المقيدين • حذف المقيدين
✫︙المحظورين • حذف المحظورين
━───━ ✫ ━───━
✫︙تقييد دقيقه + عدد الدقائق
✫︙تقييد ساعه + عدد الساعات
✫︙تقييد يوم + عدد الايام
✫︙الغاء تقييد ↫ لالغاء التقييد بالوقت
━───━ ✫ ━───━
✫︙[‹  𝖲𝗈𝗎𝗋𝖼𝖾 𝙄𝘽𝙊 ›](https://t.me/HH_418)
]]
Dev_Aek(msg.chat_id_, msg.id_, 1, (Help or text), 1, 'md')
end end
if text == "تعيين امر م3" and SecondSudo(msg) or text == "تعيين امر م٣" and SecondSudo(msg) then
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙ارسل كليشة (م3) الان " ,  1, "md")
DevAek:set(AEK..'Aek:Help31'..msg.sender_user_id_, 'msg')
return false end
if text and text:match("^(.*)$") then
local AEKTEAM =  DevAek:get(AEK..'Aek:Help31'..msg.sender_user_id_)
if AEKTEAM == 'msg' then
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙تم حفظ الكليشه الجديده " ,  1, "md")
DevAek:del(AEK..'Aek:Help31'..msg.sender_user_id_)
DevAek:set(AEK..'Aek:Help3', text)
Dev_Aek(msg.chat_id_, msg.id_, 1, text , 1, 'md')
return false end
end
if text == "م3" or text == "م٣" or text == "اوامر3" or text == "اوامر٣" then
if not Admin(msg) then
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙هذا الامر يخص الرتب الاعلى فقط\n✫︙ارسل ↫ (م6) لعرض اوامر الاعضاء', 1, 'md')
else
local Help = DevAek:get(AEK..'Aek:Help3')
local text =  [[
✫︙اوامر المدراء ↫ ⤈
━───━ ✫ ━───━
✫︙فحص البوت
✫︙ضع اسم + الاسم
✫︙وضع توحيد + رمز التوحيد
✫︙تعين عدد الكتم + العدد
✫︙الغاء • كتم اسم + الاسم
✫︙اضف • حذف ↫ رد
✫︙ردود المدير
✫︙حذف ردود المدير
✫︙حذف قوائم المنع
✫︙منع ↫ بالرد على ( ملصق • صوره • متحركه )
✫︙حذف قائمه منع + ↫ ⤈
( الصور • المتحركات • الملصقات )
━───━ ✫ ━───━
✫︙تنزيل الكل
✫︙رفع ادمن • تنزيل ادمن
✫︙الادمنيه • حذف الادمنيه
━───━ ✫ ━───━
✫︙تثبيت
✫︙الغاء التثبيت
✫︙اعاده التثبيت
✫︙الغاء تثبيت الكل
━───━ ✫ ━───━
✫︙تغير رد + اسم الرتبه + النص ↫ ⤈
✫︙المطور • منشئ الاساسي
✫︙المنشئ • المدير • الادمن
✫︙المميز • العضو
✫︙حذف ردود الرتب
━───━ ✫ ━───━
✫︙تغيير الايدي ↫ لتغيير الكليشه
✫︙تعيين الايدي ↫ لتعيين الكليشه
✫︙حذف الايدي ↫ لحذف الكليشه
━───━ ✫ ━───━
✫︙تفعيل • تعطيل + الامر ↫ ⤈
✫︙اطردني • الايدي بالصوره • الابراج
✫︙معاني الاسماء • اوامر النسب • التوحيد
✫︙الايدي • تحويل الصيغ • اوامر التحشيش
✫︙ردود المدير • ردود المطور
✫︙ضافني • حساب العمر • الزخرفه
━───━ ✫ ━───━
✫︙[‹  𝖲𝗈𝗎𝗋𝖼𝖾 𝙄𝘽𝙊 ›](https://t.me/HH_418)
]]
Dev_Aek(msg.chat_id_, msg.id_, 1, (Help or text), 1, 'md')
end end
if text == "تعيين امر م4" and SecondSudo(msg) or text == "تعيين امر م٤" and SecondSudo(msg) then
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙ارسل كليشة (م4) الان " ,  1, "md")
DevAek:set(AEK..'Aek:Help41'..msg.sender_user_id_, 'msg')
return false end
if text and text:match("^(.*)$") then
local AEKTEAM =  DevAek:get(AEK..'Aek:Help41'..msg.sender_user_id_)
if AEKTEAM == 'msg' then
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙تم حفظ الكليشه الجديده" ,  1, "md")
DevAek:del(AEK..'Aek:Help41'..msg.sender_user_id_)
DevAek:set(AEK..'Aek:Help4', text)
Dev_Aek(msg.chat_id_, msg.id_, 1, text , 1, 'md')
return false end
end
if text == "م٤" or text == "م4" or text == "اوامر4" or text == "اوامر٤" then
if not Admin(msg) then
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙هذا الامر يخص الرتب الاعلى فقط\n✫︙ارسل ↫ (م6) لعرض اوامر الاعضاء', 1, 'md')
else
local Help = DevAek:get(AEK..'Aek:Help4')
local text =  [[
✫︙اوامر المنشئين ↫ ⤈
━───━ ✫ ━───━
✫︙تنزيل الكل
✫︙اضف • حذف ↫ امر
✫︙حذف الاوامر المضافه
✫︙الاوامر المضافه
✫︙اضف نقاط ↫ بالرد • بالايدي
✫︙اضف رسائل ↫ بالرد • بالايدي
✫︙رفع مدير • تنزيل مدير
✫︙المدراء • حذف المدراء
✫︙تفعيل • تعطيل + الامر ↫ ⤈
✫︙نزلني
✫︙الحظر • الكتم
✫︙كتم الاسم
━───━ ✫ ━───━
✫︙اوامر المنشئين الاساسيين ↫ ⤈
━───━ ✫ ━───━
✫︙وضع لقب + اللقب
✫︙تفعيل • تعطيل ↫ الرفع
✫︙رفع منشئ • تنزيل منشئ
✫︙المنشئين • حذف المنشئين
✫︙رفع • تنزيل ↫ مشرف
✫︙رفع بكل الصلاحيات
✫︙حذف القوائم
━───━ ✫ ━───━
✫︙اوامر منشئ المجموعه ↫ ⤈
━───━ ✫ ━───━
✫︙رفع • تنزيل ↫ منشئ اساسي
✫︙حذف المنشئين الاساسيين 
✫︙المنشئين الاساسيين 
✫︙حذف • مسح ↫ الاسماء المكتومه
✫︙حذف جميع الرتب
━───━ ✫ ━───━
✫︙[‹  𝖲𝗈𝗎𝗋𝖼𝖾 𝙄𝘽𝙊 ›](https://t.me/HH_418)
]]
Dev_Aek(msg.chat_id_, msg.id_, 1, (Help or text), 1, 'md')
end end
if text == "تعيين امر م5" and SecondSudo(msg) or text == "تعيين امر م٥" and SecondSudo(msg) then
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙ارسل كليشة (م5) الان " ,  1, "md")
DevAek:set(AEK..'Aek:Help51'..msg.sender_user_id_, 'msg')
return false end
if text and text:match("^(.*)$") then
local AEKTEAM =  DevAek:get(AEK..'Aek:Help51'..msg.sender_user_id_)
if AEKTEAM == 'msg' then
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙تم حفظ الكليشه الجديده " ,  1, "md")
DevAek:del(AEK..'Aek:Help51'..msg.sender_user_id_)
DevAek:set(AEK..'Aek:Help5', text)
Dev_Aek(msg.chat_id_, msg.id_, 1, text , 1, 'md')
return false end
end
if text == "م٥" or text == "م5" or text == "اوامر5" or text == "اوامر٥" then
if not SudoBot(msg) then
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙هذا الامر للمطورين فقط', 1, 'md')
else
local Help = DevAek:get(AEK..'Aek:Help5')
local text =  [[
✫︙اوامر المطورين ↫ ⤈
━───━ ✫ ━───━
✫︙الكروبات
✫︙المطورين
✫︙المشتركين
✫︙الاحصائيات
✫︙المجموعات
✫︙اسم البوت + غادر
✫︙اسم البوت + تعطيل
✫︙كشف + -ايدي المجموعه
✫︙رفع مالك • تنزيل مالك
✫︙المالكين • حذف المالكين
━───━ ✫ ━───━
✫︙رفع • تنزيل ↫ مدير عام
✫︙حذف • المدراء العامين 
✫︙رفع • تنزيل ↫ ادمن عام
✫︙حذف • الادمنيه العامين 
✫︙رفع • تنزيل ↫ مميز عام
✫︙حذف • المميزين عام 
━───━ ✫ ━───━
✫︙اوامر المطور الاساسي ↫ ⤈
━───━ ✫ ━───━
✫︙تحديث
✫︙الملفات
✫︙المتجر
✫︙السيرفر
✫︙روابط الكروبات
✫︙تحديث السورس
✫︙تنظيف الكروبات
✫︙تنظيف المشتركين
✫︙حذف جميع الملفات
✫︙تعيين الايدي العام
✫︙تغير المطور الاساسي
✫︙حذف معلومات الترحيب
✫︙تغير معلومات الترحيب
✫︙غادر + -ايدي المجموعه
✫︙تعيين عدد الاعضاء + العدد
✫︙حظر عام • الغاء العام
✫︙كتم عام • الغاء العام
✫︙قائمه العام • حذف قائمه العام
✫︙وضع • حذف ↫ اسم البوت
✫︙اضف • حذف ↫ رد عام
✫︙ردود المطور • حذف ردود المطور
✫︙تعيين • حذف • جلب ↫ رد الخاص
✫︙جلب نسخه الكروبات
✫︙رفع النسخه + بالرد على الملف
✫︙تعيين • حذف ↫ قناة الاشتراك
✫︙جلب كليشه الاشتراك
✫︙تغيير • حذف ↫ كليشه الاشتراك
✫︙رفع • تنزيل ↫ مطور
✫︙المطورين • حذف المطورين
✫︙رفع • تنزيل ↫ مطور ثانوي
✫︙الثانويين • حذف الثانويين
✫︙تعيين • حذف ↫ كليشة الايدي
✫︙اذاعه للكل بالتوجيه ↫ بالرد
━───━ ✫ ━───━
✫︙تفعيل ملف + اسم الملف
✫︙تعطيل ملف + اسم الملف
✫︙تفعيل • تعطيل + الامر ↫ ⤈
✫︙الاذاعه • الاشتراك الاجباري
✫︙ترحيب البوت • المغادره
✫︙البوت الخدمي • التواصل
━───━ ✫ ━───━
✫︙[‹  𝖲𝗈𝗎𝗋𝖼𝖾 𝙄𝘽𝙊 ›](https://t.me/HH_418)
]]
Dev_Aek(msg.chat_id_, msg.id_, 1, (Help or text), 1, 'md')
end end
if text == "تعيين امر م6" and SecondSudo(msg) or text == "تعيين امر م٦" and SecondSudo(msg) then
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙ارسل كليشة (م6) الان " ,  1, "md")
DevAek:set(AEK..'Aek:Help61'..msg.sender_user_id_, 'msg')
return false end
if text and text:match("^(.*)$") then
local AEKTEAM =  DevAek:get(AEK..'Aek:Help61'..msg.sender_user_id_)
if AEKTEAM == 'msg' then
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙تم حفظ الكليشه الجديده" ,  1, "md")
DevAek:del(AEK..'Aek:Help61'..msg.sender_user_id_)
DevAek:set(AEK..'Aek:Help6', text)
Dev_Aek(msg.chat_id_, msg.id_, 1, text , 1, 'md')
return false end
end
if text == "م٦" or text == "م6" or text == "اوامر6" or text == "اوامر٦" then
local Help = DevAek:get(AEK..'Aek:Help6')
local text =  [[
✫︙اوامر الاعضاء ↫ ⤈
━───━ ✫ ━───━
✫︙السورس • موقعي • رتبتي • معلوماتي
✫︙رسائلي • حذف رسائلي • اسمي • معرفي 
✫︙ايدي •ايديي • جهاتي • غنيلي • الالعاب 
✫︙نقاطي • بيع نقاطي • القوانين • زخرفه 
✫︙رابط الحذف • نزلني • اطردني • المطور 
✫︙منو ضافني • مشاهدات المنشور • الرابط 
✫︙رقمي • ايدي المجموعه • معلومات المجموعه 
✫︙نسبه الحب • نسبه الكره • نسبه الغباء 
✫︙نسبه الرجوله • نسبه الانوثه • التفاعل
━───━ ✫ ━───━
✫︙صلاحياتي
✫︙كول + الكلمه
✫︙زخرفه + اسمك
✫︙برج + نوع البرج
✫︙معنى اسم + الاسم
✫︙احسب + تاريخ ميلادك
✫︙الحساب + ايدي الحساب
✫︙بوسه • بوسها ↫ بالرد
✫︙رفع مطي • تنزيل مطي •المطايه
✫︙هينه • هينها ↫ بالرد • بالمعرف
✫︙صيحه • صيحها ↫ بالرد • بالمعرف
✫︙صلاحياته ↫ بالرد • بالمعرف • بالايدي
✫︙ايدي • كشف  ↫ بالرد • بالمعرف • بالايدي
✫︙تحويل + بالرد ↫ صوره • ملصق • صوت • بصمه
━───━ ✫ ━───━
✫︙[‹  𝖲𝗈𝗎𝗋𝖼𝖾 𝙄𝘽𝙊 ›](https://t.me/HH_418)
]]
Dev_Aek(msg.chat_id_, msg.id_, 1, (Help or text), 1, 'md')
end

if SecondSudo(msg) then
if text == "تحديث السورس" or text == "تحديث سورس" then 
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙جاري تحديث سورس ايبو', 1, 'md') 
os.execute('rm -rf AEK.lua') 
os.execute('wget https://raw.githubusercontent.com/KAFIKAFI/KAFI/master/AEK.lua') 
dofile('AEK.lua') 
io.popen("rm -rf ../.telegram-cli/*")
print("\27[31;47m\n          ( تم تحديث السورس )          \n\27[0;34;49m\n") 
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙تم التحديث الى الاصدار الجديد', 1, 'md') 
end
if text == 'تحديث' or text == 'تحديث البوت' or text == '↫ تحديث ✫' then  
dofile('AEK.lua') 
io.popen("rm -rf ../.telegram-cli/*")
print("\27[31;47m\n        ( تم تحديث ملفات البوت )        \n\27[0;34;49m\n") 
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙تم تحديث ملفات البوت", 1, "md")
end 

if text == 'الملفات' then
Files = '\n✫︙الملفات المفعله في البوت ↫ ⤈ \n━───━ ✫ ━───━\n'
i = 0
for v in io.popen('ls Files'):lines() do
if v:match(".lua$") then
i = i + 1
Files = Files..i..'~ : `'..v..'`\n'
end
end
if i == 0 then
Files = '✫︙لا توجد ملفات في البوت'
end
send(msg.chat_id_, msg.id_,Files)
end
if text == "متجر الملفات" or text == 'المتجر' then
local Get_Files, res = https.request("https://raw.githubusercontent.com/KAFIKAFII/IDAFAT/master/getfile.json")
if res == 200 then
local Get_info, res = pcall(JSON.decode,Get_Files);
vardump(res.plugins_)
if Get_info then
local TextS = "\n✫︙قائمة ملفات متجر سورس ايبو\n✫︙الملفات المتوفره حاليا ↫ ⤈\n━───━ ✫ ━───━\n"
local TextE = "━───━ ✫ ━───━\n✫︙علامة ↫ (✔) تعني الملف مفعل\n✫︙علامة ↫ (✖️) تعني الملف معطل\n"
local NumFile = 0
for name,Info in pairs(res.plugins_) do
local CheckFileisFound = io.open("Files/"..name,"r")
if CheckFileisFound then
io.close(CheckFileisFound)
CheckFile = "(✔)"
else
CheckFile = "(✖️)"
end
NumFile = NumFile + 1
TextS = TextS.."✫︙"..Info..' ↫ ⤈\n'..NumFile.."~ : `"..name..'` ↬ '..CheckFile.."\n"
end
send(msg.chat_id_, msg.id_,TextS..TextE) 
end
else
send(msg.chat_id_, msg.id_,"✫︙لا يوجد اتصال من الـapi") 
end
end
if text == "مسح جميع الملفات" or text == "حذف جميع الملفات" then
os.execute("rm -fr Files/*")
send(msg.chat_id_,msg.id_,"✫︙تم حذف جميع الملفات المفعله")
end
if text and text:match("^(تعطيل ملف) (.*)(.lua)$") then
local FileGet = {string.match(text, "^(تعطيل ملف) (.*)(.lua)$")}
local FileName = FileGet[2]..'.lua'
local GetJson, Res = https.request("https://raw.githubusercontent.com/KAFIKAFII/IDAFAT/master/IDAFAT/"..FileName)
if Res == 200 then
os.execute("rm -fr Files/"..FileName)
send(msg.chat_id_, msg.id_,"\n✫︙الملف ↫ *"..FileName.."*\n✫︙تم تعطيله وحذفه من البوت بنجاح") 
dofile('AEK.lua')  
else
send(msg.chat_id_, msg.id_,"✫︙لا يوجد ملف بهذا الاسم") 
end
end
if text and text:match("^(تفعيل ملف) (.*)(.lua)$") then
local FileGet = {string.match(text, "^(تفعيل ملف) (.*)(.lua)$")}
local FileName = FileGet[2]..'.lua'
local GetJson, Res = https.request("https://raw.githubusercontent.com/KAFIKAFII/IDAFAT/master/IDAFAT/"..FileName)
if Res == 200 then
local ChekAuto = io.open("Files/"..FileName,'w+')
ChekAuto:write(GetJson)
ChekAuto:close()
send(msg.chat_id_, msg.id_,"\n✫︙الملف ↫ *"..FileName.."*\n✫︙تم تفعيله في البوت بنجاح") 
dofile('AEK.lua')  
else
send(msg.chat_id_, msg.id_,"✫︙لا يوجد ملف بهذا الاسم") 
end
return false
end
end 

if text and (text == 'حذف معلومات الترحيب' or text == 'مسح معلومات الترحيب') and SecondSudo(msg) then    
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙تم حذف معلومات الترحيب', 1, 'md')   
DevAek:del(AEK..'Aek:Text:BotWelcome')
DevAek:del(AEK..'Aek:Photo:BotWelcome')
return false
end 
if text and (text == 'تفعيل ترحيب البوت' or text == 'تفعيل معلومات الترحيب') and SecondSudo(msg) then    
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙تم تفعيل الترحيب عند اضافة البوت في المجموعه', 1, 'md')   
DevAek:del(AEK..'Aek:Lock:BotWelcome')
return false
end 
if text and (text == 'تعطيل ترحيب البوت' or text == 'تعطيل معلومات الترحيب') and SecondSudo(msg) then    
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙تم تعطيل الترحيب عند اضافة البوت في المجموعه', 1, 'md')   
DevAek:set(AEK..'Aek:Lock:BotWelcome',true)
return false
end 
if text and (text == 'تغير معلومات الترحيب' or text == 'تغيير معلومات الترحيب' or text == '↫ تغير معلومات الترحيب ✫') and SecondSudo(msg) then    
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙ارسل لي نص الترحيب', 1, 'md') 
DevAek:del(AEK..'Aek:Text:BotWelcome')
DevAek:del(AEK..'Aek:Photo:BotWelcome')
DevAek:set(AEK.."Aek:Set:BotWelcome"..msg.sender_user_id_,"Text") 
return false
end 
if text and DevAek:get(AEK.."Aek:Set:BotWelcome"..msg.sender_user_id_) == 'Text' then 
if text and text:match("^الغاء$") then 
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙تم الغاء الامر", 1, "md") 
DevAek:del(AEK.."Aek:Set:BotWelcome"..msg.sender_user_id_)   
return false
end 
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙تم حفظ النص ارسل لي صورة الترحيب\n✫︙ارسل ↫ الغاء لحفظ النص فقط", 1, 'md')   
DevAek:set(AEK.."Aek:Text:BotWelcome",text) 
DevAek:set(AEK.."Aek:Set:BotWelcome"..msg.sender_user_id_,"Photo") 
return false 
end 
if DevAek:get(AEK.."Aek:Set:BotWelcome"..msg.sender_user_id_) == 'Photo' then 
if text and text:match("^الغاء$") then 
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙تم حفظ النص والغاء حفظ صورة الترحيب", 1, "md") 
DevAek:del(AEK.."Aek:Set:BotWelcome"..msg.sender_user_id_)    
return false
end 
if msg.content_.photo_ and msg.content_.photo_.sizes_[1] then   
DevAek:set(AEK.."Aek:Photo:BotWelcome",msg.content_.photo_.sizes_[1].photo_.persistent_id_)
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙تم حفظ النص وصورة الترحيب", 1, 'md')   
DevAek:del(AEK.."Aek:Set:BotWelcome"..msg.sender_user_id_)   
end
return false
end

if text and text:match("^ضع كليشه المطور$") or text and text:match("^وضع كليشه المطور$") or text and text:match("^تغيير كليشه المطور$") then
if not SecondSudo(msg) then
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙للمطور الاساسي فقط ', 1, 'md')
else
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙ارسل كليشة المطور الان ", 1, "md")
DevAek:setex(AEK.."Aek:DevText" .. msg.chat_id_ .. ":" .. msg.sender_user_id_, 300, true)
end end
if text and text:match("^مسح كليشه المطور$") or text and text:match("^حذف كليشه المطور$") then
if not SecondSudo(msg) then
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙للمطور الاساسي فقط ', 1, 'md')
else
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙تم حذف كليشة المطور", 1, "md")
DevAek:del(AEK.."DevText")
end end

if DevAek:get(AEK.."textch:user" .. msg.chat_id_ .. "" .. msg.sender_user_id_) then 
if text and text:match("^الغاء$") then 
Dev_Aek(msg.chat_id_, msg.id_, 1, "✫︙تم الغاء الامر", 1, "md") 
DevAek:del(AEK.."textch:user" .. msg.chat_id_ .. "" .. msg.sender_user_id_)  
return false  end 
DevAek:del(AEK.."textch:user" .. msg.chat_id_ .. "" .. msg.sender_user_id_)  
local texxt = string.match(text, "(.*)") 
DevAek:set(AEK..'Aek:textch:user',texxt)
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙تم تغيير كليشة الاشتراك الاجباري', 1, 'md')
end
if text and text:match("^تغير كليشه الاشتراك$") and SecondSudo(msg) or text and text:match("^تغيير كليشه الاشتراك$") and SecondSudo(msg) then  
DevAek:setex(AEK.."textch:user" .. msg.chat_id_ .. "" .. msg.sender_user_id_, 300, true)  
local text = '✫︙حسنا ارسل كليشة الاشتراك الجديده'  
Dev_Aek(msg.chat_id_, msg.id_, 1,text, 1, 'md') 
end
if text == "حذف كليشه الاشتراك الاجباري" or text == "حذف كليشه الاشتراك" then  
if not SecondSudo(msg) then
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙للمطور الاساسي فقط ', 1, 'md')
else
DevAek:del(AEK..'Aek:textch:user')
textt = "✫︙تم حذف كليشة الاشتراك الاجباري"
Dev_Aek(msg.chat_id_, msg.id_, 1,textt, 1, 'md') 
end end
if text == 'كليشه الاشتراك' or text == 'جلب كليشه الاشتراك' then
if not SecondSudo(msg) then
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙للمطور الاساسي فقط ', 1, 'md')
else
local chtext = DevAek:get(AEK.."Aek:ChText")
if chtext then
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙كليشة الاشتراك ↫ ⤈ \n━───━ ✫ ━───━\n['..chtext..']', 1, 'md')
else
if DevAek:get(AEK.."Aek:ChId") then
local Check = https.request('https://api.telegram.org/bot'..TokenBot..'/getChat?chat_id='..DevAek:get(AEK.."Aek:ChId"))
local GetInfo = JSON.decode(Check)
if GetInfo.result.username then
User = "https://t.me/"..GetInfo.result.username
else
User = GetInfo.result.invite_link
end
Text = "✫︙هلو عمري عذرآ !\n✫︙عليك الاشتراك في قناتي اولآ"
keyboard = {} 
keyboard.inline_keyboard = {{{text=GetInfo.result.title,url=User}}} 
Msg_id = msg.id_/2097152/0.5
https.request("https://api.telegram.org/bot"..TokenBot..'/sendMessage?chat_id='..msg.chat_id_..'&text=' .. URL.escape(Text).."&reply_to_message_id="..Msg_id.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
else
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙لم يتم تعيين قناة الاشتراك الاجباري \n✫︙ارسل ↫ تعيين قناة الاشتراك للتعيين ', 1, 'md')
end end end end

if text == 'القناة' or text == 'قناة السورس' or text == 'قناه السورس' or text == 'قنات السورس' then 
Dev_Aek(msg.chat_id_, msg.id_, 1, '✫︙Channel ↬ @HH_418', 1, 'html')    
end 

if Sudo(msg) then 
if text == 'معلومات السيرفر' or text == 'السيرفر' then 
Dev_Aek(msg.chat_id_, msg.id_, 1, io.popen([[
LinuxVersion=`lsb_release -ds`
MemoryUsage=`free -m | awk 'NR==2{printf "%s/%sMB {%.2f%%}\n", $3,$2,$3*100/$2 }'`
HardDisk=`df -lh | awk '{if ($6 == "/") { print $3"/"$2" ~ {"$5"}" }}'`
Percentage=`top -b -n1 | grep "Cpu(s)" | awk '{print $2 + $4}'`
UpTime=`uptime | awk -F'( |,|:)+' '{if ($7=="min") m=$6; else {if ($7~/^day/) {d=$6;h=$8;m=$9} else {h=$6;m=$7}}} {print d+0,"days,",h+0,"hours,",m+0,"minutes"}'`
echo '✫︙نظام التشغيل ↫ ⤈\n`'"$LinuxVersion"'`' 
echo '━───━ ✫ ━───━\n✫︙الذاكره العشوائيه ↫ ⤈\n`'"$MemoryUsage"'`'
echo '━───━ ✫ ━───━\n✫︙وحدة التخزين ↫ ⤈\n`'"$HardDisk"'`'
echo '━───━ ✫ ━───━\n✫︙المعالج ↫ ⤈\n`'"`grep -c processor /proc/cpuinfo`""Core ~ {$Percentage%} "'`'
echo '━───━ ✫ ━───━\n✫︙الدخول ↫ ⤈\n`'`whoami`'`'
echo '━───━ ✫ ━───━\n✫︙مدة تشغيل السيرفر ↫ ⤈\n`'"$UpTime"'`'
]]):read('*a'), 1, 'md')
end
end

AEKFiles(msg)

elseif (data.ID == "UpdateMessageEdited") then
local msg = data
tdcli_function ({ID = "GetMessage",chat_id_ = msg.chat_id_,message_id_ = tonumber(msg.message_id_)},function(extra, result, success)
DevAek:incr(AEK..'Aek:EditMsg'..result.chat_id_..result.sender_user_id_)
local text = result.content_.text_ or result.content_.caption_
local Text = result.content_.text_
if DevAek:get(AEK..'Aek:Lock:EditMsgs'..msg.chat_id_) and not Text and not BasicConstructor(result) then
DeleteMessage(msg.chat_id_,{[0] = data.message_id_})
Media = 'الميديا'
if result.content_.ID == "MessagePhoto" then Media = 'الصوره'
elseif result.content_.ID == "MessageSticker" then Media = 'الملصق'
elseif result.content_.ID == "MessageVoice" then Media = 'البصمه'
elseif result.content_.ID == "MessageAudio" then Media = 'الصوت'
elseif result.content_.ID == "MessageVideo" then Media = 'الفيديو'
elseif result.content_.ID == "MessageAnimation" then Media = 'المتحركه'
end
tdcli_function ({ID = "GetUser",user_id_ = result.sender_user_id_},function(arg,dp) 
local Aekname = '✫︙العضو ↫ ['..dp.first_name_..'](tg://user?id='..dp.id_..')'
local Aekid = '✫︙ايديه ↫ `'..dp.id_..'`'
local Aektext = '✫︙قام بالتعديل على '..Media
local Aektxt = '━───━ ✫ ━───━\n✫︙تعالو يامشرفين اكو مخرب'
tdcli_function ({ID = "GetChannelMembers",channel_id_ = msg.chat_id_:gsub("-100",""),filter_ = {ID = "ChannelMembersAdministrators"},offset_ = 0,limit_ = 100},function(arg,Aekan) 
local admins = Aekan.members_  
text = '\n━───━ ✫ ━───━\n'
for i=0 , #admins do 
if not Aekan.members_[i].bot_info_ then
tdcli_function ({ID = "GetUser",user_id_ = admins[i].user_id_},function(arg,data) 
if data.first_name_ ~= false then
text = text.."~ [@"..data.username_.."]\n"
end
if #admins == i then 
SendText(msg.chat_id_, Aekname..'\n'..Aekid..'\n'..Aektext..text..Aektxt,0,'md') 
end
end,nil)
end
end
end,nil)
end,nil)
end
if not VipMem(result) then
Filters(result, text)
if text:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]") or text:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]") or text:match("[Tt].[Mm][Ee]") or text:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Dd][Oo][Gg]") or text:match("#") or text:match("@") or text:match("[Hh][Tt][Tt][Pp][Ss]://") or text:match("[Hh][Tt][Tt][Pp]://") or text:match(".[Cc][Oo][Mm]") or text:match(".[Oo][Rr][Gg]") or text:match("[Ww][Ww][Ww].") or text:match(".[Xx][Yy][Zz]") then
if DevAek:get(AEK..'Aek:Lock:EditMsgs'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = data.message_id_})
end end end 
end,nil)

elseif (data.ID == "UpdateMessageSendSucceeded") then
local msg = data.message_
local text = msg.content_.text_
local GetMsgPin = DevAek:get(AEK..'Aek:PinnedMsgs'..msg.chat_id_)
if GetMsgPin ~= nil then
if text == GetMsgPin then
tdcli_function ({ID = "PinChannelMessage",channel_id_ = msg.chat_id_:gsub('-100',''),message_id_ = msg.id_,disable_notification_ = 0},function(arg,dp) if dp.ID == 'Ok' then;DevAek:del(AEK..'Aek:PinnedMsgs'..msg.chat_id_);end;end,nil)   
elseif (msg.content_.sticker_) then 
if GetMsgPin == msg.content_.sticker_.sticker_.persistent_id_ then
tdcli_function ({ID = "PinChannelMessage",channel_id_ = msg.chat_id_:gsub('-100',''),message_id_ = msg.id_,disable_notification_ = 0},function(arg,dp) DevAek:del(AEK..'Aek:PinnedMsgs'..msg.chat_id_) end,nil)   
end
end
if (msg.content_.animation_) then 
if msg.content_.animation_.animation_.persistent_id_ == GetMsgPin then
tdcli_function ({ID = "PinChannelMessage",channel_id_ = msg.chat_id_:gsub('-100',''),message_id_ = msg.id_,disable_notification_ = 0},function(arg,dp) DevAek:del(AEK..'Aek:PinnedMsgs'..msg.chat_id_) end,nil)   
end
end
if (msg.content_.photo_) then
if msg.content_.photo_.sizes_[0] then
id_photo = msg.content_.photo_.sizes_[0].photo_.persistent_id_
end
if msg.content_.photo_.sizes_[1] then
id_photo = msg.content_.photo_.sizes_[1].photo_.persistent_id_
end
if msg.content_.photo_.sizes_[2] then
id_photo = msg.content_.photo_.sizes_[2].photo_.persistent_id_
end	
if msg.content_.photo_.sizes_[3] then
id_photo = msg.content_.photo_.sizes_[3].photo_.persistent_id_
end
if id_photo == GetMsgPin then
tdcli_function ({ID = "PinChannelMessage",channel_id_ = msg.chat_id_:gsub('-100',''),message_id_ = msg.id_,disable_notification_ = 0},function(arg,dp) DevAek:del(AEK..'Aek:PinnedMsgs'..msg.chat_id_) end,nil)   
end end end

elseif (data.ID == "UpdateOption" and data.name_ == "my_id") then
print('\27[30;32mجاري تنظيف المجموعات الوهميه يرجى الانتظار\n\27[1;37m')
local PvList = DevAek:smembers(AEK..'Aek:Users')  
for k,v in pairs(PvList) do 
tdcli_function({ID='GetChat',chat_id_ = v},function(arg,data) end,nil) 
end 
local GpList = DevAek:smembers(AEK..'Aek:Groups') 
for k,v in pairs(GpList) do 
tdcli_function({ID='GetChat',chat_id_ = v},function(arg,data)
if data and data.type_ and data.type_.channel_ and data.type_.channel_.status_ and data.type_.channel_.status_.ID == "ChatMemberStatusMember" then
tdcli_function({ID = "ChangeChatMemberStatus",chat_id_=v,user_id_=AEK,status_={ID = "ChatMemberStatusLeft"},},function(e,g) end, nil) 
DevAek:srem(AEK..'Aek:Groups',v)  
end
if data and data.type_ and data.type_.channel_ and data.type_.channel_.status_ and data.type_.channel_.status_.ID == "ChatMemberStatusLeft" then
DevAek:srem(AEK..'Aek:Groups',v)  
end
if data and data.type_ and data.type_.channel_ and data.type_.channel_.status_ and data.type_.channel_.status_.ID == "ChatMemberStatusKicked" then
DevAek:srem(AEK..'Aek:Groups',v)  
end
if data and data.code_ and data.code_ == 400 then
DevAek:srem(AEK..'Aek:Groups',v)  
end
if data and data.type_ and data.type_.channel_ and data.type_.channel_.status_ and data.type_.channel_.status_.ID == "ChatMemberStatusEditor" then
DevAek:sadd(AEK..'Aek:Groups',v)  
end end,nil) end
end

end 

