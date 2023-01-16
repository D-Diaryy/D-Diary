

class GameClass {
  final String hiddenCardpath = 'images/coverCard.jpg';
  List<String>? gameImg;

  List cards_list = [
    "images/circleCard.jpg",
    "images/diamondCard.jpg",
    "images/heartCard.jpg",
    "images/starCard.jpg",
    "images/squareCard.jpg",
    "images/triangleCard.jpg",
  ];

  List<Map<int, String>> matchCheck = [];

  final int cardCount = 12;

  initCard(List? imgList){
    print(imgList!.length);
    if(imgList.length > 6){
      cards_list = [];
      imgList.shuffle();
      for(int index = 0;index < 6;index++){
        cards_list.add(imgList[index]);
      }
      //cards_list = imgList!;
      cards_list += cards_list;
    }else if(imgList.length == 0){
      cards_list += cards_list;
    }else if(imgList.length < 6){
      imgList.forEach((element) {
        cards_list.removeLast();
      });
      cards_list += imgList;
      cards_list += cards_list;
    }
  }

  void initGame(){
    gameImg = List.generate(cardCount, (index) => hiddenCardpath);
    cards_list.shuffle();
  }
}