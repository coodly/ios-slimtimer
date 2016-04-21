// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Year.m instead.

#import "_Year.h"

@implementation YearID
@end

@implementation _Year

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Year" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Year";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Year" inManagedObjectContext:moc_];
}

- (YearID*)objectID {
	return (YearID*)[super objectID];
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

@dynamic months;

- (NSMutableSet<Month*>*)monthsSet {
	[self willAccessValueForKey:@"months"];

	NSMutableSet<Month*> *result = (NSMutableSet<Month*>*)[self mutableSetValueForKey:@"months"];

	[self didAccessValueForKey:@"months"];
	return result;
}

@dynamic user;

@end

@implementation YearAttributes 
+ (NSString *)value {
	return @"value";
}
@end

@implementation YearRelationships 
+ (NSString *)months {
	return @"months";
}
+ (NSString *)user {
	return @"user";
}
@end

