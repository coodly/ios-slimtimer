// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Task.m instead.

#import "_Task.h"

const struct TaskAttributes TaskAttributes = {
	.complete = @"complete",
	.hidden = @"hidden",
	.name = @"name",
	.taskId = @"taskId",
	.temporary = @"temporary",
	.touchedAt = @"touchedAt",
};

const struct TaskRelationships TaskRelationships = {
	.defaultTags = @"defaultTags",
	.syncStatus = @"syncStatus",
	.timeEntry = @"timeEntry",
	.user = @"user",
};

@implementation TaskID
@end

@implementation _Task

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
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
	[self setComplete:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveCompleteValue {
	NSNumber *result = [self primitiveComplete];
	return [result boolValue];
}

- (void)setPrimitiveCompleteValue:(BOOL)value_ {
	[self setPrimitiveComplete:[NSNumber numberWithBool:value_]];
}

@dynamic hidden;

- (BOOL)hiddenValue {
	NSNumber *result = [self hidden];
	return [result boolValue];
}

- (void)setHiddenValue:(BOOL)value_ {
	[self setHidden:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveHiddenValue {
	NSNumber *result = [self primitiveHidden];
	return [result boolValue];
}

- (void)setPrimitiveHiddenValue:(BOOL)value_ {
	[self setPrimitiveHidden:[NSNumber numberWithBool:value_]];
}

@dynamic name;

@dynamic taskId;

- (int32_t)taskIdValue {
	NSNumber *result = [self taskId];
	return [result intValue];
}

- (void)setTaskIdValue:(int32_t)value_ {
	[self setTaskId:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveTaskIdValue {
	NSNumber *result = [self primitiveTaskId];
	return [result intValue];
}

- (void)setPrimitiveTaskIdValue:(int32_t)value_ {
	[self setPrimitiveTaskId:[NSNumber numberWithInt:value_]];
}

@dynamic temporary;

- (BOOL)temporaryValue {
	NSNumber *result = [self temporary];
	return [result boolValue];
}

- (void)setTemporaryValue:(BOOL)value_ {
	[self setTemporary:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveTemporaryValue {
	NSNumber *result = [self primitiveTemporary];
	return [result boolValue];
}

- (void)setPrimitiveTemporaryValue:(BOOL)value_ {
	[self setPrimitiveTemporary:[NSNumber numberWithBool:value_]];
}

@dynamic touchedAt;

@dynamic defaultTags;

- (NSMutableSet*)defaultTagsSet {
	[self willAccessValueForKey:@"defaultTags"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"defaultTags"];

	[self didAccessValueForKey:@"defaultTags"];
	return result;
}

@dynamic syncStatus;

@dynamic timeEntry;

- (NSMutableSet*)timeEntrySet {
	[self willAccessValueForKey:@"timeEntry"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"timeEntry"];

	[self didAccessValueForKey:@"timeEntry"];
	return result;
}

@dynamic user;

@end

