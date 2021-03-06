// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Day.m instead.

#import "_Day.h"

const struct DayAttributes DayAttributes = {
	.value = @"value",
};

const struct DayRelationships DayRelationships = {
	.month = @"month",
};

@implementation DayID
@end

@implementation _Day

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Day" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Day";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Day" inManagedObjectContext:moc_];
}

- (DayID*)objectID {
	return (DayID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"valueValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"value"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic value;

- (int32_t)valueValue {
	NSNumber *result = [self value];
	return [result intValue];
}

- (void)setValueValue:(int32_t)value_ {
	[self setValue:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveValueValue {
	NSNumber *result = [self primitiveValue];
	return [result intValue];
}

- (void)setPrimitiveValueValue:(int32_t)value_ {
	[self setPrimitiveValue:[NSNumber numberWithInt:value_]];
}

@dynamic month;

@end

