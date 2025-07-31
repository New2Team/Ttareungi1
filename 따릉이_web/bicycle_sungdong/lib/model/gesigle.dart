
class Gesigle {
  final int? id; // 자동 증가 id
  final String title; // 제목
  final String content; // 내용 
  final String datetime; // 가게 이름

  

  Gesigle({
    this.id,
    required this.title,
    required this.content,
    required this.datetime,
  });

//Map = > Gesigle 로 변환(DB 조회)
//데이타를 이런식으로 받아서 사용을 하겠다.
factory Gesigle.fromMap(Map<String,dynamic>map){
  return Gesigle(
    id : map['id'] as  int?,
    title: map['title'] ?? "", 
    content: map['content']?? "", 
    datetime: map['datetime']??"", 
    );
}
//Gesigle - > Map(DB저장시)
//값을 넣을 떄도 키 값을 정의해서 보내줌 
Map<String,dynamic> toMap(){
  return {
    'id' : id,
    'title' : title,
    'content' : content,
    'datetime' : datetime,
  };
}

}