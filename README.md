# Gobang

This project was completed when I was at grade 11.
The following description is my readme at that time.

```
————使用说明————
1.双击run.exe开始
2.菜单通过数字键控制
3.通过setting更改设置
4.上下左右控制光标，space控制下子
5.已经开放AI对战
6.运行后会产生一定的临时文件（*.five），可通过自带的bat文件清除
```

## Build and run

Firstly, you need to run `fpcmkcfg -d "basepath=${PATH_TO_FREE_PASCAL}" -o ./fpc.cfg`
to make sure free pascal compiler can find the units.
Secondly, make a `bin` directory in the workspace folder to put the executables.
Lastly, run `make` to compile the executables.

To use the nice interface and combat with my little gomoku AI, just run `bin/run`.