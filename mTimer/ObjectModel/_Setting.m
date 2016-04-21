// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Setting.m instead.

#import "_Setting.h"

@implementation SettingID
@end

@implementation _Setting

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Setting" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Setting";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Setting" inManagedObjectContext:moc_];
}

- (SettingID*)objectID {
	return (SettingID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"keyValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"key"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic key;

- (int32_t)keyValue {
	NSNumber *result = [self key];
	return [result intValue];
}

- (void)setKeyValue:(int32_t)value_ {
	[self setKey:@(value_)];
}

- (int32_t)primitiveKeyValue {
	NSNumber *result = [self primitiveKey];
	return [result intValue];
}

- (void)setPrimitiveKeyValue:(int32_t)value_ {
	[self setPrimitiveKey:@(value_)];
}

@dynamic value;

@end

@implementation SettingAttributes 
+ (NSString *)key {
	return @"key";
}
+ (NSString *)value {
	return @"value";
}
@end

