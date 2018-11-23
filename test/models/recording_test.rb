require 'test_helper'

class RecordingTest < ActiveSupport::TestCase
  test '.sync_from_redis creates a recording on archive_started' do
    event = {
      header: {
        timestamp: 5161997873,
        name: "archive_started",
        current_time: 1542719593,
        version: "0.0.1"
      }, payload: {
        record_id: "a0fcb226a234fccc45a9417f8d7c871792e25e1d-1542719370284",
        meeting_id: "a0fcb226a234fccc45a9417f8d7c871792e25e1d-1542719370284"
      }
    }.deep_stringify_keys

    assert_difference "Recording.count" do
      Recording.sync_from_redis(event)
    end
    target = Recording.find_by(record_id: "a0fcb226a234fccc45a9417f8d7c871792e25e1d-1542719370284")
    assert_nil target.meeting_id
    assert_equal target.state, "processing"
    assert_nil target.starttime
    assert_nil target.endtime
    assert_nil target.name
    assert_nil target.participants
    assert_not target.published
  end

  test '.sync_from_redis updates an existent recording on archive_started' do
    r = recordings(:fred_room)
    event = {
      header: {
        timestamp: 5161997873,
        name: "archive_started",
        current_time: 1542719593,
        version: "0.0.1"
      }, payload: {
        record_id: r.record_id,
        meeting_id: r.record_id
      }
    }.deep_stringify_keys

    assert_difference "Recording.count", 0 do
      Recording.sync_from_redis(event)
    end
    target = Recording.find_by(record_id: r.record_id)
    assert_equal target.meeting_id, r.meeting_id
    assert_equal target.state, "processing"
    assert_equal target.starttime, r.starttime
    assert_equal target.endtime, r.endtime
    assert_equal target.name, r.name
    assert_equal target.participants, r.participants
    assert_not target.published
  end

  test '.sync_from_redis creates a recording on archive_ended' do
    event = {
      header: {
        timestamp: 5161997873,
        name: "archive_ended",
        current_time: 1542719593,
        version: "0.0.1"
      }, payload: {
        success: true,
        step_time: 1336,
        external_meeting_id: "Not Fred's Room",
        record_id: "a0fcb226a234fccc45a9417f8d7c871792e25e1d-1542719370284",
        meeting_id: "a0fcb226a234fccc45a9417f8d7c871792e25e1d-1542719370284"
      }
    }.deep_stringify_keys

    assert_difference "Recording.count" do
      Recording.sync_from_redis(event)
    end
    target = Recording.find_by(record_id: "a0fcb226a234fccc45a9417f8d7c871792e25e1d-1542719370284")
    assert_equal target.meeting_id, "Not Fred's Room"
    assert_equal target.state, "processing"
    assert_nil target.starttime
    assert_nil target.endtime
    assert_nil target.name
    assert_nil target.participants
    assert_not target.published
  end

  test '.sync_from_redis updates an existent recording on archive_ended' do
    r = recordings(:fred_room)
    event = {
      header: {
        timestamp: 5161997873,
        name: "archive_ended",
        current_time: 1542719593,
        version: "0.0.1"
      }, payload: {
        success: true,
        step_time: 1336,
        external_meeting_id: "Not Fred's Room",
        record_id: r.record_id,
        meeting_id: r.record_id
      }
    }.deep_stringify_keys

    assert_difference "Recording.count", 0 do
      Recording.sync_from_redis(event)
    end
    target = Recording.find_by(record_id: r.record_id)
    assert_equal target.meeting_id, "Not Fred's Room"
    assert_equal target.state, "processing"
    assert_equal target.starttime, r.starttime
    assert_equal target.endtime, r.endtime
    assert_equal target.name, r.name
    assert_equal target.participants, r.participants
    assert_not target.published
  end

  test '.sync_from_redis creates a recording on sanity_started' do
    event = {
      header: {
        timestamp: 5161997873,
        name: "sanity_started",
        current_time: 1542719593,
        version: "0.0.1"
      }, payload: {
        external_meeting_id: "Not Fred's Room",
        record_id: "a0fcb226a234fccc45a9417f8d7c871792e25e1d-1542719370284",
        meeting_id: "a0fcb226a234fccc45a9417f8d7c871792e25e1d-1542719370284"
      }
    }.deep_stringify_keys

    assert_difference "Recording.count" do
      Recording.sync_from_redis(event)
    end
    target = Recording.find_by(record_id: "a0fcb226a234fccc45a9417f8d7c871792e25e1d-1542719370284")
    assert_equal target.meeting_id, "Not Fred's Room"
    assert_equal target.state, "processing"
    assert_nil target.starttime
    assert_nil target.endtime
    assert_nil target.name
    assert_nil target.participants
    assert_not target.published
  end

  test '.sync_from_redis updates an existent recording on sanity_started' do
    r = recordings(:fred_room)
    event = {
      header: {
        timestamp: 5161997873,
        name: "sanity_started",
        current_time: 1542719593,
        version: "0.0.1"
      }, payload: {
        external_meeting_id: "Not Fred's Room",
        record_id: r.record_id,
        meeting_id: r.record_id
      }
    }.deep_stringify_keys

    assert_difference "Recording.count", 0 do
      Recording.sync_from_redis(event)
    end
    target = Recording.find_by(record_id: r.record_id)
    assert_equal target.meeting_id, "Not Fred's Room"
    assert_equal target.state, "processing"
    assert_equal target.starttime, r.starttime
    assert_equal target.endtime, r.endtime
    assert_equal target.name, r.name
    assert_equal target.participants, r.participants
    assert_not target.published
  end

  test '.sync_from_redis creates a recording on sanity_ended' do
    event = {
      header: {
        timestamp: 5161997873,
        name: "sanity_ended",
        current_time: 1542719593,
        version: "0.0.1"
      }, payload: {
        success: true,
        step_time: 557,
        external_meeting_id: "Not Fred's Room",
        record_id: "a0fcb226a234fccc45a9417f8d7c871792e25e1d-1542719370284",
        meeting_id: "a0fcb226a234fccc45a9417f8d7c871792e25e1d-1542719370284"
      }
    }.deep_stringify_keys

    assert_difference "Recording.count" do
      Recording.sync_from_redis(event)
    end
    target = Recording.find_by(record_id: "a0fcb226a234fccc45a9417f8d7c871792e25e1d-1542719370284")
    assert_equal target.meeting_id, "Not Fred's Room"
    assert_equal target.state, "processing"
    assert_nil target.starttime
    assert_nil target.endtime
    assert_nil target.name
    assert_nil target.participants
    assert_not target.published
  end

  test '.sync_from_redis updates an existent recording on sanity_ended' do
    r = recordings(:fred_room)
    event = {
      header: {
        timestamp: 5161997873,
        name: "sanity_ended",
        current_time: 1542719593,
        version: "0.0.1"
      }, payload: {
        success: true,
        step_time: 557,
        external_meeting_id: "Not Fred's Room",
        record_id: r.record_id,
        meeting_id: r.record_id
      }
    }.deep_stringify_keys

    assert_difference "Recording.count", 0 do
      Recording.sync_from_redis(event)
    end
    target = Recording.find_by(record_id: r.record_id)
    assert_equal target.meeting_id, "Not Fred's Room"
    assert_equal target.state, "processing"
    assert_equal target.starttime, r.starttime
    assert_equal target.endtime, r.endtime
    assert_equal target.name, r.name
    assert_equal target.participants, r.participants
    assert_not target.published
  end

  test '.sync_from_redis creates a recording on process_started' do
    event = {
      header: {
        timestamp: 5161997873,
        name: "process_started",
        current_time: 1542719593,
        version: "0.0.1"
      }, payload: {
        workflow: "presentation",
        external_meeting_id: "Not Fred's Room",
        record_id: "a0fcb226a234fccc45a9417f8d7c871792e25e1d-1542719370284",
        meeting_id: "a0fcb226a234fccc45a9417f8d7c871792e25e1d-1542719370284"
      }
    }.deep_stringify_keys

    assert_difference "Recording.count" do
      Recording.sync_from_redis(event)
    end
    target = Recording.find_by(record_id: "a0fcb226a234fccc45a9417f8d7c871792e25e1d-1542719370284")
    assert_equal target.meeting_id, "Not Fred's Room"
    assert_equal target.state, "processing"
    assert_nil target.starttime
    assert_nil target.endtime
    assert_nil target.name
    assert_nil target.participants
    assert_not target.published
  end

  test '.sync_from_redis updates an existent recording on process_started' do
    r = recordings(:fred_room)
    event = {
      header: {
        timestamp: 5161997873,
        name: "process_started",
        current_time: 1542719593,
        version: "0.0.1"
      }, payload: {
        workflow: "presentation",
        external_meeting_id: "Not Fred's Room",
        record_id: r.record_id,
        meeting_id: r.record_id
      }
    }.deep_stringify_keys

    assert_difference "Recording.count", 0 do
      Recording.sync_from_redis(event)
    end
    target = Recording.find_by(record_id: r.record_id)
    assert_equal target.meeting_id, "Not Fred's Room"
    assert_equal target.state, "processing"
    assert_equal target.starttime, r.starttime
    assert_equal target.endtime, r.endtime
    assert_equal target.name, r.name
    assert_equal target.participants, r.participants
    assert_not target.published
  end

  test '.sync_from_redis creates a recording on process_ended' do
    event = {
      header: {
        timestamp: 5161997873,
        name: "process_ended",
        current_time: 1542719593,
        version: "0.0.1"
      }, payload: {
        workflow: "presentation",
        success: true,
        step_time: 557,
        external_meeting_id: "Not Fred's Room",
        record_id: "a0fcb226a234fccc45a9417f8d7c871792e25e1d-1542719370284",
        meeting_id: "a0fcb226a234fccc45a9417f8d7c871792e25e1d-1542719370284"
      }
    }.deep_stringify_keys

    assert_difference "Recording.count" do
      Recording.sync_from_redis(event)
    end
    target = Recording.find_by(record_id: "a0fcb226a234fccc45a9417f8d7c871792e25e1d-1542719370284")
    assert_equal target.meeting_id, "Not Fred's Room"
    assert_equal target.state, "processed"
    assert_nil target.starttime
    assert_nil target.endtime
    assert_nil target.name
    assert_nil target.participants
    assert_not target.published
  end

  test '.sync_from_redis updates an existent recording on process_ended' do
    r = recordings(:fred_room)
    event = {
      header: {
        timestamp: 5161997873,
        name: "process_ended",
        current_time: 1542719593,
        version: "0.0.1"
      }, payload: {
        workflow: "presentation",
        success: true,
        step_time: 557,
        external_meeting_id: "Not Fred's Room",
        record_id: r.record_id,
        meeting_id: r.record_id
      }
    }.deep_stringify_keys

    assert_difference "Recording.count", 0 do
      Recording.sync_from_redis(event)
    end
    target = Recording.find_by(record_id: r.record_id)
    assert_equal target.meeting_id, "Not Fred's Room"
    assert_equal target.state, "processed"
    assert_equal target.starttime, r.starttime
    assert_equal target.endtime, r.endtime
    assert_equal target.name, r.name
    assert_equal target.participants, r.participants
    assert_not target.published
  end

  test '.sync_from_redis creates a recording on publish_started' do
    event = {
      header: {
        timestamp: 5161997873,
        name: "publish_started",
        current_time: 1542719593,
        version: "0.0.1"
      }, payload: {
        workflow: "presentation",
        external_meeting_id: "Not Fred's Room",
        record_id: "a0fcb226a234fccc45a9417f8d7c871792e25e1d-1542719370284",
        meeting_id: "a0fcb226a234fccc45a9417f8d7c871792e25e1d-1542719370284"
      }
    }.deep_stringify_keys

    assert_difference "Recording.count" do
      Recording.sync_from_redis(event)
    end
    target = Recording.find_by(record_id: "a0fcb226a234fccc45a9417f8d7c871792e25e1d-1542719370284")
    assert_equal target.meeting_id, "Not Fred's Room"
    assert_equal target.state, "processed"
    assert_nil target.starttime
    assert_nil target.endtime
    assert_nil target.name
    assert_nil target.participants
    assert_not target.published
  end

  test '.sync_from_redis updates an existent recording on publish_started' do
    r = recordings(:fred_room)
    event = {
      header: {
        timestamp: 5161997873,
        name: "publish_started",
        current_time: 1542719593,
        version: "0.0.1"
      }, payload: {
        success: true,
        step_time: 557,
        workflow: "presentation",
        external_meeting_id: "Not Fred's Room",
        record_id: r.record_id,
        meeting_id: r.record_id
      }
    }.deep_stringify_keys

    assert_difference "Recording.count", 0 do
      Recording.sync_from_redis(event)
    end
    target = Recording.find_by(record_id: r.record_id)
    assert_equal target.meeting_id, "Not Fred's Room"
    assert_equal target.state, "processed"
    assert_equal target.starttime, r.starttime
    assert_equal target.endtime, r.endtime
    assert_equal target.name, r.name
    assert_equal target.participants, r.participants
    assert_not target.published
  end

  test '.sync_from_redis creates a recording on publish_ended' do
    event = {
      header: {
        timestamp: 5161997873,
        name: "publish_ended",
        current_time: 1542719593,
        version: "0.0.1"
      }, payload: {
        success: true,
        step_time: 1793,
        playback: [
          {
            format: 'presentation',
            link: 'https://dev90.bigbluebutton.org/playback/presentation/2.0/playback.html?meetingId=a0fcb226a234fccc45a9417f8d7c871792e25e1d-1542719370284',
            processing_time: 5999,
            duration: 29185,
            extensions: {
              preview: {
                images: {
                  image: [
                    'https://dev90.bigbluebutton.org/presentation/a0fcb226a234fccc45a9417f8d7c871792e25e1d-1542719370284/presentation/d2d9a672040fbde2a47a10bf6c37b6a4b5ae187f-1542719370905/thumbnails/thumb-1.png',
                    'https://dev90.bigbluebutton.org/presentation/a0fcb226a234fccc45a9417f8d7c871792e25e1d-1542719370284/presentation/d2d9a672040fbde2a47a10bf6c37b6a4b5ae187f-1542719370905/thumbnails/thumb-2.png'
                  ]
                }
              }
            },
            size: 321302
          }, {
            format: 'podcast',
            link: 'https://dev90.bigbluebutton.org/playback/podcast/2.0/playback.html?meetingId=a0fcb226a234fccc45a9417f8d7c871792e25e1d-1542719370284',
            processing_time: 9919,
            duration: 22999,
            extensions: {
              preview: {
                images: {
                  image: 'https://dev90.bigbluebutton.org/podcast/a0fcb226a234fccc45a9417f8d7c871792e25e1d-1542719370284/podcast/d2d9a672040fbde2a47a10bf6c37b6a4b5ae187f-1542719370905/thumbnails/thumb-1.png'
                }
              }
            },
            size: 28892
          }
        ], metadata: {
          meetingName: "Certainly not Fred's Room",
          isBreakout: "false",
          meetingId: "Not Fred's Room"
        },
        raw_size: 8166022,
        start_time: 1542719370284,
        end_time: 1542719443220,
        workflow: "presentation",
        external_meeting_id: "Not Fred's Room",
        record_id: "a0fcb226a234fccc45a9417f8d7c871792e25e1d-1542719370284",
        meeting_id: "a0fcb226a234fccc45a9417f8d7c871792e25e1d-1542719370284"
      }
    }.deep_stringify_keys

    assert_difference "Recording.count" do
      assert_difference "Metadatum.count", 3 do
        assert_difference "PlaybackFormat.count", 2 do
          assert_difference "Thumbnail.count", 3 do
            Recording.sync_from_redis(event)
          end
        end
      end
    end

    target = Recording.find_by(record_id: "a0fcb226a234fccc45a9417f8d7c871792e25e1d-1542719370284")
    assert_equal target.meeting_id, event["payload"]["external_meeting_id"]
    assert_equal target.state, "published"
    assert_equal target.starttime, Time.at(event["payload"]["start_time"]/1000)
    assert_equal target.endtime, Time.at(event["payload"]["end_time"]/1000)
    assert_equal target.name, event["payload"]["metadata"]["meetingName"]
    assert_nil target.participants
    assert target.published

    assert_equal target.metadata[0].key, "meetingName"
    assert_equal target.metadata[0].value, "Certainly not Fred's Room"
    assert_equal target.metadata[1].key, "isBreakout"
    assert_equal target.metadata[1].value, "false"
    assert_equal target.metadata[2].key, "meetingId"
    assert_equal target.metadata[2].value, "Not Fred's Room"

    assert_equal target.playback_formats[0].format, "presentation"
    assert_equal target.playback_formats[0].url, "/playback/presentation/2.0/playback.html?meetingId=a0fcb226a234fccc45a9417f8d7c871792e25e1d-1542719370284"
    assert_equal target.playback_formats[0].length, 29185
    assert_equal target.playback_formats[0].processing_time, 5999
    assert_equal target.playback_formats[0].thumbnails[0].url, "/presentation/a0fcb226a234fccc45a9417f8d7c871792e25e1d-1542719370284/presentation/d2d9a672040fbde2a47a10bf6c37b6a4b5ae187f-1542719370905/thumbnails/thumb-1.png"
    assert_equal target.playback_formats[0].thumbnails[1].url, "/presentation/a0fcb226a234fccc45a9417f8d7c871792e25e1d-1542719370284/presentation/d2d9a672040fbde2a47a10bf6c37b6a4b5ae187f-1542719370905/thumbnails/thumb-2.png"

    assert_equal target.playback_formats[1].format, "podcast"
    assert_equal target.playback_formats[1].url, "/playback/podcast/2.0/playback.html?meetingId=a0fcb226a234fccc45a9417f8d7c871792e25e1d-1542719370284"
    assert_equal target.playback_formats[1].length, 22999
    assert_equal target.playback_formats[1].processing_time, 9919
    assert_equal target.playback_formats[1].thumbnails[0].url, "/podcast/a0fcb226a234fccc45a9417f8d7c871792e25e1d-1542719370284/podcast/d2d9a672040fbde2a47a10bf6c37b6a4b5ae187f-1542719370905/thumbnails/thumb-1.png"
  end

  # test '.sync_from_redis updates an existent recording and all associated models on publish_ended'
end
