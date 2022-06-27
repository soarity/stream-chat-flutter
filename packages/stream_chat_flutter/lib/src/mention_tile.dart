import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// This widget is used for showing user tiles for mentions
/// Use [title], [subtitle], [leading], [trailing] for
/// substituting widgets in respective positions
@Deprecated('Use `UserMentionTile` instead. Will be removed in future release')
class MentionTile extends StatelessWidget {
  /// Constructor for creating a [MentionTile] widget
  const MentionTile(
    this.member, {
    super.key,
    this.title,
    this.subtitle,
    this.leading,
    this.trailing,
  });

  /// Member to display in the tile
  final Member member;

  /// Widget to display as title
  final Widget? title;

  /// Widget to display below [title]
  final Widget? subtitle;

  /// Widget at the start of the tile
  final Widget? leading;

  /// Widget at the end of tile
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final chatThemeData = StreamChatTheme.of(context);
    return SizedBox(
      height: 56.h,
      child: Row(
        children: [
          SizedBox(width: 16.w),
          leading ??
              UserAvatar(
                constraints: BoxConstraints.tight(
                  Size(
                    40.r,
                    40.r,
                  ),
                ),
                user: member.user!,
              ),
          SizedBox(width: 8.w),
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  title ??
                      Text(
                        member.user!.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: chatThemeData.textTheme.bodyBold,
                      ),
                  SizedBox(height: 2.h),
                  subtitle ??
                      Text(
                        '@${member.userId}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: chatThemeData.textTheme.footnoteBold.copyWith(
                          color: chatThemeData.colorTheme.textLowEmphasis,
                        ),
                      ),
                ],
              ),
            ),
          ),
          trailing ??
              Padding(
                padding: EdgeInsets.only(right: 18.w, left: 8.w),
                child: StreamSvgIcon.mentions(
                  size: 24.r,
                  color: chatThemeData.colorTheme.accentPrimary,
                ),
              ),
        ],
      ),
    );
  }
}
