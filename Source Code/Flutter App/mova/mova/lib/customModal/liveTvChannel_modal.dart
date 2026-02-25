// ignore_for_file: camel_case_types, file_names

class liveTvChannel{
  String name;
  String logo;
  String url;

  liveTvChannel({required this.name,required this.url,required this.logo});
}

List<liveTvChannel> liveTvChannelList = [
  liveTvChannel(name: "Luxury", url: "http://nano.teleservice.su:8080/hls/luxury.m3u8", logo: "https://i.imgur.com/nobZa5l.png"),
  liveTvChannel(name: "Safari TV", url: "https://j78dp346yq5r-hls-live.5centscdn.com/safari/live.stream/playlist.m3u8", logo: "https://i.imgur.com/dSOfYyh.png"),
  liveTvChannel(name: "NDTV India", url: "https://ndtvindiaelemarchana.akamaized.net/hls/live/2003679/ndtvindia/master.m3u8", logo: "https://i.imgur.com/PyDjUZB.png"),
  liveTvChannel(name: "9XM", url: "https://d2q8p4pe5spbak.cloudfront.net/bpk-tv/9XM/9XM.isml/index.m3u8", logo: "https://i.imgur.com/F17QtN2.png"),
  liveTvChannel(name: "TV9", url: "https://live-sg1.global.ssl.fastly.net/live-hls/tonton4.m3u8", logo: "https://i.imgur.com/Krh1F8d.png"),
];