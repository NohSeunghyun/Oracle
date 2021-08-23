/****************
 ****<문자함수>****
 ****************
 ****************/

--1.대 소문자 변환함수

select 'Apple', 
upper('Apple') as 대문자로변환, 
lower('Apple') as 소문자로변환, 
initcap('aPpLe') as 첫글자만대문자
from dual;

--1).대 소문자 변환함수가 어떻게 활용되는지 살펴보기

--'scott'사원의 사번, 이름, 부서번호 출력

select eno, ename, dno
from employee
where ename='scott';--결과 안나옴.데이터상 이름이 대문자로 들어가있기때문

--활용방법--

select eno, ename, dno
from employee
where lower(ename)='scott';--비교대상인 사원이름을 모두 소문자로 변환하여 비교

select eno, ename, dno
from employee
where initcap(ename)='Scott';

--2.문자 길이를 반환하는 함수

--1).영문(무조건 1Byte)과 한글길이 구하기

--length():한글 1Byte로 인식

select length('Apple') as 영어1바이트, length('사과') as 한글1바이트
from dual;

--lengthB():한글 2Byte로 인식//'인코딩 방식'에 따라달라짐.(2~4Byte),UTF-8:3BYTE

select lengthB('Apple') as 영어1바이트, lengthB('사과') as 한글2바이트
from dual;

--3.문자 조작 함수
--1).concat(arguments=매개변수는 2개만):두 문자열을 하나의 문자열로 연결한다.//반드시 두 문자열만.ex)concat('A','B')는 가능, concat('A','B','C')는 안됨.

select 'Apple', '사과',
concat('Apple','=사과') as "함수사용",
'Apple' || '사과' || '맛있어' as "||사용"
from dual;

--2).substr(기존문자열,시작위치,추출할 개수):문자열의 일부만 추출한 문자열(=부분문자열)ex)substr ('가나다라',1,2)=>가나
--※오라클 인덱스(index) : 1,2,3.....(자바 배열 index : 0,1,2....)

select substr('apple mania',7,5) as mania만추출, substr('apple mania',-11,5) as apple만추출--시작위치가 음수일때 문자열의 마지막을 기준으로 거슬러 올라옴.
from dual;

--☆응용

select concat(substr ('으와씨아어',2,2),substr ('에이덥다크으',-4,2)) as 자바어렵다
from dual;

--★문제)이름이 N으로 끝나는 사원의 모든 정보 검색

--☆방법1)like연산자 사용

select *
from employee
where ename like '%N';

--☆방법2)substr 사용

select *
from employee
where substr(ename,-1,1)='N';

--★문제)1987년도에 입사한 사원의 모든 정보 검색

--☆방법1)비트윈연산자 사용

select *
from employee
where hiredate between '1987-01-01' and '1987-12-31';
--※(=where hiredate between '87-01-01' and '87-12-31';)//1900년도는 19생략가능 2000년도는 20넣어야함

--☆방법2)비교연산자 사용

select *
from employee
where hiredate>='1987/01/01' and hiredate<='1987/12/31';

--☆방법3)substr 사용

select *
from employee
where substr(hiredate,-8,2)='87';
--※(where substr(hiredate,1,2)='87';)//오라클 날짜 기본형식 'YY/MM/DD'이기 때문에 시작점이 첫번째,주의*)만약 형식을 모르고(yyyy/mm/dd로알고) 시작점을 3으로할경우.->where substr(hiredate,3,2)='87';은 결과값이 안나옴.

--★

select ename, salary
from employee--시작위치 : 끝에서 두번째부터 시작해서 2개 추출
where substr(salary,-2,2)='50';--salary는 number이지만 '문자로 자동형변환'(substr은 문자함수이기때문)

select ename, salary
from employee
where substr(to_char(salary),-1,1)='0';

--3).substrB(기존문자열,시작위치,추출할 바이트 수)

select substr('사과매니아',1,2) as 사과,
substrB('사과매니아',1,3) as 사,
substrB('사과매니아',4,3) as 과,--시작위치가 바이트수로 인식하기때문에 첫번째 자리의 3바이트인 '사'의 뒷자리 '과'의 시작위치는 4가된다.
substrB('사과매니아',1,6) as 사과,
substrB('사과매니아',7,9) as 매니아
from dual;

