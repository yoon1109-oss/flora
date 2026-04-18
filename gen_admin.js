const fs = require('fs');
const csv = fs.readFileSync('C:/Users/User/Documents/flora/flora_꽃목록.csv', 'utf8');

const imageMap = {
  '자나 장미': ['자나1.jpg','자나2.jpg','자나3.jpg','자나4.jpg'],
  '리시안셔스': ['리시안셔스1.jpg','리시안셔스2.jpg','리시안셔스3.jpg'],
  '다알리아': ['다알리아1.jpg','다알리아2.jpg'],
  '수국': ['수국1.jpg','수국2.jpg','수국3.jpg','수국4.jpg','수국5.jpg'],
  '튤립': ['튤립1.jpg','튤립2.jpg','튤립3.jpg'],
  '프리지아': ['프리지아1.jpg','프리지아2.jpg'],
  '라그라스': ['라그라스1.jpg','라그라스2.jpg'],
  '스타티스': ['스타티스1.jpg'],
  '양귀비': ['양귀비1.jpg','양귀비2.jpg','양귀비3.jpg','양귀비4.jpg'],
  '해바라기': ['해바라기1.jpg','해바라기2.jpg','해바라기3.jpg','해바라기4.jpg','해바라기5.jpg'],
  '팜파스': ['팜파스1.jpg','팜파스2.jpg','팜파스3.jpg'],
  '가넷잼로즈': ['가넷잼로즈1.jpg','가넷잼로즈2.jpg','가넷잼로즈3.jpg'],
  '붐바스틱': ['붐바스틱1.jpg'],
  '스위트스킨장미': ['스위트스킨장미.jpg'],
  '시네리아 유칼립투스': ['시네리아유칼립투스1.jpg'],
  '안나카리나로즈': ['안나카리나로즈1.jpg','안나카리나로즈2.jpg','안나카리나로즈3.jpg'],
  '은방울꽃': ['은방울꽃1.jpg','은방울꽃3.jpg'],
  '줄리엣장미': ['줄리엣장미1.jpg','줄리엣장미2.jpg'],
  '카탈리나로즈': ['카탈리나로즈1.jpg','카탈리나로즈2.jpg','카탈리나로즈3.jpg','카탈리나로즈4.jpg'],
  '캄파눌라': ['캄파눌라1.jpg','캄파눌라2.jpg'],
  '캐리장미': ['캐리장미.jpg','캐리장미2.jpg','캐리장미3.jpg'],
  '클레마티스': ['클레마티스1.jpg','클레마티스2.jpg','클레마티스3.jpg','클레마티스4.jpg'],
  '투베로사': ['투베로사1.jpg'],
  '퐁퐁': ['퐁퐁1.jpg','퐁퐁2.jpg','퐁퐁3.jpg','퐁퐁4.jpg'],
  '푸에고장미': ['푸에고장미1.jpg','푸에고장미2.jpg','푸에고장미3.jpg'],
  '핑크벨벳장미': ['핑크벨벳장미1.jpg','핑크벨벳장미2.jpg'],
  '햇살로즈': ['햇살로즈1.jpg','햇살로즈2.jpg','햇살로즈3.jpg'],
  '헤라장미': ['헤라장미1.jpg','헤라장미2.jpg','헤라장미3.jpg','헤라장미4.jpg'],
  '과꽃': ['과꽃1.jpg'],
  '델피늄': ['델피니움1.jpg','델피니움2.jpg'],
  '매트리칼리아': ['마트리카리아1.jpg'],
  '베로니카': ['베로니카2.jpg'],
  '스카비오사': ['스카비오사1.jpg','스카비오사2.jpg'],
  '옥시펜탈륨': ['옥시페탈리움1.jpg','옥시페탈리움2.jpg','옥시페탈리움3.jpg'],
  '카네이션': ['카네이션1.JPG','카네이션2.jpg','카네이션3.jpg'],
  '기젤라장미': ['기젤라장미1.jpg'],
  '맨스필드파크': ['맨스필드파크.jpg'],
  '버블검장미': ['버블검장미1.jpg'],
  '부르트장미': ['부르트장미.jpg'],
  '샤먼트장미': ['샤먼트장미.jpg'],
  '소프라노장미': ['소프라노장미1.jpg'],
  '스파이더 거베라': ['스파이더 거베라.jpg'],
  '신시아장미': ['신시아장미1.jpg'],
  '카사노바장미': ['카사노바장미1.jpg','카사노바장미2.jpg'],
  '카테이션': ['카테이션1.jpg','카테이션2.jpg','카테이션3.jpg','카테이션4.jpg','카테이션5.jpg'],
  '캄파넬라로즈': ['캄파넬라로즈.jpg'],
  '코랄작약': ['코랄작약.jpg'],
  '타임스퀘어장미': ['타임스퀘어장미.jpg'],
  '트레비장미': ['트레비장미1.jpg'],
  '프록스': ['프록스1.jpg','프록스2.jpg','프록스3.jpg'],
  '하이베리콤': ['하이베리콤1.jpg'],
  '홍조팝': ['홍조팝1.jpg'],
  '아네모네': ['아네모네1.jpg','아네모네2.jpg'],
  '헬레보루스': ['헬레보루스1.jpg','헬레보루스2.jpg','헬레보루스3.jpg'],
  '카라': ['카라1.jpg','카라2.jpg'],
  '백합': ['백합1.jpg','백합2.jpg'],
  '왁스플라워': ['왁스플라워1.jpg','왁스플라워2.jpg','왁스플라워3.jpg'],
  '스토크': ['스토크1.jpg','스토크2.jpg','스토크3.jpg','스토크4.jpg'],
  '아스틸베': ['아스틸베1.jpg','아스틸베2.jpg'],
  '미모사': ['미모사1.jpg','미모사2.jpg','미모사3.jpg'],
  '안개꽃': ['안개1.jpg','안개2.jpg','안개3.jpg','안개4.jpg'],
  '히야신스': ['히야신스2.jpg'],
  '거베라': ['거베라3.jpg','거베라4.jpg'],
  '라넌큘러스': ['라넌큘러스1.png','라넌큘러스2.jpg','라넌큘러스3.jpg','라넌큘러스4.jpg','라넌큘러스5.jpg'],
  '작약': ['작약1.jpg','작약2.jpg','작약3.jpg','작약4.jpg'],
  '조팝나무': ['조팝나무1.jpg'],
  '코스모스': ['코스모스1.jpg'],
  '수선화': ['수선화1.jpg'],
  '미모사 플로리반다': ['미모사 플로리반다1.jpg','미모사 플로리반다2.jpg'],
};

