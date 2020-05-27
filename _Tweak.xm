#import "../substrate.h"
#import <UIKit/UIKit.h>
#import <mach-o/dyld.h>
#import <initializer_list>
#import <vector>
#import <map>
#import <mach-o/dyld.h>
#import <string>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <initializer_list>
#import <vector>
#import <mach-o/dyld.h>
#import <UIKit/UIKit.h>
#import <iostream>
#import <stdio.h>
#include <sstream>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <string.h>
#include <algorithm>
#include <fstream>
#include <ifaddrs.h>
#include <stdint.h>
#include <dlfcn.h>

struct TextureUVCoordinateSet;

struct item {
	uintptr_t** vtable;
	uint8_t maxStackSize;
	int idk;
	std::string atlas;
	int frameCount;
	bool animated;
	short itemId;
	std::string name;
	std::string idk3;
	bool isMirrored;
	short maxDamage;
	bool isGlint;
	bool renderAsTool;
	bool stackedByData;
	uint8_t properties;
	int maxUseDuration;
	bool explodeable;
	bool shouldDespawn;
	bool idk4;
	uint8_t useAnimation;
	int creativeCategory;
	float idk5;
	float idk6;
	TextureUVCoordinateSet& icon;
	char filler[44];
};

typedef struct item Item;

struct iteminstance {
	uint8_t count;
	uint16_t aux;
	uintptr_t* tag;
	Item* item;
	uintptr_t* block;
	int idk[3];
};

typedef struct iteminstance ItemInstance;

struct enum CreativeItemCategory : unsigned char {
	BLOCKS = 1,
	DECORATIONS,
	TOOLS,
	ITEMS
};

static Item** Item$mItems;
static Item*(*Item$Item)(Item*, const std::string&, short);
static Item*(*Item$setIcon)(Item*, const std::string&, int);
static void(*Item$setCategory)(Item*, CreativeItemCategory);
static void(*Item$setMaxStackSize)(Item*, unsigned char);
static void(*Item$setStackedByData)(Item*, bool);
static void(*Item$addCreativeItem)(Item*, const ItemInstance&);

static ItemInstance*(*ItemInstance$ItemInstance)(ItemInstance*, const Item*, int);

int tim = 1000;
ItemInstance* inst = NULL;

static void (*Item_initClientData)(Item*);
static void _Item_initClientData(Item* self) {

	Item* myItemPtr = (Item*) malloc(sizeof(Item));

	Item$Item(myItemPtr, "testitem", tim - 0x100);

	Item$mItems[tim] = myItemPtr;
	Item$setIcon(myItemPtr, "apple", 0);
	Item$setCategory(myItemPtr, CreativeItemCategory::ITEMS);
	Item$setMaxStackSize(myItemPtr, 64);
	Item$setStackedByData(myItemPtr, true);

	Item_initClientData(self);
}

static void (*Item_initCreativeItems)(Item*);
static void _Item_initCreativeItems(Item* self) {

	Item$addCreativeItem(Item$mItems[tim], ItemInstance$ItemInstance(inst, Item$mItems[tim], 0));

	Item_initCreativeItems(self);
}

%ctor {
	MSHookFunction((void*)(0x10074242c + _dyld_get_image_vmaddr_slide(0)), (void*)&_Item_initClientData, (void**)&Item_initClientData);
	MSHookFunction((void*)(0x100734d00 + _dyld_get_image_vmaddr_slide(0)), (void*)&_Item_initCreativeItems, (void**)&Item_initCreativeItems);

	Item$mItems = (Item**)(0x1012ae238 + _dyld_get_image_vmaddr_slide(0));
	Item$Item = (Item*(*)(Item*, const std::string&, short))(0x10074689c + _dyld_get_image_vmaddr_slide(0));
	Item$setIcon = (Item*(*)(Item*, const std::string&, int))(0x100746b0c + _dyld_get_image_vmaddr_slide(0));
	Item$setCategory = (void(*)(Item*, CreativeItemCategory))(0x100746dd0 + _dyld_get_image_vmaddr_slide(0));
	Item$setMaxStackSize = (void(*)(Item*, unsigned char))(0x100746a88 + _dyld_get_image_vmaddr_slide(0));
	Item$setStackedByData = (void(*)(Item*, bool))(0x100747974 + _dyld_get_image_vmaddr_slide(0));
	Item$addCreativeItem = (void(*)(Item*, const ItemInstance&))(0x100745f10 + _dyld_get_image_vmaddr_slide(0));

	ItemInstance$ItemInstance = (ItemInstance*(*)(ItemInstance*, const Item*, int))(0x1007569a4 + _dyld_get_image_vmaddr_slide(0));
}
