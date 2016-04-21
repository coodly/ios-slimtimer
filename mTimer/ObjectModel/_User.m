// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to User.m instead.

#import "_User.h"

@implementation UserID
@end

@implementation _User

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"User";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"User" inManagedObjectContext:moc_];
}

- (UserID*)objectID {
	return (UserID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"userIdValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"userId"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic userId;

- (int32_t)userIdValue {
	NSNumber *result = [self userId];
	return [result intValue];
}

- (void)setUserIdValue:(int32_t)value_ {
	[self setUserId:@(value_)];
}

- (int32_t)primitiveUserIdValue {
	NSNumber *result = [self primitiveUserId];
	return [result intValue];
}

- (void)setPrimitiveUserIdValue:(int32_t)value_ {
	[self setPrimitiveUserId:@(value_)];
}

@dynamic tags;

- (NSMutableSet<Tag*>*)tagsSet {
	[self willAccessValueForKey:@"tags"];

	NSMutableSet<Tag*> *result = (NSMutableSet<Tag*>*)[self mutableSetValueForKey:@"tags"];

	[self didAccessValueForKey:@"tags"];
	return result;
}

@dynamic tasks;

- (NSMutableSet<Task*>*)tasksSet {
	[self willAccessValueForKey:@"tasks"];

	NSMutableSet<Task*> *result = (NSMutableSet<Task*>*)[self mutableSetValueForKey:@"tasks"];

	[self didAccessValueForKey:@"tasks"];
	return result;
}

@dynamic years;

- (NSMutableSet<Year*>*)yearsSet {
	[self willAccessValueForKey:@"years"];

	NSMutableSet<Year*> *result = (NSMutableSet<Year*>*)[self mutableSetValueForKey:@"years"];

	[self didAccessValueForKey:@"years"];
	return result;
}

@end

@implementation UserAttributes 
+ (NSString *)userId {
	return @"userId";
}
@end

@implementation UserRelationships 
+ (NSString *)tags {
	return @"tags";
}
+ (NSString *)tasks {
	return @"tasks";
}
+ (NSString *)years {
	return @"years";
}
@end

