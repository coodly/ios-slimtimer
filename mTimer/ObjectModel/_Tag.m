// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Tag.m instead.

#import "_Tag.h"

@implementation TagID
@end

@implementation _Tag

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
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

- (NSMutableSet<Task*>*)defaultForTasksSet {
	[self willAccessValueForKey:@"defaultForTasks"];

	NSMutableSet<Task*> *result = (NSMutableSet<Task*>*)[self mutableSetValueForKey:@"defaultForTasks"];

	[self didAccessValueForKey:@"defaultForTasks"];
	return result;
}

@dynamic usedForEntries;

- (NSMutableSet<TimeEntry*>*)usedForEntriesSet {
	[self willAccessValueForKey:@"usedForEntries"];

	NSMutableSet<TimeEntry*> *result = (NSMutableSet<TimeEntry*>*)[self mutableSetValueForKey:@"usedForEntries"];

	[self didAccessValueForKey:@"usedForEntries"];
	return result;
}

@dynamic user;

@end

@implementation TagAttributes 
+ (NSString *)value {
	return @"value";
}
@end

@implementation TagRelationships 
+ (NSString *)defaultForTasks {
	return @"defaultForTasks";
}
+ (NSString *)usedForEntries {
	return @"usedForEntries";
}
+ (NSString *)user {
	return @"user";
}
@end

