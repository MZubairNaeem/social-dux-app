import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:scp/core/auth/onboarding/view_models/domain_provider.dart';
import 'package:scp/core/auth/onboarding/view_models/onboarding_user_profile_view_model.dart';
import 'package:scp/core/consultant/consultant_dashboard/view/consultant_dashboard.dart';
import 'package:scp/model/domain_model.dart';
import 'package:scp/model/user_profile_model.dart';
import 'package:scp/theme/colors/colors.dart';
import 'package:scp/widgets/progressIndicator/progress_indicator.dart';
import 'package:scp/widgets/snackbar_message/snackbar_message.dart';

class OnboardingUserProfilePage extends ConsumerStatefulWidget {
  const OnboardingUserProfilePage({super.key});

  @override
  OnboardingUserProfilePageState createState() =>
      OnboardingUserProfilePageState();
}

class OnboardingUserProfilePageState
    extends ConsumerState<OnboardingUserProfilePage> {
  final taglineController = TextEditingController();
  final aboutController = TextEditingController();
  final pageLinkController = TextEditingController();
  final domainController = TextEditingController();
  final domainIdController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final onboardingUserProfileState =
        ref.watch(onboardingUserProfileViewModelProvider);
    final domains = ref.watch(domainProvider);
    ref.listen<AsyncValue<bool>>(onboardingUserProfileViewModelProvider,
        (previous, next) {
      next.when(
        data: (user) {
          CustomSnackbar.showSnackbar(context, 'Onbaording Completed', true);
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (_) => const ConsultantDashboard(),
            ),
            (route) => false,
          );
        },
        loading: () {},
        error: (error, _) {
          CustomSnackbar.showSnackbar(context, error.toString(), false);
        },
      );
    });
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text(
          'Consultant Profile',
          style: TextStyle(
            color: white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 5.w,
            vertical: 2.h,
          ),
          child: ListView(
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Just one last step',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              domains.when(
                data: (values) {
                  if (values.isEmpty) {
                    return const Text('No domains available');
                  }
                  return Container(
                    width: double.infinity,
                    height: 5.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: neutral400,
                      ),
                      borderRadius: BorderRadius.circular(12.sp),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 5.w,
                    ),
                    child: DropdownButton<DomainModel>(
                      dropdownColor: white,
                      isDense: true,
                      icon: Padding(
                        padding: EdgeInsets.only(left: 40.w),
                        child: Icon(
                          TablerIcons.caret_down,
                          color: neutral600,
                          size: 20.sp,
                        ),
                      ),
                      hint: const Text('Select a Domain'),
                      value: domainController.text.isEmpty
                          ? null
                          : values.firstWhere(
                              (domain) => domain.name == domainController.text),
                      underline: Container(),
                      items: values.map((domain) {
                        return DropdownMenuItem<DomainModel>(
                          value: domain,
                          child: Text(
                            domain.name,
                          ),
                        );
                      }).toList(),
                      onChanged: (DomainModel? role) {
                        setState(() {
                          domainController.text = role!.name;
                          domainIdController.text = role.id.toString();
                        });
                      },
                    ),
                  );
                },
                loading: () => const Center(
                  child: CustomProgressIndicator(
                    color: primaryColor,
                  ),
                ),
                error: (error, stackTrace) => Text('Error: $error'),
              ),
              SizedBox(
                height: 2.h,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Profile Tagline',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: 1.h),
              TextFormField(
                controller: taglineController,
                onFieldSubmitted: (value) {},
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: '',
                  hintStyle: TextStyle(
                    color: neutral500,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w400,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 10.sp,
                    horizontal: 12.sp,
                  ),
                  border: InputBorder.none,
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: neutral200),
                    borderRadius: BorderRadius.circular(12.sp),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: neutral200),
                    borderRadius: BorderRadius.circular(12.sp),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.circular(12.sp),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: neutral200),
                    borderRadius: BorderRadius.circular(12.sp),
                  ),
                ),
                cursorColor: primaryColor,
              ),
              SizedBox(
                height: 2.h,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Describe yourself',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: 1.h),
              TextFormField(
                controller: aboutController,
                keyboardType: TextInputType.name,
                maxLines: 3,
                decoration: InputDecoration(
                  hintStyle: TextStyle(
                    color: neutral500,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w400,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 10.sp,
                    horizontal: 12.sp,
                  ),
                  border: InputBorder.none,
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: neutral200),
                    borderRadius: BorderRadius.circular(12.sp),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: neutral200),
                    borderRadius: BorderRadius.circular(12.sp),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.circular(12.sp),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: neutral200),
                    borderRadius: BorderRadius.circular(12.sp),
                  ),
                ),
                cursorColor: primaryColor,
              ),
              SizedBox(
                height: 2.h,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Portfolio or any page link',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: 1.h),
              TextFormField(
                controller: pageLinkController,
                keyboardType: TextInputType.name,
                maxLines: 1,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 10.sp,
                    horizontal: 12.sp,
                  ),
                  border: InputBorder.none,
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: neutral200),
                    borderRadius: BorderRadius.circular(12.sp),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: neutral200),
                    borderRadius: BorderRadius.circular(12.sp),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.circular(12.sp),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: neutral200),
                    borderRadius: BorderRadius.circular(12.sp),
                  ),
                ),
                cursorColor: primaryColor,
              ),
              SizedBox(
                height: 6.h,
              ),
              ElevatedButton(
                onPressed: () {
                  if (!formKey.currentState!.validate()) {
                    return;
                  }
                  if (domainIdController.text.isEmpty) {
                    CustomSnackbar.showSnackbar(
                        context, 'Select Domain First', false);
                    return;
                  }
                  ref
                      .read(onboardingUserProfileViewModelProvider.notifier)
                      .createUserProfile(
                        UserProfileModel(
                          domainId: domainIdController.text.trim(),
                          tagline: taglineController.text.trim(),
                          about: aboutController.text.trim(),
                          pageLink: pageLinkController.text.trim(),
                        ),
                      );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(84.w, 5.h),
                ),
                child: onboardingUserProfileState is AsyncLoading
                    ? const CupertinoActivityIndicator(
                        color: white,
                      )
                    : Text(
                        'Continue',
                        style: TextStyle(
                          color: white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
