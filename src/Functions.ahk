/*
  functions : func_[\w]+
  @Author   : johngrib82@gmail.com
  @Created  : 2015. NOV. 25
*/

/*
  mouse move
*/
func_mouse_move( ww, aa, ss, dd ) {
  ; mouse pointer move distance
  ; n + wasd : long distance
  ;     wasd : normal distance
  ; m + wasd : short distance
  ; , + wasd : 1 pixcel distance

  mul = 70
  if(1 == GetKeyState("n", "P"),){
  ;if(GetKeyState("SC01A", "P")){    ;  [
    mul = 400
  ;} else if (GetKeyState("SC01B", "P")){   ;   ]
  } else if (GetKeyState("m", "P")){   ;   ]
    mul = 10
  ;} else if (GetKeyState("SC02B", "P")){  ;  \
  } else if (GetKeyState("SC033", "P")){  ;  \
    mul = 1
  }

  leftFlag  := GetKeyState("a", "P") * -1 * mul * aa
  rightFlag := GetKeyState("d", "P") * mul * dd
  upFlag  := GetKeyState("w", "P") * -1 * mul * ww
  downFlag := GetKeyState("s", "P") * mul * ss

  MouseMove, % leftFlag + rightFlag, upFlag + downFlag, 00, R
return
}

/*
  mode change by i, o, a
*/
func_i_o_a(key) {
  SetCapsLockState, Off
  GetKeyState, isShiftDown, Shift, P
  CMD.changeMode("auto")
  
  if(key = "i"){
    if("D" == isShiftDown) 
      Send, {Home}
  } else if(key = "o"){
    if("D" == isShiftDown) 
      Send, {Up}
    Send, {End}{Enter}
  } else if(key = "a"){
    if("D" == isShiftDown) 
      Send, {End}
  }
}

/*
  goto bookmarked window
*/
func_win_mem_activate(num){  
  win_id := MARK[num]
  WinActivate ahk_id %win_id%
  return
}

/*
  bookmark window
*/
func_win_memorize(num) {
  activeWin := WinExist("A")
  MARK[num] := activeWin
    return
}

/*
  shows mode on gui
*/
show_mode(msg){

  if(STAT.HasKey(msg))
    mode := msg
  else
    mode := "NORMAL"

  set := STAT[mode]
  
  bg_color := CFG.get_value(mode, "bg_color")
  font_color := CFG.get_value(mode, "font_color")
  trans := CFG.get_sect(mode)["trans"]
  
  xx := CFG.get_value("STAT_LOC", "x")
  yy := CFG.get_value("STAT_LOC", "y")

  if( WinExist("avl_normal") and mode = "NORMAL" ){
    ControlSetText, Static1, -- %msg% --, avl_normal
  } else {
    create_gui("PANEL", set["_title"], msg, xx, yy, bg_color, font_color, trans) 
  }
}

/*
  shows gui
*/
create_gui(id, title, msg, x, y, bg_color, font_color, trans){
    Gui, %id%:Destroy
    Gui, %id%:+AlwaysOnTop +ToolWindow -Caption
    Gui, %id%:Color, %bg_color%
    Gui, %id%:Font, s9 bold, Verdana
    Gui, %id%:Add, Text, c%font_color%, -- %msg% --
    Gui, %id%:Show,NoActivate x%x% y%y%, %title%
    WinSet, Transparent, %trans%, %title%
}

/*
  moves window to 1 2 3 4 5 6 7 8 9 location
*/
move_window(mon, var, title){

  key := "FENCE" . mon
  
  if(not CFG.has_sect(key))
    return
  
    top   := CFG.get_value(key, "y")
    left  := CFG.get_value(key, "x")
    width := CFG.get_value(key, "width")
    height:= CFG.get_value(key, "height")

    xx := left, ww := Floor(width / 2)
    yy := top,  hh := Floor(height / 2)

    if(var <= 3){
    yy := top + hh
    } else if(var <= 6){
    hh := height
    }
    
    if(2 = Mod(var, 3))    {
      ww := width
    } else if(0 = Mod(var, 3)) {
      xx := left + width / 2
    }

  WinMove, % title, , xx, yy, ww, hh
}

/*
  paste using clipboard register
  copy using clipboard register
*/
paste_from_clipboard_register(key){
  temp := Clipboard
  Clipboard := CLIP.get_value(key)
  Send, ^{v}
  Clipboard := temp
}
copy_to_clipboard_register(key){
  temp := Clipboard
  Send, ^{c}
  Sleep 500
  CLIP.set_value(key, Clipboard)
  Clipboard := temp
}