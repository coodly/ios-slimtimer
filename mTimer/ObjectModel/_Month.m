// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Month.m instead.

#import "_Month.h"

const struct MonthAttributes MonthAttributes = {
	.value = @"value",
};

const struct MonthRelationships MonthRelationships = {
	.days = @"days",
	.year = @"year",
};

@implementation MonthID
@end

@implementation _Month

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Month" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Month";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Month" inManagedObjectContext:moc_];
}

- (MonthID*)objectID {
	return (MonthID*)[super objectID];
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

@dynamic days;

- (NSMutableSet*)daysSet {
	[self willAccessValueForKey:@"days"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"days"];

	[self didAccessValueForKey:@"days"];
	return result;
}

@dynamic year;

@end

