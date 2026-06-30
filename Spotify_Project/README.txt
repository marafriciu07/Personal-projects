# Spotify Playlist in C

## Description

A simple playlist manager written in C using a linked list. The program stores songs and albums, displays the playlist, searches for songs, shows songs from a selected album, and shuffles the playlist.

## Features

- Add songs to the end of the playlist
- Display all songs in the playlist
- Search for a song by name
- Show all songs from a specific album
- Shuffle the playlist
- Uses a singly linked list
- Uses dynamic memory allocation

## Data Structure

Each song is stored in a node containing:

```c
char *song_name;
char *album;
struct node *next;