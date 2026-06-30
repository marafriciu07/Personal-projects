#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include <stdlib.h>
#include "chess.h"

void init(char table[][8])
{
    //white pawns
    for(int j = 0; j < 8; j++)
        table[1][j] = 'P';

    //white and black pieces
    for(int j = 0; j <= 4; j++)
    {
        if(j == 0)
        {
            table[0][j] = 'R';
            table[0][7 - j] = 'R';
            table[7][j] = 'r';
            table[7][7 - j] = 'r';
        }
        if(j == 1)
        {
            table[0][j] = 'N';
            table[0][7 - j] = 'N';
            table[7][j] = 'n';
            table[7][7 - j] = 'n';

        }
        if(j == 2)
        {
            table[0][j] = 'B';
            table[0][7 - j] = 'B';
            table[7][j] = 'b';
            table[7][7 - j] = 'b';
        }
        if(j == 3)
        {
            table[0][j] = 'Q';
            table[0][7 - j] = 'Q';
            table[7][j] = 'q';
            table[7][7 - j] = 'q';
        }
        if(j == 4)
        {
            table[0][j] = 'K';
            table[7][j] = 'k';
        }
    }

    //black pawns
    for(int j = 0; j < 8; j++)
        table[6][j] = 'p';

    //else
    for(int i = 2; i < 6; i++)
    {
        for(int j = 0; j < 8; j++)
            table[i][j] = ' ';
    }
}

void print(char table[][8])
{
    printf("  abcdefgh  \n");

    for(int i = 7; i >= 0; i--)
    {
        printf("%d ", i + 1);

        for(int j = 0; j < 8; j++)
            printf("%c", table[i][j]);

        printf(" %d\n", i + 1);
    }

    printf("  abcdefgh  \n");
}

int get_line(char table[][8], char start_col, int start_row, int dc, int dr, char line[])
{
    int current_col = start_col - 'a';
    int current_row = start_row - 1;
    int count = 0;

    // we move the piece to the valid position
    current_col = current_col + dc;
    current_row = current_row + dr;

    while(current_row >= 0 && current_row < 8 && current_col >= 0 && current_col < 8)
    {
        line[count] = table[current_row][current_col];
        count++;
        current_col = current_col + dc;
        current_row = current_row + dr;
    }

    line[count] = '\0';

    return count;
}

void encode(char table[][8], char* fen)
{
    for(int i = 7; i >= 0; i--)
    {
        int ecount = 0;

        for(int j = 0; j < 8; j++)
        {
            char piece = table[i][j];

            if(piece == ' ')
                ecount++;
            else
            {
                // If we had accumulated empty squares, write the count first
                if(ecount > 0)
                {
                    *fen++ = ecount + '0';
                    ecount = 0;
                }

                *fen++ = piece;
            }
        }

        if(ecount > 0)
            *fen++ = ecount + '0';

        if(i > 0)
            *fen++ = '/';
    }

    *fen = '\0';
}

void decode(char table[][8], char* fen)
{
    for(int i = 0; i < 8; i++)
    {
        for(int j = 0; j < 8; j++)
            table[i][j] = ' ';
    }

    int i = 7;
    int j = 0;

    while(*fen != '\0' && i >= 0)
    {
        char c = *fen;

        if(isalpha(c))
        {
            if(j < 8)
            {
                table[i][j] = c;
                j++;
            }
        }
        else if(isdigit(c))
        {
            int ecount = c - '0';
            j = j + ecount;
        }
        else if(c == '/')
        {
            i--;
            j = 0;
        }

        fen++;
    }
}

