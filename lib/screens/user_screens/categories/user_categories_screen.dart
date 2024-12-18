import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shaghaf/data_layer/data_layer.dart';
import 'package:shaghaf/extensions/screen_nav.dart';
import 'package:shaghaf/extensions/screen_size.dart';
import 'package:shaghaf/screens/user_screens/categories/bloc/categories_bloc.dart';
import 'package:shaghaf/screens/user_screens/categories/category_workshops_screen.dart';
import 'package:sizer/sizer.dart';

class UserCategoriesScreen extends StatelessWidget {
  const UserCategoriesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final categories = GetIt.I.get<DataLayer>().categories;
    return BlocProvider(
      create: (context) => CategoriesBloc(),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
              forceMaterialTransparency: true,
              centerTitle: true,
              title: Image.asset('assets/images/logo.png', height: 50)),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: SafeArea(
            child: Padding(
                padding: const EdgeInsets.all(16),
                child: GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing:
                          Device.screenType == ScreenType.tablet ? 20.0 : 10.0,
                      crossAxisSpacing:
                          Device.screenType == ScreenType.tablet ? 20.0 : 10.0,
                      childAspectRatio:
                          Device.screenType == ScreenType.tablet ? 1.5 : 1.2),
                  itemCount: categories.length,
                  itemBuilder: (context, index) => InkWell(
                    onTap: () {
                      context.push(
                          screen: CategoryWorkshopsScreen(
                        category: categories[index],
                        bloc: context.read<CategoriesBloc>()
                          ..add(CategorySearchEvent(
                              category: categories[index], searchTerm: '')),
                      ));
                    },
                    child: Center(
                      child: BlocBuilder<CategoriesBloc, CategoriesState>(
                        builder: (context, state) {
                          return Container(
                            height: context.getHeight(),
                            width: context.getWidth(),
                            decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                image: DecorationImage(
                                    image: AssetImage(categories[index].image),
                                    fit: BoxFit.cover)),
                            alignment: Alignment.center,
                            child: Container(
                              height: context.getHeight(),
                              width: context.getWidth(),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  color: Colors.black.withOpacity(0.35)),
                              child: Text(
                                  categories[index]
                                      .categoryName
                                      .tr(context: context),
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 18)),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                )),
          ),
        );
      }),
    );
  }
}
