// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Month.h instead.

@import CoreData;

NS_ASSUME_NONNULL_BEGIN

@class Day;
@class Year;

@interface MonthID : NSManagedObjectID {}
@end

@interface _Month : NSManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) MonthID*objectID;

@property (nonatomic, strong, nullable) NSNumber* value;

@property (atomic) int32_t valueValue;
- (int32_t)valueValue;
- (void)setValueValue:(int32_t)value_;

@property (nonatomic, strong, nullable) NSSet<Day*> *days;
- (nullable NSMutableSet<Day*>*)daysSet;

@property (nonatomic, strong, nullable) Year *year;

@end

@interface _Month (DaysCoreDataGeneratedAccessors)
- (void)addDays:(NSSet<Day*>*)value_;
- (void)removeDays:(NSSet<Day*>*)value_;
- (void)addDaysObject:(Day*)value_;
- (void)removeDaysObject:(Day*)value_;

@end

@interface _Month (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitiveValue;
- (void)setPrimitiveValue:(NSNumber*)value;

- (int32_t)primitiveValueValue;
- (void)setPrimitiveValueValue:(int32_t)value_;

- (NSMutableSet<Day*>*)primitiveDays;
- (void)setPrimitiveDays:(NSMutableSet<Day*>*)value;

- (Year*)primitiveYear;
- (void)setPrimitiveYear:(Year*)value;

@end

@interface MonthAttributes: NSObject 
+ (NSString *)value;
@end

@interface MonthRelationships: NSObject
+ (NSString *)days;
+ (NSString *)year;
@end

NS_ASSUME_NONNULL_END
