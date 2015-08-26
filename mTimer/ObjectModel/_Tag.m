// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Tag.m instead.

#import "_Tag.h"

const struct TagAttributes TagAttributes = {
	.value = @"value",
};

const struct TagRelationships TagRelationships = {
	.defaultForTasks = @"defaultForTasks",
	.usedForEntries = @"usedForEntries",
	.user = @"user",
};

@implementation TagID
@end

@implementation _Tag

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Tag" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Tag";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Tag" inManagedObjectContext:moc_];
}

- (TagID*)objectID {
	return (TagID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic value;

@dynamic defaultForTasks;

- (NSMutableSet*)defaultForTasksSet {
	[self willAccessValueForKey:@"defaultForTasks"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"defaultForTasks"];

	[self didAccessValueForKey:@"defaultForTasks"];
	return result;
}

@dynamic usedForEntries;

- (NSMutableSet*)usedForEntriesSet {
	[self willAccessValueForKey:@"usedForEntries"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"usedForEntries"];

	[self didAccessValueForKey:@"usedForEntries"];
	return result;
}

@dynamic user;

@end