move* all_moves(char table[][8], char tomove)
{
    int capacity = 20;
    int count = 0;

    move* moves = (move*)malloc(capacity * sizeof(move));

    if(moves == NULL)
        return NULL;

    int dr[] = {1, -1, 0, 0, 1, 1, -1, -1};
    int dc[] = {0, 0, 1, -1, 1, -1, 1, -1};

    for(int i = 0; i < 8; i++)
    {
        for(int j = 0; j < 8; j++)
        {
            char p = table[i][j];
            int is_own = 0;

            if(p != ' ')
            {
                if(tomove == 'w' && isupper(p))
                    is_own = 1;
                else if(tomove == 'b' && islower(p))
                    is_own = 1;
            }

            if(!is_own)
                continue;

            char type = tolower(p);
            int start_dir = 0;
            int end_dir = 8;

            if(type == 'r')
                end_dir = 4;
            else if(type == 'b')
                start_dir = 4;
            else if(type != 'q')
                continue;

            for(int d = start_dir; d < end_dir; d++)
            {
                for(int k = 1; k < 8; k++)
                {
                    int ni = i + k * dr[d];
                    int nj = j + k * dc[d];

                    if(ni < 0 || ni > 7 || nj < 0 || nj > 7)
                        break;

                    char target = table[ni][nj];
                    int capture = 0;
                    int blocked = 0;

                    if(target != ' ')
                    {
                        int is_opponent = 0;

                        if(tomove == 'w' && islower(target))
                            is_opponent = 1;
                        else if(tomove == 'b' && isupper(target))
                            is_opponent = 1;

                        if(is_opponent)
                            capture = 1;
                        else
                            blocked = 1;
                    }

                    if(blocked)
                        break;

                    if(count >= capacity - 1)
                    {
                        capacity *= 2;

                        move *temp = realloc(moves, capacity * sizeof(move));

                        if(temp == NULL)
                        {
                            free(moves);
                            return NULL;
                        }

                        moves = temp;
                    }

                    moves[count].c1 = 'a' + j;
                    moves[count].r1 = i + 1;
                    moves[count].c2 = 'a' + nj;
                    moves[count].r2 = ni + 1;

                    count++;

                    if(capture)
                        break;
                }
            }
        }
    }

    moves[count].c1 = 0;
    moves[count].c2 = 0;
    moves[count].r1 = 0;
    moves[count].r2 = 0;

    return moves;
}

void make_move(char table[][8], char c1, int r1, char c2, int r2)
{
    int col1 = c1 - 'a';
    int row1 = r1 - 1;

    int col2 = c2 - 'a';
    int row2 = r2 - 1;

    table[row2][col2] = table[row1][col1];
    table[row1][col1] = ' ';
}

//Checks if a piece belongs to the player whose turn it is
int is_own_piece(char piece, char tomove)
{
    if(tomove == 'w' && isupper(piece))
    {
        return 1;
    }

    if(tomove == 'b' && islower(piece))
    {
        return 1;
    }

    return 0;
}

// Checks if the destination square is empty
// or contains an opponent piece that can be captured
int can_move_to(char target, char tomove)
{

    if(target == ' ')
    {
        return 1;
    }

    // White can capture black pieces
    if(tomove == 'w' && islower(target))
    {
        return 1;
    }

    // Black can capture white pieces
    if(tomove == 'b' && isupper(target))
    {
        return 1;
    }

    return 0;
}

