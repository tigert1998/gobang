uses crt;
var
    chessboard : array[1..19,1..19] of integer;
	i,j : longint;
	
procedure print;
var
    i,j : longint;
begin
    gotoxy(1,1);
	textbackground(6);
	textcolor(16);
	for i := 1 to 19 do 
	begin
	    write('|');
		for j := 1 to 17 do write('-+');
		writeln('-|');
	end;
	gotoxy(1,1);
end;
	
begin
    print;
    assign(output,'chessboard.five');
	rewrite(output);
    
    fillchar(chessboard,sizeof(chessboard),0);
	for i := 1 to 19 do
	begin
	    for j := 1 to 19 do
		    write(chessboard[i,j],' ');
		writeln;
    end; 
	
    close(output);
	assign(output,'Message_AI_position.five');
	rewrite(output);
	close(output);
	assign(output,'Message_checkEnd.five');
	rewrite(output);
	close(output);
	assign(output,'Message_AI_ID.five');
	rewrite(output);
	writeln(1);
	close(output);
end.