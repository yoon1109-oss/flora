import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/flower.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'flora.db');

    return await openDatabase(
      path,
      version: 8,
      onCreate: _onCreate,
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 8) {
          await db.execute('''
            CREATE TABLE IF NOT EXISTS favorites (
              flower_id INTEGER PRIMARY KEY
            )
          ''');
        }
      },
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE seasons (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE flowers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        floriography TEXT NOT NULL,
        feature TEXT NOT NULL,
        review TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE flower_seasons (
        flower_id INTEGER NOT NULL,
        season_id INTEGER NOT NULL,
        PRIMARY KEY (flower_id, season_id),
        FOREIGN KEY (flower_id) REFERENCES flowers(id),
        FOREIGN KEY (season_id) REFERENCES seasons(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE flower_images (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        flower_id INTEGER NOT NULL,
        image_number INTEGER NOT NULL,
        image_path TEXT NOT NULL,
        FOREIGN KEY (flower_id) REFERENCES flowers(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE favorites (
        flower_id INTEGER PRIMARY KEY
      )
    ''');

    await _seedData(db);
  }

  Future<void> _seedData(Database db) async {
    await db.insert('seasons', {'id': 1, 'name': '봄'});
    await db.insert('seasons', {'id': 2, 'name': '여름'});
    await db.insert('seasons', {'id': 3, 'name': '가을'});
    await db.insert('seasons', {'id': 4, 'name': '겨울'});

    // [seasons, name, floriography, feature, review]
    final flowers = <List<dynamic>>[
      [[1,2,3,4], '자나 장미', '끝없는 사랑, 행복한 사랑', '분홍빛의 빈티지한 작은 송이들이 모여 있는 스프레이 장미.', '옥시랑 다음으로 자주 구매해요. 색감이 정말 예뻐서 신부들이 자주 선택하고 보관도 쉬워요.'],
      [[1,2,3,4], '콜롬비아 장미', '사랑, 기쁨', '송이가 크고 화형이 단단함', '수입 장미는 국산보다 얼굴이 훨씬 커서 메인 꽃으로 쓰기 정말 좋아요. 꽃잎이 단단해서 화병에서도 오래가고 존재감이 확실하답니다.'],
      [[1,2,3,4], '글로리아 장미', '기쁨', '화려한 그라데이션', '꽃잎 끝의 색감이 오묘하게 변하는 빈티지 장미의 대표 주자예요. 클래식하면서도 고급스러운 분위기를 낼 때 메인으로 쓰면 정말 예쁜 장미랍니다.'],
      [[1,2,3,4], '리시안셔스', '변치 않는 사랑', '꽃잎이 하늘거리고 연함', '꽃시장의 진정한 효자 아이템이에요. 어느 꽃과 섞어도 자연스럽게 어울리고 한 단만 사도 양이 풍성해서 가성비가 최고랍니다.'],
      [[1,2,4], '라넌큘러스', '매력, 매혹', '겹겹이 쌓인 꽃잎, 하노이 인기', '겨울부터 봄까지 꽃집의 주인공이죠. 겹겹이 쌓인 꽃잎이 피어날 때 정말 환상적이에요. 다만 줄기가 비어 있어서 꺾이기 쉬우니 조심해 주세요.'],
      [[1,2], '거베라', '신비, 수수께끼', '화려한 색감, 직선 줄기', '요즘은 실처럼 가느다란 파스타 거베라가 정말 유행이에요. 색감이 선명해서 한두 송이만 꽂아두어도 포인트 역할을 톡톡히 해준답니다.'],
      [[1,2,3,4], '카네이션', '모정, 사랑', '화형이 오래가고 단단함', '어버이날뿐만 아니라 평소에도 필러 소재로 자주 구매해요. 화형이 단단해서 베이스 잡기도 좋고, 요즘은 빈티지한 수입 색상들이 정말 예쁘게 나와요.'],
      [[1,2,3,4], '스프레이 카네이션', '순수한 사랑', '작은 송이가 여러 개', '한 줄기에 여러 송이의 작은 카네이션이 달려 있어 필러 소재로 쓰기 좋아요. 메인 꽃 사이사이를 빈틈없이 메워주면서 가성비도 챙길 수 있는 효자 소재예요.'],
      [[1], '아네모네', '기대, 기다림', '중앙 검은 심지가 매력적', '봄 시즌에만 볼 수 있는 독특한 분위기의 꽃이에요. 중앙의 검은 심지가 강렬해서 세련된 디자인을 할 때 꼭 넣게 되는 매력적인 아이예요.'],
      [[3,4], '다알리아', '당신의 사랑이 행복', '얼굴이 크고 기하학적 화형', '가을 웨딩 부케에서 빼놓을 수 없는 주인공이죠. 화형이 기하학적이고 화려해서 시선을 확 끌지만, 물을 많이 먹어서 관리가 조금 까다로운 편이에요.'],
      [[2,3], '수국', '진심, 변덕', '볼륨감이 엄청난 매스 플라워', '여름 행사나 선물용 꽃다발에 볼륨감을 줄 때 이만한 꽃이 없어요. 이름처럼 물을 정말 좋아하니까 물 올리기에 신경을 많이 써주셔야 한답니다.'],
      [[1,2], '델피늄', '당신을 행복하게', '독보적인 파스텔톤 하늘색', '자연스러운 하늘색을 내고 싶을 때 대체할 꽃이 없어서 꼭 구매해요. 미니 델피늄은 하늘거리는 느낌이 좋고, 대형 델피늄은 웅장한 느낌을 준답니다.'],
      [[1,2], '작약', '수줍음, 부끄러움', '꽃의 여왕, 개화 전후 극적임', '봄과 초여름 사이 아주 짧게 만날 수 있는 귀한 꽃이죠. 몽우리일 때 사와서 활짝 피어나는 과정을 보면 왜 \'꽃의 여왕\'인지 바로 알 수 있을 거예요.'],
      [[1], '헬레보루스', '불안 진정', '고급스럽고 차분한 빈티지 톤', '가격대가 조금 높은 편이지만, 특유의 빈티지하고 차분한 색감 때문에 포기할 수 없어요. 고급스러운 느낌을 내고 싶을 때 포인트로 사용해 보세요.'],
      [[1,2,3,4], '카라', '순수, 열정', '매끈하고 우아한 곡선미', '신부님들의 부케 선호도 1순위 꽃이에요. 줄기의 매끈한 곡선미를 살려서 꽃병에 길게 꽂아두기만 해도 공간이 순식간에 우아해진답니다.'],
      [[1,2,3,4], '백합', '순결', '향이 강하고 큼', '존재감이 압도적이고 향기가 정말 멀리까지 퍼져요. 한두 송이만 피어도 공간 전체를 향기로 채울 수 있어서 선물용으로 꾸준히 사랑받는 스테디셀러예요.'],
      [[1], '튤립', '사랑의 고백', '심플하고 세련된 형태', '봄이면 모든 사람이 찾는 꽃이죠. 온도에 따라 꽃잎이 열리고 닫히는 움직임이 재미있고, 한 송이만 툭 꽂아둬도 공간이 살아나는 마법 같은 꽃이에요.'],
      [[1], '프리지아', '당신의 시작 응원', '진한 향기', '졸업과 입학 시즌의 상징 같은 꽃이에요. 노란 색감도 예쁘지만 향기가 정말 독보적이라 선물 받는 분들이 가장 좋아하는 꽃 중 하나랍니다.'],
      [[1,2,3,4], '라그라스', '당신의 친절', '보들보들한 질감', '강아지풀을 닮아서 너무 귀여워요. 여러 가지 색상으로 염색된 프리저브드가 많아서 아이들 꽃다발이나 미니 소품용으로 인기가 정말 좋답니다.'],
      [[1,2,3,4], '안개꽃', '맑은 마음', '사계절 필수 필러 소재', '요즘은 염색 안개꽃도 다양해서 활용도가 정말 높아요. 메인 꽃 사이사이에 구름처럼 넣어주면 꽃다발이 훨씬 풍성해 보이고, 드라이플라워로도 딱이에요.'],
      [[1,2,3,4], '왁스플라워', '변하지 않는 사랑', '잎에서 상큼한 향기 남', '꽃잎이 왁스를 칠한 듯 매끈하고 탄탄해서 내구성이 정말 좋아요. 잎을 만지면 상큼한 레몬 향이 나서 작업할 때 기분까지 좋아지는 꽃이랍니다.'],
      [[1,4], '스토크', '영원한 아름다움', '향기 진하고 볼륨감 좋음', '가성비 있게 풍성한 느낌을 내고 싶을 때 자주 구매해요. 향기가 정말 진해서 가게에 두면 향긋함이 가득해지고, 위로 길쭉한 형태라 높이감 주기도 좋답니다.'],
      [[1,2], '매트리칼리아', '인내', '작은 계란꽃 모양', '들꽃 같은 자연스러운 무드를 낼 때 필수적인 아이예요. 작은 계란꽃 같은 모양이 너무 귀여워서 신부 부케나 카페 인테리어용으로 인기가 정말 많아요.'],
      [[1,2], '아스틸베', '기약 없는 사랑', '깃털 같은 질감', '보들보들한 깃털 같은 질감이 포인트 소재로 최고예요. 웨딩 부케에 한두 줄기만 섞어줘도 훨씬 고급스럽고 몽환적인 분위기를 연출할 수 있답니다.'],
      [[1,2,3,4], '스카비오사', '이루어질 수 없는 사랑', '하늘거리는 춤추는 줄기', '줄기가 아주 얇고 자유롭게 휘어 있어서 리듬감을 줄 때 자주 써요. 바람에 흔들리는 꽃밭 같은 느낌을 내고 싶다면 꼭 구매해야 하는 꽃이랍니다.'],
      [[1], '미모사', '부끄러움', '노란 구슬 같은 형태', '봄이 오면 꽃시장에서 가장 먼저 찾는 소재 중 하나예요. 동글동글한 노란 꽃송이가 너무 사랑스러워서 리스를 만들면 정말 예쁘고 봄 느낌이 물씬 난답니다.'],
      [[1], '조팝나무', '선언', '하얀 꽃눈 같은 라인', '봄에만 만날 수 있는 하얀 눈꽃 같은 소재예요. 가느다란 가지에 하얀 꽃들이 다닥다닥 붙어 있어서 화병에 꽂아두면 집안 분위기가 금방 화사해져요.'],
      [[1,2], '공조팝', '노력', '동글동글 뭉쳐 피는 꽃', '조팝나무보다 꽃송이가 뭉쳐 있어서 더 볼륨감이 느껴져요. 꽃다발 뒷부분에 베이스로 넣어주면 전체적인 모양을 잡기가 훨씬 수월해진답니다.'],
      [[1], '냉이초', '모든 것을 드림', '들꽃 느낌의 필러 소재', '우리가 흔히 보는 냉이꽃이지만 꽃시장에서 만나는 아이는 더 풍성해요. 자연스러운 가든 스타일 디자인을 할 때 공기감을 불어넣어 주는 필수 소재예요.'],
      [[1,2], '아미초', '우아한 자태', '레이스 같은 화형', '레이스처럼 섬세하고 가벼운 화형이 특징이에요. 메인 꽃 사이사이에 넣으면 꽃다발에 우아한 분위기를 더해주고, 전체적으로 부드러운 느낌을 완성해 준답니다.'],
      [[1,2,3,4], '옥시펜탈륨', '날카로운 자태', '파란색 작은 꽃, 진 나옴', '푸른색 꽃이 드문데, 옥시는 색감이 정말 예뻐서 포인트로 자주 구매해요. 줄기를 자르면 끈적한 흰 진이 나오니까 작업 후에 가위와 손을 꼭 닦아주세요.'],
      [[3,4], '별소국', '굳은 마음', '작고 단단한 소국', '꽃잎이 단단해서 수명이 정말 길어요. 가을철에 저렴하고 푸짐하게 구매할 수 있어서 실속 있고, 화병에 꽂아두면 이 주일 이상은 거뜬히 볼 수 있답니다.'],
      [[1,4], '설유화', '애교', '가늘고 긴 라인 소재', '나뭇가지에 팝콘 같은 하얀 꽃이 피어서 곡선 라인을 살리기에 너무 좋아요. 동양적인 느낌을 내거나 세련된 공간 장식을 할 때 자주 선택한답니다.'],
      [[1,2,3,4], '금어초', '욕망', '수직으로 뻗은 형태', '위로 길게 뻗는 형태라 높이감이 있는 화병 꽂이나 행사 장식에 필수예요. 아래부터 차례대로 피어올라가서 오랫동안 감상할 수 있다는 장점이 있어요.'],
      [[2,3], '글라디올러스', '밀회', '키가 크고 화려함', '꽃송이가 큼직하고 키가 아주 커서 대형 장식이나 제단 장식에 주로 써요. 강렬한 색감이 많아서 화려한 분위기를 연출하고 싶을 때 추천드려요.'],
      [[2,3], '목수국', '냉정', '나무 형태의 수국', '일반 수국보다 줄기가 단단하고 나무 같은 느낌이에요. 가을이 되면 빈티지하게 색이 변하는데, 그 모습이 너무 멋스러워서 드라이플라워 소재로도 인기가 많아요.'],
      [[3], '등골나물', '주저', '몽글몽글한 질감', '가을 느낌을 물씬 풍기는 소재예요. 몽글몽글한 작은 꽃들이 뭉쳐 있어서 빈 공간을 채우기 좋고, 차분한 무드를 연출할 때 섞어주면 정말 세련되어 보여요.'],
      [[4], '심비디움', '화려함', '고급 서양란', '겨울에 주로 나오는 고급스러운 난 종류예요. 꽃이 아주 단단하고 수명이 길어서 격식 있는 선물이나 명절용으로 자주 구매하는 인기 품목이랍니다.'],
      [[1,2,3,4], '반다', '애정의 표시', '보라색 체크무늬', '보라색 체크무늬가 있는 수입 난인데, 존재감이 정말 압도적이에요. 고급 부케나 포인트 장식에 한두 송이만 써도 작품의 퀄리티가 확 올라간답니다.'],
      [[1], '루피너스', '모성애', '꼬깔 모양 솟은 꽃', '독특한 꼬깔 모양 덕분에 작품에 위트를 줄 수 있는 꽃이에요. 색감이 파스텔 톤이라 봄 시즌에 다른 꽃들과 화사하게 믹스하기 정말 좋아요.'],
      [[1,2,3,4], '블랙잭', '추억', '향이 강한 대표 그린', '유칼립투스 중에서 가장 대중적이고 향이 진해요. 꽃다발의 베이스를 잡을 때 가장 먼저 손이 가는 소재고 비염에도 좋아서 찾는 분들이 많답니다.'],
      [[1,2,3,4], '파블로', '은혜', '부드러운 잎사귀', '블랙잭보다 잎이 작고 부드러워서 좀 더 네츄럴한 느낌을 줄 수 있어요. 하늘거리는 꽃들과 함께 섞었을 때 라인이 훨씬 예쁘게 산답니다.'],
      [[1,2,3,4], '구니', '자애', '은색 빛 도는 잎', '은은한 은빛이 도는 세련된 색감 때문에 인기가 많아요. 잎의 형태가 깔끔해서 모던한 디자인의 꽃다발을 만들 때 그린 소재로 자주 사용한답니다.'],
      [[1,2,3,4], '폴리안', '위로', '넓은 잎사귀', '잎이 큼직해서 커다란 꽃바구니나 행사장 베이스를 잡을 때 아주 유용해요. 한 줄기만 화병에 꽂아두어도 인테리어 효과가 좋아서 가성비 최고의 그린 소재예요.'],
      [[1,2,3,4], '루스커스', '영원한 결혼', '물 없이도 오래 버팀', '물 없이도 며칠은 거뜬할 정도로 생명력이 정말 강해요. 꽃다발 제작할 때 밑받침용으로 쓰거나 싱그러운 초록색을 더하고 싶을 때 무조건 구매하는 아이예요.'],
      [[1,2,3,4], '레몬잎', '신선함', '반짝이는 잎', '잎사귀가 단단하고 반짝여서 꽃다발의 뒷면을 받쳐주기에 가장 좋아요. 부케를 만들 때도 카라나 장미 밑에 레몬잎을 깔아주면 꽃이 훨씬 돋보인답니다.'],
      [[4], '말채', '굳은 마음', '색감 있는 줄기', '겨울에 빨갛거나 노랗게 물든 줄기를 구조물로 짜서 사용해요. 꽃만 꽂기 단조로울 때 선적인 느낌을 더해줘서 작품에 힘을 실어주는 소재랍니다.'],
      [[2], '해바라기', '기다림', '밝고 큰 화형', '여름 하면 가장 먼저 생각나는 꽃이죠. 화사하고 긍정적인 에너지를 줘서 선물용으로 인기가 많고, 요즘은 미니 해바라기나 테디베어 해바라기 등 종류도 정말 다양해요.'],
      [[3], '코스모스', '순정', '하늘거리는 줄기', '가을 꽃바구니를 만들 때 코스모스 몇 송이만 넣어도 계절감이 확 살아나요. 줄기가 얇아서 잘 휘지만 그 자연스러운 굴곡 자체가 매력적인 꽃이랍니다.'],
      [[1,2,3,4], '금란', '고귀', '노란 빛의 난', '노란빛이 도는 우아한 난으로 어른들 선물이나 명절 꽃꽂이에 필수예요. 꽃이 오래가고 단정해서 격식 있는 자리에 두기에 참 좋답니다.'],
      [[2,3], '천일홍', '변치 않는 사랑', '드라이하기 좋음', '이름처럼 꽃 모양이 오랫동안 변하지 않아서 드라이플라워용으로 최고예요. 작은 구슬 같은 꽃송이들이 너무 귀여워서 리스나 소품 만들 때 자주 활용해요.'],
      [[1,2,3,4], '스타티스', '영구불멸', '종이 질감의 꽃', '꽃잎이 바스락거리는 종이 질감이라 마른 후에도 색감이 그대로 유지돼요. 가성비가 좋고 관리하기 쉬워서 선물용 드라이플라워 다발로 많이 나간답니다.'],
      [[1,2], '장구채', '동심', '가늘고 긴 포인트 소재', '가느다란 줄기 끝에 작은 꽃들이 달려 있어서 리듬감을 주기 정말 좋아요. 꽃다발 사이사이에 삐져나오게 연출하면 훨씬 경쾌한 느낌이 든답니다.'],
      [[1], '등대풀', '수줍음', '독특한 그린 필러', '그린 소재지만 꽃 같은 독특한 형태를 가지고 있어요. 입체적인 연출을 하고 싶을 때 중간중간 넣어주면 작품이 훨씬 풍부해 보이고 세련되어 보여요.'],
      [[3], '용담초', '슬픈 그대가 좋아', '보라색 종 모양 꽃', '선명한 보라색 종 모양 꽃이 줄기를 따라 피어 있어요. 가을철에만 볼 수 있는 특유의 색감 때문에 차분하고 기품 있는 어레인지에 자주 쓰인답니다.'],
      [[3], '과꽃', '믿음직한 사랑', '소담한 화형', '예전 마당에서 보던 정겨운 느낌의 꽃이에요. 소박하면서도 친근한 매력이 있어서 들꽃 스타일 꽃바구니를 만들 때 섞어주면 참 예쁘답니다.'],
      [[1], '수선화', '자기사랑', '노란 봄의 전령사', '이른 봄, 노란색 수선화 한 단이면 집안에 봄이 찾아온 것 같아요. 향기도 은은하고 화병에 단독으로 꽂아두기만 해도 정말 예쁜 계절 꽃이랍니다.'],
      [[1,4], '히야신스', '겸손한 사랑', '향기가 매우 진함', '꽃시장에 히야신스가 나오기 시작하면 \'이제 진짜 봄이구나\' 싶어요. 향기가 아주 진하고 몽글몽글한 꽃송이가 귀여워서 구근째 사서 키우는 분들도 많아요.'],
      [[1], '무스카리', '관대한 사랑', '포도송이 같은 꽃', '작은 보라색 포도송이처럼 생긴 꽃이 너무 사랑스러워요. 미니 꽃꽂이나 부케의 포인트 소재로 쓰면 앙증맞은 매력을 극대화할 수 있답니다.'],
      [[1], '양귀비', '위로', '얇은 종이 질감 꽃잎', '몽우리 상태로 사와서 껍질을 벗고 화려한 꽃잎이 터져 나오는 과정이 경이로워요. 꽃잎이 아주 얇아서 빛을 머금었을 때 정말 신비로운 분위기를 자아낸답니다.'],
      [[1,2], '수레국화', '행복', '선명한 블루 컬러', '흔치 않은 선명한 블루 컬러를 가진 꽃이라 소중해요. 야생화 느낌의 정원 스타일 디자인을 할 때 이만한 포인트가 없어서 보이면 꼭 구매한답니다.'],
      [[2], '니겔라', '꿈길의 사랑', '독특한 씨방과 잎', '잎이 안개처럼 퍼져 있고 꽃 뒤의 씨방 모양도 정말 독특해요. 몽환적이고 신비로운 분위기를 연출하고 싶을 때 믹스하면 작품의 급이 달라진답니다.'],
      [[1,2], '베로니카', '충실', '꼬리 모양 라인 소재', '강아지 꼬리처럼 길쭉하게 뻗은 라인이 포인트예요. 아래부터 꽃이 피어 올라가며 자연스러운 곡선을 만들어줘서 꽃다발에 생동감을 더해준답니다.'],
      [[2,3], '에키놉스', '동심', '동그란 가시 공 모양', '동글동글한 가시 공처럼 생긴 독특한 모양 덕분에 질감 포인트로 최고예요. 색감도 오묘한 보라색이라 세련된 무드를 낼 때 아주 유용하답니다.'],
      [[2,3], '에린지움', '비밀스러운 고백', '푸른 빛의 가시 형태', '까칠까칠한 가시 같은 형태가 중성적이고 멋스러워요. 드라이 무드의 작품이나 남성분들을 위한 꽃다발에 섞어주면 정말 세련된 느낌이 난답니다.'],
      [[1,2,3,4], '프로테아', '왕의 위엄', '거대한 수입 꽃', '얼굴이 성인 손바닥만큼 커서 한 송이만으로도 시선을 압도해요. 이국적이고 와일드한 스타일의 대형 작품을 만들 때 주인공으로 자주 쓰인답니다.'],
      [[1,2,3,4], '방크샤', '용기', '독특한 질감의 열매', '드라이플라워처럼 보이지만 생화 소재예요. 질감이 거칠고 이국적이어서 개성 있는 인테리어용 소품이나 빈티지한 다발을 만들 때 아주 멋져요.'],
      [[1,2,3,4], '핀쿠션', '어디서나 성공', '핀 꽂힌 모양 꽃', '바늘꽂이에 핀이 꽂힌 것처럼 생긴 재미있는 꽃이에요. 생명력이 아주 강하고 주황색이나 빨간색 색감이 선명해서 강렬한 포인트를 줄 때 딱이랍니다.'],
      [[4], '브루니아', '행운', '은색 구슬 소재', '작은 은색 구슬들이 뭉쳐 있는 듯한 소재인데 겨울 느낌을 내기에 최고예요. 크리스마스 리스나 겨울 웨딩 부케에 포인트로 넣으면 정말 고급스럽답니다.'],
      [[4], '먼나무 열매', '보호', '빨간 열매 소재', '가지에 빨간 열매가 조르르 달려 있어서 겨울 분위기를 내기 좋아요. 크리스마스 시즌에 센터피스나 리스 소재로 활용하면 정말 따뜻하고 예쁜 무드가 완성돼요.'],
      [[3,4], '낙상홍', '명랑', '가지에 붙은 빨간 열매', '가을부터 겨울까지 유통되는 대표적인 열매 소재예요. 잎이 떨어지고 열매만 남은 가지는 라인 자체가 예술이라 동양 꽃꽂이에도 자주 쓰인답니다.'],
      [[3], '스노우베리', '사랑의 열매', '하얀 구슬 열매', '하얗고 뽀얀 구슬 같은 열매가 너무 청초해서 인기 최고예요. 꽃다발 중간중간에 넣어주면 전체적으로 맑고 깨끗한 느낌을 완성해 주는 필살기 소재랍니다.'],
      [[3], '스노우베리(핑크)', '환영', '분홍빛 열매', '하얀 스노우베리와는 또 다른 사랑스러운 매력이 있어요. 딸기 우유 같은 분홍색 열매가 조르르 달려 있어서 신부 부케나 로맨틱한 꽃다발에 필수예요.'],
      [[1,4], '버들강아지', '친절', '보들보들한 질감', '만지면 보들보들한 솜털 같은 느낌이 너무 좋아요. 이른 봄의 따뜻한 감성을 전달하고 싶을 때 사용하면 정말 정감 가는 작품이 된답니다.'],
      [[1], '벚꽃', '절세미인', '화사한 핑크 라인', '봄 시즌에만 잠깐 나오는 대형 소재예요. 가지 채로 화병에 크게 꽂아두면 실내에서도 벚꽃 엔딩을 즐길 수 있어서 카페 장식용으로 인기 폭발이랍니다.'],
      [[1], '목련', '고귀함', '큰 꽃송이 라인', '커다란 꽃송이가 피어날 때의 고귀한 자태가 압도적이에요. 동양적인 미를 살린 공간 연출에 쓰면 아주 품격 있는 분위기를 만들 수 있답니다.'],
      [[2], '몬스테라', '헌신', '큰 구멍 난 잎', '잎이 워낙 커서 여름철 시원한 느낌의 디스플레이에 최고예요. 한 잎만 큰 화병에 꽂아두어도 공간이 순식간에 트로피컬하게 변신한답니다.'],
      [[2], '고광나무', '추억', '하얀 꽃이 피는 나무', '하얀 꽃에서 퍼지는 은은한 향기가 일품이에요. 자연스러운 나뭇가지 라인을 살리면서 싱그러운 초록잎과 하얀 꽃을 동시에 보고 싶을 때 추천드려요.'],
      [[1,4], '은엽아카시아', '우정', '은빛 잎사귀', '잎사귀 뒷면이 은색이라 전체적으로 오묘하고 세련된 색감을 줘요. 겨울철 리스를 만들거나 꽃다발에 고급스러운 그린을 더하고 싶을 때 자주 쓴답니다.'],
      [[3], '연밥', '순결', '독특한 형태의 씨방', '연꽃이 지고 남은 씨방인데, 그 자체로 훌륭한 디자인 요소가 돼요. 오리엔탈 스타일이나 빈티지한 느낌의 꽃바구니를 만들 때 포인트로 최고랍니다.'],
      [[3], '갈대', '친절', '가을 바람 무드', '가을의 쓸쓸하면서도 낭만적인 분위기를 내고 싶을 때 필수죠. 키가 커서 대형 공간 장식이나 웨딩 포토존 베이스로 쓰면 정말 가을 가을 한 느낌이 나요.'],
      [[3,4], '팜파스', '자랑', '거대한 깃털 질감', '거대한 깃털 같은 질감이 정말 부드럽고 웅장해요. 인테리어 소품으로 인기가 정말 많고, 야외 웨딩에서 배경으로 쓰면 인생 사진을 남길 수 있답니다.'],
      [[4], '목화', '어머니의 사랑', '따뜻한 솜 뭉치', '겨울 하면 목화솜 다발을 빼놓을 수 없죠. 따뜻하고 포근한 느낌 덕분에 겨울철 선물용으로 인기가 많고 오랫동안 그대로 보관할 수 있어 실용적이에요.'],
      [[4], '백묘국', '온화함', '흰 눈 내린 잎', '잎 표면에 하얀 솜털이 있어서 눈이 내린 듯한 느낌을 줘요. 겨울 부케나 리스에 넣으면 훨씬 겨울답고 몽환적인 무드를 연출해 주는 기특한 아이랍니다.'],
      [[1,2], '램스이어', '위로', '양 귀 같은 부드러움', '이름처럼 양의 귀를 닮아 보들보들한 질감이 일품이에요. 독특한 은녹색 색감과 부드러운 촉감 때문에 포인트 그린 소재로 자주 사용한답니다.'],
      [[1,2,3,4], '베어그라스', '인내', '가늘고 긴 선 소재', '길고 얇아서 줄기를 묶거나 땋아서 다양한 형태를 만들 수 있어요. 디자인적인 선 표현을 하고 싶을 때 플로리스트들이 애용하는 기법 소재랍니다.'],
      [[1,2,3,4], '스마일락스', '생기', '길게 늘어지는 덩굴', '줄기가 아주 길게 늘어져서 파티 테이블이나 웨딩 천장 장식을 할 때 필수예요. 자연스럽게 흐르는 라인을 연출하기에 이만한 소재가 없답니다.'],
      [[1,2,3,4], '아이비', '행운', '덩굴성 잎 소재', '꽃다발 아래로 자연스럽게 늘어뜨리는 라인을 잡을 때 최고예요. 생명력이 강해서 작업하기 편하고, 네츄럴한 무드를 완성해 주는 감초 역할을 해요.'],
      [[3,4], '남천', '전화위복', '빨간 단풍 잎', '단풍 든 잎사귀가 너무 예뻐서 가을/겨울철 화병 꽂이 소재로 자주 사요. 동양적인 느낌과 계절감을 동시에 줄 수 있어서 가게 입구 장식에 딱이랍니다.'],
      [[4], '편백', '변치 않는 믿음', '진한 나무 향', '진한 숲속 향기가 나서 작업 내내 힐링 되는 소재예요. 겨울 크리스마스 리스나 트리의 베이스로 가장 많이 쓰이고, 보존성도 아주 좋답니다.'],
      [[1,2,3,4], '알스트로메리아', '우정', '화려한 점박이 무늬', '꽃잎의 점박이 무늬가 이국적이고 화려해요. 수명이 정말 길어서 꽃바구니에 넣으면 끝까지 살아남는 꽃 중 하나라 가성비와 화려함을 동시에 챙길 수 있어요.'],
      [[1,2,3,4], '글로리오사', '영광', '타오르는 불꽃 모양', '불꽃이 피어오르는 듯한 독특한 형태가 너무 멋져요. 가격대는 높지만 고급 행사나 개성 있는 부케에 쓰면 시선을 한 몸에 받는 꽃이랍니다.'],
      [[1], '유채꽃', '명랑', '노란 색감의 들꽃', '제주도의 봄을 그대로 옮겨온 듯한 느낌을 줘요. 자연스러운 들꽃 정원 스타일을 연출할 때 섞어주면 훨씬 화사하고 생동감 넘치는 작품이 돼요.'],
      [[3], '맨드라미', '시들지 않는 사랑', '뇌 모양/촛불 모양', '질감이 벨벳처럼 보드랍고 색감이 아주 선명해요. 가을철 독특한 텍스처 포인트를 주고 싶을 때 사용하면 작품에 깊이감이 생긴답니다.'],
      [[1,2], '유리호프스', '온화', '노란 작은 꽃', '작은 노란 꽃이 올망졸망 피어 있어 가든 무드를 내기 좋아요. 내츄럴한 바구니를 짤 때 삐져나오듯 꽂아주면 생기가 확 살아난답니다.'],
      [[1], '등대꽃', '수줍음', '독특한 등대 모양', '작은 등대가 달려 있는 듯한 형태가 아주 귀엽고 선이 예뻐요. 여백의 미를 살리는 동양적 꽃꽂이나 심플한 화병 꽂이의 라인 소재로 강력 추천해요.'],
      [[1], '보리', '일상이 보물', '내츄럴한 이삭 소재', '초록빛 보리 이삭은 청량한 느낌을 주고, 익은 보리는 수확의 계절감을 줘요. 전원 풍경 같은 느낌을 연출하고 싶을 때 섞어주면 참 정겹답니다.'],
      [[4], '솔방울', '불멸', '겨울 장식 소재', '크리스마스 소품을 만들 때 빠지면 섭섭한 소재죠. 천연 가습 효과도 있고 장식용으로도 훌륭해서 겨울 시즌에는 꽃시장 갈 때마다 한 봉지씩 사게 돼요.'],
      [[1,4], '버질리아', '기다림', '작은 알갱이 뭉치', '작은 알갱이들이 몽글몽글 뭉쳐 있는 수입 소재예요. 텍스처가 독특해서 모던하고 세련된 부케에 포인트로 넣으면 플로리스트의 센스가 돋보인답니다.'],
      [[1,2], '석죽', '무심', '단단하고 작은 꽃뭉치', '꽃잎이 작고 단단해서 수명이 아주 길고 저렴해요. 메인 꽃의 얼굴을 받쳐주는 필러로 쓰기 좋고, 수수한 매력이 있어 오래 봐도 질리지 않아요.'],
      [[1,2,3,4], '스타치스', '변치 않는 마음', '보라색 종이꽃', '색감이 아주 선명하고 그대로 말려도 변색이 거의 없어요. 가성비 꽃다발을 만들거나 드라이플라워용 대량 장식에 이만한 효자가 없답니다.'],
      [[4], '블루에레', '신비', '은빛 도는 침엽 소재', '은빛과 푸른빛이 동시에 도는 고급스러운 겨울 소재예요. 크리스마스 리스를 만들 때 이 소재를 섞어주면 훨씬 신비롭고 세련된 느낌이 완성된답니다.'],
      [[1,2,3,4], '가넷잼로즈', '열정, 매혹', '진한 레드핑크 빛의 겹꽃잎 스프레이 장미', '보석 이름을 딴 장미답게 색감이 정말 깊고 화려해요. 빈티지한 다발을 만들 때 포인트로 넣으면 분위기가 확 달라진답니다.'],
      [[1,2,3,4], '붐바스틱', '풍요, 행복', '큼직한 화형의 가든 스타일 스프레이 장미', '스프레이 장미 중에서 화형이 큼직하고 볼륨감이 좋아서 메인 꽃 못지않은 존재감을 뽐내요. 핑크빛이 정말 사랑스러운 장미예요.'],
      [[1,2,3,4], '스위트스킨장미', '달콤한 사랑', '부드러운 살구빛 핑크의 스탠다드 장미', '이름처럼 살결 같은 부드러운 색감이 매력적인 장미예요. 웨딩 부케나 선물 다발에 넣으면 여성스럽고 우아한 분위기를 완성해 준답니다.'],
      [[1,2,3,4], '시네리아 유칼립투스', '재생, 치유', '은빛 도는 둥근 잎의 유칼립투스', '잎이 동글동글하고 은빛이 돌아서 다른 유칼립투스보다 부드러운 느낌을 줘요. 어떤 꽃과도 잘 어울리는 만능 그린 소재랍니다.'],
      [[1,2,3,4], '안나카리나로즈', '우아한 사랑', '클래식한 화형의 핑크 가든 장미', '프랑스 여배우 이름을 딴 장미답게 정말 우아하고 고급스러워요. 겹겹이 쌓인 꽃잎이 피어나면 향기까지 은은해서 부케 소재로 인기가 많답니다.'],
      [[1], '은방울꽃', '다시 찾은 행복, 순수', '작은 종 모양 꽃이 줄기에 매달린 형태', '작은 종 모양 꽃이 줄줄이 매달려 있는 모습이 너무 청초해요. 왕실 웨딩 부케에 쓰일 만큼 고급스러운 꽃이지만 독성이 있으니 취급 시 주의하세요.'],
      [[1,2,3,4], '줄리엣장미', '로맨틱한 사랑', '피치빛 컵 모양의 대형 가든 장미', '데이비드 오스틴의 대표 품종으로 피치 색감이 정말 환상적이에요. 꽃잎이 겹겹이 풍성하게 피어나면 한 송이만으로도 부케의 주인공이 된답니다.'],
      [[1,2,3,4], '카탈리나로즈', '고귀한 사랑', '크림빛 도는 우아한 화형의 장미', '부드러운 크림색에서 살짝 핑크가 감도는 색감이 너무 고급스러워요. 웨딩 메인 소재로 많이 쓰이고 오래 봐도 질리지 않는 클래식한 장미랍니다.'],
      [[1,2], '캄파눌라', '감사, 성실', '종 모양의 보라색 꽃이 줄기를 따라 피는 형태', '종 모양 꽃이 줄줄이 달려 있어서 자연스러운 가든 느낌을 내기 좋아요. 보라색과 흰색이 주로 있는데 꽃다발에 리듬감을 더해주는 포인트 소재예요.'],
      [[1,2,3,4], '캐리장미', '순수한 사랑', '작고 단정한 화형의 파스텔 장미', '작고 동글한 화형이 정말 귀여운 장미예요. 파스텔 색감이 부드러워서 꽃다발에 넣으면 전체적으로 사랑스러운 분위기를 완성해 준답니다.'],
      [[1,2], '클레마티스', '아름다운 마음, 여행의 즐거움', '덩굴성 식물로 큰 별 모양 꽃이 피는 형태', '줄기가 덩굴처럼 자유롭게 뻗어서 자연스러운 라인을 만들 때 최고예요. 꽃잎이 크고 우아해서 부케나 어레인지에 한두 송이만 넣어도 시선을 사로잡아요.'],
      [[2,3], '투베로사', '위험한 쾌락, 관능', '하얀 꽃이 줄기를 따라 위로 피며 향이 매우 강함', '향수의 원료로 쓰일 만큼 향기가 정말 진하고 매혹적이에요. 하얀 꽃이 줄기를 따라 차례로 피어올라가는 모습이 우아하고 고급스러운 꽃이랍니다.'],
      [[3,4], '퐁퐁', '밝은 미래', '동글동글 완벽한 구 형태의 국화', '이름처럼 동글동글한 형태가 너무 귀여워요. 꽃잎이 빽빽하게 차 있어서 수명도 길고 파스텔 색상이 다양해서 귀여운 꽃다발에 꼭 넣게 되는 꽃이에요.'],
      [[1,2,3,4], '푸에고장미', '불타는 열정', '선명한 빨간색의 강렬한 스탠다드 장미', '이름이 불이라는 뜻답게 색감이 정말 강렬해요. 프로포즈나 기념일 꽃다발에 빠지지 않는 클래식한 빨간 장미의 대표 품종이에요.'],
      [[1,2,3,4], '핑크벨벳장미', '감탄, 존경', '벨벳 질감의 진한 핑크색 장미', '꽃잎 표면이 벨벳처럼 부드럽고 깊은 핑크색이 정말 매혹적이에요. 고급스러운 꽃다발이나 부케에 넣으면 질감과 색감 모두 만족스러운 장미랍니다.'],
      [[1,2,3,4], '햇살로즈', '따뜻한 사랑', '밝은 노란빛의 화사한 장미', '이름처럼 햇살 같은 밝은 노란색이 보는 사람을 기분 좋게 해줘요. 화사한 봄 꽃다발이나 축하 선물용으로 인기가 많은 사랑스러운 장미랍니다.'],
      [[1,2,3,4], '헤라장미', '영원한 사랑', '크림빛 화이트의 대형 가든 장미', '웨딩 부케의 여왕이라 불릴 만큼 신부들이 사랑하는 장미예요. 크림 화이트 색감에 겹겹이 쌓인 꽃잎이 피어나면 우아함의 끝을 보여준답니다.'],
      [[1,2,3,4], '기젤라장미', '섬세한 아름다움', '작고 섬세한 화형의 스프레이 장미', '꽃잎이 섬세하게 겹겹이 쌓여 있어 빈티지한 느낌을 줘요. 웨딩 부케나 테이블 장식에 넣으면 우아한 분위기를 완성해 주는 예쁜 장미랍니다.'],
      [[1,2,3,4], '맨스필드파크', '고귀한 아름다움', '우아한 피치핑크빛의 잉글리시 로즈', '데이비드 오스틴의 잉글리시 로즈 품종으로 은은한 피치핑크 색감이 정말 고급스러워요. 한 송이만으로도 부케의 분위기를 확 바꿔주는 매력적인 장미랍니다.'],
      [[1,2,3,4], '버블검장미', '즐거운 사랑', '선명한 핑크색의 발랄한 스탠다드 장미', '이름처럼 사탕 같은 선명한 핑크색이 정말 발랄해요. 밝고 화사한 꽃다발을 만들고 싶을 때 메인으로 쓰면 기분 좋은 에너지를 듬뿍 전해준답니다.'],
      [[1,2,3,4], '부르트장미', '강인한 매력', '샴페인빛의 시크한 스탠다드 장미', '샴페인 브랜드 이름을 딴 장미답게 색감이 세련되고 고급스러워요. 차분한 톤의 꽃다발이나 모던한 어레인지에 잘 어울리는 장미랍니다.'],
      [[1,2,3,4], '샤먼트장미', '매혹적인 사랑', '부드러운 분홍빛의 클래식한 장미', '이름처럼 매력적인 분홍빛이 보는 이의 마음을 사로잡아요. 꽃잎이 풍성하게 피어나면 클래식하면서도 로맨틱한 분위기를 연출할 수 있답니다.'],
      [[1,2,3,4], '소프라노장미', '고상한 사랑', '우아한 색감의 스탠다드 장미', '이름에 걸맞게 고상하고 우아한 색감이 매력적인 장미예요. 화형이 단정하고 꽃잎이 단단해서 오래가고 선물용 꽃다발에 넣으면 격이 달라진답니다.'],
      [[1,2], '스파이더 거베라', '신비로운 아름다움', '거미 다리처럼 길고 가느다란 꽃잎의 거베라', '일반 거베라와 달리 꽃잎이 실처럼 가늘고 길어서 독특한 매력이 있어요. 모던하고 세련된 꽃다발에 포인트로 넣으면 시선을 확 끄는 매력적인 꽃이에요.'],
      [[1,2,3,4], '신시아장미', '순수한 아름다움', '파스텔톤의 부드러운 화형을 가진 장미', '부드러운 파스텔 색감이 사랑스러워서 여성분들에게 인기가 많아요. 꽃잎이 겹겹이 풍성하게 피어나면 부케의 주인공으로도 손색이 없는 장미랍니다.'],
      [[1,2,3,4], '카사노바장미', '황홀한 사랑', '크림 옐로우빛의 우아한 대형 장미', '부드러운 크림 옐로우 색감이 고급스럽고 우아해요. 꽃이 크게 피어나면 존재감이 남다르고 웨딩이나 특별한 날의 꽃다발에 잘 어울리는 장미랍니다.'],
      [[1,2,3,4], '카테이션', '변함없는 애정', '풍성한 겹꽃잎의 화사한 화형', '꽃잎이 풍성하게 겹겹이 쌓여 있어 한 송이만으로도 볼륨감이 좋아요. 꽃다발에 넣으면 화사하면서도 포근한 느낌을 더해주는 매력적인 꽃이에요.'],
      [[1,2,3,4], '캄파넬라로즈', '감사하는 마음', '종 모양으로 피어나는 앙증맞은 가든 장미', '작은 종 모양으로 동글동글하게 피어나는 형태가 너무 귀여운 가든 장미예요. 빈티지한 부케나 자연스러운 가든 스타일에 잘 어울리는 사랑스러운 꽃이랍니다.'],
      [[1,2], '코랄작약', '수줍은 고백', '산호빛 핑크의 화려한 작약', '일반 작약의 화려함에 산호빛 핑크 색감이 더해져 정말 매혹적이에요. 봄 시즌 부케에 메인으로 쓰면 화사하면서도 고급스러운 분위기를 완성해 준답니다.'],
      [[1,2,3,4], '타임스퀘어장미', '화려한 열정', '강렬한 색감의 투톤 장미', '이름처럼 화려하고 강렬한 색감이 시선을 사로잡는 장미예요. 꽃다발에 포인트로 한두 송이만 넣어도 전체적인 분위기가 확 달라진답니다.'],
      [[1,2,3,4], '트레비장미', '소원, 희망', '부드러운 파스텔 핑크의 우아한 장미', '트레비 분수에서 따온 이름처럼 로맨틱한 감성을 지닌 장미예요. 부드러운 파스텔 핑크 색감이 우아하고 꽃다발에 넣으면 여성스러운 분위기를 완성해 준답니다.'],
      [[1,2], '프록스', '합의, 동의', '작은 꽃들이 뭉쳐 피는 동글동글한 화형', '작은 꽃송이들이 동글하게 뭉쳐 피어서 볼륨감이 좋아요. 꽃다발 사이사이에 넣어주면 빈 공간을 예쁘게 채워주면서 은은한 향기까지 더해주는 매력적인 꽃이에요.'],
      [[1,2,3,4], '하이베리콤', '보호, 안전', '알록달록한 열매가 달린 필러 소재', '동글동글한 열매가 너무 귀여워서 꽃다발에 포인트로 자주 넣어요. 빨간색, 분홍색, 초록색 등 색상이 다양하고 생명력이 강해서 오래 볼 수 있답니다.'],
      [[1], '홍조팝', '풍요로운 사랑', '붉은빛이 도는 화사한 조팝나무', '일반 조팝나무와 달리 줄기와 꽃봉오리에 붉은빛이 도는 것이 특징이에요. 봄 시즌에 나오는 소재로 꽃다발에 넣으면 화사하면서도 독특한 분위기를 줄 수 있답니다.'],
    ];

    // Images for flowers that have photos
    final imageMap = <String, List<Map<String, Object>>>{
      '자나 장미': [
        {'image_number': 1, 'image_path': 'assets/images/flowers/자나1.jpg'},
        {'image_number': 2, 'image_path': 'assets/images/flowers/자나2.jpg'},
        {'image_number': 3, 'image_path': 'assets/images/flowers/자나3.jpg'},
        {'image_number': 4, 'image_path': 'assets/images/flowers/자나4.jpg'},
      ],
      '리시안셔스': [
        {'image_number': 1, 'image_path': 'assets/images/flowers/리시안셔스1.jpg'},
        {'image_number': 2, 'image_path': 'assets/images/flowers/리시안셔스2.jpg'},
      ],
      '다알리아': [
        {'image_number': 1, 'image_path': 'assets/images/flowers/다알리아1.jpg'},
        {'image_number': 2, 'image_path': 'assets/images/flowers/다알리아2.jpg'},
      ],
      '수국': [
        {'image_number': 1, 'image_path': 'assets/images/flowers/수국1.jpg'},
        {'image_number': 2, 'image_path': 'assets/images/flowers/수국2.jpg'},
        {'image_number': 3, 'image_path': 'assets/images/flowers/수국3.jpg'},
        {'image_number': 4, 'image_path': 'assets/images/flowers/수국4.jpg'},
        {'image_number': 5, 'image_path': 'assets/images/flowers/수국5.jpg'},
      ],
      '튤립': [
        {'image_number': 1, 'image_path': 'assets/images/flowers/튤립1.jpg'},
        {'image_number': 2, 'image_path': 'assets/images/flowers/튤립2.jpg'},
        {'image_number': 3, 'image_path': 'assets/images/flowers/튤립3.jpg'},
      ],
      '프리지아': [
        {'image_number': 1, 'image_path': 'assets/images/flowers/프리지아1.jpg'},
        {'image_number': 2, 'image_path': 'assets/images/flowers/프리지아2.jpg'},
      ],
      '라그라스': [
        {'image_number': 1, 'image_path': 'assets/images/flowers/라그라스1.jpg'},
        {'image_number': 2, 'image_path': 'assets/images/flowers/라그라스2.jpg'},
      ],
      '스타티스': [
        {'image_number': 1, 'image_path': 'assets/images/flowers/스타티스1.jpg'},
      ],
      '양귀비': [
        {'image_number': 1, 'image_path': 'assets/images/flowers/양귀비1.jpg'},
        {'image_number': 2, 'image_path': 'assets/images/flowers/양귀비2.jpg'},
        {'image_number': 3, 'image_path': 'assets/images/flowers/양귀비3.jpg'},
      ],
      '해바라기': [
        {'image_number': 1, 'image_path': 'assets/images/flowers/해바라기1.jpg'},
        {'image_number': 2, 'image_path': 'assets/images/flowers/해바라기2.jpg'},
        {'image_number': 3, 'image_path': 'assets/images/flowers/해바라기3.jpg'},
        {'image_number': 4, 'image_path': 'assets/images/flowers/해바라기4.jpg'},
        {'image_number': 5, 'image_path': 'assets/images/flowers/해바라기5.jpg'},
      ],
      '팜파스': [
        {'image_number': 1, 'image_path': 'assets/images/flowers/팜파스1.jpg'},
        {'image_number': 2, 'image_path': 'assets/images/flowers/팜파스2.jpg'},
        {'image_number': 3, 'image_path': 'assets/images/flowers/팜파스3.jpg'},
      ],
      '가넷잼로즈': [
        {'image_number': 1, 'image_path': 'assets/images/flowers/가넷잼로즈1.jpg'},
        {'image_number': 2, 'image_path': 'assets/images/flowers/가넷잼로즈2.jpg'},
        {'image_number': 3, 'image_path': 'assets/images/flowers/가넷잼로즈3.jpg'},
      ],
      '붐바스틱': [
        {'image_number': 1, 'image_path': 'assets/images/flowers/붐바스틱1.jpg'},
      ],
      '스위트스킨장미': [
        {'image_number': 1, 'image_path': 'assets/images/flowers/스위트스킨장미.jpg'},
      ],
      '시네리아 유칼립투스': [
        {'image_number': 1, 'image_path': 'assets/images/flowers/시네리아유칼립투스1.jpg'},
      ],
      '안나카리나로즈': [
        {'image_number': 1, 'image_path': 'assets/images/flowers/안나카리나로즈1.jpg'},
        {'image_number': 2, 'image_path': 'assets/images/flowers/안나카리나로즈2.jpg'},
        {'image_number': 3, 'image_path': 'assets/images/flowers/안나카리나로즈3.jpg'},
      ],
      '은방울꽃': [
        {'image_number': 1, 'image_path': 'assets/images/flowers/은방울꽃1.jpg'},
        {'image_number': 2, 'image_path': 'assets/images/flowers/은방울꽃3.jpg'},
      ],
      '줄리엣장미': [
        {'image_number': 1, 'image_path': 'assets/images/flowers/줄리엣장미1.jpg'},
        {'image_number': 2, 'image_path': 'assets/images/flowers/줄리엣장미2.jpg'},
      ],
      '카탈리나로즈': [
        {'image_number': 1, 'image_path': 'assets/images/flowers/카탈리나로즈1.jpg'},
        {'image_number': 2, 'image_path': 'assets/images/flowers/카탈리나로즈2.jpg'},
        {'image_number': 3, 'image_path': 'assets/images/flowers/카탈리나로즈3.jpg'},
        {'image_number': 4, 'image_path': 'assets/images/flowers/카탈리나로즈4.jpg'},
      ],
      '캄파눌라': [
        {'image_number': 1, 'image_path': 'assets/images/flowers/캄파눌라1.jpg'},
        {'image_number': 2, 'image_path': 'assets/images/flowers/캄파눌라2.jpg'},
      ],
      '캐리장미': [
        {'image_number': 1, 'image_path': 'assets/images/flowers/캐리장미.jpg'},
        {'image_number': 2, 'image_path': 'assets/images/flowers/캐리장미2.jpg'},
        {'image_number': 3, 'image_path': 'assets/images/flowers/캐리장미3.jpg'},
      ],
      '클레마티스': [
        {'image_number': 1, 'image_path': 'assets/images/flowers/클레마티스1.jpg'},
        {'image_number': 2, 'image_path': 'assets/images/flowers/클레마티스2.jpg'},
        {'image_number': 3, 'image_path': 'assets/images/flowers/클레마티스3.jpg'},
        {'image_number': 4, 'image_path': 'assets/images/flowers/클레마티스4.jpg'},
      ],
      '투베로사': [
        {'image_number': 1, 'image_path': 'assets/images/flowers/투베로사1.jpg'},
      ],
      '퐁퐁': [
        {'image_number': 1, 'image_path': 'assets/images/flowers/퐁퐁1.jpg'},
        {'image_number': 2, 'image_path': 'assets/images/flowers/퐁퐁2.jpg'},
        {'image_number': 3, 'image_path': 'assets/images/flowers/퐁퐁3.jpg'},
        {'image_number': 4, 'image_path': 'assets/images/flowers/퐁퐁4.jpg'},
      ],
      '푸에고장미': [
        {'image_number': 1, 'image_path': 'assets/images/flowers/푸에고장미1.jpg'},
        {'image_number': 2, 'image_path': 'assets/images/flowers/푸에고장미2.jpg'},
        {'image_number': 3, 'image_path': 'assets/images/flowers/푸에고장미3.jpg'},
      ],
      '핑크벨벳장미': [
        {'image_number': 1, 'image_path': 'assets/images/flowers/핑크벨벳장미1.jpg'},
        {'image_number': 2, 'image_path': 'assets/images/flowers/핑크벨벳장미2.jpg'},
      ],
      '햇살로즈': [
        {'image_number': 1, 'image_path': 'assets/images/flowers/햇살로즈1.jpg'},
        {'image_number': 2, 'image_path': 'assets/images/flowers/햇살로즈2.jpg'},
        {'image_number': 3, 'image_path': 'assets/images/flowers/햇살로즈3.jpg'},
      ],
      '헤라장미': [
        {'image_number': 1, 'image_path': 'assets/images/flowers/헤라장미1.jpg'},
        {'image_number': 2, 'image_path': 'assets/images/flowers/헤라장미2.jpg'},
        {'image_number': 3, 'image_path': 'assets/images/flowers/헤라장미3.jpg'},
      ],
      '과꽃': [
        {'image_number': 1, 'image_path': 'assets/images/flowers/과꽃1.jpg'},
      ],
      '델피늄': [
        {'image_number': 1, 'image_path': 'assets/images/flowers/델피니움1.jpg'},
        {'image_number': 2, 'image_path': 'assets/images/flowers/델피니움2.jpg'},
      ],
      '매트리칼리아': [
        {'image_number': 1, 'image_path': 'assets/images/flowers/마트리카리아1.jpg'},
      ],
      '베로니카': [
        {'image_number': 1, 'image_path': 'assets/images/flowers/베로니카2.jpg'},
      ],
      '스카비오사': [
        {'image_number': 1, 'image_path': 'assets/images/flowers/스카비오사1.jpg'},
        {'image_number': 2, 'image_path': 'assets/images/flowers/스카비오사2.jpg'},
      ],
      '옥시펜탈륨': [
        {'image_number': 1, 'image_path': 'assets/images/flowers/옥시페탈리움1.jpg'},
        {'image_number': 2, 'image_path': 'assets/images/flowers/옥시페탈리움2.jpg'},
        {'image_number': 3, 'image_path': 'assets/images/flowers/옥시페탈리움3.jpg'},
      ],
      '카네이션': [
        {'image_number': 1, 'image_path': 'assets/images/flowers/카네이션1.JPG'},
        {'image_number': 2, 'image_path': 'assets/images/flowers/카네이션2.jpg'},
        {'image_number': 3, 'image_path': 'assets/images/flowers/카네이션3.jpg'},
      ],
      '기젤라장미': [
        {'image_number': 1, 'image_path': 'assets/images/flowers/기젤라장미1.jpg'},
      ],
      '맨스필드파크': [
        {'image_number': 1, 'image_path': 'assets/images/flowers/맨스필드파크.jpg'},
      ],
      '버블검장미': [
        {'image_number': 1, 'image_path': 'assets/images/flowers/버블검장미1.jpg'},
      ],
      '부르트장미': [
        {'image_number': 1, 'image_path': 'assets/images/flowers/부르트장미.jpg'},
      ],
      '샤먼트장미': [
        {'image_number': 1, 'image_path': 'assets/images/flowers/샤먼트장미.jpg'},
      ],
      '소프라노장미': [
        {'image_number': 1, 'image_path': 'assets/images/flowers/소프라노장미1.jpg'},
      ],
      '스파이더 거베라': [
        {'image_number': 1, 'image_path': 'assets/images/flowers/스파이더 거베라.jpg'},
      ],
      '신시아장미': [
        {'image_number': 1, 'image_path': 'assets/images/flowers/신시아장미1.jpg'},
      ],
      '카사노바장미': [
        {'image_number': 1, 'image_path': 'assets/images/flowers/카사노바장미1.jpg'},
        {'image_number': 2, 'image_path': 'assets/images/flowers/카사노바장미2.jpg'},
      ],
      '카테이션': [
        {'image_number': 1, 'image_path': 'assets/images/flowers/카테이션1.jpg'},
        {'image_number': 2, 'image_path': 'assets/images/flowers/카테이션2.jpg'},
        {'image_number': 3, 'image_path': 'assets/images/flowers/카테이션3.jpg'},
        {'image_number': 4, 'image_path': 'assets/images/flowers/카테이션4.jpg'},
        {'image_number': 5, 'image_path': 'assets/images/flowers/카테이션5.jpg'},
      ],
      '캄파넬라로즈': [
        {'image_number': 1, 'image_path': 'assets/images/flowers/캄파넬라로즈.jpg'},
      ],
      '코랄작약': [
        {'image_number': 1, 'image_path': 'assets/images/flowers/코랄작약.jpg'},
      ],
      '타임스퀘어장미': [
        {'image_number': 1, 'image_path': 'assets/images/flowers/타임스퀘어장미.jpg'},
      ],
      '트레비장미': [
        {'image_number': 1, 'image_path': 'assets/images/flowers/트레비장미1.jpg'},
      ],
      '프록스': [
        {'image_number': 1, 'image_path': 'assets/images/flowers/프록스1.jpg'},
      ],
      '하이베리콤': [
        {'image_number': 1, 'image_path': 'assets/images/flowers/하이베리콤1.jpg'},
      ],
      '홍조팝': [
        {'image_number': 1, 'image_path': 'assets/images/flowers/홍조팝1.jpg'},
      ],
      '아네모네': [
        {'image_number': 1, 'image_path': 'assets/images/flowers/아네모네1.jpg'},
        {'image_number': 2, 'image_path': 'assets/images/flowers/아네모네2.jpg'},
      ],
      '헬레보루스': [
        {'image_number': 1, 'image_path': 'assets/images/flowers/헬레보루스1.jpg'},
        {'image_number': 2, 'image_path': 'assets/images/flowers/헬레보루스2.jpg'},
        {'image_number': 3, 'image_path': 'assets/images/flowers/헬레보루스3.jpg'},
      ],
      '카라': [
        {'image_number': 1, 'image_path': 'assets/images/flowers/카라1.jpg'},
        {'image_number': 2, 'image_path': 'assets/images/flowers/카라2.jpg'},
      ],
      '백합': [
        {'image_number': 1, 'image_path': 'assets/images/flowers/백합1.jpg'},
        {'image_number': 2, 'image_path': 'assets/images/flowers/백합2.jpg'},
      ],
      '왁스플라워': [
        {'image_number': 1, 'image_path': 'assets/images/flowers/왁스플라워1.jpg'},
        {'image_number': 2, 'image_path': 'assets/images/flowers/왁스플라워2.jpg'},
        {'image_number': 3, 'image_path': 'assets/images/flowers/왁스플라워3.jpg'},
      ],
      '스토크': [
        {'image_number': 1, 'image_path': 'assets/images/flowers/스토크1.jpg'},
        {'image_number': 2, 'image_path': 'assets/images/flowers/스토크2.jpg'},
        {'image_number': 3, 'image_path': 'assets/images/flowers/스토크3.jpg'},
      ],
      '아스틸베': [
        {'image_number': 1, 'image_path': 'assets/images/flowers/아스틸베1.jpg'},
        {'image_number': 2, 'image_path': 'assets/images/flowers/아스틸베2.jpg'},
      ],
      '미모사': [
        {'image_number': 1, 'image_path': 'assets/images/flowers/미모사1.jpg'},
        {'image_number': 2, 'image_path': 'assets/images/flowers/미모사2.jpg'},
        {'image_number': 3, 'image_path': 'assets/images/flowers/미모사3.jpg'},
      ],
      '안개꽃': [
        {'image_number': 1, 'image_path': 'assets/images/flowers/안개1.jpg'},
        {'image_number': 2, 'image_path': 'assets/images/flowers/안개2.jpg'},
        {'image_number': 3, 'image_path': 'assets/images/flowers/안개3.jpg'},
        {'image_number': 4, 'image_path': 'assets/images/flowers/안개4.jpg'},
      ],
      '히야신스': [
        {'image_number': 1, 'image_path': 'assets/images/flowers/히야신스2.jpg'},
      ],
      '거베라': [
        {'image_number': 1, 'image_path': 'assets/images/flowers/거베라3.jpg'},
        {'image_number': 2, 'image_path': 'assets/images/flowers/거베라4.jpg'},
      ],
      '라넌큘러스': [
        {'image_number': 1, 'image_path': 'assets/images/flowers/라넌큘러스1.png'},
        {'image_number': 2, 'image_path': 'assets/images/flowers/라넌큘러스2.jpg'},
        {'image_number': 3, 'image_path': 'assets/images/flowers/라넌큘러스3.jpg'},
        {'image_number': 4, 'image_path': 'assets/images/flowers/라넌큘러스4.jpg'},
        {'image_number': 5, 'image_path': 'assets/images/flowers/라넌큘러스5.jpg'},
      ],
      '작약': [
        {'image_number': 1, 'image_path': 'assets/images/flowers/작약1.jpg'},
        {'image_number': 2, 'image_path': 'assets/images/flowers/작약2.jpg'},
        {'image_number': 3, 'image_path': 'assets/images/flowers/작약3.jpg'},
        {'image_number': 4, 'image_path': 'assets/images/flowers/작약4.jpg'},
      ],
      '조팝나무': [
        {'image_number': 1, 'image_path': 'assets/images/flowers/조팝나무1.jpg'},
      ],
      '코스모스': [
        {'image_number': 1, 'image_path': 'assets/images/flowers/코스모스1.jpg'},
      ],
      '수선화': [
        {'image_number': 1, 'image_path': 'assets/images/flowers/수선화1.jpg'},
      ],
      '미모사 플로리반다': [
        {'image_number': 1, 'image_path': 'assets/images/flowers/미모사 플로리반다1.jpg'},
        {'image_number': 2, 'image_path': 'assets/images/flowers/미모사 플로리반다2.jpg'},
      ],
    };

    for (final f in flowers) {
      final seasons = f[0] as List<int>;
      final name = f[1] as String;

      final flowerId = await db.insert('flowers', {
        'name': name,
        'floriography': f[2] as String,
        'feature': f[3] as String,
        'review': f[4] as String,
      });

      for (final sid in seasons) {
        await db.insert('flower_seasons', {
          'flower_id': flowerId,
          'season_id': sid,
        });
      }

      if (imageMap.containsKey(name)) {
        for (final img in imageMap[name]!) {
          await db.insert('flower_images', {
            'flower_id': flowerId,
            'image_number': img['image_number'],
            'image_path': img['image_path'],
          });
        }
      }
    }
  }

  Future<List<FlowerImage>> _getFlowerImages(Database db, int flowerId) async {
    final maps = await db.query(
      'flower_images',
      where: 'flower_id = ?',
      whereArgs: [flowerId],
      orderBy: 'image_number',
    );
    return maps.map((m) => FlowerImage.fromMap(m)).toList();
  }

  Future<List<String>> getAllFlowerNames() async {
    final db = await database;
    final maps = await db.query('flowers', columns: ['name'], orderBy: 'name');
    return maps.map((m) => m['name'] as String).toList();
  }

  Future<List<Flower>> getAllFlowers() async {
    final db = await database;
    final List<Map<String, dynamic>> flowerMaps = await db.query('flowers', orderBy: 'name');

    final flowers = <Flower>[];
    for (final map in flowerMaps) {
      final flowerId = map['id'] as int;
      final seasonMaps = await db.query(
        'flower_seasons',
        where: 'flower_id = ?',
        whereArgs: [flowerId],
      );
      final seasons = seasonMaps.map((s) => s['season_id'] as int).toList();
      final images = await _getFlowerImages(db, flowerId);
      flowers.add(Flower.fromMap(map, seasons: seasons, images: images));
    }
    return flowers;
  }

  Future<Flower?> getFlowerByName(String name) async {
    final db = await database;
    final maps = await db.query('flowers', where: 'name = ?', whereArgs: [name]);
    if (maps.isEmpty) return null;

    final map = maps.first;
    final flowerId = map['id'] as int;
    final seasonMaps = await db.query(
      'flower_seasons',
      where: 'flower_id = ?',
      whereArgs: [flowerId],
    );
    final seasons = seasonMaps.map((s) => s['season_id'] as int).toList();
    final images = await _getFlowerImages(db, flowerId);
    return Flower.fromMap(map, seasons: seasons, images: images);
  }

  Future<List<Flower>> getFlowersBySeason(int seasonId) async {
    final db = await database;
    final maps = await db.rawQuery('''
      SELECT f.* FROM flowers f
      INNER JOIN flower_seasons fs ON f.id = fs.flower_id
      WHERE fs.season_id = ?
      ORDER BY f.name
    ''', [seasonId]);

    final flowers = <Flower>[];
    for (final map in maps) {
      final flowerId = map['id'] as int;
      final seasonMaps = await db.query(
        'flower_seasons',
        where: 'flower_id = ?',
        whereArgs: [flowerId],
      );
      final seasons = seasonMaps.map((s) => s['season_id'] as int).toList();
      final images = await _getFlowerImages(db, flowerId);
      flowers.add(Flower.fromMap(map, seasons: seasons, images: images));
    }
    return flowers;
  }

  Future<Flower?> getFirstFlower() async {
    final db = await database;
    final maps = await db.query('flowers', orderBy: 'id', limit: 1);
    if (maps.isEmpty) return null;

    final map = maps.first;
    final flowerId = map['id'] as int;
    final seasonMaps = await db.query(
      'flower_seasons',
      where: 'flower_id = ?',
      whereArgs: [flowerId],
    );
    final seasons = seasonMaps.map((s) => s['season_id'] as int).toList();
    final images = await _getFlowerImages(db, flowerId);
    return Flower.fromMap(map, seasons: seasons, images: images);
  }

  Future<bool> isFavorite(int flowerId) async {
    final db = await database;
    final maps = await db.query(
      'favorites',
      where: 'flower_id = ?',
      whereArgs: [flowerId],
    );
    return maps.isNotEmpty;
  }

  Future<void> toggleFavorite(int flowerId) async {
    final db = await database;
    final exists = await isFavorite(flowerId);
    if (exists) {
      await db.delete('favorites', where: 'flower_id = ?', whereArgs: [flowerId]);
    } else {
      await db.insert('favorites', {'flower_id': flowerId});
    }
  }

  Future<List<Flower>> getFavoriteFlowers() async {
    final db = await database;
    final maps = await db.rawQuery('''
      SELECT f.* FROM flowers f
      INNER JOIN favorites fav ON f.id = fav.flower_id
      ORDER BY f.name
    ''');

    final flowers = <Flower>[];
    for (final map in maps) {
      final flowerId = map['id'] as int;
      final seasonMaps = await db.query(
        'flower_seasons',
        where: 'flower_id = ?',
        whereArgs: [flowerId],
      );
      final seasons = seasonMaps.map((s) => s['season_id'] as int).toList();
      final images = await _getFlowerImages(db, flowerId);
      flowers.add(Flower.fromMap(map, seasons: seasons, images: images));
    }
    return flowers;
  }
}