int is_valid_move(char table[][8], char c1, int r1, char c2, int r2, char tomove)
{
    // Check if the coordinates are inside the board
    if(c1 < 'a' || c1 > 'h' || c2 < 'a' || c2 > 'h')
    {
        return 0;
    }

    if(r1 < 1 || r1 > 8 || r2 < 1 || r2 > 8)
    {
        return 0;
    }

    // Convert chess coordinates into matrix indexes
    int col1 = c1 - 'a';
    int row1 = r1 - 1;

    int col2 = c2 - 'a';
    int row2 = r2 - 1;

    // A piece cannot stay on the same square
    if(row1 == row2 && col1 == col2)
    {
        return 0;
    }

    char piece = table[row1][col1];
    char target = table[row2][col2];

    // Check if the selected piece belongs to the current player
    if(!is_own_piece(piece, tomove))
    {
        return 0;
    }

    // Check if the destination is empty or contains an opponent piece
    if(!can_move_to(target, tomove))
    {
        return 0;
    }

    int row_difference = row2 - row1;
    int col_difference = col2 - col1;

    int abs_row_difference = abs(row_difference);
    int abs_col_difference = abs(col_difference);

    char type = tolower(piece);

    // Pawn movement
    if(type == 'p')
    {
        int direction;
        int starting_row;

        // White moves upwards on the board
        if(tomove == 'w')
        {
            direction = 1;
            starting_row = 1;
        }
        // Black moves downwards on the board
        else
        {
            direction = -1;
            starting_row = 6;
        }

        // Pawn moves one square forward
        if(col_difference == 0 &&
                row_difference == direction &&
                target == ' ')
        {
            return 1;
        }

        // Pawn moves two squares from its starting position
        if(col_difference == 0 &&
                row1 == starting_row &&
                row_difference == 2 * direction &&
                target == ' ' &&
                table[row1 + direction][col1] == ' ')
        {
            return 1;
        }

        // Pawn captures diagonally
        if(abs_col_difference == 1 &&
                row_difference == direction &&
                target != ' ')
        {
            return 1;
        }

        return 0;
    }

    // Knight movement
    if(type == 'n')
    {
        if((abs_row_difference == 2 && abs_col_difference == 1) ||
                (abs_row_difference == 1 && abs_col_difference == 2))
        {
            return 1;
        }

        return 0;
    }

    // King movement
    if(type == 'k')
    {
        if(abs_row_difference <= 1 && abs_col_difference <= 1)
        {
            return 1;
        }

        return 0;
    }

    int valid_direction = 0;

    // Rook moves only vertically or horizontally
    if(type == 'r')
    {
        if(row_difference == 0 || col_difference == 0)
        {
            valid_direction = 1;
        }
    }

    // Bishop moves only diagonally
    else if(type == 'b')
    {
        if(abs_row_difference == abs_col_difference)
        {
            valid_direction = 1;
        }
    }

    // Queen moves like a rook or a bishop
    else if(type == 'q')
    {
        if(row_difference == 0 ||
                col_difference == 0 ||
                abs_row_difference == abs_col_difference)
        {
            valid_direction = 1;
        }
    }

    if(valid_direction == 0)
    {
        return 0;
    }

    int row_step = 0;
    int col_step = 0;

    if(row_difference > 0)
    {
        row_step = 1;
    }
    else if(row_difference < 0)
    {
        row_step = -1;
    }

    if(col_difference > 0)
    {
        col_step = 1;
    }
    else if(col_difference < 0)
    {
        col_step = -1;
    }

    int current_row = row1 + row_step;
    int current_col = col1 + col_step;

    // Check if another piece blocks the path
    while(current_row != row2 || current_col != col2)
    {
        if(table[current_row][current_col] != ' ')
        {
            return 0;
        }

        current_row = current_row + row_step;
        current_col = current_col + col_step;
    }

    return 1;
}

//Find where the king is on the board
int find_king(char table[][8], char color, int *king_row, int *king_col)
{
    char king;

    if(color == 'w')
    {
        king = 'K';
    }
    else
    {
        king = 'k';
    }

    for(int i = 0; i < 8; i++)
    {
        for(int j = 0; j < 8; j++)
        {
            if(table[i][j] == king)
            {
                *king_row = i;
                *king_col = j;

                return 1;
            }
        }
    }

    return 0;
}

