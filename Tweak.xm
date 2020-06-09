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

typedef struct {
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
	uintptr_t* icon;
	char filler[44];
} Item;

typedef struct {
	uint8_t count;
	uint16_t aux;
	uintptr_t* tag;
	Item* item;
	uintptr_t* block;
	int idk[3];
} ItemInstance;

static Item** Item$mItems;
static Item*(*Item$Item)(Item*, const std::string&, short);
static Item*(*Item$setIcon)(Item*, const std::string&, int);

static void(*Item$addCreativeItem)(const ItemInstance&);

static ItemInstance*(*ItemInstance$ItemInstance)(ItemInstance*, const Item*, int);

int tim = 453;

static void (*Item_initClientData)(uintptr_t*);
static void _Item_initClientData(uintptr_t* self) {
	Item_initClientData(self);
}

//おそらくクリエに追加しているのが原因...?
//ItemInstanceのコンストラクタの型がダメ?
//Item::addCreativeItemのアドレスは合ってる
static void (*Item_initCreativeItems)(uintptr_t*);
static void _Item_initCreativeItems(uintptr_t* self) {
	Item* myItemPtr = new Item();
	Item$Item(myItemPtr, "testitem", tim - 0x100);
	Item$mItems[tim] = myItemPtr;
	Item$setIcon(myItemPtr, "apple", 0);
	myItemPtr->creativeCategory = 3;
	
	ItemInstance* inst = new ItemInstance();
	ItemInstance$ItemInstance(inst, Item$mItems[tim], 0);
	Item$addCreativeItem(*inst);

	Item_initCreativeItems(self);
}

static std::string (*Common_getGameDevVersionString)(uintptr_t*);
static std::string _Common_getGameDevVersionString(uintptr_t* common) {

	return "Modded!";
}

%ctor {
	MSHookFunction((void*)(0x10074242c + _dyld_get_image_vmaddr_slide(0)), (void*)&_Item_initClientData, (void**)&Item_initClientData);
	MSHookFunction((void*)(0x100734d00 + _dyld_get_image_vmaddr_slide(0)), (void*)&_Item_initCreativeItems, (void**)&Item_initCreativeItems);
	MSHookFunction((void*)(0x10006bc94 + _dyld_get_image_vmaddr_slide(0)), (void*)&_Common_getGameDevVersionString, (void**)&Common_getGameDevVersionString);

	Item$mItems = (Item**)(0x1012ae238 + _dyld_get_image_vmaddr_slide(0));
	Item$Item = (Item*(*)(Item*, const std::string&, short))(0x10074689c + _dyld_get_image_vmaddr_slide(0));
	Item$setIcon = (Item*(*)(Item*, const std::string&, int))(0x100746b0c + _dyld_get_image_vmaddr_slide(0));

	Item$addCreativeItem = (void(*)(const ItemInstance&))(0x100745f10 + _dyld_get_image_vmaddr_slide(0));

	ItemInstance$ItemInstance = (ItemInstance*(*)(ItemInstance*, const Item*, int))(0x1007569a4 + _dyld_get_image_vmaddr_slide(0));
}
