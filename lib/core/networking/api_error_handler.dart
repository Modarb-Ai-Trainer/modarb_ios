import 'package:dio/dio.dart';
import 'api_constants.dart';
import 'api_error_model.dart';




enum DataSource {
  SUCCESS,
  NO_CONTENT,
  BAD_REQUEST,
  FORBIDDEN,
  UNAUTORISED,
  NOT_FOUND,
  INTERNAL_SERVER_ERROR,
  CONNECT_TIMEOUT,
  CANCEL,
  RECIEVE_TIMEOUT,
  SEND_TIMEOUT,
  CACHE_ERROR,
  NO_INTERNET_CONNECTION,
  // API_LOGIC_ERROR,
  DEFAULT
}

class ResponseCode {
  static const int SUCCESS = 200; // success with data
  static const int NO_CONTENT = 201; // success with no data (no content)
  static const int BAD_REQUEST = 400; // failure, API rejected request
  static const int UNAUTORISED = 401; // failure, user is not authorised
  static const int FORBIDDEN = 403; //  failure, API rejected request
  static const int INTERNAL_SERVER_ERROR = 500; // failure, crash in server side
  static const int NOT_FOUND = 404; // failure, not found
  static const int API_LOGIC_ERROR = 422; // API , lOGIC ERROR

  // local status code
  static const int CONNECT_TIMEOUT = -1;
  static const int CANCEL = -2;
  static const int RECIEVE_TIMEOUT = -3;
  static const int SEND_TIMEOUT = -4;
  static const int CACHE_ERROR = -5;
  static const int NO_INTERNET_CONNECTION = -6;
  static const int DEFAULT = -7;
}

class ResponseMessage {

  static const String SUCCESS =
    ApiErrors.ok; // success with data
  static const String NO_CONTENT =
      ApiErrors.noContent; // success with no data (no content)
  static const String BAD_REQUEST =
      ApiErrors.badRequestError; // failure, API rejected request
  static const String UNAUTORISED =
      ApiErrors.unauthorizedError; // failure, user is not authorised
  static const String FORBIDDEN =
      ApiErrors.forbiddenError; //  failure, API rejected request
  static const String INTERNAL_SERVER_ERROR =
      ApiErrors.internalServerError; // failure, crash in server side
  static const String NOT_FOUND =
      ApiErrors.notFoundError; // failure, crash in server side

  // local status code
  static String CONNECT_TIMEOUT = ApiErrors.timeoutError;
  static String CANCEL = ApiErrors.defaultError;
  static String RECIEVE_TIMEOUT = ApiErrors.timeoutError;
  static String SEND_TIMEOUT = ApiErrors.timeoutError;
  static String CACHE_ERROR = ApiErrors.cacheError;
  static String NO_INTERNET_CONNECTION = ApiErrors.noInternetError;
  static String DEFAULT = ApiErrors.defaultError;
}

extension DataSourceExtension on DataSource {
  ApiErrorModel getFailure() {
    switch (this) {
      case DataSource.SUCCESS:
        return ApiErrorModel(
            status: ResponseCode.SUCCESS, message: ResponseMessage.SUCCESS);
      case DataSource.NO_CONTENT:
        return ApiErrorModel(
            status: ResponseCode.NO_CONTENT, message: ResponseMessage.NO_CONTENT);
      case DataSource.BAD_REQUEST:
        return ApiErrorModel(
            status: ResponseCode.BAD_REQUEST,
            message: ResponseMessage.BAD_REQUEST);
      case DataSource.FORBIDDEN:
        return ApiErrorModel(
            status: ResponseCode.FORBIDDEN, message: ResponseMessage.FORBIDDEN);
      case DataSource.UNAUTORISED:
        return ApiErrorModel(
            status: ResponseCode.UNAUTORISED,
            message: ResponseMessage.UNAUTORISED);
      case DataSource.NOT_FOUND:
        return ApiErrorModel(
            status: ResponseCode.NOT_FOUND, message: ResponseMessage.NOT_FOUND);
      case DataSource.INTERNAL_SERVER_ERROR:
        return ApiErrorModel(
            status: ResponseCode.INTERNAL_SERVER_ERROR,
            message: ResponseMessage.INTERNAL_SERVER_ERROR);
      case DataSource.CONNECT_TIMEOUT:
        return ApiErrorModel(
            status: ResponseCode.CONNECT_TIMEOUT,
            message: ResponseMessage.CONNECT_TIMEOUT);
      case DataSource.CANCEL:
        return ApiErrorModel(
            status: ResponseCode.CANCEL, message: ResponseMessage.CANCEL);
      case DataSource.RECIEVE_TIMEOUT:
        return ApiErrorModel(
            status: ResponseCode.RECIEVE_TIMEOUT,
            message: ResponseMessage.RECIEVE_TIMEOUT);
      case DataSource.SEND_TIMEOUT:
        return ApiErrorModel(
            status: ResponseCode.SEND_TIMEOUT,
            message: ResponseMessage.SEND_TIMEOUT);
      case DataSource.CACHE_ERROR:
        return ApiErrorModel(
            status: ResponseCode.CACHE_ERROR,
            message: ResponseMessage.CACHE_ERROR);
      case DataSource.NO_INTERNET_CONNECTION:
        return ApiErrorModel(
            status: ResponseCode.NO_INTERNET_CONNECTION,
            message: ResponseMessage.NO_INTERNET_CONNECTION);
      case DataSource.DEFAULT:
        return ApiErrorModel(
            status: ResponseCode.DEFAULT, message: ResponseMessage.DEFAULT);
    }
  }
}

