import 'package:donggu_bat/widgets/widget_bottombar.dart';
import 'package:flutter/material.dart';
import '../widgets/widget_appbar.dart';
import '../widgets/widget_bottombar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../program/rent.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import '../program/rent.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ProgramApply extends StatefulWidget {
  @override
  State<ProgramApply> createState() => _ProgramApplyState();
}

class _ProgramApplyState extends State<ProgramApply> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  //1125 hys 추가 - uid 및 DB에서 현재 로그인한 사용자 정보 불러오기
  String? current_uid = FirebaseAuth.instance.currentUser?.uid; //사용자 uid
  String? current_email = FirebaseAuth.instance.currentUser?.email; //사용자 이메일
  String? current_name =
      FirebaseAuth.instance.currentUser?.displayName; //사용자 이름
  String? current_photo = FirebaseAuth.instance.currentUser
      ?.photoURL; //사용자 프로필 사진 주소(기본 설정 : 'assets/profile.png')
  String? current_address; //사용자 주소
  String? current_recommandlist; //사용자 선호 프로그램 목록
  String selectedLocation = '';
  String? recommend_img_url;
  String? recommend_url;
  String? recommend_text;
  List<String> program_location = [];
  late Set<Map<String, String>> programDayExist = {};
  Future<void> fetchData() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection("programData")
        .doc("0")
        .get();

    if (snapshot.exists) {
      Map<String, dynamic> recommend = snapshot.data() as Map<String, dynamic>;
      recommend_img_url = recommend['이미지'];
      recommend_url = recommend['URL'];
      recommend_text = recommend["프로그램 소개"];
      // Now update the recommended list
      print(recommend_img_url);
    } else {
      print("error : 문서가 존재하지 않습니다!");
    }
  }

  //위에서 정의한 current 유저 정보 변수들에 DB에서 문서 읽어와 값 할당
  void set_current() async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('user')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get();

    // 문서가 존재하는지 확인
    if (documentSnapshot.exists) {
      // 문서의 데이터 가져오기
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
      current_address = data['address'];
      current_recommandlist = data['recommend_list'];
    } else {
      print("error : 문서가 존재하지 않습니다!");
    }
  }

  void set_program() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('programData')
          .where('일정', isNotEqualTo: "")
          .get();

      List<QueryDocumentSnapshot> documents = querySnapshot.docs;

      for (QueryDocumentSnapshot document in documents) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;

        // 가져온 데이터 활용 예시 "이름", "일정", "카테고리"
        String scheduleName = data['이름'];
        String scheduleDate = data['일정'];
        String scheduleCat = data['카테고리'];

        programDayExist.add({
          'name': scheduleName,
          'time': scheduleDate,
          'location': scheduleCat
        });
        String newValue = scheduleCat; // 새로 추가하려는 값

        // 리스트에 값이 이미 있는지 확인
        if (!program_location.contains(newValue)) {
          // 리스트에 추가
          program_location.add(newValue);
        }
        // 원하는 작업 수행
        // print('문서 ID: $documentId, 일정: $scheduleData');
        // 이 부분에서 가져온 데이터를 저장하거나 활용할 수 있습니다.
      }
      //print(programDayExist);
      print(program_location);
    } catch (error) {
      print('데이터 가져오기 실패: $error');
    }
  }

  //hys 1125 추가, 자동으로 currunt user 값들 세팅하기 위한 함수
  @override
  void initState() {
    super.initState();
    set_current();
    fetchData();
    set_program();
  }

  List<Map<String, String>> postscript = [
    {
      'nickname': '왕십리생명체2',
      'content': '심리지원 클래스 참여했는데 만족스러웠습니다. 좋은 수업 감사합니다 🙏',
      'photo': '후기.png',
      'hashtag1': '#만족스러워요',
      'hashtag2': '#도움돼요',
      'hashtag3': '#심리상담'
    },
    {
      'nickname': '반짝반짝',
      'content': '타르트를 만들었는데 아주 맛있었어요!',
      'photo': '후기1.png',
      'hashtag1': '#재밌어요',
      'hashtag2': '#만족스러워요',
      'hashtag3': '#요리수업'
    },
  ];

  int _selectedIndex = 0;
  int _currentMonthIndex = 0;
  int _rentIndex = 0;
  String selectedLocation1 = '';
  String selectedLocation2 = '';
  String? dropdownValue1;
  String? dropdownValue2;

  List<String> _monthlyImages = [
    '1.png',
    '2.png',
    '3.png',
    '4.jpg',
    '5.png',
    'image.png',
    'rainbow.jpg',
    'SNS 인증샷.jpg',
    'user_progile.jpg',
    'vertical_symbol.jpg',
    '세이프 라이딩.jpg',
    '플로깅플레져.jpg'
  ];

  List<Map<String, String>> month = [
    {
      'photo': '1.png',
      'url': 'https://sd1in.net/product/stationery-collection'
    },
    {'photo': '2.png', 'url': 'https://sd1in.net/product/1inseoul'},
    {'photo': '3.png', 'url': 'https://sd1in.net/product/living-woodworking'},
    {'photo': '4.png', 'url': 'https://sd1in.net/product/1inseoul'},
    {'photo': '5.png', 'url': 'https://sd1in.net/product/living-woodworking'},
    {'photo': 'image.png', 'url': 'https://sd1in.net/product/1inseoul'},
    {'photo': '1.png', 'url': 'https://sd1in.net/product/living-woodworking'},
    {'photo': '2.png', 'url': 'https://sd1in.net/product/1inseoul'},
    {'photo': '3.png', 'url': 'https://sd1in.net/product/living-woodworking'},
    {'photo': '4.png', 'url': 'https://sd1in.net/product/1inseoul'},
    {'photo': '5.png', 'url': 'https://sd1in.net/product/living-woodworking'},
    {'photo': 'image.png', 'url': 'https://sd1in.net/product/1inseoul'},
  ];

  List<String> programurl = [
    'https://sd1in.net/product/stationery-collection',
    'https://sd1in.net/product/1inseoul',
    'https://sd1in.net/product/living-woodworking',
    'https://sd1in.net/product/free-drawing',
    'https://sd1in.net/product/personal-consultation',
    'https://sd1in.net/product/stationery-collection',
    'https://sd1in.net/product/1inseoul',
    'https://sd1in.net/product/living-woodworking',
    'https://sd1in.net/product/free-drawing',
    'https://sd1in.net/product/personal-consultation',
    'https://sd1in.net/product/free-drawing',
    'https://sd1in.net/product/personal-consultation'
  ];

  List<Map<String, String>> recommended = [
    {
      'location': '추천.png',
      'url': 'https://sd1in.net/product/personal-consultation',
      'text': "내담자는 미술치료에서의 공감으로 자기대상과의 관계에서 형성된 다양한 사고와 감정, 욕구를 자유롭게 표현할 수 있으며, 자기대상이 자신의 인생에 미친 영향을 탐색할 수 있게 됩니다."
          "\n 치료자와 미술이라는 환경 속에서 내담자는 창조적이면서 공감적인 삶을 경험하게 되고, 자기의 발달과 회복이 촉진되는 것입니다."
    }
  ];

  List<Map<String, String>> rent = [
    {'name': '1층 다목적실', 'time': '10:00 - 12:00', 'location': '성동구 동1'},
    {'name': '3층 소회의실', 'time': '10:00 - 12:00', 'location': '성동구 동1'},
    {'name': '4층 다목적실', 'time': '13:00 - 15:00', 'location': '성동구 동1'},
    {'name': '5층 공유부엌', 'time': '10:00 - 12:00', 'location': '성동구 동1'},
    {'name': '3층 작은도서관', 'time': '10:00 - 12:00', 'location': '성동구 동2'},
    {'name': '3층 자치사랑방', 'time': '13:00 - 15:00', 'location': '성동구 동2'},
    {'name': '5층 공유부엌', 'time': '10:00 - 12:00', 'location': '성동구 동2'},
  ];

  List<String> locations = ['성동구 동1', '성동구 동2', '성동구 동3'];
  List<String> name = ['소회의실', '자치사랑방', '공유부엌', '작은도서관', '다목적실'];
  String? dropdownValue;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        // 상단바, 하단바, 메인화면으로 나눌때 주로 사용
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(55.0), // AppBar의 원하는 높이로 설정
          child: WidgetAppBar(title: "프로그램 신청"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsetsDirectional.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Align(
                  // 아이디 텍스트
                  alignment: AlignmentDirectional(-1.00, 0.00),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(5, 5, 0, 6),
                    child: Text(
                      '추천 프로그램',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                // 추천할 프로그램의 설명 팝업화면
                InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                            "프로그램 안내",
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                'assets/${recommended[0]['location']}',
                                fit: BoxFit.contain,
                                height: 250,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(15, 25, 15, 25),
                                child: Container(
                                  height: 200,
                                  child: SingleChildScrollView(
                                    child: Text('${recommended[0]['text']}'),
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  String? url = recommended[0]['url'];
                                  if (url != null) {
                                    launch(url);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  side: BorderSide(
                                      color: Colors.black38, width: 1.0),
                                  primary:
                                      const Color.fromARGB(255, 44, 96, 68),
                                  fixedSize: Size(150, 40),
                                ),
                                child: Text(
                                  "접수 바로가기",
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: Image.asset(
                    'assets/${recommended[0]['location']}',
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                  ),
                ),

                // 프로그램 신청
                Align(
                  alignment: AlignmentDirectional(-1.00, 0.00),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(5, 25, 0, 7),
                    child: Text(
                      '프로그램 신청',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 0, 5, 10),
                  child: Row(
                    children: [
                      Icon(Icons.location_pin),
                      SizedBox(width: 20),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: DropdownButton<String>(
                          value: dropdownValue,
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownValue = newValue; // null 체크 및 대체값 설정
                              selectedLocation = newValue ?? ''; // 선택된 위치 업데이트

                              // 선택한 위치에 따라 필요한 동작 수행
                              // 예를 들어, 해당 위치에 대한 정보를 가져오거나 화면을 업데이트할 수 있습니다.
                            });
                          },
                          items: program_location
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value), // 위치 이름
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 250,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black38, width: 1.0),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: programDayExist.length,
                      itemBuilder: (BuildContext context, int index) {
                        Map<String, String> programDay =
                            programDayExist.elementAt(index);
                        if (selectedLocation.isEmpty ||
                            programDay['location'] == selectedLocation) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        programDay['name'] ?? ' ',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        '${programDay['time']}', // 대관 시간
                                      ),
                                    ],
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => rentPage(),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.white,
                                    onPrimary: Colors.black,
                                    side: BorderSide(color: Colors.grey),
                                  ),
                                  child: Text('신청하기'),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return SizedBox.shrink();
                        }
                      },
                    ),
                  ),
                ),
                // 대관 신청
                Align(
                  alignment: AlignmentDirectional(-1.00, 0.00),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(5, 25, 0, 7),
                    child: Text(
                      '대관 신청',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 0, 5, 10),
                  child: Row(
                    children: [
                      Icon(
                        Icons.location_pin,
                        size: 35,
                      ),
                      SizedBox(width: 10),
                      // Container(padding: EdgeInsets.all(10), child: Text('위치')),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black38, width: 1.0),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButton<String>(
                          value: dropdownValue2,
                          onChanged: (String? newValue2) {
                            setState(() {
                              dropdownValue2 = newValue2!;
                              selectedLocation2 = newValue2 ?? '';
                            });
                          },
                          items: locations
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 250,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black38, width: 1.0),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: rent.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (selectedLocation2.isEmpty ||
                            rent[index]['location'] == selectedLocation2) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      // 대관 장소
                                      Text(
                                        rent[index]['name'] ?? '대관 위치 이름 없음',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Divider(
                                        thickness: 1,
                                        color: Colors.black38,
                                      ),
                                      Spacer(), // 간격을 일정하게 설정하기 위해 Spacer 사용

                                      // 대관 시간
                                      Text(
                                        '${rent[index]['time']}',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      Spacer(), // 간격을 일정하게 설정하기 위해 Spacer 사용
                                    ],
                                  ),
                                ),

                                // 신청하기 버튼
                                Padding(
                                  padding: const EdgeInsets.only(top: 3),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => rentPage()),
                                      );
                                      // launch(
                                      //     'https://sd1in.net/program/application-for-rental');
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.white,
                                      onPrimary: Colors.black,
                                      side: BorderSide(color: Colors.grey),
                                    ),
                                    child: Text(
                                      '신청하기',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return SizedBox.shrink();
                        }
                      },
                    ),
                  ),
                ),

                // 오늘의 후기
                Align(
                  alignment: AlignmentDirectional(-1.00, 0.00),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(5, 20, 0, 5),
                    child: Text(
                      '오늘의 후기',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                Container(
                  child: CarouselSlider.builder(
                    itemCount: postscript.length,
                    itemBuilder: (BuildContext context, int index, _) {
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          side: BorderSide(color: Colors.grey, width: 1.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/프로필.png',
                                    width: 40,
                                    height: 40,
                                    fit: BoxFit.cover,
                                  ),
                                  SizedBox(width: 15),
                                  Text(
                                    postscript[index]['nickname'] ?? '',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 15),

                              // 리뷰 글
                              Text(
                                postscript[index]['content'] ?? '',
                                style: TextStyle(fontSize: 15),
                                // maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 5),

                              // 후기 사진
                              Image.asset(
                                  'assets/${postscript[index]['photo']}'),
                              SizedBox(height: 10),

                              // 해쉬태그
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  // borderRadius: BorderRadius.circular(20),
                                ),
                                padding: EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey[400],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        vertical: 2,
                                        horizontal: 8,
                                      ),
                                      // margin: EdgeInsets.only(right: 5),
                                      child: Text(
                                        postscript[index]['hashtag1'] ?? '',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey[400],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        vertical: 2,
                                        horizontal: 8,
                                      ),
                                      child: Text(
                                        postscript[index]['hashtag2'] ?? '',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey[400],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        vertical: 2,
                                        horizontal: 8,
                                      ),
                                      child: Text(
                                        postscript[index]['hashtag3'] ?? '',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    options: CarouselOptions(
                      height: 400.0,
                      enlargeCenterPage: true,
                      enableInfiniteScroll: false,
                      viewportFraction: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: WidgetBottomNavigationBar(
          selectedIndex: _selectedIndex,
          onItemTapped: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
    );
  }
}

void _openPage(String Url) async {
  if (await canLaunch(Url)) {
    await launch(Url);
  } else {
    throw 'Could not launch $Url';
  }
}
