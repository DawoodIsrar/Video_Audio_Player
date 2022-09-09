import 'package:bitslogicxplayer/Audio/play.dart';
import 'package:bitslogicxplayer/Video/folders.dart';
import 'package:bitslogicxplayer/newFile.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:file_picker/file_picker.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:just_audio/just_audio.dart';

class SongList extends StatefulWidget {
  SongList({Key? key}) : super(key: key);

  @override
  State<SongList> createState() => _SongListState();
}

class _SongListState extends State<SongList> {
  final audioQuery = new OnAudioQuery();
  final AudioPlayer audioPlayer = AudioPlayer();
  @override
  void initState() {
    // TODO: implement initState

    requestPermission();
  }

  requestPermission() {
    Permission.storage.request();
  }

  playSong(String? uri) {
    try {
      audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(uri.toString())));
      audioPlayer.play();
    } on Exception {
      log("error parsing song");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
        appBar: AppBar(
          title: Text("BitsAudio Player"),
          backgroundColor: Colors.lightBlue[200],
        ),
      
        body: FutureBuilder<List<SongModel>>(
            future: audioQuery.querySongs(
              sortType: null,
              orderType: OrderType.ASC_OR_SMALLER,
              uriType: UriType.EXTERNAL,
              ignoreCase: true,
            ),
            builder: (context, item) {
              if (item.data == null) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              return Container(
                
                  child: ListView.builder(
                      itemBuilder: (context, index) => Container(
                                   decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: <Color>[
                                           Color(0xC4A484),
                                      Color(0xFFFDD0),
                                      Color(0xFFFFED),
                                     
                                    ], // Gr)),
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: const [
                                    BoxShadow(
                                        blurRadius: 4.0,
                                        offset: Offset(-4, -4),
                                        color: Colors.white),
                                    BoxShadow(
                                        blurRadius: 4.0,
                                        offset: Offset(4, 4),
                                        color: Colors.black12),
                                  ]),
                                  child:  ListTile(
                                            leading:   QueryArtworkWidget(
                                            id: item.data![index].id,
                                            type: ArtworkType.AUDIO,
                                            artworkFit: BoxFit.cover,
                                            artworkScale: 10,
                                       
                                            
                                            
                                            nullArtworkWidget: Image.asset("assets/mr1.png"),
                                            ),
                                            title: Text(item.data![index].displayName,style: TextStyle(fontSize: 15),),
                                            
                                            onTap: (() {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => Play(
                                                          song: item.data![index],
                                                          audioPlayer: audioPlayer,
                                                        )),
                                              );
                                            }),
                                          
                                                
                                          ),
                                    
                                    
                                  
                                ),
                                itemCount: item.data!.length,
                  ));
                  
                              },
                              
                          ));
            }
  }

