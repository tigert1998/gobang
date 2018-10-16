program gobang;
uses crt,dos,sysutils;
const
  black = 1;
  white = 2;
var
  chessboard : array[1..19,1..19] of longint;
  way,pc1,pc2,human1,human2 : longint;
  musicOn : boolean;

procedure setpoint(x,y,who:integer) forward;
procedure clear_dialogue forward;
procedure dialogue(str1:string) forward;
procedure mainMenu forward;
procedure computer(id:string) forward;
procedure start forward;
function law(x,y:longint):boolean forward;
Procedure ctrl(who:integer) forward;
function getWinner:longint forward;
procedure endit(who:longint) forward;
procedure settings forward;
procedure first forward;
procedure print_chessboard forward;

{ 菜单·& 对话栏 }

procedure print_chessboard;
var
  i,j : longint;
begin
  gotoxy(1,1);
  textbackground(6);
  textcolor(0);
  for i := 1 to 19 do 
  begin
    write('|');
    for j := 1 to 17 do write('-+');
    writeln('-|');
  end;
  gotoxy(1,1);
end;

procedure init;
var 
  i : longint;
begin
  executeprocess('initialization','');
  clrscr;
  gotoxy(1,24);
  writeln('V 1.2 Code by TigerTang.');
  textbackground(7);
  textcolor(0);
  gotoxy(38,1);
  write('|');
  for i := 1 to 10 do write('-');
  write('|');
  gotoxy(40,1);
  write('Menu');
  for i := 2 to 18 do
  begin
    gotoxy(38,i);
    write('|');
    write('':10);
    gotoxy(49,i);
    write('|');
  end;
  gotoxy(38,19);
  write('|');
  for i := 1 to 10 do write('-');
  write('|');

  textbackground(3);
  gotoxy(1,20);
  write('|');
  for i := 1 to 47 do write('-');
  write('|');
  gotoxy(3,20);
  write('Message');
  for i := 21 to 22 do
  begin
    gotoxy(1,i);
    write('|');
    write('':47);
    gotoxy(49,i);
    write('|');
  end;
  gotoxy(1,23);
  write('|');
  for i := 1 to 47 do write('-');
  write('|');

  print_chessboard;
  fillchar(chessboard,sizeof(chessboard),0);
  way := 1;
  human1 := 2;
  pc1 := 1;
  musicOn := true;
  gotoxy(1,1);
end;

function findchoice(max:longint):char;
var
  str2 : string;
begin
  findchoice := readkey;
  if findchoice = 'q' then halt;
  str(max,str2);
  while (findchoice > str2) or (findchoice < '1') do
    findchoice := readkey;
end;

procedure clear_dialogue;
var
  x,y : longint;
begin
  x := whereX;
  y := whereY;
  textbackground(3);
  gotoxy(2,21);
  write('':47);
  gotoxy(2,22);
  write('':47);
  gotoxy(x,y);
end;

procedure dialogue(str1:string);
var
  l,x,y : longint;
  str2 : string;
begin
  textbackground(3);
  textcolor(0);
  x := whereX;
  y := whereY;
  clear_dialogue;
  l := length(str1);
  if l <= 47 then
  begin
    gotoxy(2,21);
    write(str1);
  end
  else
  begin
    str2 := copy(str1,48,l-48+1);
    delete(str1,48,l-47);
    gotoxy(2,21); write(str1);
    gotoxy(2,22); write(str2);
  end;
  gotoxy(x,y);
end;  

procedure mainMenu;
var
  x,y : longint;
  ch : char;
begin
  clear_dialogue;
  x := whereX;
  y := whereY;
  textcolor(12);
  textbackground(7);
  gotoxy(41,2);
  write('GoBang!');
  textcolor(0);
  gotoxy(39,4);
  write('1.Start');
  gotoxy(39,6);
  write('2.Settings');
  gotoxy(39,8);
  write('3.Clean');
  gotoxy(39,10);
  write('4.Exit');
  gotoxy(x,y);
  repeat
    ch := findchoice(4);
    if ch <> '3' then
    begin
      x := whereX;
      y := whereY;
      gotoxy(39,4);
      write('':10);
      gotoxy(39,6);
      write('':10);
      gotoxy(39,8);
      write('':10);
      gotoxy(39,10);
      write('':10);
      gotoxy(x,y);
    end;
    case ch of
      '1' : start;
      '2' : settings;
      '3' : 
        begin
          executeprocess('initialization','');
          fillchar(chessboard,sizeof(chessboard),0);
        end;
      '4' : halt;
    end;
  until ch <> '3';
end;