const lines = csv.split('\n').filter(l => l.trim());
const rows = lines.slice(1).filter(l => l.trim()).map(l => {
  const c = l.split(',');
  const name = c[1] ? c[1].trim() : '';
  return {
    no: c[0],
    name,
    seasons: [c[5],c[6],c[7],c[8]],
    appImages: imageMap[name] || [],
  };
});

const hasCount = rows.filter(r => r.appImages.length > 0).length;
const noCount = rows.filter(r => r.appImages.length === 0).length;

const tableRows = rows.map(r => {
  const yn = r.appImages.length > 0 ? 'Y' : 'N';
  const seasonLabels = r.seasons.map((s,i) => s==='O' ? ['봄','여름','가을','겨울'][i] : null).filter(Boolean).join(' ');
  const imgCells = r.appImages.length > 0
    ? r.appImages.map(img => {
        const path = 'assets/images/flowers/' + img;
        const safePath = path.replace(/'/g, "\\'");
        const safeImg = img.replace(/'/g, "\\'");
        return '<img class="thumb" src="' + path + '" title="' + img + '" onclick="openModal(\'' + safePath + '\',\'' + safeImg + '\')" />';
      }).join('')
    : '<span class="no-img">없음</span>';
  return '<tr class="row-' + yn.toLowerCase() + '">'
    + '<td class="td-no">' + r.no + '</td>'
    + '<td class="td-name">' + r.name + '</td>'
    + '<td class="td-yn ' + (yn==='Y'?'yn-y':'yn-n') + '">' + yn + '</td>'
    + '<td class="td-count">' + (r.appImages.length > 0 ? r.appImages.length+'장' : '-') + '</td>'
    + '<td class="td-season">' + seasonLabels + '</td>'
    + '<td class="td-imgs">' + imgCells + '</td>'
    + '</tr>';
}).join('');

const html = `<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Flora Admin — 사진 목록</title>
<style>
  * { box-sizing: border-box; margin: 0; padding: 0; }
  body { font-family: 'Noto Sans KR', sans-serif; background: #FAF6F1; color: #6B5044; }
  header { background: #FAF6F1; border-bottom: 1px solid #E8DDD5; padding: 16px 28px; display: flex; align-items: center; gap: 14px; }
  header h1 { font-size: 17px; font-weight: 600; letter-spacing: 0.5px; }
  .stats { display: flex; gap: 8px; margin-left: auto; }
  .chip { padding: 5px 13px; border-radius: 999px; font-size: 12px; font-weight: 600; border: 1.5px solid; cursor: pointer; transition: all 0.15s; user-select: none; }
  .chip-all { border-color: #B8A89E; color: #8C6E63; }
  .chip-all.active { background: #B8A89E22; }
  .chip-y { border-color: #8A9E84; color: #8A9E84; }
  .chip-y.active { background: #8A9E8422; }
  .chip-n { border-color: #C9A090; color: #C9A090; }
  .chip-n.active { background: #C9A09022; }
  .toolbar { padding: 10px 28px; display: flex; align-items: center; gap: 12px; background: #FAF6F1; border-bottom: 1px solid #E8DDD5; }
  .search { border: 1px solid #E8DDD5; background: #F3ECE3; border-radius: 8px; padding: 7px 13px; font-size: 13px; color: #6B5044; outline: none; width: 240px; }
  .search:focus { border-color: #C9A090; }
  .result-count { font-size: 12px; color: #B8A89E; margin-left: auto; }
  .table-wrap { overflow-y: auto; height: calc(100vh - 108px); }
  table { width: 100%; border-collapse: collapse; }
  th { background: #F3ECE3; font-size: 10px; font-weight: 700; letter-spacing: 1.2px; color: #B8A89E; padding: 9px 14px; text-align: left; border-bottom: 1px solid #E8DDD5; position: sticky; top: 0; z-index: 1; }
  td { padding: 8px 14px; border-bottom: 1px solid #E8DDD5; font-size: 13px; vertical-align: middle; }
  tr:hover td { background: #F3ECE344; }
  .td-no { color: #B8A89E; font-size: 11px; width: 40px; }
  .td-name { font-weight: 500; width: 130px; white-space: nowrap; }
  .td-yn { font-weight: 800; font-size: 13px; width: 44px; text-align: center; }
  .yn-y { color: #8A9E84; }
  .yn-n { color: #C9A090; }
  .td-count { color: #8C6E63; width: 52px; text-align: center; }
  .td-season { color: #B8A89E; font-size: 11px; width: 110px; }
  .thumb {
    width: 52px; height: 52px; object-fit: cover;
    border-radius: 8px; margin: 2px 4px 2px 0;
    border: 1.5px solid #E8DDD5; cursor: pointer;
    transition: transform 0.15s, border-color 0.15s;
    vertical-align: middle;
  }
  .thumb:hover { transform: scale(1.1); border-color: #C9A090; box-shadow: 0 2px 8px rgba(201,160,144,0.3); }
  .no-img { color: #B8A89E; font-style: italic; font-size: 12px; }
  .row-n td { background: #FFF9F7; }

  .modal-overlay {
    display: none; position: fixed; inset: 0;
    background: rgba(0,0,0,0.75); z-index: 100;
    align-items: center; justify-content: center;
    cursor: pointer;
  }
  .modal-overlay.open { display: flex; }
  .modal-box {
    background: #FAF6F1; border-radius: 16px;
    padding: 20px; max-width: 88vw; max-height: 90vh;
    display: flex; flex-direction: column; align-items: center; gap: 10px;
    box-shadow: 0 12px 48px rgba(0,0,0,0.35); cursor: default;
  }
  .modal-img { max-width: 78vw; max-height: 74vh; object-fit: contain; border-radius: 10px; }
  .modal-name { font-size: 12px; color: #8C6E63; letter-spacing: 0.3px; }
  .modal-close {
    position: fixed; top: 18px; right: 24px;
    font-size: 32px; color: #fff; cursor: pointer;
    line-height: 1; user-select: none; opacity: 0.85;
  }
  .modal-close:hover { opacity: 1; }
</style>
</head>
<body>

<header>
  <h1>🌸 Flora Admin — 사진 목록</h1>
  <div class="stats">
    <span class="chip chip-all active" onclick="setFilter('all',this)">전체 ` + rows.length + `</span>
    <span class="chip chip-y" onclick="setFilter('y',this)">사진있음 ` + hasCount + `</span>
    <span class="chip chip-n" onclick="setFilter('n',this)">사진없음 ` + noCount + `</span>
  </div>
</header>

<div class="toolbar">
  <input class="search" type="text" placeholder="꽃 이름 검색..." oninput="doSearch(this.value)">
  <span class="result-count" id="count">` + rows.length + `개</span>
</div>

<div class="table-wrap">
  <table>
    <thead>
      <tr>
        <th>No</th><th>꽃 이름</th><th>사진</th><th>장수</th><th>시즌</th><th>앱 등록 파일 (썸네일)</th>
      </tr>
    </thead>
    <tbody id="tbody">` + tableRows + `</tbody>
  </table>
</div>

<div class="modal-overlay" id="modal" onclick="closeModal()">
  <span class="modal-close" onclick="closeModal()">×</span>
  <div class="modal-box" onclick="event.stopPropagation()">
    <img class="modal-img" id="modal-img" src="" alt="">
    <div class="modal-name" id="modal-name"></div>
  </div>
</div>

<script>
let currentFilter = 'all';
let currentSearch = '';

function setFilter(f, el) {
  currentFilter = f;
  document.querySelectorAll('.chip').forEach(c => c.classList.remove('active'));
  el.classList.add('active');
  applyFilter();
}
function doSearch(v) {
  currentSearch = v.trim();
  applyFilter();
}
function applyFilter() {
  const rows = document.querySelectorAll('#tbody tr');
  let count = 0;
  rows.forEach(tr => {
    const name = tr.querySelector('.td-name').textContent;
    const yn = tr.querySelector('.td-yn').textContent.trim();
    const matchSearch = !currentSearch || name.includes(currentSearch);
    const matchFilter = currentFilter === 'all'
      || (currentFilter === 'y' && yn === 'Y')
      || (currentFilter === 'n' && yn === 'N');
    tr.style.display = (matchSearch && matchFilter) ? '' : 'none';
    if (matchSearch && matchFilter) count++;
  });
  document.getElementById('count').textContent = count + '개';
}

function openModal(src, name) {
  document.getElementById('modal-img').src = src;
  document.getElementById('modal-name').textContent = name;
  document.getElementById('modal').classList.add('open');
}
function closeModal() {
  document.getElementById('modal').classList.remove('open');
  document.getElementById('modal-img').src = '';
}
document.addEventListener('keydown', e => { if (e.key === 'Escape') closeModal(); });
</script>
</body>
</html>`;

fs.writeFileSync('C:/Users/User/Documents/flora/admin.html', html, 'utf8');
console.log('admin.html 생성 완료 -', rows.length, '개 꽃');
