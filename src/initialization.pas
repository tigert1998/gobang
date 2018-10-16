uses crt;
var
  chessboard : array[1..19,1..19] of integer;
  i,j : longint;

begin
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
