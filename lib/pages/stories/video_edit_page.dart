import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pro_image_editor/pro_image_editor.dart';
import 'package:pro_video_editor/pro_video_editor.dart';
import 'package:video_player/video_player.dart';

/// A sample page demonstrating how to use the video-editor.
class VideoEditorPage extends StatefulWidget {
  final String path;
  const VideoEditorPage({super.key, required this.path});
  @override
  State<VideoEditorPage> createState() =>
      _VideoEditorPageState();
}

class _VideoEditorPageState
    extends State<VideoEditorPage> {
  /// The target format for the exported video.
  final _outputFormat = VideoOutputFormat.mp4;
  
  /// Video editor configuration settings.
  late final VideoEditorConfigs _videoConfigs = const VideoEditorConfigs(
    initialMuted: true,
    initialPlay: false,
    isAudioSupported: true,
    minTrimDuration: Duration(seconds: 7),
  );

  /// Indicates whether a seek operation is in progress.
  bool _isSeeking = false;

  /// Stores the currently selected trim duration span.
  TrimDurationSpan? _durationSpan;

  /// Temporarily stores a pending trim duration span.
  TrimDurationSpan? _tempDurationSpan;

  /// Controls video playback and trimming functionalities.
  ProVideoController? _proVideoController;

  /// Stores generated thumbnails for the trimmer bar and filter background.
  List<ImageProvider>? _thumbnails;

  /// Holds information about the selected video.
  late VideoMetadata _videoMetadata;

  /// Number of thumbnails to generate across the video timeline.
  final int _thumbnailCount = 7;

  /// The video currently loaded in the editor.
  late EditorVideo _video;

  String? _outputPath;

  /// The duration it took to generate the exported video.
  Duration _videoGenerationTime = Duration.zero;
  late VideoPlayerController _videoController;

  final _taskId = DateTime.now().microsecondsSinceEpoch.toString();
  bool _isInitializing = true;
  String _initializationStatus = 'Loading video...';

  @override
  void initState() {
    super.initState();
    _initializeEditor();
  }

  @override
  void dispose() {
    _videoController.dispose();
    _proVideoController?.dispose();
    super.dispose();
  }

  Future<void> _initializeEditor() async {
    try {
      setState(() => _initializationStatus = 'Loading video metadata...');
      
      _video = EditorVideo.file(File(widget.path));
      await _setMetadata();
      
      setState(() => _initializationStatus = 'Initializing video player...');
      await _initializeVideoPlayer();
      
      setState(() => _initializationStatus = 'Generating thumbnails...');
      await _generateThumbnails();
      
      setState(() => _initializationStatus = 'Setting up controller...');
      _setupProVideoController();
      
      setState(() => _isInitializing = false);
      
    } catch (e) {
      print('Initialization error: $e');
      setState(() {
        _initializationStatus = 'Error: $e';
        _isInitializing = false;
      });
    }
  }

  /// Loads and sets [_videoMetadata] for the given [_video].
  Future<void> _setMetadata() async {
    _videoMetadata = await ProVideoEditor.instance.getMetadata(_video);
    print("Metadata duration: ${_videoMetadata.duration}");
  }

  /// Initializes the video player controller
  Future<void> _initializeVideoPlayer() async {
    _videoController = VideoPlayerController.file(File(widget.path));
    
    await _videoController.initialize();
    await _videoController.setLooping(false);
    await _videoController.setVolume(_videoConfigs.initialMuted ? 0 : 100);
    
    if (_videoConfigs.initialPlay) {
      await _videoController.play();
    } else {
      await _videoController.pause();
    }
    
    _videoController.addListener(_onDurationChange);
  }

  /// Generates thumbnails for the given [_video].
  Future<void> _generateThumbnails() async {
    if (!mounted) return;
    
    var imageWidth = MediaQuery.sizeOf(context).width /
        _thumbnailCount *
        MediaQuery.devicePixelRatioOf(context);

    List<Uint8List> thumbnailList = [];

    try {
      if (!kIsWeb && Platform.isAndroid) {
        thumbnailList = await ProVideoEditor.instance.getKeyFrames(
          KeyFramesConfigs(
            video: _video,
            outputSize: Size.square(imageWidth),
            boxFit: ThumbnailBoxFit.cover,
            maxOutputFrames: _thumbnailCount,
            outputFormat: ThumbnailFormat.jpeg,
          ),
        );
      } else {
        final duration = _videoMetadata.duration;
        final segmentDuration = duration.inMilliseconds / _thumbnailCount;

        thumbnailList = await ProVideoEditor.instance.getThumbnails(
          ThumbnailConfigs(
            video: _video,
            outputSize: Size.square(imageWidth),
            boxFit: ThumbnailBoxFit.cover,
            timestamps: List.generate(_thumbnailCount, (i) {
              final midpointMs = (i + 0.5) * segmentDuration;
              return Duration(milliseconds: midpointMs.round());
            }),
            outputFormat: ThumbnailFormat.jpeg,
          ),
        );
      }

      List<ImageProvider> temporaryThumbnails =
          thumbnailList.map(MemoryImage.new).toList();

      // Precache thumbnails
      var cacheList =
          temporaryThumbnails.map((item) => precacheImage(item, context));
      await Future.wait(cacheList);
      
      _thumbnails = temporaryThumbnails;

    } catch (e) {
      print('Thumbnail generation error: $e');
      // Continue without thumbnails rather than failing completely
      _thumbnails = [];
    }
  }

  void _setupProVideoController() {
    _proVideoController = ProVideoController(
      videoPlayer: _buildVideoPlayer(),
      initialResolution: _videoMetadata.resolution,
      videoDuration: _videoMetadata.duration,
      fileSize: _videoMetadata.fileSize,
      thumbnails: _thumbnails,
    );
  }

  void _onDurationChange() {
    if (!mounted || _proVideoController == null) return;
    
    var totalVideoDuration = _videoMetadata.duration;
    var duration = _videoController.value.position;
    _proVideoController!.setPlayTime(duration);

    if (_durationSpan != null && duration >= _durationSpan!.end) {
      _seekToPosition(_durationSpan!);
    } else if (duration >= totalVideoDuration) {
      _seekToPosition(
        TrimDurationSpan(start: Duration.zero, end: totalVideoDuration),
      );
    }
  }

  Future<void> _seekToPosition(TrimDurationSpan span) async {
    _durationSpan = span;

    if (_isSeeking) {
      _tempDurationSpan = span; // Store the latest seek request
      return;
    }
    _isSeeking = true;

    _proVideoController!.pause();
    _proVideoController!.setPlayTime(_durationSpan!.start);

    await _videoController.pause();
    await _videoController.seekTo(span.start);

    _isSeeking = false;

    // Check if there's a pending seek request
    if (_tempDurationSpan != null) {
      TrimDurationSpan nextSeek = _tempDurationSpan!;
      _tempDurationSpan = null; // Clear the pending seek
      await _seekToPosition(nextSeek); // Process the latest request
    }
  }

  /// Generates the final video based on the given [parameters].
  Future<void> generateVideo(CompleteParameters parameters) async {
    final stopwatch = Stopwatch()..start();

    await _videoController.pause();

    var exportModel = RenderVideoModel(
      id: _taskId,
      video: _video,
      outputFormat: _outputFormat,
      enableAudio: _proVideoController?.isAudioEnabled ?? true,
      imageBytes: parameters.layers.isNotEmpty ? parameters.image : null,
      blur: parameters.blur,
      colorMatrixList: parameters.colorFilters,
      startTime: parameters.startTime,
      endTime: parameters.endTime,
      transform: parameters.isTransformed
          ? ExportTransform(
              width: parameters.cropWidth,
              height: parameters.cropHeight,
              rotateTurns: parameters.rotateTurns,
              x: parameters.cropX,
              y: parameters.cropY,
              flipX: parameters.flipX,
              flipY: parameters.flipY,
            )
          : null,
    );

    final directory = await getTemporaryDirectory();
    final now = DateTime.now().millisecondsSinceEpoch;
    _outputPath = await ProVideoEditor.instance.renderVideoToFile(
      '${directory.path}/my_video_$now.mp4',
      exportModel,
    );
    _videoGenerationTime = stopwatch.elapsed;
  }

  /// Closes the video editor
  void onCloseEditor(EditorMode editorMode) async {
    if (editorMode != EditorMode.main) return Navigator.pop(context);
    if (_outputPath != null) {
      // Handle preview navigation if needed
      Navigator.pop(context, _outputPath);
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isInitializing) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 20),
              Text(
                _initializationStatus,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    if (_proVideoController == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Failed to initialize video editor'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _initializeEditor,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return _buildEditor();
  }

  final _editor = GlobalKey<ProImageEditorState>();

  Widget _buildEditor() {
    return ProImageEditor.video(
      _proVideoController!,
      key: _editor,
      callbacks: ProImageEditorCallbacks(
        onCompleteWithParameters: generateVideo,
        onCloseEditor: onCloseEditor,
        videoEditorCallbacks: VideoEditorCallbacks(
          onPause: _videoController.pause,
          onPlay: _videoController.play,
          onMuteToggle: (isMuted) {
            _videoController.setVolume(isMuted ? 0 : 100);
          },
          onTrimSpanUpdate: (durationSpan) {
            if (_videoController.value.isPlaying) {
              _proVideoController!.pause();
            }
          },
          onTrimSpanEnd: _seekToPosition,
        ),
      ),
      configs: ProImageEditorConfigs(
        dialogConfigs: const DialogConfigs(
          widgets: DialogWidgets(
            // loadingDialog: (message, configs) => Center(
            //   child: CircularProgressIndicator(
            //     value: configs?.progress,
            //   ),
            // ),
          ),
        ),
        mainEditor: const MainEditorConfigs(
          widgets: MainEditorWidgets(),
        ),
        paintEditor: const PaintEditorConfigs(
          enableModePixelate: false,
          enableModeBlur: false,
        ),
        videoEditor: _videoConfigs.copyWith(
          playTimeSmoothingDuration: const Duration(milliseconds: 600),
        ),
      ),
    );
  }

  Widget _buildVideoPlayer() {
    return Center(
      child: AspectRatio(
        aspectRatio: _videoController.value.aspectRatio,
        child: VideoPlayer(_videoController),
      ),
    );
  }
}