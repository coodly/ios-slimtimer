// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Month.h instead.

#import <CoreData/CoreData.h>

extern const struct MonthAttributes {
	__unsafe_unretained NSString *value;
} MonthAttributes;

extern const struct MonthRelationships {
	__unsafe_unretained NSString *days;
	__unsafe_unretained NSString *year;
} MonthRelationships;

@class Day;
@class Year;

@interface MonthID : NSManagedObjectID {}
@end

@interface _Month : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) MonthID* objectID;

@property (nonatomic, strong) NSNumber* value;

@property (atomic) int32_t valueValue;
- (int32_t)valueValue;
- (void)setValueValue:(int32_t)value_;

//- (BOOL)validateValue:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *days;

- (NSMutableSet*)daysSet;

@property (nonatomic, strong) Year *year;

//- (BOOL)validateYear:(id*)value_ error:(NSError**)error_;

@end

@interface _Month (DaysCoreDataGeneratedAccessors)
- (void)addDays:(NSSet*)value_;
- (void)removeDays:(NSSet*)value_;
- (void)addDaysObject:(Day*)value_;
- (void)removeDaysObject:(Day*)value_;

@end

@interface _Month (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitiveValue;
- (void)setPrimitiveValue:(NSNumber*)value;

- (int32_t)primitiveValueValue;
- (void)setPrimitiveValueValue:(int32_t)value_;

- (NSMutableSet*)primitiveDays;
- (void)setPrimitiveDays:(NSMutableSet*)value;

- (Year*)primitiveYear;
- (void)setPrimitiveYear:(Year*)value;

@end
