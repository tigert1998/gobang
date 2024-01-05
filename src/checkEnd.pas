const
    dx : array[1..4] of integer = (1,0,1,-1);
	dy : array[1..4] of integer = (0,1,1,1);
var
    i,j : longint;
	chessboard : array[1..19,1..19] of longint;
	
function law(x,y:longint):boolean;
begin
    if (x <= 0) or (y <= 0) then exit(false);
	if (x > 19) or (y > 19) then exit(false);
	exit(true);
end;

function pointcheck(who,x,y:longint):boolean;
var
    way,nowX,nowY,st,i,sum : longint;
begin
    pointcheck := false;
    for way := 1 to 4 do
	begin
		for st := -4 to 0 do
		begin
		    nowX := x + dx[way]*st;
		    nowY := y + dy[way]*st; 
			if not law(nowX,nowY) then continue;
			sum := 0;
			if chessboard[nowX,nowY] = who then inc(sum);
			for i := 1 to 4 do
			begin
			    inc(nowX,dx[way]);
				inc(nowY,dy[way]);
				if not law(nowX,nowY) then continue;
				if chessboard[nowX,nowY] = who then inc(sum);
			end;
			if sum = 5 then exit(true);
		end;
	end;
end;

function check(who:integer):boolean;
var
    i,j : longint;
begin
    check := false;
    for i := 1 to 19 do
	    for j := 1 to 19 do
		begin
		    if pointcheck(who,i,j) then exit(true);
		end;
end;

begin
    assign(output,'Message_checkEnd.five');
	rewrite(output);
    assign(input,'chessboard.five');
	reset(input);
	
	for i := 1 to 19 do
	begin
	    for j := 1 to 19 do
		    read(chessboard[i,j]);
		readln;
	end;
	if check(1) then writeln(1)
	else if check(2) then writeln(2)
	else writeln(0);
	
	close(output);
end.