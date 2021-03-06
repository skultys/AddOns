local L = LibStub("AceLocale-3.0"):NewLocale("EPGP", "zhCN")
if not L then return end

L["Alts"] = "马甲"
L["A member is awarded EP"] = "一名会员被奖励EP"
L["A member is credited GP"] = "一名会员被记入GP"
L["A new tier is here!  You should probably reset or rescale GP (Interface -> Options -> AddOns -> EPGP)!"] = "新的级别出现！你可能需要重置或重新调整GP （界面-> 选项-> 插件-> EPGP）！" -- Needs review
L["An item was disenchanted or deposited into the guild bank"] = "一件物品已被分解或已存入公会银行"
L["Announce"] = "通告"
L["Announce medium"] = "通告媒介"
L["Announcement of EPGP actions"] = "EPGP操作通告"
L["Announces EPGP actions to the specified medium."] = "通告EPGP操作至指定媒介."
L["Announce when:"] = "何时通告:"
L["Automatic boss tracking"] = "自动追踪首领"
L["Automatic boss tracking by means of a popup to mass award EP to the raid and standby when a boss is killed."] = "自动追踪首领借助弹出框在击杀首领后群体奖励EP给团员及待命人员."
L["Automatic handling of the standby list through whispers when in raid. When this is enabled, the standby list is cleared after each reward."] = "团队活动中通过密语自动处理待命名单. 如启用,每次奖励后待命名单将被清空."
L["Automatic loot tracking"] = "自动追踪拾取"
L["Automatic loot tracking by means of a popup to assign GP to the toon that received loot. This option only has effect if you are in a raid and you are either the Raid Leader or the Master Looter."] = "自动追踪拾取借助弹出框为获得战利品的角色指定GP. 仅当你在团队中且为团长或物品分配者时此选项方有效."
L["Award EP"] = "奖励EP"
L["Awards for wipes on bosses. Requires DBM, DXE, or BigWigs"] = "对boss战灭团进行奖励.需要DBM,DXE,或BigWigs支持." -- Needs review
L["Base GP should be a positive number"] = "BaseGP(装备基础分数)应为正数"
L["Boss"] = "首领"
L["Credit GP"] = "记入GP"
L["Credit GP to %s"] = "给 %s 增加GP"
L["Custom announce channel name"] = "自定义通告频道名称"
L["Decay"] = "衰减"
L["Decay EP and GP by %d%%?"] = "设定EP及GP的衰减值为 %d%%?"
L["Decay of EP/GP by %d%%"] = "EP及GP的衰减值为 %d%%"
L["Decay Percent should be a number between 0 and 100"] = "衰减率的值应介于0至100之间"
L["Decay=%s%% BaseGP=%s MinEP=%s Extras=%s%%"] = "衰减=%s%% BaseGP=%s MinEP=%s 附加=%s%%"
L["default"] = "默认" -- Needs review
L["%+d EP (%s) to %s"] = "%+d EP (%s) 给 %s" -- Needs review
L["%+d GP (%s) to %s"] = "%+d GP (%s) 给 %s"
L["%d or %d"] = "%d 或 %d"
L["Do you want to resume recurring award (%s) %d EP/%s?"] = "你想重新开始周期性奖励 (%s) %d EP/%s 吗?"
L["EP/GP are reset"] = "EP/GP 已被重置"
L["EPGP decay"] = "EPGP衰减"
L["EPGP is an in game, relational loot distribution system"] = "EPGP是一个游戏内置的关联式战利品分配系统"
L["EPGP is using Officer Notes for data storage. Do you really want to edit the Officer Note by hand?"] = "EPGP使用官员备注存储数据. 你确定要手动修改官员备注么?"
L["EPGP reset"] = "EPGP重置"
L["EP Reason"] = "EP理由"
L["expected number"] = "期望参数: 数字" -- Needs review
L["Export"] = "导出"
L["Extras Percent should be a number between 0 and 100"] = "附加率的值应介于0至100之间"
L["GP: %d"] = "GP: %d"
L["GP: %d or %d"] = "GP: %d 或 %d"
L["GP is rescaled for the new tier"] = "为了新等级, GP被重新调整了" -- Needs review
L["GP (not EP) is reset"] = "GP (不是EP) 被重置了" -- Needs review
L["GP (not ep) reset"] = "重置GP （非EP）" -- Needs review
L["GP on tooltips"] = "在工具栏提示中显示GP"
L["GP Reason"] = "GP原因"
L["GP rescale for new tier"] = "为了新等级重新调整GP" -- Needs review
L["Guild or Raid are awarded EP"] = "公会或团队被奖励EP"
L["Hint: You can open these options by typing /epgp config"] = "提示: 你可通过键入 /epgp config 来显示这些选项"
L["Idle"] = "待命" -- Needs review
L["If you want to be on the award list but you are not in the raid, you need to whisper me: 'epgp standby' or 'epgp standby <name>' where <name> is the toon that should receive awards"] = "如果你想进入奖励名单却不在团队中,那么你必须向我密语: 'epgp standby' 或 'epgp standby <角色名>' 此<角色名>应为接受奖励的角色."
L["Ignoring EP change for unknown member %s"] = "忽略对未知会员%s进行的EP改动"
L["Ignoring GP change for unknown member %s"] = "忽略对未知会员%s进行的GP改动"
L["Import"] = "导入"
L["Importing data snapshot taken at: %s"] = "导入%s截取的数据快照"
L["invalid input"] = "无效输入" -- Needs review
L["Invalid officer note [%s] for %s (ignored)"] = "人物 %s 包含无效的官员备注 [%s] (已被忽略)"
L["List errors"] = "列出错误"
L["Lists errors during officer note parsing to the default chat frame. Examples are members with an invalid officer note."] = "在默认聊天框架中列出解析官员备注时发生的错误. 例如具有无效官员备注的会员."
L["Loot"] = "拾取"
L["Loot tracking threshold"] = "战利品拾取追踪等级阀值"
L["Make sure you are the only person changing EP and GP. If you have multiple people changing EP and GP at the same time, for example one awarding EP and another crediting GP, you *are* going to have data loss."] = "确保你是唯一一个正在变更EP和GP的人。如果有多人同时变更EP和GP，比如一个人正在发放EP时另一个人记录GP，你*必定*会丢失数据。" -- Needs review
L["Mass EP Award"] = "群体EP奖励"
L["Min EP should be a positive number"] = "MinEP(最低贡献点数)应为正数"
L["must be equal to or higher than %s"] = "必须高于或者等于 %s" -- Needs review
L["must be equal to or lower than %s"] = "必须小于等于 %s" -- Needs review
L["Next award in "] = "距离下次奖励"
L["off"] = "关闭" -- Needs review
L["on"] = "打开" -- Needs review
L["Only display GP values for items at or above this quality."] = "仅为达到或超过此品质的物品显示GP值."
L["Open the configuration options"] = "设置选项"
L["Open the debug window"] = "开启调试窗口"
L["Other"] = "其它"
L["Outsiders should be 0 or 1"] = "替补为0或1" -- Needs review
L["Paste import data here"] = "粘贴导入数据至此"
L["Personal Action Log"] = "个人操作日志"
L["Provide a proposed GP value of armor on tooltips. Quest items or tokens that can be traded for armor will also have a proposed GP value."] = "在物品信息提示中提供装备的GP建议值. 任务物品或可用于交换装备的代币也将有一个GP建议值."
L["Quality threshold"] = "品质阀值" -- Needs review
L["Recurring"] = "循环"
L["Recurring awards resume"] = "周期性奖励重新开始"
L["Recurring awards start"] = "周期性奖励开始"
L["Recurring awards stop"] = "周期性奖励结束"
L["Redo"] = "重做"
L["Re-scale all main toons' GP to current tier?"] = "重新调整所有大号GP到当前级别" -- Needs review
L["Rescale GP"] = "重新调整 GP" -- Needs review
L["Rescale GP of all members of the guild. This will reduce all main toons' GP by a tier worth of value. Use with care!"] = "重新调整所有公会成员GP. 这样做会使所有主号的GP下降一个等级. 请小心使用!" -- Needs review
L["Reset all main toons' EP and GP to 0?"] = "重置所有主角色的EP及GP为零?"
L["Reset all main toons' GP to 0?"] = "重设所有人GP到0?" -- Needs review
L["Reset EPGP"] = "重置EPGP"
L["Reset only GP"] = "只重设GP" -- Needs review
L["Resets EP and GP of all members of the guild. This will set all main toons' EP and GP to 0. Use with care!"] = "重置全体公会成员的EP及GP, 此操作将重置所有主角色的EP及GP为零. 慎重使用!"
L["Resets GP (not EP!) of all members of the guild. This will set all main toons' GP to 0. Use with care!"] = "重设所有工会成员的GP(不是EP!). 这样做将会使所有主号的GP清零. 请小心使用!" -- Needs review
L["Resume recurring award (%s) %d EP/%s"] = "重新开始周期性奖励 (%s) %d EP/%s"
L["%s: %+d EP (%s) to %s"] = "%s: %+d EP (%s) 给 %s"
L["%s: %+d GP (%s) to %s"] = "%s: %+d GP (%s) 给 %s"
L["Sets loot tracking threshold, to disable the popup on loot below this threshold quality."] = "设置拾取追踪品质阀值, 拾取低于设定品质阀值的物品时禁用弹出框."
L["Sets the announce medium EPGP will use to announce EPGP actions."] = "设置用来通告EPGP操作的EPGP通告媒介."
L["Sets the custom announce channel name used to announce EPGP actions."] = "设置用来通告EPGP操作的自定义通告频道名称."
L["'%s' - expected 'on', 'off' or 'default', or no argument to toggle."] = "'%s' - 选择“on”，“off”或者“default”，否则将无法触发" -- Needs review
L["'%s' - expected 'on' or 'off', or no argument to toggle."] = "'%s' - 选择“on”，“off”或者“default”，否则将无法触发" -- Needs review
L["'%s' - expected 'RRGGBBAA' or 'r g b a'."] = "'%s' - 需要 “RRGGBBAA” 或 “r g b a”." -- Needs review
L["'%s' - expected 'RRGGBB' or 'r g b'."] = "'%s' - 期望参数 'RRGGBB' 或 'r g b'." -- Needs review
L["Show everyone"] = "显示所有人"
L["'%s' - Invalid Keybinding."] = "'%s' - 无效按键绑定" -- Needs review
L["%s is added to the award list"] = "%s 被添加进奖励名单中"
L["%s is already in the award list"] = "%s 已经在奖励名单中了"
L["%s is dead. Award EP?"] = "%s 被击杀. 奖励EP?"
L["%s is not eligible for EP awards"] = "%s 无资格获得EP奖励"
L["%s is now removed from the award list"] = "已从奖励名单中移除了 %s"
L["Some english word"] = "一些英语" -- Needs review
L["Some english word that doesn't exist"] = "一些不存在的英语" -- Needs review
L["'%s' '%s' - expected 'on', 'off' or 'default', or no argument to toggle."] = "'%s' '%s' - 期望参数 'on', 'off' 或 'default', 没有参数则在状态间切换." -- Needs review
L["'%s' '%s' - expected 'on' or 'off', or no argument to toggle."] = "'%s' '%s' - 期望值为 'on' 或 'off'. 没有参数则在 'on' 与 'off' 之间切换." -- Needs review
L["%s: %s to %s"] = "%s: %s 由 %s"
L["Standby"] = "待命"
L["Standby whispers in raid"] = "发送密语的待命人员"
L["Start recurring award (%s) %d EP/%s"] = "开始周期性奖励 (%s) %d EP/%s"
L["Stop recurring award"] = "停止周期性奖励"
L["%s to %s"] = "%s 由 %s"
L["string1"] = "串" -- Needs review
L["'%s' - values must all be either in the range 0-1 or 0-255."] = "'%s' - 必须选择0-1 或 0-255之间的值" -- Needs review
L["'%s' - values must all be either in the range 0..1 or 0..255."] = "'%s' - 必须选择0-1 或 0-255之间的值" -- Needs review
L["The imported data is invalid"] = "导入数据无效"
L["To export the current standings, copy the text below and post it to: %s"] = "如要导出当前积分表, 复制以下文本并发布至 %s"
L["Tooltip"] = "工具栏提示"
L["To restore to an earlier version of the standings, copy and paste the text from: %s"] = "如要还原到一个较早版本的积分表, 需从 %s 复制并粘贴文本"
L["Undo"] = "撤销"
L["unknown argument"] = "未知条件" -- Needs review
L["unknown selection"] = "未知选择" -- Needs review
L["Using %s for boss kill tracking"] = "使用%s以追踪首领击杀。"
L["Value"] = "数值"
L["Whisper"] = "密语"
L["Wipe awards"] = "灭团奖励"
L["Wiped on %s. Award EP?"] = "在 %s 的战斗中灭团. 奖励EP?" -- Needs review
L["You can now check your epgp standings and loot on the web: http://www.epgpweb.com"] = "现在你可访问如下网站查阅自己的epgp积分和已获得战利品: http://www.epgpweb.com"
