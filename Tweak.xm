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

struct Item {
	void** vtable;
	char filler[56];
};
static Item** Item$mItems;
static Item*(*Item)(const std::string&, short);
static Item*(*setIcon)(const std::string&, int);
static void(*setCategory)(CreativeItemCategory);
static void(*setMaxStackSize)(unsigned char);
static void(*setStackedByData)(bool);
static void(*addCreativeItem)(const ItemInstance&);

struct ItemInstance {
	void** vtable;
	unsigned char count;
	unsigned short aux;
	uintptr_t* userData;
	bool valid;
	Item* item;
	uintptr_t* block;
};
struct ItemInstance*(*ItemInstance)(const Item*, int);

enum struct CreativeItemCategory : unsigned char {
	BLOCKS = 1,
	DECORATIONS,
	TOOLS,
	ITEMS
};

int tim = 1000;

static void (*Item_initClientData)(Item*);
static void _Item_initClientData(Item* self) {
	Item$mItems[tim] = new Item("testitem", tim - 256);
	Item$mItems[tim]->setIcon("apple", 0);
	Item$mItems[tim]->setCategory(CreativeItemCategory::ITEMS);
	Item$mItems[tim]->setMaxStackSize(64);
	Item$mItems[tim]->setStackedByData(true);

	Item_initClientData(self);
}

static void (*Item_initCreativeItems)(Item*);
static void _Item_initCreativeItems(Item* self) {
	addCreativeItem(ItemInstance(Item$mItems[tim], 0));

	Item_initCreativeItems(self);
}

%ctor {
	MSHookFunction((void*)(0x10074242c + _dyld_get_image_vmaddr_slide(0)), (void*)&_Item_initClientData, (void**)&Item_initClientData);
	MSHookFunction((void*)(0x100734d00 + _dyld_get_image_vmaddr_slide(0)), (void*)&_Item_initCreativeItems, (void**)&Item_initCreativeItems);

	Item$mItems = (Item**)(0x1012ae238 + _dyld_get_image_vmaddr_slide(0));
	Item = (Item*(*)(const std::string&, short))(0x10074689c + _dyld_get_image_vmaddr_slide(0));
	setIcon = (Item*(*)(const std::string&, int))(0x100746b0c + _dyld_get_image_vmaddr_slide(0));
	setCategory = (void(*)(CreativeItemCategory))(0x100746dd0 + _dyld_get_image_vmaddr_slide(0));
	setMaxStackSize = (void(*)(unsigned char))(0x100746a88 + _dyld_get_image_vmaddr_slide(0));
	setStackedByData = (void(*)(bool))(0x100747974 + _dyld_get_image_vmaddr_slide(0));
	addCreativeItem = (void(*)(const ItemInstance&))(0x100745f10 + _dyld_get_image_vmaddr_slide(0));

	ItemInstance = (ItemInstance*(*)(const Item*, int))(0x1007569a4 + _dyld_get_image_vmaddr_slide(0));
}
