// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Task.m instead.

#import "_Task.h"

@implementation TaskID
@end

@implementation _Task

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Task" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Task";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Task" inManagedObjectContext:moc_];
}

- (TaskID*)objectID {
	return (TaskID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"completeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"complete"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"hiddenValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"hidden"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"taskIdValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"taskId"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"temporaryValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"temporary"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic complete;

- (BOOL)completeValue {
	NSNumber *result = [self complete];
	return [result boolValue];
}

- (void)setCompleteValue:(BOOL)value_ {
	[self setComplete:@(value_)];
}

- (BOOL)primitiveCompleteValue {
	NSNumber *result = [self primitiveComplete];
	return [result boolValue];
}

- (void)setPrimitiveCompleteValue:(BOOL)value_ {
	[self setPrimitiveComplete:@(value_)];
}

@dynamic hidden;

- (BOOL)hiddenValue {
	NSNumber *result = [self hidden];
	return [result boolValue];
}

- (void)setHiddenValue:(BOOL)value_ {
	[self setHidden:@(value_)];
}

- (BOOL)primitiveHiddenValue {
	NSNumber *result = [self primitiveHidden];
	return [result boolValue];
}

- (void)setPrimitiveHiddenValue:(BOOL)value_ {
	[self setPrimitiveHidden:@(value_)];
}

@dynamic name;

@dynamic taskId;

- (int32_t)taskIdValue {
	NSNumber *result = [self taskId];
	return [result intValue];
}

- (void)setTaskIdValue:(int32_t)value_ {
	[self setTaskId:@(value_)];
}

- (int32_t)primitiveTaskIdValue {
	NSNumber *result = [self primitiveTaskId];
	return [result intValue];
}

- (void)setPrimitiveTaskIdValue:(int32_t)value_ {
	[self setPrimitiveTaskId:@(value_)];
}

@dynamic temporary;

- (BOOL)temporaryValue {
	NSNumber *result = [self temporary];
	return [result boolValue];
}

- (void)setTemporaryValue:(BOOL)value_ {
	[self setTemporary:@(value_)];
}

- (BOOL)primitiveTemporaryValue {
	NSNumber *result = [self primitiveTemporary];
	return [result boolValue];
}

- (void)setPrimitiveTemporaryValue:(BOOL)value_ {
	[self setPrimitiveTemporary:@(value_)];
}

@dynamic touchedAt;

@dynamic defaultTags;

- (NSMutableSet<Tag*>*)defaultTagsSet {
	[self willAccessValueForKey:@"defaultTags"];

	NSMutableSet<Tag*> *result = (NSMutableSet<Tag*>*)[self mutableSetValueForKey:@"defaultTags"];

	[self didAccessValueForKey:@"defaultTags"];
	return result;
}

@dynamic syncStatus;

@dynamic timeEntry;

- (NSMutableSet<TimeEntry*>*)timeEntrySet {
	[self willAccessValueForKey:@"timeEntry"];

	NSMutableSet<TimeEntry*> *result = (NSMutableSet<TimeEntry*>*)[self mutableSetValueForKey:@"timeEntry"];

	[self didAccessValueForKey:@"timeEntry"];
	return result;
}

@dynamic user;

@end

@implementation TaskAttributes 
+ (NSString *)complete {
	return @"complete";
}
+ (NSString *)hidden {
	return @"hidden";
}
+ (NSString *)name {
	return @"name";
}
+ (NSString *)taskId {
	return @"taskId";
}
+ (NSString *)temporary {
	return @"temporary";
}
+ (NSString *)touchedAt {
	return @"touchedAt";
}
@end

@implementation TaskRelationships 
+ (NSString *)defaultTags {
	return @"defaultTags";
}
+ (NSString *)syncStatus {
	return @"syncStatus";
}
+ (NSString *)timeEntry {
	return @"timeEntry";
}
+ (NSString *)user {
	return @"user";
}
@end

