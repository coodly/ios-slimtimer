// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TimeReport.m instead.

#import "_TimeReport.h"

const struct TimeReportAttributes TimeReportAttributes = {
	.seconds = @"seconds",
};

const struct TimeReportRelationships TimeReportRelationships = {
	.syncStatus = @"syncStatus",
};

@implementation TimeReportID
@end

@implementation _TimeReport

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"TimeReport" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"TimeReport";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"TimeReport" inManagedObjectContext:moc_];
}

- (TimeReportID*)objectID {
	return (TimeReportID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"secondsValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"seconds"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic seconds;

- (int32_t)secondsValue {
	NSNumber *result = [self seconds];
	return [result intValue];
}

- (void)setSecondsValue:(int32_t)value_ {
	[self setSeconds:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveSecondsValue {
	NSNumber *result = [self primitiveSeconds];
	return [result intValue];
}

- (void)setPrimitiveSecondsValue:(int32_t)value_ {
	[self setPrimitiveSeconds:[NSNumber numberWithInt:value_]];
}

@dynamic syncStatus;

@end