--4).instr(대상문자열,찾을 글자,시작위치,몇 번째 발견) : 문자열 내에 해당문자가 어느위치에 존재하는지
--※'시작위치','몇번째 발견'생략하면 둘 다 1로 간주한것과 결과가 같다.(=시작위치,발견 둘다 1일경우 생략가능)

select instr('apple','p') as 생략, instr('apple','p',1,1) as 생략안함, instrB('apple','p') as 바이트수구하기
from dual;

select instr('apple','p',2,2), instrB('apple','p')
from dual;
--※영어는 무조건 1Byte이기 때문에 같은값이나옴.그러나 한글은 인코딩방식에 따라 달라짐

select instr('바나나','나'), instr('바나나','나',1,1), instrB('바나나','나')
from dual;
--※instrB는 필요없음.

--'바나나'에서 '나'문자가 2번째 문자부터 시작해서 2번째발견되는 '나'를 찾아 index위치를 알려달라
--'바나나'에서 '나'문자가 2번째 문자부터 시작해서 2번째발견되는 '나'를 찾아 Byte시작위치를 알려달라(인코딩방식 UTF-8이므로 한글 한문자당3Byte. 바(1.2.3)나(4.5.6)나(7.8.9)
select instr('바나나','나',2,2), instrB('바나나','나',2,2)
from dual;

--★문제)이름의 세번째 글자가 'R'인 사원의 모든정보 검색

--☆방법1)like연산자 사용

select *
from employee
where ename like '__R%';

--☆방법2)substr 사용

select *
from employee
where substr(ename,3,1)='R';

--☆방법3)instr 사용

select *
from employee
where instr(ename,'R',3,1)=3;

--☆방법4)instrB 사용(영어기때문에 찾을 정수값(Byte)이 같음.고로 잘안씀),한글일경우 세번째문자를 찾으려면 =5;이나 인코딩방식이 UTF-8이면 3바이트씩 차지하기때문에 =7;

select *
from employee
where instrB(ename,'R',3,1)=3;

--5).LPAD(Left Padding)(반대:RPAD) : 칼럼이나 대상문자열을 명시된 자릿수에서 오른쪽에 나타내고 남은 왼쪽은 특정 기호로 채운다.

--활용방법--10자리를 마련후 salary:오른쪽, 남은 왼쪽자리들'*'로 채움

select Lpad(salary,10,'*')
from employee;

select Rpad(salary,10,'*')
from employee;

--6).1]LTRIM:문자열의 왼쪽의 공백제거
--.2]RTRIM:문자열의 오른쪽의 공백제거
--.3]TRIM:문자열의 양쪽의 공백제거

select '  사과매니아'||'입니다.  ',--||연결연산자(=concat)
Ltrim ('  사과매니아'||'입니다.  ') as 왼쪽공백제거,
Rtrim ('  사과매니아'||'입니다.  ') as 오른쪽공백제거,
Trim ('  사과매니아'||'입니다.  ') as 양쪽공백제거 
from dual;

/*
 * Trim(특정문자 from 컬럼이나 대상문자열)을 사용할경우.
 * 컬럼이나 대상문자열에서 특정문자가 첫번째 글자이거나 마지막 글자이면 잘라내고
 * 남은 문자열만 반환
 * ※제일 앞글자나 제일 뒷글자만 제거
 */

select Trim('사'from'사과매니아')
from dual;

/****************
 ****<숫자함수>****
 *****p114참조****
 ****************/

--1.ROUND함수(대상,화면에 표시되는 자릿수) : 반올림함수.단, 자릿수 생략하면 0으로 간주.((0=일의자리)까지 표시할때 소수점 첫째자리가 5보다크면 반올림된다.)
--													(=표시안되는 자릿수 반올림.)
--                                               ->백(=자릿수-2) 십(=자릿수-1) 일(=자릿수0) .(소수점) 일(1) 일(2) 일(3) ~~~

select 98.7654
from dual;--그대로출력

--활용방법--

select Round(7898.7654),--일의자리까지 표시(왼쪽기준으로 표시),소수첫째자릿수 반올림 후 표시
Round(7898.7654,2),--소수점2번째자리까지 표시(소수3번째자리가 5보다크면 반올림)
Round(7898.7654,-1)--십의자리까지 표시,일의자리 반올림하여 표시--남은자리는 0으로채움.
from dual;