int is_square_attacked(char table[][8], int row, int col, char attacker)
{
    int dr_rook[] = {1, -1, 0, 0};
    int dc_rook[] = {0, 0, 1, -1};

    int dr_bishop[] = {1, 1, -1, -1};
    int dc_bishop[] = {1, -1, 1, -1};

    // Check attacks from rooks and queens
    for(int d = 0; d < 4; d++)
    {
        int current_row = row + dr_rook[d];
        int current_col = col + dc_rook[d];

        while(current_row >= 0 && current_row < 8 &&
                current_col >= 0 && current_col < 8)
        {
            char piece = table[current_row][current_col];

            if(piece != ' ')
            {
                if(attacker == 'w' && (piece == 'R' || piece == 'Q'))
                {
                    return 1;
                }

                if(attacker == 'b' && (piece == 'r' || piece == 'q'))
                {
                    return 1;
                }

                break;
            }

            current_row = current_row + dr_rook[d];
            current_col = current_col + dc_rook[d];
        }
    }

    // Check attacks from bishops and queens
    for(int d = 0; d < 4; d++)
    {
        int current_row = row + dr_bishop[d];
        int current_col = col + dc_bishop[d];

        while(current_row >= 0 && current_row < 8 &&
                current_col >= 0 && current_col < 8)
        {
            char piece = table[current_row][current_col];

            if(piece != ' ')
            {
                if(attacker == 'w' && (piece == 'B' || piece == 'Q'))
                {
                    return 1;
                }

                if(attacker == 'b' && (piece == 'b' || piece == 'q'))
                {
                    return 1;
                }

                break;
            }

            current_row = current_row + dr_bishop[d];
            current_col = current_col + dc_bishop[d];
        }
    }

    // Check attacks from knights
    int knight_dr[] = {2, 2, -2, -2, 1, 1, -1, -1};
    int knight_dc[] = {1, -1, 1, -1, 2, -2, 2, -2};

    for(int d = 0; d < 8; d++)
    {
        int current_row = row + knight_dr[d];
        int current_col = col + knight_dc[d];

        if(current_row >= 0 && current_row < 8 &&
                current_col >= 0 && current_col < 8)
        {
            char piece = table[current_row][current_col];

            if(attacker == 'w' && piece == 'N')
            {
                return 1;
            }

            if(attacker == 'b' && piece == 'n')
            {
                return 1;
            }
        }
    }

    // Check attacks from pawns
    if(attacker == 'w')
    {
        if(row - 1 >= 0 && col - 1 >= 0 && table[row - 1][col - 1] == 'P')
        {
            return 1;
        }

        if(row - 1 >= 0 && col + 1 < 8 && table[row - 1][col + 1] == 'P')
        {
            return 1;
        }
    }
    else
    {
        if(row + 1 < 8 && col - 1 >= 0 && table[row + 1][col - 1] == 'p')
        {
            return 1;
        }

        if(row + 1 < 8 && col + 1 < 8 && table[row + 1][col + 1] == 'p')
        {
            return 1;
        }
    }

    // Check attacks from kings
    for(int dr = -1; dr <= 1; dr++)
    {
        for(int dc = -1; dc <= 1; dc++)
        {
            if(dr == 0 && dc == 0)
            {
                continue;
            }

            int current_row = row + dr;
            int current_col = col + dc;

            if(current_row >= 0 && current_row < 8 &&
                    current_col >= 0 && current_col < 8)
            {
                char piece = table[current_row][current_col];

                if(attacker == 'w' && piece == 'K')
                {
                    return 1;
                }

                if(attacker == 'b' && piece == 'k')
                {
                    return 1;
                }
            }
        }
    }

    return 0;
}

int is_in_check(char table[][8], char color)
{
    int king_row;
    int king_col;
    char attacker;

    // Find the king of the current player
    if(!find_king(table, color, &king_row, &king_col))
    {
        return 0;
    }

    // If white is checked, the attacker is black
    if(color == 'w')
    {
        attacker = 'b';
    }
    else
    {
        attacker = 'w';
    }

    // Check if the opponent attacks the king's square
    if(is_square_attacked(table, king_row, king_col, attacker))
    {
        return 1;
    }

    return 0;
}

int has_legal_moves(char table[][8], char color)
{
    for(int i = 0; i < 8; i++)
    {
        for(int j = 0; j < 8; j++)
        {
            char piece = table[i][j];

            // Check if the piece belongs to the current player
            if(!is_own_piece(piece, color))
            {
                continue;
            }

            for(int ni = 0; ni < 8; ni++)
            {
                for(int nj = 0; nj < 8; nj++)
                {
                    char c1 = 'a' + j;
                    int r1 = i + 1;

                    char c2 = 'a' + nj;
                    int r2 = ni + 1;

                    // Check if the move follows the piece movement rules
                    if(!is_valid_move(table, c1, r1, c2, r2, color))
                    {
                        continue;
                    }

                    // Save the pieces before making the move
                    char old_piece = table[i][j];
                    char old_target = table[ni][nj];

                    // Make the move temporarily
                    make_move(table, c1, r1, c2, r2);

                    // If the king is not in check, this is a legal move
                    if(!is_in_check(table, color))
                    {
                        // Restore the board
                        table[i][j] = old_piece;
                        table[ni][nj] = old_target;

                        return 1;
                    }

                    // Restore the board if the move is not legal
                    table[i][j] = old_piece;
                    table[ni][nj] = old_target;
                }
            }
        }
    }

    // No legal move was found
    return 0;
}

int is_checkmate(char table[][8], char color)
{
    // A player can only be checkmated if their king is in check
    if(!is_in_check(table, color))
    {
        return 0;
    }

    // If the player still has a legal move, it is not checkmate
    if(has_legal_moves(table, color))
    {
        return 0;
    }

    // The king is in check and there are no legal moves
    return 1;
}
