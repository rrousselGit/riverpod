import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.g.dart';
part 'user.freezed.dart';

@freezed
class User with _$User {
  @JsonSerializable(fieldRename: FieldRename.snake)
  factory User({
    required int reputation,
    required int userId,
    BadgeCount? badgeCounts,
    required String displayName,
    required String profileImage,
    required String link,
  }) = _User;

  factory User.fromJson(Map<String, Object> json) => _$UserFromJson(json);
}

@freezed
class BadgeCount with _$BadgeCount {
  factory BadgeCount({
    required int bronze,
    required int silver,
    required int gold,
  }) = _BadgeCount;

  factory BadgeCount.fromJson(Map<String, Object> json) =>
      _$BadgeCountFromJson(json);
}

/// Renders the profile picture of a user and their badges.
class UserAvatar extends StatelessWidget {
  const UserAvatar({super.key, required this.owner});

  final User owner;

  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}