--2.TRUNC(대상,화면에 표시되는 자릿수) : 화면에 표시되는 자릿수까지 남기고 버림 단,자릿수 생략하면 0으로 간주.

select Trunc(7898.7654,0),--일의자리까지 표시 후 남은 거 버림
Trunc(7898.7654,2),--소수점 2번째자리까지 표시 후 남은 거 버림
Trunc(7898.7654,-1)--십의자리까지 표시 후 남은거 버리고 남은자리(양수자리)0으로채움
from dual;

--3.MOD(수1,수2) : 수1을 수2로 나눈 나머지 (=자바의 %함수)

select Mod (10,3)
from dual;

select Mod (109876543210,37)
from dual;

--★문제)모든 사원의 급여를 500으로 나눈 나머지, 사원이름과 급여와 나머지 출력

select ename, salary, Mod(salary,500) as 나머지
from employee;

/****************
 ****<날짜함수>****
 ****p117참조*****
 ****************/

--1.SYSDATE : 시스템으로부터 현재 날짜와 시간을 가져옴

select sysdate
from dual;

--date + 수 = 날짜에서 수만큼 지난 날짜를 구할때 사용
--date - 수 = 날짜에서 수만큼 이전 날짜를 구할때 사용
--date - date = 일수를 구할때 사용.ex)5월7일-5월1일=6일
--date + 수/24 = 날짜에 시간을 더할때 사용

--활용방법--

select sysdate-1 as 어제,
sysdate as 오늘,
sysdate+1 as "내 일"
from dual;

--★문제1)사원들의 현재까지 근무일수 구하기

select ename, sysdate-hiredate as 근무일수
from employee;

--위 문제 근무일수를 소수점제외한 정수로 만들어 깔끔하게 표시하기.

--☆방법1)

select ename, round(sysdate-hiredate) as "반올림한 근무일수"
from employee;

--☆방법2)

select ename, trunc(sysdate-hiredate) as 근무일수
from employee;

--★문제2)입사일에서 월을 기준으로 잘라내기(월까지 표시,나머지는 버림)

select ename, hiredate, trunc(hiredate,'month') as "월별로 자르기"--'월'은 '1'일부터 시작이기 때문에 1이 최소값,시간은 모두 버려서 0이됨
from employee;

--2.MONTHS_BETWEEN(날짜1,날짜2) : 날짜1과 날짜2 사이의 개월수 구하기

--★문제1)사원들의 현재까지 근무월수 구하기

select ename, sysdate, hiredate,
months_between(sysdate,hiredate) as "근무월수 양수",
months_between(hiredate,sysdate) as "근무월수 음수"
from employee;

--위 문제 근무월수를 소수점제외한 정수로 만들어 깔끔하게 표시하기.

--☆방법1)

select ename, sysdate, hiredate,
round(months_between(sysdate,hiredate)) as "반올림한 근무월수"
from employee;

--☆방법2)

select ename, sysdate, hiredate,
trunc(months_between(sysdate,hiredate)) as 근무월수
from employee;

--3.ADD_MONTHS(날짜,더할 개월수) : 특정 개월수를 더한 날짜

select ename, hiredate, add_monthS(hiredate,3) as "+3개월", add_monthS(hiredate,-3) as "-3개월"
from employee;

--4.NEXT_DAY(날짜,'수요일') : 해당 날짜를 기준으로 최초로 도래하는 '수요일'에 해당하는 날짜 구하기

select sysdate, next_day(sysdate,'수요일'),
next_day(sysdate,4)--일요일 1,월요일 2,.....토요일 7
from dual;

--5.LAST_DAY(날짜) : 해당 날짜가 속한 달의 마지막 날짜 구하기(대부분 달의 경우 마지막날이 정해져 있지만 2월달은 마지막날이 28일 또는 29일이 될수있으므로 2월에 사용하면 효율적)

select sysdate, last_day(sysdate)
from dual;

--★문제)사원들의 입사 월의 마지막날(일) 구하기

select ename, hiredate, last_day(hiredate)
from employee;

--이용)지정날짜의 마지막날구하기

select last_day('2021/12/01')
from dual;

