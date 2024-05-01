import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modarb_app/core/helper/extension.dart';
import 'package:modarb_app/core/helper/spacing.dart';
import 'package:modarb_app/core/theming/colors.dart';
import 'package:modarb_app/core/theming/styles.dart';
import 'package:modarb_app/features/my_trainer/logic/trainer_cubit.dart';
import 'package:modarb_app/features/my_trainer/logic/trainer_states.dart';

class SheetOfAddingExercises extends StatelessWidget {
  const SheetOfAddingExercises({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrainerCubit, TrainerState>(
      builder: (context, state) {
        var cubit = context.read<TrainerCubit>();
        return Container(
          decoration: const BoxDecoration(
            color: ColorsManager.darkGray,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
               Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: (){
                        context.pop();
                      },
                    icon: const Icon(Icons.close),
                  ),
                  TextButton(
                      onPressed: (){},
                      child: const Text('ADD')) ,
                ],
              ),
              verticalSpace(10),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'search',
                  hintStyle: const TextStyle(
                      color: ColorsManager.mainPurple
                  ),
                  filled: true,
                  fillColor: ColorsManager.lighterGray,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: BorderSide.none,

                  ),
                  prefixIcon: const Icon(Icons.search,
                    color: ColorsManager.mainPurple,
                  ),
                ),
              ),
              verticalSpace(10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButton(
                  value: cubit.valueChoose,
                  hint:  cubit.valueChoose == null ? const Text('select item') : Text('${cubit.valueChoose}') ,
                  dropdownColor: ColorsManager.lighterGray,
                  icon: const Icon(Icons.arrow_drop_down),
                  iconSize: 33,
                  isExpanded: true,
                  underline: const SizedBox(),
                  onChanged: (String ?newValue) {
                    cubit.emitChangeSelection(newValue);
                  },
                  items: cubit.itemsExercisesList.map((valueItem){
                    return DropdownMenuItem(
                      value :valueItem,
                    child : Text(valueItem),
                  );
                  }).toList(),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {},
                      child: ListTile(
                    title: Text(
                      'chest press',
                      style: TextStyles.font16White700,
                    ),
                    subtitle: Text(
                      'full-body',
                      style: TextStyles.font12White600,
                    ),
                    leading: SizedBox(
                      width: 70.w,
                      height: 60.h,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.r),
                        child: Image.asset(
                          'assets/images/Muscles1.png',
                          fit: BoxFit.fill,

                        ),
                      ),
                    ),

                  ),
                    );
                    },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}