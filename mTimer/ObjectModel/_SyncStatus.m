// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SyncStatus.m instead.

#import "_SyncStatus.h"

const struct SyncStatusAttributes SyncStatusAttributes = {
	.createdAt = @"createdAt",
	.syncFailed = @"syncFailed",
	.syncNeeded = @"syncNeeded",
};

const struct SyncStatusRelationships SyncStatusRelationships = {
	.statusForEntry = @"statusForEntry",
	.statusForReport = @"statusForReport",
	.statusForTask = @"statusForTask",
};

@implementation SyncStatusID
@end

@implementation _SyncStatus

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"SyncStatus" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"SyncStatus";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"SyncStatus" inManagedObjectContext:moc_];
}

- (SyncStatusID*)objectID {
	return (SyncStatusID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"syncFailedValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"syncFailed"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"syncNeededValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"syncNeeded"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic createdAt;

@dynamic syncFailed;

- (BOOL)syncFailedValue {
	NSNumber *result = [self syncFailed];
	return [result boolValue];
}

- (void)setSyncFailedValue:(BOOL)value_ {
	[self setSyncFailed:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveSyncFailedValue {
	NSNumber *result = [self primitiveSyncFailed];
	return [result boolValue];
}

- (void)setPrimitiveSyncFailedValue:(BOOL)value_ {
	[self setPrimitiveSyncFailed:[NSNumber numberWithBool:value_]];
}

@dynamic syncNeeded;

- (BOOL)syncNeededValue {
	NSNumber *result = [self syncNeeded];
	return [result boolValue];
}

- (void)setSyncNeededValue:(BOOL)value_ {
	[self setSyncNeeded:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveSyncNeededValue {
	NSNumber *result = [self primitiveSyncNeeded];
	return [result boolValue];
}

- (void)setPrimitiveSyncNeededValue:(BOOL)value_ {
	[self setPrimitiveSyncNeeded:[NSNumber numberWithBool:value_]];
}

@dynamic statusForEntry;

@dynamic statusForReport;

@dynamic statusForTask;

@end