--6. 날짜 및 시간차이 계산방법
--날짜 차이 : 종료일자(yyyy-mm-dd)-시작일자(yyyy-mm-dd)
--시간 차이 : 종료일시(yyyy-mm-dd hh24:mi:ss)-시작일시(yyyy-mm-dd hh:mi:ss) *24
--분 차이 : 종료일시(yyyy-mm-dd hh24:mi:ss)-시작일시(yyyy-mm-dd hh:mi:ss) *24 *60
--초 차이 : 종료일시(yyyy-mm-dd hh24:mi:ss)-시작일시(yyyy-mm-dd hh:mi:ss) *24 *60 *60

--★'종료일자-시작일자'빼면 차이값이 '일 기준'의 수치값으로 반환

--날짜 차이 계산
select abs(to_date('2015-05-08', 'yyyy-mm-dd') - to_date('2021-05-01', 'yyyy-mm-dd'))--abs:절대값
from dual;

--시간 차이 계산
select (to_date('15', 'hh24') - to_date('13', 'hh24'))*24 --*24 생략시 '1이 하루'를 기준으로 0.08일 차이
from dual;--하루가 24시간이니 0.08*24하면 시간이 나옴. 2시간차이 ★만약 소수점이 나오면 round함수를 사용해 보기좋게 처리
--시간 차이 계산 round 사용해보기 - 위 쿼리를 사용하면 2로 딱 떨어지므로 초까지 표시하여 소수점표기
select round((to_date('15:00:58', 'hh24:mi:ss') - to_date('13:00:40', 'hh24:mi:ss'))*24,2)
from dual;

--분차이 계산
select (to_date('15:43', 'hh24:mi') - to_date('13:18', 'hh24:mi')) *24 *60
from dual;--145분 차이

--초 차이 계산
select (to_date('15:00:58', 'hh24:mi:ss') - to_date('13:00:40', 'hh24:mi:ss'))*24 *60 *60
from dual;--7218초 차이

/****************
 ***<형변환 함수>***
 ****p124참조*****
 ****************/

/*
 *     <---to_number()--------------to_char()-----
 *       -to_char()->               <- to_char()-
 * [수]                   [문자]                     [날짜]
 *      <-to_number()-              -to_date() ->
 *     -------------------to_date()-------------->
 */

/*
 * 1.to_char():('수'나 '날짜', 형식)을 문자로 변환
 * ☆'날짜'와 관련된 형식
 * 1)YYYY : 년도 4자리, YY : 년도 2자리
 * 2)MM : 월 2자리 수로, MON : 월을 '알파벳'으로
 * 3)DD : 일 2자리 수로, D : 사용안함
 * 단, DAY : 요일표시 예)월요일
 * ☆'시간'과 관련된 형식
 * 1)AM 또는 PM : 오전 AM, 오후 PM 시각표시
 * (=A.M. 또는 P.M. : 오전 A.M. 오후 P.M.)
 * 2)HH 또는 HH12 : 시간((AM,PM)1~12시로표현)
 * 3)HH24 : 24시간으로 표현(0~23시로 표현)
 * 4)MI : 분
 * 5)SS : 초
 */

--활용방법--

select ename, hiredate,
to_char(hiredate,'yy-mm')as "입사 년월",
to_char(hiredate,'yyyy/mm/dd day dd') as "입사 년월일,요일,일",
to_char(sysdate,'yyyy/mm/dd day dd,am')
from employee;

select to_char(sysdate,'yyyy/mon/day')
from dual;

select --AM=PM=A.M.=P.M 결과는 12시이전은 '오전',이후는 '오후'
to_char(sysdate,'yyyy/mm/dd day dy, PM HH'),
to_char(sysdate,'yyyy/mm/dd day dy, A.M. HH'),
to_char(sysdate,'yyyy/mm/dd day dy, AM HH24:MI:SS')
from dual;

/*
 * <'숫자'와 관련된 형식>
 * 0:자릿수를 나타내며 자릿수가 맞지 않을 경우 '0으로 채움'
 * 9:자릿수를 나타내며 자릿수가 맞지 않을 경우 '채우지 않음'
 * L:각 지역별 통화기호를 앞에 표시
 * .:소수점 표시
 * ,:천 단위 자리 표시 
 * 
 */

--활용방법--

select ename, salary,
to_char(salary,'L000,000,000'),
to_char(salary,'L999,999,999'),
to_char(salary,'L000,000,000.00'),
to_char(salary,'L999,999,999.99'),
to_char(123.666,'L000,000,000.00'),
to_char(123.666,'L999,999,999.99')
from employee;

