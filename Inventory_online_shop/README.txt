# Online Shop Inventory Management System

## Description

A C program that manages the inventory of an online shop using a hash table.

Each product has a unique ID, name, manufacturer, and price. The program reads products from a text file, stores them in a hash table, displays the inventory, deletes products, and finds two products whose prices add up to a given gift card value.

## Features

- Reads product data from `products.txt`
- Stores products in a hash table
- Uses linked lists to handle hash collisions
- Assigns product IDs starting from `101`
- Displays all products in the inventory
- Shows the total number of products in stock
- Deletes a product by ID or by name
- Searches for two products whose prices add up to a gift card value
- Uses dynamic memory allocation

## Product Information

Each product contains:

- `id` - unique product identifier
- `name` - product name
- `manufacturer` - manufacturer name
- `price` - product price

## Input File Format

The program reads data from a file named `products.txt`.

The first line contains the number of products.

Each following line contains:

```txt
ProductName Price Manufacturer