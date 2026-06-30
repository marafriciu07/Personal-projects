#include <stdio.h>
#include <ctype.h>
#include "chess.h"

int main()
{
    // The chess board
    char table[8][8];

    // White always starts the game
    char tomove = 'w';

    // Place all pieces on the board
    init(table);

    // The game continues until the program is stopped
    while(1)
    {
        char c1, c2;
        int r1, r2;

        // Show the current board before every turn
        print(table);

        // Display which player must make a move
        if(tomove == 'w')
        {
            printf("\nWhite to move.\n");
        }
        else
        {
            printf("\nBlack to move.\n");
        }

        // Read a move, for example: e2 e4
        printf("Enter move, for example e2 e4: ");

        if(scanf(" %c%d %c%d", &c1, &r1, &c2, &r2) != 4)
        {
            printf("Invalid input.\n");
            return 1;
        }

        // Convert uppercase input such as E2 E4 into lowercase
        c1 = tolower(c1);
        c2 = tolower(c2);

        // Check if both coordinates are on the chess board
        if(c1 < 'a' || c1 > 'h' ||
                c2 < 'a' || c2 > 'h' ||
                r1 < 1 || r1 > 8 ||
                r2 < 1 || r2 > 8)
        {
            printf("Move outside the board.\n");
            continue;
        }

        // Convert chess notation into matrix coordinates
        int col1 = c1 - 'a';
        int row1 = r1 - 1;

        int col2 = c2 - 'a';
        int row2 = r2 - 1;

        // Read the piece that the player wants to move
        char piece = table[row1][col1];

        // Read the piece from the destination square
        char target = table[row2][col2];

        // Check that the player selected one of their own pieces
        if(!is_own_piece(piece, tomove))
        {
            printf("You must move one of your own pieces.\n");
            continue;
        }

        // Check that the player is not moving onto their own piece
        if(!can_move_to(target, tomove))
        {
            printf("You cannot move onto your own piece.\n");
            continue;
        }

        if(!is_valid_move(table, c1, r1, c2, r2, tomove))
        {
            printf("Invalid move.\n");
            continue;
        }

        // Move the piece on the board
        make_move(table, c1, r1, c2, r2);

        // Check if the move leaves the current player's king in check
        if(is_in_check(table, tomove))
        {
            // Restore the old board position
            table[row1][col1] = piece;
            table[row2][col2] = target;

            printf("You cannot leave your king in check.\n");
            continue;
        }

        // Check if the opponent is checkmated
        if(tomove == 'w')
        {
            if(is_checkmate(table, 'b'))
            {
                print(table);
                printf("Checkmate. White wins.\n");
                break;
            }

            if(is_in_check(table, 'b'))
            {
                printf("Black is in check.\n");
            }

            tomove = 'b';
        }
        else
        {
            if(is_checkmate(table, 'w'))
            {
                print(table);
                printf("Checkmate. Black wins.\n");
                break;
            }

            if(is_in_check(table, 'w'))
            {
                printf("White is in check.\n");
            }

            tomove = 'w';
        }
    }

    return 0;
}