--10진'수'를 16진수'문자'로 변환

select to_char(10,'X'),--10진수(10)->16진수(A(수))->'A'(16진수문자:'0'~'F')로 변환//'X'(=Hex(a)(16진수를의미))
--						//소문자'x'대문자와'X'의 차이는 출력하는 문자.소문자로 적으면 소문자, 대문자로 적으면 대문자가 출력됨.
to_char(255,'X'),--'##'은 16진수의 자릿수가 없기때문에 나옴(자릿수부족). 이 경우 자릿수를 올려줌.(아래수식참고)
to_char(255,'xx')--자릿수를 올려 표현.ff가나옴
from dual;

--'문자'나 16진수'문자'->10진'수'로 변환

select to_number('A','X'),
to_number('FF','xx')--수로 변환하는 것이기때문에 대,소문자 구분없다.
from dual;

/*
 * 대부분 사용하는 to_number('문자')의 용도는
 * 단순히 10진수 형태의 문자를 숫자로 변환하는데 사용됨
 */

select to_number('0123'),--java에서 "0123"과  123다름,"0123"은 " '0' '1' '2' '3' "으로 이루어진 문자(수), 123은 정수
to_number('12.34')--'1''2'.'3''4'
from dual;

--2.to_date():('수'나 '문자', 형식)을 날짜형으로 변환

select ename, hiredate
from employee
where hiredate=19810220;--데이터 타입이 맞지않아 검색 불가능(오류)

--to_date('수'나'문자', 형식) 함수 이용하여 수를 날짜형으로 변환

select ename, hiredate
from employee
where hiredate=to_date(19810220,'YYYYMMDD');--★주의:반드시 yyyy 4자리년도 모두 적어줘야함.

select ename, hiredate
from employee
where hiredate=to_date(810220,'YYMMDD');--형식 안맞출경우 결과 출력 안됨.

select ename, hiredate
from employee
where hiredate=to_date('19810220','YYYYMMDD');--문자타입이 날짜형으로 변환

/*
 * 3.to_number()
 */

select 100000-50000
from dual;

select 100,000-50,000
from dual;--★주의: 천단위 콤마(,)가 있으면 '100' '100-50' '000' 결과=> '100' '-50' '0'로 됨. 

select '100000'-'50000'
from dual;--☆문자('수'로만 이루어진 문자)이지만 수로 자동 형변환되어 연산.단,콤마가 있으면 자동현변한 안됨.수만 있어야함ex)'100,000'-'50,000'은 안됨.

select to_number('100,000','999,999')-to_number('50,000','999,999')--★주의:문자에 천단위 구분쉼표 찍고 형식에도 천단위 구분쉼표 찍어야함.
from dual;

select to_number('100000')-to_number('50000')--문자이지만 수로 자동 형변환되어 연산,to_number()사용할 필요없다.
--											      단,자동형변환 안될시 사용해야함.(('수')일 경우에만 자동형변환 되어 연산)
from dual;

/****************
 ****<일반 함수>****
 ****p130참조*****
 ****************/

/*
 * ★null 처리하는 함수들
 * 1.NVL(값1,값2) : 값1이 null이 아니면 값1, 값1이 null이면 값2
 * --★주의 : 반드시 값1과 값2는 데이터 타입이 일치하여야 함 ex)commission의 타입은 number이므로 '수'가 들어가야함
 *    예)NVL(hiredate, '2021/05/20')--hiredate가 null값이 아니면 그대로 사용하고 null값이면 '2021/05/20'으로 출력.
 *    에)NVL(job, 'MANAGER')--job이 null값이 아니면 그대로 사용, null값이면 'MANAGER'로 출력
 * 2.NVL2(값1, 값1이 null이 아니면 값2, 값1이 null이면 값3)
 * 3.NULLIF(값1, 값2) : 두 값이 같으면 null,다르면 '첫번째 값1' 출력
 */

--커미션이 있으면 커미션을 포함한 연봉을 구하고, 커미션이 없으면 커미션을 제외한 연봉을 구하여라.(아래 3개수식 같은결과.)

select ename, salary, commission,salary*12+commission
from employee;--null이 있어서 연봉 계산 안됨.

--1)

