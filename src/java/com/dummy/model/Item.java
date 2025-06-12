package com.dummy.model;

// Model class representing a dummy item
public class Item {
    private int itemID; // Unique ID for the item
    private String name; // Item name
    private String description; // Item description

    // Constructor
    public Item() {}

    public Item(String name, String description) {
        this.name = name;
        this.description = description;
    }

    // Getters and Setters
    public int getItemID() {
        return itemID;
    }

    public void setItemID(int itemID) {
        this.itemID = itemID;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}