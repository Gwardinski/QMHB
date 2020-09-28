import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/models/user_model.dart';
import 'package:qmhb/services/user_collection_service.dart';

class UserListener extends StatefulWidget {
  final child;
  UserListener({
    @required this.child,
  });

  @override
  _UserListenerState createState() => _UserListenerState();
}

class _UserListenerState extends State<UserListener> {
  bool _hasInitiated = false;

  UserDataStateModel _userDataStateModel;
  @override
  Widget build(BuildContext context) {
    _userDataStateModel = Provider.of<UserDataStateModel>(context);
    UserModel currentUserModel = _userDataStateModel.user;
    return StreamBuilder(
      stream: UserCollectionService().getUserStream(currentUserModel?.uid),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          UserModel newUserModel = snapshot.data;
          bool hasUpdated =
              newUserModel.lastUpdated.toString() != currentUserModel.lastUpdated.toString();
          if (hasUpdated || !_hasInitiated) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                _hasInitiated = true;
              });
              _userDataStateModel.updateCurrentUser(newUserModel);
            });
          }
        }
        return widget.child;
      },
    );
  }
}
