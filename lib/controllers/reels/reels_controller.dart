import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import 'package:video_player/video_player.dart';
import '../../models/profile/user_model.dart';
import '../../models/reels/reel_model.dart';
import '../../services/app_auth_service.dart';
import '../../services/storage_service.dart';
import '../../view/screens/home/home_page.dart';

class ReelsController extends GetxController {
  Rx<TextEditingController> _reelSearchController = TextEditingController().obs;
  Rx<TextEditingController> _reelSearchController1 = TextEditingController().obs;

  TextEditingController get reelSearchController => _reelSearchController.value;

  String get searchQuery => reelSearchController.text;
  RxList<ReelModel> searchedReelsList = <ReelModel>[].obs;
  final _reelDbRef = FirebaseFirestore.instance.collection('reels');
  RxList<ReelModel> allReelsList = <ReelModel>[].obs;
  RxBool _isLoading = false.obs;

  get isLoading => _isLoading.value;

  updateLoading(bool value) => _isLoading.value = value;
  RxBool _isCommentLoading = false.obs;

  bool get isCommentLoading => _isCommentLoading.value;

  updateCommentLoading(bool value) => _isCommentLoading.value = value;

  RxList<ReelModel> currentUserReels = <ReelModel>[].obs;

  Rx<TextEditingController> _titleController = TextEditingController().obs;
  Rx<TextEditingController> _captionController = TextEditingController().obs;
  Rx<TextEditingController> _commentController = TextEditingController().obs;

  TextEditingController get titleController => _titleController.value;

  TextEditingController get commentController => _commentController.value;

  TextEditingController get captionController => _captionController.value;

  String get title => titleController.text;

  String get commentText => commentController.text;

  String get caption => captionController.text;
  Rx<File?> _videoFile = Rx<File?>(null);

  File? get videoFile => _videoFile.value;
  File? get photoFile => _videoFile.value;
  Rx<VideoPlayerController?> _fileVideoController = Rx<VideoPlayerController?>(null);

  VideoPlayerController? get fileVideoController => _fileVideoController.value;

  get updateVideoController {
    var videoController = VideoPlayerController.file(videoFile!,
        videoPlayerOptions: VideoPlayerOptions(
          allowBackgroundPlayback: true,
        ));
    videoController.initialize().then(
          (value) {
        videoController.play();
        _fileVideoController.value = videoController;
      },
    );
  }

  void updateVideoFile(File? file) => _videoFile.value = file;
  final StorageService _storageService =
  StorageService(collectionName: 'reels');
  void updatePhotoFile(File? file) => _videoFile.value = file;
  final StorageService _storageService1 =
  StorageService(collectionName: 'photo');

  @override
  void onInit() {
    fetchReels();
    super.onInit();
  }

  fetchReels() {
    _reelDbRef.snapshots().listen(
          (snapshot) {
        allReelsList.value = snapshot.docs
            .map(
              (doc) => ReelModel.fromJson(doc.data()),
        )
            .toList();
        currentUserReels.value = allReelsList.value.where(
              (reel) => reel.authorId == AppAuth.userId,
        ).toList();
        performSearch('');
      },
    );
  }

  uploadReel() async {
    if (videoFile == null) {
      showMessage(message: "Please choose Video");
    } else if (title.isEmpty || caption.isEmpty) {
      showMessage(message: "Please fill empty fields");
    } else {
      updateLoading(true);
      String? videoUrl;
      if (videoFile != null) {
        videoUrl = await _storageService.uploadMedia(
            file: videoFile!, fileName: reelName(), type: MediaType.video);
      }
      var newReelId = _reelDbRef.doc().id;
      var reel = ReelModel(
        id: newReelId,
        authorId: AppAuth.userId,
        caption: caption,
        comments: <Comment>[],
        title: title,
        likesIds: [],
        numberOfComments: 0,
        numberOfLikes: 0,
        video: videoUrl,
      );
      await _reelDbRef.doc(newReelId).set(reel.toJson());
      updateLoading(false);
      showMessage(message: 'Post Uploaded Successfully');
      Get.offAll(HomePage());
      resetFields();
    }
  }

  String reelName() {
    return "${AppAuth.userId}reelNo-${DateTime.now().microsecond}";
  }

  void showMessage({required String message}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  Stream<UserModel> reelAuthorData(String? authorId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(authorId)
        .snapshots()
        .map(
          (snapshot) {
        if (snapshot.exists) {
          return UserModel.fromJson(snapshot.data()!);
        } else {
          throw UserModel();
        }
      },
    );
  }

  void resetFields() {
    titleController.clear();
    captionController.clear();
    updateVideoFile(null);
    updateVideoController;
  }

  Widget isReelLikedWidget(List<String>? likesIds) {
    if (likesIds?.contains(AppAuth.userId) == true) {
      return Icon(
        Icons.favorite,
        color: Colors.red,
      );
    } else {
      return Icon(
        Icons.favorite_border,
        color: Colors.white,
      );
    }
  }

  void manageReelLike(ReelModel reel) {
    if (reel.likesIds?.contains(AppAuth.userId) == true) {
      _reelDbRef.doc(reel.id).update({
        "likes_ids": FieldValue.arrayRemove([AppAuth.userId]),
        "number_of_likes": FieldValue.increment(-1),
      });
    } else {
      _reelDbRef.doc(reel.id).update({
        "likes_ids": FieldValue.arrayUnion([AppAuth.userId]),
        "number_of_likes": FieldValue.increment(1),
      });
    }
  }

  void performSearch(String text) {
    if (searchQuery.isEmpty) {
      searchedReelsList.value = allReelsList;
      return;
    }
    searchedReelsList.value = allReelsList
        .where(
          (reel) =>
      reel.caption?.toLowerCase().contains(searchQuery) == true ||
          reel.title?.toLowerCase().contains(searchQuery) == true,
    )
        .toList();
  }

  Future<void> uploadComment(ReelModel reel) async {
    if (commentText.isEmpty) {
      showMessage(message: 'Please fill Comment');
      return;
    }
    updateCommentLoading(true);
    var comment = Comment(
        commentId: "${AppAuth.userId}${DateTime.now().microsecond.toString()}",
        text: commentText,
        commentAuthorId: AppAuth.userId,
        createdAt: DateTime.now());
    await _reelDbRef.doc(reel.id).update({
      "number_of_comments": (reel.comments?.length ?? 0) + 1,
      "comments": FieldValue.arrayUnion([comment.toJson()]),
    });
    updateCommentLoading(false);
    reel.comments?.add(comment);
    showMessage(message: 'Comment Uploaded Successfully');
    commentController.clear();
  }
}