procedure mode;
var
  x,y : longint;
  ch : char;
begin
  clear_dialogue;
  x := whereX;
  y := whereY;
  textcolor(0);
  textbackground(7);
  gotoxy(39,4);
  write('1.Human&PC');
  gotoxy(39,6);
  write('2.Human&..');
  gotoxy(39,8);
  write('3.PC &  PC');
  gotoxy(39,10);
  write('4.Back');
  gotoxy(39,12);
  write('Default: ',way);
  gotoxy(x,y);
  repeat
    x := whereX;
    y := whereY;
    gotoxy(39,12);
    write('Default: ',way);
    gotoxy(x,y);
    ch := findchoice(4);
    case ch of
    '1' : begin way := 1; human1 := 2; pc1 := 1; end;
    '2' : begin way := 2; human1 := 1; human2 := 2; end;
    '3' : begin way := 3; pc1 := 1; pc2 := 2; end;
    '4' : 
      begin
        x := whereX;
        y := whereY;
        gotoxy(39,6);
        write('':10);
        gotoxy(39,8);
        write('':10);
        gotoxy(39,10);
        write('':10);  
        gotoxy(39,12);
        write('':10);  
        gotoxy(39,4);
        write('':10);  
        gotoxy(x,y);
        settings;
      end;
    end;
  until (ch = '4');
end;

procedure music;
var
  x,y : longint;
  ch : char;
begin
  clear_dialogue;
  x := whereX;
  y := whereY;
  textcolor(0);
  textbackground(7);
  gotoxy(39,4);
  write('1.On');
  gotoxy(39,6);
  write('2.Off');
  gotoxy(39,8);
  write('3.Back');
  gotoxy(39,10);
  if musicOn then write('Default: 1') else write('Default: 2');
  gotoxy(x,y);
  repeat
    x := whereX;
    y := whereY;
    gotoxy(39,10);
    if musicOn then write('Default: 1') else write('Default: 2');
    gotoxy(x,y);
    ch := findchoice(3);
    case ch of
    '1' : musicOn := true;
    '2' : musicOn := false;
    '3' : 
      begin
        x := whereX;
        y := whereY;
        gotoxy(39,6);
        write('':10);
        gotoxy(39,8);
        write('':10);
        gotoxy(39,10);
        write('':10);  
        gotoxy(39,4);
        write('':10);  
        gotoxy(x,y);
        settings;
      end;
    end;
  until (ch = '3');
end;

procedure settings;
var
  x,y : longint;
  ch : char;
begin
  clear_dialogue;
  x := whereX;
  y := whereY;
  textcolor(0);
  textbackground(7);
  gotoxy(39,4);
  write('1.Mode');
  gotoxy(39,6);
  write('2.First');
  gotoxy(39,8);
  write('3.Music');
  gotoxy(39,10);
  write('4.Back');
  gotoxy(x,y);
  ch := findchoice(4);
  x := whereX;
  y := whereY;
  gotoxy(39,6);
  write('':10);
  gotoxy(39,8);
  write('':10);
  gotoxy(39,10);
  write('':10); 
  gotoxy(39,4);
  write('':10); 
  gotoxy(x,y);     
  case ch of
    '1' : mode;
    '2' : first;
    '3' : music;    
    '4' : mainMenu;
  end;
end;

procedure first;
var
  x,y,who : longint;
  ch : char;
begin
  clear_dialogue;
  x := whereX;
  y := whereY;
  textcolor(0);
  textbackground(7);
  gotoxy(39,4);
  write('1.Human');
  gotoxy(39,6);
  write('2.PC1');
  gotoxy(39,8);
  write('3.PC2');
  gotoxy(39,10);
  write('4.Back');
  if pc1 = 1 then who := 2 
  else if (human1 = 1) and (way = 1) then who := 1
  else who := 3;
  gotoxy(39,12);
  write('Default: ',who);
  gotoxy(x,y);
  repeat
    x := whereX;
    y := whereY;
    gotoxy(39,12);
    if pc1 = 1 then who := 2 
    else if (human1 = 1) and (way = 1) then who := 1
    else who := 3;
    write('Default: ',who);
    gotoxy(x,y);
    ch := findchoice(4);
    case ch of
      '1' : begin way := 1; human1 := 1; pc1 := 2; end;
      '2' : begin human1 := 2; pc1 := 1; pc2 := 2; end;
      '3' : begin way := 3; pc2 := 1; pc1 := 2; end;
      '4' :
        begin
          x := whereX;
          y := whereY;
          gotoxy(39,6);
          write('':10);
          gotoxy(39,8);
          write('':10);
          gotoxy(39,4);
          write('':10); 
          gotoxy(39,10);
          write('':10);
          gotoxy(39,12);
          write('':10);          
          gotoxy(x,y);
          settings;
        end;
    end;
  until (ch = '4');