class ErrorHandler implements Exception {
  late ApiErrorModel apiErrorModel;

  ErrorHandler.handle(dynamic error) {
    if (error is DioException) {
      // dio error so its an error from response of the API or from dio itself
      apiErrorModel = _handleError(error);
    } else {
      // default error
      apiErrorModel = DataSource.DEFAULT.getFailure();
    }
  }
}

ApiErrorModel _handleError(DioException error) {
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
      return DataSource.CONNECT_TIMEOUT.getFailure();
    case DioExceptionType.sendTimeout:
      return DataSource.SEND_TIMEOUT.getFailure();
    case DioExceptionType.receiveTimeout:
      return DataSource.RECIEVE_TIMEOUT.getFailure();
    case DioExceptionType.cancel:
      return DataSource.CANCEL.getFailure();
    case DioExceptionType.connectionError:
      return DataSource.DEFAULT.getFailure();
    case DioExceptionType.badCertificate:
      return DataSource.DEFAULT.getFailure();

    case DioExceptionType.badResponse:
      if (error.response != null &&
          error.response?.statusCode != null &&
          error.response?.data != null) {
        // Check for success flag or message in the response data
        if (error.response?.statusCode == 200 ||
            error.response?.data['message'] == 'Success') {
          return ApiErrorModel.fromJson(
              error.response?.data); // Assuming success model parsing
        } else {
          return ApiErrorModel.fromJson(
              error.response?.data); // Parse actual error details
        }
      } else {
        return DataSource.DEFAULT.getFailure();
      }

    case DioExceptionType.unknown:
      return DataSource.DEFAULT.getFailure();
  }
}

class ApiInternalStatus {
  static const int SUCCESS = 0;
  static const int FAILURE = 1;
}



