import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PackageItem extends StatelessWidget {
  const PackageItem({
    super.key,
    required this.name,
    required this.version,
    required this.description,
    this.onTap,
  });

  final String name;
  final String version;
  final String? description;

  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final description = this.description;

    return ListTile(
      onTap: onTap,
      title: Row(
        children: [
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xff0175c2),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Text(version),
        ],
      ),
      subtitle: description != null ? Text(description) : null,
    );
  }
}

class PackageItemShimmer extends StatelessWidget {
  const PackageItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.white,
      child: ListTile(
        title: Builder(
          builder: (context) {
            return Row(
              children: [
                Container(
                  height: DefaultTextStyle.of(context).style.fontSize! * .8,
                  width: 100,
                  decoration: const BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.all(
                      Radius.circular(50),
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  height: DefaultTextStyle.of(context).style.fontSize! * .8,
                  width: 40,
                  decoration: const BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.all(
                      Radius.circular(50),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        subtitle: Builder(
          builder: (context) {
            return Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Column(
                children: [
                  Container(
                    height: DefaultTextStyle.of(context).style.fontSize! * .8,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.all(
                        Radius.circular(50),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    height: DefaultTextStyle.of(context).style.fontSize! * .8,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.all(
                        Radius.circular(50),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
