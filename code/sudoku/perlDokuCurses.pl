#!/usr/bin/perl

#by Andreas Müller, 2005
#this program may be used under the conditions of the GNU General Public License

use Curses;

@board=
(
[0,7,0,0,0,5,9,0,0],
[0,0,5,0,0,0,0,0,0],
[0,0,2,0,0,8,0,6,0],
[0,9,0,0,0,0,0,0,8],
[5,0,0,1,0,0,0,0,6],
[4,0,0,0,6,0,0,2,0],
[0,5,0,9,0,0,7,0,0],
[0,0,0,0,0,0,8,0,0],
[0,0,7,4,0,0,0,1,0],
);

sub is_possible_solution {
	$row=$_[0]; $col=$_[1];
	$element=$board[$row][$col];
	for $i(0..8) {
		# check row
		if ($col!=$i) {
			$board[$row][$i]==$element && return 0;
		}
		# check column
		if ($row!=$i) {
			$board[$i][$col]==$element && return 0;
		}
		# check subsquare
		if ($i%3!=$row%3 && int($i/3)!=$col%3) {
			$board[($row-$row%3)+($i%3)][($col-$col%3)+int($i/3)]==$element && return 0;
		}
	}
	return 1;
}

sub board_ok {
	for $i(0..8) { for $j(0..8) {
		$board[$i][$j]==0 && next;
		if (!is_possible_solution($i,$j)) {
			print "row $i col $j: invalid element ($board[$i][$j])\n"; print_board();
			return 0;
		}
	}}
	return 1;
}

sub print_board {
	my $i=0; my $j=0;
	for $line(@board) {
		for $element(@$line) {
			print $element;
			$i++; ($i%9==3||$i%9==6)&& print "|";
		}
		print "\n"; 
		$j++; ($j==3||$j==6) && print"---+---+---\n";
	}
}

sub print_board_curses {
	my $i=0; my $j=0;
	for $line(@board) {
		for $element(@$line) {
			if ($element==0) { attrset(COLOR_PAIR(3)); }
			else { attrset(COLOR_PAIR(1)); }
                	printw("$element");
			$i++; 
			if (($i%9==3||$i%9==6)) { attrset(COLOR_PAIR(4)); printw("|"); }
		}
		printw("\n");
		$j++;
		if ($j==3||$j==6) { attrset(COLOR_PAIR(4)); printw("---+---+---\n"); }
	}
}

sub bruteforce_subboard {
	my $row=$_[0];
	my $col=$_[1];
	if ($board[$row][$col]>0) { #predefined field
		if ($row==8 && $col == 8) { #found solution
			return 1;
		} else { #try changing next field
			return bruteforce_subboard($row+int(($col+1)/9),($col+1)%9);
		}
	} else { #check all values
		for my $i(1..9) {
			$board[$row][$col]=$i;
			if (is_possible_solution($row,$col)) {
				move($row+int($row/3),$col+int($col/3));
				printw("%d",$i);
				refresh();
				if ($row==8 && $col == 8) { #found solution
					return 1;
				} else {
					if (bruteforce_subboard($row+int(($col+1)/9),($col+1)%9)) {
						return 1; #found solution
					}
					#don't return, but continue it no solution was found
				}
			}
		}
		$board[$row][$col]=0;
		move($row+int($row/3),$col+int($col/3));
		attrset(COLOR_PAIR(3));
		printw("0");
		refresh();
		attrset(COLOR_PAIR(2));
		return 0; #no solution in this subset
	}
}




# main
if (board_ok()) {
        print "Solution possible, trying all numbers...\n";
} else {
	print "Invalid board, exiting.\n";
}
initscr;
start_color();
init_pair(1,COLOR_GREEN,COLOR_BLACK);
init_pair(2,COLOR_BLUE,COLOR_BLACK);
init_pair(3,COLOR_RED,COLOR_BLACK);
init_pair(4,COLOR_WHITE,COLOR_BLACK);
attroff(A_BOLD);
print_board_curses();
refresh();
attrset(COLOR_PAIR(2));
$result=bruteforce_subboard(0,0);
clear;
endwin;
if ($result) {
	print_board();
	print "result found!\n";
} else {
	print "tried all options, but no result found!\n";
}
