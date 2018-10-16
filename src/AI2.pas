USES crt;
const
    dx : array[1..4] of integer = (0,1,-1,1);
    dy : array[1..4] of integer = (-1,0,-1,-1);

var
    chessboard : text;
    who : longint;
	map,marks : array[1..19,1..19] of longint;
	effect : array[1..19,1..19] of boolean;
{                    ———————— 华丽丽的分割线 ————————            }
{                        ———————— 工具组 ————————                }
function law(x,y:longint):boolean forward;

function getWinner(x,y:longint):longint;
var
    way,i,st,en,newX,newY : longint;
	ok : boolean;
begin
    getwinner := 0;
    for way := 1 to 4 do
	begin
	    for st := -4 to 0 do
		begin
		    en := st + 4;
			if not law(x+st*dx[way],y+st*dy[way]) or not law(x+en*dx[way],y+en*dy[way]) then continue;
			ok := true;
			for i := st to en do
			begin
			    newX := x+i*dx[way];
				newY := y+i*dy[way];
				if map[newX,newY] <> map[x+st*dx[way],y+st*dy[way]] then begin ok := false; break; end;
			end;
			if ok and (map[x+st*dx[way],y+st*dy[way]] <> 0) then exit(map[x+st*dx[way],y+st*dy[way]]);
		end;
	end;
end;
	
procedure scanf;
var
    i,j : longint;
begin
    readln(who);
    for i := 1 to 19 do
    begin
        for j := 1 to 19 do
            read(chessboard,map[i,j]);
        readln(chessboard);
    end;
end;

function oppo(who:longint):longint;
begin
    if who = 1 then exit(2);
    oppo := 1;
end;

function law(x,y:longint):boolean;
begin
    if (x <= 0) or (y <= 0) then exit(false);
    if (x > 19) or (y > 19) then exit(false);
    law := true;
end;

{                    ———————— 华丽丽的分割线 ————————              }
{                        ———————— 人工智能 ————————                }

function mark(way,l,live:longint):longint;
begin	
    if (l = 5) and (live = 10) then mark := 10000000
	else if (l = 5) then mark := 7000000
    else if (l = 4) and (live = 10) then mark := 100000
    else if (l = 4) and (live <> 0) then mark := 10000
    else if (l = 3) and (live = 10) then mark := 1000
    else if (l = 3) and ((live = 5) or (live = 6)) then mark := 10
	else if (l = 3) and (live = 4) then mark := 4
    else if (l = 2) and (live = 10) then mark := 6;
	//if (way = 3) or (way = 4) then mark := trunc(mark * 2.7);
end;

function count(x,y,who,way:longint):longint;
var
    i,newX,newY : longint;
begin
    count := 0;
    for i := 0 to 4 do
    begin
        newX := x - dx[way]*i;
        newY := y - dy[way]*i;
        if not law(newX,newY) then exit;
        if map[newX,newY] = who then inc(count);
    end;
end;

function live(x,y,who,way:longint):longint;
var
    i,newX,newY,st,en : longint;
	space : boolean;
begin
    live := 10; { 1 }
    newX := x;
    newY := y;
    while law(newX,newY) and (map[newX,newY] = who) do
    begin
        newX := newX + dx[way];
        newY := newY + dy[way];
    end;
    if (not law(newX,newY)) or (map[newX,newY] = oppo(who)) then dec(live,5);

    newX := x - 4*dx[way];
    newY := y - 4*dy[way];
    while law(newX,newY) and (map[newX,newY] = who) do
    begin
        newX := newX - dx[way];
        newY := newY - dy[way];
    end;
    if not law(newX,newY) or (map[newX,newY] = oppo(who)) then dec(live,5);
    
    for i := 0 to 4 do
    begin
        newX := x - i*dx[way];
        newY := y - i*dy[way];
        if not law(newX,newY) then exit;
        if map[newX,newY] = oppo(who) then exit(0);
    end;
	
	space := false; { 2 }
    newX := x;
    newY := y;
    st := 0;
    while law(newX,newY) and (map[newX,newY] = 0) do
    begin
        newX := newX - dx[way];
        newY := newY - dy[way];
        inc(st);
    end;
    en := 4;
    newX := x - 4*dx[way];
    newY := y - 4*dy[way];
    while law(newX,newY) and (map[newX,newY] = 0) do
    begin
        newX := newX + dx[way];
        newY := newY + dy[way];
        dec(en);
    end;
    for i := st to en do
    begin
        newX := x - dx[way]*i;
        newY := y - dy[way]*i;
        if map[newX,newY] = 0 then
        begin
            space := true;
            break;
        end;
    end;
    if space and (live = 10) then exit(6);
    if space and (live = 0) and (count(x,y,who,way) >= 4) then exit(5);
	if space and (live = 5) then exit(4);