end;

{ ———————————————————————— }  

procedure computer(id:string);
var
  AI : text;
  x,y : longint;
begin
  assign(AI,'Message_AI_ID.five');
  rewrite(AI);
  if id = '1' then writeln(AI,pc1) else writeln(ai,pc2);
  close(AI);
  if id = '1' then executeprocess('AI1','') else executeprocess('AI2','');
  assign(AI,'Message_AI_position.five');
  reset(AI);
  readln(AI,x,y);
  close(AI);
  if id = '1' then setpoint(x,y,pc1) else setpoint(x,y,pc2);
end;

procedure start;
var 
  ch : char;
begin
  if way = 1 then 
  begin
    setpoint(19 div 2,19 div 2,1);
    if pc1 = 2 then computer('1'); 
    while true do
    begin
      ctrl(human1);
      if getwinner = human1 then endit(human1);
      computer('1');
      if getwinner = pc1 then endit(pc1);
    end;
  end
  else if way = 2 then
  begin
    gotoxy(17,9);
    while true do
    begin
      ctrl(human1);
      if getwinner = human1 then endit(human1);
      ctrl(human2);
      if getwinner = human2 then endit(human2);
    end;
  end
  else if way = 3 then
  begin
    if pc2 = 1 then computer('2');
    while true do
    begin
      computer('1');
      if getwinner = pc1 then endit(pc1);
      ch := readkey;
      computer('2');
      if getwinner = pc2 then endit(pc2);
      ch := readkey;
    end;
  end;
end;

{ ———————————————————————— }  

function law(x,y:longint):boolean;
begin
  if (x <= 0) or (y <= 0) then exit(false);
  if (x > 19) or (y > 19) then exit(false);
  law := true;
end;

Procedure setpoint(x,y,who:integer); 
var
  a,b,i,j:integer;
  chess : text;
begin
  textbackground(6);
  chessboard[x,y] := who;
  a := y*2-1; { on the screen }
  b := x;
  gotoxy(a,b);
  if who = black then textcolor(0) else textcolor(15);
  write('0');
  gotoxy(a,b);
  assign(chess,'chessboard.five');
  rewrite(chess);
  for i := 1 to 19 do
  begin
    for j := 1 to 19 do
      write(chess,chessboard[i,j],' ');
    writeln(chess);
  end;
  close(chess);
end;

Procedure ctrl(who:integer);
var
  x,y : longint;
  ch : char;
begin
  x := wherex;
  y := wherey;
  ch := readkey;
  if ch = 'q' then halt;
  while (ch <> ' ') do
  begin
    case ch of
      #72 : if law(y-1,(x+1) div 2) then gotoxy(x,y-1); { up }
      #80 : if law(y+1,(x+1) div 2) then gotoxy(x,y+1); { down }
      #75 : if law(y,((x-2)+1) div 2) then gotoxy(x-2,y); { left }
      #77 : if law(y,((x+2)+1) div 2) then gotoxy(x+2,y); { right }
    end;
    x := wherex;
    y := wherey;
    ch := readkey;
  end;
  if chessboard[y,(x+1) div 2] = 0 then setpoint(y,(x+1) div 2,who) else ctrl(who);
end;

function getWinner:longint;
var
  winner : text;
begin
  executeprocess('checkEnd','');
  assign(winner,'Message_checkEnd.five');
  reset(winner);
  readln(winner,getwinner);
  close(winner);
end;

procedure endit(who:longint);
var 
  ch : char;
begin
  if way = 1 then 
  begin
    if who = human1 then 
      dialogue('You win! Press any key to continue.')
    else
      dialogue('You lost! Press any key to continue.');
    if musicOn then 
    begin 
      // if who = human1 then winexec('music_win',0) else winexec('music_lose',0);
    end
  end
  else if way = 2 then 
  begin
    // if musicOn then winexec('music_win',0);
    if who = human1 then 
      dialogue('Player1 win! Press any key to continue.')
    else 
      dialogue('Player2 win! Press any key to continue.');
  end
  else if way = 3 then
  begin
    // if musicOn then winexec('music_win',0);
    if who = human1 then
      dialogue('AI1 win! Press any key to continue.')
    else
      dialogue('AI2 win! Press any key to continue.');
  end;
  ch := readkey;
  mainMenu;
end;

begin
   
  init;
  mainMenu;
  
end.
