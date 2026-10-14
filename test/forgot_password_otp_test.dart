import 'package:dartz/dartz.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sanad_app/core/network/error/failures.dart';
import 'package:sanad_app/features/shared/forgot_password/data/params/forgot_password_param.dart';
import 'package:sanad_app/features/shared/forgot_password/data/params/reset_password_confirm_param.dart';
import 'package:sanad_app/features/shared/forgot_password/data/repos/forgot_password_repo.dart';
import 'package:sanad_app/features/shared/forgot_password/presentation/controllers/forgot_password_cubit.dart';

class _FakeRepo implements ForgotPasswordRepo {
  @override
  Future<Either<Failure, String>> requestPasswordReset(
    ForgotPasswordParam param,
  ) async => right('ok');

  @override
  Future<Either<Failure, String>> confirmPasswordReset(
    ResetPasswordConfirmParam param,
  ) async => right('ok');
}

void main() {
  late ForgotPasswordCubit cubit;

  setUp(() => cubit = ForgotPasswordCubit(_FakeRepo()));
  tearDown(() async => await cubit.close());

  void fill(String otp) {
    cubit.otpController.text = otp;
    cubit.newPasswordController.text = 'NewPass12';
    cubit.confirmPasswordController.text = 'NewPass12';
  }

  test('OTP must be exactly 8 characters', () {
    fill('1234567');
    expect(cubit.isConfirmFormValid, false);
    fill('12345678');
    expect(cubit.isConfirmFormValid, true);
    fill('123456789');
    expect(cubit.isConfirmFormValid, false);
  });

  test('resend cooldown counts down from 60 to 0', () {
    fakeAsync((async) {
      cubit.startResendCooldown();
      expect(cubit.resendSecondsLeft, 60);
      expect(cubit.canResend, false);
      async.elapse(const Duration(seconds: 59));
      expect(cubit.resendSecondsLeft, 1);
      async.elapse(const Duration(seconds: 1));
      expect(cubit.resendSecondsLeft, 0);
      expect(cubit.canResend, true);
    });
  });
}
