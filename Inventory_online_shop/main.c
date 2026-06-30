#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

typedef struct node
{
    int id;
    double price;
    char name[100];
    char manufacturer[100];
    struct node *next;
} node;

typedef struct hash_table
{
    int capacity;
    int size;
    node **elements;
} hash_table;

node* new_node(int id, double price, char *name, char *manufacturer)
{
    node *q = (node *)malloc(1 * sizeof(node));
    if(q == NULL) return NULL;

    q->id = id;
    q->price = price;
    strcpy(q->name, name);
    strcpy(q->manufacturer, manufacturer);
    q->next = NULL;

    return q;
}

void allocate_hash(hash_table *HASH, int capacity_hash)
{
    HASH->capacity = capacity_hash;
    HASH->elements = calloc(HASH->capacity, sizeof(node *));
    if(HASH->elements == NULL) return;

    HASH->size = 0;
}

int hash_function(hash_table *HASH, int id)
{
    return id % HASH->capacity;
}

void insert_hash_table(hash_table *HASH, double price, char *name, char *manufacturer, int id)
{
    int index = hash_function(HASH, id);

    node *q = new_node(id, price, name, manufacturer);
    if(q == NULL)
    {
        return;
    }

    q->next = HASH->elements[index];
    HASH->elements[index] = q;

    HASH->size++;
}

void print_hash(hash_table *HASH)
{
    printf("Current Inventory Report\n\n");
    printf("ID   Product Name        Manufacturer       Price\n");
    printf("-------------------------------------------------\n");

    for(int i=0; i<HASH->capacity; i++)
    {
        node *current_node = HASH->elements[i];
        while(current_node != NULL)
        {
            printf("%d   %-18s %-18s $%.2lf\n",
                   current_node->id,
                   current_node->name,
                   current_node->manufacturer,
                   current_node->price);

            current_node = current_node->next;
        }
    }

    printf("-------------------------------------------------\n");
    printf("Total items in stock: %d\n", HASH->size);
}

int search_with_id(hash_table *HASH, int key, char *name)
{
    for(int i=0; i<HASH->capacity; i++)
    {
        if(HASH->elements[i]!= NULL)
        {
            node *q = HASH->elements[i];

            while(q != NULL)
            {
                /* cautare dupa ID */
                if(key != 0 && q->id == key)
                {
                    return q->id;
                }

                /* cautare dupa nume */
                if(key == 0 && strcmp(q->name, name) == 0)
                {
                    return q->id;
                }

                q = q->next;
            }
        }
    }
    return 0;
    //return 0 if did not found anything
}

void delete_hash_key(hash_table *HASH, int key, char *name)
{
    int new_id = search_with_id(HASH, key, name);

    if(new_id == 0)
    {
        printf("Product not found.\n");
        return;
    }

    int index = hash_function(HASH, new_id);

    node *p = NULL;
    node *q = HASH->elements[index];

    while(q != NULL && q->id != new_id)
    {
        p = q;
        q = q->next;
    }

    if(q == NULL) return;

    if(p!= NULL)
    {
        p->next = q->next;
    }
    else HASH->elements[index] = q->next;

    free(q);
    HASH->size--;

}

void gift_card_function(hash_table *HASH, double gift_card_value)
{
    node *q;
    node *p;

    for(int i = 0; i < HASH->capacity; i++)
    {
        q = HASH->elements[i];

        while(q != NULL)
        {
            for(int j = i; j < HASH->capacity; j++)
            {
                p = HASH->elements[j];

                while(p != NULL)
                {
                    if(q != p &&
                            fabs((q->price + p->price) - gift_card_value) < 0.001)
                    {
                        printf("You can buy the following items:\n");
                        printf("%s - $%.2lf\n", q->name, q->price);
                        printf("%s - $%.2lf\n", p->name, p->price);
                        return;
                    }

                    p = p->next;
                }
            }

            q = q->next;
        }
    }

    printf("No items add up exactly to your gift card value.\n");
}

int main()
{
    FILE *pf = fopen("products.txt", "r");

    if(pf == NULL)
    {
        printf("The file could not be opened.\n");
        return -1;
    }

    int n;
    fscanf(pf, "%d", &n);

    hash_table HASH;
    allocate_hash(&HASH, n);

    int id = 101;
    double price;
    char name[100];
    char manufacturer[100];

    for(int i = 0; i < n; i++)
    {
        fscanf(pf, "%99s %lf %99s", name, &price, manufacturer);

        insert_hash_table(&HASH, price, name, manufacturer, id);

        id++;
    }

    double gift_card_value;
    fscanf(pf, "%lf", &gift_card_value);

    printf("\nCurrent inventory:\n");
    print_hash(&HASH);

    printf("\nAfter deletion:\n");

    delete_hash_key(&HASH, 102, NULL);

    print_hash(&HASH);

    printf("\nGift card result for $%.2lf:\n", gift_card_value);
    gift_card_function(&HASH, gift_card_value);

    fclose(pf);

    return 0;
}