select ename, salary, commission, salary*12+nvl(commission, 0) as "연봉"--커미션이 null이면 0으로바꿔 연산할수있게 바꿈.
--																		이걸 사용안하면 커미션에null이있어서 연산결과가 null로나옴.
from employee;

--2)

select ename, salary, commission, salary*12+nvl2(commission, commission, 0) as "연봉"--커미션이 null이 아니면 커미션값 그대로 연산
from employee;

--3)

select ename, salary, commission, nvl2(commission, salary*12+commission, salary*12) as "연봉"--커미션이 null이 아니면 
--																		월급*12+커미션을 하여 연봉을 구하고, null이면 월급*12를 하여 연봉을 구하여라
from employee;

---------------------------------------------------------------------------------------------------------------

select ename, salary, commission, salary*12+nvl2(commission, 2000, 0) as "연봉"--커미션이 null이 아니면 모두 2000으로 바꿔
--														(데이터상의 값을 바꾸는것은 아님) 연산, 커미션이 null인사람은 0으로 표시해 연산가능하게 바꿈.
from employee;

select NULLif('a','a'), NULLif('a','b')
from dual;

--4.COALESCE(인수, 인수, 인수, ......) ※매개변수=인자=인수

/*
 * ★문제★
 * 사원테이블에서 커미션이 null이 아니면 커미션 출력,
 * 커미션이 null이고 급여(salary)가 null이 아니면 급여를 출력,
 * 커미션과 급여 모두 null이면 0출력
 */

select ename, salary, commission,
coalesce(commission, salary, 0)
from employee;--★ null과 0은 다름. 0은 연산가능, null은 알수없음.

--★★5.DECODE() : 자바의 switch~case와 비슷.많이 사용하는 함수. ★ 문자->코드 : 인코딩, 코드->문자 : 디코딩

select ename, dno,
decode(dno, 10, 'A',
            20, 'B',
            30, 'C',
            40, 'D',
            '기본') as "Dname"-->부서번호 10을 A,20을 B,30을 C,40을 D,그 외의것은 기본 으로 바꿔 출력.
from employee;

select ename, dno,
decode(dno, 10, 'A',
            20, 'B',
            30, 'C',
            40, 'D') as "Dname"-->※그 외의것에 해당사항없으면 생략가능.
from employee;

select ename, dno,
decode(dno, 10, 'A',
            20, 'B',
            30, 'C',
            40, 'D',
            '기본') as "Dname"
from employee
order by dno;--※asc(오름차순(위에서 작은것부터 아래로 큰것))생략가능, desc(내림차순 생략불가능)

--6.CASE~END : 자바의 if else if ~ else와 비슷. DECODE()함수에 사용하지 못하는 비교연산자(> = <)를 사용할때 사용.

select ename, dno,
CASE when dno=10 then 'A'--★주의 : ,입력하면 안됨.(CASE~END문 사이)
     when dno=20 then 'B'--자바의 같다 : ==, SQL의 같다 : =
     when dno=30 then 'C'
     when dno=40 then 'D'
     ELSE '기본'
END
as "Dname"
from employee
order by dno;

/*
 * ★좀 더 알아보기★
 * ★자동형변환
 */

select '100'+200--'100'은 수로만 이루어진 문자라 자동형변환되어 연산됨.to_number()함수 사용 안해도됨.
from dual;--'100'문자->100 정수로 자동형변환.=>100+200=300

--★문자 연결 함수(concat)

select concat('100',200), 100 || '200' || 300 || '400'--concat과같이 자동형변환되어 사용가능, concat은 (,)두개밖에 연결못하나,
--														 ||함수를 사용하면 계속 연결 가능.
from dual;--200 (정)수->'200'문자로 자동형변환.=>'100'+'200'='100200'

select ename
from employee
where eno=7369;--비교연산자는 타입이 똑같아야 연산가능하나, 문자인'7369'가 정수인 7369로 자동 형변환되어 비교연산. 
                 --★(타입=)number(수):정수, (타입=)number(수,수):실수.뒷 수는 소수점 몇번째까지 인가 표시 

--★CAST() : 데이터 형식 변환함수

--평균월급 구하기. ★평균 구하는 함수 : AVG

select avg(salary) as "평균 월급"
from employee;

--1-1.실수로 나온 결과를 정수로 보기

select cast(avg(salary) as number(6)) as "평균 월급"
from employee;

--TRUNC 함수를 사용하여 실수를 정수로 만들기

