import 'package:custom_button/http_crud/http_crud_vm.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class HttpCrudVU extends StackedView<HttpCrudVM> {
  const HttpCrudVU({super.key});

  @override
  Future<void> onViewModelReady(HttpCrudVM viewModel) async {
    viewModel.fetchData();
  }

  @override
  Widget builder(BuildContext context, HttpCrudVM viewModel, Widget? child) {
    if (viewModel.isBusy && viewModel.data.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text("HTTP CRUD App")),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text("HTTP CRUD App")),
      body: Center(
        child: !viewModel.isError
            ? !viewModel.showBlog
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: viewModel.data.isEmpty
                              ? Center(child: Text("No data loaded"))
                              : ListView.builder(
                                  itemCount: viewModel.data.length,
                                  itemBuilder: (context, index) => ListTile(
                                    leading: Text(
                                      viewModel.data[index]["id"].toString(),
                                    ),
                                    title: Text(
                                      viewModel.data[index]["title"].toString(),
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          onPressed: () {},
                                          icon: Icon(Icons.edit),
                                        ),
                                        IconButton(
                                          onPressed: () {},
                                          icon: Icon(Icons.delete),
                                        ),
                                      ],
                                    ),
                                    onTap: () {
                                      viewModel.openBlog(index);
                                    },
                                  ),
                                ),
                        ),
                        ElevatedButton(
                          onPressed: viewModel.fetchData,
                          child: Text("Load"),
                        ),
                      ],
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            viewModel.data[viewModel.blogIndex!]['title'],
                            style: TextStyle(fontSize: 30),
                            textAlign: TextAlign.center,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: Text(
                              viewModel.data[viewModel.blogIndex!]['body'],
                            ),
                          ),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: viewModel.backToList,
                            child: Text("Back"),
                          ),
                        ],
                      ),
                    )
            : Center(
                child: AlertDialog(
                  title: Text("Error"),
                  content: Text(
                    viewModel.errorMessage.isEmpty
                        ? "Could not fetch data, try again?"
                        : viewModel.errorMessage,
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        viewModel.fetchData();
                      },
                      child: Text("Yes"),
                    ),
                    TextButton(
                      onPressed: viewModel.backToList,
                      child: Text("No"),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  @override
  HttpCrudVM viewModelBuilder(BuildContext context) {
    return HttpCrudVM();
  }
}
