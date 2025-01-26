import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediamaster/Widgets/themes.dart';

import 'guest_bloc.dart';

class GuestScreen extends StatefulWidget {
  const GuestScreen({super.key});

  @override
  _GuestScreenState createState() => _GuestScreenState();
}

class _GuestScreenState extends State<GuestScreen> {

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final guestBloc = BlocProvider.of<GuestBloc>(context);
    guestBloc.add(
      GuestButtonPressed(
        context: context,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Guest Screen'),
      ),
      body: BlocListener<GuestBloc, GuestState>(
        listener: (context, state) {
          if (state is GuestFailure) {
            ScaffoldMessenger
              .of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.error),
                  duration: const Duration(seconds: 3),
                )
              );
          }
        },
        child: BlocBuilder<GuestBloc, GuestState>(
          builder: (context, state) {
            if (state is GuestLoading) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: loadingWidget(context),
                ),
              );
            } 
            else {
              return Center(
                child: Text('No Loading State'),
              );
            }
          },
        ),
      ),
    );
  }
}