end;

function attack(x,y,who:longint):longint;
var
    way,curnum,curlive,power,newX,newY : longint;
begin
    map[x,y] := who;
    attack := 0;
    for way := 1 to 4 do
    begin
	    for power := 0 to 4 do 
		begin
		    newX := x + dx[way]*power;
			newY := y + dy[way]*power;
	        curnum := count(newx,newy,who,way);
            if curnum = 5 then
            begin
		        inc(attack,mark(way,5,0));
                continue;
            end;
		    curlive := live(newx,newy,who,way);
            if curlive = 0 then continue;
		    inc(attack,mark(way,curnum,curlive));
		end;
    end;
	map[x,y] := 0;
end;

function defend(x,y,who:longint):longint;
begin
    defend := trunc(attack(x,y,oppo(who)) * 0.3); 	
end;

procedure AI(who:longint;var x,y:longint);
var
    i,j,max : longint;
begin
    max := -1;
    for i := 1 to 19 do
	    for j := 1 to 19 do
		begin
		    if not effect[i,j] then continue;
		    if map[i,j] <> 0 then
			begin
			    marks[i,j] := 0;
				continue;
			end;
		    marks[i,j] := attack(i,j,who) + defend(i,j,who);
			if marks[i,j] > max then
			begin
			    max := marks[i,j];
				x := i;
				y := j;
			end;
		end;
end;
{
function search(x,y,who,k:longint):longint;
var
    oppoX,oppoY,newX,newY : longint;
begin
    search := 0;
    map[x,y] := who;
	search := attack(x,y,who) + defend(x,y,who);
	if k = 4 then exit;
	if getwinner(x,y) = who then exit(10000000);
    AI(oppo(who),oppoX,oppoY);
    map[oppoX,oppoY] := oppo(who);
    AI(who,newX,newY);
    inc(search,search(newX,newY,who,k+1));
    map[newX,newY] := 0;
    map[oppoX,oppoY] := 0;	
end;
}
{
procedure print;
var
    max,sum,i,j,choice,thought : longint;
	choiceX,choiceY : array[1..400] of longint;
begin
    max := -1;
	sum := 0;
    for i := 1 to 19 do
	    for j := 1 to 19 do
		begin
		    thought := search(i,j,who,1);
	        if thought > max then 
	        begin
	            sum := 1;
	        	max := thought;
	        	choiceX[sum] := i;
	        	choiceY[sum] := j;
	        	continue;
	        end;
	        if thought = max then 
	        begin
	            inc(sum);
	        	choiceX[sum] := i;
	        	choiceY[sum] := j;
	        	continue;
	        end;
		end;
    randomize;
    choice := random(sum)+1;
    writeln(choiceX[choice],' ',choiceY[choice]);
end;
}

procedure print;
var
    x,y : longint;
begin
    AI(who,x,y);
	writeln(x,' ',y);
end;

procedure steps;
var
    i1,j1,i,j,sum : longint;
begin
    sum := 0;
    fillchar(effect,sizeof(effect),false);
    for i := 1 to 19 do
	    for j := 1 to 19 do
		begin
		    if map[i,j] <> 0 then
			begin
			    inc(sum);
			    for i1 := i-2 to i+2 do
				    for j1 := j-2 to j+2 do
					begin
					    if not law(i1,j1) then continue;
						effect[i1,j1] := true;
					end;
			end;
		end;
	if sum = 0 then 
	begin
	    writeln('9 9');
		halt;
	end;
end;

{                    ———————— 华丽丽的分割线 ————————              }
{                        ———————— 主程序 ————————                  }

begin
  assign(chessboard,'chessboard.five');
  reset(chessboard);
  assign(input,'Message_AI2_ID.five');
  reset(input);
  assign(output,'Message_AI2_position.five');
  rewrite(output);

  scanf;
  steps;
  print;

  close(input);
  close(output);
  close(chessboard);
end.
