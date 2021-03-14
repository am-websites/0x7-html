#include <stdio.h>

/* by Anreas Müller, 2005 */

/* this program may be used under the conditions of the GNU General Public License */

char board[9][9]=
{
{0,2,0,0,0,0,0,7,0},
{9,0,0,5,0,8,0,0,4},
{0,0,0,0,0,0,0,0,0},
{4,0,0,0,3,0,0,0,8},
{0,7,0,0,9,0,0,2,0},
{6,0,0,0,1,0,0,0,5},
{0,0,0,0,0,0,0,0,0},
{5,0,0,6,0,4,0,0,1},
{0,3,0,0,0,0,0,9,0},
};

int total;

void print_board(void) {
	int i,j;
	for (i=0;i<9;i++) {
		for (j=0;j<9;j++) {
			if (j==3||j==6) printf("|");
			printf("%d",board[i][j]);
		}
		printf("\n");
		if (i==2||i==5) printf("---+---+---\n");
	}
}


char is_possible_solution(char row, char col) {
	char element,i,j;
	total++;
	element=board[row][col];
	for (i=0;i<9;i++) {
		/* check row */
		if (col!=i) {
			if (board[row][i]==element) return 0;
		}
		/* check column */
		if (row!=i) {
			if (board[i][col]==element) return 0;
		}
		/* check subsquare */
		if (i%3!=row%3 && i/3!=col%3) {
			if (board[(row-row%3)+(i%3)][(col-col%3)+i/3]==element) return 0;
		}
	}
	return 1;
}

char board_ok(void) {
	char i,j;
	for (i=0;i<9;i++) for (j=0;j<9;j++) {
		if (board[i][j]==0) continue;
		if (!is_possible_solution(i,j)) {
			printf("row %d col %d: invalid element (%d)\n",i,j,board[i][j]); 
			print_board();
			return 0;
		}
	}
	return 1;
}

char bruteforce_subboard(char row, char col) {
	int i;
	if (board[row][col]>0) { /* predefined field */
		if (row==8 && col == 8) { /* found solution */
			return 1;
		} else { /* try changing next field */
			return bruteforce_subboard(row+(col+1)/9,(col+1)%9);
		}
	} else {  /* check all values */
		for (i=1;i<=9;i++) {
			board[row][col]=i;
			if (is_possible_solution(row,col)) {
				if (row==8 && col==8) { /* found solution */
					return 1;
				} else {
					if (bruteforce_subboard(row+(col+1)/9,(col+1)%9)) {
						return 1;  /* found solution */
					}
					/* don't return, but continue if no solution was found */
				}
			}
		}
		board[row][col]=0;
		return 0; /* no solution in this subset */
	}
}

int main(int argc, char *argv[]) {
	total=0;
	if (board_ok()) {
        	printf("Solution possible, trying all numbers...\n");
	} else {
		printf("Invalid board, exiting.\n");
	}
	if (bruteforce_subboard(0,0)) {
		print_board();
		printf("result found!\n");
	} else {
		printf("tried all options, but no result found!\n");
	}
	printf("total moves checked: %d\n",total);
}
