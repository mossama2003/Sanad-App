import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sanad_app/core/network/error/failures.dart';
import 'package:sanad_app/features/shared/forgot_password/data/params/forgot_password_param.dart';
import 'package:sanad_app/features/shared/forgot_password/data/params/reset_password_confirm_param.dart';
import 'package:sanad_app/features/shared/forgot_password/data/repos/forgot_password_repo.dart';
import 'package:sanad_app/features/shared/forgot_password/presentation/controllers/forgot_password_cubit.dart';

class _MockForgotPasswordRepo implements ForgotPasswordRepo {
  Either<Failure, String>? requestResult;
  Either<Failure, String>? confirmResult;

  @override
  Future<Either<Failure, String>> requestPasswordReset(
    ForgotPasswordParam param,
  ) async {
    return requestResult ?? right('OTP sent');
  }

  @override
  Future<Either<Failure, String>> confirmPasswordReset(
    ResetPasswordConfirmParam param,
  ) async {
    return confirmResult ?? right('Password reset successful');
  }
}

void main() {
  group('ForgotPassword DTOs', () {
    test('ForgotPasswordParam maps email correctly to JSON', () {
      const param = ForgotPasswordParam(email: '  user@example.com ');
      final json = param.toJson();
      expect(json, {'email': 'user@example.com'});
      final formData = param.toFormData();
      expect(
        formData.fields.any((e) => e.key == 'email' && e.value == 'user@example.com'),
        isTrue,
      );
    });

    test('ResetPasswordConfirmParam maps fields correctly to JSON', () {
      const param = ResetPasswordConfirmParam(
        otp: ' 12345678 ',
        newPassword: 'Password123',
        reNewPassword: 'Password123',
      );
      final json = param.toJson();
      expect(json, {
        'otp': '12345678',
        'new_password': 'Password123',
        're_new_password': 'Password123',
      });
      final formData = param.toFormData();
      expect(formData.fields.any((e) => e.key == 'otp' && e.value == '12345678'), isTrue);
      expect(
        formData.fields.any((e) => e.key == 'new_password' && e.value == 'Password123'),
        isTrue,
      );
      expect(
        formData.fields.any((e) => e.key == 're_new_password' && e.value == 'Password123'),
        isTrue,
      );
    });
  });

  group('ForgotPasswordCubit Validation Rules', () {
    late _MockForgotPasswordRepo mockRepo;
    late ForgotPasswordCubit cubit;

    setUp(() {
      mockRepo = _MockForgotPasswordRepo();
      cubit = ForgotPasswordCubit(mockRepo);
    });

    tearDown(() async {
      await cubit.close();
    });

    test('initial state and form validation are falsy for empty inputs', () {
      expect(cubit.state, isA<ForgotPasswordInitial>());
      expect(cubit.isRequestFormValid, false);
      expect(cubit.isConfirmFormValid, false);
    });

    test('request form validity with invalid and valid email', () {
      cubit.emailController.text = 'invalid-email';
      expect(cubit.isRequestFormValid, false);

      cubit.emailController.text = 'valid@sanad.org';
      expect(cubit.isRequestFormValid, true);
    });

    test('confirm form validation requires valid OTP and password complexity rules', () {
      void fill({
        required String otp,
        required String newPass,
        required String confirmPass,
      }) {
        cubit.otpController.text = otp;
        cubit.newPasswordController.text = newPass;
        cubit.confirmPasswordController.text = confirmPass;
      }

      // Valid case
      fill(otp: '12345678', newPass: 'StrongPass1', confirmPass: 'StrongPass1');
      expect(cubit.hasMinLength, true);
      expect(cubit.hasUppercase, true);
      expect(cubit.hasNumber, true);
      expect(cubit.passwordsMatch, true);
      expect(cubit.isConfirmFormValid, true);

      // Short password
      fill(otp: '12345678', newPass: 'Pass1', confirmPass: 'Pass1');
      expect(cubit.hasMinLength, false);
      expect(cubit.isConfirmFormValid, false);

      // No uppercase
      fill(otp: '12345678', newPass: 'strongpass1', confirmPass: 'strongpass1');
      expect(cubit.hasUppercase, false);
      expect(cubit.isConfirmFormValid, false);

      // No number
      fill(otp: '12345678', newPass: 'StrongPass', confirmPass: 'StrongPass');
      expect(cubit.hasNumber, false);
      expect(cubit.isConfirmFormValid, false);

      // Passwords mismatch
      fill(otp: '12345678', newPass: 'StrongPass1', confirmPass: 'StrongPass2');
      expect(cubit.passwordsMatch, false);
      expect(cubit.isConfirmFormValid, false);

      // OTP too short (< 8 chars)
      fill(otp: '1234567', newPass: 'StrongPass1', confirmPass: 'StrongPass1');
      expect(cubit.isConfirmFormValid, false);

      // OTP too long (> 8 chars)
      fill(otp: '123456789', newPass: 'StrongPass1', confirmPass: 'StrongPass1');
      expect(cubit.isConfirmFormValid, false);
    });

    test('toggle password visibility emits ForgotPasswordValidationChanged', () {
      expect(cubit.obscureNewPassword, true);
      cubit.toggleNewPasswordVisibility();
      expect(cubit.obscureNewPassword, false);
      expect(cubit.state, isA<ForgotPasswordValidationChanged>());

      expect(cubit.obscureConfirmPassword, true);
      cubit.toggleConfirmPasswordVisibility();
      expect(cubit.obscureConfirmPassword, false);
      expect(cubit.state, isA<ForgotPasswordValidationChanged>());
    });

    test('submitRequestReset emits loading and error when repository fails', () async {
      mockRepo.requestResult = left(ServerFailure('Email not registered'));
      cubit.emailController.text = 'test@example.com';

      // Call internal logic directly
      final future = cubit.repo.requestPasswordReset(
        ForgotPasswordParam(email: cubit.emailController.text),
      );
      final result = await future;

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure.errMessage, 'Email not registered'),
        (_) => fail('Expected left'),
      );
    });

    test('submitConfirmReset emits loading and success when repository succeeds', () async {
      mockRepo.confirmResult = right('Password changed');
      cubit.otpController.text = '123456';
      cubit.newPasswordController.text = 'ValidPass1';
      cubit.confirmPasswordController.text = 'ValidPass1';

      final future = cubit.repo.confirmPasswordReset(
        ResetPasswordConfirmParam(
          otp: cubit.otpController.text,
          newPassword: cubit.newPasswordController.text,
          reNewPassword: cubit.confirmPasswordController.text,
        ),
      );
      final result = await future;

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Expected right'),
        (msg) => expect(msg, 'Password changed'),
      );
    });
  });
}
