import 'package:discover_deep_cove/data/models/activity/activity_images.dart';
import 'package:discover_deep_cove/data/models/activity/track.dart';
import 'package:discover_deep_cove/data/models/media_file.dart';
import 'package:jaguar_orm/jaguar_orm.dart';

part 'activity.jorm.dart';

enum ActivityType{
  countActivity,
  photographActivity,
  pictureSelectActivity,
  pictureTapActivity,
  textAnswerActivity
}

class Activity {
  @PrimaryKey()
  int id;

  @Column()
  DateTime lastModified;

  @BelongsTo(TrackBean)
  int trackId;

  @Column()
  int activityType;

  @Column()
  String qrCode;

  @Column()
  double xCoord;

  @Column()
  double yCoord;

  @Column()
  String title;

  @Column()
  String description;

  @Column(isNullable: true)
  String task;

  /// The image to display with the activity description.
  @BelongsTo(MediaFileBean, isNullable: true)
  int imageId;

  /// The image that the user took for this activity.
  @BelongsTo(MediaFileBean, isNullable: true)
  int userPhotoId;

  /// The selected picture for a picture select activity.
  @BelongsTo(MediaFileBean, isNullable: true)
  int selectedPictureId;

  @Column(isNullable: true)
  double userXCoord;

  @Column(isNullable: true)
  double userYCoord;

  @Column(isNullable: true)
  int userCount;

  @Column(isNullable: true)
  String userText;

  @ManyToMany(ActivityImageBean, MediaFileBean)
  List<MediaFile> imageOptions;

  bool isCompleted(){

    switch(ActivityType.values[activityType]){
      case ActivityType.pictureSelectActivity: {
        return selectedPictureId != null;
      }
      break;
      case ActivityType.pictureTapActivity: {
        return userXCoord != null && userYCoord != null;
      }
      break;
      case ActivityType.countActivity: {
        return userCount != null;
      }
      break;
      case ActivityType.textAnswerActivity: {
        return userText != null;
      }
      break;
      case ActivityType.photographActivity: {
        return userPhotoId != null;
      }
      break;
      default: {
        return false;
      }
    }

  }
}

@GenBean()
class ActivityBean extends Bean<Activity> with _ActivityBean {
  ActivityBean(Adapter adapter)
      : activityImageBean = ActivityImageBean(adapter),
        super(adapter);

  final ActivityImageBean activityImageBean;

  TrackBean _trackBean;
  TrackBean get trackBean => _trackBean ?? TrackBean(adapter);

  MediaFileBean _mediaFileBean;
  MediaFileBean get mediaFileBean => _mediaFileBean ?? MediaFileBean(adapter);

  final String tableName = 'activities';
}
