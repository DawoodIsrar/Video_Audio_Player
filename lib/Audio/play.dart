import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:flutter/cupertino.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Play extends StatefulWidget {
  Play({Key? key, required this.song, required this.audioPlayer})
      : super(key: key);
  final SongModel song;
  final AudioPlayer audioPlayer;
  @override
  State<Play> createState() => _PlayState();
}

class _PlayState extends State<Play> {
  Duration d = Duration();
  Duration p = Duration();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    playSong();
  }

  bool isPlayng = false;
  playSong() {
    try {
      widget.audioPlayer
          .setAudioSource(AudioSource.uri(Uri.parse(widget.song.uri!),
           tag: MediaItem(
    // Specify a unique ID for each media item:
    id: '${widget.song.id}',
    // Metadata to display in the notification:
    album: "${widget.song.album}",
    title: "${widget.song.displayNameWOExt}",
    artUri: Uri.parse('${widget.song.artistId}}'),
    artist: "${widget.song.artist}",
    
  ),
          ));
      widget.audioPlayer.play();
      isPlayng = true;
    } on Exception {
      log("error parsing song");
    }
    widget.audioPlayer.durationStream.listen((duration) {
      setState(() {
        d = duration!;
      });
    });
    widget.audioPlayer.positionStream.listen((pos) {
      setState(() {
        p = pos;
      });
    });
  }

  void SliderChange(int seconds) {
    Duration d = Duration(seconds: seconds);
    widget.audioPlayer.seek(d);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("BitsAudio Player"),
          backgroundColor: Colors.lightBlue[200],
         
        ),
      body: SafeArea(
          child: Stack(
            children:[

              Container(
                width: double.infinity,
                height: double.infinity,
                child: QueryArtworkWidget(

                  id: widget.song.id,
                  type: ArtworkType.AUDIO,
                  nullArtworkWidget: Icon(Icons.music_note,size: 35,),
                  keepOldArtwork: true,

                ),
              ),

              Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: <Color>[
                          Color(0xFFFFFF),
                          Color(0xff81D4F4),
              ], // Gr)),
                    )),
                width: double.infinity,
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [

                    Center(
                      child: CircleAvatar(
                        backgroundColor: Colors.black26,
                        radius: 150,

                        child: Column(
                          children: [
                           Container(
                             padding: EdgeInsets.only(top: 10),
                               width: 150,
                               height: 150,
                               child: QueryArtworkWidget(id: widget.song.id, type: ArtworkType.AUDIO, keepOldArtwork: true,)),
                            SizedBox(
                              height: 10,
                            ),
                           Text(
                                widget.song.displayNameWOExt,
                                overflow: TextOverflow.fade,
                                maxLines: 1,
                                style: TextStyle(fontSize: 20,color: Colors.white),
                              ),

                            SizedBox(
                              height: 10,
                            ),
                            Text(
                                widget.song.artist.toString(),
                                overflow: TextOverflow.fade,
                                maxLines: 1,
                                style: TextStyle(fontSize: 15,color: Colors.white),
                              ),

                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        Text(p.toString().split(".")[0]),
                        Expanded(
                            child: Slider(
                              activeColor: Colors.black54,
                                min: const Duration(microseconds: 0)
                                    .inSeconds
                                    .toDouble(),
                                value: p.inSeconds.toDouble(),
                                max: d.inSeconds.toDouble(),
                                onChanged: (value) {
                                  setState(() {
                                    SliderChange(value.toInt());
                                    value = value;
                                  });
                                })),
                        Text(d.toString().split(".")[0]),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                            onPressed: () {
                            setState(() {

                              if(widget.audioPlayer.hasPrevious){
                                widget.audioPlayer.seekToPrevious();
                              }
                            });

                            },
                            icon: Icon(Icons.skip_previous, size: 50)),
                        SizedBox(
                          height: 10,
                        ),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                if (isPlayng) {
                                  widget.audioPlayer.pause();
                                } else {
                                  widget.audioPlayer.play();
                                }
                                isPlayng = !isPlayng;
                              });
                            },
                            icon: Icon(
                              isPlayng ? Icons.pause : Icons.play_arrow,
                              size: 50,
                            )),
                        SizedBox(
                          height: 10,
                        ),
                        IconButton(
                            onPressed: () {

                             setState(() {
                               if(widget.audioPlayer.hasNext){
                                 widget.audioPlayer.seekToNext();
                               }
                             });

                            },
                            icon: Icon(Icons.skip_next, size: 50)),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    )
                  ],
                )),

            ]
          )),
    );
  }
}
