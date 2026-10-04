┌───────────────────────────────────────────────────────────────────┐
│ ▄  ▄ ▄▄▄ ▄▄▄ ▄▄  ▄▄▄ ▄▄                                           │
│ █▀▄█ █▄  █ █ █▄▀ █▄█ █ █                                          │
│ ▀  ▀ ▀   ▀▀▀ ▀   ▀ ▀ ▀▀                                           │
│ By Anders Nivfors of THD                                          │
└───────────────────────────────────────────────────────────────────┘

  NFOPad是一种结合NFO查看以及快速和灵活的小型文本编辑器.
  它是微软记事本的延伸,扩展的设置和支持NFO文件.
  可以根据文件的扩展名确定是否使用ASCII字体.
  NFOPad也充分支持Unicode编码的文件.

  功能列表:
   - URL & E-mail 链接地址处理
   - 高度定制 (字体, 颜色, 应用程序设置)
   - 窗口自动调整宽度
   - 最近打开的文件列表
   - 复制选定文本到剪切板选项
   - 内置ASCII字体预览NFO文件
   - 文本滚动
   - Tab缩进符宽度设置
   - 便携式 (免安装)
   - 支持Unicode编码
   - 支持Alpha blend透明窗体
   - 多语言本地化
   - 集成到右键
   - 根据扩展名决定字体
   - 打印
   - 搜索 & 替换文本
   - 插入/覆盖模式
   - 转到行
   - 删除行
   - 拖拽到窗口打开文件
   - 改进的按住CTRL键双击选字
   - 打开当前目录的上一个/下一个文件
   - 总在最上面选项
   - ESC键退出
   - 自动换行选项
   - 微软记事本的日志功能

  访问我们的网页获取更多信息和更新:
  讨论区: http://truehumandesign.se

