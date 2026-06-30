#ifndef CHESS_H_INCLUDED
#define CHESS_H_INCLUDED

void init(char table[][8]);

void print(char table[][8]);

int get_line(char table[][8], char start_col, int start_row, int dc, int dr, char line[]);

void encode(char table[][8], char* fen);

void decode(char table[][8], char* fen);

typedef struct{
	char c1, c2;
	int r1, r2;
}move;

move* all_moves(char table[][8], char tomove);

int is_own_piece(char piece, char tomove);

int can_move_to(char target, char tomove);

void make_move(char table[][8], char c1, int r1, char c2, int r2);

int is_valid_move(char table[][8], char c1, int r1, char c2, int r2, char tomove);

int find_king(char table[][8], char color, int *king_row, int *king_col);

int is_square_attacked(char table[][8], int row, int col, char attacker);

int is_in_check(char table[][8], char color);

int has_legal_moves(char table[][8], char color);

int is_checkmate(char table[][8], char color);

#endif // CHESS_H_INCLUDED
