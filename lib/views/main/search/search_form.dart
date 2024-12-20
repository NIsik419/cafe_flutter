import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cafe_front/constants/colors.dart';
import 'package:cafe_front/widgets/button/custom_button_layout.dart';
import '../../../models/cafe.dart';
import '../../../provider/main/cafe_detail/search_view_model.dart';
import '../../../widgets/appbar/FilterBar.dart';
import '../../../widgets/appbar/custom_appbar.dart';

enum SearchState { loading, list, map }

class SearchForm extends StatefulWidget {
  final String keyword;
  const SearchForm({Key? key, required this.keyword}) : super(key: key);

  @override
  State<SearchForm> createState() => _SearchFormState();
}

class _SearchFormState extends State<SearchForm> {
  SearchState state = SearchState.list;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SearchViewModel(),
      // builder를 사용하여 Provider context에 접근할 수 있는 새로운 BuildContext를 얻습니다
      builder: (context, child) {
        final viewModel = context.watch<SearchViewModel>();

        // initState 대신 build 메서드에서 초기 검색을 수행
        if (viewModel.cafeResults.isEmpty && !viewModel.isLoading) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            viewModel.searchCafes(widget.keyword);
          });
        }

        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                const BackButtonAppBar(icons: SizedBox()),
                const CustomSearchBar(),
                const FilterBar(),
                const Align(
                  alignment: Alignment.centerRight,
                  child: CustomButtonLayout(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    borderColor: CustomColors.orange,
                    backgroundColor: CustomColors.orange,
                    child: Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.swap_vert, color: Colors.white, size: 20),
                          Text('추천순', style: TextStyle(
                              color: Colors.white, fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(child: getContent(viewModel)),
              ],
            ),
          ),
        );
      },
    );
  }

  // 검색 결과를 가져오는 함수
  Widget getContent(SearchViewModel viewModel) {
    // if (viewModel.isLoading) {
    //   return const Center(child: CircularProgressIndicator());
    // }

    if (viewModel.cafeResults.isEmpty) {
      return const Center(child: Text('검색 결과가 없습니다.'));
    }

    const greyStyle = TextStyle(color: CustomColors.deepGrey);
    const smallStyle = TextStyle(color: CustomColors.deepGrey, fontSize: 10);

    return ListView.builder(
      itemCount: viewModel.cafeResults.length,
      itemBuilder: (context, idx) {
        Cafe cafe = viewModel.cafeResults[idx];
        return Container(
          margin: const EdgeInsets.all(10),
          height: 200,
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 120,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: List.generate(5, (idx)=>
                      Container(
                        margin: const EdgeInsets.only(right: 5),
                        width: 100,
                        child: Image.asset('assets/images/details/image${idx%3}.jpg',fit: BoxFit.fill,),
                      ),
                  ),
                ),
              ),
              Text(cafe.name, style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 5),
              Text(cafe.address ?? '주소 없음', style: greyStyle),
              const SizedBox(height: 5),
              Text('예상평점 ★ 도보 15분 리뷰 999+', style: greyStyle),
            ],
          ),
        );
      },
    );
  }

}
class CustomSearchBar extends StatefulWidget {
  const CustomSearchBar({Key? key}) : super(key: key);

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
        final viewModel = context.watch<SearchViewModel>();

        return Container(
          margin: const EdgeInsets.all(10),
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xffeeeeee),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: TextFormField(
                    controller: _searchController,
                    style: const TextStyle(fontSize: 13),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: '지역, 메뉴, 매장명 검색',
                      hintStyle: TextStyle(fontSize: 13, color: CustomColors.deepGrey),
                    ),
                    onFieldSubmitted: (value) => _searchCafes(value, viewModel),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => _searchCafes(_searchController.text, viewModel),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  width: 20,
                  child: Image.asset('assets/icons/search_basic.png'),
                ),
              ),
            ],
          ),
        );
  }

  void _searchCafes(String keyword, SearchViewModel viewModel) {
    if (keyword.isNotEmpty) {
      viewModel.searchCafes(keyword);
    }
  }
}