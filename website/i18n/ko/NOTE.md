# 한국어 번역작업 (Korean Translation)

## 작업하기

- [Initialize the i18n folder](https://docusaurus.io/docs/i18n/git#initialize-the-i18n-folder)

```shell
# 처음에 한국어 i18n 생성하기 (docusaurus)
yarn run write-translations --locale ko

# website/i18n/ko/ 폴더에서 문서수정
# 한국어 문서 실행하고, 최초실행시 import 폴더 구조가 안맞는 것 맞추기
yarn run dev --locale ko

# 빌드
yarn run build --locale ko
# 빌드된 파일 확인
yarn run serve

# 작업후 문서의 생성코드 업데이트
dart run build_runner watch --delete-conflicting-outputs 
```
