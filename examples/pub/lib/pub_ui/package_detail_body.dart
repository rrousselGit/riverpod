import 'package:flutter/material.dart';

class PackageDetailBodyScrollView extends StatelessWidget {
  const PackageDetailBodyScrollView({
    super.key,
    this.packageDescription,
    required this.packageName,
    required this.packageVersion,
    required this.likeCount,
    required this.grantedPoints,
    required this.maxPoints,
    required this.popularityScore,
  });

  final String packageName;
  final String packageVersion;
  final String? packageDescription;
  final int likeCount;
  final int grantedPoints;
  final int maxPoints;
  final double popularityScore;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      children: [
        Text(
          '$packageName $packageVersion',
          style: const TextStyle(fontSize: 20),
        ),
        const SizedBox(height: 10),
        Text(packageDescription ?? ''),
        const SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Text(
                  '$likeCount',
                  style: const TextStyle(
                    color: Color(0xff1967d2),
                    fontSize: 40,
                  ),
                ),
                const Text('LIKES', style: TextStyle(fontSize: 13)),
              ],
            ),
            Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '$grantedPoints',
                      style: const TextStyle(
                        color: Color(0xff1967d2),
                        fontSize: 40,
                      ),
                    ),
                    Text(
                      '/$maxPoints',
                      style: const TextStyle(
                        color: Color(0xff1967d2),
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                const Text(
                  'PUB POINTS',
                  style: TextStyle(fontSize: 13),
                ),
              ],
            ),
            Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '${popularityScore.round()}',
                      style: const TextStyle(
                        color: Color(0xff1967d2),
                        fontSize: 40,
                      ),
                    ),
                    const Text(
                      '%',
                      style: TextStyle(
                        color: Color(0xff1967d2),
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                const Text(
                  'POPULARITY',
                  style: TextStyle(fontSize: 13),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
