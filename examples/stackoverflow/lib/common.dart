import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

part 'common.freezed.dart';
part 'common.g.dart';

class TimestampParser implements JsonConverter<DateTime, int> {
  const TimestampParser();

  @override
  DateTime fromJson(int json) {
    return DateTime.fromMillisecondsSinceEpoch(
      json * 1000,
      isUtc: true,
    );
  }

  @override
  int toJson(DateTime object) => object.millisecondsSinceEpoch;
}

@freezed
abstract class Owner with _$Owner {
  @JsonSerializable(fieldRename: FieldRename.snake)
  factory Owner({
    required int reputation,
    required int userId,
    BadgeCount? badgeCounts,
    required String displayName,
    required String profileImage,
    required String link,
  }) = _Owner;

  factory Owner.fromJson(Map<String, Object> json) => _$OwnerFromJson(json);
}

@freezed
abstract class BadgeCount with _$BadgeCount {
  factory BadgeCount({
    required int bronze,
    required int silver,
    required int gold,
  }) = _BadgeCount;

  factory BadgeCount.fromJson(Map<String, Object> json) =>
      _$BadgeCountFromJson(json);
}

class AnswersCount extends StatelessWidget {
  const AnswersCount(
    this.answerCount, {
    Key? key,
    required this.accepted,
  }) : super(key: key);

  final int answerCount;
  final bool accepted;

  @override
  Widget build(BuildContext context) {
    final textStyle = accepted
        ? null
        : answerCount == 0
            ? const TextStyle(color: Color(0xffacb2b8))
            : const TextStyle(color: Color(0xff5a9e6f));
    return Container(
      decoration: answerCount > 0
          ? BoxDecoration(
              color: accepted ? const Color(0xff5a9e6f) : null,
              border: Border.all(color: const Color(0xff5a9e6f)),
              borderRadius: BorderRadius.circular(3),
            )
          : null,
      padding: const EdgeInsets.all(7),
      child: Column(
        children: [
          Text(answerCount.toString(), style: textStyle),
          Text('answers', style: textStyle)
        ],
      ),
    );
  }
}

class UpvoteCount extends StatelessWidget {
  const UpvoteCount(this.upvoteCount, {Key? key}) : super(key: key);

  final int upvoteCount;

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(color: Color(0xffacb2b8));

    return Padding(
      padding: const EdgeInsets.all(7),
      child: Column(
        children: [
          Text(upvoteCount.toString(), style: textStyle),
          const Text('votes', style: textStyle)
        ],
      ),
    );
  }
}

String _useCreatedSince(DateTime creationDate) {
  final label = useState('');

  useEffect(() {
    void setLabel() {
      final now = DateTime.now();
      final diff = now.difference(creationDate);

      String value;
      if (diff.inDays > 1) {
        value = '${diff.inDays} days';
      } else if (diff.inHours > 0) {
        value = '${diff.inHours} hours';
      } else if (diff.inMinutes > 0) {
        value = '${diff.inMinutes} mins';
      } else {
        value = '${diff.inSeconds} seconds';
      }

      label.value = 'asked $value ago';
    }

    setLabel();
    final timer = Timer.periodic(const Duration(minutes: 1), (_) => setLabel());

    return timer.cancel;
  }, [creationDate]);

  return label.value;
}

class PostInfo extends HookConsumerWidget {
  const PostInfo({
    Key? key,
    required this.owner,
    required this.creationDate,
  }) : super(key: key);

  final Owner owner;
  final DateTime creationDate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final label = _useCreatedSince(creationDate);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF9fa6ad),
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 3),
        Row(
          children: [
            Container(
              height: 32,
              width: 32,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
              ),
              clipBehavior: Clip.hardEdge,
              child: Image.network(owner.profileImage),
            ),
            const SizedBox(width: 4),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  owner.displayName,
                  style: const TextStyle(
                    color: Color(0xff3ca4ff),
                    fontSize: 12,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      '${owner.reputation}',
                      style: const TextStyle(
                        color: Color(0xff9fa6ad),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (owner.badgeCounts != null) ...[
                      if (owner.badgeCounts!.gold > 0) ...[
                        const SizedBox(width: 4),
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: const Color(0xffffcc00),
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '${owner.badgeCounts!.gold}',
                          style: const TextStyle(
                            color: Color(0xff9fa6ad),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                      if (owner.badgeCounts!.silver > 0) ...[
                        const SizedBox(width: 4),
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: const Color(0xffb4b8bc),
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '${owner.badgeCounts!.silver}',
                          style: const TextStyle(
                            color: Color(0xff9fa6ad),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                      if (owner.badgeCounts!.bronze > 0) ...[
                        const SizedBox(width: 4),
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: const Color(0xffd1a784),
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '${owner.badgeCounts!.bronze}',
                          style: const TextStyle(
                            color: Color(0xff9fa6ad),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ],
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

@freezed
abstract class TagTheme with _$TagTheme {
  const factory TagTheme({
    required TextStyle style,
    required EdgeInsets padding,
    required Color backgroundColor,
    required BorderRadius borderRadius,
  }) = _TagTheme;
}

final tagThemeProvider = Provider<TagTheme>((ref) {
  throw UnimplementedError();
});

class Tag extends HookConsumerWidget {
  const Tag({
    Key? key,
    required this.tag,
  }) : super(key: key);

  final String tag;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tagTheme = ref.watch(tagThemeProvider);

    return Container(
      decoration: BoxDecoration(
        borderRadius: tagTheme.borderRadius,
        color: tagTheme.backgroundColor,
      ),
      padding: tagTheme.padding,
      child: Text(tag, style: tagTheme.style),
    );
  }
}
