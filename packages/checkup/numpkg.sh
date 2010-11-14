#!/bin/bash

num=`pacman -Qu | wc -l`
case $num in
0)
	echo "No"
	;;
1)
	echo "one"
	;;
2)
	echo "Two"
	;;
3)
	echo "Three"
	;;
4)
	echo "Four"
	;;
5)
	echo "Five"
	;;
6)
	echo "Six"
	;;
7)
	echo "Seven"
	;;
8)
	echo "Eight"
	;;
9)
	echo "Nine"
	;;
10)
	echo "Ten"
	;;
11)
	echo "Eleven"
	;;
12)
	echo "Twelve"
	;;
13)
	echo "Thirteen"
	;;
14)
	echo "Fourteen"
	;;
15)
	echo "Fifteen"
	;;
16)
	echo "Sixteen"
	;;
17)
	echo "Seventeen"
	;;
18)
	echo "Eighteen"
	;;
19)
	echo "Nineteen"
	;;
20)
	echo "Twenty"
	;;
21)
	echo "Twenty one"
	;;
22)
	echo "Twenty Two"
	;;
23)
	echo "Twenty Three"
	;;
24)
	echo "Twenty Four"
	;;
25)
	echo "Twenty Five"
	;;
26)
	echo "Twenty Six"
	;;
[27-99])
	echo "Loads of"
	;;

esac

