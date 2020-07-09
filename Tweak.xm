#include "substrate.h"
#include <string>
#include <cstdio>
#include <mach-o/dyld.h>


struct TextureUVCoordinateSet;

struct Item {
	uintptr_t** vtable; // 0
	uint8_t maxStackSize; // 8
	int idk; // 12
	std::string atlas; // 16
	int frameCount; // 40
	bool animated; // 44
	short itemId; // 46
	std::string name; // 48
	std::string idk3; // 72
	bool isMirrored; // 96
	short maxDamage; // 98
	bool isGlint; // 100
	bool renderAsTool; // 101
	bool stackedByData; // 102
	uint8_t properties; // 103
	int maxUseDuration; // 104
	bool explodeable; // 108
	bool shouldDespawn; // 109
	bool idk4; // 110
	uint8_t useAnimation; // 111
	int creativeCategory; // 112
	float idk5; // 116
	float idk6; // 120
	char buffer[12]; // 124
	TextureUVCoordinateSet* icon; // 136
	char filler[100];
};

struct ItemInstance {
	uint8_t count;
	uint16_t aux;
	uintptr_t* tag;
	Item* item;
	uintptr_t* block;
	int idk[3];
};

static Item** Item$mItems;
static Item*(*Item$Item)(Item*, const std::string&, short);
static Item*(*Item$setIcon)(Item*, const std::string&, int);

static void(*Item$addCreativeItem)(const ItemInstance&);

static ItemInstance*(*ItemInstance$ItemInstance)(ItemInstance*, int, int, int);

int tim = 453;
Item* myItemPtr;


static void (*_Item$initCreativeItems)();
static void Item$initCreativeItems() {
	_Item$initCreativeItems();

	ItemInstance inst;
	ItemInstance$ItemInstance(&inst, tim, 1, 0);
	Item$addCreativeItem(inst);	
}

static void (*_Item$registerItems)();
static void Item$registerItems() {
	_Item$registerItems();

	myItemPtr = new Item();
	Item$Item(myItemPtr, "testitem", tim - 0x100);
	Item$mItems[tim] = myItemPtr;
	myItemPtr->creativeCategory = 3;
}

static void (*_Item$initClientData)();
static void Item$initClientData() {
	_Item$initClientData();

	Item$setIcon(myItemPtr, "test", 0);
}

static std::string (*_Common$getGameDevVersionString)(uintptr_t*);
static std::string Common$getGameDevVersionString(uintptr_t* common) {
	return "Hacked!";
}

%ctor {
	MSHookFunction((void*)(0x100734d00 + _dyld_get_image_vmaddr_slide(0)), (void*)&Item$initCreativeItems, (void**)&_Item$initCreativeItems);
	MSHookFunction((void*)(0x100733348 + _dyld_get_image_vmaddr_slide(0)), (void*)&Item$registerItems, (void**)&_Item$registerItems);
	MSHookFunction((void*)(0x10074242c + _dyld_get_image_vmaddr_slide(0)), (void*)&Item$initClientData, (void**)&_Item$initClientData);
	MSHookFunction((void*)(0x10006bc94 + _dyld_get_image_vmaddr_slide(0)), (void*)&Common$getGameDevVersionString, (void**)&_Common$getGameDevVersionString);

	Item$mItems = (Item**)(0x1012ae238 + _dyld_get_image_vmaddr_slide(0));
	Item$Item = (Item*(*)(Item*, const std::string&, short))(0x10074689c + _dyld_get_image_vmaddr_slide(0));
	Item$setIcon = (Item*(*)(Item*, const std::string&, int))(0x100746b0c + _dyld_get_image_vmaddr_slide(0));

	Item$addCreativeItem = (void(*)(const ItemInstance&))(0x100745f10 + _dyld_get_image_vmaddr_slide(0));

	ItemInstance$ItemInstance = (ItemInstance*(*)(ItemInstance*, int, int, int))(0x100756c70 + _dyld_get_image_vmaddr_slide(0));
}
