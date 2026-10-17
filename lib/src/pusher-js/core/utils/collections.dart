@JS()
library core.utils.collections;

import "package:js/js.dart";

/// Merges multiple objects into the target argument.
/// For properties that are plain Objects, performs a deep-merge. For the
/// rest it just copies the value of the property.
/// To extend prototypes use it as following:
/// Pusher.Util.extend(Target.prototype, Base.prototype)
/// You can also use it to merge objects without altering them:
/// Pusher.Util.extend({}, object1, object2)
@JS()
external dynamic /*T*/ extend/*<T>*/(dynamic target,
    [dynamic sources1,
    dynamic sources2,
    dynamic sources3,
    dynamic sources4,
    dynamic sources5]);
@JS()
external String stringify();
@JS()
external num arrayIndexOf(List<dynamic> array, dynamic item);

/// Applies a function f to all properties of an object.
/// Function f gets 3 arguments passed:
/// - element from the object
/// - key of the element
/// - reference to the object
@JS()
external objectApply(dynamic object, Function f);

/// Return a list of objects own proerty keys
@JS()
external List<String> keys(dynamic object);

/// Return a list of object's own property values
@JS()
external List<dynamic> values(dynamic object);

/// Applies a function f to all elements of an array.
/// Function f gets 3 arguments passed:
/// - element from the array
/// - index of the element
/// - reference to the array
@JS()
external apply(List<dynamic> array, Function f, [dynamic context]);

/// Maps all elements of the array and returns the result.
/// Function f gets 4 arguments passed:
/// - element from the array
/// - index of the element
/// - reference to the source array
/// - reference to the destination array
@JS()
external List<dynamic> map(List<dynamic> array, Function f);

/// Maps all elements of the object and returns the result.
/// Function f gets 4 arguments passed:
/// - element from the object
/// - key of the element
/// - reference to the source object
/// - reference to the destination object
@JS()
external dynamic mapObject(dynamic object, Function f);

/// Filters elements of the array using a test function.
/// Function test gets 4 arguments passed:
/// - element from the array
/// - index of the element
/// - reference to the source array
/// - reference to the destination array
@JS()
external List<dynamic> filter(List<dynamic> array, Function test);

/// Filters properties of the object using a test function.
/// Function test gets 4 arguments passed:
/// - element from the object
/// - key of the element
/// - reference to the source object
/// - reference to the destination object
@JS()
external filterObject(Object object, Function test);

/// Flattens an object into a two-dimensional array.
@JS()
external List<dynamic> flatten(Object object);

/// Checks whether any element of the array passes the test.
/// Function test gets 3 arguments passed:
/// - element from the array
/// - index of the element
/// - reference to the source array
@JS()
external bool any(List<dynamic> array, Function test);

/// Checks whether all elements of the array pass the test.
/// Function test gets 3 arguments passed:
/// - element from the array
/// - index of the element
/// - reference to the source array
@JS()
external bool all(List<dynamic> array, Function test);
@JS()
external String encodeParamsObject(data);
@JS()
external String buildQueryString(dynamic data);

/// See https://github.com/douglascrockford/JSON-js/blob/master/cycle.js
/// Remove circular references from an object. Required for JSON.stringify in
/// React Native, which tends to blow up a lot.
@JS()
external dynamic decycleObject(dynamic object);

/// Provides a cross-browser and cross-platform way to safely stringify objects
/// into JSON. This is particularly necessary for ReactNative, where circular JSON
/// structures throw an exception.
@JS()
external String safeJSONStringify(dynamic source);