// import 'dart:io';
//
// import 'package:dio/dio.dart';
// import 'package:freezed_annotation/freezed_annotation.dart';
// import 'package:modarb_app/core/networking/api_error_model.dart';
//
// part 'api_error_handler.freezed.dart';
//
// @freezed
// abstract class NetworkExceptions with _$NetworkExceptions {
//   const factory NetworkExceptions.requestCancelled() = RequestCancelled;
//
//   const factory NetworkExceptions.unauthorizedRequest(String reason) = UnauthorizedRequest;
//
//   const factory NetworkExceptions.badRequest() = BadRequest;
//
//   const factory NetworkExceptions.notFound(String reason) = NotFound;
//
//   const factory NetworkExceptions.methodNotAllowed() = MethodNotAllowed;
//
//   const factory NetworkExceptions.notAcceptable() = NotAcceptable;
//
//   const factory NetworkExceptions.requestTimeout() = RequestTimeout;
//
//   const factory NetworkExceptions.sendTimeout() = SendTimeout;
//
//   const factory NetworkExceptions.unProcessableEntity(String reason) = UnprocessableEntity;
//
//   const factory NetworkExceptions.conflict() = Conflict;
//
//   const factory NetworkExceptions.internalServerError() = InternalServerError;
//
//   const factory NetworkExceptions.notImplemented() = NotImplemented;
//
//   const factory NetworkExceptions.serviceUnavailable() = ServiceUnavailable;
//
//   const factory NetworkExceptions.noInternetConnection() = NoInternetConnection;
//
//   const factory NetworkExceptions.formatException() = FormatException;
//
//   const factory NetworkExceptions.unableToProcess() = UnableToProcess;
//
//   const factory NetworkExceptions.defaultError(String error) = DefaultError;
//
//   const factory NetworkExceptions.unexpectedError() = UnexpectedError;
//
//   static NetworkExceptions handleResponse(Response? response) {
//     List<ApiErrorModel> listOfErrors = List.from(response?.data).map((e) => ApiErrorModel.fromJson(e)).toList();
//     String allErrors = listOfErrors.map((e) => "${e.error} : ${e.message}  ").toString().replaceAll("(", "").replaceAll(")", "");
//     int statusCode = response?.statusCode ?? 0;
//     switch (statusCode) {
//       case 400:
//       case 401:
//       case 403:
//         return NetworkExceptions.unauthorizedRequest(allErrors);
//       case 404:
//         return NetworkExceptions.notFound(allErrors);
//       case 409:
//         return const NetworkExceptions.conflict();
//       case 408:
//         return const NetworkExceptions.requestTimeout();
//       case 422:
//         return NetworkExceptions.unProcessableEntity(allErrors);
//       case 500:
//         return const NetworkExceptions.internalServerError();
//       case 503:
//         return const NetworkExceptions.serviceUnavailable();
//       default:
//         var responseCode = statusCode;
//         return NetworkExceptions.defaultError(
//           "Received invalid status code: $responseCode",
//         );
//     }
//   }
//
//   static NetworkExceptions getDioException(dynamic error) {
//     if (error is Exception) {
//       try {
//         NetworkExceptions networkExceptions;
//         if (error is DioException) {
//           switch (error.type) {
//             case DioExceptionType.cancel:
//               networkExceptions = const NetworkExceptions.requestCancelled();
//               break;
//             case DioExceptionType.connectionTimeout:
//               networkExceptions = const NetworkExceptions.requestTimeout();
//               break;
//             case DioExceptionType.unknown:
//               networkExceptions =
//               const NetworkExceptions.noInternetConnection();
//               break;
//             case DioExceptionType.receiveTimeout:
//               networkExceptions = const NetworkExceptions.sendTimeout();
//               break;
//             case DioExceptionType.badResponse:
//               networkExceptions =
//                   NetworkExceptions.handleResponse(error.response);
//               break;
//             case DioExceptionType.sendTimeout:
//               networkExceptions = const NetworkExceptions.sendTimeout();
//               break;
//             case DioExceptionType.badCertificate:
//               networkExceptions =
//               const NetworkExceptions.unauthorizedRequest("Bad Certificate");
//               break;
//             case DioExceptionType.connectionError:
//               networkExceptions =
//               const NetworkExceptions.unauthorizedRequest("Connection Error");
//               break;
//           }
//         } else if (error is SocketException) {
//           networkExceptions = const NetworkExceptions.noInternetConnection();
//         } else {
//           networkExceptions = const NetworkExceptions.unexpectedError();
//         }
//         return networkExceptions;
//       } on FormatException catch (e) {
//         return const NetworkExceptions.formatException();
//       } catch (_) {
//         return const NetworkExceptions.unexpectedError();
//       }
//     } else {
//       if (error.toString().contains("is not a subtype of")) {
//         return const NetworkExceptions.unableToProcess();
//       } else {
//         return const NetworkExceptions.unexpectedError();
//       }
//     }
//   }
//
//   static String getErrorMessage(NetworkExceptions networkExceptions) {
//     var errorMessage = "";
//     networkExceptions.when(notImplemented: () {
//       errorMessage = "Not Implemented";
//     }, requestCancelled: () {
//       errorMessage = "Request Cancelled";
//     }, internalServerError: () {
//       errorMessage = "Internal Server Error";
//     }, notFound: (String reason) {
//       errorMessage = reason;
//     }, serviceUnavailable: () {
//       errorMessage = "Service unavailable";
//     }, methodNotAllowed: () {
//       errorMessage = "Method Allowed";
//     }, badRequest: () {
//       errorMessage = "Bad request";
//     }, unauthorizedRequest: (String error) {
//       errorMessage = error;
//     }, unprocessableEntity: (String error) {
//       errorMessage = error;
//     }, unexpectedError: () {
//       errorMessage = "Unexpected error occurred";
//     }, requestTimeout: () {
//       errorMessage = "Connection request timeout";
//     }, noInternetConnection: () {
//       errorMessage = "No internet connection";
//     }, conflict: () {
//       errorMessage = "Error due to a conflict";
//     }, sendTimeout: () {
//       errorMessage = "Send timeout in connection with API server";
//     }, unableToProcess: () {
//       errorMessage = "Unable to process the data";
//     }, defaultError: (String error) {
//       errorMessage = error;
//     }, formatException: () {
//       errorMessage = "Unexpected error occurred";
//     }, notAcceptable: () {
//       errorMessage = "Not acceptable";
//     });
//     return errorMessage;
//   }
// }
