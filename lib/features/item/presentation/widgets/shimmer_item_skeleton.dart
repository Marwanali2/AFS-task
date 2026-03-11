import 'package:afs_task/features/item/presentation/widgets/shimmer_item_skeleton_animation.dart';
import 'package:flutter/material.dart';

class ShimmerItemSkeleton extends StatefulWidget {
  final int index;

  const ShimmerItemSkeleton({super.key, required this.index});

  @override
  State<ShimmerItemSkeleton> createState() => ShimmerItemSkeletonState();
}
