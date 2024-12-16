import 'package:flutter/material.dart';

class DataDay extends StatefulWidget {
  final String day;
  final List<String> hour;
  final List<String> index;
  
  const DataDay(
      {super.key, required this.day, required this.hour, required this.index});

  @override
  State<DataDay> createState() => _DataDayState();
}

class _DataDayState extends State<DataDay> {
  // bool have_file1 = false;
  // bool have_file2 = false;
  // bool have_file3 = false;
  // bool have_file4 = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: (){
            
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,  // Align contents to the top
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Day text
                Flexible(
                  flex: 1,  // Control the flexibility for day
                  child: Text(
                    widget.day,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 16),  // Adds space between day and the list of hours/indices
          
                // List of hour and index values
                Flexible(
                  flex: 2,  // Control the space for the hour and index
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,  // Align text to the left
                    children: [
                      for (int i = 0; i < widget.hour.length; i++)
                        Row(
                          children: [
                            Text(
                              widget.hour[i],
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(width: 6),  // Adds space between hour and index
                            Text(
                              widget.index[i],
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimaryContainer,
                                fontSize: 22,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
          
                // Icons for additional actions in the same row
                // const SizedBox(width: 16),
                // icon_round(have_file1, icon: Icons.edit_note_outlined),
                // const SizedBox(width: 6),
                // icon_round(have_file2, icon: Icons.attach_file_outlined),
                // const SizedBox(width: 6),
                // icon_round(have_file3, icon: Icons.comment_outlined),
                // const SizedBox(width: 6),
                // if (have_file4)
                //   image_round("assets/images/result2.png")
                // else
                //   image_round("assets/images/result1.png"),
              ],
            ),
          ),
        ),
        const Divider(
          height: 1,
        ),
      ],
    );
  }

  // Method to display icon in rounded container
  Widget icon_round(bool ok, {IconData? icon}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      padding: const EdgeInsets.all(4),
      child: Icon(
        icon,
        color: ok
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.outline,
        size: 18,
      ),
    );
  }

  // Method to display image in rounded container
  Widget image_round(String path) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      padding: const EdgeInsets.all(4),
      child: Image.asset(
        path,
        height: 18,
        width: 18,
      ),
    );
  }
}