┌───────────────────────────────────────────────────────────────────┐
│ 历史版本                                                          │
├───────────────────────────────────────────────────────────────────┘
│
| ver 1.8     [2022-04-02]
:  - Added support for zooming the text with Ctrl+plus/Ctrl+minus/
     Ctrl+0 or scrollwheel
   - Added support for adding/removing a specified string to the 
     start of all selected lines (typically used for commenting 
     lines in scripts/source code)
   - All icons updated and 256x256 version added
   - Untabify now remove spaces as well as tabs
   - Added Reset all settings button to Options/Misc
   - "Allow changes to text" checkbox moved from menu to 
     Options/Misc to avoid accidental use of feature and READ ONLY 
     status bar item will be shown when set
   - bugfix: ctrl-stepping the caret did not work for some cases
   - bugfix: open new file with F6/F7 did not ask to save unchanged
     changes
   - bugfix: horizontal scroll position restored properly for a
     bunch of cases

  ver 1.75    [2020-02-09]
   - Triple clicking now selects the whole line
   - Open dialog now shows all file types by default
   - Recent files list now shows 10 files instead of 6 by default
   - Bugfix: opening a new file with the same contents as the
     currently open did not scroll the text to the top
   - Minor tweaks and fixes

  ver 1.74    [2018-06-16]
   - Improved detection of when to load text as unicode (tries to 
     detect UTF-8/UTF-16 even when the BOM is missing)
   - Fixed so non-text files containing null is displayed as
     expected
   - Pasted text with non-windows line endings (\n instead of \r\n)
     is now displayed properly
   - Fixed Replace/Replace all not working for some cases if
     clipboard was locked
   - URL detection improved to handle URLs within other tags
   - Initial paths set in Open/Save dialog when passing a file as
     argument to the exe
   - Misc. optimizations
   - Localization updates

  ver 1.73    [2017-09-09]
   - Added command for sorting the selected lines alphabetically
   - Recent files list instantly updated for all open NFOPad
     instances
   - Scrolled position is preserved so the selected text is kept in
     view (for when reopening files, changing wordwrap/font etc)
   - When reopening a file the text selection is no longer
     preserved if the selected text has changed
   - Fix for detection of email addresses within citation marks
   - Tabify behavior tweaked
   - .LOG feature (adding current date and time on open) now marks
     file as dirty as expected
   - Bugfix: Opening a file which ends with a non-empty line will
     no longer add one empty line
   - Bugfix: Ctrl+Insert and Shift+Insert no longer toggles
     OVERWRITE
   - Bugfix: Tabify honors read only setting
   - Minor fixes to both NFOPad and the installer

  ver 1.72    [2016-11-14]
   - Tab key will indent the current selection (tabify)
   - Hebrew localization added
   - Url/email detection improvements
   - Apostrophe added as word delimiter by default for better word
     selection in scripts/source code
   - App path registration fixed for non admin windows accounts
   - Installer updated to fix windows 10 issues
   - Bugfix: Delete line did not work as expected if word wrap was
     enabled

  ver 1.71    [2016-02-20]
   - Load times for large text files improved
   - Double clicking a word and keeping the button held down now
     allows the user to select several words just as ctrl + click
   - Slovak localization added
   - Set the NFOPad icon on "Edit with NFOPad" in the windows
     context menu
   - Opening an empty NFOPad, adding text and removing it again
     will no longer prompt to save on close
   - Added help text about starting the app as administrator when
     writing to the registry fails
   - Localization fixes
   - Bugfix: when having the menu bar hidden, AltGr no longer
     flickers the menu when held down
   - Bugfix: Auto Window Width no longer changes the window size
     when NFOPad is maximized

  ver 1.7     [2015-07-30]
   - 查找功能添加"输入即搜索"设置
   - 现在可以选择关联文件之后的图标, 旧图标升级与新增5个图标供选择
   - 修正文件扩展名的描述, 当与NFOPad关联时以显示正确的文件类型
   - 现在与NFOPad关联有效, 将会立即刷新资源管理器中的关联文件图标
   - 修正: Shell/Edit扩展窗口无法一直检测"使用NFO字体"的正确设置
   - 修正: "自动窗口宽度"在某些情况下无法正确显示
   - 语言文件修正

  ver 1.69    [2014-04-06]
   - 添加法国语言
   - 修复CTRL + 空格键删除整个单词

  ver 1.68    [2014-01-18]
   - 添加意大利语言
   - 部分语言与代码修正

  ver 1.67    [2013-10-27]
   - 添加巴西葡萄牙语言
   - 添加使用F6/F7在当前目录打开下一个/上一个文件
   - 在状态栏中双击路径可以复制到剪贴板
   - 修正: 当焦点在"查找"对话框时无法使用快捷键选取主窗口的文本查找
   - 修正: 有时选择了视窗以外在某些情况下文本的滚动位置恢复失败
   - 修正: 小幅修正

  ver 1.66    [2013-01-20]
   - 添加乌克兰语言
   - 可以在"选项"中选定INI文件的位置
   - 为了更直观查找文本将尝试滚动文本,所匹配的文本将不是在屏幕的底部
   - 修正"撤销"无法撤销以下操作:
     删除行,替换,全部替换,大小写转换与插入日期
   - 修正: "统计匹配"与"全部替换"的结果对话框隐藏于NFOPad主窗口
   - 修正: 当搜索到底部时如果向上搜索必须按两次

  ver 1.65    [2012-09-30]
   - 字词选择升级, 现在可以适用于ctrl+点击, ctrl+箭头方向键与双击
     现在还追加了选择一个单词再使用ctrl+shift+点击也能如预期工作.
   - 添加一个可定制的字词分隔符列表
   - 修正打开和保存大文件的性能
   - 修正: 部分操作系统无法正确显示NFO文件, 除了亚洲的操作系统用户
     取消默认启用"使用西部拉丁语编码读取NFO文件"
   - 修正: 当NFOPad设置为"总在最上面"时部分对话框隐藏在主窗口
   - 修正: 部分对话框的Windows信息/警告音效提示不正确
   - 修正: 主窗口被移动后部分对话框的位置不正确
   - 修正: 不显示锁定文件的文件大小
   - 修正: 更新葡萄牙语本地化文件
   - 小幅修正

  ver 1.64    [2012-04-14]
   - 添加匈牙利语言
   - 直接滚动(使用箭头方向键滚动文本)和在什么情况下才启用的一些选项
   - 改进当尝试保存unicode字符有错误编码时的对话框显示
   - 菜单栏可隐藏 (使用ALT键再次显示)
   - 你可以指定在屏幕的哪个位置打开NFOPad, 发送两个额外的命令行参数
     (nfopad.exe [文件路径] [x坐标] [y坐标])
   - 现在可以打开快捷方式的命令行参数指定的引用文件
   - 修正: 打开网络共享或路径很长的文件可能导致失败
   - 修正: 设置NFOPad语言时按下对话框的"确定"有时会提示错误的消息

  ver 1.63    [2011-11-20]
   - 添加韩国语言
   - 调整部分默认设置

  ver 1.62    [2011-10-23]
   - 添加俄罗斯语言
   - URL网址链接现在可以检测以www开头的网址 (不包含 http://)
   - 按键盘上的 "Insert" 键可以切换输入模式 (覆盖/插入)
   - 状态栏中提示输入模式, 也可以在状态栏项目中关闭提示
   - 修正: 打印时没有将文件的标题发送到打印机
   - 修正: 没有正确删除右键上下文菜单中的 "View with NFOPad"
   - 修正: 一些罕见的情况, 滚动位置与可选择文本被重置

  ver 1.61    [2011-10-02]
   - 添加中文简体本土语言
   - 添加支持alpha混合透明程序窗体 (与快速设置方式)
   - 添加当文本改变和未保存时程序标题有*星号提示
   - 添加设置禁止所有操作写入注册表, 以确保 100% 的可移植性
   - 修复按住CTRL键无法使用鼠标选择多个单词
   - 右键上下文菜单 "View with NFOPad" 更改为-> "Edit with NFOPad"
   - 修复小规模布局与代码优化
   - 修正: 使用F9-F12切换字体选择时保持文本滚动位置
   - 修正: 打印时tabs的处理不正确

  ver 1.6     [2010-10-05]
   - Polish localization added
   - Added option for toggling all status bar items on/off
   - Added new status bar items: file size, unicode indication,
     selection length (not shown by default)
   - "Match case" in the Find dialog is not saved between sessions
     anymore
   - Added setting for always using the standard tab width 8 for nfo
     files, since some nfo files assumes this (default true)
   - When reopening a file (F5) the text is scrolled back to the
     previous location
   - Find/replace/count performance greatly improved
   - Changed some default values for Auto Width
   - Fixes and tweaks on how to select text by double clicking and
     ctrl-clicking
   - Added a warning if trying to use a language when the language
     file has not been installed
   - Fixes, checks and warnings regarding reading and writing
     registry keys for all users using an windows account without
     admin rights
   - bugfix: Find dialog was always on top all other windows
   - bugfix: Changing font selection using the menu or keyboard
     shortcuts did not update the Save As dialog's default extension
   - bugfix: Misc localization fixes

  ver 1.59    [2010-07-22]
   - Program language can be set in options
   - Quick switch between NFO/text mode can be done from menu or
     with shortcut keys.
   - URL detection now work within xml tags
   - Default encoding for saving files can be set in options
   - Fixed taskbar icon to use the one with high resolution
   - German localization added
   - Portuguese localization added
   - Spanish localization added

  ver 1.58    [2010-05-16]
   - Added support for multiple languages in the GUI. Added
     localizations for Swedish
   - Added setting to select whether to save the window 
     position/size on exit
   - Added word count in the search dialog
   - Hourglass cursor shown during large operations
   - Replace All optimized
   - "New Window" will open the new window with a small offset
   - Bugfix: The program settings INI file is now saved as Unicode
   - Bugfix: Changing the word wrap setting no longer resets the
     tab width
   - Bugfix: Printing large texts with lots of tabs was very slow
   - Bugfix: Application could crash if unable to read the INI file

  ver 1.57    [2010-03-27]
   - Tab width can be set in Options
   - NFOPad warns if trying to save a text with unicode characters
     with an incompatible encoding
   - More intuitive word selection when double clicking a word.
   - Double clicking an URL or e-mail address will select it
   - Adding ".LOG" at the top of a text tells NFOPad to
     automatically add the current date and time to the text
     upon opening, just as Notepad.
   - Recent files list always sorted so the most recent files are
     shown first.
   - Word wrapping added when printing to make sure all text fits
     the page.
   - Bugfix: Removed false warning when printing
   - Bugfix: Tabs where not handled correctly when printing
   - Bugfix: URL/e-mail detection did not work in the end of 
     really long texts
   - Bugfix: Delete line was possible in read only mode
   - A bunch of minor tweaks

  ver 1.56    [2009-09-25]
   - Program settings can now be saved to an INI file or the
     windows registry
   - Added a READ ONLY notification in the status bar
   - "TXT file" is now shown in the Windows Explorer's New menu (can
     be turned off in Options)
   - Bugfix: fixed so force western latin encoding setting doesn't
     apply to unicode files
   - Bugfix: Save As and changing encoding would reload the wrong
     file (file saved correctly but wrong text loaded)

  ver 1.55    [2009-06-22]
   - New Options dialogue
   - Added Auto width, including settings in Options
   - Added operations for making the selected text uppercase,
     lowercase, sentence case, title case and inverted case
   - Added "Insert Time/Date"
   - Added support for URLs within {} and <>
   - Save dialog tweaks
   - Bugfix: URL detection didn't work on uppercase addresses

  ver 1.54    [2009-05-17]
   - Made a new icon for NFOPad (and all associated files)
   - Added option to search text in reverse direction (shift+F3)
   - Improved URL/e-mail detection to handle addresses within
     parenthesis/brackets and detect the following keywords:
     http://, https://, ftp://, ftps://, file://, gopher://,
     news://, nntp://, telnet://, wais://, prospero://
   - Added Reopen current file (F5)
   - Optimized "Replace all" to be >40 times faster
   - Changing the encoding of a file when saving will refresh the
     text to reflect the change
   - Bug fixes

  ver 1.53   [2009-04-13]
   - Added option "Load NFO files with western latin encoding",
     true by default. NFO files was not displayed properly for 
     users with a non latin OS language (such as Chinese or 
     Japanese).
   - Added separate colors for nfo/txt
   - Made it easier to associate new extensions with NFOPad and
     also made it possible to set what font to use for each
     extension
   - Fixed so you can use Start->Run "nfopad" to start NFOPad,
     even when the program wasn't installed using the installer
   - Removed unwanted shortcuts (CTRL + H, J, I, M)
   - Font character set is used and saved properly
   - Improved unicode support in Find/Replace dialog
   - Suggested filename cleared on New
   - Program renamed to NFOPad with a capital P
   - Various fixes

  ver 1.52    [2009-02-09]
   - Added support for some rare line ending characters, fixes
     problems with some NFO files having double blank lines
   - SaveAs dialog now suggests the previous path and filename
   - Bugfix: extension detection was case sensitive
   - Bugfix: you could open several font/color dialogs in Options
     which would stall NFOPad
   - Bugfix: parts of the recent items list could be cleared and
     using several NFOPad could overwrite recent items
   - Some minor fixes

  ver 1.51    [2009-01-09]
   - Fixed so locked files can be opened by NFOPad (files used by
     some other process)
   - Additional Unicode support, encoding can be selected upon open
     and save
   - Fixed so the scrolled location in the file is preserved upon
     replace
   - The SaveAs dialog suggests the default extension from the
     opened file
   - Shift+delete to remove a line only applies if nothing
     is selected in the text (else the selection is
     removed as expected)

  ver 1.5     [2008-12-01]
   - Full Unicode support
   - "Copy on select" added which copies the selected text on mouse
     up, can be enabled in Options
  - "New Window" menu item added. Opens a new instance of NFOPad
   - Replace functionality added
   - Selected text is automatically copied to the search field
   - Search dialog has new settings for "always start from top" 
     and "close on search"
   - Search dialog uses ASCII font if that is used in the text
   - Added support for Vista/XP themes.
   - Loading and saving of files rewritten (loading a large text is
     much faster)
   - Added option when using "extension determines font" to use
     either nfo or txt as default extension when saving and viewing
     files without extension
   - Increased max number of recent items to 20
   - Dropping a shortcut (.lnk) on NFOPad will open the referenced
     file as expected
   - Optimized url and e-mail detection which could be really slow
     on large text files
   - Changed how the application settings are stored, this
     unfortunately means all your old settings will be wiped
   - Readme added to Help menu
   - The standard windows taskbar menu items added
   - Fixed some printing issues
   - Fixed bug when clicking on an address in the text if it was on
     the last line
   - Default settings changed for text font and recent files count
   - Finally got rid of some old bugs

  ver 1.42    [2008-10-07]
   - Recent files list added to File menu
   - Shift+delete deletes the line
   - Fixed bug which asked if the user wanted to save changes twice
   - Updated some dialogs
   - Tooltip fixes
   - Fixed so UTF byte-order marks aren't displayed in the text 
     (but keeps it when saved)

  ver 1.41    [2008-03-24]
   - E-mail adress follow added (openens default e-mail client)
   - Added CTRL+click as default on e-mail and URL following
   - URL/e-mail follow tweaks and optimizations
   - Fixed small bug with the statusbar not being updated

  ver 1.4     [2007-11-24]
   - URL follow (on double or single click)
   - Status bar added, shows current line, column and full path
   - Goto line function added (CTRL+G)
   - Warning added when trying to save a file marked as read-only
   - Some minor fixes

  ver 1.3     [2007-05-13]
   - New ASCII fonts included for the nfo-files!
   - Font, font style and font size can be changed for both nfo and
     txt files
   - Printing of ASCII text possible
   - "Always on top" option added
   - Fixed bug with printing the text which messed up the tabs
   - When searching, the selected text is automatically copied to
     the search dialog
   - Fixed bug with NFOPad crashing if the computer had no default
     printer installed (WinXP/Vista)
   - Fixed so when saving and having word wrap enabled, the text is
     not scrolled to the top anymore
   - "Save changes to text?" dialog has a Cancel button
   - Options dialog tab order fixed
   
  ver 1.2     [2007-01-08]
   - new search dialog, search options updated
   - fixed bug that made program save wrapped text on new lines
   - updated associations options
   - default bg color tweaked
   - printing bugs fixed, still only plain text though
   - Maximized flag saved, fixes issues when closing the program
     when maximized
   - default font when "use extension to determine font" is changed
     to fixedsys
   - save dialog filters updated
   - namelist changed to show filename first
   - fixed bug with name list not being able to handle long
     filenames or spaces (in certain cases)
   - fixed bug with font not being updated on save file
   
  ver 1.1     [2006-10-08]
    - searching the text is now possible
    - added support for dropping files on the program
    - printing is now possible, the output is plain text though
    - the program will check the extension in order to set the
      correct font
    - added support for additional text encoding formats
    - program will quit on ESC
    - more shortcut keys for main menu added
    - Removed first time message about context integration (the
      feature can be set upon install or in options)
    - options added: 
    - Use extension to determine font
    - ask to save unsaved document upon exit
    - close program on ESC key
    - minor updates and bug fixes
.
: ver 1.0     [2004-03-08]
|   - first official version
│
├───────────────────────────────────────────────────────────────────┐
│ (c) True Human Design 2022                                        │
│ http://truehumandesign.se                                         │
└───────────────────────────────────────────────────────────────────┘
