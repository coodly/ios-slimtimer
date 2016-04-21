// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TimeEntry.m instead.

#import "_TimeEntry.h"

@implementation TimeEntryID
@end

@implementation _TimeEntry

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"TimeEntry" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"TimeEntry";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"TimeEntry" inManagedObjectContext:moc_];
}

- (TimeEntryID*)objectID {
	return (TimeEntryID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"markedForDeletionValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"markedForDeletion"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"remoteIdValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"remoteId"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic comment;

@dynamic endTime;

@dynamic markedForDeletion;

- (BOOL)markedForDeletionValue {
	NSNumber *result = [self markedForDeletion];
	return [result boolValue];
}

- (void)setMarkedForDeletionValue:(BOOL)value_ {
	[self setMarkedForDeletion:@(value_)];
}

- (BOOL)primitiveMarkedForDeletionValue {
	NSNumber *result = [self primitiveMarkedForDeletion];
	return [result boolValue];
}

- (void)setPrimitiveMarkedForDeletionValue:(BOOL)value_ {
	[self setPrimitiveMarkedForDeletion:@(value_)];
}

@dynamic remoteId;

- (int32_t)remoteIdValue {
	NSNumber *result = [self remoteId];
	return [result intValue];
}

- (void)setRemoteIdValue:(int32_t)value_ {
	[self setRemoteId:@(value_)];
}

- (int32_t)primitiveRemoteIdValue {
	NSNumber *result = [self primitiveRemoteId];
	return [result intValue];
}

- (void)setPrimitiveRemoteIdValue:(int32_t)value_ {
	[self setPrimitiveRemoteId:@(value_)];
}

@dynamic startTime;

@dynamic touchedAt;

@dynamic syncStatus;

@dynamic tags;

- (NSMutableSet<Tag*>*)tagsSet {
	[self willAccessValueForKey:@"tags"];

	NSMutableSet<Tag*> *result = (NSMutableSet<Tag*>*)[self mutableSetValueForKey:@"tags"];

	[self didAccessValueForKey:@"tags"];
	return result;
}

@dynamic task;

@end

@implementation TimeEntryAttributes 
+ (NSString *)comment {
	return @"comment";
}
+ (NSString *)endTime {
	return @"endTime";
}
+ (NSString *)markedForDeletion {
	return @"markedForDeletion";
}
+ (NSString *)remoteId {
	return @"remoteId";
}
+ (NSString *)startTime {
	return @"startTime";
}
+ (NSString *)touchedAt {
	return @"touchedAt";
}
@end

@implementation TimeEntryRelationships 
+ (NSString *)syncStatus {
	return @"syncStatus";
}
+ (NSString *)tags {
	return @"tags";
}
+ (NSString *)task {
	return @"task";
}
@end