select trunc(avg(salary), 0) as "평균 월급"--, 0)생략가능
from employee;

--1-2.실수로 나온 결과를 실수로 보기 : 전체 자릿수 6자리 중 소수점 이하 2자리까지 표시

select cast(avg(salary) as number(6,2)) as "평균 월급"
from employee;

--ROUND함수 사용하여 소수점 2자리까지 표시

select round(avg(salary),2) as "평균 월급"
from employee;

--2.다양한 구분자를 날짜 형식으로 변경 하기

select cast('2021$05$20' as date)
from dual;

select cast('20210520' as date)
from dual;

select cast('2021!05^20' as date)
from dual;

select cast('2021=05=20' as date)
from dual;

--※퀴리의 결과를 보기 좋도록 처리할 때 사용

select CAST(nvl(salary,0) as char(7)) || '+' || cast(nvl(commission,0) AS CHAR(7)) || '=' as "월급+커미션",
nvl(salary,0) + nvl(commission,0) as "총합"
from employee;

--★★rank 함수 : 순위 메기는 함수
--☆연봉 순위 메기기
select ename, salary,
rank() over(order by salary desc) as "급여 순위"
from employee;

--★만약 중복된 급여로 인해 순위가 중복되어 중복된 순위 다음 순위가 다른 순위일 경우 ex)1 2 3 3 3 6 7 이런경우
select ename, salary,
dense_rank() over(order by salary desc) as "급여 순위"
from employee;--ex)1 2 3 3 3 6 7 -> 1 2 3 3 3 4 5 로 변경

--★★만약 중복된 급여로 인해 순위가 중복된것을 정상적으로 순위를 메기려면
--★★방법1 정렬조건을 하나 더 추가한다
select ename, salary,
dense_rank() over(order by salary desc, commission desc) as "급여 순위"
from employee;

--★★방법2 row_number 사용
select ename, salary,
row_number() over(order by salary desc) as "급여 순위"
from employee;

--그룹별 순위 메기기 - partition by 그룹기준컬럼 사용
select dno, ename, salary, commission,
rank() over(partition by dno order by salary desc, commission desc) as "급여 순위"
from employee;

--그룹별 최소급여, 최대급여 구하기
--keep()함수와 first, last 키워드를 활용하면 그룹내 최소급여, 최대급여을 쉽게 구할 수 있다.
--★dense_rank함수만 사용가능
--방법1.keep함수사용
select dno, ename, salary,
min(salary) keep(dense_rank first order by salary) over(partition by dno) as "최소 급여",
max(salary) keep(dense_rank last order by salary) over(partition by dno) as "최대 급여"
from employee;

--문제에 의거한 딱 그룹별 최소급여,최대급여만 구하고자 한다면 아래 쿼리문
select distinct dno,
min(salary) keep(dense_rank first order by salary) over(partition by dno) as "최소 급여",
max(salary) keep(dense_rank last order by salary) over(partition by dno) as "최대 급여"
from employee
order by dno;

--★위 문제 심화) 각 부서에 최소급여,최대급여에 해당하는 사원만 출력해보기 = 각 부서당 최소급여,최대급여를 가진 단 두명씩만 출력하기
--방법1-1.그룹함수 사용 후 서브쿼리 사용 후 union all 사용
--[1]각 부서별 최소급여
select dno, min(salary)
from employee
group by dno
order by dno;

--[2]각 부서별 최대급여
select dno, max(salary)
from employee
group by dno
order by dno;

--[3]최소급여을 구하고자 하는 정보출력을 위해 서브쿼리 결합
select dno, ename, salary
from employee
where (dno, salary) in (select dno, min(salary)
				   		from employee
				   		group by dno)
order by dno;
				   		
--[4]최대급여을 구하고자 하는 정보 출력을 위해 서브쿼리 결합
select dno, ename, salary
from employee
where (dno, salary) in (select dno, max(salary)
				   		from employee
				   		group by dno)
order by dno;
				   		
--[5]위 결과를 바탕으로 union all로 합치기
select dno, ename, salary
from employee
where (dno, salary) in (select dno, min(salary)
				   		from employee
				   		group by dno)
union all
select dno, ename, salary
from employee
where (dno, salary) in (select dno, max(salary)
				   		from employee
				   		group by dno)
order by dno, salary desc;

