// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Month.m instead.

#import "_Month.h"

@implementation MonthID
@end

@implementation _Month

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
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
	[self setValue:@(value_)];
}

- (int32_t)primitiveValueValue {
	NSNumber *result = [self primitiveValue];
	return [result intValue];
}

- (void)setPrimitiveValueValue:(int32_t)value_ {
	[self setPrimitiveValue:@(value_)];
}

@dynamic days;

- (NSMutableSet<Day*>*)daysSet {
	[self willAccessValueForKey:@"days"];

	NSMutableSet<Day*> *result = (NSMutableSet<Day*>*)[self mutableSetValueForKey:@"days"];

	[self didAccessValueForKey:@"days"];
	return result;
}

@dynamic year;

@end

@implementation MonthAttributes 
+ (NSString *)value {
	return @"value";
}
@end

@implementation MonthRelationships 
+ (NSString *)days {
	return @"days";
}
+ (NSString *)year {
	return @"year";
}
@end

