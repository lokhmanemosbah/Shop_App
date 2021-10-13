import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/modules/search_screen/cubit/seaechcubitstates.dart';
import 'package:shop/modules/search_screen/cubit/searchcubit.dart';
import 'package:shop/shared/components/components.dart';
import 'package:shop/shared/components/constants.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  var formKey = GlobalKey<FormState>();
  var searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SearchCubit(),
      child: BlocConsumer<SearchCubit, SearchCubitStates>(
        listener: (context, state) {
          if(state is SearchSeccessState){
            print('status from listner ${state.searchModel.status}');
            print('messag from listner ${state.searchModel.data!.data![0].name}');
          }
          if(state is SearchErrorState){
            print('error from search listner : ${state.error.toString()}');
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    defaultTextField(
                      controller: searchController,
                      type: TextInputType.text,
                      textForUnValid: 'enter text to search',
                      onSubmit: (String text) {
                        SearchCubit.get(context).search(text: text.toString());
                      },
                      text: isArabic ? 'بحث':'Search',
                      prefix: Icons.search,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    if (state is SearchLodingState) LinearProgressIndicator(),
                    SizedBox(
                      height: 10.0,
                    ),
                    if (state is SearchSeccessState)
                      Expanded(
                        child: ListView.separated(
                          itemBuilder: (context, index) => buildListProduct(
                            SearchCubit.get(context).searchModel!.data!.data![index],
                            context,
                          ),
                          separatorBuilder: (context, index) => myDivider(),
                          itemCount:
                          SearchCubit.get(context).searchModel!.data!.data!.length,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
