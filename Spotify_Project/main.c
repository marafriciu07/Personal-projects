#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct node
{
    char *song_name;
    char *album;
    struct node *next;
} node;

typedef struct linked_list
{
    node *first;
    node *last;
    int size;
} linked_list;

node* new_node(char *song, char *alb)
{
    node *q = (node *)malloc(sizeof(node));
    if(q == NULL) return NULL;

    q->song_name = song;
    q->album = alb;
    q->next = NULL;

    return q;
}

void insert_last(linked_list *list, char *song, char *alb)
{
    node *q = new_node(song, alb);
    if(list->first == NULL)
    {
        list->first = q;
        list->last = q;
    }
    else
    {
        list->last->next = q;
        list->last = q;
    }
    list->size++;
}

void print_list(linked_list *list)
{
    node *q = list->first;
    while(q != NULL)
    {
        printf("%s - %s\n", q->song_name, q->album);
        q = q->next;
    }
}

int search_song(linked_list *list, char *song)
{
    node *q = list->first;
    while(q != NULL)
    {
        if(strcmp(q->song_name, song)==0)
            return 1;
        q = q->next;
    }
    return 0;
}

void print_album(linked_list *list, char *alb)
{
    node *q = list->first;
    while(q != NULL)
    {
        if(strcmp(q->album, alb)==0)
            printf("%s ", q->song_name);
        q = q->next;
    }
    if(q == NULL) return;
}

void shuffle_playlist(linked_list *list)
{
    if (list->size < 2) return;

    node **nodes = (node **)malloc(list->size * sizeof(node *));
    if(nodes == NULL) return;
    node *q = list->first;
    for (int i = 0; i < list->size; i++)
    {
        nodes[i] = q;
        q = q->next;
    }

    for (int i = list->size - 1; i > 0; i--)
    {
        int j = rand() % (i + 1);
        node *temp = nodes[i];
        nodes[i] = nodes[j];
        nodes[j] = temp;
    }

    list->first = nodes[0];
    for (int i = 0; i < list->size - 1; i++)
    {
        nodes[i]->next = nodes[i + 1];
    }

    nodes[list->size - 1]->next = NULL;
    list->last = nodes[list->size - 1];

    free(nodes);

}

int main()
{
    linked_list list;

    list.first = NULL;
    list.last = NULL;
    list.size = 0;

    insert_last(&list, "Slow Dance", "Midnight");
    insert_last(&list, "Back Again", "Open Road");
    insert_last(&list, "Daydream", "Soft Glow");
    insert_last(&list, "All Right", "Open Road");
    insert_last(&list, "Lost in Time", "Midnight");
    insert_last(&list, "Blue Lights", "Night Drive");

    printf("Original playlist:\n");
    print_list(&list);

    printf("\nSearching for Daydream:\n");

    if(search_song(&list, "Daydream") == 1)
    {
        printf("Song found.\n");
    }
    else
    {
        printf("Song not found.\n");
    }

    printf("\nSongs from Open Road:\n");
    print_album(&list, "Open Road");

    printf("\n\nShuffled playlist:\n");
    shuffle_playlist(&list);
    print_list(&list);

    return 0;
}
