# Console Chess Game in C

## Description

A console-based chess game written in C. The game displays an 8x8 chess board, allows two players to enter moves, validates piece movement, handles captures, checks for check, and detects checkmate.

## Features

- Standard 8x8 chess board
- Two-player console gameplay
- White and black turns
- Piece movement validation for:
  - Pawns
  - Knights
  - Bishops
  - Rooks
  - Queens
  - Kings
- Capturing opponent pieces
- Prevents moving onto your own piece
- Prevents moves that leave your own king in check
- Detects check
- Detects checkmate
- Board initialization
- FEN encoding and decoding
- Move generation for rooks, bishops, and queens

## Project Files

- `main.c` - Runs the game loop and reads player moves.
- `chess.c` - Contains the chess board functions, move validation, check, and checkmate logic.
- `chess.h` - Contains structures and function declarations.

## Piece Notation

White pieces are written using uppercase letters:

```txt
P - Pawn
N - Knight
B - Bishop
R - Rook
Q - Queen
K - King