--방법1-2.keep함수 사용 후 서브쿼리 사용 후 union all 사용
--[1]각 부서별 최소급여
select distinct dno,
min(salary) keep(dense_rank first order by salary) over(partition by dno) as "최소 급여"
from employee
order by dno;

--[2]각 부서별 최대급여
select distinct dno,
max(salary) keep(dense_rank last order by salary) over(partition by dno) as "최대 급여"
from employee
order by dno;

--[3]최소급여을 구하고자 하는 정보출력을 위해 서브쿼리 결합
select dno, ename, salary, 
min(salary) keep(dense_rank first order by salary) over(partition by dno) as "최소 급여"
from employee
where (dno, salary) in (select distinct dno, min(salary) keep(dense_rank first order by salary) over(partition by dno)
				 		from employee);

--[4]최대급여을 구하고자 하는 정보 출력을 위해 서브쿼리 결합
select dno, ename, salary, 
max(salary) keep(dense_rank last order by salary) over(partition by dno) as "최대 급여"
from employee
where (dno, salary) in (select distinct dno, max(salary) keep(dense_rank last order by salary) over(partition by dno)
				 		from employee);
				 		
--[5]위 결과를 바탕으로 union all로 합치기
select dno, ename, salary, 
min(salary) keep(dense_rank first order by salary) over(partition by dno) as "부서의 최소/최대 급여"
from employee
where (dno, salary) in (select distinct dno, min(salary) keep(dense_rank first order by salary) over(partition by dno)
				 		from employee)
union all
select dno, ename, salary, 
max(salary) keep(dense_rank last order by salary) over(partition by dno) as "부서의 최소/최대 급여"
from employee
where (dno, salary) in (select distinct dno, max(salary) keep(dense_rank last order by salary) over(partition by dno)
				 		from employee)
order by dno, salary;

--방법2.잘못된 것
select dno, ename, salary,
min(salary) as "최소급여",
max(salary) as "최대급여"
from employee
group by dno, ename, salary
order by 1;--그룹별 최소급여, 최대급여가 아닌 각 사원의 최소급여, 최대급여을 구하게되어 최소급여, 최대급여가 자기 급여임;

/************************
 ***4장-다양한함수혼자해보기 **
 ************************/

--1.SUBSTR 함수를 사용하여 사원들의 입사한 년도와 입사한 달만 출력하시오.

select ename, substr (hiredate,1,2) as 년도, substr (hiredate,4,2) as 월
from employee;

--2.SUBSTR 함수를 사용하여 4월에 입사한 사원을 출력하시오.

select ename, hiredate
from employee
where substr (hiredate,4,2)='04';

--3.MOD 함수를 사용하여 사원번호가 짝수인 사람만 출력하시오.

select *
from employee
where mod(eno,2)=0;

--4.입사일은 연도는 2자리(YY), 월은 숫자()로 표시하고 요일은 약어(DY)로 지정하여 출력하시오.

select ename, hiredate,
to_char(hiredate,'YY/MON/DY')
from employee;

/*
 * 5.올해 며칠이 지났는지 출력하시오.
 * 현재날짜에서 올해 1월 1일을 뺀 결과를 출력하고 TO_DATE 함수를 사용하여
 * 데이터 형을 일치시키시오.
 */

select trunc(sysdate-to_date('2021/01/01','YYYY/MM/DD')) as 일수--★주의 : 문자'2021/01/01'<<-반드시''사용.or 수 20210101로 사용해도됨.
from dual;

--6.사원들의 상관 사번을 출력하되 상관이 없는 사원에 대해서는 NULL값 대신 0으로 출력하시오.

select eno, ename, nvl(manager,0) as "상관사번"--nvl2(manager,manager,0)도 사용가능.--상관번호 대신 이름으로 바꾸는 법 해보기.
from employee;

/*
 * DECODE 함수로 직급에 따라 급여를 인상하시오.
 * 직급이 'ANALYST'인 사원은 200
 *      'SALESMAN'인 사원은 180
 *      'MANAGER'인 사원은 180
 *      'CLERK'인 사원은 100을 인상하시오.
 */

select eno, ename, job, salary,
decode(job,'ANALYST',salary+200,
'SALESMAN',salary+180,
'MANAGER',salary+180,
'CLERK',salary+100,
salary) as "인상된 급여"
from employee;

/************************************************************************************************************************************/